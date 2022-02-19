Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD184BC736
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 10:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240034AbiBSJrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 04:47:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiBSJrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 04:47:18 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10411D306;
        Sat, 19 Feb 2022 01:46:58 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id c6so16820285edk.12;
        Sat, 19 Feb 2022 01:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/XWKW3hXKwgMLnnsxhCBCrgwGI2F5Yo37z9iyRvkHiA=;
        b=AUhiSel2N0gBkGTcaCFrjl7jkXyeTaKqPx2ITTFfYG4KjKB1fwAIqHS1dFkxHiu9ut
         tEgvHKAIp4b9Rhdo8MavC60vsCgBFP47xm5hEk9hazaMKpb4ISTM1ex6CG9xdcefuQ8f
         3AYGmeN8XhDs0+j1c9VhFI3FKGtS9731XlPcjxCwU6Q3AZOLHnz2RJylDlpyDisNk7Ol
         jKJOYC+ar2avFkoTNQrqlHW4bm79Ku8JGFfxBFrDHQePQ4wn938qyK3OQuEKBPoZCmqH
         byylMVprhxuAWp+lgF/kYwPEWjej6rYdwLmo31BT0cZIz4cga7RdIsqpNS02tOOlU5rW
         AwtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/XWKW3hXKwgMLnnsxhCBCrgwGI2F5Yo37z9iyRvkHiA=;
        b=Z4mYfurpk4Qn1Os0V8Gi+HGprEVtxIKfw2Qf99U0fbSszY9pUzchf+v+XWoBmY1wlR
         sJmKrhPoiqoR28bQ3cxGTa6/AX/X8t2XQWQHslSl++tFmh0/Z9O4UAz9y22enhPrbnEh
         D81x/6wnbcRxrVCIfQ8ForBPaBJxg+4eDdZhtqCVM3QYKIm+wPMjXXWfUQ7gAjccRmjR
         f/e9F0Gfc+zpkdZeuPn4X7P3+Gp4z8/rmE6We4VKVQPMTzrcJJY7vXEQohR7yuPBhIrA
         nFchxQ/BdHnXGFJMVx8v1x2V2mNUNjCa2AF3ofunMLOigJBJmLNwTE7iX+skhisZw4UX
         zh4A==
X-Gm-Message-State: AOAM533I48z/ezyx9kZxhDf7mpWmDdnJu/x8knNSwqfW6Kp/7lN6OuKW
        E3jlPM4CP2K83rEXSS97MAL21gsSRm8=
X-Google-Smtp-Source: ABdhPJxp/DNNvAmL06lvP1Ci+JZBjA9JHl9A2Viq6YLIaWOISAD71J44Lg5B5CkS1Fb3aEWSFfygGA==
X-Received: by 2002:a05:6402:7cb:b0:410:dde2:5992 with SMTP id u11-20020a05640207cb00b00410dde25992mr12439954edy.323.1645264016988;
        Sat, 19 Feb 2022 01:46:56 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id u27sm3015170ejc.220.2022.02.19.01.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 01:46:56 -0800 (PST)
Date:   Sat, 19 Feb 2022 11:46:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/1] net: dsa: microchip: ksz9477: export HW
 stats over stats64 interface
Message-ID: <20220219094655.p3dkupwe3bkwwly6@skbuf>
References: <20220219082630.2454948-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220219082630.2454948-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 19, 2022 at 09:26:30AM +0100, Oleksij Rempel wrote:
> Provide access to HW offloaded packets over stats64 interface.
> The rx/tx_bytes values needed some fixing since HW is accounting size of
> the Ethernet frame together with FCS.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
> changes v4:
> - do not copy raw counters to the stack
> changes v3:
> - move dev->dev_ops->r_mib_stat64 insight of the mutex
> changes v2:
> - fix locking issue in in atomic context
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
