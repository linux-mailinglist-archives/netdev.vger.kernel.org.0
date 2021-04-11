Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C3035B778
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 01:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbhDKXyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 19:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbhDKXyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 19:54:19 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C42C061574;
        Sun, 11 Apr 2021 16:54:02 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u17so17331344ejk.2;
        Sun, 11 Apr 2021 16:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uY6yvdhoZ+7M6T+5z0FE+cEKikS3Y5VFSZo8V/ntV1g=;
        b=VudhNGbntpzfQhhmSVGUnJIw4lnugzRbeOLvkP6jLWhe3MjjCil087x74PTPuCN7Mk
         on0destlzKhLPsejnTVVMk8nV3T5qFxYWcmJd+gpY2z60a+0xh4P8ITHys9ZeJZ855cI
         bGx6m+v3KcE+2WDc+bWVRAgQBXfWXsud018XetTwCnCYwuuaLRM1Z5rgDVHEi5wExxHr
         B6Jg/VAcagqAQ5lIi6XyuZIXf8IBzOur7C3IdIKdqh9RS7/mjVJwASGlGV/I/Xgz8D0u
         7k8yefyiTJMiJduxrq0KM0CI7MK8untCjlxqdPe9l/X/92cve7ljc6TmvQQGBqLWcVF2
         lIyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uY6yvdhoZ+7M6T+5z0FE+cEKikS3Y5VFSZo8V/ntV1g=;
        b=otl1q6nE+KFFKqx/VZqcRdxRXyiR9+hVLuXTumpcIuB3a+GoFu5XOWK9BlqgTvQEbO
         rexwEYbyDysXrbChyKlr8PIGraFREveP2GupqbnLtTk/xiVNB8in5YtNX/wvPCYPvcfm
         dk6d8IG4w6Vlb0op+A6yyEwDKjwl3XM8WDZ2XoTp0HlEpxmaQazfLOhIXCB9H1bAMzhD
         HTPj9EQkCrRJozZa+fBdd6/XubVBry2VbAJWtRVn/2kn2TtA5z1M9QhbeAD1rRv8J/uL
         uIIOpoYdyLJfHdX2MlpwTlRU9BmoTDJWXwIbYYGDqoSNWhNiiusvzz5pKTmMoYon9WSq
         mcYg==
X-Gm-Message-State: AOAM533I+n6IC+Xv9jLwVShV06p2H6WSBWaV9t6ns97YACREyzqv2Jff
        SnrrvooRtTq/+Yo0/BpWxEI=
X-Google-Smtp-Source: ABdhPJyu3abjgucUVGguj2fQSDw0feI0Xtdcjki0UWxGFQSijKNH5PJdVvHi0aVb17Hag57XY9RNPg==
X-Received: by 2002:a17:907:2485:: with SMTP id zg5mr7983661ejb.43.1618185241484;
        Sun, 11 Apr 2021 16:54:01 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id c16sm4723539ejx.81.2021.04.11.16.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 16:54:00 -0700 (PDT)
Date:   Mon, 12 Apr 2021 02:53:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20210411235358.vpql2mppobjhknfg@skbuf>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
 <20210411200135.35fb5985@thinkpad>
 <20210411185017.3xf7kxzzq2vefpwu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210411185017.3xf7kxzzq2vefpwu@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 09:50:17PM +0300, Vladimir Oltean wrote:
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
> > 
> > What do you guys think?
> 
> The reason why I don't think this is such a great idea is because the
> CPU port assignment is a major reconfiguration step which should at the
> very least be done while the network is down, to avoid races with the
> data path (something which this series does not appear to handle).
> And if you allow the static user-port-to-CPU-port assignment to change
> every time a link goes up/down, I don't think you really want to force
> the network down through the entire switch basically.
> 
> So I'd be tempted to say 'tough luck' if all your ports are not up, and
> the ones that are are assigned statically to the same CPU port. It's a
> compromise between flexibility and simplicity, and I would go for
> simplicity here. That's the most you can achieve with static assignment,
> just put the CPU ports in a LAG if you want better dynamic load balancing
> (for details read on below).

Just one more small comment, because I got so carried away with
describing what I already had in mind, that I forgot to completely
address your idea.

I think that DSA should provide the means to do what you want but not
the policy. Meaning that you can always write a user space program that
monitors the NETLINK_ROUTE rtnetlink through a socket and listens for
link state change events on it with poll(), then does whatever (like
moves the static user-to-CPU port mapping in the way that is adequate to
your network's requirements). The link up/down events are already
emitted, and the patch set here gives user space the rope to hang itself.

If you need inspiration, one user of the rtnetlink socket that I know of
is ptp4l:
https://github.com/richardcochran/linuxptp/blob/master/rtnl.c
