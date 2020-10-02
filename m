Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865FA2810EA
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 13:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387652AbgJBLFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 07:05:48 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:32234
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725920AbgJBLFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 07:05:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNk2Snx+xIn6u0J0WNFDox8s1P3tucfIFsotgMwNnbI=;
 b=LMA90sN4jpP2z0jApl0MxVEmNpO9Lqd2wlrFIVQZSLGvedFpqp9g67nbFdwLEOtI7p0hi1Ua1Yk27HnxD/pJLFspKN2ZHn2S6qVL121FSbxfB7gtDhZGAecnj4Mygy7eAO6ukVSp509WOliOkm2VuUFzrLVp+cOXVArnIC6p9bk=
Received: from AM6PR10CA0099.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::40)
 by HE1PR0802MB2233.eurprd08.prod.outlook.com (2603:10a6:3:c1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Fri, 2 Oct
 2020 11:05:30 +0000
Received: from AM5EUR03FT007.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8c:cafe::70) by AM6PR10CA0099.outlook.office365.com
 (2603:10a6:209:8c::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend
 Transport; Fri, 2 Oct 2020 11:05:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT007.mail.protection.outlook.com (10.152.16.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.34 via Frontend Transport; Fri, 2 Oct 2020 11:05:29 +0000
Received: ("Tessian outbound bac899b43a54:v64"); Fri, 02 Oct 2020 11:05:29 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 88c0a716cc965fd0
X-CR-MTA-TID: 64aa7808
Received: from 31d25fdc087a.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id E8AC061C-DF22-4D15-9D14-887CBA852B14.1;
        Fri, 02 Oct 2020 11:05:24 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 31d25fdc087a.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 02 Oct 2020 11:05:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DvF6rCtULYdJWPWYKWzuwSHqdh1Y61J+idu3fBBCkI2vzCfRxl5byemF6yEhVAZ6iNlVOLosUUmq89BaV9kaLIw0j8mp0adNcVZLP615NxxUSsTcDtpznVXZubr3v6r0gHU95Srj2+qv7MWEg6ykHT5VRQiUTZN22pNxBQoiRJiHCr1ZgfU3ypWkN19BZqcJxam9A4cxL1I6pBx5lF+fNjle0Ctn1gMSesjIVLcNkCBirUnP+b5zubt/Ub3XR+O+bIa6DXJKqRWoLn4SNu/MTVedMrR/Q94DhvwwOqePiLOvx2pvsCxmXyvm+jj26VmupiemnOkU3erY0tQr28Bmyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNk2Snx+xIn6u0J0WNFDox8s1P3tucfIFsotgMwNnbI=;
 b=OGvvPtmZJJe3x6WsLjy6CYSdquah2Jnsre+WTvbzHNw2oQJW4IueVVkRv44Cw42XZHPFxeT72BgnUU2dhlzuxKEfHrCT6/nXbMTAH0LpWS/tBYz+hrdRSWppdJJG6db0oNc2zh5IUGnYHNaB/ycuhkaV0T5swBTa20uXmd+R6KGQu0e64cktfgTPBgL6XAkuNSmHca9GBCPWYQNIwpvWnbPNWOaCeX3Z/nvbdG2dBXSeOsEYkKxXruiSu4Cgt0PIpW/0YuCAv1Ek2/eeXJZLnutGrC7shb77P4wqgSifXU1N7Kf+4tyh6dLnSC+vBXfcFOgJ87uLMl16PeChYW4Ocw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNk2Snx+xIn6u0J0WNFDox8s1P3tucfIFsotgMwNnbI=;
 b=LMA90sN4jpP2z0jApl0MxVEmNpO9Lqd2wlrFIVQZSLGvedFpqp9g67nbFdwLEOtI7p0hi1Ua1Yk27HnxD/pJLFspKN2ZHn2S6qVL121FSbxfB7gtDhZGAecnj4Mygy7eAO6ukVSp509WOliOkm2VuUFzrLVp+cOXVArnIC6p9bk=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from DB8PR08MB4010.eurprd08.prod.outlook.com (2603:10a6:10:ab::15)
 by DBAPR08MB5831.eurprd08.prod.outlook.com (2603:10a6:10:1a8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Fri, 2 Oct
 2020 11:05:19 +0000
Received: from DB8PR08MB4010.eurprd08.prod.outlook.com
 ([fe80::2d77:cba8:3fc8:3d4f]) by DB8PR08MB4010.eurprd08.prod.outlook.com
 ([fe80::2d77:cba8:3fc8:3d4f%3]) with mapi id 15.20.3412.029; Fri, 2 Oct 2020
 11:05:19 +0000
Subject: Re: [net-next PATCH v1 3/7] net: phy: Introduce fwnode_get_phy_id()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, nd <nd@arm.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-4-calvin.johnson@oss.nxp.com>
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <11e6b553-675f-8f3d-f9d5-316dae381457@arm.com>
Date:   Fri, 2 Oct 2020 12:05:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200930160430.7908-4-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0399.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::27) To DB8PR08MB4010.eurprd08.prod.outlook.com
 (2603:10a6:10:ab::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.178] (188.30.19.167) by LO2P265CA0399.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:f::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Fri, 2 Oct 2020 11:05:16 +0000
X-Originating-IP: [188.30.19.167]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: db6b483a-848a-4808-88e8-08d866c31311
X-MS-TrafficTypeDiagnostic: DBAPR08MB5831:|HE1PR0802MB2233:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0802MB22333A167025998EAFC9770995310@HE1PR0802MB2233.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Tr36l5jprVJkh4AUADxqVsG6hIojkxwAxxs1f8hoehL8/osAt3ZLPU59pgt4uhdLBKFtBIlzUO27FIAK8mCsKMhZkxDY2fUwYy+zForJd8xaffZIAHASahgWZf+0HKCrLOfJRiLRziEPcnv1BZxwFF9X4V8g5BwgfWoJ2CN6Ym6n/zW2E9ZfoDtpKf09I1wv+hdaBvoARKB0Z81sAPsmnrUj5ZdntnNTD3cEIeXCMHvEeXhJhxkYGtdbDW6MRwld2u2Fh2OOLTdOW77GJQUMQfFz5AHKUthqdkgQ4VvFyYmS/3v0Tetqok4IG/wrkaFY5gliwQo+Ac40Ms5nVAGYEmXjS60ZcJjXpedIfDARBxxnEOrWjCVMlcBoc5nbPPeh3iTe9wgh/JWc13b2dM6HcQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB4010.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(478600001)(36756003)(2616005)(6486002)(956004)(26005)(66556008)(66476007)(110136005)(83380400001)(31696002)(66946007)(86362001)(186003)(16526019)(54906003)(55236004)(2906002)(5660300002)(53546011)(31686004)(316002)(4326008)(16576012)(8936002)(52116002)(8676002)(7416002)(44832011)(921003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yuD4QfqttM6fqNtwYFgvug+1j6x64xGZn5GZikyzoi6g1X7ilQKwG5mAlqYV4GgmrvefhE4pAL8XTXcFKJNyswOA/T7L2nXch7t6qFzVU9eeAh8WV+MNO3hjpG/4Zzkw1kHF14hWNG14lN9MiZIBANST2HdEA1uKUTOdgld3eeG7AfmXx+1Sj519ui/wIT+609AVsrj8DDXzFxwbrolNA0ThAP72oy+XZDl6sE0u/OWCr9+mtbDADwKLp6PE9QlcKKVtONBtqzFdUHvem20pr/2lQFxt2jvS18mCDBBDZbx5roQqRfe7tX9hSwB8QUkEvb8TX5qKzNzyzb0myUMjTBEFr5FAwDwF5beDdWUiDcU+RHIl5b6B+R/7z+hxw8GOHgmekT4mQJSqWujzqhduC+s0nNOALWAyIjVY3SAoYjBwx5l7lKxJd0XekpX8wrJihFab3yhZSPj1CZesVuyEwdDhHu0STXHWMfOuCKdXyFIScvcQ/4Foh7hCbI7IQYoi9IP/Lys2yjpHE7NDzkvIot9PxQbLzLEVcoCdar5C1S0XaFji4PV8nwK5tkZgDoDJO8kS9Em45e7f5lPr0u52FygMBuq7g7xoXX01SJ5RBx8XYvTf5Hcw4z+jckNGuQfvtOMucTwuZuR3/FvMieSfzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5831
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT007.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: c853c894-889f-43ae-7b6b-08d866c30c9f
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RROT0Ymq+u/vCae17ntqDGqK2JcB6kHCF81zEen1owTQplJjcRlPB694C0cncj3r2R33P6isNw+vOUQLM8wEiIl8ZjxmB9qSlcSwHL7VKTtMEVNIvhBL3xPn9gesTSSN/Ox68rstmLxuJH6q/U00abmsY0aKTvzK9TLtp/vOlNkjMJQWT4k9w2K9l9C9L+P7vowEGR3/tqe5S5R0H+o4wL+vM8GpdiCXP3unfKTl/cZa0WYqlv93BaL4CQZbzoHPFvlqDyBhX3Xcp75RPfV8SloR7i7CotZAD8/1nJW1ZaI9i5GgDydjwgjHWm/4ssuhRiuI+J/DWfUkHerSSxO2cuokAys+tpvTWDU8HbUWLYAvekc/V+O31Hg3+09A+7F27opauWDp/CxYyyELDNZHJP7P+EtrXkMUP81S+G8ZxK9DoQZkqmu9zR2pO7vxPqKy
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(46966005)(31696002)(8936002)(81166007)(82310400003)(47076004)(6486002)(356005)(82740400003)(2616005)(2906002)(956004)(44832011)(478600001)(8676002)(186003)(16576012)(55236004)(70586007)(31686004)(86362001)(336012)(450100002)(36756003)(5660300002)(70206006)(36906005)(110136005)(316002)(83380400001)(26005)(53546011)(4326008)(16526019)(54906003)(921003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 11:05:29.6517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db6b483a-848a-4808-88e8-08d866c31311
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT007.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2233
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30/09/2020 17:04, Calvin Johnson wrote:
> Extract phy_id from compatible string. This will be used by
> fwnode_mdiobus_register_phy() to create phy device using the
> phy_id.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
> 
>   drivers/net/phy/phy_device.c | 32 +++++++++++++++++++++++++++++++-
>   include/linux/phy.h          |  5 +++++
>   2 files changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index c4aec56d0a95..162abde6223d 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -9,6 +9,7 @@
>   
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>   
> +#include <linux/acpi.h>
>   #include <linux/bitmap.h>
>   #include <linux/delay.h>
>   #include <linux/errno.h>
> @@ -845,6 +846,27 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
>   	return 0;
>   }
>   
> +/* Extract the phy ID from the compatible string of the form
> + * ethernet-phy-idAAAA.BBBB.
> + */
> +int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
> +{
> +	unsigned int upper, lower;
> +	const char *cp;
> +	int ret;
> +
> +	ret = fwnode_property_read_string(fwnode, "compatible", &cp);
> +	if (ret)
> +		return ret;
> +
> +	if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
> +		*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
> +		return 0;
> +	}
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL(fwnode_get_phy_id);

This block, and the changes in patch 4 duplicate functions from 
drivers/of/of_mdio.c, but it doesn't refactor anything in 
drivers/of/of_mdio.c to use the new path. Is your intent to bring all of 
the parsing in these functions of "compatible" into the ACPI code path?

If so, then the existing code path needs to be refactored to work with 
fwnode_handle instead of device_node.

If not, then the DT path in these functions should call out to of_mdio, 
while the ACPI path only does what is necessary.

> +
>   /**
>    * get_phy_device - reads the specified PHY device and returns its @phy_device
>    *		    struct
> @@ -2866,7 +2888,15 @@ EXPORT_SYMBOL_GPL(device_phy_find_device);
>    */
>   struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
>   {
> -	return fwnode_find_reference(fwnode, "phy-handle", 0);
> +	struct fwnode_handle *phy_node;
> +
> +	phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
> +	if (is_acpi_node(fwnode) || !IS_ERR(phy_node))
> +		return phy_node;
> +	phy_node = fwnode_find_reference(fwnode, "phy", 0);
> +	if (IS_ERR(phy_node))
> +		phy_node = fwnode_find_reference(fwnode, "phy-device", 0);
> +	return phy_node;
>   }
>   EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
>   
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 7b1bf3d46fd3..b6814e04092f 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -1378,6 +1378,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
>   				     bool is_c45,
>   				     struct phy_c45_device_ids *c45_ids);
>   #if IS_ENABLED(CONFIG_PHYLIB)
> +int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id);
>   struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
>   struct phy_device *device_phy_find_device(struct device *dev);
>   struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode);
> @@ -1385,6 +1386,10 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
>   int phy_device_register(struct phy_device *phy);
>   void phy_device_free(struct phy_device *phydev);
>   #else
> +static inline int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
> +{
> +	return 0;
> +}
>   static inline
>   struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
>   {
> 
