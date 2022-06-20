Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B65551641
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 12:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbiFTKt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 06:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239937AbiFTKt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 06:49:58 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2041.outbound.protection.outlook.com [40.107.101.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA17B63A6;
        Mon, 20 Jun 2022 03:49:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B70mKYOjNrzwms3MIwj6p/LAs68yFjHvXAaLjG+5bOlh210XRQ64qIqQc9lzbo4bh9qDTbUE94uflygaolfjUQZwIJSUJgx86PPX5E6Oc5lAdtKt1sgXzk6QsYKB9yTPf1GKeBIXjHMG+mhbZFp0rcXKGcgKZU7h+caab81kVlCUnAuy37POJom1mKV44rq+oMu/gZclifhdUCZSIogOEw1Mq4vfGNizR/vpbGC+7j2BTYNkX4TCxO2ohOwlFq4e2T7kvp9T92k2yQX63MLcoenTey5dbzGj5NNQMlAv1FTTpT1J3St2M5riW/4XLH9XcI5JmHDusurTGHlOSuHhJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kofuTaaIlyd01+OB50cMz3kviNZieNe+S/eZTDk0nvY=;
 b=cb8C7Jcz2RpqRJuH5bXHq/FBVlXeDDca7UkX+Gtqim5xobWKt7+0kpPzu/USg8xMaStLlZ4t8uE9APyy2mhCX69Cfw9TdZFFJhwbPzRcxkD8RSIOe+rXx3eFi2q8fwRp6sjySaQAtbMQqV5XmbW0YKT2cde4DGTe4jY219w7bepjBIXqfOZJFXH7r5ANpbYoSQ1j8N1akwwCdYfH55Lpr8YH1LL6bcNlyk6xBgH171d8nrKTtWGf45DIwrb2Tf81IJNxgfGw48UoxBZAozerJDVpqlfp0a0KOl4SYcGLVtDchqAU7tW6VK0RRO6SVwmtTMzsQIE1TN29fbAq2MHEDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kofuTaaIlyd01+OB50cMz3kviNZieNe+S/eZTDk0nvY=;
 b=FTuDR56BunO0kK79L9Dl6dN7AUJzZAg5Wajy6W/umV2Zz0Jdj0b52VVapPqYhBfsGmpnsw+FIRiuotuAFO8emcPtWQbHQA30TBgWyWXGamVZ2m1qU/rGkkhPijwrdqYbK7qRpRgCEm0fIz9nNTFW3unJbsgBNm4JUCi5fuWh7PFo27GkU5kiSrwZZLhqZeowESnSlVeUt68w79oIe3gzVDMJ9mIBNVoOB6Wi3W1QzGSJ2A7ileBzmxy1wlqN5yaXjfzUlYeLA6X6L6godvT1kT1vSDTdATjjTv9umtpnh3TLXug2sHAYdWs3/w/DPrAokhVDwHnAeRV8EtZ24XCgZQ==
Received: from BN0PR08CA0002.namprd08.prod.outlook.com (2603:10b6:408:142::18)
 by CH2PR12MB4023.namprd12.prod.outlook.com (2603:10b6:610:14::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.13; Mon, 20 Jun
 2022 10:49:55 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::b8) by BN0PR08CA0002.outlook.office365.com
 (2603:10b6:408:142::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16 via Frontend
 Transport; Mon, 20 Jun 2022 10:49:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 10:49:54 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 20 Jun
 2022 10:49:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 20 Jun
 2022 03:49:50 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Mon, 20 Jun
 2022 03:49:47 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     <bpf@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: Enable config options needed for xdp_synproxy test
Date:   Mon, 20 Jun 2022 13:49:39 +0300
Message-ID: <20220620104939.4094104-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c46ebdbd-3470-4d8d-31c1-08da52aa9c94
X-MS-TrafficTypeDiagnostic: CH2PR12MB4023:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4023C12EF3719E179737D897DCB09@CH2PR12MB4023.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nmAityggwO8l2x8os25dVaYzIZAxOKiAgLgraItw/jZ3+S2Lq+enVbx3xPOTFlVmOQLfcIzWjhdJKvlMp4Cu3pFeSBVlZ8CcSgAZbF5CRUJ6A641whpsfzgRyYxjB2DkkM+VsgGytv0ZpD5Rk4XJVJicoSVL6yOXEKrzz2UVNuiPonJGwHgzUkTvDBkL3AxPVb/lKaY+w+H5cJn6aDkVzddg9lPtoG8buGQeLWYyJ2iYOBCp5pd4nNyLX/uMe0v62AVHUhRn8+4O7L3w5KyNGKHW7QLS2cxhjfGpw1/mCytHVb0PbRrX36rhkvKovuxt/v0AwrL0jjygkDHYZMftG83sndAs5179k33Axatw36UB5YGpCNZHIAcO1L5Rbjz7kGFVxhuztfL48rOtTTv79hHhZpuEc9f7gbt9ru9M+cd034UGtn5ZgE+F/fsppX0Wt+13b54y6VIEOshqNGItp3hP6mFMw+kxjreZVZBwNxMQdMcvoYJYQPfqO3IW66YTfyfCdk4bIwJW7Y0G4E2kNorICQ5kr5iV+Gm3M7Og1qtfA6dhi8MbTwiI5T/qrvkv6hozBhnayCm12D62/VKwRdmPzEjC00hpBdByc3tIk2O3gc8/7TOFF2rl7H51Au/I3azyYOufhHWs6A+dCSL6thhuc3gklQGW7mC2x5MWC+7mtjiCK8XaraDLRwzjJvpGjIMcJs6CoqDB2+2nTbmCGbB+HKiFH0dl4E8ocQSeaU/6LwE5yJOg/BGnC/GVaMscDf9Gy+MixG+2V8JXmVRh/y964elRqj9m7x6D8mFW1ww=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(376002)(46966006)(40470700004)(36840700001)(4744005)(2616005)(5660300002)(40460700003)(41300700001)(316002)(6666004)(81166007)(7696005)(2906002)(36860700001)(356005)(82740400003)(26005)(82310400005)(86362001)(336012)(40480700001)(426003)(70586007)(83380400001)(70206006)(8676002)(4326008)(36756003)(478600001)(47076005)(1076003)(8936002)(186003)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 10:49:54.9659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c46ebdbd-3470-4d8d-31c1-08da52aa9c94
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4023
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds the kernel config options needed to run the recently
added xdp_synproxy test. Users without these options will hit errors
like this:

test_synproxy:FAIL:iptables -t raw -I PREROUTING         -i tmp1 -p
tcp -m tcp --syn --dport 8080 -j CT --notrack unexpected error: 256
(errno 22)

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
---
 tools/testing/selftests/bpf/config | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 3b3edc0fc8a6..c05904d631ec 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -57,3 +57,9 @@ CONFIG_FPROBE=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_MPTCP=y
+CONFIG_NETFILTER_SYNPROXY=y
+CONFIG_NETFILTER_XT_TARGET_CT=y
+CONFIG_NETFILTER_XT_MATCH_STATE=y
+CONFIG_IP_NF_FILTER=y
+CONFIG_IP_NF_TARGET_SYNPROXY=y
+CONFIG_IP_NF_RAW=y
-- 
2.30.2

