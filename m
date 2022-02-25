Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA58E4C4410
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240338AbiBYL6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240327AbiBYL6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:58:37 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FD320DB15;
        Fri, 25 Feb 2022 03:58:05 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id qx21so10335954ejb.13;
        Fri, 25 Feb 2022 03:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eKJcSLZAqP7Os/0t4MvxXKq9XdTtYRY2RFv0Q261puo=;
        b=TbZTSwLTXlHE3l+DQoC9XPQJkmkuzFD/5PYkMX7e36XxS4UzNzN4YQJGfpJYcGTHac
         AArqrl1juPOZh0EqroYU2icS6kuR7M3jbinV22S9lILo5rUYwnpVCAFiAtvDEZQfr32n
         P/C3AcOLT2C4VbS10pcxGRAdtf8vFfAcXteRj2pUKI5QDhkLszzAW3j80w5U+yM7N3+4
         ccw4eE3XZqOBrm49//8V07QT4X0nlsqomYodDCJaKxnwbgxIcYZyDIAtRUEUvXwVvXca
         UqawrG7iQDM6X1Bt3/clkWxAu4NF4+xYxEadlwFvSBMRrKXDOXtF+HeL5Hg1Q1tj/EtL
         LRFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eKJcSLZAqP7Os/0t4MvxXKq9XdTtYRY2RFv0Q261puo=;
        b=jJ5UJj1Cu0ugIbPH0CPktOzQuNTxHYwLhkmOfI6WmtCScKv8FLTihKSp7+APVZumbD
         9CN3nxtYqjQTxr717g4ihafargbXjKVCbODfYE8C7MvP83udyE7LmKwovD7zoi8qaTuB
         7hezPB2ficiVorlCKpjMZJT1wWYT1KuNC8yaslRVIv7IpMTr5Fc2gkJl3TeBX4AfSSd/
         iYgBhy0rCWH9uZOf8gKPCs04EuXAT/NsgNd1xQWwtQYFX/lrvro7OXj+/o0uyRSWnPv4
         ONF02Bcqf7hVVDiDY0Mt+LZvG0ASD7T2SnKFXERdIz1pqp0Z0Djris6gaoZFRb9CCyPP
         l1Ag==
X-Gm-Message-State: AOAM532fdNRYbXoLSBEYskCMf4bmCtiR/y5i0HGXEMd0Hbfy6sshicqm
        prZJ4L31Cyf/SoDdW1elFAE=
X-Google-Smtp-Source: ABdhPJz6eq8C4+FovCPWn1z0kmbj/viW24DsEHd4nLKo3hZ6ewkVkQqQpSwJYcHEppknlr14y/jU/Q==
X-Received: by 2002:a17:906:4752:b0:6ce:61d9:b632 with SMTP id j18-20020a170906475200b006ce61d9b632mr6078452ejs.694.1645790284186;
        Fri, 25 Feb 2022 03:58:04 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id cc21-20020a0564021b9500b00403bc1dfd5csm1276100edb.85.2022.02.25.03.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 03:58:03 -0800 (PST)
Date:   Fri, 25 Feb 2022 13:58:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 1/1] net: dsa: microchip: ksz9477: implement
 MTU configuration
Message-ID: <20220225115802.bvjd54cwwk6hjyfa@skbuf>
References: <20220223084055.2719969-1-o.rempel@pengutronix.de>
 <20220223233833.mjknw5ko7hpxj3go@skbuf>
 <20220224045936.GB4594@pengutronix.de>
 <20220224093329.hssghouq7hmgxvwb@skbuf>
 <20220224093827.GC4594@pengutronix.de>
 <20220224094657.jzhvi67ryhuipor4@skbuf>
 <20220225114740.GA27407@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225114740.GA27407@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 12:47:40PM +0100, Oleksij Rempel wrote:
> On Thu, Feb 24, 2022 at 11:46:57AM +0200, Vladimir Oltean wrote:
>  
> > So where is it failing exactly? Here I guess, because mtu_limit will be
> > negative?
> > 
> > 	mtu_limit = min_t(int, master->max_mtu, dev->max_mtu);
> > 	old_master_mtu = master->mtu;
> > 	new_master_mtu = largest_mtu + dsa_tag_protocol_overhead(cpu_dp->tag_ops);
> > 	if (new_master_mtu > mtu_limit)
> > 		return -ERANGE;
> > 
> > I don't think we can work around it in DSA, it's garbage in, garbage out.
> > 
> > In principle, I don't have such a big issue with writing the MTU
> > register as part of the switch initialization, especially if it's global
> > and not per port. But tell me something else. You pre-program the MTU
> > with VLAN_ETH_FRAME_LEN + ETH_FCS_LEN, but in the MTU change procedure,
> > you also add KSZ9477_INGRESS_TAG_LEN (2) to that. Is that needed at all?
> > I expect that if it's needed, it's needed in both places. Can you
> > sustain an iperf3 tcp session over a VLAN upper of a ksz9477 port?
> > I suspect that the missing VLAN_HLEN is masking a lack of KSZ9477_INGRESS_TAG_LEN.
> 
> Hm... I assume I need to do something like this:
> - build kernel with BRIDGE_VLAN_FILTERING
> - |
>   ip l a name br0 type bridge vlan_filtering 1
>   ip l s dev br0 up
>   ip l s lan1 master br0
>   ip l s dev lan1 up
>   bridge vlan add dev lan1 vid 5 pvid untagged
>   ip link add link br0 name vlan5 type vlan id 5
> 
> I use lan5@ksz for net boot. As soon as i link lan1@ksz to the br0 with
> vlan_filtering enabled, the nfs on lan5 will be broken. Currently I have
> no time to investigate it. I'll try to fix VLAN support in a separate
> task. What will is acceptable way to proceed with MTU patch?

No bridge, why create a bridge? And even if you do, why add lan5 to it?
The expectation is that standalone ports still remain functional when
other ports join a bridge.

I was saying:

ip link set lan1 up
ip link add link lan1 name lan1.5 type vlan id 5
ip addr add 192.168.100.1/24 dev lan1.5 && ip link set lan1.5 up
iperf3 -c 192.168.100.2
