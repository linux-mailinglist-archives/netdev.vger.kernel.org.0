Return-Path: <netdev+bounces-9117-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09A86727586
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 05:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FC921C20FCA
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 03:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E89741107;
	Thu,  8 Jun 2023 03:17:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D21ECF;
	Thu,  8 Jun 2023 03:17:58 +0000 (UTC)
Received: from mail-yw1-x1141.google.com (mail-yw1-x1141.google.com [IPv6:2607:f8b0:4864:20::1141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9EFE43;
	Wed,  7 Jun 2023 20:17:57 -0700 (PDT)
Received: by mail-yw1-x1141.google.com with SMTP id 00721157ae682-565de553de1so3138997b3.0;
        Wed, 07 Jun 2023 20:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686194276; x=1688786276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V7fMdE8eaW7BeuJ297fgloLKjwJdfmPyym4SYRcLyPI=;
        b=gIimOiJmtBiXZ/AfGv9nbO9GUOUxWMjMHVDRQMd8A7YFdE8Dk/pmt/ao6FozOnablT
         F7uU/1ol0VP7EEzjNS80q8nrViUR6/VoRT3dkTGUStdVjAQ2k0/LMN0GQ5WpJ34pRtMC
         yxkmwGi8jPVDb/7pHSxyno9EDCyBpjjUagh9PxB88BS4TAJqScbUXBTYFaWXuR5SPSkl
         8H/cphHwNeEZKS94o/sg/g85q93Ka0Cwa3L1XpWzgHoNfp2saysc8FWyvjnM/aZoMTqH
         dFKdJQTnYHgny1px4n1+UyNLk1CJbSkh0Q3WmHOu4M43M0sHrJ7XmUpay7orEF/9VXpM
         GTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686194276; x=1688786276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V7fMdE8eaW7BeuJ297fgloLKjwJdfmPyym4SYRcLyPI=;
        b=cZ55G5YIQsN7n4sVeB1nAfdsbiK2m6iNzA7lnCQhHRrdh5iR0zcHq7H5Xa4rFzBvdU
         OYnlvm1z162YoYjVKKhoM7kI4c5b/SkKSu4xzQzaw31mBpyB/dtdrEPpLXQ3OWY0zzEl
         ZMHaZETmX7dt7B3iX/tKaaHnkMHfFWss16PLdfvBku5gTgZWqFt6RnFxk3T8AhirZH0G
         E03GJKEHFMyEo5Vzlt/j0hh8cJSqrUwF1GmcJSsbrjRMe/kEiRkfOhi1awplYueZWDWI
         MaCoEHQFKENdeMWo64qxHT8oKsY2+Na4gD0Ok8JM0PrCseoDGMit+lVMQxN/6RgxJGpc
         WjYA==
X-Gm-Message-State: AC+VfDxI/h13Lmrd6YMbBuvc+xMP9IGJl9sOh1qjauT1R16kiS6gbyC3
	jkFs35EhEH3EgJ4AIHO6aH9c3J+x/aaZWEwrlYgIUxQuIzwAfJ66
X-Google-Smtp-Source: ACHHUZ5dPBEvyBVjI47c0kbRPC2Y0VkP2Lilanf4uyMojOYEDQLHVku5t53NLCaZ3cNkXLbvQCdyYer6yxkBkHGAyGQ=
X-Received: by 2002:a0d:e8d2:0:b0:561:9bcc:6c81 with SMTP id
 r201-20020a0de8d2000000b005619bcc6c81mr1218726ywe.24.1686194276278; Wed, 07
 Jun 2023 20:17:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607125911.145345-1-imagedong@tencent.com>
 <20230607125911.145345-2-imagedong@tencent.com> <20230607200905.5tbosnupodvydezq@macbook-pro-8.dhcp.thefacebook.com>
In-Reply-To: <20230607200905.5tbosnupodvydezq@macbook-pro-8.dhcp.thefacebook.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Thu, 8 Jun 2023 11:17:45 +0800
Message-ID: <CADxym3abYOZ5JVa4FP5R-Vi7HAk=n_0vTmMGveDH8xvFtuaBDw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] bpf, x86: allow function arguments up to
 12 for TRACING
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: davem@davemloft.net, dsahern@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, 
	sdf@google.com, x86@kernel.org, imagedong@tencent.com, benbjiang@tencent.com, 
	netdev@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 4:09=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jun 07, 2023 at 08:59:09PM +0800, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > For now, the BPF program of type BPF_PROG_TYPE_TRACING can only be used
> > on the kernel functions whose arguments count less than 6. This is not
> > friendly at all, as too many functions have arguments count more than 6=
.
> >
> > Therefore, let's enhance it by increasing the function arguments count
> > allowed in arch_prepare_bpf_trampoline(), for now, only x86_64.
> >
> > For the case that we don't need to call origin function, which means
> > without BPF_TRAMP_F_CALL_ORIG, we need only copy the function arguments
> > that stored in the frame of the caller to current frame. The arguments
> > of arg6-argN are stored in "$rbp + 0x18", we need copy them to
> > "$rbp - regs_off + (6 * 8)".
> >
> > For the case with BPF_TRAMP_F_CALL_ORIG, we need prepare the arguments
> > in stack before call origin function, which means we need alloc extra
> > "8 * (arg_count - 6)" memory in the top of the stack. Note, there shoul=
d
> > not be any data be pushed to the stack before call the origin function.
> > Then, we have to store rbx with 'mov' instead of 'push'.
>
> x86-64 psABI requires stack to be 16-byte aligned when args are passed on=
 the stack.
> I don't see this logic in the patch.

Yeah, it seems I missed this logic......:)

I have not figure out the rule of the alignment, but after
observing the behavior of the compiler, the stack seems
should be like this:

------ stack frame begin
rbp

xxx   -- this part should be aligned in 16-byte

------ end of arguments in stack
xxx
------ begin of arguments in stack

So the code should be:

+       if (nr_regs > 6 && (flags & BPF_TRAMP_F_CALL_ORIG)) {
+                stack_size =3D ALIGN(stack_size, 16);
+                stack_size +=3D (nr_regs - 6) * 8;
+       }

Am I right?

Thanks!
Menglong Dong

