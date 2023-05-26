Return-Path: <netdev+bounces-5788-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46D6A712BF2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:41:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1535281931
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C0A290E0;
	Fri, 26 May 2023 17:41:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D912828C3B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:41:09 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE50CE6B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:40:58 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-96f8d485ef3so159880166b.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685122857; x=1687714857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pSaK6G2VVNNpdqq+Y56+DOhWYZRR11ay4bAj5o0qKr0=;
        b=czdUTFvhPB0C6gRIDGLrtXntLLjn8RAMUDHXPG5nwslO2jPFmWYNzO+F0MNWObI7tc
         IdwG9omkM1l+EucKUrK4tisIoPYa/TVw8r+Ho1fMGy0DrxUz2LYhusjUAl/dG6r2MfJq
         dChQOAoZqKl4SeoRM/4MPmdihEA4hptwF3e/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685122857; x=1687714857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pSaK6G2VVNNpdqq+Y56+DOhWYZRR11ay4bAj5o0qKr0=;
        b=ayrc9OksG0osrawxbVHaXr/U59Nd2Hz7xLgodPlFcpjn5HRaDOvS3XK94pVqsEobrP
         I3veHLDbmL5JpsavD6AdJMDA3QxXYNK3NXX+oFP95W8O2wzmeitkkK557Qr9NXUqPzla
         ZJq9CVmxPstp5iJUpms4Uy56iCt2xhxbPbcOGypDKo7eafZ9E8gCKOPhRhSWA4zF0Frw
         e/2L+Lqubs3A2FZbVaXqnbE7ZXZUknd0AZNjPdMIQMVfK2e5PdiFHSK3+Vm6k5xBKLP6
         ihkIuFpKsN2jms0BjIFnOKqCG9mM3k3IrPZiqIh0naxmFmO7MZHDzNxziGrKGXy/bQBp
         mtjQ==
X-Gm-Message-State: AC+VfDxUZbgsJJOSc1cvWZpgtlOjfRNA1+FbE1ZrdEz7Kb/jh9+u7fa/
	0Z3bsLFK4P+IM3NOP69K2CLoIXRvghrmdyUIiIekFIYe
X-Google-Smtp-Source: ACHHUZ6+kHb5jr7Z5aXb8gaRauf6k03IwbHq5G3j2WCW9LxJ/b9K0ByAjL+O80k1rpRFEf9d/MdJcg==
X-Received: by 2002:a17:906:ee8e:b0:965:6b9e:7ded with SMTP id wt14-20020a170906ee8e00b009656b9e7dedmr2885697ejb.42.1685122857065;
        Fri, 26 May 2023 10:40:57 -0700 (PDT)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id lf13-20020a170907174d00b009571293d6acsm2429692ejc.59.2023.05.26.10.40.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 10:40:56 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-51190fd46c3so1432828a12.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:40:56 -0700 (PDT)
X-Received: by 2002:a17:907:786:b0:965:ff38:2fb3 with SMTP id
 xd6-20020a170907078600b00965ff382fb3mr2607275ejb.74.1685122856105; Fri, 26
 May 2023 10:40:56 -0700 (PDT)
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
 <CAHk-=whtDupvWtj_ow11wU4_u=KvifTqno=5mW1VofyehjdVRA@mail.gmail.com> <CANn89i+u8jvfSQAQ=_JY0be56deJNhKgDWbqpDAvfm-i34qX9A@mail.gmail.com>
In-Reply-To: <CANn89i+u8jvfSQAQ=_JY0be56deJNhKgDWbqpDAvfm-i34qX9A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 May 2023 10:40:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh16fVwO2yZ4Fx0kyRHsNDhGddzNxfQQz2+x08=CPvk_Q@mail.gmail.com>
Message-ID: <CAHk-=wh16fVwO2yZ4Fx0kyRHsNDhGddzNxfQQz2+x08=CPvk_Q@mail.gmail.com>
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

On Fri, May 26, 2023 at 10:25=E2=80=AFAM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> arch/x86/lib/copy_user_64.S:34:2: error: invalid instruction mnemonic
> 'alternative'

Ok, that's just odd. For me, assembler mnemonics - very much including
macros - are case-insensitive.

It's actually documented that way, with the example given is for a
macro that is declared as "sum" and then used as "SUM":

   https://sourceware.org/binutils/docs/as/Macro.html

And if you want to use macros as pseudo-instructions, that's what you
want, since typically assembler instructions are not case sensitive.

But yeah, your build environment is clearly different, and yes, we
declare the macro with all caps, and other places use it that way too.

Clang?

              Linus

