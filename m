Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBC03A3034
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhFJQKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:10:17 -0400
Received: from mail-mw2nam08on2075.outbound.protection.outlook.com ([40.107.101.75]:32629
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229979AbhFJQKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 12:10:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6JgmHqPYIBtIf1iA6ZxGPqg2ZAb+PU54Uj+LtkvOtoN1z/7RCgimXZNng4ppKvOBIfjzd+WX108faGmbdU4WLD4HUnbpWDt8/fvujGf8MXCuOM/b0sn/Fs26wh1oAQmLmoV209gV1yEVIWpIY5DVVVRjHMVcSwZmlNN9lW3Nt6/PER4Rfz/4zxtgql0GPb+/JFlMrTSfROz3wD8OfrcGrFVSNWCXf+f8Uae5NZ7GwHjXz+KSPgFLth3yjrokgIGOv6oWFWXfUsGopk+Vq9X3OAczgMtCagya3l2A7iRLs0MqHaQY0FBEY/YMR7HotbgC7rIUoSeWWPdtBo0nfRyJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29GhoepTH2rjN7X+1AJEqNOtfR5d5L2secJ4ip3H53Q=;
 b=ld171HQfiIKR6WMmfTOJAhEPekRGe2O8/PDameYvpyuDOD9YrVTZ8INkl5STaI1suMr7zqJ5rjUyKELj1O110B8WNuKsIvQQJfnZyEyx8l+7QttoeUk1XV75BY2jlIYdBgSAM05mSsQyRGUNAl7zGrNHw1XquiFiSb7oBlOjJ0gC2++DgObY5rhbcEUZ7xOXDXzkAtWqcTixGExkztq++uoiqen0JGEge/ikNWf/gTajhxiygN9Xn0+2zS6AhGXGPB6m4wc604i8LiQOKqOYtfITaLOx650NWJ6Spvw2ojjqOV/qykz+kCtkvZI0CjblyHPBrguRtkQtqjmCRSTUPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29GhoepTH2rjN7X+1AJEqNOtfR5d5L2secJ4ip3H53Q=;
 b=uF3QOJyYkoE5FaHXSjRKVG3cQq0ZjRQbGSHhZktuXK40cbPPvxuR8aVEQ6dQxysa7DgSnbG3DW0XgIzJGDHXqA7xAZSS6sskT/4UhE3Ijr3aoDcfFLoKRIFcrnxmideZPsQL9Lsi3N6BkbWU4pQKErVqki47d3lS/R+A02SfkmC78flzmTKTBcmkxeyt2dZy4T+iG7K/WJDFhhk9UtEuZpOp7Tz7iCPmaMOmCcnPkA9nzqzAaKMJIOTrEG8eAt/AdKGaRFI3mlOXBdGL3ye1K7xYJj5LX6pv5rrudpqCNTpIsNkZ9ZWtqllWpPzBiQW1oone2fjSSI2Nf//yi9+5xw==
Received: from MWHPR17CA0067.namprd17.prod.outlook.com (2603:10b6:300:93::29)
 by MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 16:08:18 +0000
Received: from CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:93:cafe::5) by MWHPR17CA0067.outlook.office365.com
 (2603:10b6:300:93::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Thu, 10 Jun 2021 16:08:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT011.mail.protection.outlook.com (10.13.175.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 16:08:18 +0000
Received: from [10.26.49.10] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Jun
 2021 16:08:15 +0000
Subject: Re: [PATCH v1 1/1] net: usb: asix: ax88772: manage PHY PM from MAC
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     Marek Szyprowski <m.szyprowski@samsung.com>,
        <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20210610142009.16162-1-o.rempel@pengutronix.de>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <852dd4cf-206a-ff36-e219-3454c419a126@nvidia.com>
Date:   Thu, 10 Jun 2021 17:08:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210610142009.16162-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d352902-8d82-4bb7-a1f5-08d92c29f61a
X-MS-TrafficTypeDiagnostic: MWHPR12MB1502:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1502F972810B0C55832EE7C9D9359@MWHPR12MB1502.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HkHOG6xM/11kpfPVglojlATbQOpDUwPiXLN+Af3nokWYDPThduzmqbddqK7RtGLYOt6sqIyKd6asoBh1X+K4oS4zsqrPU9VElDpncSyAPdKdAD2VatFGb1cuyRYjFfmR4YfB54xx90oouniHVwGy5LuBwZSFoa/LLcZykDggdjzZ2YVz/YZ5pZpyikCIS/PeYQ0xubOMeheQUbkG+DFKjPQFaxAgxHaHjxPWuRzFO0hfuRJmG9OgzQ43fhH/4J0JJjZAJSwi3Zen0zjjIsbEq3ms024BOX2gVEyelL6TizM5issWfme0rteJ86kxpoA3gea7kp3H4enl/8rtNCygGz5w6jvj9KDnTzJOSpm5J/iz0evgsJ7+b30eEP7nL1QwR+Qw7tB2qN7dYYXPpdPleoKbcB7hcfAWIkWQMMTzhltAA7aW+16ivOSRLY3fu9aP4Lo5loD2RG73fEYeNG9H2r6N/c1hb/l1sSzLJw1p3Rh3qc0bDDrl+y5WpsN8BhN6VUBvovad29BVJCnKB9dQ8NqAb7szewSUdNsfmW5DD18O8G3FOCDmBDnZJP6eK0R0x6fDnwBD5q5mj0p4O6PwyLXdJ+qJWyQslZQ+xtDu/+/85LjlgPrWSU5wDAJThqj+SR2EsIAlgSaK+TOHGTeJntpjUW23GVGVChsO/dsUQMjACdltYsVh3fj/XlO2jm3C
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(46966006)(36840700001)(36860700001)(53546011)(36906005)(8676002)(16576012)(110136005)(316002)(86362001)(31686004)(426003)(54906003)(4326008)(186003)(26005)(8936002)(2616005)(16526019)(5660300002)(336012)(4744005)(478600001)(47076005)(7636003)(70586007)(36756003)(70206006)(7416002)(83380400001)(2906002)(356005)(31696002)(82310400003)(82740400003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 16:08:18.2008
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d352902-8d82-4bb7-a1f5-08d92c29f61a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/06/2021 15:20, Oleksij Rempel wrote:
> Take over PHY power management, otherwise PHY framework will try to
> access ASIX MDIO bus before MAC resume was completed.
> 
> Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reported-by: Jon Hunter <jonathanh@nvidia.com>
> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/usb/asix_devices.c | 43 ++++++++++------------------------
>  1 file changed, 12 insertions(+), 31 deletions(-)


Thanks! Works for me ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Cheers
Jon

-- 
nvpublic
