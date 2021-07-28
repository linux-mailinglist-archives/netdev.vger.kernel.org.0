Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4D33D9584
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhG1SsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhG1SsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 14:48:16 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45724C061765
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:48:14 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so5438656pji.5
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SJOnUe8agutCLg/ZadS8BjR7HR6Kq5K1kn4qUVAqrrk=;
        b=mh4JeFwBt6Y5UPWcYWMR1x5yozfEgo/TfIPAoy5ZJ8Nwk/JAOqvhtRuh62wYkw0gWx
         eSTLTuPOrxN/gSnF+uS3NZsmzxZXZrey4p4NznpzdnsIu3QzBIHjufAoa6vcrfdTK/MK
         UO0k2psV7LOOEeOxPgf0j1CsOwO0IG7cdcuHk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SJOnUe8agutCLg/ZadS8BjR7HR6Kq5K1kn4qUVAqrrk=;
        b=YCbaAWaF6c7EZ6uUqzSKzaroyDiU83jOz9rYD/Pxs/AuMVO6Fp3wRU9K4CpNyMJ3yN
         m/u65kAd1/Txi9qx7yrctVifkdiBp4vte+7afsO1dTyKUNsQsgYcxyGLGjtGb54sW6yN
         tb5sjnROFKJ4ALvOUq9ad973Zg87ibALJ4NDPy7mGLiny7xfIpzYeWCCmpz6pJObVc4G
         bH49+MNR3mYxoCM2ibCe+MEdJA70kx0qDD7UE6ToEZrZKAK1xwEgG+ZsRn1vR7LGboZi
         GGpyKTyK9GT2oP/u2XqUGvGtkHQNTl/oo+JNHF/2wxIfv12AsMx7H2MKGlIfa6VghsrB
         n75w==
X-Gm-Message-State: AOAM533xZjBJWoV4cVuFNdUqs9YXs6Hz2FFIFXyY//SbUv8RQK1EVuMn
        IbFUY5d/SdUn8d8ATsaKeyaagA==
X-Google-Smtp-Source: ABdhPJxvi0cmbhx9Lj1TStHgIHN5QQ2T/dtxeaUGkZmn2TgWdwk6Jgg9hqWbzPjLsM7Lt3AgzgAQyA==
X-Received: by 2002:a62:b414:0:b029:32e:3ef0:7735 with SMTP id h20-20020a62b4140000b029032e3ef07735mr1234772pfn.61.1627498093768;
        Wed, 28 Jul 2021 11:48:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g19sm6735758pjl.25.2021.07.28.11.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 11:48:12 -0700 (PDT)
Date:   Wed, 28 Jul 2021 11:48:11 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jann Horn <jannh@google.com>, Ingo Molnar <mingo@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Qitao Xu <qitao.xu@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-hardening@vger.kernel.org
Subject: Re: tracepoints and %p [was: Re: [Patch net-next resend v2] net: use
 %px to print skb address in trace_netif_receive_skb]
Message-ID: <202107281146.B2160202D@keescook>
References: <20210715055923.43126-1-xiyou.wangcong@gmail.com>
 <202107230000.B52B102@keescook>
 <CAG48ez0b-t_kJXVeFixYMoqRa-g1VRPUhFVknttiBYnf-cjTyg@mail.gmail.com>
 <20210728115633.614e9bd9@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728115633.614e9bd9@oasis.local.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 11:56:33AM -0400, Steven Rostedt wrote:
