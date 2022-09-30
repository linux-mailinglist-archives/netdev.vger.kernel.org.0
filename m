Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6B75F0F37
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 17:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiI3Ps2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 11:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiI3PsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 11:48:24 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019501B0E0D;
        Fri, 30 Sep 2022 08:48:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCr1QJUIdS0ZCpkC+5lpH3BlqXitno7LLZOCO/2DjwHN+x/8Pi4UGrDI5RWvRNJ5q6WO/elf+xv6ORvYhZYOlsgatv2PF+ZjlMffGbEANU3QAZnmmcgQbth5ADfJl3FHHPaD/td1m4SsG3LebRk2uPEZ/Vm2JnvehQGifOduOc8tkD8Jk7So48Op4/RhSos1S+A1aVMWEzA2b7EHHSlmb4AKOjUL0G5/xLIWKc0+6TZeXM4p1x2AjH9fwqx5xH7ll8WAS4OYz8e66j+VMr/sjjHpocBuLdlt2WFcFzCNTrApMWPoTgkF75b8bO4dCF2/PyaQuUNEWL85KfhDI/TIkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rR9PKpO0GcA5EX23Zw3rKrOZ2FmAnNhjMHNEGsKKulE=;
 b=gEUekvPIj28RLtRLnwugqocF/xl/fRE+LfgCesuAW+65rhkGm72O+DgGtqKOHHPSUt66n0j8totI/cJh8Pu4kBxRB4d/+GgQzEK+X6zcq1/rBuIGm45u1lrLtDD95BKS3FtDy4kCHDckPG7wcSUV7g1vHOZgM1dOk4Kv4UrXV4U1AjRJdVRUnFSvV5P3oCbY195Rf2XtEywtQ+bjCe5mC7XG02i/3GcdtfqfZ4pkx0KreVGyrwb7KBwFSbmd8bsSjWQSnMjaTBxIYSr0aXRrRQWyMUZ/uV1RbTG7g2G7eL6jnMdz5EVJPvFA5QnffEY+KGG+N8Muqw1jgU1MIkYzQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rR9PKpO0GcA5EX23Zw3rKrOZ2FmAnNhjMHNEGsKKulE=;
 b=R62iglXDtlPSKp36hLGj1zDSkMkKEadrDg6mILVKMCWzKccEcI+dF7KoFDDr5RsRgFOVKsAynCwuMAyskQyyQqUbd7ur1mwB7RVJVyoCFEPBpqqZiWYDPNnzjURqAThGbUH/GNbaozAHunWG04alu+RTru2Gy5E5ES5EqrnTzMMc2W9Kjb9HEhf/bAYGgSNXCitzGEIPJpg9D7ZbzhUhzHl/hYJb8jRsEro9JVf4ahgLsiZvBBFXB1GtGSaHdzdxEh848nn+uMlazUKRiP3PE+gD0FL80iMEjFK7Nn9m/rYBIj0lERrxCJZ5MAuGC5TwNjR6+9JlJa5c0Rkd5ExMBQ==
Received: from MW4PR04CA0047.namprd04.prod.outlook.com (2603:10b6:303:6a::22)
 by MW3PR12MB4476.namprd12.prod.outlook.com (2603:10b6:303:2d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 15:48:21 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::22) by MW4PR04CA0047.outlook.office365.com
 (2603:10b6:303:6a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23 via Frontend
 Transport; Fri, 30 Sep 2022 15:48:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Fri, 30 Sep 2022 15:48:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 30 Sep
 2022 08:48:14 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 30 Sep
 2022 08:48:09 -0700
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-2-daniel.machon@microchip.com>
 <87leq1uiyc.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Daniel Machon <daniel.machon@microchip.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Date:   Fri, 30 Sep 2022 17:41:22 +0200
In-Reply-To: <87leq1uiyc.fsf@nvidia.com>
Message-ID: <874jwovp6x.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT041:EE_|MW3PR12MB4476:EE_
X-MS-Office365-Filtering-Correlation-Id: afa1b289-d45c-4cef-032b-08daa2fb3379
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yrk/zV6qBq7WtjeI183uhFupv2042p5C/6hi0DJdfDkgKUEisDlQllpVxI1mmplVzOdAscLQu6/BKLczXNlh3PwehopGDCQVtO61Q5PLF5bq0WZhqv0U7Z50NPHyDRT/dg6+pusJi3BOJ5QTkitSAO+mmFzqLPTqQEzVFQhdAoqRpSPxcFLUphQMQb0MHXsJeUYsb14iN1TNH1Sy9yProh8hohi21pyHQGo0vt3zLHs0jzNnLArRRoWowafHjoJE9O073K4yT7Np6PZdFgjzEJGnS2fuSnVXgb25V6DICdBzZTQvYZ79CPRxY20lXKSZp6MORgPMOYSgIcTJCQ95/vd05GHZmVn8D7EKp7JhXWApxnTgJEbm7mxWW/76a47jRdWM36PP5yr7LqioBoEBAuSzs5aRsoVd+Ba4Lm2B+thFK91tkmiIjbqjg1Hn9VU+2e8pgUkWgvPXIqiGnN2j889gXhJXBVhbIakpsAQJ5IXqzan8yLuakhCqIOJWYoElO3ivCoF7sPaer4u5cZWOvs15CZUcGtgdMmUfxP2UNaZ0+6FccpEA6k0wv9rEMzqgBACF9DDn0crx5kO62pUyj55hgLpFnZiLRGBtWF0t0f7ZywlT+fbEfsYSXaJ6wua9yIEJ12PHbTK3WAwblOuYPv/sGQElArxDOQlNwqvdkc9ZHMqf4b3tEKeSSWDF5OkLhdyy4Z1PbsUkRj/JulXETi6TnyudsQSVoTuInuKrUuL8UgaMK261TGnkPOcxcVxIJCYwwly8PC+dWJWTQIskNA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199015)(36840700001)(40470700004)(46966006)(8936002)(6862004)(47076005)(426003)(36756003)(40480700001)(37006003)(2616005)(40460700003)(8676002)(4326008)(356005)(7636003)(5660300002)(478600001)(6200100001)(7416002)(54906003)(316002)(86362001)(336012)(16526019)(186003)(41300700001)(6666004)(82740400003)(4744005)(36860700001)(2906002)(70586007)(70206006)(82310400005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 15:48:20.9312
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: afa1b289-d45c-4cef-032b-08daa2fb3379
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4476
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> We can pack the new stuff into a smaller payload. The inner attribute
> would not be DCB_ATTR_DCB_APP, but say DCB_ATTR_DCB_PCP, which would
> imply the selector. The payload can be struct { u8 prio; u16 proto; }.
> This would have been bounced by the old UAPI, so we know no userspace
> makes use of that.

Except this will end up having size of 4 anyway due to alignment. We'll
have to make it a struct { ... } __attribute__((__packed__));
