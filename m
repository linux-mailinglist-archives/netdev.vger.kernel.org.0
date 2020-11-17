Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FB22B6D50
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730736AbgKQS10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgKQS1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 13:27:25 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FB3C0613CF;
        Tue, 17 Nov 2020 10:27:25 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d3so10703176plo.4;
        Tue, 17 Nov 2020 10:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BzlahuoWyinnwS/4xXXocdXgOxSu6wIaLBe7RoB5Z1M=;
        b=TAxOYJy6jCxXM75t9rh4DhV+WuIbd2FuD1e7lj5QQaDMmNcntG/2BBddDFHs+iX2N3
         fFpxi3qPo4GpGmtXT/FFHqk+TNI6dsbRsVzH4Z76kZwrwmiMjSO6UchL1MMPuXrCBNDK
         V+i7U7MnuRf9xkLimwe5czbPuzRke4/SHz/C69l/b5BWMQ1d+Jwa3RFb3N5ACuHMIOMC
         5HHO8/JZBqwFktWn7YuRC2vTBB1zWYrjITMv3XqhU9N5BVL+IyzMndda9cAe5Drifick
         r//GZOmkQw70qXYDebxg/4zo/whlMUhOfs1qYXE0dyly+tSmvEQFb4aw3DTxUdGlkahb
         P4Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BzlahuoWyinnwS/4xXXocdXgOxSu6wIaLBe7RoB5Z1M=;
        b=ZhFoU2YRszDHwZsXr9ddO6LIiu9zB/DNv4GGz1WxXnGZDYCSqoGjKK0OuYBK5h4VHp
         PhaPAutPf5gGh9I5ckXspVZqkGxlE7Ipf3zrbJTMsqL/8O7W1uirAZb1Yqm5NIr5ZXCQ
         oGAzr2OyGUCHYkmCLDPdjBlrqODwPYQ8F0xhfyyNrgQ4luSv+3BoaUwd9P2CuRgTeVbb
         ljMf0pV5uQRWfhAOgX1o1WQUbTZm4zSp47byt8tFpgRS+srb1CwN4RdD/ueBh7N7dqG/
         8F/IqUiOmRhq28snVz1itU+BNGEfG4z065woI0Tcl0hes2M31lsmUI548+oTXbaIdbC2
         A1uw==
X-Gm-Message-State: AOAM532MhNkAvUW1eLh+XfAunT6OZySdDokVfSXFIbR5wnYChyFkvQlR
        hCTZY6bpS4YsAOahaYF7slE=
X-Google-Smtp-Source: ABdhPJyN2ufBumsfgA200wyF1uAQlafS/Q/VIpNO4mNYFAkpQf6iKzC9jrNO3uxpOQjQyDcju5ZQGQ==
X-Received: by 2002:a17:902:8c84:b029:d9:471:f0da with SMTP id t4-20020a1709028c84b02900d90471f0damr406157plo.84.1605637644952;
        Tue, 17 Nov 2020 10:27:24 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:8f57])
        by smtp.gmail.com with ESMTPSA id y5sm3758457pjr.50.2020.11.17.10.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 10:27:24 -0800 (PST)
Date:   Tue, 17 Nov 2020 10:27:21 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiri Benc <jbenc@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        ecree@solarflare.com
Subject: Re: [PATCHv5 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201117182721.nmhewohx3dxwv34i@ast-mbp>
References: <20201109070802.3638167-1-haliu@redhat.com>
 <20201116065305.1010651-1-haliu@redhat.com>
 <CAADnVQ+LNBYq5fdTSRUPy2ZexTdCcB6ErNH_T=r9bJ807UT=pQ@mail.gmail.com>
 <20201116155446.16fe46cf@carbon>
 <20201117023757.qypmhucuws3sajyb@ast-mbp>
 <20201117031933.GJ2408@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117031933.GJ2408@dhcp-12-153.nay.redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 11:19:33AM +0800, Hangbin Liu wrote:
> On Mon, Nov 16, 2020 at 06:37:57PM -0800, Alexei Starovoitov wrote:
> > On Mon, Nov 16, 2020 at 03:54:46PM +0100, Jesper Dangaard Brouer wrote:
> > > 
> > > Thus, IMHO we MUST move forward and get started with converting
> > > iproute2 to libbpf, and start on the work to deprecate the build in
> > > BPF-ELF-loader.  I would prefer ripping out the BPF-ELF-loader and
> > > replace it with libbpf that handle the older binary elf-map layout, but
> > > I do understand if you want to keep this around. (at least for the next
> > > couple of releases).
> > 
> > I don't understand why legacy code has to be around.
> > Having the legacy code and an option to build tc without libbpf creates
> > backward compatibility risk to tc users:
> > Newer tc may not load bpf progs that older tc did.
> 
> If a distro choose to compile iproute2 with libbpf, I don't think they will
> compile iproute2 without libbpf in new version. So yum/apt-get update from
> official source doesn't like a problem.
> 
> Unless a user choose to use a self build iproute2 version. Then the self build
> version may also don't have other supports, like libelf, libnml, libcap etc.
> 
> > 
> > > I actually fear that it will be a bad user experience, when we start to
> > > have multiple userspace tools that load BPF, but each is compiled and
> > > statically linked with it own version of libbpf (with git submodule an
> > > increasing number of tools will have more variations!).
> > 
> > So far people either freeze bpftool that they use to load progs
> > or they use libbpf directly in their applications.
> > Any other way means that the application behavior will be unpredictable.
> > If a company built a bpf-based product and wants to distibute such
> > product as a package it needs a way to specify this dependency in pkg config.
> > 'tc -V' is not something that can be put in a spec.
> > The main iproute2 version can be used as a dependency, but it's meaningless
> > when presence of libbpf and its version is not strictly derived from
> > iproute2 spec.
> > The users should be able to write in their spec:
> > BuildRequires: iproute-tc >= 5.10
> > and be confident that tc will load the prog they've developed and tested.
> 
> The current patch does have a libbpf version check, it need at least libbpf
> 0.1.0. So if a distro starts to build iproute2 based on libbpf, there will
> have a dependence. The rule could be added to rpm spec file, or what else
> the distro choose. That's the distro compiler's work.
> 
> Unless you want to say a company built a bpf-based product, they only
> add iproute2 version dependence(let's say some distros has iproute2 5.12 with
> libbpf supported), and somehow forgot add libbpf version dependence check
> and distro check. At the same time a user run the product on a distro without
> libbpf compiled on iproute2 5.12. That do will cause problem.

right.
You've answered Ed's question:

> But if libbpf is dynamically linked, they can put
> Requires: libbpf >= 0.3.0
> Requires: iproute-tc >= 5.10
> and get the dependency behaviour they need.  No?

It is a problem because >= 5.10 cannot capture legacy vs libbpf.

> But if I'm the user, I will think the company is not professional for bpf
> product that they even do not know libbpf is needed...
> 
> So my opinion: for end user, the distro should take care of libbpf and
> iproute2 version control. For bpf company, they should take care if libbpf
> is used by the iproute2 and what distros they support.

So you're saying that bpf community shouldn't care about their users.
The distros suppose to step forward and provide proper bpf support
in tools like iproute2?
In other words iproute2 upstream doesn't care about shipping quality product.
It's distros job now.
Thanks, but no.
iproute2 should stay with legacy obsolete prog loader
and the users should switch to bpftool + iproute2 combination.
bpftool for loading progs and iproute2 for networking configs.