> On Wed, 28 Jul 2021 17:13:12 +0200
> Jann Horn <jannh@google.com> wrote:
> 
> > +tracing maintainers
> > 
> > On Fri, Jul 23, 2021 at 9:09 AM Kees Cook <keescook@chromium.org> wrote:
> > > On Wed, Jul 14, 2021 at 10:59:23PM -0700, Cong Wang wrote:  
> > > > From: Qitao Xu <qitao.xu@bytedance.com>
> > > >
> > > > The print format of skb adress in tracepoint class net_dev_template
> > > > is changed to %px from %p, because we want to use skb address
> > > > as a quick way to identify a packet.  
> > >
> > > No; %p was already hashed to uniquely identify unique addresses. This
> > > is needlessly exposing kernel addresses with no change in utility. See
> > > [1] for full details on when %px is justified (almost never).
> > >  
> > > > Note, trace ring buffer is only accessible to privileged users,
> > > > it is safe to use a real kernel address here.  
> > >
> > > That's not accurate either; there is a difference between uid 0 and
> > > kernel mode privilege levels.
> > >
> > > Please revert these:
> > >
> > >         851f36e40962408309ad2665bf0056c19a97881c
> > >         65875073eddd24d7b3968c1501ef29277398dc7b
> > >
> > > And adjust this to replace %px with %p:
> > >
> > >         70713dddf3d25a02d1952f8c5d2688c986d2f2fb
> > >
> > > Thanks!
> > >
> > > -Kees  
> > 
> > Hi Kees,
> > 
> > as far as I understand, the printf format strings for tracepoints
> > don't matter for exposing what data is exposed to userspace - the raw
> > data, not the formatted data, is stored in the ring buffer that
> > userspace can access via e.g. trace_pipe_raw (see
> > https://www.kernel.org/doc/Documentation/trace/ftrace.txt), and the
> > data can then be formatted **by userspace tooling** (e.g.
> > libtraceevent). As far as I understand, the stuff that root can read
> > via debugfs is the data stored by TP_fast_assign() (although root
> > _can_ also let the kernel do the printing and read it in text form).
> > Maybe Steven Rostedt can help with whether that's true and provide
> > more detail on this.
> 
> That is exactly what is happening. I wrote the following to the replied
> text up at the top, then noticed you basically stated the same thing
> here ;-)

Where is the %px being formatted then? If it's the kernel itself (which
is the only thing that does %px), then it doesn't need to be %px, since
the raw data is separate. i.e. leave it %p for whatever logs will get
spilled out to who knows where.

> "You can get the raw data from the trace buffers directly via the
> trace_pipe_raw. The data is copied directly without any processing. The
> TP_fast_assign() adds the data into the buffer, and the printf() is
> only reading what's in that buffer. The hashing happens later. If you
> read the buffers directly, you get all the data you want."
> 
> > 
> > In my view, the ftrace subsystem, just like the BPF subsystem, is
> > root-only debug tracing infrastructure that can and should log
> > detailed information about kernel internals, no matter whether that
> > information might be helpful to attackers, because if an attacker is
> > sufficiently privileged to access this level of debug information,
> > that's beyond the point where it makes sense to worry about exposing
> > kernel pointers. But even if you disagree, I don't think that ftrace
> > format strings are relevant here.
> 
> Anyway, those patches are not needed. (Kees is going to hate me).
> 
> Since a345a6718bd56 added in 5.12, you can just do:
> 
>  # trace-cmd start -e net_dev_start_xmit
>  # trace-cmd show
> [..]
>             sshd-1853    [007] ...1  1995.000611: net_dev_start_xmit: dev=em1 queue_mapping=0 skbaddr=00000000f8c47ebd vlan_tagged=0 vlan_proto=0x0000 vlan_tci=0x0000 protocol=0x0800 ip_summed=3 len=150 data_len=84 network_offset=14 transport_offset_valid=1 transport_offset=34 tx_flags=0 gso_size=0 gso_segs=1 gso_type=0x1
> 
> Notice the value of skbaddr=00000000f8c47ebd ?
> 
> Now I do:
> 
> 	# trace-cmd start -O nohash-ptr -e net_dev_start_xmit
> 	# trace-cmd show
> [..]
>             sshd-1853    [007] ...1  2089.462722: net_dev_start_xmit: dev= queue_mapping=0 skbaddr=ffff8cfbc3ffd0e0 vlan_tagged=0 vlan_proto=0x0000 vlan_tci=0x0000 protocol=0x0800 ip_summed=3 len=150 data_len=84 network_offset=14 transport_offset_valid=1 transport_offset=34 tx_flags=0 gso_size=0 gso_segs=1 gso_type=0x1
> 
> And now we have:
> 
> skbaddr=ffff8cfbc3ffd0e0

How does ftrace interact with lockdown's confidentiality mode?

-- 
Kees Cook
