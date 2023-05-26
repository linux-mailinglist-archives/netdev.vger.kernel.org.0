Return-Path: <netdev+bounces-5772-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9801E712B4A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F6B71C2099D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD32E28C05;
	Fri, 26 May 2023 17:00:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28CB271F6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:00:43 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CBB194
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:00:42 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-5147e40bbbbso994945a12.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685120440; x=1687712440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOgQ0laylSsSXUxakhP+bdUPB6O0yALSW2XM6n3Lc/w=;
        b=Zwu61xRIRJFWalIXgc6ah6dDtHLl6uw9nT0y8JMsg/9atXtDwKypUlsAWirjZFpckT
         V5R35cPlg5R1+qqxp4xKUTZI5SleaQCR7CrEraXIUpa/vor4Ytt3AR8/JWmZcJaVk6B7
         GuypUqsGdlOfTjzTZZwv//eY0hikDRIt5sWc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685120440; x=1687712440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HOgQ0laylSsSXUxakhP+bdUPB6O0yALSW2XM6n3Lc/w=;
        b=IJFTnhTBomXf8KvBUT5LLJ0SGhf0eCz/Fp7wPdIm9Oapq1rzVI+4iBTiwiUG1xAauV
         uGbMkYZ5kPy4CAd4O3z0FXq67uHgu8K4ske7f2mHhr30gmnKT7o8r0BhybDprib12I1i
         dgYo8F43xpshxXu8cW3bKQ2n90HKwY1qinYxiwAafMxwrwu6qH6YhCQLS7+tYXcFFbEq
         wCfc4taP+9HKp7uEwh4x/cCeH3H4EN7ecxMdEBEQOYSNtrYhEvaDENfJu4yNT4QOcqHh
         QvmV5ogelKlinr/UCVwnN+BkYZ/RuCsbUIjVQdW8NXXM129BNuzh8kWwtwEsjFOljWhv
         /o+g==
X-Gm-Message-State: AC+VfDzilWJ8PYvbpmfYFVB1gc4lcKlE0QjymNXDd8PbBn/BuFTK8JJj
	kWGimu/698EjfkiqCpnNvG8zGVS8WYqBe0XsU9jgtAE8
X-Google-Smtp-Source: ACHHUZ7QaOqfRBDNxcTw8PCxYa5jN7SEXIqWS2YhvSSHY4aAwpqs1Ab/Ay36sz+0Ad9n0Z24G1swQw==
X-Received: by 2002:a17:907:9308:b0:96f:dd14:f749 with SMTP id bu8-20020a170907930800b0096fdd14f749mr2708160ejc.23.1685120440637;
        Fri, 26 May 2023 10:00:40 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id q9-20020a170906940900b009545230e682sm2366958ejx.91.2023.05.26.10.00.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 10:00:39 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-514859f3ffbso327391a12.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:00:39 -0700 (PDT)
X-Received: by 2002:a17:907:94c9:b0:968:db2f:383 with SMTP id
 dn9-20020a17090794c900b00968db2f0383mr2744712ejc.53.1685120439249; Fri, 26
 May 2023 10:00:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89iKUbyrJ=r2+_kK+sb2ZSSHifFZ7QkPLDpAtkJ8v4WUumA@mail.gmail.com>
 <CAHk-=whqNMUPbjCyMjyxfH_5-Xass=DrMkPT5ZTJbFrtU=qDEQ@mail.gmail.com>
 <CANn89i+bExb_P6A9ROmwqNgGdO5o8wawVZ5r3MHnz0qfhxvTtA@mail.gmail.com> <CAHk-=wig6VizZHtRznz7uAWa-hHWjrCNANZ9B+1G=aTWPiVH4g@mail.gmail.com>
In-Reply-To: <CAHk-=wig6VizZHtRznz7uAWa-hHWjrCNANZ9B+1G=aTWPiVH4g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 May 2023 10:00:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=whkci5ck5Him8Lx5ECKHEtj=bipYmOCGe8DWrrp8uDq5g@mail.gmail.com>
Message-ID: <CAHk-=whkci5ck5Him8Lx5ECKHEtj=bipYmOCGe8DWrrp8uDq5g@mail.gmail.com>
Subject: Re: x86 copy performance regression
To: Eric Dumazet <edumazet@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 9:56=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Ahh, I tested it in an allmodconfig build, but only building that one
> file, and not trying to link it. And gas was apparent;y perfectly
> happy just leaving that undefined feature as a relocation.

Oh, never mind. Even with that fixed, objtool is very unhappy about my
hack, because it knows about short jumps, and despite me encoding it
as a sequence of bytes, objtool will just decode it anyway and say
"that's not right".

Grr, I tried so hard to get the exact asm I wanted, but our
sanity-checking catches my cleverness and stops me in my tracks.

Let me go look at it some more. I *really* didn't want to make the
code worse for ERSM.

             Linus

