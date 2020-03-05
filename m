Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89C7179D29
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 02:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgCEBHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 20:07:13 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33788 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgCEBHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 20:07:13 -0500
Received: by mail-pf1-f193.google.com with SMTP id n7so1914673pfn.0;
        Wed, 04 Mar 2020 17:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iQWBNwZHuPES1MAoYyVFOv0LMHmBOzfbtmN1zJy1w/o=;
        b=lPi3WynqEhgSxtdhPVPi1DD8k33RlVyhFUl3VyoGjBC918Y1wxu4JCF5Ti9u0R5C+P
         /mYAPBc4r+ZMj28iOPkc3pPBbIxz2Y8p1fvZDhDIXHjcaktmZyWdMepkjbfIPSq/cZ70
         /wFZOA8Cun1baf77H7uDoPBpViWSCWbMS71oTv2sgBDuPsCmlV5Vo/QKeICUtHCijJ67
         3xpIXDXETxV+HGCaI/qk3DI6wbZuQ2I6a/58jtZtMMKDrgipy3xTbFEsblL6k4UU20vf
         k+46l8/p+gtwcbVQc7z1vTN/TLcw5RFT5OoL3lE9/QKQBqnGDdgOcFNU+9fd+s02qg91
         PbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iQWBNwZHuPES1MAoYyVFOv0LMHmBOzfbtmN1zJy1w/o=;
        b=CXWgWc78SWzjEx47K0R9xF9sOpHj8zQ+E8RsjSTGpwILhg0U23MGgw3+RoeYLP8T9o
         Lmv1IpsZfropGMOds8soi1hTRt70iRumMsJo3ZFg99h3A+FQXk0tlqtjpbw2XrPQ+v6q
         Gsz83eh8SdOb0ze0XLCJXSzOvdL4pI+iT2UEqZ3wMrl0HsxiieQBFGRMT07A0WTy7aq4
         6j6iP7fvSVKJQw5+THMPpRfl1h0F9OIrOgKtVTfyz54t7JeVT5310CIPaqIqFXr1yziU
         q68MeeXbhcxn48VZzLTyjq5Zq98u4mpqSFB78PWfX7xSw0WgkbBWp3PZjSgwlLotLqPN
         nF+Q==
X-Gm-Message-State: ANhLgQ2ihAgurOY+KOBwdctV6Fcsn/CZMX8pwZ4ORugcdyDIbvmV8V9L
        AW3Ox776yC36/ebo8VKPAtrK5Nfh
X-Google-Smtp-Source: ADFU+vuHmwE7CLPhGdFv03knts8JvJkZNMVcJe4Sp3IhC9s/hR/inZdku+BFQr56oiY5VoKnq/D+zw==
X-Received: by 2002:a63:3c59:: with SMTP id i25mr4809601pgn.387.1583370431455;
        Wed, 04 Mar 2020 17:07:11 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::4:c694])
        by smtp.gmail.com with ESMTPSA id a9sm29023628pfo.35.2020.03.04.17.07.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 17:07:10 -0800 (PST)
Date:   Wed, 4 Mar 2020 17:07:08 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
Message-ID: <20200305010706.dk7zedpyj5pb5jcv@ast-mbp>
References: <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
 <CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com>
 <87pndt4268.fsf@toke.dk>
 <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
 <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com>
 <87k1413whq.fsf@toke.dk>
 <20200304043643.nqd2kzvabkrzlolh@ast-mbp>
 <20200304114000.56888dac@kicinski-fedora-PC1C0HJN>
 <20200304204506.wli3enu5w25b35h7@ast-mbp>
 <20200304132439.6abadbe3@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304132439.6abadbe3@kicinski-fedora-PC1C0HJN>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 01:24:39PM -0800, Jakub Kicinski wrote:
