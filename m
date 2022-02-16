Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5CC4B8A9B
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbiBPNrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:47:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbiBPNrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:47:24 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8134A6C902;
        Wed, 16 Feb 2022 05:47:11 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id h18so3999988edb.7;
        Wed, 16 Feb 2022 05:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aonyv9vG++jyXrz8AgRb6ka2sz/9zMglBjVPvI/MDfU=;
        b=G2GSZQE7F4Yu78XOwRPiQNuGFUI8BWaKqnkR45e891ALDyOa5FBdsU932UhSYFdNPP
         LquR9/kdib75rmH486xhIw4lNXmuBPtMB2twbn9+b3jdHBxvP6drq8Fk/0i5CtS/wpPe
         TKvIa2BnNX3kCo595jexClkt171EyD0okOZLxRTSmX6VQr8tHUnCGTC2ZbQDoLcAHepc
         5Nfx81Ip0yTOf5LFMnP6Mgm5GYUloHp6Kek4PM2PrEgsBgukpQ3RmgusJum3VMKOwWY2
         n4hss+Api+T5AXNYnlcNucdFu1qm92YsQzNcN+O3D2DN0GoM3SdqJo/HFrDQgaEgahJw
         +KJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aonyv9vG++jyXrz8AgRb6ka2sz/9zMglBjVPvI/MDfU=;
        b=wxmAGX+8hwKBAzIF6DJSCLY3+gZiEE5X/+ixyENt2N2oISFTgDNDTAgLcBzR97hlFE
         nB5k8upj+XmVuWVs1/MsCLlawGMQMXPSW97cae1uXOuPHAx/4YZRbj93ozBHbWARN/Dr
         j6cY6ziRYTs90o1+dT9sf86KYjtNJnZa2Zjn+G7j4MCEYjL/DkIkf1sf0L8Rcf4wZCxg
         nt5SufZEhC/uKCBXkPQcBd5KGdE+Lz6Al570G1DhSJK7upeR+Db+JlIcyIukhYBHPpwP
         rc4791vN65Ko+8e/JoUJJJYwGKWEkCPTAIkPOORQID7w8d6wFJkeEbd+PmhKw3X9A6Mz
         pzQg==
X-Gm-Message-State: AOAM533RdGWBMedqzHOuY5gYyJsepMj/TekBK7R4PTD/W4Q5JlIFxAee
        3jyIUe+fY6LwA8Y9vyUiwPWSj+66n6A=
X-Google-Smtp-Source: ABdhPJztsTibOp5md9hl09DvL/C/vQ72OlXmJzRVyxlTwsFAhOlQ/JDccpY7wAc8e3qpXJ5umkF58A==
X-Received: by 2002:a05:6402:11cc:b0:40f:b100:492a with SMTP id j12-20020a05640211cc00b0040fb100492amr3162079edw.282.1645019229855;
        Wed, 16 Feb 2022 05:47:09 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id b6sm12972854ejb.80.2022.02.16.05.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 05:47:09 -0800 (PST)
Date:   Wed, 16 Feb 2022 15:47:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mans Rullgard <mans@mansr.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <jbe@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: lan9303: handle hwaccel VLAN tags
Message-ID: <20220216134707.g247fqnvfbr4udbj@skbuf>
References: <20220216124634.23123-1-mans@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216124634.23123-1-mans@mansr.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 12:46:34PM +0000, Mans Rullgard wrote:
> Check for a hwaccel VLAN tag on rx and use it if present.  Otherwise,
> use __skb_vlan_pop() like the other tag parsers do.  This fixes the case
> where the VLAN tag has already been consumed by the master.
> 
> Signed-off-by: Mans Rullgard <mans@mansr.com>
> ---
> Changes:
> - call skb_push/pull only where actually needed
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
