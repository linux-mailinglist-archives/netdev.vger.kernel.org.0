Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F61A225CDA
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 12:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgGTKor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 06:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbgGTKoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 06:44:46 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57EBC0619D2
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 03:44:45 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s10so17283185wrw.12
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 03:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wG7K0uq8mpLNpl6r6yyIK1jp2dXYWitOo/oUfoeSlAo=;
        b=dqdxmTZ6+gN++MK7rDSC7D5QKx04y3ZsSX2bGExyrfDLLkwc3HAre+/5CJjXb8DRCG
         L1b+S+GhVUwfYW/t1Y7dqnLxaAe75m8yZlBo+767cn+ilAhdFEu5ix23YEbE+8xiRUl/
         kbTW8xI6L8oQb24MX72zy2OlV4vKU/QhRL/Xc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wG7K0uq8mpLNpl6r6yyIK1jp2dXYWitOo/oUfoeSlAo=;
        b=skx7eiWjCguKBNmdmX/748uuo/YI9G5q+Z8nFfciiGF0gRQ2rMbU5glI/SYI7+5Jeo
         8oYt9sTqDMSNxixqVwzELEBc+EiZb2P0y1S2tmU9SPzI3ps2yiwtBbbWNMlOEX3VlC9Y
         1meOZvC5ddJ5ENdzvgIpdafefZkeE2CdfTVUCitB+B4AhXtUNFcHWxFtRbrG9LahCNvH
         YY/uexyjhU6B1M7MjSTIB2EXspnmwZ4iPmI60YVcuNaKbTCDKIXHcNYQXAVJV76ZtBpb
         o37XYcaqnd3aBbwAbJx/8C8PZzxMjsCASIiHp1AHXnub8hc4hFnXxd/kgsMog3wgsdd8
         vOzA==
X-Gm-Message-State: AOAM531vu1gX3dd+IorYDwS9PPlg4pkWgEj54GETV4cX0PRXn7d7m3PP
        PBjslHyS69vm8pz3uWJHvXQz8Q==
X-Google-Smtp-Source: ABdhPJycW9SMvCj+IwJIi5ruNoHI7H4Hqf0HBuMTqROBaRA08TgGoNei9d52jp9Pa0Kxd2bDH0z0qQ==
X-Received: by 2002:a5d:4c8a:: with SMTP id z10mr21330200wrs.384.1595241884483;
        Mon, 20 Jul 2020 03:44:44 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x7sm31909992wrr.72.2020.07.20.03.44.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 03:44:43 -0700 (PDT)
Subject: Re: [PATCH 1/2] net: dsa: Add flag for 802.1AD when adding VLAN for
 dsa switch and port
To:     hongbo.wang@nxp.com, xiaoliang.yang_1@nxp.com,
        allan.nielsen@microchip.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com, mingkai.hu@nxp.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        linux-devel@linux.nxdi.nxp.com
References: <20200720104119.19146-1-hongbo.wang@nxp.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <05b06d46-d705-7d06-b4dd-2bee90f75168@cumulusnetworks.com>
Date:   Mon, 20 Jul 2020 13:44:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200720104119.19146-1-hongbo.wang@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/07/2020 13:41, hongbo.wang@nxp.com wrote:
> From: "hongbo.wang" <hongbo.wang@nxp.com>
> 
> the following command can be supported:
> ip link add link swp1 name swp1.100 type vlan protocol 802.1ad id 100
> 
> Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
> ---
>  include/uapi/linux/if_bridge.h | 1 +
>  net/dsa/slave.c                | 9 +++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 

This is not bridge related at all, please leave its flags out of it.

Nacked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>



> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index caa6914a3e53..ecd960aa65c7 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -132,6 +132,7 @@ enum {
>  #define BRIDGE_VLAN_INFO_RANGE_END	(1<<4) /* VLAN is end of vlan range */
>  #define BRIDGE_VLAN_INFO_BRENTRY	(1<<5) /* Global bridge VLAN entry */
>  #define BRIDGE_VLAN_INFO_ONLY_OPTS	(1<<6) /* Skip create/delete/flags */
> +#define BRIDGE_VLAN_INFO_8021AD	(1<<7) /* VLAN is 802.1AD protocol */
>  
>  struct bridge_vlan_info {
>  	__u16 flags;
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 4c7f086a047b..376d7ac5f1e5 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1232,6 +1232,7 @@ static int dsa_slave_get_ts_info(struct net_device *dev,
>  static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>  				     u16 vid)
>  {
> +	u16 flags = 0;
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
>  	struct bridge_vlan_info info;
>  	int ret;
> @@ -1252,7 +1253,10 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>  			return -EBUSY;
>  	}
>  
> -	ret = dsa_port_vid_add(dp, vid, 0);
> +	if (ntohs(proto) == ETH_P_8021AD)
> +		flags |= BRIDGE_VLAN_INFO_8021AD;
> +
> +	ret = dsa_port_vid_add(dp, vid, flags);
>  	if (ret)
>  		return ret;
>  
> @@ -1744,7 +1748,8 @@ int dsa_slave_create(struct dsa_port *port)
>  
>  	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;
>  	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
> -		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
> +		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
> +				       NETIF_F_HW_VLAN_STAG_FILTER;
>  	slave_dev->hw_features |= NETIF_F_HW_TC;
>  	slave_dev->features |= NETIF_F_LLTX;
>  	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
> 

