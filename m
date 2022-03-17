Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1F64DC7AE
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 14:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbiCQNgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 09:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbiCQNf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 09:35:58 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B801DA8CC
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 06:34:41 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 25so7224978ljv.10
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 06:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=e7JdKBlCtJhhIKbeyWrRRpILPdPk5VmnP7z+lNgBwVo=;
        b=H2J5e8Gq3VTcZ1paS/Bmh6ddx9ZgehxfsqO/ma6Vxlsi8CA7tCoFrCISrLaa9jSADH
         MI4w24VplUhuND7wkXdlzPnpBtc8lpEpNVWMLPi+v3yrvvLyhP83wstfEc9owUg1MAGT
         cKwVIJ4tuzTX1TqUpqK8uYPkXinJXessZZSqmsiE8b2Bl4K8slUfue0kYssKomtSM0uD
         7SwIUwdzT1Hay2Fc1udI8eAz0QX88PK1zDX08S+aVyXd3fnwdMmXNqOI9BKB4OXKjX22
         G6XL3XlpQx2sITOhHi7AovUVZ4zMjHC+y5ndDXKK0N4SAF6QfrYrA5u9/XaaBp0OjtsA
         4k5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=e7JdKBlCtJhhIKbeyWrRRpILPdPk5VmnP7z+lNgBwVo=;
        b=u/EPh8PvNn7sHsJt8kgyF4Xj186XbL+D8haeaCYQjG7JJtxIjJcptBLGUSl3Ww/wTV
         YhRAWZ8bXXO4SblmOeTQ+qVfGyFNxkd683r285LkCn3GdLC/FXjxAqgd8bxDBmdnT1hO
         NC0vz4Syz3HucX4OG7FEKiBkAUPAhHdh4jb5TqulWhUWug6uBWEt/pqLxn+iElcFUIPQ
         ql3rRf3plFJXppeRTPf5fcKEUZnKhg8+qneX8Doq8RybtAz+i5z/RISn6+eGi3KSawIT
         2T8m3BiFrvEwx4KXgDoRixsZH1Uz9AN6sezI60wwZV8XdK3dbYQY+oGw+/Qs7+5/voId
         MDbw==
X-Gm-Message-State: AOAM530dE54koXyui/cSb/ES5nvC6mHJ1y9X21mDsiQyoJ+mpUqvjKeS
        AwRokj/4XkaCDxf0KqFw5M3tvg==
X-Google-Smtp-Source: ABdhPJzNnsYXBFGHWKosRoLjHjQAH2RKHYYb3kVKL10e7y1FleezOYYdsDcLWB14hVOfCjHIPC2tnQ==
X-Received: by 2002:a2e:3517:0:b0:247:f48a:7c35 with SMTP id z23-20020a2e3517000000b00247f48a7c35mr2827282ljz.217.1647524080196;
        Thu, 17 Mar 2022 06:34:40 -0700 (PDT)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id z1-20020a195e41000000b00448ac0a351csm451040lfi.211.2022.03.17.06.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 06:34:39 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH 2/5] net: bridge: Implement bridge flood flag
In-Reply-To: <YjMo9xyoycXgSWXS@shredder>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
 <20220317065031.3830481-3-mattias.forsblad@gmail.com>
 <87r1717xrz.fsf@gmail.com>
 <50f4e8b0-4eea-d202-383b-bf2c2824322d@gmail.com>
 <cf7af730-1f98-f845-038b-43104fa060cd@blackwall.org>
 <YjMo9xyoycXgSWXS@shredder>
