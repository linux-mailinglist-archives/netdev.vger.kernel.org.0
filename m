Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C06A46583E
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 22:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344010AbhLAVTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 16:19:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344041AbhLAVTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 16:19:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638393387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GPzmQj1IsjlPnltPX8hZRbHYQRtf/ixrfOVD6/KxR2E=;
        b=Tqq+lVfTjIHBaclR69CB36dLSkSQuhN74DmHj7MPC4aIkV0G3aLmW2ZHWJ/OowVewTd/dD
        fJ3csvcu4b758+RthhznOPSFUK8Lmpxo2fGvsPZAUMzWxi2Ia4aR2eG3D+kaj6dW/uinoZ
        tC3zwlbWfz2Zcf2pkr4mwlXT4hoL0po=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-Kc__6DXLO_aUKx-W4ercgQ-1; Wed, 01 Dec 2021 16:16:26 -0500
X-MC-Unique: Kc__6DXLO_aUKx-W4ercgQ-1
Received: by mail-wm1-f69.google.com with SMTP id 205-20020a1c00d6000000b003335d1384f1so491360wma.3
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 13:16:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GPzmQj1IsjlPnltPX8hZRbHYQRtf/ixrfOVD6/KxR2E=;
        b=E9h5PH1XWCj8r1sIGS7ABAO46mI8fNqjoTKTMTRGzcA4OCr/S18BsXMvVry1z3Owmt
         kcT1DJlF0hA+HeQFqXViFElF465z/w7/2jZdaHXYC6MWD+YMCv1pTKgVZe79kDZ44SoM
         V+wprqAnvKii4+fH1XcmFKSPlQW8iDIqm3vFQxAqCpjR4J0v+rGAvIHH2zlamvCX1hq4
         7tZdsCV8Cr66JmL8omamxzvWG794uinLEqTVUNMF5o3AQrZ5m7CvS+sakhn4BgALJ0GE
         ILfDx9Ips8K5zjW1CwRlIrAAA/TZf2mvZ46yVvIpraH74hrxxt2W/mYDD9rcilwCfc/H
         7r9A==
X-Gm-Message-State: AOAM5301g95e8N260HqM7t1Mzbsi+oWf1sbGu0UHXv2MPm0Hhe8owW8T
        qPnph4wDVz9OrwlPH8MTs+1qgMjHUR71t3uOBFH1rGZkMPto+fVC0zJ0/tAMilArepvsxhWTXid
        BuhTT12pOWTOQplOi
X-Received: by 2002:adf:f042:: with SMTP id t2mr9682976wro.180.1638393385115;
        Wed, 01 Dec 2021 13:16:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxuLCBpyiwihrbeFqNb/eygmX3EUnyJs4sEoh9/bUrAJdtVQ/g3pip6gyyZqZBqt3DcC77Byg==
X-Received: by 2002:adf:f042:: with SMTP id t2mr9682959wro.180.1638393384923;
        Wed, 01 Dec 2021 13:16:24 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id b6sm384261wmq.45.2021.12.01.13.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 13:16:24 -0800 (PST)
Date:   Wed, 1 Dec 2021 22:16:22 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 06/29] bpf: Add bpf_arg/bpf_ret_value helpers
 for tracing programs
Message-ID: <YafmJudHEl+4wPrW@krava>
References: <20211118112455.475349-1-jolsa@kernel.org>
 <20211118112455.475349-7-jolsa@kernel.org>
 <CAEf4Bza0UZv6EFdELpg30o=67-Zzs6ggZext4u40+if9a5oQDg@mail.gmail.com>
 <YaPFEpAqIREeUMU7@krava>
 <CAEf4BzbauHaDDJvGpx4oCRddd4KWpb4PkxUiUJvx-CXqEN2sdQ@mail.gmail.com>
 <CAADnVQ+6iMkRh3YLjJpyoLtqgzU2Fwhdhbv3ue7ObWWoZTmFmw@mail.gmail.com>
 <CAEf4BzabQ9YU=d-F0ypA6W73YD534cAb2SkAkwYuyD6dk71LSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzabQ9YU=d-F0ypA6W73YD534cAb2SkAkwYuyD6dk71LSQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 09:59:57AM -0800, Andrii Nakryiko wrote:
> On Wed, Dec 1, 2021 at 9:37 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Nov 30, 2021 at 11:13 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > Hm... I'd actually try to keep kprobe BTF-free. We have fentry for
> > > cases where BTF is present and the function is simple enough (like <=6
> > > args, etc). Kprobe is an escape hatch mechanism when all the BTF
> > > fanciness just gets in the way (retsnoop being a primary example from
> > > my side). What I meant here was that bpf_get_arg(int n) would read
> > > correct fields from pt_regs that map to first N arguments passed in
> > > the registers. What we currently have with PT_REGS_PARM macros in
> > > bpf_tracing.h, but with a proper unified BPF helper.
> >
> > and these macros are arch specific.
> > which means that it won't be a trivial patch to add bpf_get_arg()
> > support for kprobes.
> 
> no one suggested it would be trivial :) things worth doing are usually
> non-trivial, as can be evidenced by Jiri's patch set
> 
> > Plenty of things to consider. Like should it return an error
> > at run-time or verification time when a particular arch is not supported.
> 
> See my other replies to Jiri, I'm more and more convinced that dynamic
> is the way to go for things like this, where the safety of the kernel
> or BPF program are not compromised.
> 
> But you emphasized an important point, that it's probably good to
> allow users to distinguish errors from reading actual value 0. There
> are and will be situations where argument isn't available or some
> combination of conditions are not supported. So I think, while it's a
> bit more verbose, these forms are generally better:
> 
> int bpf_get_func_arg(int n, u64 *value);
> int bpf_get_func_ret(u64 *value);
> 
> WDYT?

ok, good preparation for kprobe code quirks described by Alexei 

> 
> > Or argument 6 might be available on one arch, but not on the other.
> > 32-bit CPU regs vs 64-bit regs of BPF, etc.
> > I wouldn't attempt to mix this work with current patches.
> 
> Oh, I didn't suggest doing it as part of this already huge and
> complicated set. But I think it's good to think a bit ahead and design
> the helper API appropriately, at the very least.
> 
> And again, I think bpf_get_func_arg/bpf_get_func_ret deserve their own
> patch set where we can discuss all this independently from
> multi-attach.
> 

good ;-) thanks,
jirka

