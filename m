Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D2F485856
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243040AbiAESb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243000AbiAESa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:30:56 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3E3C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 10:30:56 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id g2so36183113pgo.9
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 10:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iLge3+8W3+D08UrUjB3n/p6frzw5Y6QErRsgk5EK3gM=;
        b=ME/liIL4fQ0KjCPj8AlB6XYt+ZGeaoO7aixXfY1H2zLim/XnDvxDlKscfRX3AapShM
         rk6S1y743yUlQ7JSEpkrMw//nYRsGGFcZmnfj2z05ugtrBCEpJvbxa8680mIAJGGg27k
         2hugoZX86NxnPKHnZOqbjMMbxJBdqWAu2TOHqD+vzCsRKMOYN/luz+nzIUx8j4F9B4h3
         3QGzOe3YKEUMajZkxBxtAPprtap8Rrs4h1kRihLGVDDqjpL6rncVnADZuRltDK1qwrUs
         Q8iG4K6gWBEYNVmm+mQXPWYNvgtxGwr3dNgBxibu0jbapiF8LFqTn6/1EKqx0Dq3GZHj
         aqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iLge3+8W3+D08UrUjB3n/p6frzw5Y6QErRsgk5EK3gM=;
        b=UBIK4fROLC7TbNx8HrFyFUCzolo7FYW8Jl9pW2hJZjekBm3E1Y0v/y8fM2ydp2hi86
         AR6h0joyDopdtVOh3HyQjXLS5dx7f0TVKTnDO51G0Fdsc1GQzUmxBqa5t4FH5bUqj8zU
         E4OAdmZ1vIUJ245k4XTvopjp+AZ4Urk5IpkpchYL0d1NGrv0qNjVgNV7NfXQL4GGDRDV
         zowD55vTVrnfkuA63K553KqcBwhNZ+Q5cdIKGjMTHBW68bknuMMH1CDnJ+AcLpcUx0uD
         lj0BDib3miKiGLg9mMeHjH0i3sLsNwG8Lzmh3vMp5FWOHYUjqC2FVK7a3IEUyQRGYh7t
         ddrA==
X-Gm-Message-State: AOAM532QxYIfM3dnuagTi193cvrYjALlObpvqFbqdlkrnwGOjbcdQoOl
        V3JSCGJ95hyL15EA+wbOqiY=
X-Google-Smtp-Source: ABdhPJw/YYFSnH7pIvpTq0zwFvZvl+grOVxsy6NuzQEHoAdKCiMFzKeLAkJzuB0uwCpvj0SuSxLhCw==
X-Received: by 2002:a63:fd53:: with SMTP id m19mr48483383pgj.563.1641407456214;
        Wed, 05 Jan 2022 10:30:56 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ip2sm3144851pjb.34.2022.01.05.10.30.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 10:30:55 -0800 (PST)
