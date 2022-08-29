Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F705A49E3
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 13:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiH2Lab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 07:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbiH2L3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 07:29:45 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20616.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::616])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5061D7437D;
        Mon, 29 Aug 2022 04:17:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kiBPSpahkAXKssEk2POI4wvpIJj2a8jdhCKowcSF9fqzUBNbiE8sEh6RqZL+capUhFEgkP0QF4ntyb4wEtP+zUi5c6ozU2Y7em+vNqIFtuDouO6ihPmJACUbkwXxHjCx8hoXQzIlIwR40KQT8+E1siNwPi09TYlO+b1axoanN7IWNJ4dFxXu+ujudxAQz2NiXxLV4uQWrnnulBrta/YSsNymyKxX1yGvcJKNp0lJGgd8J5aMLyHvzS22NB8PScwkPURyt2YDdbD7IRacTPSRCZZqUg3XrziBhZEqHUPBeeQ7uxOIg2mlbPq8G+nD4ofAFbqz8yLWSSYnqiicL/dLZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xlROFYK3+0EuvVBgXLR4y5Wwp9l0uJG6v0e/9cDU/5U=;
 b=eyvDurdqYiuYh6ev198sDXdVKS4VoNA0BT1rBnE9VRU4pO2xkUjkokg8rm4Vl3qs+z+8DcojefwkD8d7Up949CqKHj8ffApYA1jCsAieWhe4WDHZmySpr5rfduB2EnQcIaP/AeyAt0Fxs9N9G8H93fQy09m93ENHTZ/RJk3rWm8stMBk0dSL/QuXL377GqR4cYiFumpZvdPtAMVtaVef+WWH2BzbhrXpe88YLpE3amt/4x11c6lml6GrQ6XK0Y59MEVNWmOgHp/cw1YgANA7QGdbNULpkT49Cyrmd/C/vn7bMkTBPyhhuRhK0gSKQpU5J5cgIhKxKbymoHGVqn03PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xlROFYK3+0EuvVBgXLR4y5Wwp9l0uJG6v0e/9cDU/5U=;
 b=ciC76CLAGP/GmSadStEJW1qAsDE1JH9v3/Sx4HzJTL3y6zmgQPzOuUr9qd0pFG/TxPxI3DTqbam5Q5USH0e885bHlnItmL/i9/iq89zNmOVDQCPOv3zy888vvx8W4Y8CnFLeprCL4/ZJpAas86HEZLBZRpQvUu19H3xP/rsZje20Cp6nPYJsoaDHwYyknuvL1aSlu+f03KfpJ1FZ0mJz2x1MLAFJzs2CfX/9YXo4nnvKqY/TWjIjwCpKekol78DSHPdY2UTVyIkZwTLzqhvjL9e3DlV4I1lFmZ8qUd12VmqqKw/22tG1AAohWkGJKj8IB+RYDrh7RWyFiaiGsSWuxw==
Received: from DS7PR03CA0220.namprd03.prod.outlook.com (2603:10b6:5:3ba::15)
 by DM6PR12MB3323.namprd12.prod.outlook.com (2603:10b6:5:11f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Mon, 29 Aug
 2022 11:14:10 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::a7) by DS7PR03CA0220.outlook.office365.com
 (2603:10b6:5:3ba::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Mon, 29 Aug 2022 11:14:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Mon, 29 Aug 2022 11:14:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 29 Aug
 2022 11:14:09 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 29 Aug
 2022 04:14:06 -0700
References: <20220829105454.266509-1-cui.jinpeng2@zte.com.cn>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <cgel.zte@gmail.com>
CC:     <idosch@nvidia.com>, <petrm@nvidia.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] mlxsw: remove redundant err variable
Date:   Mon, 29 Aug 2022 13:11:38 +0200
In-Reply-To: <20220829105454.266509-1-cui.jinpeng2@zte.com.cn>
Message-ID: <87edwzi9ok.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 170f094b-20fd-47b9-ad1a-08da89af9928
X-MS-TrafficTypeDiagnostic: DM6PR12MB3323:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sZF0O/BYKYQo2B86Au4TXASZnOKoqYojwon4IawspaCa/xPSfltYrG+eTctm8y1of71fgVvUCGmrq371H+7znfLql/0keOzTtdluqG6Qux0rmjkY/Wac1hhXErKPxBku1HvtFoHA6rK0KL8sl82i53dLZLCnLQzv6YABhkuNq2GfBHibMKdLhGb4Rx6GPaJ5uqDmN71F5cdAagLlB+Xy9wQzx0NAAFXZA7lE6InathBKqwZW1nmDSbrNg8XEe5VGZ2fidXkmEi2hKQAfxOiuZ1arztMK1/Y0xtlBJc1suYDtVDiast9Nf19nw8mVMfpymwycMrYQwwZQtb5jkjm2Us/PXxlMcD+p2KN2DvQb8I6US4IAuLJynPKC91N+m17stgydZZ3hckFjc94wp+xl64vmIXecQUm9Lg4Wgj/0F2t9lE1fhSLm+CuBnrJ6FNVcr5ypW3IqPx/82LENgBnHafo8uaXtJ6U7CbRE0DGYXHro4DPiwcVoTwULsu/C2y4ykyVAaNRD7OEf9HnhTHIOTuTaH+vraAnevuTVpXgty+KToYeid/yTwVlhaeaQgkXGqmADH2x42dPgVXWqLj1hh4zKJz9twZYydZc35gOCA2Dna0MKTvxS+akU7s2caqskqpC4WAPQC2oW35o8oRlXCLh5tSyTz1VoCH0QjrA17A0EmNGLOmJD4TYAOujGhOC+w7bEiz4Wv7ZFtWsxhq43ZsqLRra9Vi6r8jrE2OkmMDBhyocKYValxSHtBNiU3+xVxka44p1YD8kJMY7h35xCsIVs6D1Wq5/GXjVMiHPtgzMl6NwAhmkpuzTIAwBVo/hX
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39860400002)(376002)(346002)(40470700004)(46966006)(36840700001)(86362001)(8936002)(5660300002)(356005)(6666004)(82740400003)(2906002)(81166007)(82310400005)(478600001)(26005)(41300700001)(336012)(426003)(40460700003)(36756003)(186003)(6916009)(70586007)(4744005)(54906003)(316002)(40480700001)(70206006)(4326008)(47076005)(2616005)(16526019)(8676002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 11:14:10.4458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 170f094b-20fd-47b9-ad1a-08da89af9928
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3323
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


cgel.zte@gmail.com writes:

> From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
>
> Return value from mlxsw_core_bus_device_register() directly
> instead of taking this in another redundant variable.
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Reviewed-by: Petr Machata <petrm@nvidia.com>

Thanks!
