Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC6B673450
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 10:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjASJYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 04:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjASJXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 04:23:50 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F064615A;
        Thu, 19 Jan 2023 01:23:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEi5keb+k1/B53ND7dWWDYH0TXZ4F7h6wU+Nz05X9K7mcAEeMPKXs5D24Nk02IN/hZS2NZA3BAnDI6CpYTZk3E2XXH//SHJrpTfuaVPypYEZqAPWP3YpCm3oESQh59TaAE/oOSrhaIPvVTQim8G9+kUz1yuwHcvKuqxHYe2ybRoO1aOrutwGxqB6yLOsJpYa0fiWRPR0RUR7wnXHIa5EcvGFDFjLA4XHeK6PELpPyl3aV2E0VJeDXVNpZsYjlwdV48Ks4g8hqjRRbkX2cp7h6Dsyrs1HDeqTARSuyIoY0tNh0DJbxZ/BocSoaeVQdYhUE1m+MqoiNWp2zl8IT0sMRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2QG6gAjYIpKPON4AYUavwFJPsAXRGWvr3EkFd5LMXdc=;
 b=fhkAuKrZfPA28zIBrLSxfIHPJtttA2Jm40xNhFGiFmdRD+AqT4IRg80slhAnrtA8joeQStvoxXku1pp6KEdoJDYYVn+Opun6FRvEJNAPnQrEiRJ0wB5KhtklrDrRPMRzvpUjPCKbN0cgixVf0v1ETMOL457s4xrGh5fXqkU5lwZVsFdYS0jA4s8XzNBaetOWbQYm2Ts5PNLq+3Krfvgm0G1zv0hWLpap2Fi46tK2WRUeid4SaOkUFaBOtGh/u1zV0jpfnuwvU5yObwGVgkiEDsX1SQz0F2fF64WLpDxyr3nzpcLQ6dumCoVT0yL/S6nNh43Lg2PGzw45KRirkmqaIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QG6gAjYIpKPON4AYUavwFJPsAXRGWvr3EkFd5LMXdc=;
 b=IBI9MOUYpvrM2Cai2IFJv3ibYzsQwVnrYin/2wCfvNh5Wd8Ro8NnrZZQiZDorDmHEOyQua2ybLKaU39efiUSQma3YyRnAV1kIg7LKvBcLMvzlO4QjwLoUgbIDueqAe4k2/q4BMd4p3L4Cytcmns/QVg8pEaOZ8vwFaDwq0bgoQqwAycvvTI+LsKEw6Pq0REbj7aE1IoUdLpkuPPWtxlcLhR24+BAG0oqHkIzC6qQfGOn/53T5YdwqlI1rK+5WvZ6n1kWEAsHsFCE2Z8SchVQjVhqRkVBufzoD+wEvMyeRoE+9jYtk9ptwYSCXh0JKkhAjGTvL2ZVgGz1NXe4Muv59A==
Received: from BN8PR16CA0034.namprd16.prod.outlook.com (2603:10b6:408:4c::47)
 by DS0PR12MB7780.namprd12.prod.outlook.com (2603:10b6:8:152::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 09:23:28 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::ad) by BN8PR16CA0034.outlook.office365.com
 (2603:10b6:408:4c::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 09:23:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.24 via Frontend Transport; Thu, 19 Jan 2023 09:23:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 01:23:17 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 01:23:11 -0800
References: <20230118210830.2287069-1-daniel.machon@microchip.com>
 <20230118210830.2287069-5-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <petrm@nvidia.com>,
        <vladimir.oltean@nxp.com>, <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 4/6] net: dcb: add helper functions to
 retrieve PCP and DSCP rewrite maps
Date:   Thu, 19 Jan 2023 10:23:04 +0100
In-Reply-To: <20230118210830.2287069-5-daniel.machon@microchip.com>
Message-ID: <871qnq98ub.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT017:EE_|DS0PR12MB7780:EE_
X-MS-Office365-Filtering-Correlation-Id: f7fb0162-860f-40b4-470a-08daf9fed2e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v/4jIa0ZJj8FU2Yqstgu9Mi9pS4/7+0rVUo/HzIZjuzPrK3zKBVCM2Yd+QSJMHJrGMiOEhPRunpeU/+lsGBHZwdYxbD4xRGUCQvbOiyKnVU2z1203jMi3Ni83mifS35L/B1oUwndIPr5152AuofvCy3S3SqkriBqHChOARIebb6CshGxX7AXACE2RQn5AmziKdzf+IiHpBmi8eBgEMGvwNtW1wWZiZUoBGjVRBTCLPFctPoQ+XJpmOi0+tff6BAxLjuBkhda6kdk1Bxq+KMSHLf8jW+xbboP8Pxn9jZ/dbDhQ9GinHNNBhTi1znaCgUVol2N1z4bLQY2ZOASm1mubomkWirE0mmDS94PYEw/zEHoS70+53DyG/+wcnAk5y0oR/e2NXU58vSlzGs9NWJ1esSI8ps7j3EsGChkBRZ9vyPfUL2i46saG/kV3nCE1UHcAktvNUWOrBQr6sQabkh/0WE58iQKA84OgRorwHJR9W/jm+LxAgrTUzurkjBqCr6pn/31Pb+llCnESWovtF3JYYZ+Jp21lf+VjvoC1OmzaiWwEZ9YBU2jYEJhRI/my1h57UWkzB6iNSW/+FR6y6DcJ9t483oo0aWuDP03kab/ltfkRXC8A4VXi6z8iVLBrqRvoPbgEAmovaWTchNa4WuF1E6b+5bYdbAl4Z3bO2Kaug3lnWQzg2kaud+sBT7tO7xyJZ3TbTtgmQO61h/nonWHCA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199015)(46966006)(40470700004)(36840700001)(36756003)(356005)(86362001)(82740400003)(7416002)(2906002)(70206006)(4744005)(8936002)(5660300002)(70586007)(36860700001)(7636003)(316002)(426003)(54906003)(6666004)(47076005)(478600001)(82310400005)(40480700001)(8676002)(6916009)(4326008)(41300700001)(186003)(26005)(16526019)(40460700003)(336012)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 09:23:27.9828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7fb0162-860f-40b4-470a-08daf9fed2e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7780
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> Add two new helper functions to retrieve a mapping of priority to PCP
> and DSCP bitmasks, where each bitmap contains ones in positions that
> match a rewrite entry.
>
> dcb_ieee_getrewr_prio_dscp_mask_map() reuses the dcb_ieee_app_prio_map,
> as this struct is already used for a similar mapping in the app table.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