Subject: Re: [PATCH v2 net-next 2/7] net: dsa: merge all bools of struct
 dsa_port into a single u8
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <20220105132141.2648876-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d41c058c-d20f-2e9f-ea2c-0a26bdb5fea3@gmail.com>
Date:   Wed, 5 Jan 2022 10:30:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220105132141.2648876-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 5:21 AM, Vladimir Oltean wrote:
> struct dsa_port has 5 bool members which create quite a number of 7 byte
> holes in the structure layout. By merging them all into bitfields of an
> u8, and placing that u8 in the 1-byte hole after dp->mac and dp->stp_state,
> we can reduce the structure size from 576 bytes to 552 bytes on arm64.
> 
> Before:
> 
> pahole -C dsa_port net/dsa/slave.o
> struct dsa_port {
>         union {
>                 struct net_device * master;              /*     0     8 */
>                 struct net_device * slave;               /*     0     8 */
>         };                                               /*     0     8 */
>         const struct dsa_device_ops  * tag_ops;          /*     8     8 */
>         struct dsa_switch_tree *   dst;                  /*    16     8 */
>         struct sk_buff *           (*rcv)(struct sk_buff *, struct net_device *); /*    24     8 */
>         enum {
>                 DSA_PORT_TYPE_UNUSED = 0,
>                 DSA_PORT_TYPE_CPU    = 1,
>                 DSA_PORT_TYPE_DSA    = 2,
>                 DSA_PORT_TYPE_USER   = 3,
>         } type;                                          /*    32     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         struct dsa_switch *        ds;                   /*    40     8 */
>         unsigned int               index;                /*    48     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         const char  *              name;                 /*    56     8 */
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         struct dsa_port *          cpu_dp;               /*    64     8 */
>         u8                         mac[6];               /*    72     6 */
>         u8                         stp_state;            /*    78     1 */
> 
>         /* XXX 1 byte hole, try to pack */
> 
>         struct device_node *       dn;                   /*    80     8 */
>         unsigned int               ageing_time;          /*    88     4 */
>         bool                       vlan_filtering;       /*    92     1 */
>         bool                       learning;             /*    93     1 */
> 
>         /* XXX 2 bytes hole, try to pack */
> 
>         struct dsa_bridge *        bridge;               /*    96     8 */
>         struct devlink_port        devlink_port;         /*   104   288 */
>         /* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
>         bool                       devlink_port_setup;   /*   392     1 */
> 
>         /* XXX 7 bytes hole, try to pack */
> 
>         struct phylink *           pl;                   /*   400     8 */
>         struct phylink_config      pl_config;            /*   408    40 */
>         /* --- cacheline 7 boundary (448 bytes) --- */
>         struct net_device *        lag_dev;              /*   448     8 */
>         bool                       lag_tx_enabled;       /*   456     1 */
> 
>         /* XXX 7 bytes hole, try to pack */
> 
>         struct net_device *        hsr_dev;              /*   464     8 */
>         struct list_head           list;                 /*   472    16 */
>         const struct ethtool_ops  * orig_ethtool_ops;    /*   488     8 */
>         const struct dsa_netdevice_ops  * netdev_ops;    /*   496     8 */
>         struct mutex               addr_lists_lock;      /*   504    32 */
>         /* --- cacheline 8 boundary (512 bytes) was 24 bytes ago --- */
>         struct list_head           fdbs;                 /*   536    16 */
>         struct list_head           mdbs;                 /*   552    16 */
>         bool                       setup;                /*   568     1 */
> 
>         /* size: 576, cachelines: 9, members: 30 */
>         /* sum members: 544, holes: 6, sum holes: 25 */
>         /* padding: 7 */
> };
> 
> After:
> 
> pahole -C dsa_port net/dsa/slave.o
> struct dsa_port {
>         union {
>                 struct net_device * master;              /*     0     8 */
>                 struct net_device * slave;               /*     0     8 */
>         };                                               /*     0     8 */
>         const struct dsa_device_ops  * tag_ops;          /*     8     8 */
>         struct dsa_switch_tree *   dst;                  /*    16     8 */
>         struct sk_buff *           (*rcv)(struct sk_buff *, struct net_device *); /*    24     8 */
>         enum {
>                 DSA_PORT_TYPE_UNUSED = 0,
>                 DSA_PORT_TYPE_CPU    = 1,
>                 DSA_PORT_TYPE_DSA    = 2,
>                 DSA_PORT_TYPE_USER   = 3,
>         } type;                                          /*    32     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         struct dsa_switch *        ds;                   /*    40     8 */
>         unsigned int               index;                /*    48     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         const char  *              name;                 /*    56     8 */
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         struct dsa_port *          cpu_dp;               /*    64     8 */
>         u8                         mac[6];               /*    72     6 */
>         u8                         stp_state;            /*    78     1 */
>         u8                         vlan_filtering:1;     /*    79: 0  1 */
>         u8                         learning:1;           /*    79: 1  1 */
>         u8                         lag_tx_enabled:1;     /*    79: 2  1 */
>         u8                         devlink_port_setup:1; /*    79: 3  1 */
>         u8                         setup:1;              /*    79: 4  1 */
> 
>         /* XXX 3 bits hole, try to pack */
> 
>         struct device_node *       dn;                   /*    80     8 */
>         unsigned int               ageing_time;          /*    88     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         struct dsa_bridge *        bridge;               /*    96     8 */
>         struct devlink_port        devlink_port;         /*   104   288 */
>         /* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
>         struct phylink *           pl;                   /*   392     8 */
>         struct phylink_config      pl_config;            /*   400    40 */
>         struct net_device *        lag_dev;              /*   440     8 */
>         /* --- cacheline 7 boundary (448 bytes) --- */
>         struct net_device *        hsr_dev;              /*   448     8 */
>         struct list_head           list;                 /*   456    16 */
>         const struct ethtool_ops  * orig_ethtool_ops;    /*   472     8 */
>         const struct dsa_netdevice_ops  * netdev_ops;    /*   480     8 */
>         struct mutex               addr_lists_lock;      /*   488    32 */
>         /* --- cacheline 8 boundary (512 bytes) was 8 bytes ago --- */
>         struct list_head           fdbs;                 /*   520    16 */
>         struct list_head           mdbs;                 /*   536    16 */
> 
>         /* size: 552, cachelines: 9, members: 30 */
>         /* sum members: 539, holes: 3, sum holes: 12 */
>         /* sum bitfield members: 5 bits, bit holes: 1, sum bit holes: 3 bits */
>         /* last cacheline: 40 bytes */
> };
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
