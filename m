Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B254E1D8442
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 20:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733047AbgERSK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 14:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732979AbgERSKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 14:10:55 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E71DC05BD09
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 11:10:55 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f4so11618308iov.11
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 11:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=w3PcIuoE+UYdqtbKWOyNWqo5WYCCkMtjBoB3uATICjA=;
        b=UdKlxDEljHFk2reIZ/PtTXpjvTWiS42HlYkH2paVgxTR3HVwOSMUseIaT2V3s8CFFw
         ziEX8aUeYTnF4p+TX8KUqEYZ/XJvr44PcFzAmDWsR1jzK0PcF23Cf9PVfwkVTE3sPO/k
         zF8csa5FbYAX655izKwjaL8KBMIQIKhXrUeYpxSklf5/tC4i00g9rqI0Y1W8s4h+FlOB
         f/1i8vPFrSz2OeRJkP6QMpWqZ8FJGG8yFe0YiPx/nCMRxky3KN6f72lhFjocYFQa5zMM
         CgUUKZPA+ZDKlDN22B3Sq3Qo1D1OQOuUE+O6U2GMU+ETWY+gdiMWDSs51wYdU1hRP4mJ
         QUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=w3PcIuoE+UYdqtbKWOyNWqo5WYCCkMtjBoB3uATICjA=;
        b=eSNOKWuyNqUX7FHO35UuAGUeae8vlcnqjPGt/R5oy7SqpUjTJywKGKKzNgPrKDc3cp
         Q+bDtY4A73gVHDeHGHmlsUS8s8UW+WMM0VMMvbnXKlRrvyozO2fQd4keHe7Dl+e0OEVz
         TitH/C3Mfbr60M3Xu5I17l2nYU5AA1T75/LG0nLFQXa2HkAUKiCJTRR2xIw0fGUFH84l
         lfHLKTvtNkztWzNDvBmkaSKxq17HuYi3NrIt3JrmPDzE8S5MLLVhriuwA65T1HNmj9g5
         e9j/6paxnhH7i9nNbp+P8HGV2sQVNMVKRjJC1Nx9ovDWpG+Rm0PsBAMj1fm+WV2jRFjg
         RGvg==
X-Gm-Message-State: AOAM531OqOwK/sgKTgJDXyZr9I6IV/9jcP/nJ7ezLFbxNGnfV++Q48aW
        sWJqYpfzlqirH+KGpIfPr2M=
X-Google-Smtp-Source: ABdhPJwUg8d+BY6rrFxK62tC3+ITkwUiqP9+KKMYA4sP4+UnccYRyw7jPiaka0LNf8YelJZJzswHfg==
X-Received: by 2002:a02:58c3:: with SMTP id f186mr17363954jab.120.1589825454381;
        Mon, 18 May 2020 11:10:54 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b18sm628203ilh.77.2020.05.18.11.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 11:10:53 -0700 (PDT)
Date:   Mon, 18 May 2020 11:10:44 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        daniel@iogearbox.net, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Message-ID: <5ec2cfa49a8d7_1c562afa67bea5b47c@john-XPS-13-9370.notmuch>
In-Reply-To: <2148cc16-4988-5866-cb64-0a4f3d290a23@gmail.com>
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk>
 <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
 <5ebf1d9cdc146_141a2acf80de25b892@john-XPS-13-9370.notmuch>
 <2148cc16-4988-5866-cb64-0a4f3d290a23@gmail.com>
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern wrote:
> On 5/15/20 4:54 PM, John Fastabend wrote:
> > Hi David,
> > 
> > Another way to set up egress programs that I had been thinking about is to
> > build a prog_array map with a slot per interface then after doing the
> > redirect (or I guess the tail call program can do the redirect) do the
> > tail call into the "egress" program.
> > 
> > From a programming side this would look like,
> > 
> > 
> >   ---> ingress xdp bpf                BPF_MAP_TYPE_PROG_ARRAY
> >          redirect(ifindex)            +---------+
> >          tail_call(ifindex)           |         |
> >                       |               +---------+
> >                       +-------------> | ifindex | 
> >                                       +---------+
> >                                       |         |
> >                                       +---------+
> > 
> > 
> >          return XDP_REDIRECT
> >                         |
> >                         +-------------> xdp_xmit
> > 
> > 
> > The controller would then update the BPF_MAP_TYPE_PROG_ARRAY instead of
> > attaching to egress interface itself as in the series here. I think it
> > would only require that tail call program return XDP_REDIRECT so the
> > driver knows to follow through with the redirect. OTOH the egress program
> > can decide to DROP or PASS as well. The DROP case is straight forward,
> > packet gets dropped. The PASS case is interesting because it will cause
> > the packet to go to the stack. Which may or may not be expected I guess.
> > We could always lint the programs or force the programs to return only
> > XDP_REDIRECT/XDP_PASS from libbpf side.
> > 
> > Would there be any differences from my example and your series from the
> > datapath side? I think from the BPF program side the only difference
> > would be return codes XDP_REDIRECT vs XDP_PASS. The control plane is
> > different however. I don't have a good sense of one being better than
> > the other. Do you happen to see some reason to prefer native xdp egress
> > program types over prog array usage?
> 
> host ingress to VM is one use case; VM to VM on the same host is another.