> On Wed, 4 Mar 2020 12:45:07 -0800 Alexei Starovoitov wrote:
> > On Wed, Mar 04, 2020 at 11:41:58AM -0800, Jakub Kicinski wrote:
> > > On Tue, 3 Mar 2020 20:36:45 -0800 Alexei Starovoitov wrote:  
> > > > > > libxdp can choose to pin it in some libxdp specific location, so other
> > > > > > libxdp-enabled applications can find it in the same location, detach,
> > > > > > replace, modify, but random app that wants to hack an xdp prog won't
> > > > > > be able to mess with it.    
> > > > > 
> > > > > What if that "random app" comes first, and keeps holding on to the link
> > > > > fd? Then the admin essentially has to start killing processes until they
> > > > > find the one that has the device locked, no?    
> > > > 
> > > > Of course not. We have to provide an api to make it easy to discover
> > > > what process holds that link and where it's pinned.  
> > > 
> > > That API to discover ownership would be useful but it's on the BPF side.  
> > 
> > it's on bpf side because it's bpf specific.
> > 
> > > We have netlink notifications in networking world. The application
> > > which doesn't want its program replaced should simply listen to the
> > > netlink notifications and act if something goes wrong.  
> > 
> > instead of locking the bike let's setup a camera and monitor the bike
> > when somebody steals it.
> > and then what? chase the thief and bring the bike back?
> 
> :) Is the bike the BPF program? It's more like thief is stealing our
> parking spot, we still have the program :)

yeah. parking spot is a better analogy.

> Maybe also the thief should not have CAP_ADMIN in the first place?
> And ask a daemon to perform its actions..

a daemon idea keeps coming back in circles.
With FD-based kprobe/uprobe/tracepoint/fexit/fentry that problem is gone,
but xdp, tc, cgroup still don't have the owner concept.
Some people argued that these three need three separate daemons.
Especially since cgroups are mainly managed by systemd plus container
manager it's quite different from networking (xdp, tc) where something
like 'networkd' might makes sense.
But if you take this line of thought all the ways systemd should be that
single daemon to coordinate attaching to xdp, tc, cgroup because
in many cases cgroup and tc progs have to coordinate the work.
At that's where it's getting gloomy... unless the kernel can provide
a facility so central daemon is not necessary.

> > current xdp, tc, cgroup apis don't have the concept of the link
> > and owner of that link.
> 
> Why do the attachment points have to have a concept of an owner and 
> not the program itself?

bpf program is an object. That object has an owner or multiple owners.
A user process that holds a pointer to that object is a shared owner.
FD is such pointer. FD == std::shared_ptr<bpf_prog>.
Holding that pointer guarantees that <bpf_prog> will not disappear,
but it says nothing that the program will keep running.
For [ku]probe,tp,fentry,fexit there was always <bpf_link> in the kernel.
It wasn't that formal in the past until most recent Andrii's patches,
but the concept existed for long time. FD == std::shared_ptr<bpf_link>
connects a kernel object with <bpf_prog>. When that kernel objects emits
an event the <bpf_link> guarantees that <bpf_prog> will be executed.

For cgroups we don't have such concept. We thought that three attach modes we
introduced (default, allow-override, allow-multi) will cover all use cases. But
in practice turned out that it only works when there is a central daemon for
_all_ cgroup-bpf progs in the system otherwise different processes step on each
other. More so there has to be a central diff-review human authority otherwise
teams step on each other. That's sort-of works within one org, but doesn't
scale.

To avoid making systemd a central place to coordinate attaching xdp, tc, cgroup
progs the kernel has to provide a mechanism for an application to connect a
kernel object with a prog and hold the ownership of that link so that no other
process in the system can break that connection. That kernel object is cgroup,
qdisc, netdev. Interesting question comes when that object disappears. What to
do with the link? Two ways to solve it:
1. make link hold the object, so it cannot be removed.
2. destroy the link when object goes away.
Both have pros and cons as I mentioned earlier.
And that's what's to be decided.
I think the truth is somewhat in the middle. The link has to hold the object,
so it doesn't disappear from under it, but get notified on deletion, so the
link can be self destroyed. From the user point of view the execution guarantee
is still preserved. The kernel object was removed and the link has one dangling
side. Note this behavior is vastly different from existing xdp, tc, cgroup
behavior where both object and bpf prog can be alive, but connection is gone
and execution guarantee is broken.
