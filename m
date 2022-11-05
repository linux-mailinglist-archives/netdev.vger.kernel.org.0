Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D256661DC1E
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 17:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiKEQh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 12:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKEQh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 12:37:56 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF00205C5
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 09:37:55 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id k2so20470995ejr.2
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 09:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hALesDv4QpHeBz2pINC8u6XGk4Uhnl75mpK79ICLHv8=;
        b=WXTiUP17D7LgxTRdDwME1baP1g3IXAWWWZMAMCeLW+p2vFE2Q3iC7Qdlm5wLLp55T4
         L4Hr6uz5klo9/88wDvtEscdNSsd7Q98TMC+s+dhgizE1+Upm030J/9Yg0MoSv1VrFh8h
         8A1BNXh1GGhBVjajH14aBGtGGSf/ViWXXRXZ3Wj19lSsg86gEqKg6NW9IobqyIcBZGSx
         Mkd1EOdcPQF7S7HgIJH4gwTBd2eypIO0+U9oo/GS2GWl4XEJR7l0fopdEdzeJ1PiAQKZ
         KeFkuhYVD0TaJRPe69uLHNZmHNegCslI6OYezGzJAOzZSfzGEdqxmEO4GYYctUWyew2a
         rimQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hALesDv4QpHeBz2pINC8u6XGk4Uhnl75mpK79ICLHv8=;
        b=xFxeDc/mHyFEgGDn+hHu8C7QZKloVuDIs4ORCNLeKss6hhMVshl26qmns/HWJ8w5gt
         RUiHh3EF2HBFex4Peq7xOX8v6yjSxgYXPhfkvHHFxgoOHQ6dFiu6cdywhXOdUkqhKMAM
         3PBiz0y+hAgxlvkr4wb9yL0XBlB6KcN7zo2HRDhwoFLR4cMJ2yAuctkt3tShjRH+Y9a7
         b9rrF9e+CX7pVNPw4SaPqagDqA5fUmE9N9TMzs0LyoGJYS2w+09L+HVAs4NvhFkdD/lF
         8gZs+f8y3WmfzbI+Z4luzWkIeg2KiGbGI8IYBVYHgfVZ44l4/Hg1ow2NlUBU/7IdKYNs
         sVUw==
X-Gm-Message-State: ACrzQf2flJIAdST3F/xf/av+n+OyslpDd3Xi/4KclKOzsdocrSwR6L/r
        3buyFN7SkjKULHLLCEwHKDU=
X-Google-Smtp-Source: AMsMyM6baw5e87J/KA9T2vgDa0H3WHbWFcIcP0QiNFOx19Xu6nq6S/HdvMmmwurGb/qCkzaNB3zCVQ==
X-Received: by 2002:a17:906:8a7b:b0:7ac:baef:6de1 with SMTP id hy27-20020a1709068a7b00b007acbaef6de1mr40090050ejc.734.1667666274146;
        Sat, 05 Nov 2022 09:37:54 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090630c900b0073de0506745sm1070509ejb.197.2022.11.05.09.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 09:37:53 -0700 (PDT)
Date:   Sat, 5 Nov 2022 18:37:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     piergiorgio.beruto@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: Potential issue with PHYs connected to the same MDIO bus and
 different MACs
Message-ID: <20221105163751.it2mxwobzhqwtyr4@skbuf>
References: <022c01d8f111$6e6e2580$4b4a7080$@gmail.com>
 <20221105133443.jlschsx6zvkrqbph@skbuf>
 <024601d8f124$5c797510$156c5f30$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <024601d8f124$5c797510$156c5f30$@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 05, 2022 at 03:39:07PM +0100, piergiorgio.beruto@gmail.com wrote:
>    priv->phylink_config.dev = &pdev->dev;
>    priv->phylink_config.type = PHYLINK_NETDEV;

The problem is here. You think that &pdev->dev is the same as
&ndev->dev, but it isn't (and it's SET_NETDEV_DEV that makes the linkage
between the 2). Use &ndev->dev here, and check out how phylink uses the
"dev" field:

#define to_net_dev(d) container_of(d, struct net_device, dev)

	if (config->type == PHYLINK_NETDEV) {
		pl->netdev = to_net_dev(config->dev);
