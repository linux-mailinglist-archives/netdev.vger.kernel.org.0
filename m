Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CE031D59E
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 08:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhBQHIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 02:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhBQHIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 02:08:53 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E47C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 23:08:13 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id v1so16195121wrd.6
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 23:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6d/b3uLihvH7pBotSUD5UsSvhyk+KqI5rmcdxQ+FSt4=;
        b=iTJp7f0iQryHx4od0f7IDpWTa9wpmR7RKblNphsInux71PsV+TgWXL7/ad7X2k1NCQ
         KDdswdjubcSOxDDg+RKr8/rkEeJiy9EZ+o4J5/Q7/qcWB7fiKfXJqWrD5F1NfuLK/lZ7
         iav9Dmk3le3HSeEiV7oqxeZ4I4MdpD2cQ26IH+0JmEFTcneoc9b9JSVHVWKAEkckzEtF
         xMrJzNsBTbeuxTfZ+GeSb44vmuVd+veSDVq/4mLLq3e5zEPJxSzkroMXXJ2CcF2/CpBM
         LUqkcdhFRpTrOsLN8bLL/WTriaoxzSSuGPCGugIiWA2mo4FZHwGObkDuOOArdGc+sW9M
         Va9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6d/b3uLihvH7pBotSUD5UsSvhyk+KqI5rmcdxQ+FSt4=;
        b=D0KV3TJY0rdvFw2h4Yv0ZPcQ4BtGscCcA7MEzR/4oPAkq06gGZq9WeEg/kDzAclFhu
         MgxZa5MOP/cKZMxxQGu/wMTRA7gGr7TWro9Ghy8I/WgZKSKGz1rKaIxrGvgeCcWie4f4
         4HGmt3liAmcO5iUfqc7eKF18lAPBfSfAa+t2WMacUOhPD0MJdq7zwg6rfgFFwvCOz6qi
         p/ALFA53luq0T/t7a38B+F8+0b/oeRg/D9d3ptkVQJx+gWmkUh+MuvblxIDJyJzrn5GL
         Sb7jO/rA52eg9hltdBLfZBWNBKHWWU9nQWlSsXkXl9xFWaENPca5p39wwV7wmPt5eUvD
         k46Q==
X-Gm-Message-State: AOAM533bGQVhOtdNzXguqXLxkoaTvrVwIfMRfFRu2WV7L2WMDD0d15jP
        9EQto8gNnI6P9YvxVYbEq8c=
X-Google-Smtp-Source: ABdhPJyQcOJ4dDoJze/CCVgAL9B7VoW+VcmADuxqsWud7wRjwCIKNAcyJdpatDVgE/iQMVWyINHG+Q==
X-Received: by 2002:a05:6000:1542:: with SMTP id 2mr28009517wry.356.1613545691805;
        Tue, 16 Feb 2021 23:08:11 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:18f2:c6f5:8692:46a1? ([2003:ea:8f39:5b00:18f2:c6f5:8692:46a1])
        by smtp.googlemail.com with ESMTPSA id p16sm11778244wmj.3.2021.02.16.23.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Feb 2021 23:08:11 -0800 (PST)
To:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>
References: <20210217062139.7893-1-dqfext@gmail.com>
 <20210217062139.7893-2-dqfext@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next 1/2] net: dsa: add Realtek RTL8366S switch tag
