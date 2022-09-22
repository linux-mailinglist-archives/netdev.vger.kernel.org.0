Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595245E60EF
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 13:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbiIVL0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 07:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiIVL0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 07:26:25 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFCCE3EC2
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 04:26:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsbT6kXfHf5BlAtJwHaBo6/QFZ7v+ApRtiTLLgfF05iDG5sdkcM6UwKnhbhpQy0co6bNAnCfLVlzEdaH+BMw5z5Sa7UV3557HOW6d7r0QKrFcKB78X3eAtMhfmbLeZod67TfRFjDQyEzoAy3iilBtynO3gcBrQ+TetStAgbX4Bh0rkLhVeZe4LoUuJORKastuxoIVeQbkYmKjVa8A+x1r4/aM+NdeDfEQAtryRcbbvbFfS2xEYK28ueXz4gZAW+zyll1+76YqMXGqysj4NM9lcQuFuA5JePkbWcy8X1pcWb3u4HmURnjr6QZHiFquOCG0h5Wuq8sJPShson+ZIZSKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDeUaB6FKQMnXThrWBYcBHxInki7jO78A1DeYswucho=;
 b=c/EH78qH8GXDGLHgzWqGnha9/EK/JJa+lK4cYtFKNso7ZcE33Jooml+bNM06ll9NFsijfXghnNKZJkSNcUkNGC2lAvrHIOldFLmJdOm7e6o0lqNOaxlFl9ZzkU4N1FL7BnSSa63GmZd8grcSEWgvhVRTIG8JuRdMTfubrO6K6R8JEoUPNmzMSOWkoSyv70ENOF9BgcGkMAb5qxZfEqx0dguBJcihVGJsKXXw1d+flCzV48OoQPLi241xOW3gyplIYVfOb/LMm9brrqWtbJ+JwukZPzNINJB87TFGI4gNGns6VyZlXoRfZ3t76cB8yvJjNeHPpKQqqrqMaVKx2w/wpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDeUaB6FKQMnXThrWBYcBHxInki7jO78A1DeYswucho=;
 b=Tp8Yu2iMIHfxGkyw/Cs5n6CQ8SmDx7792pOLmMZWCu9KSddgAqxCZop6f06bWOkZAlryD8sC4vbcK+qrjraec8Y36dvMlKxtlI/hf5cxy0e0PoMxEJWyIAzOeAtpSn4/vHjj0yLws15eIpl6yrwfEuPLTdB2CZzRSX4ZRhxSednt1arqoTiyjmnG/AddmjTfdDJm40vl0Et1kgIjpff3g/CsWBT/fY6yUuV5qy6tzvdUaXhRFQJx67dD5bb66hApr0n9Ja1TjNYumeExaZOukfJE7z1f42syTzPUKQUIlybHsyEwBAijuQIdigs03be3NXPFBkTRSo1X/RorwmWkvA==
Received: from DS7PR07CA0023.namprd07.prod.outlook.com (2603:10b6:5:3af::28)
 by IA1PR12MB6305.namprd12.prod.outlook.com (2603:10b6:208:3e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 22 Sep
 2022 11:26:06 +0000
Received: from DM6NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::5f) by DS7PR07CA0023.outlook.office365.com
 (2603:10b6:5:3af::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17 via Frontend
 Transport; Thu, 22 Sep 2022 11:26:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT084.mail.protection.outlook.com (10.13.172.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.14 via Frontend Transport; Thu, 22 Sep 2022 11:26:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 22 Sep
 2022 04:25:54 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 22 Sep
 2022 04:25:51 -0700
References: <20220922024453.437757-1-liuhangbin@gmail.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH net] selftests: forwarding: add shebang for sch_red.sh
Date:   Thu, 22 Sep 2022 13:25:24 +0200
In-Reply-To: <20220922024453.437757-1-liuhangbin@gmail.com>
Message-ID: <87wn9vwszn.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT084:EE_|IA1PR12MB6305:EE_
X-MS-Office365-Filtering-Correlation-Id: 64abd52c-6e47-4ec3-d81a-08da9c8d3d9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qJA1iMTa3XwJJ1tDLf+04ZNgXEnEebQ8nj1v2E/reirWx6S7ei4HAqKIELPrdN/oV5/KtMaLNH4Ah1j+oykChqSUz8AHPS9wR7FakN1snuzU1jXeaotnXh5BhryVfYsBx0O3/JKWvG6wo/z/iEzFxRjPwBOUdXsRRWGgVrNu5LeOpOFvEXj5xGquc1cxNmoHhylcziZXugOTYev8IxXAf0vdll6K9gkjxzOftIDN2EQ9uxngS4H3kvfM/y+AIV/qsnZvRyBjmFTM+Knvi1mujvnhKqaIw3jD6g9ahyB+FZa/ZA4nb1DPfnJLgtIL3/49ljAlX61Oig2msQBuEr+uNNHn4XNIq4sYIXAHKp8FlUFIoakImY/UppsXYgxfrQmyufQygnxxIv8pzWpFlILrbdyoX5dIu9JT7SuSMu9pKnnEK8BHwH4YBY5pxLEqcgodxSjId2XELOm46xotwDYxdim3GrnFCRzP8zfoYW9Si+/TRmf/fje6ZqHMEXAKzp7Gbhr7XZY3ubvovlYtRgXIG/Nh8CMLNfvSnLnp/n2dAoyYg79muefBGG4/fhoYP8Tt3jVokhXTkT+cXYPbT87oocFgC7rXr9YjM5dkjqAAtPJxqyLl39CoRe4+KmtUXbrP0x0HeN/HaTBnL5TEpb8bObNfyAQhGxvD3ySw0b10+U1CAILtc4bCaGpDBnbWV5zBZEYt2WfervaKAND0kvJDoQwS5VBXT2iUtuPum1RNb+yc14VZFu6CBjo0IGQ+E5C1dMg5oqr9gCa5rg2iXnu93w==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199015)(46966006)(40470700004)(36840700001)(426003)(7636003)(47076005)(478600001)(4326008)(16526019)(107886003)(54906003)(40460700003)(70586007)(186003)(70206006)(26005)(4744005)(36756003)(41300700001)(316002)(40480700001)(2616005)(5660300002)(86362001)(82310400005)(6666004)(6916009)(2906002)(336012)(356005)(82740400003)(8676002)(8936002)(36860700001)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 11:26:06.2820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64abd52c-6e47-4ec3-d81a-08da9c8d3d9a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6305
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hangbin Liu <liuhangbin@gmail.com> writes:

> RHEL/Fedora RPM build checks are stricter, and complain when executable
> files don't have a shebang line, e.g.
>
> *** WARNING: ./kselftests/net/forwarding/sch_red.sh is executable but has no shebang, removing executable bit
>
> Fix it by adding shebang line.
>
> Fixes: 6cf0291f9517 ("selftests: forwarding: Add a RED test for SW datapath")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
