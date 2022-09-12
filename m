Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047D05B56DD
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 10:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiILI6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 04:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiILI6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 04:58:24 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F0633A18
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 01:58:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/s+DM6toXDZgEi+oY/yaz8eWCcfMg0D+S/bhWOkH8Y8wcFOfX349LbySV/v/FmzOGO4Swv4hZB8sQGWvCQKZ1W0Goo8W0q8OCcIbvxLz7/tUh9oI1KiEwUIaI6V+bX5JpICIbuseFCZtrlWPVx/TIoZqjDT2dnT2CZpMOYrRSO6AmQpA2t0P/3HGN91o66q0wMeP9LinHBn37C+cXOVJDZnB1b4cDONGrYJ2uZEsZolD6ESSUNZusGxuww06dKbQsrlVb+SPfoY8um86MT3blEwoJBr1Q36KYeEC+vElZ+7InWL3gv12VPN2A+azhZ3RuLvx4crTsWKXX9VeB9g+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=loeFG4A/W3oehRw2ZbtsYe6RkgvHHo1vh2D9rm1N4QQ=;
 b=ijd6DJAM0tucaT1c0bNHVa+eCYTTO1PjKPEmPsLC/fNyyI5u/3/hUj07YWdEn5l2vX4fk1emZOUJo0tZuLzy8SO6bB+CN6o+dB9Y2v/yZp4f3e+JJ+l9MeljNHAerUTZTTgmF5nrzu51ZZiVmo4t5lwy4ng9DBhksilfvszbvsIDIU15+3rPd8NuqT4GySNx7gjeoG8hBFoOlOcifb5si/7CfxqJOza3NFe2BSte63fpV40IRR3W4QAoPXijEuzJ5octsvwgaVAU+wxu8LJBgZGBZ5g2PP2ZCnp09ZjLGDXzMi+qTvilcZABaRvf+zGewrI2oOWCshULaD8bgNqttw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loeFG4A/W3oehRw2ZbtsYe6RkgvHHo1vh2D9rm1N4QQ=;
 b=nd04GTauJzR52KNIeZQT8TM8JIwf02K2ZW/Lww6VLhD7Fz/orfdmqqOEsjLs9Xgay10hUtsYImAaQvyyguIEtxDKiDdHdIiOJwQIdtR7pAZ0uRW/M+M5J2q+/qv4gSRuhgi24SCdp/8U5UWH8aCIb6RWmqWjG2wT+2W35ZG/7h4yB/o0uUeTCA20Xy8pUr48BDBlZGM/EwnVMgi/x05t81qxGSIyYkJxs+/usSTrXKPZpv2XrxaZXI3UO+sAIDzcqbwQ7x8lURDJ8V0iVHJ4Q1X0SOqVr+2pDhSqA0KF9PEZdLpWM/TkyKxVAE8VW5K63ijs5m4vyV5DxfZyfgW34g==