Date:   Thu, 17 Mar 2022 14:34:38 +0100
Message-ID: <87r170k8i9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 14:26, Ido Schimmel <idosch@idosch.org> wrote:
> On Thu, Mar 17, 2022 at 01:42:55PM +0200, Nikolay Aleksandrov wrote:
>> On 17/03/2022 13:39, Mattias Forsblad wrote:
>> > On 2022-03-17 10:07, Joachim Wiberg wrote:
>> >> On Thu, Mar 17, 2022 at 07:50, Mattias Forsblad <mattias.forsblad@gmail.com> wrote:
>> >>> This patch implements the bridge flood flags. There are three different
>> >>> flags matching unicast, multicast and broadcast. When the corresponding
>> >>> flag is cleared packets received on bridge ports will not be flooded
>> >>> towards the bridge.
>> >>
>> >> If I've not completely misunderstood things, I believe the flood and
>> >> mcast_flood flags operate on unknown unicast and multicast.  With that
>> >> in mind I think the hot path in br_input.c needs a bit more eyes.  I'll
>> >> add my own comments below.
>> >>
>> >> Happy incident I saw this patch set, I have a very similar one for these
>> >> flags to the bridge itself, with the intent to improve handling of all
>> >> classes of multicast to/from the bridge itself.
>> >>
>> >>> [snip]
>> >>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>> >>> index e0c13fcc50ed..fcb0757bfdcc 100644
>> >>> --- a/net/bridge/br_input.c
>> >>> +++ b/net/bridge/br_input.c
>> >>> @@ -109,11 +109,12 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>> >>>  		/* by definition the broadcast is also a multicast address */
>> >>>  		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
>> >>>  			pkt_type = BR_PKT_BROADCAST;
>> >>> -			local_rcv = true;
>> >>> +			local_rcv = true && br_opt_get(br, BROPT_BCAST_FLOOD);
>> >>
>> >> Minor comment, I believe the preferred style is more like this:
>> >>
>> >> 	if (br_opt_get(br, BROPT_BCAST_FLOOD))
>> >>         	local_rcv = true;
>> >>
>> >>>  		} else {
>> >>>  			pkt_type = BR_PKT_MULTICAST;
>> >>> -			if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
>> >>> -				goto drop;
>> >>> +			if (br_opt_get(br, BROPT_MCAST_FLOOD))
>> >>> +				if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
>> >>> +					goto drop;
>> >>
>> >> Since the BROPT_MCAST_FLOOD flag should only control uknown multicast,
>> >> we cannot bypass the call to br_multicast_rcv(), which helps with the
>> >> classifcation.  E.g., we want IGMP/MLD reports to be forwarded to all
>> >> router ports, while the mdb lookup (below) is what an tell us if we
>> >> have uknown multicast and there we can check the BROPT_MCAST_FLOOD
>> >> flag for the bridge itself.
>> > 
>> > The original flag was name was local_receive to separate it from being
>> > mistaken for the flood unknown flags. However the comment I've got was
>> > to align it with the existing (port) flags. These flags have nothing to do with
>> > the port flood unknown flags. Imagine the setup below:
>> > 
>> >            vlan1
>> >              |
>> >             br0             br1
>> >            /   \           /   \
>> >          swp1 swp2       swp3 swp4
>> > 
>> > We want to have swp1/2 as member of a normal vlan filtering bridge br0 /w learning on. 
>> > On br1 we want to just forward packets between swp3/4 and disable learning. 
>> > Additional we don't want this traffic to impact the CPU. 
>> > If we disable learning on swp3/4 all traffic will be unknown and if we also 
>> > have flood unknown on the CPU-port because of requirements for br0 it will
>> > impact the traffic to br1. Thus we want to restrict traffic between swp3/4<->CPU port
>> > with the help of the PVT.
>> > 
>> > /Mattias
>> 
>> The feedback was correct and we all assumed unknown traffic control.
>> If you don't want any local receive then use filtering rules. Don't add unnecessary flags.
>
> Yep. Very easy with tc:
>
> # tc qdisc add dev br1 clsact
> # tc filter add dev br1 ingress pref 1 proto all matchall action drop
>
> This can be fully implemented inside the relevant device driver, no
> changes needed in the bridge driver.

Interesting. Are you saying that a switchdev driver can offload rules
for a netdev that it does not directly control (e.g. bridge that it is
connected to)? It thought that you had to bind the relevant ports to the
same block to approximate that. If so, are any drivers implementing
this? I did a quick scan of mlxsw, but could not find anything obvious.
