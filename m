Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD694DCAB1
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbiCQQEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236300AbiCQQEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:04:04 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A07321352A
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:02:46 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id s29so9731202lfb.13
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=KqSbW1jQevNaYgxLTZ1J9zqPO7M3Xn1F5ABmOMvHM1w=;
        b=BBxT7zMM9973f7zTKvA7frEw5bk4NQ3mVj+a98nMKXQE1yuR8hIunoeyym5ce5Jrre
         a+U1ghqyZQMexEPR4MG8zhX9ABZPadLllVU7IM15aPpaAVYWK0w01BvWP3A8d5AC+cX4
         fpL2paMR9IOWN7et5Pi609NRJnV3N9JZadAQFCIh2rMfLdmXnHdz5EMeJsNaz6FfkZvN
         xpkHfdYfk1VigTHUDenzSKEVcOLM9UEN23e4POsv4bshNkRlyh2+rSwq2HYybHSx52xR
         uVrNFWPDQpmmKG30oxdHwWnH5YfIcj1UN9Hm/HHoPxBBXUem38dT//MzkmZf6ErD4qqC
         LGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KqSbW1jQevNaYgxLTZ1J9zqPO7M3Xn1F5ABmOMvHM1w=;
        b=lfks9xTpi9nfuK0kLJATMpujq2rHYPV4UWuwOtvZPaFlyMtKEhQGgsNWtNUcbyggwh
         d7H0wlweEGNVEOMsPAGCfeBynWsKbpLD61D68TppDyHMQPCdwwkNSbqCXEOesZXFuEPH
         EATv/lcy3Z6vfgHqJfHhwI/l4CyzgEppb3i8F5M3okrLUMsZU4H25mY5IP8xRxI/6vw6
         jqwult0jvA8C3j7TJaiT4nWMnmzZyrKunUffP1+xuKv5YuDpDAxMHfJ/bfTh4ue3YZU2
         rn3i0us4L1EgwmtQpN83AFmWNnoh1/b5Q6neT5LuL4eE8XCMy203/qdLdq4uSh1OJOT/
         EoJw==
X-Gm-Message-State: AOAM533G4d+z5vAby+NLsLNbI1PaokzmdB9T1bagVI1w5sl1AmBLZ3v5
        BbQRa1Cz+zpUNS6hv5ALUxoZIg==
X-Google-Smtp-Source: ABdhPJyWoXmi4yd8mP/RD39Tjn8DW2fuYVj0gAcfHbLZ/Io+HaTCCoW9JtmbQojvlSJj2dAqmZmjcg==
X-Received: by 2002:a05:6512:21ac:b0:449:524b:585b with SMTP id c12-20020a05651221ac00b00449524b585bmr3490355lft.334.1647532964237;
        Thu, 17 Mar 2022 09:02:44 -0700 (PDT)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id k9-20020a05651210c900b00448956cb40csm479948lfg.109.2022.03.17.09.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 09:02:43 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH 2/5] net: bridge: Implement bridge flood flag
In-Reply-To: <YjNBWsAsOidtTtIB@shredder>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
 <20220317065031.3830481-3-mattias.forsblad@gmail.com>
 <87r1717xrz.fsf@gmail.com>
 <50f4e8b0-4eea-d202-383b-bf2c2824322d@gmail.com>
 <cf7af730-1f98-f845-038b-43104fa060cd@blackwall.org>
 <YjMo9xyoycXgSWXS@shredder> <87r170k8i9.fsf@waldekranz.com>
 <YjNBWsAsOidtTtIB@shredder>
Date:   Thu, 17 Mar 2022 17:02:42 +0100
Message-ID: <87mthok1nh.fsf@waldekranz.com>
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

