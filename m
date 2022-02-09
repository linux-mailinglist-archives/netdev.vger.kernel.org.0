Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08004AF4AC
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbiBIPDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbiBIPDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:03:23 -0500
X-Greylist: delayed 909 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 07:03:27 PST
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FF3C0613C9
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 07:03:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1644418054; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=TjSgu9sZsyKr/hEIFKeJoy8pAugybVEUIG2BbddlTrs/AzVW06uYW0wauusGZd1/x2gqVFeErVdMmZTGCV977DymOq79p4kbgo0g8G/TTySGUNIuIBucp4FqADBDddVFu45vp9XSpagMGUCLyrlLsASlnwdqVMrhsmhQAySobVE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1644418054; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=kmwejnD0khrSw7Jzk3gPGadOWupapvsORfk9uYGhYd8=; 
        b=ZfRt3CP6bd8JCsvrDkWACX5GpUwqQH8HPkoDpdKMq0KlyXyLVrvP4BF63Csvjie+bhLvvPKdwZR+gGYEqcFz7yDUJzB/yfWFOTS7wBtnyPB3W3g3g+DXbAhGCedhmLhnmlpkJ1KOF+wKJshTEph8ljTgN92mEtxp0UDiX0Sjr14=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1644418054;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=kmwejnD0khrSw7Jzk3gPGadOWupapvsORfk9uYGhYd8=;
        b=dtNvbm1VL5aQ7kRJ3HU8prbsmNoyKbtJT6VpnGh3kx9eJngRuoRUbnyu6offD4tt
        y9tws15N7pKZwvLJgg4u1Kj6ngAU/o9Trel972AB06beF6VH61aRGTihbjkf0PqFbAl
        JWjqjnvn3w6MV7vuG9bf+d8ZvcKZZGtXwriz2P5c=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1644418053600780.3051547022845; Wed, 9 Feb 2022 06:47:33 -0800 (PST)
Message-ID: <24eba648-9029-e66f-aa2c-31ddbc7b1199@arinc9.com>
Date:   Wed, 9 Feb 2022 17:47:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
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
Cc:     Hauke Mehrtens <hauke@hauke-m.de>
References: <20220209143948.445823-1-dqfext@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220209143948.445823-1-dqfext@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2022 17:39, DENG Qingfang wrote:
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

Thanks for submitting this!

Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Cheers.
Arınç
