Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D4F485844
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242936AbiAESad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242941AbiAESaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:30:11 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58515C0611FF
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 10:30:11 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id m1so113012pfk.8
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 10:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sx+o5eEJvMumngfbgVfRePrwZnkLqGZDiHAJc/NSGMM=;
        b=IhRZmCg98s8idf7yCOPs4Jan1niIntjUm4a9y9g9VOTluTQWp5/swkrTNJTkAuI8B0
         WR9lgPEgv5o+lR589/S6r6ppTqb4uNihWvhOyAFPlbSNNpCXTbMZelzVkccX7Bn/uxqO
         SA4gLuoSg4edAMsASsUPl5GnzIsEt5lODMgHesUje2Se8uQY5is7INbdYiZA9s4kYtgz
         OijXu/RY36SRp5dquyQ2ymxrHbfllsieqnILTwJSq93iRLDuYhpS9hjGe2JhLNc1vsTS
         uarLsZiuTKUhDTQV4qYmmaEz76vNrRgtp3v8/nMaM4T/G1FI1On02sYLm2gvZ4uRiD3s
         eq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sx+o5eEJvMumngfbgVfRePrwZnkLqGZDiHAJc/NSGMM=;
        b=Q1ctDGcz/WXcCNX6AKiZ8uIh1j3MY6wcTPYcYBku0TIRRHSL8E/rD4rzjmp9wuMkwo
         Iy+ml1TZ1YRcMoTTtjRUSzr/d+xZy6KAbiugf2E5pS1pQ1an1/89SKy5MjZZVOeKv9Be
         Xm98habKCXEMCmuNZcOHmwfm6oGHXYyO9FCybVvOfM6KY9daBHrDaNzDKFhDfBHXraZz
         j5tnSUD2WCXa55o0Vd42pFm3T4PAE3PPpv9Jy/a+iK117FOd1ch5cZoDtZnN8YKej/6m
         WeT3Y6Ci95+zNsovTTLTdK1+yo6IbIo0pz5DJaiVlcsytrtKC6OfI25DpSWAEItn4yon
         POOA==
X-Gm-Message-State: AOAM530DhKpDJZfjGpYn04jd6MGmgR/UNCbKzW/6mdfgY7inXXcn3cbM
        z02TjMptn9bHIY/zyVpT4J4=
X-Google-Smtp-Source: ABdhPJzTbhHlXN6qqEy5epG1PT5SC8U91DgbpxLXFO+TXq+wISiEH3ihflBgRnqpaSHKZQgiJp/csg==
X-Received: by 2002:a63:5f84:: with SMTP id t126mr48830748pgb.553.1641407410793;
        Wed, 05 Jan 2022 10:30:10 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b5sm3993412pfm.155.2022.01.05.10.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 10:30:10 -0800 (PST)
Subject: Re: [PATCH v2 net-next 1/7] net: dsa: move dsa_port :: stp_state near
 dsa_port :: mac
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <20220105132141.2648876-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3f78cf69-fb44-c846-1af8-3408e1b7ef0a@gmail.com>
Date:   Wed, 5 Jan 2022 10:30:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220105132141.2648876-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 5:21 AM, Vladimir Oltean wrote:
> The MAC address of a port is 6 octets in size, and this creates a 2
> octet hole after it. There are some other u8 members of struct dsa_port
> that we can put in that hole. One such member is the stp_state.
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
> 
>         /* XXX 2 bytes hole, try to pack */
> 
>         struct device_node *       dn;                   /*    80     8 */
>         unsigned int               ageing_time;          /*    88     4 */
>         bool                       vlan_filtering;       /*    92     1 */
>         bool                       learning;             /*    93     1 */
>         u8                         stp_state;            /*    94     1 */
> 
>         /* XXX 1 byte hole, try to pack */
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
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
