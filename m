Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F32B5E919E
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 10:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiIYIOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 04:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiIYIOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 04:14:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163089595
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 01:14:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9oleq5kfsyNOI83CLsaj1UfH3vJTbnSGB52dOg51XqXEjPuLo+JOWxFfBV5p2J2/Mj977YQFv5Am/DSgdUzpA7jP+k6q7jbD8h9JST/z+ir1hFzz9AMc3bNaDHccNguVciK/G6MS4ob3fyuyV3cfpZ5h+gnyCSsqFxJcCNG82j/xd/X1mfE+Y2UuXcYM6rwfRdvcQSHJ98kUymbbiwtQVbj+iMcgfRlAlETuHJlI+pcqlm/ArnuBU3lqxtfIdnKI6tZ4yvgCNNCGCVb8+gnaBmnkSYMANEwwMYi0poSBFFUm53rWmG40vPAnE9oFlDIy91BAX0wR1MsH7BWm4lJrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W++vUL4DWexwLZsl9ICld/37cUhvilIaSQvYcN/OAfw=;
 b=hVCMsWzarJ1sVbOAD33LRCAFKlY0Fx3iDheyysjnrrpzuVrkEw5ZA6ya9+owFZjSxDGL9WoAZr0gqY7lE6VKR1BltOdWLc/+OluEzzBU0kQ7DcA4TJHXHNESfU3R3lsVO0BQB2t7pMM1zFDj9FX5LfFceFSdwWraXw1dN9s222/f3tVIN2l5rmzwFeq5yEgaSVS87K8cPwTa93O9PW/0oINdC6PSd7ovc3q6Y4tTs1vH6smFJWnzBVsPoMkGigHvNGdQR3KDw1N0irqXKLmj2Tr8ykb2T+IPxMiTGobqlCNhupXMTNkUjR7RaufkhyAkDZxHnmeMpkY7rEHd/2t8VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W++vUL4DWexwLZsl9ICld/37cUhvilIaSQvYcN/OAfw=;
 b=KbL3Gmm3r9kktLE4Z7diXh1FnG7yUnaitLBDMSaGL6c1CcHwpJM6SzqrdqRwet8CGgIJFb+9nBWQ47XrfGFMoZpKBvLfg4ighXu32G2LHe5cgA0gvNvAqkz9Fj60xsjZjkNsPZxCUnsFJRmYt2fpr8pbBJVJTxbTI5c6oym+ClzWuavbSZMwp9Hi2OXhL+vVxeCvCfemV8J0OoDRFXopNqVLx2PP4AHSQcVEjnUMxfcVCioCwCn6M4lT7oTqyV6SZoUzoHY1ZGSEf+fg0FoXQCUNuAfbHIF6GNc6tUISdunyBIZ1dfzKU19uSvo41PD2cmNL5fQy0W4aBr+gVdAMhA==
Received: from MW4PR04CA0101.namprd04.prod.outlook.com (2603:10b6:303:83::16)
 by SN7PR12MB7371.namprd12.prod.outlook.com (2603:10b6:806:29a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Sun, 25 Sep
 2022 08:14:37 +0000
Received: from CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::d3) by MW4PR04CA0101.outlook.office365.com
 (2603:10b6:303:83::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24 via Frontend
 Transport; Sun, 25 Sep 2022 08:14:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT039.mail.protection.outlook.com (10.13.174.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.14 via Frontend Transport; Sun, 25 Sep 2022 08:14:36 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 25 Sep
 2022 01:14:27 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 25 Sep
 2022 01:14:26 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Sun, 25 Sep 2022 01:14:24 -0700
From:   Paul Blakey <paulb@nvidia.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net v2 0/2] net: Fix return value of qdisc ingress handling on success
Date:   Sun, 25 Sep 2022 11:14:20 +0300
Message-ID: <1664093662-32069-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT039:EE_|SN7PR12MB7371:EE_
X-MS-Office365-Filtering-Correlation-Id: 50d1e867-41c8-4f89-9740-08da9ecdfc81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O1pTWgeDxbhT4IlTdwuYF2MB7qmhOWdRJSyui2v/TaixQwZTa9Lwlg55m0AUD/4W8R1VU5uami76TACkNPT7GBsVk3Dyq1SxVxHELIdKKfaTcxW3LwWwVsNQYOGqzmxEhn/0nql9kyJJORunukCoqbL0onLrzCUZf81wQHJ/LdJYpO0IirWUDE2qshd5pAO1oOFnp800hxmA07bQC7PU6jOntT/ppfup/j/XvLY+WazCkKcXRmz4i9JwQ41RXnD4cecol1to/3wqfZNb+9VBLqWR3/iem/eicuZ13RvA1TVvHaBNGib/9NQleFDTP6L5ce3cPlIaJflkSs49CLHs+ZNq3GCy/LIG/Pz0Tn7j4xPPyf3zSH1tj4M2nfgukjGDD3+SMKJ1vGx8/2uaefuPuprj8uhQganx9GoAsHoc3JXFY9cPg2g6Q5df0Z76V2cCt0KtHNb0LrRlsj+QgbAvhEh6prbT//pNxmZPPZZp4euDehvNKFW1Zkt6C74nyZogwmlcnjq6Hitw3Hd98Xp5Rtl6be2ZJISzPB4HfTtPZUmLL1A0+NVQzk1cxFPxV/p5L3XY5ps8SWvkn8Iv3G1phyS9e6pCMX72o6Tq8IhWRjOFBY6IxS7+LfZhVDo4DIFBOqwtAoZ3NEN9neCenBXeYaipWAm4Gf33LFi9b9hrvP9MKgiqADg0IRcwkoD6xSTBGuZOj8HDhcur+4Lm1r9hdxNUScF3MDqRifIGzBeat90qOzKSkbsLpIfLatPpbKOMlI8rorIsytjqJZ5GX1ECxA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199015)(36840700001)(40470700004)(46966006)(316002)(36860700001)(6636002)(54906003)(110136005)(26005)(186003)(86362001)(336012)(4744005)(2616005)(8936002)(2906002)(70206006)(70586007)(4326008)(8676002)(6666004)(36756003)(5660300002)(41300700001)(426003)(47076005)(40460700003)(40480700001)(7636003)(82310400005)(82740400003)(356005)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2022 08:14:36.7244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d1e867-41c8-4f89-9740-08da9ecdfc81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7371
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix patch + self-test with the currently broken scenario.

v1->v2:
  Changed blamed commit
  Added self-test

Paul Blakey (2):
  net: Fix return value of qdisc ingress handling on success
  selftests: add selftest for chaining of tc ingress handling to egress

 net/core/dev.c                                |  3 +
 .../net/test_ingress_egress_chaining.sh       | 81 +++++++++++++++++++
 2 files changed, 84 insertions(+)
 create mode 100644 tools/testing/selftests/net/test_ingress_egress_chaining.sh

-- 
2.30.1

