Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2DC671B06
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjARLpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjARLna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:43:30 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E726D373;
        Wed, 18 Jan 2023 03:02:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPaxfthrgXdGE5Ij8PMdKoxsp6MrNwp7hjMWHMhBM7FeftRInro55uRN4ujrIuJtJ/XXL0XhB5mctbCD7BHbS9vkAPbvoDQ+Cy5Sp+jBQNC0iCmBQm8sAy1pxqlqVph2c0m+ZvMEdzJ3QpASPIXmHPtrRlqxDtgm8WFUcAWyBo7zRcVKLNve92BJ7lrNIjcA4Ip7X5Xw7zPfH4Azsxdrj/wIYqR3glM2eME55/YI7dhkZnwLnV+50X6NjxkfMjMxdP3EgGmhLdWvKPmSh31DRSyxdBi/kqB/bPYFM7m/JyqYdrFp9QyvjjUwNsC0nYxzSfw46hP2lmGwtFGDwMNMeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2QG6gAjYIpKPON4AYUavwFJPsAXRGWvr3EkFd5LMXdc=;
 b=d5rnqBVaq8d+qb+1q9najLdLfyZ4KAXGRzUlHUSOvvY8eqiBsTrYNIZrtTMmvVehBDduqzLiTpMsAAysSMAz5kTq5jm52mPxckSB9TMLHY5AwxgCTHZWPsOGCIZdPtFoniEQ/E1nRDOiV5FROoZR3icOGQIqAeus5MgSxjdKRy/ocV+KVIkzkqdbmRJbf20Y70/EmNw0b8MktYXkbvGhCSY84lKkSe7DUwRTcbtACmT59wADf+lbF2m9XPxADU1EyxguKhzbnUT70B7MQwHiQvsEtGyv8GlR0b4ztcd0IukqzamCaaMV0PDjuSYYe5fqAF784n7uMgUmor9a/G8zUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QG6gAjYIpKPON4AYUavwFJPsAXRGWvr3EkFd5LMXdc=;
 b=C1XiR/0yoHBNg0XRtW9B1lzoc/nTpSC0JaSbv+fxfEHR3PqkPPLEgFkLEChPskxwMeilwl/rNNnlQyx+4FqfB8wDbX5h+6iSc/kJAJ9kQZGuuYLqRxZ1jUOaqHJ+OtskhpEG0FVtnFOoLddnb2+UQk1KFXItEyw02bnAAAJeZ2TPbcflJ7lQib5nyDOrUCEb7tb2zQoGF1QO5YXhh1ZUgMc25039fdUpTcRLgE46kYDK75Vx52/0glqgsCho7ZGyx8wR560WDVmQ66CCZ5QUEM2IsHBIKnry3UmryK7iIpBrur+Jq5LXJbEBgVWcKir5y3k2Y0cbrOzgT7wG8D/rEQ==
Received: from DM6PR02CA0161.namprd02.prod.outlook.com (2603:10b6:5:332::28)
 by DM4PR12MB5149.namprd12.prod.outlook.com (2603:10b6:5:390::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 11:02:06 +0000
Received: from DM6NAM11FT102.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::62) by DM6PR02CA0161.outlook.office365.com
 (2603:10b6:5:332::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Wed, 18 Jan 2023 11:02:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT102.mail.protection.outlook.com (10.13.173.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Wed, 18 Jan 2023 11:02:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 03:01:55 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 03:01:50 -0800
References: <20230116144853.2446315-1-daniel.machon@microchip.com>
 <20230116144853.2446315-5-daniel.machon@microchip.com>
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
Subject: Re: [PATCH net-next v2 4/6] net: dcb: add helper functions to
 retrieve PCP and DSCP rewrite maps
Date:   Wed, 18 Jan 2023 12:01:33 +0100
In-Reply-To: <20230116144853.2446315-5-daniel.machon@microchip.com>
Message-ID: <87h6wow1gl.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT102:EE_|DM4PR12MB5149:EE_
X-MS-Office365-Filtering-Correlation-Id: ea92bf59-a4c0-46ae-859f-08daf9437009
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0rkKghqz3IfYXMCHzTBMH6Ky2sLTQPcGyivlu2MYrrGJPQnCQ5HGKMRTveWxJAEB+Epb/LykUDiYLjcHqIVxqa/ji+swmSjgoIicrgM1APDb/cjcxiDZATi+zGN+PT53o/W+6iHzE2BEgNY3JQXKaQR1TQ6FIQ4FYjGml2hQXViV74yP8KqJ21cZ0Xj/6oqseiKviAuiuarBr7FpgcshfbV4sY0rqQmH7fcV71DUm0fdHtrSOGxnuiBhI8Qs8eHhfL6m6Np2LjOQpSoGdb/H+yKCvYn22jYeCNvD0JjxZwPo/EypZPyiFZxbngnyXvgilZ/5HoYK33eDliuc/C7BQDQIjgrHIVSRPE7LjWRMttNEGHA9Tr9pVxqmblaEVStXsbxQYyXdjEk8KWTS6A7BT6SG4CeuXA1uvv98JcQTSbG4pAY/If22z9pb/c3iwenYt5jaEpfFLgQiltwbPdPXnBRgxXkPy4Ah0VxCgdAp1QLQK4BuDp4cum+R5daGAZFyBKCDVRKQUdPU5v++TxRnoTKQfOfxtBZ6OjOxf0N+2DOCImFrXqaVr94039N4+HKmjDn9D8THa7QMVPYm1rHFzrOlv+H9UIDOo2Wve4E4rnX87tJUgEAU/2N6G3qPiY59U94tsf7jzomrHsqq98iNI7a55pz8jrzfyvJb3a+9AMcUnlUiF0Dk2dhrCoZqMnLax72k5jOTJx+0wcCEqcFBQw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(36756003)(7636003)(356005)(70586007)(70206006)(86362001)(2906002)(7416002)(5660300002)(4744005)(82740400003)(36860700001)(6916009)(336012)(40460700003)(6666004)(54906003)(8676002)(478600001)(316002)(82310400005)(2616005)(4326008)(41300700001)(40480700001)(186003)(47076005)(8936002)(26005)(16526019)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:02:06.2737
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea92bf59-a4c0-46ae-859f-08daf9437009
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT102.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5149
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
