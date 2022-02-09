Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9024AFFE7
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 23:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbiBIWLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 17:11:53 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiBIWLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 17:11:52 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577C4DF8E3F8;
        Wed,  9 Feb 2022 14:11:51 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4JvDcc45vzz9sQq;
        Wed,  9 Feb 2022 23:11:44 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1644444702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jWD3hlhZOdYnBOvsmD40qoO3MXZ/D9lG7XrV59Xi8M0=;
        b=h/WVcaCi9/b9Muo4p+HpswPv2dMJqcmTjdbMNngx/TlViOyH+PSKSFlT9sLJ2CQ162RUkE
        fSi2EiEU+3VQItviu2KC1fq0r9yMJXT6F7riJGHS6S2hUN/CDSPTjM7X3QDdEnPCH439G4
        cgCPYrJ1Hzjl62XBONFHx4jU1y7rwtJ0l18mGno4MNWuTZ4e4Qmml6j+SNtSzQd1vz7Bnx
        XIhOIVD55Ie2hD5sA4udCCg3UlkXAGRKTNrjzwglPIPr6YFgMFdwfPfDw7Y1Z1RToPHH9j
        FRmstvJWZQL+DKFhfmXjeKyxZP2nJx6ScgL47vXPWXFPDuKW8FkXMVyyy6frzQ==
Message-ID: <788ac214-7fd9-33b8-38da-54690a24bdef@hauke-m.de>
Date:   Wed, 9 Feb 2022 23:11:38 +0100
MIME-Version: 1.0
Subject: Re: [PATCH net] net: phy: mediatek: remove PHY mode check on MT7531
Content-Language: en-US
To:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
References: <20220209143948.445823-1-dqfext@gmail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
In-Reply-To: <20220209143948.445823-1-dqfext@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/22 15:39, DENG Qingfang wrote:
> The function mt7531_phy_mode_supported in the DSA driver set supported
> mode to PHY_INTERFACE_MODE_GMII instead of PHY_INTERFACE_MODE_INTERNAL
> for the internal PHY, so this check breaks the PHY initialization:
> 
> mt7530 mdio-bus:00 wan (uninitialized): failed to connect to PHY: -EINVAL
> 
> Remove the check to make it work again.
> 
> Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
> Fixes: e40d2cca0189 ("net: phy: add MediaTek Gigabit Ethernet PHY driver")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Tested-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>   drivers/net/phy/mediatek-ge.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/phy/mediatek-ge.c b/drivers/net/phy/mediatek-ge.c
> index b7a5ae20edd5..68ee434f9dea 100644
> --- a/drivers/net/phy/mediatek-ge.c
> +++ b/drivers/net/phy/mediatek-ge.c
> @@ -55,9 +55,6 @@ static int mt7530_phy_config_init(struct phy_device *phydev)
>   
>   static int mt7531_phy_config_init(struct phy_device *phydev)
>   {
> -	if (phydev->interface != PHY_INTERFACE_MODE_INTERNAL)
> -		return -EINVAL;
> -
>   	mtk_gephy_config_init(phydev);
>   
>   	/* PHY link down power saving enable */

