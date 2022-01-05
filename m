Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32D148588C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243038AbiAESgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243104AbiAESef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:34:35 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1409C034003
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 10:34:33 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 196so117702pfw.10
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 10:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pntpRjyFC/F0v8c8Z0X2ljdzbMrjC1yDm7KW1TlpWTQ=;
        b=XJgII9YvoNq3a8+/W+Y13GolQYbm5CGN9zYgm1SFgb2K+mX/wJt7n0yvGZncjPx7xJ
         w+PSs8KTkST6XYvlRMIVtc/rqkZSfUOtDDr+BcmEycURWtfjxm14Vj8whYtzhKYDSbUD
         FIm8tyBtAw37o+PWwlKKdbHGRj71pDwiR4QM0BgI8Qq4WF6AHzSkbD4F5JIVxXpRjOKE
         Vh/oTYYeFNQng8rK0M9ZVLu8kYAD1rvSREgfRnnoI0Jvs/Tf8Vks7XcOJM3o9ZK0Q10c
         khvZ5dXHDtPUcPCpWNnsKlyuqO8WAa1ezrolp3Sxo/iCoEULHk1Yl/2dfBcg5ujx5gf9
         6Bww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pntpRjyFC/F0v8c8Z0X2ljdzbMrjC1yDm7KW1TlpWTQ=;
        b=3+dSmArdRFpffCUnx6ylRXFesjl3wZ/DEq/FkM49IHfFmPvh1V9MalwQhE/0btIzE9
         bpGYtf0K4zlhIPfWbEMrXL1hliOuHLV/d7AIqCRbWaco7oYXQVeMIHagPpJxQ6bLH9K9
         y1QEpAHaFhIouy4NjcFdkF+4nF/GIV6ivSCWx3g5GsziT3c4+kKFQlyGO9Ic4rtBQpU/
         WLmwzyMiKWYlcayht888vbbsc5SVjEphHbgl5NuMYEoYOHhyssY/lhCIDbwq23gfRJg/
         5KCBDSJosVznh9BMyO5HZY1fbOVC3OLCBubT9U0VWWQVPY65ZA/F2RZi/xgvomeJWJTy
         30lw==
X-Gm-Message-State: AOAM530RdAuYsYQIwR5+FD4qitr+Hmh3gTQjGLozSd+RE56qUZqXizuT
        dR9PUkan1Hg00nV9DdjaXYs=
X-Google-Smtp-Source: ABdhPJzYlXs/EmgAnDnWoRqtioOVmR2L+ohmzBbD6mEySIjdRha2clKOqqrNJ3drs22X1EWXhmG3lw==
X-Received: by 2002:a63:784e:: with SMTP id t75mr30961376pgc.285.1641407673152;
        Wed, 05 Jan 2022 10:34:33 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e30sm17577287pgb.10.2022.01.05.10.34.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 10:34:32 -0800 (PST)
Subject: Re: [PATCH v2 net-next 6/7] net: dsa: move dsa_switch_tree :: ports
 and lags to first cache line
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <20220105132141.2648876-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1dcc27f7-f223-d5dd-5945-917e76b1b9df@gmail.com>
Date:   Wed, 5 Jan 2022 10:34:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220105132141.2648876-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 5:21 AM, Vladimir Oltean wrote:
> dst->ports is accessed most notably by dsa_master_find_slave(), which is
> invoked in the RX path.
> 
> dst->lags is accessed by dsa_lag_dev(), which is invoked in the RX path
> of tag_dsa.c.
> 
> dst->tag_ops, dst->default_proto and dst->pd don't need to be in the
> first cache line, so they are moved out by this change.
> 
> Before:
> 
> pahole -C dsa_switch_tree net/dsa/slave.o
> struct dsa_switch_tree {
>         struct list_head           list;                 /*     0    16 */
>         struct raw_notifier_head   nh;                   /*    16     8 */
>         unsigned int               index;                /*    24     4 */
>         struct kref                refcount;             /*    28     4 */
>         bool                       setup;                /*    32     1 */
> 
>         /* XXX 7 bytes hole, try to pack */
> 
>         const struct dsa_device_ops  * tag_ops;          /*    40     8 */
>         enum dsa_tag_protocol      default_proto;        /*    48     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         struct dsa_platform_data * pd;                   /*    56     8 */
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         struct list_head           ports;                /*    64    16 */
>         struct list_head           rtable;               /*    80    16 */
>         struct net_device * *      lags;                 /*    96     8 */
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
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