But host ingress to VM would still work with tail calls because the XDP
packet came from another XDP program. At least that is how I understand
it.

VM to VM case, again using tail calls on the sending VM ingress hook
would work also.

> 
> > 
> > From performance side I suspect they will be more or less equivalant.
> > 
> > On the positive side using a PROG_ARRAY doesn't require a new attach
> > point. A con might be right-sizing the PROG_ARRAY to map to interfaces?
> > Do you have 1000's of interfaces here? Or some unknown number of
> 
> 1000ish is probably the right ballpark - up to 500 VM's on a host each
> with a public and private network connection. From there each interface
> can have their own firewall (ingress and egress; most likely VM unique
> data, but to be flexible potentially different programs e.g., blacklist
> vs whitelist). Each VM will definitely have its own network data - mac
> and network addresses, and since VMs are untrusted packet validation in
> both directions is a requirement.

Understood and makes sense.

> 
> With respect to lifecycle management of the programs and the data,
> putting VM specific programs and maps on VM specific taps simplifies
> management. VM terminates, taps are deleted, programs and maps
> disappear. So no validator thread needed to handle stray data / programs
> from the inevitable cleanup problems when everything is lumped into 1
> program / map or even array of programs and maps.

OK. Also presumably you already have a hook into this event to insert
the tc filter programs so its probably a natural hook for mgmt.

> 
> To me the distributed approach is the simplest and best. The program on
> the host nics can be stupid simple; no packet parsing beyond the
> ethernet header. It's job is just a traffic demuxer very much like a
> switch. All VM logic and data is local to the VM's interfaces.

IMO it seems more natural and efficient to use a tail call. But, I
can see how if the ingress program is a l2/l3 switch and the VM hook
is a l2/l3 filter it feels more like a switch+firewall layout we
would normally use on a "real" (v)switch. Also I think the above point
where cleanup is free because of the tap tear down is a win.

> 
> 
> > interfaces? I've had building resizable hash/array maps for awhile
> > on my todo list so could add that for other use cases as well if that
> > was the only problem.
> > 
> > Sorry for the late reply it took me a bit of time to mull over the
> > patches.
> > 
> > Thanks,
> > John
> > 

Pulling in below because I think it was for me.

> I am trying to understand the resistance here. There are ingress/egress
> hooks for most of the layers - tc, netfilter, and even within bpf APIs.
> Clearly there is a need for this kind of symmetry across the APIs, so
> why the resistance or hesitation for XDP?

Because I don't see it as necessary and it adds another xdp interface. I
also didn't fully understand why it would be useful.

> 
> Stacking programs on the Rx side into the host was brought up 9
> revisions ago when the first patches went out. It makes for an
> unnecessarily complicated design and is antithetical to the whole
> Unix/Linux philosophy of small focused programs linked together to
> provide a solution.

I know it was brought up earlier and at the time the hook was also being
used for skbs. This sort of convinced me it was different from the tail
call example. Once skbs usage become impractical it seems like the
same datapath can be implemented with xdp+prog_array. As I understand
it this is still the case. The datapath could be implemented as a set
of xdp+prog_array hooks but the mgmt life-cycle is different and also
the mental model is a bit different. At least the mental model of the
BPF developer has to be different.

> Can you elaborate on your concerns?

Just understanding the use case.

My summary is the series gives us a few nice things (a) allows control
plane to be simpler because programs will not need to be explicitly
garbage collected, (b) we don't have to guess a right-size for a
program array map because we don't have to manage a map at all, and
(c) helps bpf programmers mental model by using separate attach points
for each function.

I can see how (a) and (b) will be useful so no objections from my
side to merge the series.
