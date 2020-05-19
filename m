Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242991D8FB9
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 08:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgESGE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 02:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgESGE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 02:04:57 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEF8C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 23:04:57 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id e18so13267217iog.9
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 23:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=PmkkoBE9F37XiH2WUE6VHmaYBPZRIHMeshcVpYpJIyI=;
        b=pj/GLVmS9CiAIUcqJGDBtIVPeG3hTVZZNGuKPnd+0uZULgpi+iWWJWuVzaGpZJZtXi
         C+YFOWZXbtqtiWxYMR0dk7ah+P+fCzTb3Woa1z5wviM1lQ9ufYZ9zZRI60MGr4btksgo
         KYCTRP1YVxYs+5ROaiDw8QGAdNKYG9tuqj7KUUec06neBa44M3ezy69OFHu0w8rvBBjT
         WQbqBhmW0MCZ98CN3/mkccRFeF9+nzUV22cp3Mpfr4FK/kDW0eH7H257nAcJ6XwYzHJT
         GIbvL+VVOWvYzIPwaGg0udjoLiuqj3cri5LrrhvDCh1IeC5E+DMFtvgv4Qdu8mkIUxc5
         QImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=PmkkoBE9F37XiH2WUE6VHmaYBPZRIHMeshcVpYpJIyI=;
        b=cPF44qRU0po4OUsmh16g31JMyD5121cQsFFyJFYmd4jtRhHUN/CZihCuj+CSbjPYBx
         v0D4OG9MDWmn3ncrN5FZVd4QAA7oC+DMUB5YjUY6CGMBn02cdJpZRdywfsedlDHn5Dbk
         1QzmPu+bD9xbVddUHbhvEDTq1IAcFX5Pmmmh3dcUcpv335KnuGnpPWWgDFt9w17PC1iO
         MFYKV0Trzy6wePp2BahCTtVvynNufjnjszl3vhXsnHQw8tkHHG0xD0ZDOEOI9WkQSAML
         vNimtJFRaxhkl3VzGJDM1Zx4OoGgkygz+jnrxpNi7Caoge4tI3fa4TOl5eTpy5rXUy3m
         xzPQ==
X-Gm-Message-State: AOAM533Sxc4bulubsT3eIwA5t8xfY+7bwg6ueezHAo/00WslmdtTpmUt
        anz/yrg7FmIjZom2ec0hA6M=
X-Google-Smtp-Source: ABdhPJy92nQFHvYHzDK8kEsEESldsqrVx3uRG2GvIK+xaGy3u0ftnVWf60jK6D5kALrRGAQketo/9g==
X-Received: by 2002:a02:9462:: with SMTP id a89mr15038787jai.127.1589868296563;
        Mon, 18 May 2020 23:04:56 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a17sm3858241ilr.68.2020.05.18.23.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 23:04:55 -0700 (PDT)
Date:   Mon, 18 May 2020 23:04:47 -0700
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
Message-ID: <5ec376ff1680_2e852b10123785b4ae@john-XPS-13-9370.notmuch>
In-Reply-To: <cdd04862-dafd-080e-e90e-5161e568bac3@gmail.com>
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk>
 <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
 <5ebf1d9cdc146_141a2acf80de25b892@john-XPS-13-9370.notmuch>
 <2148cc16-4988-5866-cb64-0a4f3d290a23@gmail.com>
 <5ec2cfa49a8d7_1c562afa67bea5b47c@john-XPS-13-9370.notmuch>
 <cdd04862-dafd-080e-e90e-5161e568bac3@gmail.com>
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
> On 5/18/20 12:10 PM, John Fastabend wrote:
> >>
> >> host ingress to VM is one use case; VM to VM on the same host is another.
> > 
> > But host ingress to VM would still work with tail calls because the XDP
> > packet came from another XDP program. At least that is how I understand
> > it.
> > 
> > VM to VM case, again using tail calls on the sending VM ingress hook
> > would work also.
> 
> understood. I realize I can attach the program array all around, I just
> see that as complex control plane / performance hit depending on how the
> programs are wired up.
> 

Hard to argue with out a specific program. I think it could go either way.
I'll concede the control plane might be more complex but not so convinced
about performance. Either way having a program attached to the life cycle
of the VM seems like something that would be nice to have. In the tc skb
case if we attach to a qdisc it is removed automatically when the device
is removed. Having something similar for xdp is probably a good thing.

Worth following up in Daniel's thread. Another way to do that instead of
having the program associated with the ifindex is to have it associated
with the devmap entry. Basically when we add an entry in the devmap if
we had a program fd associated with it they could both be released when
the devmap entry is removed. This will happen automatically if the ifindex
is removed. But, rather than fragment threads too much I'll wait for
Daniel's reply.

> >>
> >> With respect to lifecycle management of the programs and the data,
> >> putting VM specific programs and maps on VM specific taps simplifies
> >> management. VM terminates, taps are deleted, programs and maps
> >> disappear. So no validator thread needed to handle stray data / programs
> >> from the inevitable cleanup problems when everything is lumped into 1
> >> program / map or even array of programs and maps.
> > 
> > OK. Also presumably you already have a hook into this event to insert
> > the tc filter programs so its probably a natural hook for mgmt.
> 
> For VMs there is no reason to have an skb at all, so no tc filter program.

+1 nice win for sure.

> 
> > 
> >>
> >> To me the distributed approach is the simplest and best. The program on
> >> the host nics can be stupid simple; no packet parsing beyond the
> >> ethernet header. It's job is just a traffic demuxer very much like a
> >> switch. All VM logic and data is local to the VM's interfaces.
> > 
> > IMO it seems more natural and efficient to use a tail call. But, I
> > can see how if the ingress program is a l2/l3 switch and the VM hook
> > is a l2/l3 filter it feels more like a switch+firewall layout we
> > would normally use on a "real" (v)switch. Also I think the above point
> > where cleanup is free because of the tap tear down is a win.
> 
> exactly. To the VM. the host is part of the network. The host should be
> passing the packets as fast and as simply as possible from ingress nic
> to vm. It can be done completely as xdp frames and doing so reduces the
> CPU cycles per packet in the host (yes, there are caveats to that
> statement).
> 
> VM to host nic, and VM to VM have their own challenges which need to be
> tackled next.
> 
> But the end goal is to have all VM traffic touched by the host as xdp
> frames and without creating a complex control plane. The distributed
> approach is much simpler and cleaner - and seems to follow what Cilium
> is doing to a degree, or that is my interpretation of

+1 agree everything as xdp pkt is a great goal.

> 
> "By attaching to the TC ingress hook of the host side of this veth pair
> Cilium can monitor and enforce policy on all traffic exiting a
> container. By attaching a BPF program to the veth pair associated with
> each container and routing all network traffic to the host side virtual
> devices with another BPF program attached to the tc ingress hook as well
> Cilium can monitor and enforce policy on all traffic entering or exiting
> the node."
> 
> https://docs.cilium.io/en/v1.7/architecture/

In many configurations there are no egress hooks though because policy (the
firewall piece) is implemented as part of the ingress hook. Because the
ingress TC hook "knows" where it will redirect a packet it can also run
the policy logic for that pod/VM/etc.
