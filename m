Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AA15A1284
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241679AbiHYNl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239774AbiHYNlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:41:24 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2080.outbound.protection.outlook.com [40.107.96.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFEC40BFA
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 06:41:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eXXc8NVY8UvL/slzyVSIONzSJFzD7+UB9hOFwNQ6K6ZmYyWFG6P+AA6e6HzW0Qml39soO+JkYwXgYHRVyNs2GMSo6aol3GTxHGwxRzjCeQizPLJWBhbS+fIOSEci9Vdb5enuA9g3zmuoC+832FHiPXJ2RxN2VXXsaEhuJFAe8u5hF3fQBFDsrC61bMEOyafe8bsEJ+9w9HKm7IBsxBVHYpNJ4UqyRvvX2301LDAEmy39nTNlB7z+vnyugEDgdik6z47ulnpwc8DzPzzd845M1Z5tE1Ih/XwCpD862XDMgg7tZ5+0L+a9eUIzQlsryM3YZZ2jTa3vJFYAzCaj4SWiQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZPRhmhfYkoqaTPPdH3SvQ5VwUJITCGhwhh6MoWK7ro=;
 b=kcLRZFsL1+tgCpopKa61MmwkHX8mpqP/voAlTbIi3M+3czRGfJvk/ui95k3kJLWeYbT2oPLRHwyDnSbNLF1qpmppwzqxRdCUPmiTyAS7Fb25jodBXVGKLL9EMkvdXzXJCoKUo7ALyHl3tq4BRIdO/b29PeTQHaEm1yJLgPMEJNmywEPGzDRM8an4BE8h+Vn8hLMS+evdXkEHYYlleZ1h2okeB65PQPjo2n7jKBahsjKJh3UZBsGRyIqEp/PKkQeadI8qH0N5bfQcJFJoLYttHuQeluUPdz+vxDCHtdiLWtjgsNjWrpA/xmDTgqf6z/4ZJmVPIu8sdm9V27RKY4ZNiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZPRhmhfYkoqaTPPdH3SvQ5VwUJITCGhwhh6MoWK7ro=;
 b=jJLBHyRaAvuO8G9AD77uGvKn1RqzdGBgamMVAsjU67f38yNoJ+IQ32ixkqRdcsMacL2Echs1teWfpjUl9A0gxaLSp+sPX5N0i1nrid+Guwt+2UzMUxKQiVJLQww6mPY6YacH7a1BtnML5ZQSwODqnyC/4fxO4UYlAN++pfFnM3RcOBE1hExsZRX+hQ/JPmR80TRIlPlLD+J+9vWclR9WQ/8lIUwNME9+AO+9pwdyq8i7exgWvSRyQaoIs5h+ljAL/Sg7iHov98ThpI3Yems0y1JknRL3T8mE9RFp8s6P7GSCybDbvspvl9+cgHDpEN2Dy9x5SV0O7e3OuJhH0yECSw==
Received: from DM6PR04CA0003.namprd04.prod.outlook.com (2603:10b6:5:334::8) by
 MN2PR12MB2943.namprd12.prod.outlook.com (2603:10b6:208:ad::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.21; Thu, 25 Aug 2022 13:41:17 +0000
Received: from DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::35) by DM6PR04CA0003.outlook.office365.com
 (2603:10b6:5:334::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Thu, 25 Aug 2022 13:41:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT112.mail.protection.outlook.com (10.13.173.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Thu, 25 Aug 2022 13:41:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 25 Aug
 2022 13:41:15 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 25 Aug
 2022 06:41:13 -0700
References: <Yv9VO1DYAxNduw6A@DEN-LT-70577> <874jy8mo0n.fsf@nvidia.com>
 <YwKeVQWtVM9WC9Za@DEN-LT-70577> <87v8qklbly.fsf@nvidia.com>
 <YwXXqB64QLDuKObh@DEN-LT-70577> <87pmgpki9v.fsf@nvidia.com>
 <YwZoGJXgx/t/Qxam@DEN-LT-70577> <87k06xjplj.fsf@nvidia.com>
 <Ywdff/6c3nRMRHDb@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <vladimir.oltean@nxp.com>,
        <thomas.petazzoni@bootlin.com>, <Allan.Nielsen@microchip.com>,
        <maxime.chevallier@bootlin.com>, <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Date:   Thu, 25 Aug 2022 15:30:58 +0200
In-Reply-To: <Ywdff/6c3nRMRHDb@DEN-LT-70577>
Message-ID: <87fshkjv9l.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fad45ac7-3eaf-4c1d-af82-08da869f7c68
X-MS-TrafficTypeDiagnostic: MN2PR12MB2943:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qob+mro7n4zgKOVs0AgF1N62Nx4RnrzWUWAgdez8Gcr4WC+m7DTkscMjr7y6vRvCCmRpxPgY5Pxyg9X4MbyI+mxR7JFGOBxwYIffu+/4+xkBVXA5lCy7vmAB30lufzAPW7GgvO2TbZjE3seTpzvcYJ/NiYiv7ajtLttKtdy/OT1/fo7NKsMnViUqUa27fdfCja0jFyM6H/tY+eDflrk/lJXTF1U5ywjbtbUoMW7W8xoiDrj8UgAr2e3VsmZMnOnqGh/3BIb08FCFzUxcCh8MchpeAy+4rlpONmR0W9xL47kVhPY2D6sN/+6t/H6w8HQQw/1UPrLzIQZFjIjJvh4tV3iNOzDuAffh+Vklk6ALoWXK/N0XEAsYk3qDm88au7JotqXl//yqxjbwzmUxLmPIepdYc2q17zZmNXS7pxCLChbbe5aDCvbJ3+rP+t15DmiYax+TITlYwNH7dzolMPN0GTf4udieg5sG60LpcVIOdBBXdE3U1WiKfpDSCtxcIQzKjHRPIgq4q80kL0eVFfBxSUW+USAGvl7lNuL7Hg0QUz1RVB3gxW2vngZlaOj7ALUEIT8HbnnEu4oItab7oaJdSnxQKQGzf+5gLKI7nzUW2jWjBPCQLiq86t8nGKX24INLXQjP4qjBzWdNmrDiP+wCgkBYExx2lDS4EJJ4AzTNrcXqGToVcS9mqQhbFgpEp90waXugpqGhYIb44p1OR0ImLwOdCDXoTj4BR8XeP8PnKB7gGFKofJuDyUmRgbXjBblki+tahyG1Qao3lKBJfp6S4G4yBkG34Hz0P2QxAex0xUXUoI32iya8tJ6clGvQbrKO
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(346002)(396003)(46966006)(40470700004)(36840700001)(82740400003)(5660300002)(81166007)(356005)(36860700001)(8936002)(40460700003)(4744005)(36756003)(6666004)(26005)(107886003)(82310400005)(86362001)(478600001)(40480700001)(41300700001)(83380400001)(2906002)(336012)(186003)(426003)(6916009)(54906003)(316002)(16526019)(2616005)(47076005)(70586007)(70206006)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 13:41:16.4941
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fad45ac7-3eaf-4c1d-af82-08da869f7c68
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2943
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

> I will prepare some patches for this soon and make sure to cc you. 
> Initially I would like to add support for:
>
>   - pcp/dei-prio mapping for ingress only. If things look good, we
>     can add support for rewrite later. Any objections to this?

Rewrite is closely related, but we don't have tools to configure it
anyway, and I don't see how adding a PCP prioritization first makes it
more difficult to add these later.

>   - Support for trust ordering as a new dedicated object.

Sounds good.

But note that I'm not a gatekeeper, I just happened on some opinions :)
