Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0E848588B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243068AbiAESfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243124AbiAESe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:34:58 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27312C03400A
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 10:34:53 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id c2so156352pfc.1
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 10:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IY6ucR4okLWFvolvKhSHphA+DI8wkBofqir0erP5xFs=;
        b=RBTx537KoleE3j1RlJNHoTGO6sIV0x5wbbdgHzNLUBLi9nT/uRzKuqYVMSxTq9Hb2b
         OWk5mGc12Bl1lxla1iLiggo7FDikz3ZzPZPBi7UyjfWFgRYOWqZzX+H5rGMEUjBxpwg3
         yZqU1rruUmDk8qUs3cw1B9jgcTdEjUWHPDssW4uhlLDvS9TDb8jGoCZGxXcrPQMHLQKX
         2iwoKj+p/oIqvtGF+vcojcJuOt4atQiRQrVDxFXBuyFvL2x7I149VX7fuHbXnHkHNGew
         chTnmAk7SrM/MNLP+qdj30MTkvifEpd5od6qCl5bBE8KsefPmh+hSqZXLHJh1vqaJ7M3
         NZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IY6ucR4okLWFvolvKhSHphA+DI8wkBofqir0erP5xFs=;
        b=BlM7hkHYmhMWpCBuEjB/jcn0PuKU8f1fA3zR4YLNNRq2AAvkHak1PaX3lddfLCtliv
         Z2FfKqpkymX0HfEUHLj9LHwjGakO/cFz4DCE6cxTi/XMMBOVNyK7vIz6TV9vGRD3GzdJ
         b5FfUEeLP4Y2EC4dyDVLrDc89Ym97P41yObUYA7CZm4MEp91sPyhD47VW3LOuGSgrxp4
         DTmn846F9hI96DjwIgQ0+wHnEfS0BBl2ViPCEgBKTpEaqNtvLRj9lJGNtY8FxRAF68TP
         63mwfKP5O9a4fxen9mt6aEopKUG5FZjC9RdiJQKsCNf3592/K6j41TH93CW1P1oIQQGI
         fK9Q==
X-Gm-Message-State: AOAM5335SsuK1MZeVEcFoZgPeWxnU38YIqr1ayK7bJz/ATvnfOe7oOrx
        miYSY6woNtX32zkyoCyuesqFRo8QOxQ=
X-Google-Smtp-Source: ABdhPJwCHNz19NGsN2rkk++hyalkHuV8tMRzF4HvOZmBFOmrUA5w/FcY9c4WzySGoBUk9Bg3nLd+7A==
X-Received: by 2002:a63:954f:: with SMTP id t15mr2670730pgn.9.1641407692640;
        Wed, 05 Jan 2022 10:34:52 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t191sm38343337pgd.3.2022.01.05.10.34.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 10:34:52 -0800 (PST)
Subject: Re: [PATCH v2 net-next 7/7] net: dsa: combine two holes in struct
 dsa_switch_tree
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <20220105132141.2648876-8-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <89fd1983-c4d5-3a95-7834-eeb8480c716e@gmail.com>
Date:   Wed, 5 Jan 2022 10:34:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220105132141.2648876-8-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 5:21 AM, Vladimir Oltean wrote:
> There is a 7 byte hole after dst->setup and a 4 byte hole after
> dst->default_proto. Combining them, we have a single hole of just 3
> bytes on 64 bit machines.
> 
> Before:
> 
> pahole -C dsa_switch_tree net/dsa/slave.o
> struct dsa_switch_tree {
>         struct list_head           list;                 /*     0    16 */
>         struct list_head           ports;                /*    16    16 */
>         struct raw_notifier_head   nh;                   /*    32     8 */
>         unsigned int               index;                /*    40     4 */
>         struct kref                refcount;             /*    44     4 */
>         struct net_device * *      lags;                 /*    48     8 */
>         bool                       setup;                /*    56     1 */
> 
>         /* XXX 7 bytes hole, try to pack */
> 
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         const struct dsa_device_ops  * tag_ops;          /*    64     8 */
>         enum dsa_tag_protocol      default_proto;        /*    72     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         struct dsa_platform_data * pd;                   /*    80     8 */
>         struct list_head           rtable;               /*    88    16 */
>         unsigned int               lags_len;             /*   104     4 */
>         unsigned int               last_switch;          /*   108     4 */
> 
>         /* size: 112, cachelines: 2, members: 13 */
>         /* sum members: 101, holes: 2, sum holes: 11 */
>         /* last cacheline: 48 bytes */
> };
> 
> After:
> 
> pahole -C dsa_switch_tree net/dsa/slave.o
> struct dsa_switch_tree {
>         struct list_head           list;                 /*     0    16 */
>         struct list_head           ports;                /*    16    16 */
>         struct raw_notifier_head   nh;                   /*    32     8 */
>         unsigned int               index;                /*    40     4 */
>         struct kref                refcount;             /*    44     4 */
>         struct net_device * *      lags;                 /*    48     8 */
>         const struct dsa_device_ops  * tag_ops;          /*    56     8 */
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         enum dsa_tag_protocol      default_proto;        /*    64     4 */
>         bool                       setup;                /*    68     1 */
> 
>         /* XXX 3 bytes hole, try to pack */
> 
>         struct dsa_platform_data * pd;                   /*    72     8 */
>         struct list_head           rtable;               /*    80    16 */
>         unsigned int               lags_len;             /*    96     4 */
>         unsigned int               last_switch;          /*   100     4 */
> 
>         /* size: 104, cachelines: 2, members: 13 */
>         /* sum members: 101, holes: 1, sum holes: 3 */
>         /* last cacheline: 40 bytes */
> };
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
