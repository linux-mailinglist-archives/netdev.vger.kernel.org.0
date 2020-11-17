Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152C82B57C8
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgKQDTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:19:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35026 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbgKQDTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:19:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605583189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LR1RVCVDmMZYtYdb1NH5Ko2l6/L30HghQHqegBLQOWc=;
        b=i5DvOlknCSsI5gwXSTtIU5k+yy8BxmQFjwxJOscSN20AcZb+Ns/KdmV3KZcwnGvntUOT95
        ow2XAM4h2jRaWncctEBdoRTvhsyGqiwWtPwuzB9a3bl/MHPrWgX6atENmqb6hFFKdzZD/x
        Lcp7bZ/EH4bQnxpC6NT1d7LJwr2R6po=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-Fb6B3x6KPCKDlY5A2DIUng-1; Mon, 16 Nov 2020 22:19:47 -0500
X-MC-Unique: Fb6B3x6KPCKDlY5A2DIUng-1
Received: by mail-pl1-f200.google.com with SMTP id p15so10655061plr.2
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:19:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LR1RVCVDmMZYtYdb1NH5Ko2l6/L30HghQHqegBLQOWc=;
        b=o74PY85D9IYU8n0/7W680/f+F/xvMq6pGdo+mHM+FL/isjuyRO7kSNhuBG4yWXon1m
         nRYVWxoP8R3j0RaYVQalZScc6lCDlCRBFFYmuw1ACsOh2pEMmbvwMdx4pmjP15AxGlQl
         7M47s8cJ1gOx+1xnq1lLoOHnujx2oa38DsKHs0+8tHxzm9kvZHPYj2X4hvSSsxHGwm0G
         KmG7AleJENMrTh94HP4nucM4m+nWGuop7ZlwCZrPlkKHkNRdmZRykMbNa3Ol+rlyV5Z7
         U4DGIqGFC0u0yg9pUv5AtwsQYgIE65gFguEtTVKD2mB/Ji98RlRzLkB6v3U2UsFNVhld
         DlTQ==
X-Gm-Message-State: AOAM532A9qSDy91vz3Su8YVdcwImZ6qi/CGxQ3aXjLhWE0eNErMDyBMj
        aogZGG5WrfxPtHAHIq7OWNhWWlBCFludaIPRpnhA5c7VN+3P6wXkGeL4lPUsauQ7Wq642XXLWrv
        v2YKU/pIqGzZzU0s=
X-Received: by 2002:a62:1506:0:b029:18b:44dd:6325 with SMTP id 6-20020a6215060000b029018b44dd6325mr16940671pfv.30.1605583186145;
        Mon, 16 Nov 2020 19:19:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJziRqjVkGJDdX0zd1KU7xPtskheZ1Riv1/UF0Izbf15BvaLUnJ8G+ibKrTAjIh/cOQjSlop2w==
X-Received: by 2002:a62:1506:0:b029:18b:44dd:6325 with SMTP id 6-20020a6215060000b029018b44dd6325mr16940645pfv.30.1605583185840;
        Mon, 16 Nov 2020 19:19:45 -0800 (PST)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l10sm964723pjg.3.2020.11.16.19.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 19:19:45 -0800 (PST)
Date:   Tue, 17 Nov 2020 11:19:33 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiri Benc <jbenc@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv5 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201117031933.GJ2408@dhcp-12-153.nay.redhat.com>
References: <20201109070802.3638167-1-haliu@redhat.com>
 <20201116065305.1010651-1-haliu@redhat.com>
 <CAADnVQ+LNBYq5fdTSRUPy2ZexTdCcB6ErNH_T=r9bJ807UT=pQ@mail.gmail.com>
 <20201116155446.16fe46cf@carbon>
 <20201117023757.qypmhucuws3sajyb@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117023757.qypmhucuws3sajyb@ast-mbp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 06:37:57PM -0800, Alexei Starovoitov wrote:
> On Mon, Nov 16, 2020 at 03:54:46PM +0100, Jesper Dangaard Brouer wrote:
> > 
> > Thus, IMHO we MUST move forward and get started with converting
> > iproute2 to libbpf, and start on the work to deprecate the build in
> > BPF-ELF-loader.  I would prefer ripping out the BPF-ELF-loader and
> > replace it with libbpf that handle the older binary elf-map layout, but
> > I do understand if you want to keep this around. (at least for the next
> > couple of releases).
> 
> I don't understand why legacy code has to be around.
> Having the legacy code and an option to build tc without libbpf creates
> backward compatibility risk to tc users:
> Newer tc may not load bpf progs that older tc did.

If a distro choose to compile iproute2 with libbpf, I don't think they will
compile iproute2 without libbpf in new version. So yum/apt-get update from
official source doesn't like a problem.

Unless a user choose to use a self build iproute2 version. Then the self build
version may also don't have other supports, like libelf, libnml, libcap etc.

> 
> > I actually fear that it will be a bad user experience, when we start to
> > have multiple userspace tools that load BPF, but each is compiled and
> > statically linked with it own version of libbpf (with git submodule an
> > increasing number of tools will have more variations!).
> 
> So far people either freeze bpftool that they use to load progs
> or they use libbpf directly in their applications.
> Any other way means that the application behavior will be unpredictable.
> If a company built a bpf-based product and wants to distibute such
> product as a package it needs a way to specify this dependency in pkg config.
> 'tc -V' is not something that can be put in a spec.
> The main iproute2 version can be used as a dependency, but it's meaningless
> when presence of libbpf and its version is not strictly derived from
> iproute2 spec.
> The users should be able to write in their spec:
> BuildRequires: iproute-tc >= 5.10
> and be confident that tc will load the prog they've developed and tested.

The current patch does have a libbpf version check, it need at least libbpf
0.1.0. So if a distro starts to build iproute2 based on libbpf, there will
have a dependence. The rule could be added to rpm spec file, or what else
the distro choose. That's the distro compiler's work.

Unless you want to say a company built a bpf-based product, they only
add iproute2 version dependence(let's say some distros has iproute2 5.12 with
libbpf supported), and somehow forgot add libbpf version dependence check
and distro check. At the same time a user run the product on a distro without
libbpf compiled on iproute2 5.12. That do will cause problem.

But if I'm the user, I will think the company is not professional for bpf
product that they even do not know libbpf is needed...

So my opinion: for end user, the distro should take care of libbpf and
iproute2 version control. For bpf company, they should take care if libbpf
is used by the iproute2 and what distros they support.

Please correct me if I missed something.

Thanks
Hangbin

