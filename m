Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577BF2F32E5
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 15:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732706AbhALOY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 09:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbhALOYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 09:24:55 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E1BC061786;
        Tue, 12 Jan 2021 06:24:15 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id jx16so3739987ejb.10;
        Tue, 12 Jan 2021 06:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O5/HL8VVGM5tx4Z8dAyAokogpc1Z04/fo1fGs1jUizo=;
        b=tYMBvZXJbgouAv/74jI0R/AItKNmhSOgh+xASdDYxzc8X7c7KSAwM4ftUkoHfnyYxW
         y9WzzBCSjsRKZURM1WaLTtme+zOUnSmIRdTkvNMZFd8cPore2leXkWeE+NFnFe3/cmr/
         daOMwVcCpFOyvBePet7lF5Fr40U+AljLRaY7uI1QIRGPc/a6PUzpnzs3daBP6QU2GDcX
         QEUrOrB+Y4MW/BOdm59cvUIzoNM8OPeJOxMafGkCd8U/kmt92ij/0V1u3n1T/4GkxcMR
         YPin4m4Vx77ktlClhtLJZRuZbc4XqK9YOaqYJ+fxtrf8M9/vqIBL7V6BwONF9oRZ4t2o
         tpjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O5/HL8VVGM5tx4Z8dAyAokogpc1Z04/fo1fGs1jUizo=;
        b=O3T6jXu+OPkNcNDTlDcdoQmFW/ohX0Uy3P27URq7bfwt15LMuWA8drcwsocAWMlUEG
         aPHpWKpdR9+6XHcf+2l9u+WavDv6XlTtFezNXFkBA//g3yx3ELuj2M605oSLOUUPyGOY
         WLK55ABx7jl4OPEmFCz05GzQdP5E3BPmlB3sZvNWMxEJJ18NWle9G0woUPuUYRwJupNi
         UDiCaTN+UOf8cwOTJi+my6q6ptrwiGuYoqdSB10b6AN2Asgr/TC8YqUtz4326+j1bt4j
         Dkq46MIVBAHGyTo3mYratZJxRBvfRCi/UQG+CnmSKp+rsrctswDdFn6sC2hc/ywAHGQB
         bhAw==
X-Gm-Message-State: AOAM532BikWpSwXhwRNUlYFK6b3PlLuJJWal1t9rAGORDXYLU05wilCZ
        uz2WYbfJMQnDgP60v/s+LzWUCwIxVJGTJaiGcts=
X-Google-Smtp-Source: ABdhPJwUicnFgTajXRPkiUNbl2a34Wk/ysj6ZVQx7/4K5mvC1OnJOAdExATWq4YM05B3nzcs8HGowKXT0bzg0tRt3eA=
X-Received: by 2002:a17:907:1004:: with SMTP id ox4mr3381026ejb.240.1610461453603;
 Tue, 12 Jan 2021 06:24:13 -0800 (PST)
MIME-Version: 1.0
References: <20210112091403.10458-1-gilad.reti@gmail.com> <CACYkzJ6DJ0NEm+qTBpMSJNFfgNHBFPZc=Ytj4w+4hY=Co4=0yg@mail.gmail.com>
In-Reply-To: <CACYkzJ6DJ0NEm+qTBpMSJNFfgNHBFPZc=Ytj4w+4hY=Co4=0yg@mail.gmail.com>
From:   Gilad Reti <gilad.reti@gmail.com>
Date:   Tue, 12 Jan 2021 16:23:37 +0200
Message-ID: <CANaYP3EQhTQ_o6QF_JNffJqHmVWRw6wcc95u8XvDpm+pY8ER3Q@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: support PTR_TO_MEM{,_OR_NULL} register spilling
To:     KP Singh <kpsingh@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 3:57 PM KP Singh <kpsingh@kernel.org> wrote:
>
> On Tue, Jan 12, 2021 at 10:14 AM Gilad Reti <gilad.reti@gmail.com> wrote:
> >
> > Add support for pointer to mem register spilling, to allow the verifier
> > to track pointer to valid memory addresses. Such pointers are returned
>
> nit: pointers

Thanks

>
> > for example by a successful call of the bpf_ringbuf_reserve helper.
> >
> > This patch was suggested as a solution by Yonghong Song.
>
> You can use the "Suggested-by:" tag for this.

Thanks

>
> >
> > The patch was partially contibuted by CyberArk Software, Inc.
>
> nit: typo *contributed

Thanks. Should I submit a v2 of the patch to correct all of those?

>
> Also, I was wondering if "partially" here means someone collaborated with you
> on the patch? And, in that case:
>
> "Co-developed-by:" would be a better tag here.

No, I did it alone. I mentioned CyberArk since I work there and did some of the
coding during my daily work, so they deserve credit.

>
> Acked-by: KP Singh <kpsingh@kernel.org>
>
>
> >
> > Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier
> > support for it")
> > Signed-off-by: Gilad Reti <gilad.reti@gmail.com>
> > ---
> >  kernel/bpf/verifier.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 17270b8404f1..36af69fac591 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -2217,6 +2217,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
> >         case PTR_TO_RDWR_BUF:
> >         case PTR_TO_RDWR_BUF_OR_NULL:
> >         case PTR_TO_PERCPU_BTF_ID:
> > +       case PTR_TO_MEM:
> > +       case PTR_TO_MEM_OR_NULL:
> >                 return true;
> >         default:
> >                 return false;
> > --
> > 2.27.0
> >
