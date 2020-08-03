Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1C723B045
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgHCWio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHCWio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:38:44 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB0FC06174A;
        Mon,  3 Aug 2020 15:38:44 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id w17so21763957ply.11;
        Mon, 03 Aug 2020 15:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=AX8P5SKs4RxEU7ZpFU9jN59OucHZg9tzIJ/e/VXbTYw=;
        b=q2zt9D+SIiYjnYDi0kYbfBNtbDV08MM+29B8yrwIABZRNZy46qWK7SRUjNjjeICZXC
         TxzJoux6iyzuDEzgWe3xWJRGW2iFO9aup+EbbLUW950/Cw5CcG542YL7xbiLRPNCkgCq
         EUf/J/bRMmP8d59mRFdvcXpPASfYMfM6I7H/8Q8GtwHrO6ER2DJ2Ik0/f8jgzGe6rs/v
         n1L4kJPiHhZ8i1RkZA94SklGkcFFPlaZXzJYsNm6+e00QzGDipsRknyW079umhzvGZtf
         D1MhNBmX3QNG4eso5Au8m4e0S00TSjH1OATUFIEWHEnY3aD0roNLsa/o1gNjXBbKhTUl
         ptfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AX8P5SKs4RxEU7ZpFU9jN59OucHZg9tzIJ/e/VXbTYw=;
        b=MqVExEczozpjAqvFyCejM6r+zC8TtK9GX3jsJxpYluKhCUWkCUxVrrqf82zdwPih87
         Uz8v1N3FFgOdd0Obo58wxP9JJuRoljvBA66+4dY8KxUE2jqdtUsi4unMlZE5GsTDa33w
         gIw0l3EDz4A8KlQy0fffefuDMOpt9nuMi6GiIPJUQjy/58WPVZ8NUTs1LO1gZhUukjSi
         XFXPPf8LDCpv/8MDGnzvOdHMHm508FemXRRjXQJKtcrQs5LcSq+fXE1YVom4M/ersHrY
         46xV77cgoFzI1cNK1JooCJimY36VFK757AoJbLeF7yVax4VV9UKF3X8F4hg50CpBsTEb
         G8Vg==
X-Gm-Message-State: AOAM530RtGWzaFEDPDgwfJTB1XP7+4knFHIcMTBU7tuN/EGXE05fkYlf
        uGyytbZdwrcal1MIHpTqujg=
X-Google-Smtp-Source: ABdhPJy6PXHcy8CX+mGcA9wwdsuzxLm8TUkLIsXV+Y6np08kQPCJkdfCQTlLNMnaJu4/XfOWs3nhrA==
X-Received: by 2002:a17:90a:bc45:: with SMTP id t5mr1375382pjv.139.1596494323642;
        Mon, 03 Aug 2020 15:38:43 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm22103571pfg.135.2020.08.03.15.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 15:38:42 -0700 (PDT)
Subject: Re: [PATCH v4 1/2] net: dsa: Add protocol support for 802.1AD when
 adding or deleting vlan for dsa switch port
To:     hongbo.wang@nxp.com, xiaoliang.yang_1@nxp.com,
        allan.nielsen@microchip.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com, mingkai.hu@nxp.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        vinicius.gomes@intel.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ivecera@redhat.com
References: <20200730102505.27039-1-hongbo.wang@nxp.com>
 <20200730102505.27039-2-hongbo.wang@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <effcb1fe-79ed-ed79-ffe3-977ed9aa006e@gmail.com>