On Thu, Mar 17, 2022 at 16:10, Ido Schimmel <idosch@idosch.org> wrote:
> On Thu, Mar 17, 2022 at 02:34:38PM +0100, Tobias Waldekranz wrote:
>> On Thu, Mar 17, 2022 at 14:26, Ido Schimmel <idosch@idosch.org> wrote:
>> > On Thu, Mar 17, 2022 at 01:42:55PM +0200, Nikolay Aleksandrov wrote:
>> >> On 17/03/2022 13:39, Mattias Forsblad wrote:
>> >> > On 2022-03-17 10:07, Joachim Wiberg wrote:
>> >> >> On Thu, Mar 17, 2022 at 07:50, Mattias Forsblad <mattias.forsblad@gmail.com> wrote:
>> >> >>> This patch implements the bridge flood flags. There are three different
>> >> >>> flags matching unicast, multicast and broadcast. When the corresponding
>> >> >>> flag is cleared packets received on bridge ports will not be flooded
>> >> >>> towards the bridge.
>> >> >>
>> >> >> If I've not completely misunderstood things, I believe the flood and
>> >> >> mcast_flood flags operate on unknown unicast and multicast.  With that
>> >> >> in mind I think the hot path in br_input.c needs a bit more eyes.  I'll
>> >> >> add my own comments below.
>> >> >>
>> >> >> Happy incident I saw this patch set, I have a very similar one for these
>> >> >> flags to the bridge itself, with the intent to improve handling of all
>> >> >> classes of multicast to/from the bridge itself.
>> >> >>
>> >> >>> [snip]
>> >> >>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>> >> >>> index e0c13fcc50ed..fcb0757bfdcc 100644
>> >> >>> --- a/net/bridge/br_input.c
>> >> >>> +++ b/net/bridge/br_input.c
>> >> >>> @@ -109,11 +109,12 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>> >> >>>  		/* by definition the broadcast is also a multicast address */
>> >> >>>  		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
>> >> >>>  			pkt_type = BR_PKT_BROADCAST;
>> >> >>> -			local_rcv = true;
>> >> >>> +			local_rcv = true && br_opt_get(br, BROPT_BCAST_FLOOD);
>> >> >>
>> >> >> Minor comment, I believe the preferred style is more like this:
>> >> >>
>> >> >> 	if (br_opt_get(br, BROPT_BCAST_FLOOD))
>> >> >>         	local_rcv = true;
>> >> >>
>> >> >>>  		} else {
>> >> >>>  			pkt_type = BR_PKT_MULTICAST;
>> >> >>> -			if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
>> >> >>> -				goto drop;
>> >> >>> +			if (br_opt_get(br, BROPT_MCAST_FLOOD))
>> >> >>> +				if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
>> >> >>> +					goto drop;
>> >> >>
>> >> >> Since the BROPT_MCAST_FLOOD flag should only control uknown multicast,
>> >> >> we cannot bypass the call to br_multicast_rcv(), which helps with the
>> >> >> classifcation.  E.g., we want IGMP/MLD reports to be forwarded to all
>> >> >> router ports, while the mdb lookup (below) is what an tell us if we
>> >> >> have uknown multicast and there we can check the BROPT_MCAST_FLOOD
>> >> >> flag for the bridge itself.
>> >> > 
>> >> > The original flag was name was local_receive to separate it from being
>> >> > mistaken for the flood unknown flags. However the comment I've got was
>> >> > to align it with the existing (port) flags. These flags have nothing to do with
>> >> > the port flood unknown flags. Imagine the setup below:
>> >> > 
>> >> >            vlan1
>> >> >              |
>> >> >             br0             br1
>> >> >            /   \           /   \
>> >> >          swp1 swp2       swp3 swp4
>> >> > 
>> >> > We want to have swp1/2 as member of a normal vlan filtering bridge br0 /w learning on. 
>> >> > On br1 we want to just forward packets between swp3/4 and disable learning. 
>> >> > Additional we don't want this traffic to impact the CPU. 
>> >> > If we disable learning on swp3/4 all traffic will be unknown and if we also 
>> >> > have flood unknown on the CPU-port because of requirements for br0 it will
>> >> > impact the traffic to br1. Thus we want to restrict traffic between swp3/4<->CPU port
>> >> > with the help of the PVT.
>> >> > 
>> >> > /Mattias
>> >> 
>> >> The feedback was correct and we all assumed unknown traffic control.
>> >> If you don't want any local receive then use filtering rules. Don't add unnecessary flags.
>> >
>> > Yep. Very easy with tc:
>> >
>> > # tc qdisc add dev br1 clsact
>> > # tc filter add dev br1 ingress pref 1 proto all matchall action drop
>> >
>> > This can be fully implemented inside the relevant device driver, no
>> > changes needed in the bridge driver.
>> 
>> Interesting. Are you saying that a switchdev driver can offload rules
>> for a netdev that it does not directly control (e.g. bridge that it is
>> connected to)? It thought that you had to bind the relevant ports to the
>> same block to approximate that. If so, are any drivers implementing
>> this? I did a quick scan of mlxsw, but could not find anything obvious.
>
> Yes, currently mlxsw only supports filters configured on physical
> netdevs, but the HW can support more advanced configurations such as
> filters on a bridge device (or a VLAN upper). These would be translated
> to ACLs configured on the ingress/egress router interface (RIF) backing
> the netdev. NIC drivers support much more advanced tc offloads due to
> the prevalent usage of OVS in this space, so might be better to check
> them instead.
>
> TBH, I never looked too deeply into this, but assumed it's supported via
> the indirect tc block infra. See commit 7f76fa36754b ("net: sched:
> register callbacks for indirect tc block binds") for more details.

Thanks for this pointer! That does indeed seem possible.

For others who may be interested, the API seems to have moved a bit, but
there are a few implementations. The current entry point seems to be:

flow_indr_dev_register

> Even if I got it wrong, it would be beneficial to extend the tc offload
> infra rather than patching the bridge driver to achieve a functionality
> that is already supported in the SW data path via tc.

Agreed! I just had no idea that it was already possible.
