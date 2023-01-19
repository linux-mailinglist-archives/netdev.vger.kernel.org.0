Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BEB67344E
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 10:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjASJXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 04:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjASJX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 04:23:26 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2087.outbound.protection.outlook.com [40.107.100.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895E869B36;
        Thu, 19 Jan 2023 01:23:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UloCBb45PBCpwOFRSzo6WtQcAJ4KtzlXJYR54gnxtSmEnsBomBYO9GPjVthM2DZeIEDb/uTjCShYVNnv6+j09gMt5OL7A3gFiOMgyyONnPrpl4YjsXzqH7PhngVgzGs+4NkY5YS1oa62A4AIFjuPMLYO57PVCRz7uuejyBgciPfwTJYiMdTa4ehgwRhH4E/0EG1mTSHrpo2gljUUbF5enV43/fj+i2Fb5VDcO1U2Le96KfQodGfpYqdxhDhI+2Lpmd6E01EKAJlkXHYsRTTcSVAm7f4mBFjsFcKRHYhZi567vdFz2AjHuG0BnNnAyKuptBGN3eN53sNZ+N4hDD5s2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K6Sz1xr/zN8yTKtBrT3EOlTrS7FDfurlxRFFmdncDPs=;
 b=AMT0qlaFuTj7dQqJwH/w7eCPS5XXUocDj+PUaXVPg5O9GFHSwJ8bDhnxX079cFKVTJF2J+2zkSB0KIgD60YAKmVd0deX/HBtuN6uz/DvO5nz2rGj1Ek7h4gebrLCHrjCZtYhHAAPRdEDSl9H3V36Pq4nXHykSMUjCze6pkQbZ0EviUFIe3VGrKFJgr4pffsOVOIwPMvVEKNR5lXcf7YL5GaU1SnIN6DC6A6BY3SwHrPcvev13r5Nwy591WF/VrQgznAtyTfjfWbaIIxQtkBaZwLa1EFHm9WX9EHOpiZ/wU4smBbKpd/xWdHyB2juwnCUY0LBxeFBxd8DYLJuQ6hfcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6Sz1xr/zN8yTKtBrT3EOlTrS7FDfurlxRFFmdncDPs=;
 b=DYpcof9wofPqj9GjllPdQLARiQDo5JrbrhNqJR6sXbexbPQ1aCglR5K6aLkLZfRJAZEtTXXwxDqg96LIF7GlOE2chukfs9bODrR6mjeMOCHv9L83OTxei82L1oEZan62pfmOFXUKzqlMjWSWZV7NVcXzULFBKsP+a8881E+E5+HGkp5p6FsAasj1jc6AJfYlkDY1x8ORLVLeZUIbT7GQ37aAFbH9xVNDcqU4noxicuvZ1UEnIfZNLupyWF5BNhWKspOqW3+LDyQB6fAfDUq9XUSi1xD7mjU8xl3vTD14oVWaoTaC4B2Bd4xRBw49kRUjUgbmBu7x52fKVmUG0t6vpA==
Received: from DM6PR06CA0094.namprd06.prod.outlook.com (2603:10b6:5:336::27)
 by BN9PR12MB5194.namprd12.prod.outlook.com (2603:10b6:408:11b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 09:23:00 +0000
Received: from DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::91) by DM6PR06CA0094.outlook.office365.com
 (2603:10b6:5:336::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 09:23:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT072.mail.protection.outlook.com (10.13.173.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 19 Jan 2023 09:22:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 01:22:48 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 01:22:42 -0800
References: <20230118210830.2287069-1-daniel.machon@microchip.com>
 <20230118210830.2287069-2-daniel.machon@microchip.com>
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
Subject: Re: [PATCH net-next v3 1/6] net: dcb: modify dcb_app_add to take
 list_head ptr as parameter
Date:   Thu, 19 Jan 2023 10:22:34 +0100
In-Reply-To: <20230118210830.2287069-2-daniel.machon@microchip.com>
Message-ID: <875yd298v3.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT072:EE_|BN9PR12MB5194:EE_
X-MS-Office365-Filtering-Correlation-Id: 55d7c2f4-6e91-412b-0c7a-08daf9fec225
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oRTL9/6KSuK5pblfWSqfc4KzbBkkLnGAc9RwHpBMIcp3azPsMlBmi6cz53/Jc85WobZovai7L0dpKxkpvdLPCjqk3F8RwzP2UhTLZf01WPoXrpGbt6dzUDCLtNBfWDLQaU6eFEEP997qM2EmwKzitv/5QW2T+0eJYdMKHY9+xDYIlLm69cUANPPKU5hrJB6dy/m9pWhm+Y+vL6rYFKyRSEMGeXZsIQU/HYjJdgfowO/ReKpHmEOlMqkrTD3wsDS7rTW8yD+wrsE3Db0Tw7qCUmgMr1G7a1/vzW30NYU/lghdPSrXx1utulPovbwYfmQoQM7K04x+V9n3/WmYef2c/1tInNcn5HX5/T9xtpavXRn9+JR8GJzIuX20Bx2EqmT5PTC7dXBo7RS53XSYIiWtz4MBQhYeqL5jXl4QYxbuOvjadTxN4vAWB+dubqngaO9JYyeYB4bwf+2D9sSdvdJFgodjxQjIMaBL+3DU+l6JueR6/a/TWahuKkn96lVmps31LwHoSE3eYbyr/0AyDAQiBjsONiEXVAhDT+Djbrv6n4ztzaQxrcXpeFBHhpwySaGK+ZUrpPfWTVftpirm+LTfLdRzRgOlhme4UB141bDj4/bMEgo60HfsOmGXyTpsspYcG5Rwi5CQaNqR5lYfgnJ8x9lxr2VHQjquMs772WCwCmG0xmvIQR1YZdHq+Pt4qGZ3IkLBvH68M/Y9XBA48skLpw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199015)(46966006)(40470700004)(36840700001)(356005)(2906002)(4744005)(70586007)(7416002)(8936002)(5660300002)(36860700001)(7636003)(70206006)(82740400003)(54906003)(6666004)(316002)(86362001)(426003)(36756003)(478600001)(47076005)(82310400005)(41300700001)(40480700001)(6916009)(4326008)(8676002)(186003)(16526019)(336012)(2616005)(26005)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 09:22:59.9157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55d7c2f4-6e91-412b-0c7a-08daf9fec225
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5194
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

> In preparation to DCB rewrite. Modify dcb_app_add to take new struct
> list_head * as parameter, to make the used list configurable. This is
> done to allow reusing the function for adding rewrite entries to the
> rewrite table, which is introduced in a later patch.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
