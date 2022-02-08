Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8CE4ADC40
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352648AbiBHPSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239424AbiBHPSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:18:36 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1108FC061577
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 07:18:34 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id s13so53123994ejy.3
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 07:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aOLzuOLlP/f98S9a3BMaCLPxZQ1gBmNEHnx7naa6bCg=;
        b=fq38nRJ58BfqG1umexttXe1iglNFMZFrWjYgIlSHztXyBxXDksB8WdErZAaht4PMHl
         YSXmMbHyJXM1N5NeWG2XXTw5G/4CHC9rtiN9IqXPxveNtTnku2BWZ4hrqd9wWpMiCSG2
         1/9DyRwFn1edi5EDo33Lf5d2mSCafxPLx6hLghlWkvA1rr1umd/7vk+DhYRZT6OLzOZn
         pZJ5TISWMnzRwkOVN4akKPfgOtGS4V6xgqzeK53tKPZ5uHXAltdGz3bldCYlWg7EDU8U
         ijPyZhko33vqcrf1HHKFb5iuxSEh5oRDdzUrub1jTs2jXnAJWxBUvhsJFtdRFodX7gT8
         KG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aOLzuOLlP/f98S9a3BMaCLPxZQ1gBmNEHnx7naa6bCg=;
        b=02rwC1huLPeyq7Kd7dCtSwFQHQ3gZFxGOpfu2Nl0aCNf99p4m4BFggDxRAsBhcniOZ
         3GCq/gZnlsL1girCOm8haMRv23tG6X0xf4PZ5GiqqjBxqLTcRkvVuXoL5eJux1rt5hgv
         hCPNmwtjiSha5D7DN3Rf3UM8qzRjb4Qp7isX2DnO3McL+p9vLdzWlswUHiMfDo1uskUf
         VJKvh6S26DciA5DBWow0Gc0CsbVi7FkKnN7JdkVQaRQgcASnHkr7kREE1ynAFII/efrS
         BpMETRoZlRzKlfhc5lnwC821NgJhKlEO7fikrGL4DDZoPIXOhYkQaLZ1lf/qRRWUfoD5
         LP3Q==
X-Gm-Message-State: AOAM531aqAkl532T517fPPg/QrfXecS64b2c7YopKkLLZ93kzKCZHBoO
        M5YVPhxtUtdNja8c0t/8U3Y=
X-Google-Smtp-Source: ABdhPJwVlDeEhSsIAzH3hS8xAwdgYzE0uN4Q5JW9dUiDmr5yqXLYx3o4hG5OrUZTwQ/ZmDD35xjCGg==
X-Received: by 2002:a17:907:e8b:: with SMTP id ho11mr4300850ejc.650.1644333512435;
        Tue, 08 Feb 2022 07:18:32 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id r8sm2946543edt.65.2022.02.08.07.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 07:18:31 -0800 (PST)
Date:   Tue, 8 Feb 2022 16:18:28 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH CFT net-next 0/6] net: dsa: qca8k: convert to phylink_pcs
 and mark as non-legacy
Message-ID: <YgKJxKBF6/i2k0tR@Ansuel-xps.localdomain>
References: <YgKIIq2baq4yERS5@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgKIIq2baq4yERS5@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 03:11:30PM +0000, Russell King (Oracle) wrote:
> This series adds support into DSA for the mac_select_pcs method, and
> converts qca8k to make use of this, eventually marking qca8k as non-
> legacy.
> 
> Patch 1 adds DSA support for mac_select_pcs.

Was thinking... Is it possible to limit the polling just to sgmii/basex?
Would save some overhead in the case fixed-rate is set and the link
never change.

> Patch 2 and patch 3 moves code around in qca8k to make patch 4 more
> readable.
> Patch 4 does a simple conversion to phylink_pcs.
> Patch 5 moves the serdes configuration to phylink_pcs.
> Patch 6 marks qca8k as non-legacy.
> 
>  drivers/net/dsa/qca8k.c | 738 +++++++++++++++++++++++++++---------------------
>  drivers/net/dsa/qca8k.h |   8 +
>  include/net/dsa.h       |   3 +
>  net/dsa/port.c          |  15 +
>  4 files changed, 436 insertions(+), 328 deletions(-)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
	Ansuel
