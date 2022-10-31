Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08F0613AF1
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 17:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiJaQDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 12:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiJaQDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 12:03:12 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2080.outbound.protection.outlook.com [40.107.101.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9962B12746;
        Mon, 31 Oct 2022 09:03:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9pLZZ2cF7VqNarPFrQ8kdSZoA2Kp3gdddKlKEm0hC+QodMTFxsto6YA17V6WeMSTjAsMwzYUEst/YznhrlzvWeJnyJpunyas04Q56TtVxanZ9K5WLtsqQNPyGRUDqDqr7s8EsePF/HgqnwBi45pfn2Dxd9YkzfIoZAVJBO803YZekzwz6cIAIAho/drUeQ9JebuGInLzrFRXpCWwEiW31sklJ/QQHBucmdK3C6lrydBST9abajsF6IEmE56Y8jFibxQTa4NZV8uXzhPiVDOoiC/G3VXglCPrb6jPcCwJZ9ZftUKrR1yNYHvNaZGKtJiSkHWBbzfuoXU95BOD70m4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BSZIAW9gzm5sxm5+csIEynKArO8blh/0ODm97VtPedk=;
 b=CHVhAYniQylGNwJuT9FrnQ5nH+Xn/i5uTaN2MZbYzxmrnZQr7Vl2YtKo0uOQfPVuVTQBIejO5rnHBw+lgwUB57FqNy0L30gDed0RG8F4RbOxtLCmmL1To8erxsCVmhs1V2GNJVrR7wfrN2M1CVGREewCrZRvM47NLRuzALDKFlEos5lMq+XJeDWCstGG1gP3EYhpKH8H2EFxoJZ5AjmIiWlsn9jk6FbBp4VSetSa2rTptAylntnazhPgGoaNSx6cBnu8seKHsIMzfQDZPBg1MPMr3dkpqf0b9iVTcObxA9VtXwpQQ+oPmIGCLYbRtbAZU0s6dJMqxSgPjDyJN5tCdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSZIAW9gzm5sxm5+csIEynKArO8blh/0ODm97VtPedk=;
 b=oZ5i2tJK6e2Yk/J36SsvTApc8lyLCP8lO4jMp9KWVcy2Q2AdzyGm20VZTEImuNSWUIi2kB8atnX18V06ylw3Ou7DsuBvPgnGqZM82Tj9+Ta4pa7XXeF1pVnVcGjSb2vfXg2EBF7I5LPgFtXB8ynriFk6BcJWf3S6/RQHyc0iJeyPU5nEO6roi3+pnFkPw0nArDkqnDvHFnPJ1GUI/wfa2moku8Z1Jos8aLZBjVZONbP2r4PPb7Q772t0b1jHe1xovwC246eTa1gl4rrwLCBT0hsPIYJlhXnKFFhE2J0lPqn/4Bf1evN0Xh84WAj2HCT8Cq+lyz748kzLhEnv5i7WzA==
Received: from BN9PR03CA0449.namprd03.prod.outlook.com (2603:10b6:408:113::34)
 by MN2PR12MB4175.namprd12.prod.outlook.com (2603:10b6:208:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 16:03:09 +0000
Received: from BN8NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::6) by BN9PR03CA0449.outlook.office365.com
 (2603:10b6:408:113::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16 via Frontend
 Transport; Mon, 31 Oct 2022 16:03:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT114.mail.protection.outlook.com (10.13.177.46) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.14 via Frontend Transport; Mon, 31 Oct 2022 16:03:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 31 Oct
 2022 09:02:55 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 31 Oct
 2022 09:02:51 -0700
References: <20221028131403.1055694-1-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <petrm@nvidia.com>, <maxime.chevallier@bootlin.com>,
        <thomas.petazzoni@bootlin.com>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v5 0/6] Add new PCP and APPTRUST attributes to
 dcbnl
Date:   Mon, 31 Oct 2022 17:02:27 +0100
In-Reply-To: <20221028131403.1055694-1-daniel.machon@microchip.com>
Message-ID: <87y1swugk6.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT114:EE_|MN2PR12MB4175:EE_
X-MS-Office365-Filtering-Correlation-Id: d8ba1764-8b52-4793-87ca-08dabb5967a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZbYfeF/QcaxXXe8/lEtaus7Q9BemE2h8JpzxYvdWVjMTTJOQrTqXzooaGYd6tNsvXCK2WxrlUjT8uU3xD+OPbIz0UZIj7Xx1kEToxocGwoytNoWxrFud542hGgRX8ZBQ1jguh0IKSVXDjwtRO0opnMM6ZM5huXaw3w6dT8FQ2i7U2wvOl9HmZCmV0lWNWpdFRUkPzZotJwkHfPYury1emQ+vcd4f/v4vUSaJKAQPiy3roAqB1NT92rLOjtS8y8rlOzmQAj6Z0q7SQows5w9OofWH0fCMlQoYjTd3kgQhAzAOxjgmjWWo+t+RE9EmYOr6HJhI8F0YirkDMboByxJHtEnGABtX6PzCjWCW7hahw0c7Gc5dImNckox9CgD+BeoENTRVK5J97gH2d/jgc3tjLsH3geeuqOYWQSJGJU8Yl5K+odPv8EgnGaXWQsJpesDFLCaYzFL2tjlb9qfu9uVrY1hWdeHnibdhDRhWRLp9HFyi0x1Ftwa2olBDn8pzb9Mj7f3+AsfNBl+padSqOZEKzLtffXk2TL7SugeaW4s+IgFOQnkx/UlQ5noUydGbR4Oe7rtN9KixABcqsofoxWP3oCGXojgTNM5nm07o/RAeQK0PDDDlUdaIyhrsyul1Ufq1abvVK7zelJ73S92P4DCgT2ecA+tfHkC4d7YJzv20ZcMnZqq7bGsZZmUnKMKWf7AA7De1vQOXFj2BacimvCsIziAtTK38QWY6t8l3qFjEeORAelZ6LUtlkQJvXP1WwtTZXcD0lHupPYECkdWUwZtHejBsCWWcGU4NhaK2bFHniHY=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199015)(36840700001)(40470700004)(46966006)(82740400003)(478600001)(47076005)(2906002)(336012)(36860700001)(426003)(356005)(7636003)(4326008)(70206006)(70586007)(40480700001)(8676002)(2616005)(82310400005)(186003)(16526019)(41300700001)(86362001)(5660300002)(6916009)(316002)(36756003)(54906003)(558084003)(6666004)(40460700003)(8936002)(26005)(7416002)(17423001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 16:03:08.9372
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ba1764-8b52-4793-87ca-08dabb5967a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4175
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I believe my comments from v4 still apply to this version.
