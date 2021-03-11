Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0D833800B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhCKWFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhCKWEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 17:04:53 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F85CC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 14:04:53 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id f1so42339498lfu.3
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 14:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gxZSZ0LuPRPFwUXxMFQMDqK16uOk/NPez/kgLYZBwMA=;
        b=iOpYNPhGkQ4YZUZQYBr/OOZTkpb9DULJEV94mgOr1JM4krEPIYALy+hxyiisH5nfk5
         DZ5NELnvNtUiCAr2TYrlxnz9UV685yH3Z9a3M3rlJoU27tc1fZGfw0Cww0ApNVZ8B2ek
         dEQ/dHWPYh6exHshevz2OjuHTOYOq4nsrr5bi4yZP3ocFbz304wXq1fUcgvjbYPsqTfP
         XVT2ZKx2fRXNND2rkcqKCKb3QucvvmU1h91abDkodamRP6Wj0+AquznR4fQX4aa2rS0x
         Ep3/g/eGTzNEMJYNdYASirhAYtXBgka0VDXrZ6iHsgSpWHrw5mTSuHIehZ9G0AvL8mLC
         l8xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gxZSZ0LuPRPFwUXxMFQMDqK16uOk/NPez/kgLYZBwMA=;
        b=bG4rvXhAWGdejUcpb7a3xmcTi5ahri/ewY1cSHpPwZC8WmV69HWgltC3BKOTKKE8lN
         2fw3/7pT5z5HPN9WrDn9vHWVz4PNRKj1hTIbcjYSSyHUAXtzw29sQs1K0WsAPAIpJ4wi
         CDYxMZTH0vru7pE9sHFsZTc1bFhlqEpPqLgknho+gdUe0zcoPdReBwRbiy2V/HUtUU7G
         kwXrHUak7zej2AfmPMVqhDOEh2xLrIEetcR6VvYrHV6E8Aj6W75FftKJhk5ndwsjYdfW
         LgSdAQJbAUTLi7M4/R8WCoaycFkK+FEH28gR4yjKYSGp4/J7FBSKvtgxiSsiAsUcTGq9
         +mKg==
X-Gm-Message-State: AOAM533oB/wmhp1SihyrmrlvBqsy5+Dmz+tKpFk5KZt15nTQFA8p27Lp
        6xDDWKKoRwiyOLs37K36DjJzDafpv4k=
X-Google-Smtp-Source: ABdhPJz8zBKVefUkc5CMh5zy7uJ4u6yd5ZSTA7ZE9AextPR2wTNcgPu3odGX83yWwudPcS7IQ/YI/Q==
X-Received: by 2002:a05:6512:10d1:: with SMTP id k17mr3271215lfg.649.1615500291456;
        Thu, 11 Mar 2021 14:04:51 -0800 (PST)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id a18sm1388030ljj.106.2021.03.11.14.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 14:04:50 -0800 (PST)
Subject: Re: [PATCH] net: dsa: bcm_sf2: setup BCM4908 internal crossbar
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210310115951.14565-1-zajec5@gmail.com>
 <dafc2ec7-871b-3ddc-d094-400055e81e4c@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <6727ac96-b004-f1f3-10c0-32f96dfe9f0c@gmail.com>
Date:   Thu, 11 Mar 2021 23:04:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <dafc2ec7-871b-3ddc-d094-400055e81e4c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.03.2021 18:19, Florian Fainelli wrote:
> On 3/10/21 3:59 AM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> On some SoCs (e.g. BCM4908, BCM631[345]8) SF2 has an integrated
>> crossbar. It allows connecting its selected external ports to internal
>> ports. It's used by vendors to handle custom Ethernet setups.
>>
>> BCM4908 has following 3x2 crossbar. On Asus GT-AC5300 rgmii is used for
>> connecting external BCM53134S switch. GPHY4 is usually used for WAN
>> port. More fancy devices use SerDes for 2.5 Gbps Ethernet.
>>
>>                ┌──────────┐
>> SerDes ─── 0 ─┤          │
>>                │   3x2    ├─ 0 ─── switch port 7
>>   GPHY4 ─── 1 ─┤          │
>>                │ crossbar ├─ 1 ─── runner (accelerator)
>>   rgmii ─── 2 ─┤          │
>>                └──────────┘
>>
>> Use setup data based on DT info to configure BCM4908's switch port 7.
>> Right now only GPHY and rgmii variants are supported. Handling SerDes
>> can be implemented later.
>>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>>   drivers/net/dsa/bcm_sf2.c      | 41 ++++++++++++++++++++++++++++++++++
>>   drivers/net/dsa/bcm_sf2.h      |  1 +
>>   drivers/net/dsa/bcm_sf2_regs.h |  7 ++++++
>>   3 files changed, 49 insertions(+)
>>
>> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
>> index 8f50e91d4004..b4b36408f069 100644
>> --- a/drivers/net/dsa/bcm_sf2.c
>> +++ b/drivers/net/dsa/bcm_sf2.c
>> @@ -432,6 +432,40 @@ static int bcm_sf2_sw_rst(struct bcm_sf2_priv *priv)
>>   	return 0;
>>   }
>>   
>> +static void bcm_sf2_crossbar_setup(struct bcm_sf2_priv *priv)
>> +{
>> +	struct device *dev = priv->dev->ds->dev;
>> +	int shift;
>> +	u32 mask;
>> +	u32 reg;
>> +	int i;
>> +
>> +	reg = 0;
> 
> I believe you need to do a read/modify/write here otherwise you are
> clobbering the other settings for the p_wan_link_status and
> p_wan_link_sel bits.

Thanks, I didn't know about those bits.


>> +	switch (priv->type) {
>> +	case BCM4908_DEVICE_ID:
>> +		shift = CROSSBAR_BCM4908_INT_P7 * priv->num_crossbar_int_ports;
>> +		if (priv->int_phy_mask & BIT(7))
>> +			reg |= CROSSBAR_BCM4908_EXT_GPHY4 << shift;
>> +		else if (0) /* FIXME */
>> +			reg |= CROSSBAR_BCM4908_EXT_SERDES << shift;
>> +		else
> 
> Maybe what you can do is change bcm_sf2_identify_ports() such that when
> the 'phy-interface' property is retrieved from Device Tree, we also
> store the 'mode' variable into the per-port structure
> (bcm_sf2_port_status) and when you call bcm_sf2_crossbar_setup() for
> each port that has been setup, and you update the logic to look like this:
> 
> if (priv->int_phy_mask & BIT(7))
> 	reg |= CROSSBAR_BCM4908_EXT_GPHY4 << shift;
> else if (phy_interface_mode_is_rgmii(mode))
> 	reg |= CROSSBAR_BCM4908_EXT_RGMII
> 
> and we add support for SerDes when we get to that point. This would also
> allow you to detect if an invalid configuration is specified via Device
> Tree.

Sounds great, but I experienced a problem while trying to implement that.

On Asus GT-AC5300 I have:

/* External BCM53134S switch */
port@7 {
	label = "sw";
	reg = <7>;

	fixed-link {
		speed = <1000>;
		full-duplex;
	};
};

after adding
phy-mode = "rgmii";
to it, my PHYs stop working because of SF2.

bcm_sf2_sw_mac_link_up() calls:
bcm_sf2_sw_mac_link_set(ds, 7, PHY_INTERFACE_MODE_RGMII, true);
which results in setting RGMII_MODE_EN bit in the REG_RGMII_CNTRL_P(7).

For some reason setting above bit results in stopping internal PHYs.
unimac_mdio_read() starts getting MDIO_READ_FAIL.

Do you have any idea why it happens?
