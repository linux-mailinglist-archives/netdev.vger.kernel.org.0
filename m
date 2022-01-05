Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8C6485865
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243011AbiAESc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243012AbiAEScv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:32:51 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5E7C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 10:32:50 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id w7so219803plp.13
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 10:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=npGv5ZlvCr3q6bCN+G4C/LCqkRtJ1nv2D1XF6wv8wNc=;
        b=GlGG9c2ZyuoKTRfN90bMWUW3wBtJjC7H4uxws0vrfHjo10PLE5pelYav0QVV1M1Xz4
         XSrWs+RRdvTe+O2dyS1gR120YPa88KIx60ARIndjTEHRRw0LU2OuEpqPjPodMVvXNgh9
         DPdrarQJ1sbWLJ/mYXz5++wU2+2cBkbzp2+3a8vY+TmLMpwkIunaRfeQp0Qj9QTmtIHP
         VEpwzUdEh14QfTQz5Dz5OP14nwRpDrJhgu/nHAD9dX9z+ViDI31kRUlxbDcMcuOx6uTY
         RhjFrHyQHLVzE0CyNazD+E44cfLZ/6MiRc3TbvZLepcrCL77/PbhjkXnp4+wovX9Br3O
         PdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=npGv5ZlvCr3q6bCN+G4C/LCqkRtJ1nv2D1XF6wv8wNc=;
        b=h6aZTqSWcslQ6Wlp8SOP3NkwIewxg3zvddYGVtHpH3HfoKbNEAb4FwNdY6owQcjlQ0
         TAD3lUmNrk7gLqDX1fEUdIf8B539hVcZrXAQYB1ssKXrK7zbK3fBqRMsdrbiW2vgSjFW
         +bxvyZWNWlSg/RDEmo6fA+gCIv5kVDWqsacs6sXvNw4X8/J7VyDFiyeKF2BAuV+fGmuu
         YsBkrMP+DJPxy4UBY1aPhR7ljaiRnZLpblqdFex4V8gVmiSPApxRHClz9SiUsdcXB6aH
         ND+JX58dWhgdOaeBVQsEI+U26zXMAN8PRkn9lpYq+eeIOzFMJhWL9d84lkgmoVGTrOei
         6jvQ==
X-Gm-Message-State: AOAM5324xfnQoqHQ9F+Zb7EmMpf+LKkDjIBbuB+kb7oyjaIKVZ/03/8x
        6HeLTN6rSeZdyVucbVlgC18=
X-Google-Smtp-Source: ABdhPJyWZKfiYTCjnQ2OmA8Xr+rSY87J+bMdcvFi28uIG5aatIYwLj9kcyfmDgOlJXjqA9/B9OP1XQ==
X-Received: by 2002:a17:90a:7101:: with SMTP id h1mr5545900pjk.93.1641407570401;
        Wed, 05 Jan 2022 10:32:50 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z13sm28532650pgi.75.2022.01.05.10.32.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 10:32:49 -0800 (PST)
