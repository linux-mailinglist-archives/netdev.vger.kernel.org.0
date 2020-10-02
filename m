Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C57281122
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 13:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgJBLXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 07:23:33 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:1412
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725953AbgJBLXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 07:23:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89wpZmuvkHK8OkovzWix8xd7smlQRku//wVOJNxEMi4=;
 b=kLVU5/P2dcP1DcJ0+eRYonPtMDxLUjIrXn82ZbemmD1/KTUsB8LApwr1PliOVAfsK1W5t5noCH6igStmECjf++xKtd+A4amRIGwNSxsjM5n3Xgp3E186QKLGsnx4okHCigFJOHfe4hLDued4uHGXWW/Ehp35SoHoc33OFUxwGmo=
Received: from AM7PR04CA0024.eurprd04.prod.outlook.com (2603:10a6:20b:110::34)
 by AM8PR08MB5809.eurprd08.prod.outlook.com (2603:10a6:20b:1db::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Fri, 2 Oct
 2020 11:23:25 +0000
Received: from AM5EUR03FT027.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:110:cafe::29) by AM7PR04CA0024.outlook.office365.com
 (2603:10a6:20b:110::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37 via Frontend
 Transport; Fri, 2 Oct 2020 11:23:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT027.mail.protection.outlook.com (10.152.16.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.34 via Frontend Transport; Fri, 2 Oct 2020 11:23:25 +0000
Received: ("Tessian outbound 7fc8f57bdedc:v64"); Fri, 02 Oct 2020 11:23:25 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 5adefeaaaca55000
X-CR-MTA-TID: 64aa7808
Received: from 1828ee3d27cf.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 4FA779F3-729B-42BC-BDFC-3FB4902BA946.1;
        Fri, 02 Oct 2020 11:22:47 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 1828ee3d27cf.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 02 Oct 2020 11:22:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lp/hTBwj8GzXTetUbug+PEdecnVFMPP5ZxSZdfZT9ZygBZQPf/3tMczgC3SB8ZED6WVlrLjggZonq40hMYRxjHqg2tX8zjTs0LovySU926TTw9/uLW+Pa19taGVA548YIZxehBfm8f1vIoiHsouve9+rWV0sa9Do7jdjOa367WgYFUhHyBhVJ3bGD9zf7pLIHG1w1FChrycKAxP9klGxu+dWtNiowR7xn1MbBvS6YpYPv5bkRcvlIdw2+if8AEQOiIvhoXFJYv/mid/7u6wAXeY9Ye9j4X32WxDIDEZHjFEGBQRlVs149jbxHPpackpzwjK+l3rOfs6ktE9pJR7BgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89wpZmuvkHK8OkovzWix8xd7smlQRku//wVOJNxEMi4=;
 b=KB9PIctEDpo3C7H6A85pxAAC0cdhHHi+uRIUx3dqOuY2+UE5OXgegcrayOcyEL9WD9uFc4JpdAUw+foUpeeZmToWe3Bydv+oswAelNmVJISVq8Wz8fjiLQ5SiMLD3W2R1HHxa5xfKkjlxC9COUPBFTXxcgJ+1VVH3TH5EoZZ1lFhH/8f4xheWRgQE8VpCgQG9DyP33WZJ3IElv5Z35YPkXr7MGYpqTQ8B71VYNIz5ODqsbaGJFnSPqVgO6NWPQD1GtphDlGBlM1ieWG4ocOE4z/IDmzZ9bXQG95sFHt6LduvLLwwnfv/R9O9OUlW+fdEaVPvdu6woEkMuJXC1DVfjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89wpZmuvkHK8OkovzWix8xd7smlQRku//wVOJNxEMi4=;
 b=kLVU5/P2dcP1DcJ0+eRYonPtMDxLUjIrXn82ZbemmD1/KTUsB8LApwr1PliOVAfsK1W5t5noCH6igStmECjf++xKtd+A4amRIGwNSxsjM5n3Xgp3E186QKLGsnx4okHCigFJOHfe4hLDued4uHGXWW/Ehp35SoHoc33OFUxwGmo=
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
Received: from DB8PR08MB4010.eurprd08.prod.outlook.com (2603:10a6:10:ab::15)
 by DBAPR08MB5608.eurprd08.prod.outlook.com (2603:10a6:10:1a5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Fri, 2 Oct
 2020 11:22:45 +0000
Received: from DB8PR08MB4010.eurprd08.prod.outlook.com
 ([fe80::2d77:cba8:3fc8:3d4f]) by DB8PR08MB4010.eurprd08.prod.outlook.com
 ([fe80::2d77:cba8:3fc8:3d4f%3]) with mapi id 15.20.3412.029; Fri, 2 Oct 2020
 11:22:45 +0000
Subject: Re: [net-next PATCH v1 6/7] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
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
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-7-calvin.johnson@oss.nxp.com>
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <0e433de7-f569-0373-59a7-16f2999902d4@arm.com>
Date:   Fri, 2 Oct 2020 12:22:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200930160430.7908-7-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0087.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::27) To DB8PR08MB4010.eurprd08.prod.outlook.com
 (2603:10a6:10:ab::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.178] (188.30.19.167) by LO2P265CA0087.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:8::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35 via Frontend Transport; Fri, 2 Oct 2020 11:22:40 +0000
X-Originating-IP: [188.30.19.167]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 520b295c-b7e7-4b90-fbb9-08d866c5943e
X-MS-TrafficTypeDiagnostic: DBAPR08MB5608:|AM8PR08MB5809:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR08MB580923A731409C0C395E853795310@AM8PR08MB5809.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: H24+FFyCgY9qrM06cIEcnPnbEeAP30bhtFAILOuHWSqaRnOM3qS0kMBVdkujY7onvkcfPHzjGm7kyezLL4D66Oydp4nCkeMiTXjdRg6FQoezZH6SMVbFwsGl0QOJeAMV7dHeynpj2OWe345FZ4fsI7zJ4UNxTx6pBdf7bHRDR/ug9O9iIceypElL4mIsFATUmqSwkzW/Zt4ZzcJgyXLqO8R/0oah7ruC4GhfNtL7h5/fDAzIsKigwDiemnVFttN7pyiZmq3N0po6WAUyoQRowhk70EB+nub22c9GXkKoNlSO+YwfgF6tMYK2nuQlX4/HuFu7qaPguJwLyytgvwkAsFOy8M2nOn+dUsnjN4mBvl+OKkAsjrXZnIdBlKSHkfsUQRxDBZsELMNrHwXFz4lfW6/n780cJqFqecfmvF42mUBqZdF8lF9pjW5ZGtuwHBBx
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB4010.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(956004)(31686004)(36756003)(2616005)(44832011)(52116002)(16526019)(6666004)(31696002)(6486002)(83380400001)(186003)(5660300002)(86362001)(53546011)(8936002)(8676002)(7416002)(110136005)(2906002)(26005)(4326008)(55236004)(16576012)(478600001)(54906003)(66556008)(66476007)(66946007)(316002)(921003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: W+4xNLoAUOXcVkslR8oe6fJi8k8rZ7jk5L8x+P51wFAQvvhUlltaBwpyRwJ9suGCHolPYFzsKLT5+WrhjTg4IzxNHiP81Zz90mS/FSldGifvw0kU9Rv18k5efd7QWk90S5Ucy0d2O8xoT29vHGpPNcnsgmmaLQycGipkzCKK0Io1AiTGebnFVDEdxiy3Y8smsy4X5+USzlrNf0zHvIXKuSdHGH0+Mz2o3h2jHAprg6B2+lx3g3jiqtloPfqD21bsqFd9j4BY7hHCr63UBRVZeCjqgfU5UnOzr0Cp9FURYmXzqdDqZsqA1FAsxfAhsu0cNP2AApMiGqBBHBAHppqsCUuG3pF0c3A1esQupB3KNqgcoL6MQ0aWtkdL+z/IFFkjzsokRtPX8ktvy9o2BS1vtVetUiXq8vWbm1yjHHdbh5NSfNrY+khyb2NNmjCtsQNuY3OeMqr1FPn32D61bc+3iQ1CBDkS4HFthkZ+LX4zBze/UCpoVDPswi3rU6Jjk+wCCG4Pt5Ht/qdlS6+vDVR3VNB3viJff9ll0vY5FuxHT9LJlvyPFWpoBLRxSRm6IVnu6yPEi1YuHBs6tEPTXlWB8V51XZ0iek+Z9gmRjjAJjKI6x+lWojsrmKEKRJNFJpjfVfnLfdFHMC8fc/1gDM1HuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5608
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT027.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 7ed53947-cc8f-43b9-b14b-08d866c57c04
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NDehxm3RaMBeVgbJM6fDt3ehLPS4TCS104CHDTcGKpEvGxdVPRBa0zLHkLWqlyEGwDPGvO+Yc4zaa08RG89ThDKLBN8kRWyFPWWjbVKT+JAoRx1i1mxJm6Q3Z7leXXdJn8gFSO44mE1WA0In6mTIwx5BxNAQ9kt6PHwgtkXkj9CtnXizzSFOPi8rD/P1iTQmWINYRY98Oc+a2WWfjhm1sswDzZKMinae2XZfdZBRU4G95OkAYlj8MpoCA/+daopfKqo6WcLUYnKPK+MHDrKZJGUjBpc/0Ck1igOxYCK0nbJFaKxvIcHM4uejeTxYD6iBuGeXXYI9MyCrKTzgKaIlGUzryK2D1iEvDBaecP1Y7wN4Zn/TPU3R/RZ0/BxfOGXzI/H+FZdLAhTmNIoQ1+5LAvXQBB1wvYGiZp2X+IVv/JgWe3SU8bOr+NCBJrgLQaOG
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39850400004)(46966005)(70206006)(8676002)(70586007)(356005)(36756003)(316002)(450100002)(31696002)(16576012)(4326008)(81166007)(478600001)(36906005)(82740400003)(82310400003)(47076004)(44832011)(5660300002)(6666004)(55236004)(2906002)(16526019)(336012)(83380400001)(53546011)(956004)(2616005)(8936002)(31686004)(54906003)(26005)(6486002)(186003)(110136005)(86362001)(921003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 11:23:25.3072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 520b295c-b7e7-4b90-fbb9-08d866c5943e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT027.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5809
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30/09/2020 17:04, Calvin Johnson wrote:
> Modify dpaa2_mac_connect() to support ACPI along with DT.
> Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
> DT or ACPI.
> 
> Replace of_get_phy_mode with fwnode_get_phy_mode to get
> phy-mode for a dpmac_node.
> 
> Use helper function phylink_fwnode_phy_connect() to find phy_dev and
> connect to mac->phylink.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
> 
>   .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 79 ++++++++++++-------
>   1 file changed, 50 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> index 90cd243070d7..18502ee83e46 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -3,6 +3,7 @@
>   
>   #include "dpaa2-eth.h"
>   #include "dpaa2-mac.h"
> +#include <linux/acpi.h>
>   
>   #define phylink_to_dpaa2_mac(config) \
>   	container_of((config), struct dpaa2_mac, phylink_config)
> @@ -35,38 +36,56 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
>   }
>   
>   /* Caller must call of_node_put on the returned value */
> -static struct device_node *dpaa2_mac_get_node(u16 dpmac_id)
> +static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
> +						u16 dpmac_id)
>   {
> -	struct device_node *dpmacs, *dpmac = NULL;
> -	u32 id;
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> +	struct fwnode_handle *dpmacs, *dpmac = NULL;
> +	unsigned long long adr;
> +	acpi_status status;
>   	int err;
> +	u32 id;
>   
> -	dpmacs = of_find_node_by_name(NULL, "dpmacs");
> -	if (!dpmacs)
> -		return NULL;
> +	if (is_of_node(dev->parent->fwnode)) {
> +		dpmacs = device_get_named_child_node(dev->parent, "dpmacs");
> +		if (!dpmacs)
> +			return NULL;
> +
> +		while ((dpmac = fwnode_get_next_child_node(dpmacs, dpmac))) {
> +			err = fwnode_property_read_u32(dpmac, "reg", &id);
> +			if (err)
> +				continue;
> +			if (id == dpmac_id)
> +				return dpmac;
> +		}
There is a change of behaviour here that isn't described in the patch 
description, so I'm having trouble following the intent. The original 
code searches the tree for a node named "dpmacs", but the new code 
constrains the search to just the parent device.

Also, because the new code path is only used in the DT case, I don't see 
why the behaviour change is required. If it is a bug fix, it should be 
broken out into a separate patch. If it is something else, can you 
describe what the reasoning is?

I also see that the change to the code has dropped the of_node_put() on 
the exit path.

>   
> -	while ((dpmac = of_get_next_child(dpmacs, dpmac)) != NULL) {
> -		err = of_property_read_u32(dpmac, "reg", &id);
> -		if (err)
> -			continue;
> -		if (id == dpmac_id)
> -			break;
> +	} else if (is_acpi_node(dev->parent->fwnode)) {
> +		device_for_each_child_node(dev->parent, dpmac) {
> +			status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(dpmac),
> +						       "_ADR", NULL, &adr);
> +			if (ACPI_FAILURE(status)) {
> +				pr_debug("_ADR returned %d on %s\n",
> +					 status, (char *)buffer.pointer);
> +				continue;
> +			} else {
> +				id = (u32)adr;
> +				if (id == dpmac_id)
> +					return dpmac;
> +			}
> +		}
>   	}
> -
> -	of_node_put(dpmacs);
> -
> -	return dpmac;
> +	return NULL;
>   }
>   
> -static int dpaa2_mac_get_if_mode(struct device_node *node,
> +static int dpaa2_mac_get_if_mode(struct fwnode_handle *dpmac_node,
>   				 struct dpmac_attr attr)
>   {
>   	phy_interface_t if_mode;
>   	int err;
>   
> -	err = of_get_phy_mode(node, &if_mode);
> -	if (!err)
> -		return if_mode;
> +	err = fwnode_get_phy_mode(dpmac_node);
> +	if (err > 0)
> +		return err;

Is this correct? The function prototype from patch 2 is:

struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)

It returns struct fwnode_handle *. Does this compile?

>   
>   	err = phy_mode(attr.eth_if, &if_mode);
>   	if (!err)
> @@ -303,7 +322,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>   {
>   	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
>   	struct net_device *net_dev = mac->net_dev;
> -	struct device_node *dpmac_node;
> +	struct fwnode_handle *dpmac_node = NULL;
>   	struct phylink *phylink;
>   	struct dpmac_attr attr;
>   	int err;
> @@ -323,7 +342,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>   
>   	mac->if_link_type = attr.link_type;
>   
> -	dpmac_node = dpaa2_mac_get_node(attr.id);
> +	dpmac_node = dpaa2_mac_get_node(&mac->mc_dev->dev, attr.id);
>   	if (!dpmac_node) {
>   		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
>   		err = -ENODEV;
> @@ -341,7 +360,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>   	 * error out if the interface mode requests them and there is no PHY
>   	 * to act upon them
>   	 */
> -	if (of_phy_is_fixed_link(dpmac_node) &&
> +	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
>   	    (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
>   	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
>   	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
> @@ -352,7 +371,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>   
>   	if (attr.link_type == DPMAC_LINK_TYPE_PHY &&
>   	    attr.eth_if != DPMAC_ETH_IF_RGMII) {
> -		err = dpaa2_pcs_create(mac, dpmac_node, attr.id);
> +		err = dpaa2_pcs_create(mac, to_of_node(dpmac_node), attr.id);
>   		if (err)
>   			goto err_put_node;
>   	}
> @@ -361,7 +380,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>   	mac->phylink_config.type = PHYLINK_NETDEV;
>   
>   	phylink = phylink_create(&mac->phylink_config,
> -				 of_fwnode_handle(dpmac_node), mac->if_mode,
> +				 dpmac_node, mac->if_mode,
>   				 &dpaa2_mac_phylink_ops);
>   	if (IS_ERR(phylink)) {
>   		err = PTR_ERR(phylink);
> @@ -372,13 +391,14 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>   	if (mac->pcs)
>   		phylink_set_pcs(mac->phylink, &mac->pcs->pcs);
>   
> -	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
> +	err = phylink_fwnode_phy_connect(mac->phylink, dpmac_node, 0);
>   	if (err) {
> -		netdev_err(net_dev, "phylink_of_phy_connect() = %d\n", err);
> +		netdev_err(net_dev, "phylink_fwnode_phy_connect() = %d\n", err);
>   		goto err_phylink_destroy;
>   	}
>   
> -	of_node_put(dpmac_node);
> +	if (is_of_node(dpmac_node))
> +		of_node_put(to_of_node(dpmac_node));
>   
>   	return 0;
>   
> @@ -387,7 +407,8 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>   err_pcs_destroy:
>   	dpaa2_pcs_destroy(mac);
>   err_put_node:
> -	of_node_put(dpmac_node);
> +	if (is_of_node(dpmac_node))
> +		of_node_put(to_of_node(dpmac_node));
>   err_close_dpmac:
>   	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
>   	return err;
> 
