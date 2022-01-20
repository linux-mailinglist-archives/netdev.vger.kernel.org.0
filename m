Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE8B494697
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 05:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358544AbiATEuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 23:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358540AbiATEue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 23:50:34 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6189C061574;
        Wed, 19 Jan 2022 20:50:34 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u11so4177254plh.13;
        Wed, 19 Jan 2022 20:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pff7LtwS9rqu2dIvCcRFiA9nkzuhU2cBqVvleie1e1M=;
        b=QMHsv/Wr99MvwQ03YELXn+d9tM3kW1XkHdw8ES+5IDc8OQ1nbdn+h4eCQdeo4kF4HO
         B8X46vtrNKdzqBdWypgukxw8aDS6isHNjVaecuhhJa6zsc/+3RyHmEaolGTcWOKPGLw8
         QLF9PotFuSg/s3mD8L/Y9Jj7aSjKYvcMFf0XYhQJj9NnxEhthZyAiy/fTCLX94MhKkb6
         uroCupQoKfwZdKtIr/SVWIjsD0k1twlHsz1jDHnQc5fXnN383Ks96hNS0J52j4boHVAS
         8YedzB6T+6bWg5RlSZocLdSeeWJGpS+fifzLqVbBTyyj35ySuY0AP+vS4pnLwO2JEC8N
         dAAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pff7LtwS9rqu2dIvCcRFiA9nkzuhU2cBqVvleie1e1M=;
        b=AGe3+OTiZi9FFelhNlmCdVrdTu1g/ZBRwEcCCLoBoznhN/ybkWBQrA6T1fNkf/ovdK
         K08MpAzhbQEOjRX9JX9EcYpnjZXI3Vt5EpK804+yMZ414E58m1JVOBn4ye7AKF/VtDBP
         NGoVd4ptqb75iK82M9dc6oYywwisRPLVdmn3C/rZzPuNcZtcoif4g/1GWVe+Ps5n4aRc
         DF9xuWhNLp6Mhi+Cby/ITjzmeVeE13iwPdZunhPoFqag5x0nzjCn8MyCudZvVA0YVXHf
         vX7a4NYduj8t6ao5tL9P+BroJi7/bmFXi6JTkYZDS+dE0fapspv6szQKMsWLilOjTwu0
         9FgQ==
X-Gm-Message-State: AOAM532WRCtTOkmIpAem6WBR90d2hzPDJI3YqgTljmZm/7wMdqQwjvcb
        u7A4WWBpreIAMlTJ9VXbEXUyMN7w5CBToMWoNig=
X-Google-Smtp-Source: ABdhPJz4hKxWnRl8I82nR/dVUjToi2RDtd87q94YckX+kYrz2a9fJhsKvPg1+ZzXRaKVmxRwq1E3+fC4xSKWGguqIPk=
X-Received: by 2002:a17:90b:3b4f:: with SMTP id ot15mr8731637pjb.138.1642654234229;
 Wed, 19 Jan 2022 20:50:34 -0800 (PST)
MIME-Version: 1.0
References: <20220119230620.3137425-1-song@kernel.org> <20220119230620.3137425-7-song@kernel.org>
 <20220120041421.ngrxukhb4t6b7tlq@ast-mbp.dhcp.thefacebook.com> <FC0F20F4-8B5A-428A-BA48-3ABC49723327@fb.com>
In-Reply-To: <FC0F20F4-8B5A-428A-BA48-3ABC49723327@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 19 Jan 2022 20:50:23 -0800
Message-ID: <CAADnVQK3BUg8me5zc3N8y9qu+ee_yMvKuhNasHQzuQ6_CcQ_Tg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 8:48 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jan 19, 2022, at 8:14 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Jan 19, 2022 at 03:06:19PM -0800, Song Liu wrote:
> >>
> >> +/*
> >> + * BPF program pack allocator.
> >> + *
> >> + * Most BPF programs are pretty small. Allocating a hole page for each
> >> + * program is sometime a waste. Many small bpf program also adds pressure
> >> + * to instruction TLB. To solve this issue, we introduce a BPF program pack
> >> + * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
> >> + * to host BPF programs.
> >> + */
> >> +#define BPF_PROG_PACK_SIZE  HPAGE_PMD_SIZE
> >> +#define BPF_PROG_MAX_PACK_PROG_SIZE HPAGE_PMD_SIZE
> >
> > We have a synthetic test with 1M bpf instructions. How did it JIT?
> > Are you saying we were lucky that every BPF insn was JITed to <2 bytes x86?
> > Did I misread the 2MB limit?
>
> The logic is, if the program is bigger than 2MB, we fall back to use
> module_alloc(). This limitation simplifies the bpf_prog_pack allocator.

Ahh. Missed this part of the diff. Makes sense.
