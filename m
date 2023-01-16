Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1EB66BC7E
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjAPLKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjAPLKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:10:50 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2106.outbound.protection.outlook.com [40.107.101.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FD417CCE;
        Mon, 16 Jan 2023 03:10:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DtgQAPwwWXWxV8QsIqvWQkw2tDfA4OiU1gCWBwSz3O/Is0Fi9ZY3XUboLMaqIT2TgtvMbqecLffAvXQ9Kn9pzF0dazU8UnoRolOKhsNvhGEXMUj5DtTfNUDLTuAZNvtqdsXTorYcVe02aw46qNlBnN2SGbj5ewG/AEVBLNY3UuKTaKy7uy8V520gYQWZJBsSEJ6IaSNYFsvSecTqnoCy1QhwrSlGC8Zj2cHVxZoVQzVqyi25iujqgpjZHpNEaQGINJTGOnyksscG7As5GXuD0+ORmYGVCncFPLHcb0DOxIMmKtacXbFgwnz6KrP8xlk9r5szmJRvnpVUw9HLb3KyGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZiLlzmA2T/Dof2PLCzCR/zhqmmv5BwoNp1n0JGk9u0=;
 b=lihyZH4DtWClPbEaX326zzP60S5oGiR/GNLCba8+3+3wt7oa9rI59CVoTOlrphr2ClP2Jy9Hf8RGFMie4DRqBbR4aEiDsxUUk+CChU8opNk/iRZ5FrgJ8GhtRfIt/myvIkJBlgnc1Mym1ho++cs88DKnNmRnXAhvZTMLNxvn/YL5YCqkO/7eVuWBL/BpSTnXsbO9mS8expi5AAdHX2Z0uNel3sHzt3crrG8h/3GFjwNwg73oMo8pn8ZKbfQ7Af7CtELx7P2x2yQzhJo7+Ckw0HBpCkYhNhEVJl8JbojmTI9oaxDX1qftMEQOJG//u86H38bzrFeiuGprOvZ2Yi3eKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZiLlzmA2T/Dof2PLCzCR/zhqmmv5BwoNp1n0JGk9u0=;
 b=AaiLzk8YbCGqUAm3QPFyztTLIfW75/A41Lyt4qaciJVd2r1jRSRlZkL4JDo+eOKUd3UdxpbVv+9E2AXdlbpYqhsjSJMh6YSsHn7eVyuZFKkD4B8F5k1oTQqX0ZH63IAy0aGWsGHKs6bxYtWXff+xqBWS1xXI//1M9UM96wGFlA8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH8PR13MB6222.namprd13.prod.outlook.com (2603:10b6:510:23a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Mon, 16 Jan
 2023 11:10:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.5986.019; Mon, 16 Jan 2023
 11:10:46 +0000
Date:   Mon, 16 Jan 2023 12:10:39 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pierluigi Passaro <pierluigi.p@variscite.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eran.m@variscite.com,
        nate.d@variscite.com, francesco.f@variscite.com,
        pierluigi.passaro@gmail.com
Subject: Re: [PATCH v2] net: mdio: force deassert MDIO reset signal
Message-ID: <Y8UwrzenvgGw8dns@corigine.com>
References: <20230115213746.26601-1-pierluigi.p@variscite.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230115213746.26601-1-pierluigi.p@variscite.com>
X-ClientProxiedBy: AM3PR07CA0105.eurprd07.prod.outlook.com
 (2603:10a6:207:7::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH8PR13MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: a7a616ab-dbff-4845-526c-08daf7b250b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ps7OOCnysdnumfzuGIeOBgbsuK4N0eOMwNAZAqYDvq4Wy8nCLcGruIFzSav1jl1w66L4MIZMs91KVtr3giY9i061XS3uSjAU8Ac6+sFEGV1pYolUW4VHOWktoErKPqT/GHbrSy301uJHrr+wR3FTWH/E6q1Y16P4OgEN/u0ipXu5lZHq8OLShmafgwmfDRrSaM56tXnf6QPKCehnpFO+1i4mjKopX+/DNb6VTrtXpp4SSu/n5ziN+qb3xMMpu3qfamXuvnx2UC485ysnQGPMNbvBef1UDuqwiCWpC9ItgJ6dA/MgpEm1YLFegBLbJZo617bL0BL1vk7x19VRG14O8ddeZcNIZzI4/oX6TMolKEB5yq/cHK5qL7bDoLY80SxpSs1GW/RrXBQ4t5whINsTkaMCco8b0mzQA0z7ngq08CHevVEFBV2kg27p+FRL7qXzFSNYPbjEKlJJT03hlMZCBLVZJnQO/RqZnI3FK3IGKVdcppXpPkXLh3WEa4bJsUDAA6exoublN2nD1yEqjaz46hiMbKq/Hdh8ED6zwChNZsF4NRZaWtXF2kfhYgN7giYAaPkc80Jl3RKG9xwAQMya/liwpgPAuEaC2KQ7sP8QE3kSA0H5ANVN5vj/WcS/rJtz6deluHEitsRn9d9/M0+XNX3lXWvsUXkCuKY0GVEb+Z3hCJUKageSkY2XG3LQ2EAO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(136003)(39840400004)(451199015)(41300700001)(44832011)(2906002)(36756003)(478600001)(316002)(2616005)(38100700002)(86362001)(6512007)(4326008)(6916009)(6486002)(186003)(8676002)(66556008)(83380400001)(5660300002)(6506007)(66476007)(7416002)(66946007)(6666004)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uCGYoEmP9WudFlsxXUIbTpvKl+DH6LT4QEaR3jPhb6TwulCiSllKm1j0MzUe?=
 =?us-ascii?Q?Nn1elc7100gSNPL3BbZzrBBHqawT73bF//2JlHvZ/G5MZwOu7ed7sv5i0cD+?=
 =?us-ascii?Q?YB0hzOYOynYmnZEUhD4XfdXfAtGzYpyBHBhTpLhYKLoj/kU+hrOhTuZnsr28?=
 =?us-ascii?Q?zn4o7Cg2u2PasFsTQbFhjP1ImkiAexRVGwnx+ACfj6kR4s0zSwJWljiO2QvR?=
 =?us-ascii?Q?I1xxfHSjOU2qI+thcfrjB0cCe8l1gn45ihnqUtH8VsORYKRn+/1C2F1zTHC4?=
 =?us-ascii?Q?I1303CyjsJ5QOdYultOA8yc3S0ufgVt3X6yLompjM6HIkrVkWJIlR7y7ze5Q?=
 =?us-ascii?Q?6b9+Xl7m7SM4/rQ9FDb11wK5f7oIhz2FrNBYKwoMJl5lajWfabPo2iVZ8Zy9?=
 =?us-ascii?Q?UQxgqQj+V3ykdmbyMtekS7iUzVxcsz8eUSJZOaNfD2/r0gzdsqhduemzOBQU?=
 =?us-ascii?Q?gN+I0vGrrtye24PgEZtfS+9rY/ZImLMqF9whRFe0z51r+hYvqoaUAgNgvyCf?=
 =?us-ascii?Q?RPPQnxyHC9IavJVBux3VPaN+SRElAg79emT6ucstpfmH2gIuc0gKYdWI1l92?=
 =?us-ascii?Q?m2pgkZbvwvDywIdycdDxBBNxQabA1ZL45VFPwQ95wg05p7JtdbqeCNjJtpRI?=
 =?us-ascii?Q?41icQ3c3RkS2PsCXdlO/a0q6aGX9ZBqrJ4LPZ5dR4ryV7FG4YR5KUK0v2eyK?=
 =?us-ascii?Q?2B+Jrtw7GkAY+TH3MXawJSkBm0KzpsqBPoDG1ph6jH9mN+1c0xmOvwMdG+1H?=
 =?us-ascii?Q?JKlxcpXUVv9OqU/nJ+5qP8jR/LF+PKP54buXgD9JM67omGR/C2XAiwjCNeG2?=
 =?us-ascii?Q?cQ1BKZqtieFit3eH2RhH2Kbt3RKcT8xhQq7t/6Ox3f72a21cf6g7+ts9ywc+?=
 =?us-ascii?Q?uNSn0uG6yMMGIPoxvcRouJ3eyAOunC+X0P/UQTdqdn18NTr1EoiBR+hft8oO?=
 =?us-ascii?Q?pUQafxkT/pIymki+A6Jz4J5L/paRqDGVuowztvtiZWa9E1vEnx+eSSVUptRP?=
 =?us-ascii?Q?FB+4kMgYVJ3Ecte/VNIEuP4msmFhfEEomGBXc6cfJJGAIonfIiEVmqlPcQ1D?=
 =?us-ascii?Q?8tmzQsox31xGEyNqWEMFflIGYC63W/+pyzxWE1ZmSDkeiUvY7EBHlePIeSzU?=
 =?us-ascii?Q?VwP06vPFkUxv+fCZa39ZZNc93N9FBJtXJTr5309lNAvan5ODIG4hPdRKuz4z?=
 =?us-ascii?Q?rpxmLyEimhI8vuVaVGxPtsGMYFW1fNpF/wpkIgSm9XwcF8vepEU8rjoGGV0z?=
 =?us-ascii?Q?swakWGIhrFSVCHuXA3E42muim0HPLUMBK7riQNlmK3lGo3dOKNaMhvsNrjNM?=
 =?us-ascii?Q?+MNClyK90e6emE4uLc6Hk3CN9R+fNqTSOZ9GmZxc8c3QX0sso0uURrf4/QuE?=
 =?us-ascii?Q?BtmlD922nSTO8E+9JBGL9mY7SRYXowpl5G/oWDM5G1odKv7u7fJwuJNVjXsx?=
 =?us-ascii?Q?sKBYf+LugHhaqDziVVR1wIg2yVPzfzWeuFafpaS6LAJ7mI+OlxHDJfR81FVJ?=
 =?us-ascii?Q?ulqNA4ueB8x8lZgGnivWKM2Xq45J8OV0eVGgeuQpjD/6a0+Xmcjd0V7+rJz/?=
 =?us-ascii?Q?Pkt/dArgs2JniVoCJI733ttJbTa/HkCWYgmxDD+1ClzGLAX0cGnn7mPWrA54?=
 =?us-ascii?Q?zbC8jSLfwSEk3gn0F4/TIwumw3IRBSL/77MmKmG9den5nuG9lWoFPSQu4Nyu?=
 =?us-ascii?Q?h/k8oA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7a616ab-dbff-4845-526c-08daf7b250b4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 11:10:45.8767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4xr446N2+v5XEQ1jF1HCu6XlFyGJzFf0GqtyzLNGDw35frFuMQ67TUVO929ZEUx3Ik9/cIZ1pQvVnO5gV63c/ND5C61CYQ8PG4mqkYGrNKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR13MB6222
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 15, 2023 at 10:37:46PM +0100, Pierluigi Passaro wrote:
> When the reset gpio is defined within the node of the device tree
> describing the PHY, the reset is initialized and managed only after
> calling the fwnode_mdiobus_phy_device_register function.
> However, before calling it, the MDIO communication is checked by the
> get_phy_device function.
> When this happen and the reset GPIO was somehow previously set down,
> the get_phy_device function fails, preventing the PHY detection.
> These changes force the deassert of the MDIO reset signal before
> checking the MDIO channel.
> The PHY may require a minimum deassert time before being responsive:
> use a reasonable sleep time after forcing the deassert of the MDIO
> reset signal.
> Once done, free the gpio descriptor to allow managing it later.
> 
> Signed-off-by: Pierluigi Passaro <pierluigi.p@variscite.com>
> Signed-off-by: FrancescoFerraro <francesco.f@variscite.com>
> ---
>  drivers/net/mdio/fwnode_mdio.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> index b782c35c4ac1..1f4b8c4c1f60 100644
> --- a/drivers/net/mdio/fwnode_mdio.c
> +++ b/drivers/net/mdio/fwnode_mdio.c
> @@ -8,6 +8,8 @@
>  
>  #include <linux/acpi.h>
>  #include <linux/fwnode_mdio.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/gpio/driver.h>
>  #include <linux/of.h>
>  #include <linux/phy.h>
>  #include <linux/pse-pd/pse.h>
> @@ -118,6 +120,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
>  	bool is_c45 = false;
>  	u32 phy_id;
>  	int rc;
> +	int reset_deassert_delay = 0;

nit: it looks like scope of reset_deassert_delay could be reduced
     to the else clause where it is used.

> +	struct gpio_desc *reset_gpio;

nit: reverse xmas tree for local variable declarations

...

Also, if reposting, the target tree for this should be in the subject.
Assuming net-next, that would mean "[PATCH net-next v3]"