Message-ID: <e395ad31-9aeb-0afe-7058-103c6dce942d@gmail.com>
Date:   Wed, 17 Feb 2021 08:07:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210217062139.7893-2-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.02.2021 07:21, DENG Qingfang wrote:
> Add support for Realtek RTL8366S switch tag
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  include/net/dsa.h      |  2 +
>  net/dsa/Kconfig        |  6 +++
>  net/dsa/Makefile       |  1 +
>  net/dsa/tag_rtl8366s.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 107 insertions(+)
>  create mode 100644 net/dsa/tag_rtl8366s.c
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 83a933e563fe..14fedf832f27 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -49,6 +49,7 @@ struct phylink_link_state;
>  #define DSA_TAG_PROTO_XRS700X_VALUE		19
>  #define DSA_TAG_PROTO_OCELOT_8021Q_VALUE	20
>  #define DSA_TAG_PROTO_SEVILLE_VALUE		21
> +#define DSA_TAG_PROTO_RTL8366S_VALUE		22
>  
>  enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
> @@ -73,6 +74,7 @@ enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_XRS700X		= DSA_TAG_PROTO_XRS700X_VALUE,
>  	DSA_TAG_PROTO_OCELOT_8021Q	= DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
>  	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
> +	DSA_TAG_PROTO_RTL8366S		= DSA_TAG_PROTO_RTL8366S_VALUE,
>  };
>  
>  struct packet_type;
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index a45572cfb71a..303228e0ad8b 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -104,6 +104,12 @@ config NET_DSA_TAG_RTL4_A
>  	  Realtek switches with 4 byte protocol A tags, sich as found in
>  	  the Realtek RTL8366RB.
>  
> +config NET_DSA_TAG_RTL8366S
> +	tristate "Tag driver for Realtek RTL8366S switch tags"
> +	help
> +	  Say Y or M if you want to enable support for tagging frames for the
> +	  Realtek RTL8366S switch.
> +
>  config NET_DSA_TAG_OCELOT
>  	tristate "Tag driver for Ocelot family of switches, using NPI port"
>  	select PACKING
> diff --git a/net/dsa/Makefile b/net/dsa/Makefile
> index 44bc79952b8b..df158e73a30b 100644
> --- a/net/dsa/Makefile
> +++ b/net/dsa/Makefile
> @@ -12,6 +12,7 @@ obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
>  obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
>  obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
>  obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
> +obj-$(CONFIG_NET_DSA_TAG_RTL8366S) += tag_rtl8366s.o
>  obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
>  obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
>  obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
> diff --git a/net/dsa/tag_rtl8366s.c b/net/dsa/tag_rtl8366s.c
> new file mode 100644
> index 000000000000..6c6c66853e4c
> --- /dev/null
> +++ b/net/dsa/tag_rtl8366s.c
> @@ -0,0 +1,98 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Handler for Realtek RTL8366S switch tags
> + * Copyright (c) 2021 DENG, Qingfang <dqfext@gmail.com>
> + *
> + * This tag header looks like:
> + *
> + * -------------------------------------------------
> + * | MAC DA | MAC SA | 0x8899 | 2-byte tag  | Type |
> + * -------------------------------------------------
> + *
> + * The 2-byte tag format in tag_rcv:
> + *       +------+------+------+------+------+------+------+------+
> + * 15: 8 |   Protocol number (0x9)   |  Priority   |  Reserved   |
> + *       +------+------+------+------+------+------+------+------+
> + *  7: 0 |             Reserved             | Source port number |
> + *       +------+------+------+------+------+------+------+------+
> + *
> + * The 2-byte tag format in tag_xmit:
> + *       +------+------+------+------+------+------+------+------+
> + * 15: 8 |   Protocol number (0x9)   |  Priority   |  Reserved   |
> + *       +------+------+------+------+------+------+------+------+
> + *  7: 0 |  Reserved   |          Destination port mask          |
> + *       +------+------+------+------+------+------+------+------+
> + */
> +
> +#include <linux/etherdevice.h>
> +
> +#include "dsa_priv.h"
> +
> +#define RTL8366S_HDR_LEN	4
> +#define RTL8366S_ETHERTYPE	0x8899

I found this protocol referenced as Realtek Remote Control Protocol (RRCP)
and it seems to be used by few Realtek chips. Not sure whether this
protocol is officially registered. If yes, then it should be added to
the list of ethernet protocol id's in include/uapi/linux/if_ether.h.
If not, then it may be better to define it using the usual naming
scheme as ETH_P_RRCP in realtek-smi-core.h.


> +#define RTL8366S_PROTOCOL_SHIFT	12
> +#define RTL8366S_PROTOCOL	0x9
> +#define RTL8366S_TAG	\
> +	(RTL8366S_PROTOCOL << RTL8366S_PROTOCOL_SHIFT)
> +
> +static struct sk_buff *rtl8366s_tag_xmit(struct sk_buff *skb,
> +					 struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	__be16 *tag;
> +
> +	/* Make sure the frame is at least 60 bytes long _before_
> +	 * inserting the CPU tag, or it will be dropped by the switch.
> +	 */
> +	if (unlikely(eth_skb_pad(skb)))
> +		return NULL;
> +
> +	skb_push(skb, RTL8366S_HDR_LEN);
> +	memmove(skb->data, skb->data + RTL8366S_HDR_LEN,
> +		2 * ETH_ALEN);
> +
> +	tag = (__be16 *)(skb->data + 2 * ETH_ALEN);
> +	tag[0] = htons(RTL8366S_ETHERTYPE);
> +	tag[1] = htons(RTL8366S_TAG | BIT(dp->index));
> +
> +	return skb;
> +}
> +
> +static struct sk_buff *rtl8366s_tag_rcv(struct sk_buff *skb,
> +					struct net_device *dev,
> +					struct packet_type *pt)
> +{
> +	u8 *tag;
> +	u8 port;
> +
> +	if (unlikely(!pskb_may_pull(skb, RTL8366S_HDR_LEN)))
> +		return NULL;
> +
> +	tag = skb->data - 2;
> +	port = tag[3] & 0x7;
> +
> +	skb->dev = dsa_master_find_slave(dev, 0, port);
> +	if (unlikely(!skb->dev))
> +		return NULL;
> +
> +	skb_pull_rcsum(skb, RTL8366S_HDR_LEN);
> +	memmove(skb->data - ETH_HLEN,
> +		skb->data - ETH_HLEN - RTL8366S_HDR_LEN,
> +		2 * ETH_ALEN);
> +
> +	skb->offload_fwd_mark = 1;
> +
> +	return skb;
> +}
> +
> +static const struct dsa_device_ops rtl8366s_netdev_ops = {
> +	.name		= "rtl8366s",
> +	.proto		= DSA_TAG_PROTO_RTL8366S,
> +	.xmit		= rtl8366s_tag_xmit,
> +	.rcv		= rtl8366s_tag_rcv,
> +	.overhead	= RTL8366S_HDR_LEN,
> +};
> +module_dsa_tag_driver(rtl8366s_netdev_ops);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8366S);
> 

