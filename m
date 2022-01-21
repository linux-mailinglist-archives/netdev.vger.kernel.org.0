Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D1249650A
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 19:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382109AbiAUSaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 13:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351379AbiAUSaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 13:30:08 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B69C06173B;
        Fri, 21 Jan 2022 10:30:07 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id c5so8798014pgk.12;
        Fri, 21 Jan 2022 10:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gWj0fzkX6SCr+mRNygpziIPt+01hOV6R350muCnRcCU=;
        b=l/J/McHeqUVAhA32h+ht0lmcQvt+VOS+25ykgysMqJGLguXx8Fj5BnVWcj55HiGTXs
         DM9rwK2Ccfa1LQg88CaAtvcrxcGnIv7LdCfSpIXCA0ypb53qfuhxil/1kOt/15YzrePa
         veEB5Ij1bLXaLnH4XXqvVaLXYw/hbWLiyj3SONltS1Jvun78v+S2bbfzzpXl6CQl4JvK
         h+5x1WKaM6IH4M8ZT9cL/A8POlhdcUu86EMJtjB//Gs2mFYj6u+6N9qanuZ4+wzx2wD+
         G76qOdag74qYkhgiyud84AzXJRurp1Ik9+47TFic8Bzeq1jyfzPnWAHSGH6COBZpHnZe
         natw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gWj0fzkX6SCr+mRNygpziIPt+01hOV6R350muCnRcCU=;
        b=zAQaic5V0NBVR1O4FrnAANq6Tvn0LMm6hI1mbQIeNQrFSh/Qa2Q9V+mG9qcKsyTgbH
         lh+eIXI98iioJO17e4ukyJSIfL/rfy3BRlBOcd56JDt7srqPZyDQn5P22WdfYmnZMRB4
         XlEuvYK5410srpfgG/70wYpS3FNkII/tPT/spf2MbqkwMudXtGF/z7wKOErvaqeLgw+4
         8jK6Bzfeq+j/PPXO7WTBbGmUnIxvWJt6QQGY54nJLEMcH6Jou12JoEEc3lLTEyBN0flC
         WbAGFPMt9AOBOKv40txCSfu23foKUncnDcnO3XyMngyH3RyhnyWC2KaPmbOciyr7wz8D
         vaJQ==
X-Gm-Message-State: AOAM530QfaIvSfGkqOCvkgJk7QXQBbfO07DSl+VEvbwcffhTRQu3L0Vk
        EtYwS1+1XEUZK/vHCSWrTBXfPPIIaGlWXKXCOzk=
X-Google-Smtp-Source: ABdhPJwCC5D8V66vVff0tslgFtrLz++jacDAuai/oq5Em/lkIeBs7qJRgpWrk+8iZ1ZDRkzPfO93f9W+kgtovuo/twQ=
X-Received: by 2002:a62:6342:0:b0:4bc:c4f1:2abf with SMTP id
 x63-20020a626342000000b004bcc4f12abfmr4937309pfb.77.1642789806987; Fri, 21
 Jan 2022 10:30:06 -0800 (PST)
MIME-Version: 1.0
References: <20220120191306.1801459-1-song@kernel.org> <20220120191306.1801459-8-song@kernel.org>
 <CAADnVQL-TAZD6BbN-sXDpAs0OHFWGg3e=RafBQ10=ExXESNQgg@mail.gmail.com> <F72EEF0D-4F61-4AE1-B2A1-D16A5DBCCC37@fb.com>
In-Reply-To: <F72EEF0D-4F61-4AE1-B2A1-D16A5DBCCC37@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Jan 2022 10:29:55 -0800
Message-ID: <CAADnVQLWj6cVE=OEqNfSBcAzFJDHPF8sPfqGfaCknV+Q=1HOmQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 7/7] bpf, x86_64: use bpf_prog_pack allocator
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 9:53 AM Song Liu <songliubraving@fb.com> wrote:
> >
> > the header->size could be just below 2MB.
> > I don't think kzalloc() can handle that.
>
> Technically, kzalloc can handle 2MB allocation via:
>   kzalloc() => kmalloc() => kmalloc_large() => kmalloc_order()
>
> But this would fail when the memory is fragmented. I guess we should use
> kvmalloc() instead?

Contiguous 2MB allocation?

> >
> >> +                               if (!tmp_header) {
> >> +                                       bpf_jit_binary_free_pack(header);
> >> +                                       header = NULL;
> >> +                                       prog = orig_prog;
> >> +                                       goto out_addrs;
> >> +                               }
> >> +                               tmp_header->size = header->size;
> >> +                               tmp_image = (void *)tmp_header + ((void *)image - (void *)header);
> >
> > Why is 'tmp_image' needed at all?
> > The above math can be done where necessary.
>
> We pass both image and tmp_image to do_jit(), as it needs both of them.
> I think maintaining a tmp_image variable makes the logic cleaner. We can
> remove it from x64_jit_data, I guess.

I'd remove from x64_jit_data. The recompute is cheap.

Speaking of tmp_header name... would be great to come up
with something more descriptive.
Here both tmp_header/tmp_image and header/image are used at the same time.
My initial confusion with the patch was due to the name 'tmp'.
The "tmp" prefix implies that the tmp_image will be used first
and then it will become an image.
But it's not the case.
Maybe call it 'rw_header' and add a comment that 'header/image'
are not writeable directly ?
Or call it 'poke_header' ?
Other ideas?
