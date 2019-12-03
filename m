Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 166E31100E5
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 16:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfLCPLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 10:11:42 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45833 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfLCPLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 10:11:41 -0500
Received: by mail-lj1-f193.google.com with SMTP id d20so4174780ljc.12
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 07:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K8tafk5S1peTqaHLhmqRxbvDN3I0h3xsqtkwOGZ+zKY=;
        b=GaTF90NiF1D8heJ0stwa1iZGpKbu08CfvHVQ2VkL7GocRvtNH1ahrEQpTpxDeA4dpi
         eX0yDIpXGV4GUX1f/4pg8TNqB/V5bmocvman+JJTeNPZ2Dm8IWBccOvuP08izAx9hb/k
         YdUm6psRp824Sq1WSMQEVXR8ro8IAgQsbSWrIPqLuLzkfcG8dCr0ltHE0wqHMDysd33t
         fB86I7UoIXRzpBIAAMaY2iHZ3TYEfcg7nlKL0wgEeiQ4V4QkCX+I6KQwbV9/hT+bV8Pm
         uD6FKpYyB6DhkOPAv1zSh2xUl5H5LlQn2FpljjXSW0Xsg5gf6/BGwGJeUJPSbuYLSHRL
         QBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=K8tafk5S1peTqaHLhmqRxbvDN3I0h3xsqtkwOGZ+zKY=;
        b=DNwvsaFaXX8AWfOx/brR/ewtLTdupfzYhqbQqZAC4RSwVddMt6qkKhDidI0KEG/sk7
         8o/Igt+TPRIRG6GirSP7ka9otL9V5PaO/rvgTxuqm9mdQVrl59GmwnCHVYAJCCVz4Q01
         94b+Od7JSghz/1ySLaAGGsgPBDVvCm/zh5QfakH9DK3p4JI+SunLgAfPPuwHz3A9bfyN
         HdtDNYMRTrarOibUWcTSzroFkF6QCoxHK3AYSjH/HoEfmPs/Ur9iAzXcdiFf96Ck5WWz
         D++Jm1ERgnXzzuzeZteGd/RNB1is1fjeLlpFnx9wDgdp2mthImQYmzpLmn7LBUBdonfh
         jWFA==
X-Gm-Message-State: APjAAAW+wX+WG4pzQzjnnm9YWI0L/430TnCWXf1ePoYsV/N+lSRLlZT1
        V/VLYIEfCvIuhEMJwfKZOkYwFg==
X-Google-Smtp-Source: APXvYqzEAh+Y/SQ8dt9S7s3S+/gai+RxyGx911W+vSCAwUS6BS64XRlTLzKR9euGboindzME1aDYkw==
X-Received: by 2002:a2e:9684:: with SMTP id q4mr2975607lji.242.1575385898821;
        Tue, 03 Dec 2019 07:11:38 -0800 (PST)
