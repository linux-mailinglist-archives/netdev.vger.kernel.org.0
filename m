Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E62425D1B8
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfGBO1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:27:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42502 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfGBO1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 10:27:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id x17so18061281wrl.9
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 07:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EvUD0G7ZLwM85um29w40yj3BLaLrf8+fkprze7AgXNg=;
        b=DrpE3UpNbWUGjDYvTqLX3fvgMdTrRLaxHJLpNBeQZU7wzjche41R79xGFkswL8KoPY
         zVSzzUZv5rfcljAXNiFx7suJ7R/xmVM/zaPGOLwYNMyUPF1s0Q1+R1vGLKZDaA2o8PCt
         IPh7RBd7m4PGlp5POrk1oLrfn5CJOSBQgIjgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EvUD0G7ZLwM85um29w40yj3BLaLrf8+fkprze7AgXNg=;
        b=sAoYrSXX9B48qFEMvxdimbPhLMaSVEqVaG0a3p9ZPcx1pjhMulgP3T75BhN2H4QeZ6
         FNM9MSo/FPQA1HN2cK7ZroTu+2ZT5YjWygH/KPNuikfuvM2iWvuyCEQuwSmDl9pzffis
         UA7Xuwj6yHekvm7iGPXxucYSDD9Kie7cHyQk3fj5YFNUi5CqFLSGspA4pFa4bSVnc82l
         JQTFYfZwwGpahHTUNFMo8q44AEUYrwn9UY51Ym2dkZ1fat2R1yFlABBn1p2wCCgGVfYq
         2rX1XoPimPSZXlSIPI7dtuR6GMbQi8WFvJmbsimr/yjQMr1iAeziLDjbk1t6+qOfU+dz
         gQaw==
X-Gm-Message-State: APjAAAWYxbkDcE/nY9PDKeTsJpuYUX8xcA4KlzS8oEsI4UlDKpggeDaB
        l/LtHKNvQaZkBgdL3yU58magUQ==
X-Google-Smtp-Source: APXvYqxh4w3loFivtXTdoyivP+vj02ZyRUER9CIjkB7eqjStukVyHFTwuU3SE6szdCB0CMJhrLhD3Q==
X-Received: by 2002:a5d:5386:: with SMTP id d6mr16098031wrv.207.1562077652079;
        Tue, 02 Jul 2019 07:27:32 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id o11sm2203164wmh.37.2019.07.02.07.27.30
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 07:27:31 -0700 (PDT)
Subject: Re: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        Ido Schimmel <idosch@idosch.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ido Schimmel <idosch@mellanox.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, b.a.t.m.a.n@lists.open-mesh.org
References: <20190620235639.24102-1-vivien.didelot@gmail.com>
 <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
 <20190621172952.GB9284@t480s.localdomain> <20190623070949.GB13466@splinter>
 <20190623072605.2xqb56tjydqz2jkx@shell.armlinux.org.uk>
 <20190623074427.GA21875@splinter> <20190629162945.GB17143@splinter>
 <20190630165601.GC2500@otheros>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <da75f439-87fb-6e77-4042-a95953f92f75@cumulusnetworks.com>
Date:   Tue, 2 Jul 2019 17:27:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190630165601.GC2500@otheros>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/06/2019 19:56, Linus Lüssing wrote:
> On Sat, Jun 29, 2019 at 07:29:45PM +0300, Ido Schimmel wrote:
>> I would like to avoid having drivers take the querier state into account
>> as it will only complicate things further.
> 
> I absolutely share your pain. Initially in the early prototypes of
> multicast awareness in batman-adv we did not consider the querier state.
> And doing so later did indeed complicate the code a good bit in batman-adv
> (together with the IGMP/MLD suppression issues). I would have loved to
> avoid that.
> 
> 
>> Is there anything we can do about it? Enable the bridge querier if no
>> other querier was detected? Commit c5c23260594c ("bridge: Add
>> multicast_querier toggle and disable queries by default") disabled
>> queries by default, but I'm only suggesting to turn them on if no other
>> querier was detected on the link. Do you think it's still a problem?
> 
> As soon as you start becoming the querier, you will not be able to reliably
> detect anymore whether you are the only querier candidate.
> 
> If any random Linux host using a bridge device were potentially becoming
> a querier, that would cause quite some trouble when this host is
> behind some bad, bottleneck connection. This host will receive
> all multicast traffic, not just IGMP/MLD reports. And with a
> congested connection and then unreliable IGMP/MLD, multicast would
> become unreliable overall in this domain. So it's important that
> your querier is not running in the "dark, remote, dusty closet" of
> your network (topologically speaking).
> 

+1
We definitely don't want random hosts becoming queriers

>> On Sun, Jun 23, 2019 at 10:44:27AM +0300, Ido Schimmel wrote:
>>> See commit b00589af3b04 ("bridge: disable snooping if there is no
>>> querier"). I think that's unfortunate behavior that we need because
>>> multicast snooping is enabled by default. If it weren't enabled by
>>> default, then anyone enabling it would also make sure there's a querier
>>> in the network.
> 
> I do not quite understand that point. In a way, that's what we
> have right now, isn't it? By default it's disabled, because by
> default there is no querier on the link. So anyone wanting to use
> multicast snooping will need to make sure there's a querier in the
> network.
> 

Indeed, also you could create the bridge with explicit mcast parameters if you need
different behaviour on start. Unfortunately I think you'll have to handle
the querier state.

> 
> Overall I think the querier (election) mechanism in the standards could
> need an update. While the lowest-address first might have
> worked well back then, in uniform, fully wired networks where the
> position of the querier did not matter, this is not a good
> solution anymore in networks involving wireless, dynamic connections.
> Especially in wireless mesh networks this is a bit of an issue for
> us. Ideally, the querier mechanism were dismissed in favour of simply
> unsolicited, periodic IGMP/MLD reports...
> 
> But of course, updating IETF standards is no solution for now. 
> 
> While more complicated, it would not be impossible to consider the
> querier state, would it? I mean you probably already need to
> consider the case of a user disabling multicast snooping during
> runtime, right? So similarly, you could react to appearing or
> disappearing queriers?
> 
> Cheers, Linus
> 

Thanks,
 Nik