Subject: Re: [PATCH v2 net-next 4/7] net: dsa: merge all bools of struct
 dsa_switch into a single u32
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <20220105132141.2648876-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ac686bdb-470b-07ab-2ef9-3d47fd06e6cd@gmail.com>
Date:   Wed, 5 Jan 2022 10:32:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220105132141.2648876-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 5:21 AM, Vladimir Oltean wrote:
> struct dsa_switch has 9 boolean properties, many of which are in fact
> set by drivers for custom behavior (vlan_filtering_is_global,
> needs_standalone_vlan_filtering, etc etc). The binary layout of the
> structure could be improved. For example, the "bool setup" at the
> beginning introduces a gratuitous 7 byte hole in the first cache line.
> 
> The change merges all boolean properties into bitfields of an u32, and
> places that u32 in the first cache line of the structure, since many
> bools are accessed from the data path (untag_bridge_pvid, vlan_filtering,
> vlan_filtering_is_global).
> 
> We place this u32 after the existing ds->index, which is also 4 bytes in
> size. As a positive side effect, ds->tagger_data now fits into the first
> cache line too, because 4 bytes are saved.
> 
> Before:
> 
> pahole -C dsa_switch net/dsa/slave.o
> struct dsa_switch {
>         bool                       setup;                /*     0     1 */
> 
>         /* XXX 7 bytes hole, try to pack */
> 
>         struct device *            dev;                  /*     8     8 */
>         struct dsa_switch_tree *   dst;                  /*    16     8 */
>         unsigned int               index;                /*    24     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         struct notifier_block      nb;                   /*    32    24 */
> 
>         /* XXX last struct has 4 bytes of padding */
> 
>         void *                     priv;                 /*    56     8 */
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         void *                     tagger_data;          /*    64     8 */
>         struct dsa_chip_data *     cd;                   /*    72     8 */
>         const struct dsa_switch_ops  * ops;              /*    80     8 */
>         u32                        phys_mii_mask;        /*    88     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         struct mii_bus *           slave_mii_bus;        /*    96     8 */
>         unsigned int               ageing_time_min;      /*   104     4 */
>         unsigned int               ageing_time_max;      /*   108     4 */
>         struct dsa_8021q_context * tag_8021q_ctx;        /*   112     8 */
>         struct devlink *           devlink;              /*   120     8 */
>         /* --- cacheline 2 boundary (128 bytes) --- */
>         unsigned int               num_tx_queues;        /*   128     4 */
>         bool                       vlan_filtering_is_global; /*   132     1 */
>         bool                       needs_standalone_vlan_filtering; /*   133     1 */
>         bool                       configure_vlan_while_not_filtering; /*   134     1 */
>         bool                       untag_bridge_pvid;    /*   135     1 */
>         bool                       assisted_learning_on_cpu_port; /*   136     1 */
>         bool                       vlan_filtering;       /*   137     1 */
>         bool                       pcs_poll;             /*   138     1 */
>         bool                       mtu_enforcement_ingress; /*   139     1 */
>         unsigned int               num_lag_ids;          /*   140     4 */
>         unsigned int               max_num_bridges;      /*   144     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         size_t                     num_ports;            /*   152     8 */
> 
>         /* size: 160, cachelines: 3, members: 27 */
>         /* sum members: 141, holes: 4, sum holes: 19 */
>         /* paddings: 1, sum paddings: 4 */
>         /* last cacheline: 32 bytes */
> };
> 
> After:
> 
> pahole -C dsa_switch net/dsa/slave.o
> struct dsa_switch {
>         struct device *            dev;                  /*     0     8 */
>         struct dsa_switch_tree *   dst;                  /*     8     8 */
>         unsigned int               index;                /*    16     4 */
>         u32                        setup:1;              /*    20: 0  4 */
>         u32                        vlan_filtering_is_global:1; /*    20: 1  4 */
>         u32                        needs_standalone_vlan_filtering:1; /*    20: 2  4 */
>         u32                        configure_vlan_while_not_filtering:1; /*    20: 3  4 */
>         u32                        untag_bridge_pvid:1;  /*    20: 4  4 */
>         u32                        assisted_learning_on_cpu_port:1; /*    20: 5  4 */
>         u32                        vlan_filtering:1;     /*    20: 6  4 */
>         u32                        pcs_poll:1;           /*    20: 7  4 */
>         u32                        mtu_enforcement_ingress:1; /*    20: 8  4 */
> 
>         /* XXX 23 bits hole, try to pack */
> 
>         struct notifier_block      nb;                   /*    24    24 */
> 
>         /* XXX last struct has 4 bytes of padding */
> 
>         void *                     priv;                 /*    48     8 */
>         void *                     tagger_data;          /*    56     8 */
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         struct dsa_chip_data *     cd;                   /*    64     8 */
>         const struct dsa_switch_ops  * ops;              /*    72     8 */
>         u32                        phys_mii_mask;        /*    80     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         struct mii_bus *           slave_mii_bus;        /*    88     8 */
>         unsigned int               ageing_time_min;      /*    96     4 */
>         unsigned int               ageing_time_max;      /*   100     4 */
>         struct dsa_8021q_context * tag_8021q_ctx;        /*   104     8 */
>         struct devlink *           devlink;              /*   112     8 */
>         unsigned int               num_tx_queues;        /*   120     4 */
>         unsigned int               num_lag_ids;          /*   124     4 */
>         /* --- cacheline 2 boundary (128 bytes) --- */
>         unsigned int               max_num_bridges;      /*   128     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         size_t                     num_ports;            /*   136     8 */
> 
>         /* size: 144, cachelines: 3, members: 27 */
>         /* sum members: 132, holes: 2, sum holes: 8 */
>         /* sum bitfield members: 9 bits, bit holes: 1, sum bit holes: 23 bits */
>         /* paddings: 1, sum paddings: 4 */
>         /* last cacheline: 16 bytes */
> };
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
