Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED11621A79
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbiKHR0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbiKHR0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:26:17 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290E8101CF
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:26:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FSCE1J6jlWibBFCGse3b1kAxJuJ1fBhNbQC805nQiObS5xFU+0SOgwJIgvbR7oSP8vFRx/l7ADzwTRJzHoDhi8xS3SMYOUYDVhQVNhMFNioL7z8OO51+M4qaBK80DgkX6gFA+wK5ZyobZB6wVk5zJdBGuUel/bQotr7o8fB2FxIqfdzjEu4zL9s6DNgL3rfMTwBZ7/OnRCzHiv4uyvJh2dL7B6fYCq0ZQaV+NxwtitImG+ZiZ4uyzsw9wqjMFpa4McUW6FchXJCPHpENtWDULAr2Q8Mt8tRrBNo1A0hv36DVvtLNv1YUIPKriesOG5aANsRPNgBzyKHESwY4hUK+GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LVbmqEiWJSf9p6Kzb5lMVPKLQJ+Ow0aypIgqYUfptbM=;
 b=Ea1pZCzCvCStVV5vQfpYxAnF6p2EXp1YehSunTwRitWI12WDvFBmnzDxEnkDCP0Z7tzkS0g1yOzKuJWRlAQuUTPI955DnCgCNJQOou5dhsuHXr59fPet1TKWqvnK2IEJ/tAtaegNcEtNNmtrmqPcDRu/9onqJZb80CVKwOJDS501p5PK7eUD7pAnAtwZPdI6hpsb5LkQixggBQsW0EYzW5bnE1gE7mgU+Y1Ev1xo8tjIzYzfusq02U3rsd6hHgscalf752U09vDxEWvS8plTbdv4RxKvd+1nbfZJAsOsAFIA8La+NsVq5HdqnjL4of1zSnjvT65XmLVsLDr5R91TKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LVbmqEiWJSf9p6Kzb5lMVPKLQJ+Ow0aypIgqYUfptbM=;
 b=IRN1wXJGsaJg/G6g8i9VqKLaSgXYak7cCmhRlBTxBvoMRT/C1G0ra6gXXUugIVxj1Z7Jz6HbvyaNlviqdjqavfccxsluAvts+fPGuH6z6I2XS33xEvBF+YbLXinf/SF+4qOs1wQOnnjcyIt7APGSXX45KdOr/yEYRo3LruGHN0E=