Date:   Mon, 3 Aug 2020 15:38:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730102505.27039-2-hongbo.wang@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 3:25 AM, hongbo.wang@nxp.com wrote:
> From: "hongbo.wang" <hongbo.wang@nxp.com>
> 
> the following command will be supported:
> 
> Set bridge's vlan protocol:
>     ip link set br0 type bridge vlan_protocol 802.1ad
> Add VLAN:
>     ip link add link swp1 name swp1.100 type vlan protocol 802.1ad id 100
> Delete VLAN:
>     ip link del link swp1 name swp1.100
> 
> Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
> ---
>  include/net/switchdev.h |  1 +
>  net/dsa/dsa_priv.h      |  4 ++--
>  net/dsa/port.c          |  6 ++++--
>  net/dsa/slave.c         | 27 +++++++++++++++++++++------
>  net/dsa/tag_8021q.c     |  4 ++--
>  5 files changed, 30 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index ff2246914301..7594ea82879f 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -97,6 +97,7 @@ struct switchdev_obj_port_vlan {
>  	u16 flags;
>  	u16 vid_begin;
>  	u16 vid_end;
> +	u16 proto;

You are adding a new member to the switchdev VLAN object, so you should
make sure that all call paths creating and parsing that object get
updated as well, for now, you are doing this solely within DSA which is
probably reasonable if we assume proto is uninitialized and unused
elsewhere, there is no change of functionality.

[snip]

> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 41d60eeefdbd..2a03da92af0a 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1233,7 +1233,10 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>  				     u16 vid)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	u16 vlan_proto = ntohs(proto);
>  	struct bridge_vlan_info info;
> +	bool change_proto = false;
> +	u16 br_proto = 0;
>  	int ret;
>  
>  	/* Check for a possible bridge VLAN entry now since there is no
> @@ -1243,20 +1246,24 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>  		if (dsa_port_skip_vlan_configuration(dp))
>  			return 0;
>  
> +		ret = br_vlan_get_proto(dp->bridge_dev, &br_proto);
> +		if (ret == 0 && br_proto != vlan_proto)
> +			change_proto = true;


This deserves a comment, because the change_proto variable is not really
explaining what this is about, maybe more like "incompatible_proto" would?

First you query the VLAN protocol currently configured on the bridge
master device, and if this VLAN protocol is different than the one being
requested, then you treat this as an error. It might make sense to also
print a message towards the user that the bridge device protocol should
be changed, or that the bridge device should be removed and re-created
accordingly.

Does it not work if we have a bridge currently configured with 802.1ad
and a 802.1q VLAN programming request comes in? In premise it should,
right? Likewise, if we had a 802.1ad bridge configured already and we
want to configure a 802.1Q VLAN on a bridged port, there should be a way
for this configuration to work.

And both cases, it ought to be possible to configure the switch in
double tagged mode and just make sure that there is no S-tag being added
unless requested.

> +
>  		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
>  		 * device, respectively the VID is not found, returning
>  		 * 0 means success, which is a failure for us here.
>  		 */
>  		ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
> -		if (ret == 0)
> +		if (ret == 0 && !change_proto)
>  			return -EBUSY;
>  	}
>  
> -	ret = dsa_port_vid_add(dp, vid, 0);
> +	ret = dsa_port_vid_add(dp, vid, vlan_proto, 0);
>  	if (ret)
>  		return ret;
>  
> -	ret = dsa_port_vid_add(dp->cpu_dp, vid, 0);
> +	ret = dsa_port_vid_add(dp->cpu_dp, vid, 0, 0);
>  	if (ret)
>  		return ret;
>  
> @@ -1267,7 +1274,10 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
>  				      u16 vid)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	u16 vlan_proto = ntohs(proto);
>  	struct bridge_vlan_info info;
> +	bool change_proto = false;
> +	u16 br_proto = 0;
>  	int ret;
>  
>  	/* Check for a possible bridge VLAN entry now since there is no
> @@ -1277,19 +1287,23 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
>  		if (dsa_port_skip_vlan_configuration(dp))
>  			return 0;
>  
> +		ret = br_vlan_get_proto(dp->bridge_dev, &br_proto);
> +		if (ret == 0 && br_proto != vlan_proto)
> +			change_proto = true;
> +
>  		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
>  		 * device, respectively the VID is not found, returning
>  		 * 0 means success, which is a failure for us here.
>  		 */
>  		ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
> -		if (ret == 0)
> +		if (ret == 0 && !change_proto)
>  			return -EBUSY;

Since we are copying the same code than in the add_vid path, it might
make sense to extract this to a helper function eventually.

>  	}
>  
>  	/* Do not deprogram the CPU port as it may be shared with other user
>  	 * ports which can be members of this VLAN as well.
>  	 */
> -	return dsa_port_vid_del(dp, vid);
> +	return dsa_port_vid_del(dp, vid, vlan_proto);
>  }
>  
>  struct dsa_hw_port {
> @@ -1744,7 +1758,8 @@ int dsa_slave_create(struct dsa_port *port)
>  
>  	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;
>  	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
> -		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
> +		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
> +				       NETIF_F_HW_VLAN_STAG_FILTER;

You cannot advertise this netdev feature for *all* DSA switch driver
unless you have verified that each DSA driver implementing
port_vlan_add() will work correctly. Please assign this flag from within
the ocelot driver for now.

>  	slave_dev->hw_features |= NETIF_F_HW_TC;
>  	slave_dev->features |= NETIF_F_LLTX;
>  	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
> diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
> index 780b2a15ac9b..848f85ed5c0f 100644
> --- a/net/dsa/tag_8021q.c
> +++ b/net/dsa/tag_8021q.c
> @@ -152,9 +152,9 @@ static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
>  	struct dsa_port *dp = dsa_to_port(ds, port);
>  
>  	if (enabled)
> -		return dsa_port_vid_add(dp, vid, flags);
> +		return dsa_port_vid_add(dp, vid, 0, flags);

Why not pass ETH_P_8021Q here to indicate we want a 802.1Q, not .AD
configuration request?
-- 
Florian
