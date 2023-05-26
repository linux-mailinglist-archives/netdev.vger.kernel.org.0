Return-Path: <netdev+bounces-5815-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF4B0712E2E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 22:37:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42F761C21113
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 20:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8DB2773D;
	Fri, 26 May 2023 20:37:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2017C2CA9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 20:37:36 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F533114
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:37:35 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-51480d3e161so709219a12.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685133453; x=1687725453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eKtb5pF799Vf0zYkpYw5rmcT4zTxO2bOf/EKOzgAhcY=;
        b=BOjN3c0mNuFLGaA8ph4Pbmp3phDLkFpEmpt7ob4g0VlG6IQxJqBcj42Dej6W8LeWYR
         ql3RVtPvRxVf9j9PQKQl4EQewjdi4lBNwKNHhGhgUYmGJWUfOpULkOnvq2WUbMUju49c
         XvBg68bgZ9/uoJaW3x1ZF5yJPaw1gS1utGf6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685133453; x=1687725453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eKtb5pF799Vf0zYkpYw5rmcT4zTxO2bOf/EKOzgAhcY=;
        b=L9SA7PmoeYGsM2RJtYl2iRogxV+HwiSFN5F2LixXnXACodHSsuQ5MGLHOvqPyvw3jC
         pmp41WnD2F2+MTsAnWiQS8DBWpgnVejn6DKtnghcJMGDjGql+7QCHh7IVLNEIq21kjGA
         b7xXGPWfiYafNTYzmwGC/uCCWYCbotknFVpvurPCsgxU8k2sF7JNYPa/t5jGX6Hl44VZ
         HoDUpkEGeCUP6pM/kf2ozFesbJ/8zq6SErfaBgrYJdskGp/CvlyzvrR2C7+l1tTpmaha
         gUd2Nzcd3JaKH0leQB9g7YhIbK+SasGRngMgAt1Iknq7jfCC54jrwHY+1uk6oOZec6Av
         Xzdg==
X-Gm-Message-State: AC+VfDwQwH6MnmRuqh9lJ3FM9UzxgRPP2z4KJ1XsTQ6L0bj+SMpsngJ5
	CCK0cy5IwvEmG0PUI8g4n90sOYW5i8H+Ikg63Z0iG5f6
X-Google-Smtp-Source: ACHHUZ5pYAVJMoBO7yk6amqhxvqNba5ZfSjyxVZ3v1GUqaTaromOwZnTc+9IGrAJ6vLbjJula+gILw==
X-Received: by 2002:a17:907:36cb:b0:970:bef:4393 with SMTP id bj11-20020a17090736cb00b009700bef4393mr3816449ejc.7.1685133453507;
        Fri, 26 May 2023 13:37:33 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id q15-20020a1709066b0f00b0096b4c3489e6sm2583751ejr.177.2023.05.26.13.37.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 13:37:33 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5147f7d045bso1000889a12.2
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:37:32 -0700 (PDT)
X-Received: by 2002:a17:907:3f92:b0:94e:dd30:54b5 with SMTP id
 hr18-20020a1709073f9200b0094edd3054b5mr3679061ejc.6.1685133452593; Fri, 26
 May 2023 13:37:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89iKUbyrJ=r2+_kK+sb2ZSSHifFZ7QkPLDpAtkJ8v4WUumA@mail.gmail.com>
 <CAHk-=whqNMUPbjCyMjyxfH_5-Xass=DrMkPT5ZTJbFrtU=qDEQ@mail.gmail.com>
 <CANn89i+bExb_P6A9ROmwqNgGdO5o8wawVZ5r3MHnz0qfhxvTtA@mail.gmail.com>
 <CAHk-=wig6VizZHtRznz7uAWa-hHWjrCNANZ9B+1G=aTWPiVH4g@mail.gmail.com>
 <CAHk-=whkci5ck5Him8Lx5ECKHEtj=bipYmOCGe8DWrrp8uDq5g@mail.gmail.com>
 <CAHk-=whtDupvWtj_ow11wU4_u=KvifTqno=5mW1VofyehjdVRA@mail.gmail.com>
 <CANn89i+u8jvfSQAQ=_JY0be56deJNhKgDWbqpDAvfm-i34qX9A@mail.gmail.com>
 <CAHk-=wh16fVwO2yZ4Fx0kyRHsNDhGddzNxfQQz2+x08=CPvk_Q@mail.gmail.com>
 <CANn89iJ3=OiZEABRQQLL6z+J-Wy8AvTJz6NPLQDOtzREiiYb4Q@mail.gmail.com> <CAHk-=whZ23EHnBG4ox9QpHFDeiCSrA2H1wrYrfyg3KP=zK5Sog@mail.gmail.com>
In-Reply-To: <CAHk-=whZ23EHnBG4ox9QpHFDeiCSrA2H1wrYrfyg3KP=zK5Sog@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 May 2023 13:37:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wibWdTp-kdCKc-F3d4aVcHO40qqoxoATG+KhVivYE0TqA@mail.gmail.com>
Message-ID: <CAHk-=wibWdTp-kdCKc-F3d4aVcHO40qqoxoATG+KhVivYE0TqA@mail.gmail.com>
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

On Fri, May 26, 2023 at 11:33=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Anyway, I guess *this* avoids all issues. It creates an extra jump to
> a jump for the case where the CPU doesn't have ERMS, but I guess we
> don't really care about those CPUs anyway.

Well, I'm obviously wrong, because my very own CPU (AMD Zen 2) doesn't do E=
RMS.

But the extra 'jmp' doesn't seem to appreciably matter, so I guess I
don't care. It does show up in profiles, but only barely.

I've committed and pushed out the fix.

               Linus