Received: from MW4PR04CA0291.namprd04.prod.outlook.com (2603:10b6:303:89::26)
 by MW4PR12MB6801.namprd12.prod.outlook.com (2603:10b6:303:1e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 17:26:12 +0000
Received: from CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::3b) by MW4PR04CA0291.outlook.office365.com
 (2603:10b6:303:89::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Tue, 8 Nov 2022 17:26:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT077.mail.protection.outlook.com (10.13.175.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Tue, 8 Nov 2022 17:26:11 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 11:26:11 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 09:26:10 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 8 Nov 2022 11:26:09 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 00/11] sfc: TC offload counters
Date:   Tue, 8 Nov 2022 17:24:41 +0000
Message-ID: <cover.1667923490.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT077:EE_|MW4PR12MB6801:EE_
X-MS-Office365-Filtering-Correlation-Id: c4c9ab64-0abb-4a80-a3c8-08dac1ae54ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2xyghUpMVK285pemy082Md6MwO5DWe/XmnfE5qEk/U22yfaR3j+G08ozLK87WjKOAyi0ZCMdv+ruuiU+soD0VVRaLvV014ImiCJTgCegGdZsvZ2bFfSLXh0I0nmSuMdElxoLEX9hfnO0J62YKIissmHMBsNyCyGCmCu3V+tcEP8a156cPaWb7E/q9VphA/63a7Y8lye+hWPJXUFTyfEsU5HbrZ0q6m8tNnPNnJW96V4bTypXyQer1cfKZogPgyI1n6V4dgaCtSTnPvM8F+b75bQ/IBqr/wH46rWLceE2SjWT1guxDoU5mD6ZFmAmCTOWmAKQ1CnUglKMg3y4kFMKzT5RlEFMpt7csut+XkWuxLUwCgEMzKi3WcHSXVb/qeqmfW4Fkn2x7V4qvP/sWqaChjJ9sjIW1buIniao1hOjRYZTioIQ+X26v5AgiHEApsOcPUxKNFWs/FXXlbxAUr9ol86UUFlycIqW6FpPJb4ZRZlBxNihycENsTydvc+b21mTh4+4k5N84LXYLPp5uRZ+VFWoI8aYpzf4xJnWJvr/IH3OHmWuBiPooIaGaFiPsM/VUSQbMtev6UPJxl2NbOXC4waRj/oGtVGhs0zbTLb5Zhc/QfayG0OJ+8E6fBkRKAxnLM5JQEsIWn5bF4G3YcIMuRdyEqqqKtRX5sATVWPcg8y2HMeE9xOq5AsJMdq9nbn0ylExy4qRvgV6Jwswz+eDGDABwpobBu/VSEUyYvH/xC8x8WFLwRlcTDVUcyEtetdSgVBBcmSfrMw2qb2crhhqdIHLTW1XKDFdD+nUcPt0lqU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(451199015)(40470700004)(36840700001)(46966006)(83380400001)(426003)(47076005)(336012)(82740400003)(55446002)(356005)(86362001)(36860700001)(186003)(2876002)(2906002)(41300700001)(81166007)(8936002)(82310400005)(4326008)(40480700001)(316002)(478600001)(6666004)(9686003)(26005)(40460700003)(70206006)(70586007)(5660300002)(110136005)(54906003)(6636002)(8676002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:26:11.8180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4c9ab64-0abb-4a80-a3c8-08dac1ae54ee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6801
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

EF100 hardware supports attaching counters to action-sets in the MAE.
Use these counters to implement stats for TC flower offload.

The counters are delivered to the host over a special hardware RX queue
 which should only ever receive counter update messages, not 'real'
 network packets.

Edward Cree (11):
  sfc: add ability for an RXQ to grant credits on refill
  sfc: add start and stop methods to channels
  sfc: add ability for extra channels to receive raw RX buffers
  sfc: add ef100 MAE counter support functions
  sfc: add extra RX channel to receive MAE counter updates on ef100
  sfc: add hashtables for MAE counters and counter ID mappings
  sfc: add functions to allocate/free MAE counters
  sfc: accumulate MAE counter values from update packets
  sfc: attach an MAE counter to TC actions that need it
  sfc: validate MAE action order
  sfc: implement counters readout to TC stats

 drivers/net/ethernet/sfc/Makefile             |   2 +-
 drivers/net/ethernet/sfc/ef100_rx.c           |  21 +-
 drivers/net/ethernet/sfc/efx_channels.c       |   9 +-
 drivers/net/ethernet/sfc/mae.c                | 170 +++++-
 drivers/net/ethernet/sfc/mae.h                |   7 +
 drivers/net/ethernet/sfc/mae_counter_format.h |  73 +++
 drivers/net/ethernet/sfc/mcdi.h               |   5 +
 drivers/net/ethernet/sfc/net_driver.h         |  17 +-
 drivers/net/ethernet/sfc/rx_common.c          |   3 +
 drivers/net/ethernet/sfc/tc.c                 | 122 +++++
 drivers/net/ethernet/sfc/tc.h                 |  16 +
 drivers/net/ethernet/sfc/tc_counters.c        | 501 ++++++++++++++++++
 drivers/net/ethernet/sfc/tc_counters.h        |  59 +++
 13 files changed, 997 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/mae_counter_format.h
 create mode 100644 drivers/net/ethernet/sfc/tc_counters.c
 create mode 100644 drivers/net/ethernet/sfc/tc_counters.h