Received: from DS7PR03CA0012.namprd03.prod.outlook.com (2603:10b6:5:3b8::17)
 by DM6PR12MB4880.namprd12.prod.outlook.com (2603:10b6:5:1bc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Mon, 12 Sep
 2022 08:58:08 +0000
Received: from CY4PEPF0000B8EE.namprd05.prod.outlook.com
 (2603:10b6:5:3b8:cafe::c1) by DS7PR03CA0012.outlook.office365.com
 (2603:10b6:5:3b8::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14 via Frontend
 Transport; Mon, 12 Sep 2022 08:58:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CY4PEPF0000B8EE.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.9 via Frontend Transport; Mon, 12 Sep 2022 08:58:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 12 Sep
 2022 08:58:06 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 12 Sep
 2022 01:58:04 -0700
References: <20220909153830.3732504-1-idosch@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <edumazet@google.com>, <petrm@nvidia.com>,
        <jie2x.zhou@intel.com>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net] netdevsim: Fix hwstats debugfs file permissions
Date:   Mon, 12 Sep 2022 10:57:06 +0200
In-Reply-To: <20220909153830.3732504-1-idosch@nvidia.com>
Message-ID: <87pmg1dl5z.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EE:EE_|DM6PR12MB4880:EE_
X-MS-Office365-Filtering-Correlation-Id: 35e55790-f8dc-4b13-f3b3-08da949ce9af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +uY4lNvyLn6b2GqYLFkkQrINpoEEUvXsenWwGuA+43qIV0B+Geni7uf34eQi/2UsRaOOlNae5+EU5jgb6Szpxu+OeP8cuGlAGD8r0XlRaciQHHDOrtDcTLpUbsHNcg+9heRhp+kTRgj0Bzv1bQzHZhdfq9XVK0UesRZDeK5oAP7+khOulmKmQ3qQEGmeKmMpFN1kAUgJXQ6X0Mn/bIMxw0oKHPMQ7A3eMgb5913W0ez1KeNpDS0ITLBLfjBbDW6JntPfP3DBwLTfViym/cDOA732ZK4uoPRtun7fnN7ZsipOcUsPi42i2JEGHV9iCprWYG5Dv+kRCYkHu21eiBTP2ZE3IGQiH2gGohH4uKQtIHFZpf/iSlbVPtIOxSuZQCqa4y+RcxahohOq0FTJOUqPSCDx+sGcsqGGJRRwFlFPvhUCu1BQ7G4/0oE4VjR4QPu59WLhrw0wTxAK5GKMfySc/wneUYlm4D2U32O8qDULS6eKYZPQrOLpgTkZ0H1bl8eN3ZczdhOdGBdEvQbWpg+zKtVltIVW6QrKjBqUs+FNH2Rv8v70ln5Yh1SHCPlM6ktVGkS4kaM2RUt0GzVenYT5ScoE9Jr7GRpAQlsvnhWZJuJWh1vh/B0QkkrCdI8CIUPylooVMFjdG757dzuiRfmNaailxxlNqrhdYLMcLJRBssCIKsC1Q0qmgcuyHh0YmqBux+BEzn08EbbF3R/frkcGg2h82hsWKPhYbqVB0ieHDqI7sShcr8U1Uvsfqb3i64mCmbXhGTKDj0vDBeGOdIivgIt9u8gRB1ztZ1mXRfVuS1k=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(396003)(346002)(36840700001)(46966006)(40470700004)(8676002)(81166007)(82740400003)(70586007)(70206006)(86362001)(356005)(36860700001)(36756003)(47076005)(426003)(336012)(2616005)(26005)(107886003)(478600001)(41300700001)(4326008)(6636002)(16526019)(186003)(40460700003)(40480700001)(54906003)(37006003)(316002)(8936002)(82310400005)(2906002)(4744005)(5660300002)(6862004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 08:58:08.1528
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35e55790-f8dc-4b13-f3b3-08da949ce9af
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4880
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ido Schimmel <idosch@nvidia.com> writes:

> The hwstats debugfs files are only writeable, but they are created with
> read and write permissions, causing certain selftests to fail [1].
>
> Fix by creating the files with write permission only.
>
> [1]
>  # ./test_offload.py
>  Test destruction of generic XDP...
>  Traceback (most recent call last):
>    File "/home/idosch/code/linux/tools/testing/selftests/bpf/./test_offload.py", line 810, in <module>
>      simdev = NetdevSimDev()
>  [...]
>  Exception: Command failed: cat /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/hwstats/l3/disable_ifindex
>
>  cat: /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/hwstats/l3/disable_ifindex: Invalid argument
>
> Fixes: 1a6d7ae7d63c ("netdevsim: Introduce support for L3 offload xstats")
> Reported-by: Jie2x Zhou <jie2x.zhou@intel.com>
> Tested-by: Jie2x Zhou <jie2x.zhou@intel.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
