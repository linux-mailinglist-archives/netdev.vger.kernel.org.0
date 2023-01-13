Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC14B669D52
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjAMQKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjAMQKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:10:19 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20611.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::611])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CB28BAB8;
        Fri, 13 Jan 2023 08:04:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVxTgMvmNMeOlHmQEmwJ5cbVdC2btS1W9DgfuSWB1WhXdhhGuZ0NaNGCnekqO23AW+uGj8itwTWQzeNtaDkIGG5KbtgTeSQD75xcdZOUhDANkezOffQN4pOelGS42LIq967FtMLviiuvw55BVR0Aw+79eRY/yMCl3XzDJL3C3Ku41nMDttDk4GxSRJ9vTwvE85Kxuua7hn5L7rQ9X85N4GU0ADx7cFJ/mEm6Ao/zVSw5VeUVAedjMHVtDtw8QyatfhXSgae4NVVGXCV0ynKA1clvhHebpbRM2Eux/BFy60M7/SlrId/ByqAniswjxz3dqhnQkh+4DefNVrKyyZnEqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jMeY1cLfC9UxRT4ExOlr8uQLnfTRuzbppNGzf/A/rhI=;
 b=jVr3Nl5Kw4PpbCRrZdtEx5zVWrnyHKfZlwLIU+Gt4zSpzFo4qDjKqJ28NxRvviH0JUk7f7MHdrnl1iPwoS5ytSwriNobSS1W4Jod6421UhUoa+R1lB/GCZfjPO5MrUAZjJhMA1FmIiLNPRVynTwa3YtzRVLwm1LmMO/Barg2DBWR8oME9tece7C/WOytTqH7+NfW+FGy6T8nrCzqgTorAFhd7IYAMTSsBenskUDXL6q6JkgBmCtPWwmcQ7Thqdr0TrJexX3XweUgXeQZxzedGYSehAFOK9htPoNvN04VfksdWcsle++iYpDNfzdS9hPeo/lIFYHRgmS3GKKXWzUhPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMeY1cLfC9UxRT4ExOlr8uQLnfTRuzbppNGzf/A/rhI=;
 b=HgNEB0P2JZOyeKyvCCiEW5pVcpSZ2/Z8ce36NK+b2DrkOOmGz1gapWTRhfQGnlpJd5mny8y4U9VosCycMiTLZyKu43gT6kDLX3+G8PMFS7p8xU7OVCzX+nuy/2YMu8ObnlG24YCdLAcyFxbCYeWQYRpSmbPhn8yyktU+O5LitavJ2BTO+DNtImwnuDlR7VNJEycDlVqLPz0C0f36cqz4GfZK26HN8QCh66pTNgp01ySQ5biFBlHkf1OBtPNAA2OJu/jJzssgONjLKN+iOsUJz6DyBVLNsGs7OWbyBz9rwKAuDA3L/6ag0Kdcjb5p+m5ahWpREKHCH22WjnqNA3QyKA==
Received: from DM6PR10CA0025.namprd10.prod.outlook.com (2603:10b6:5:60::38) by
 MN0PR12MB6054.namprd12.prod.outlook.com (2603:10b6:208:3ce::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 16:04:03 +0000
Received: from DS1PEPF0000E644.namprd02.prod.outlook.com
 (2603:10b6:5:60:cafe::69) by DM6PR10CA0025.outlook.office365.com
 (2603:10b6:5:60::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.16 via Frontend
 Transport; Fri, 13 Jan 2023 16:04:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000E644.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.11 via Frontend Transport; Fri, 13 Jan 2023 16:04:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:03:47 -0800
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:03:43 -0800
References: <20230112201554.752144-1-daniel.machon@microchip.com>
 <20230112201554.752144-4-daniel.machon@microchip.com>
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
Subject: Re: [PATCH net-next 3/6] net: dcb: add new rewrite table
Date:   Fri, 13 Jan 2023 16:51:17 +0100
In-Reply-To: <20230112201554.752144-4-daniel.machon@microchip.com>
Message-ID: <871qnyzajm.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E644:EE_|MN0PR12MB6054:EE_
X-MS-Office365-Filtering-Correlation-Id: fb9fc8c0-4e97-41b1-4961-08daf57fcacf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0VVYcC4EFe3n8lzZBPm2qQ7khf9ia73yyhJI3NotqspVQhmE5eFV/TzGwT7X6q8C1Yyb09FH6DWGgrRWMWiwOqmzvtagS7Dq0Oq9CAJgEcou0xpxC/J32IS41boK5Fuz6F3Hv4HZetxQvScHMjqIw1lzH8ukG16oH92ItKXy2z6/yrI/fKesBMEQSQ6+nGKB8b/ibwBh66MW4efVfenfiXU41L+CF5U6Roq7RpCl+e4oJrOdzEKbH2cAHoz0XVDOm6Fk+c4dTZ4/EQN5tFGr3UTlAItn0SKwyKbmd/by9eNWhWCV+0R1T5PNdlV2bHfTCQOL6Y2lXEDBKyIGUOHPnIeD/oXGOilAgUsOHANKw0qQmGW5T+k7TTZFuwOIHfseshrbxacOR5pxKaj/E1vzGwZlDOuMNpI4GYx+XGw+osM1/VExuXm1NxOj1lHAOtwy2l7r6MYv4QABROMwtzsDDBfdQSgO9NI3w9U3+o6F8w094qQfqJFWH6mBBx0PLddjRboipB4S4RB+tEqp3qr+jNocO/0ySH9Hyi34sK+0faie2JnUrp10nl2NIdBbQArOgdFDvXc3zpZtfU6m5yoLTatsXUkMeP1vYdWJEBYDVQLGc7kg5+0ievwk9PE0rVGrHx6E55H1a9ftlOOo+O0CpgSx/Jmaq2RULGEsYwSkC4tbsFDsxB6S5XQzIf+ozu6RbzoT0KPulB4d0Qjk3bgWNQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199015)(46966006)(36840700001)(40470700004)(4326008)(70586007)(70206006)(83380400001)(5660300002)(478600001)(356005)(8936002)(8676002)(36756003)(41300700001)(186003)(54906003)(82740400003)(40480700001)(6666004)(316002)(16526019)(2616005)(7636003)(47076005)(426003)(40460700003)(26005)(86362001)(82310400005)(336012)(6916009)(2906002)(7416002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 16:04:03.7018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb9fc8c0-4e97-41b1-4961-08daf57fcacf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E644.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6054
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> Add new rewrite table and all the required functions, offload hooks and
> bookkeeping for maintaining it. The rewrite table reuses the app struct,
> and the entire set of app selectors. As such, some bookeeping code can
> be shared between the rewrite- and the APP table.
>
> New functions for getting, setting and deleting entries has been added.
> Apart from operating on the rewrite list, these functions do not emit a
> DCB_APP_EVENT when the list os modified. The new dcb_getrewr does a
> lookup based on selector and priority and returns the protocol, so that
> mappings from priority to protocol, for a given selector and ifindex is
> obtained.

Yeah, the call_dcbevent_notifiers() business can be added when there are
any users.

>
> Also, a new nested attribute has been added, that encapsulates one or
> more app structs. This attribute is used to distinguish the two tables.
>
> The dcb_lock used for the APP table is reused for the rewrite table.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

No comments about the code besides what Dan has pointed out.
