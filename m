Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7D235C404
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbhDLKbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 06:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238970AbhDLKba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 06:31:30 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11097C061574;
        Mon, 12 Apr 2021 03:31:12 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id sd23so10749491ejb.12;
        Mon, 12 Apr 2021 03:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EGiA9WNNtPc3+NS/6kdbcDSHvt+XlVdb8Hnww0GQLWw=;
        b=HEgI8G6ADeyHpKGzLw4Wny6LdPxHZMvswc8guL88pCcCgHGVLIVK8KhA9ornowNPGF
         w1wSlbql/TPryQmP47gEJh1rydP+nMf4zeEtoNp7WQIzzan3KB6hGqvJhtV2Xh4no+F8
         1twmPxLwoB4rW6u1Z6QX8gvDmVag+ihlk4uM44dXwPg3/slr+5WAdLl/0qOzSJUpb7cY
         izpyH1H8+yucfx15b57AujTUgOHQ6ZqIyW9JMMIinosAjXLOPrw/6pczMadKx4RNDEZH
         FlQ+Ds5b+A8CHshpzKqXoLkk513EkKXeQBkyYv1mec0u3k6Wq3sZnQNFg06vKJiO37sI
         zC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EGiA9WNNtPc3+NS/6kdbcDSHvt+XlVdb8Hnww0GQLWw=;
        b=Go3GUrDEiySSxXNHY6Oh+8onpXg9TZEj3jBKbpwl6h/3eIl3HR8jFp7x7PxwVGD0H1
         hPWGUkwA3AJw7VdoFTIJP0/qH9BtKTLt9HI+HswdwQ6hTzqtKjRmVcjnb9G4Hyg0QEEX
         4fwyZAMzswVkM8+FFsBfFHnvyZUWw26PVHRpGiCQIQoH4xqFTyQf6/HeMdrU1Swyu9VF
         JFUT+Bm3vTmI/yVQJv+iRfbCNIqmrC4FHAWUomCTSrVZf58kTCzTq3OSNQ8mESDBVVtZ
         EO9ZyvTAGkaq/SPOa6OYMQ/20y5F1EYhfGGzQGBg61Ao1qMQq1wOOchqHMCC5NMvZqK3
         TP1w==
X-Gm-Message-State: AOAM533TieK2QO9e8YZievpP3jLN8yM7gS8EFksbZm1d8BSj3pA59ZEg
        Dz/TZev8GUU+kPiIRTnQDw8=
X-Google-Smtp-Source: ABdhPJy7UBj4q+DvQwXKRoDAy0S48SlayaYgb0EAfcwKCvFak61Jet3zUyd3fC4bpH2uKHiuBQ7qLw==
X-Received: by 2002:a17:906:2509:: with SMTP id i9mr3939604ejb.117.1618223470621;
        Mon, 12 Apr 2021 03:31:10 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-79-34-220-97.business.telecomitalia.it. [79.34.220.97])
        by smtp.gmail.com with ESMTPSA id w22sm6379565edl.92.2021.04.12.03.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 03:31:10 -0700 (PDT)
Date:   Mon, 12 Apr 2021 06:53:04 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek Behun <marek.behun@nic.cz>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <YHPSMMeOtnLNJPWm@Ansuel-xps.localdomain>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
 <20210411200135.35fb5985@thinkpad>
 <YHNCUDJrz7ISiLVT@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHNCUDJrz7ISiLVT@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 08:39:12PM +0200, Andrew Lunn wrote:
> On Sun, Apr 11, 2021 at 08:01:35PM +0200, Marek Behun wrote:
> > On Sat, 10 Apr 2021 15:34:46 +0200
> > Ansuel Smith <ansuelsmth@gmail.com> wrote:
> > 
> > > Hi,
> > > this is a respin of the Marek series in hope that this time we can
> > > finally make some progress with dsa supporting multi-cpu port.
> > > 
> > > This implementation is similar to the Marek series but with some tweaks.
> > > This adds support for multiple-cpu port but leave the driver the
> > > decision of the type of logic to use about assigning a CPU port to the
> > > various port. The driver can also provide no preference and the CPU port
> > > is decided using a round-robin way.
> > 
> > In the last couple of months I have been giving some thought to this
> > problem, and came up with one important thing: if there are multiple
> > upstream ports, it would make a lot of sense to dynamically reallocate
> > them to each user port, based on which user port is actually used, and
> > at what speed.
> > 
> > For example on Turris Omnia we have 2 CPU ports and 5 user ports. All
> > ports support at most 1 Gbps. Round-robin would assign:
> >   CPU port 0 - Port 0
> >   CPU port 1 - Port 1
> >   CPU port 0 - Port 2
> >   CPU port 1 - Port 3
> >   CPU port 0 - Port 4
> > 
> > Now suppose that the user plugs ethernet cables only into ports 0 and 2,
> > with 1, 3 and 4 free:
> >   CPU port 0 - Port 0 (plugged)
> >   CPU port 1 - Port 1 (free)
> >   CPU port 0 - Port 2 (plugged)
> >   CPU port 1 - Port 3 (free)
> >   CPU port 0 - Port 4 (free)
> > 
> > We end up in a situation where ports 0 and 2 share 1 Gbps bandwidth to
> > CPU, and the second CPU port is not used at all.
> > 
> > A mechanism for automatic reassignment of CPU ports would be ideal here.
> 
> One thing you need to watch out for here source MAC addresses. I've
> not looked at the details, so this is more a heads up, it needs to be
> thought about.
>
> DSA slaves get there MAC address from the master interface. For a
> single CPU port, all the slaves have the same MAC address. What
> happens when you have multiple CPU ports? Does the slave interface get
> the MAC address from its CPU port? What happens when a slave moves
> from one CPU interface to another CPU interface? Does its MAC address
> change. ARP is going to be unhappy for a while? Also, how is the
> switch deciding on which CPU port to use? Some switches are probably
> learning the MAC address being used by the interface and doing
> forwarding based on that. So you might need unique slave MAC
> addresses, and when a slave moves, it takes it MAC address with it,
> and you hope the switch learns about the move. But considered trapped
> frames as opposed to forwarded frames. So BPDU, IGMP, etc. Generally,
> you only have the choice to send such trapped frames to one CPU
> port. So potentially, such frames are going to ingress on the wrong
> port. Does this matter? What about multicast? How do you control what
> port that ingresses on? What about RX filters on the master
> interfaces? Could it be we added it to the wrong master?
> 

I think that MAC adress should be changed accordingly. If the port
doesn't have a custom mac set, it should follow the master mac and be
changed on port change. (Since this is an RFC I didn't add any lock but
I think it's needed to change also the cpu_dp and the xmit path)

> For this series to make progress, we need to know what has been
> tested, and if all the more complex functionality works, not just
> basic pings.

About testing, I'm currently using this with a qca8k switch. It looks
like all works correctly but I agree that this needs better testing of
the more complex funcionality. Anyway this series just adds the
possibility of support and change cpu port but by default keeps the
old default bheaviour. (so in theory no regression in that part)

> 
>       Andrew
