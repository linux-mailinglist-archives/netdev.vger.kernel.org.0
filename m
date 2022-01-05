Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0853485868
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242986AbiAESdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiAESda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:33:30 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23969C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 10:33:30 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id q14so262547plx.4
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 10:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=We5ZLFF7FCYNDQwDlqQeVAuri2qng050bY5fw660duM=;
        b=bMi6Xx6P2ccLiB5nSQ586BI9+qWz6/ROGpKQjsPB9pl0HLVJfc1f6KRB+QJc0Xttvi
         cYXR69OEb0lS2FYO0JrerHaXBNs0AaTPvYI9hEP9E4x14REobFsueCq65Xa0l0EUvycG
         zVnFZX0D4j66db2E1LwjFwWOgjs+fJVwI+Nkp0AerXiox01EfgKrTBWW1+ynn/cqK9PG
         JRH7v+9yVOX+jYvdljgnYkgxpfwi7xjT7r5PnFqH9rYqit4v6bvJgEXGYYrbk1Gy9IOD
         7BBeaUMY/WPAbrLnv1L0piqvgwrbGr05QpJGHRC4iicbIZOMVs+tK6IyUxHYsUaDZ4KO
         W5Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=We5ZLFF7FCYNDQwDlqQeVAuri2qng050bY5fw660duM=;
        b=r/bwKJFxkastAx7BKbR06lJNrOBkJqN+PJ6oAuegoYxAVy2RtTNUv9t4UxI4Apd8A9
         uaZBa+2hZ0VTQo68jNeYktTP1kJzAdLits22wv+qBe7EzUrLHZnYVdannm+3kneq7LrW
         n8C1uHZtlh9jv7wCWhTADNGShvheOSTeNV7Nr0YrWiBTy+lwI1SoywJ9jA/tA8N2lZYD
         PRRh50zRWxt/eFBOIcrG8t579YoAPT226ktWZH4M5GGMU1ml7MmfZMZ1wZI58s9tzo09
         9mBFVtbBfdBSzkOqOu4sGTFZYifN+wI8zNh52q9ESaQTQXllWHd0AuBmt80/a6xseGVT
         bwSg==
X-Gm-Message-State: AOAM533OFtIN8HQUSIvG5QffanZGROGRA2TSuCBmmhmEmoF1n9L1Xrd5
        Dl2xfHGsvxtm0imbFjzkPsA=
X-Google-Smtp-Source: ABdhPJwQjWOud3O5rEvjKAOkLPh0SvQ3BQgageTqkaq3cdryvWwed3uOBwswFWTqvrXU7lqElQ3k6A==
X-Received: by 2002:a17:902:ec81:b0:149:e9df:561b with SMTP id x1-20020a170902ec8100b00149e9df561bmr992930plg.59.1641407609648;
        Wed, 05 Jan 2022 10:33:29 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b21sm12174032pfv.74.2022.01.05.10.33.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 10:33:29 -0800 (PST)
Subject: Re: [PATCH v2 net-next 5/7] net: dsa: make dsa_switch :: num_ports an
 unsigned int
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <20220105132141.2648876-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e77ee553-732a-87ab-dcd9-ae1ae283e0c8@gmail.com>
Date:   Wed, 5 Jan 2022 10:33:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220105132141.2648876-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 5:21 AM, Vladimir Oltean wrote:
> Currently, num_ports is declared as size_t, which is defined as
> __kernel_ulong_t, therefore it occupies 8 bytes of memory.
> 
> Even switches with port numbers in the range of tens are exotic, so
> there is no need for this amount of storage.
> 
> Additionally, because the max_num_bridges member right above it is also
> 4 bytes, it means the compiler needs to add padding between the last 2
> fields. By reducing the size, we don't need that padding and can reduce
> the struct size.
> 
> Before:
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
>         unsigned int               num_ports;            /*   132     4 */
> 
>         /* size: 136, cachelines: 3, members: 27 */
>         /* sum members: 128, holes: 1, sum holes: 4 */
>         /* sum bitfield members: 9 bits, bit holes: 1, sum bit holes: 23 bits */
>         /* paddings: 1, sum paddings: 4 */
>         /* last cacheline: 8 bytes */
> };
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
