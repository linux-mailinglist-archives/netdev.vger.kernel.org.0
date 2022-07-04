Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E88565E9C
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 22:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiGDUpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 16:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiGDUpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 16:45:41 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2057.outbound.protection.outlook.com [40.107.101.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5639D2630
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 13:45:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4/AJiYRnY8ASexmRVYUcmSV8lIQkTiKNKgtMMwH/RFDv1boCWRxhIDeDjwHhn9kgLoAPTZYkvMUJKRS3ng/5S+BtxQTmlbGZuvpJOqLjojlLTLQ3bjQzvgFGlMJ0ap6LOCLXGQoZBBsHtmUPPyVMrCjt3U9ywqqpAwEIbvSyBf40heKmacRyoRuHKJPg1wWljcvoou5bZVCYUcD+Bnp9XHyCt7eibxCmc1XI1qOTCOUdTTyYiP98tmmuKZeN71GUA8bV01AG3E06zRIXIDS+oMFMvrwcbLclZ6HP1jewQQiXPe6eCcJtkVkzYUjrc4P9+NGypzpg48jgxNrEbEaQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/+KBxE7GIioyul8xOUTp/69jPG0AHvQzVGvJH5Il+c=;
 b=WfujmhIrzn0PGGA/XDErXIRe6s4faR5yt9mBEQVZ5DbXB7EVwQCvSCyyOt76hLw8IauFCkUikwi4GdSfIYUbgZAo3uKAksnnvJFfM815F8YhmNfihoLC7ua58+kfMrhjh40h2ZDEPNAyM0MZm03DhEiIjB37aYjp/WnZrybG95nAdKACuCCTc6m5SAo8TbeR650wF5/WYgK4MHomGBt7DjXIOD4rsSsQ+7gm8JkiUb/rWYiIqDtZCCg/v/64DW+UwjWAFgbOiLAlnPSxKDXN4SgLx1maYnjJtQqWxW1G0BQ0C/aIifSO6wCFnQ+k5SfJCkVZ3Q0JAkXJs6IJ4+tRGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/+KBxE7GIioyul8xOUTp/69jPG0AHvQzVGvJH5Il+c=;
 b=i9Zt7H2yQhfX7fmbssIApOA77sUmfQnr0bONaIv2gfJrI7DeD+HtM8U/WtJ9hgXrwlpUUCXYfm5AKaxZ12eMQrQj/LrLf+j0PymiYc3k2YAQEQ3IQy+akCEoGNCGXA051OFgLacPrprGcST1RHZwr8tgYWar8bKTvJBN2zkI71zuqPxlzKR7/OFCUWROxWX42HpRiQr6F5FrRiWyligeGRmVfZpKbiP3bC+tCmHszzyQ05IvlLp8qikn3xe4IDmXGKXOxDab/rCvOJ+wft/i6d1z3vgiOSmYXmHv+xHNB5ewqe1hjUy/Fq94/pe/osxUYpe84GeifIzGtaL3TsLS8w==
Received: from MWHPR18CA0050.namprd18.prod.outlook.com (2603:10b6:300:39::12)
 by CH0PR12MB5204.namprd12.prod.outlook.com (2603:10b6:610:bb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 20:45:38 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:39:cafe::c4) by MWHPR18CA0050.outlook.office365.com
 (2603:10b6:300:39::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21 via Frontend
 Transport; Mon, 4 Jul 2022 20:45:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Mon, 4 Jul 2022 20:45:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 4 Jul
 2022 20:45:37 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 4 Jul 2022
 13:45:36 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Mon, 4 Jul
 2022 13:45:33 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <saeedm@nvidia.com>
CC:     <jianbol@nvidia.com>, <idosch@nvidia.com>,
        <xiyou.wangcong@gmail.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <netdev@vger.kernel.org>, <maord@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net 0/2] Fix police 'continue' action offload
Date:   Mon, 4 Jul 2022 22:44:03 +0200
Message-ID: <20220704204405.2563457-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 847474a6-cbde-498b-d3a2-08da5dfe26c4
X-MS-TrafficTypeDiagnostic: CH0PR12MB5204:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AWHrtC+p4Aof+jeDp++JqtFDJF1QQp2Qw+nExoDOzekOhPjSwTF1X2NQ31Aya17j5cCAYIefWxoI9yku3Nuh/rsq7ypOOHtI3uWCR6nIA1owaZOA8DlWOEUIEKg+tP+CL/zbWz853sA/FT1YFwRPcIlrkFUVw8G5s0FerGv0Ljr9Yv+oixaSc1V6KADHCBYpB8jZPxdcOLH62iW3jf/WHCAW6KQJ5bo2PvJwtShJyeJrqTc+6Wokbi9hNQVpF5Dc2YnUF68MoFEvoJL0LLiGeDSwCgILzcZYt+1COvm9OAzy09fJMuIDHHbUFdi7Mj8XDqmoz9rdnBVhisgd4djb8/7e+DH2l4AwrimHiIOXMEHEU6fh+NQf8oxPIwrLFUcNkmQYR2x/HzuRNmYvaLEP2Z25zWr115biIKnwxg4CCRLrPp7GEsfppYfCo+dRKIYaCvEeGfSson45OPuOQqSdD34JoR6M+LT4b0RAhPhRrlchLq6Mg9XBXqo6ie9J1P5K4RMLAChskqE6W0TTheSETM7sABxwJyhgGCltqVMWxnv6TlVKbC1u2VhDhLC4znx2dQkX1THeWJrfJzJTO030v4WvvZf2o7HuA3kOgCRCibSFWNVTeeMKP/3hKhKHrcO54+tO2T5FJl15kkxWZwkSb2hCH1ybdS4u6HAJhD7ojLvHca21aNIbYzWhtjy0kWuCH6L1teLcDPY/GnwrcVgAmeg2r7LX1fiZGVnIeZ/LfeD3W+Wf+t2qF6oGqpZg/3WJJ6RaxiS1nIQjsAfu7GEoht+eQoGiZRoNKw38MZSD98Q/FwFmj1rUYZSd3/fmk9izIDJFWau8JjgtZ5rODIjFvnJoP1/F68MfqBMPa6AXD1U=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(136003)(376002)(46966006)(36840700001)(40470700004)(478600001)(54906003)(6636002)(2906002)(36756003)(6666004)(110136005)(316002)(70586007)(8936002)(7696005)(70206006)(5660300002)(86362001)(4744005)(2616005)(4326008)(8676002)(356005)(36860700001)(26005)(81166007)(1076003)(107886003)(336012)(426003)(186003)(47076005)(83380400001)(82310400005)(40480700001)(41300700001)(82740400003)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 20:45:37.8762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 847474a6-cbde-498b-d3a2-08da5dfe26c4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5204
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TC act_police with 'continue' action had been supported by mlx5 matchall
classifier offload implementation for some time. However, 'continue' was
assumed implicitly and recently got broken in multiple places. Fix it in
both TC hardware offload validation code and mlx5 driver.

Vlad Buslov (2):
  net/sched: act_police: allow 'continue' action offload
  net/mlx5e: Fix matchall police parameters validation

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 13 ++++++-------
 include/net/flow_offload.h                      |  1 +
 net/sched/act_police.c                          |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.36.1