Received: from khorivan (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id s7sm1507072ljo.43.2019.12.03.07.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 07:11:38 -0800 (PST)
Date:   Tue, 3 Dec 2019 17:11:34 +0200
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Po Liu <po.liu@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of
 traffic classes
Message-ID: <20191203151133.GB2680@khorivan>
Mail-Followup-To: Po Liu <po.liu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191127094517.6255-1-Po.Liu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 09:59:18AM +0000, Po Liu wrote:

Hi, Po Liu

>IEEE Std 802.1Qbu standard defined the frame preemption of port
>traffic classes. This patch introduce a method to set traffic
>classes preemption. Add a parameter 'preemption' in struct
>ethtool_link_settings. The value will be translated to a binary,
>each bit represent a traffic class. Bit "1" means preemptable
>traffic class. Bit "0" means express traffic class.  MSB represent
>high number traffic class.
>
>If hardware support the frame preemption, driver could set the
>ethernet device with hw_features and features with NETIF_F_PREEMPTION
>when initializing the port driver.
>
>User can check the feature 'tx-preemption' by command 'ethtool -k
>devname'. If hareware set preemption feature. The property would
>be a fixed value 'on' if hardware support the frame preemption.
>Feature would show a fixed value 'off' if hardware don't support
>the frame preemption.
>
>Command 'ethtool devname' and 'ethtool -s devname preemption N'
>would show/set which traffic classes are frame preemptable.
>
>Port driver would implement the frame preemption in the function
>get_link_ksettings() and set_link_ksettings() in the struct ethtool_ops.
>
>Signed-off-by: Po Liu <Po.Liu@nxp.com>
>---
> include/linux/netdev_features.h | 5 ++++-
> include/uapi/linux/ethtool.h    | 5 ++++-
> net/core/ethtool.c              | 1 +
> 3 files changed, 9 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
>index 4b19c544c59a..299750a8b414 100644
>--- a/include/linux/netdev_features.h
>+++ b/include/linux/netdev_features.h
>@@ -80,6 +80,7 @@ enum {
>
> 	NETIF_F_GRO_HW_BIT,		/* Hardware Generic receive offload */
> 	NETIF_F_HW_TLS_RECORD_BIT,	/* Offload TLS record */
>+	NETIF_F_HW_PREEMPTION_BIT,	/* Hardware TC frame preemption */
>
> 	/*
> 	 * Add your fresh new feature above and remember to update
>@@ -150,6 +151,7 @@ enum {
> #define NETIF_F_GSO_UDP_L4	__NETIF_F(GSO_UDP_L4)
> #define NETIF_F_HW_TLS_TX	__NETIF_F(HW_TLS_TX)
> #define NETIF_F_HW_TLS_RX	__NETIF_F(HW_TLS_RX)
>+#define NETIF_F_PREEMPTION	__NETIF_F(HW_PREEMPTION)
>
> /* Finds the next feature with the highest number of the range of start till 0.
>  */
>@@ -175,7 +177,8 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
> /* Features valid for ethtool to change */
> /* = all defined minus driver/device-class-related */
> #define NETIF_F_NEVER_CHANGE	(NETIF_F_VLAN_CHALLENGED | \
>-				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL)
>+				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL | \
>+				 NETIF_F_PREEMPTION)
>
> /* remember that ((t)1 << t_BITS) is undefined in C99 */
> #define NETIF_F_ETHTOOL_BITS	((__NETIF_F_BIT(NETDEV_FEATURE_COUNT - 1) | \
>diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
>index d4591792f0b4..12ffb34afbfa 100644
>--- a/include/uapi/linux/ethtool.h
>+++ b/include/uapi/linux/ethtool.h
>@@ -1776,6 +1776,8 @@ enum ethtool_reset_flags {
> };
> #define ETH_RESET_SHARED_SHIFT	16
>
>+/* Disable preemtion. */
>+#define PREEMPTION_DISABLE     0x0
>
> /**
>  * struct ethtool_link_settings - link control and status
>@@ -1886,7 +1888,8 @@ struct ethtool_link_settings {
> 	__s8	link_mode_masks_nwords;
> 	__u8	transceiver;
> 	__u8	reserved1[3];
>-	__u32	reserved[7];
>+	__u32	preemption;

Why 32 when only 8 is needed?

>+	__u32	reserved[6];
> 	__u32	link_mode_masks[0];
> 	/* layout of link_mode_masks fields:
> 	 * __u32 map_supported[link_mode_masks_nwords];
>diff --git a/net/core/ethtool.c b/net/core/ethtool.c
>index cd9bc67381b2..6ffcd8a602b8 100644
>--- a/net/core/ethtool.c
>+++ b/net/core/ethtool.c
>@@ -111,6 +111,7 @@ static const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN]
> 	[NETIF_F_HW_TLS_RECORD_BIT] =	"tls-hw-record",
> 	[NETIF_F_HW_TLS_TX_BIT] =	 "tls-hw-tx-offload",
> 	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
>+	[NETIF_F_HW_PREEMPTION_BIT] =	 "tx-preemption",

What about tx-frame-preempt? or frame-preemption?

> };
>
> static const char
>-- 
>2.17.1
>

-- 
Regards,
Ivan Khoronzhuk
