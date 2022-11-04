Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33829619EA3
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiKDRZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiKDRZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:25:06 -0400
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D39F42F48;
        Fri,  4 Nov 2022 10:24:38 -0700 (PDT)
Received: from 104.47.11.176_.trendmicro.com (unknown [172.21.188.236])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 9DB9910000633;
        Fri,  4 Nov 2022 17:24:36 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1667582676.127000
X-TM-MAIL-UUID: c07fce66-e2f2-494b-b643-533fa3f1d375
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.176])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 1F4ED100010B7;
        Fri,  4 Nov 2022 17:24:36 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWiqZD9hYWwfdMeUnnUZZZW1tXnadU0ekQa1LMRsJM7Y+Glz3aw6LcVG++hxP5/iXlCwlbVO5i7EFVK0qc48rMlT+gi/pqYAdUrBpuPeQ9W+W8AYFMbx1pd7dIYDOiI3RXRI9Z7yQ/H7gdUVZuMP47Mts6M9acJ/y5/rENpb09bctloO5RYKdSDBXsV9z+QSt60pEt4ImbWQ/LBrcNgsLDTzbtfOmNhWh/W7Jv00uiU7qn5kXWrufjKHBGpET6OSA0UM1g0VX8OGr2635EzgQ0AsghCXOSI1xzRvFYQd9cw8LNj1pdXBuUVB0iAT2WVahtrh6gG5RWuee86eGOLe9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZpYqoea4Jv7WiheUn5w4tO4MXgzYIcW61fIfqK8mK4=;
 b=CnI+bA8QbsOG/2X3yQnK1LFrUYy+JRSKo7E8knjkl6ZbF4jLUfzBVAiHHBUFBaGAZMh/SFNiAmwdtw4YSKMCQaKP7T05tOS1EhrxtjlZ5EJadIfWWV55ielhMF1ni+hpii60Z/0mFJ6lSTZj2Pby6Kt/qti22O3Ez/7JbE0/tn9eKU/AAZEtFIelVh7HnETK9Oi+cgk5FEIM6GBkLc2ZzCySJt3B+XahLq5TO6LLLWgAqQChChncMQIwQ2m29SkAvtgYX6AWTuCh6CQSAj/2ku9Z4HE9hj1imrFnsxqKqBi7S20oFMDCZ1BKF/+brAKS59M2akh6xYG46enxYP+rLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.66.60.4) smtp.rcpttodomain=davemloft.net smtp.mailfrom=opensynergy.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=opensynergy.com;
 dkim=none (message not signed); arc=none
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.66.60.4)
 smtp.mailfrom=opensynergy.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=opensynergy.com;
Received-SPF: Pass (protection.outlook.com: domain of opensynergy.com
 designates 217.66.60.4 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.66.60.4; helo=SR-MAIL-03.open-synergy.com; pr=C
From:   Harald Mommer <Harald.Mommer@opensynergy.com>
To:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Harald Mommer <harald.mommer@opensynergy.com>,
        Harald Mommer <Harald.Mommer@opensynergy.com>
Subject: [RFC PATCH v2 2/2] can: virtio: Add virtio_can to MAINTAINERS file.
Date:   Fri,  4 Nov 2022 18:24:21 +0100
Message-Id: <20221104172421.8271-3-Harald.Mommer@opensynergy.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221104172421.8271-1-Harald.Mommer@opensynergy.com>
References: <20221104172421.8271-1-Harald.Mommer@opensynergy.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM6EUR05FT048:EE_|FR2P281MB1480:EE_
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: b37a73fb-24c0-4bfa-8fd3-08dabe8970d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1b91LlsAdZT/PTvnFeutfs4Jsvde3vHZTQn+NTEYi+qd3fPzq8MLnxGm8DczeAu0yBtCVP0ulE381Qo53rUIxBM4mv4aN3YnWgf+r45KsGgLlU76qWGb6wQCVQKfRszrNaJTm8/evAuJc3WiMSk02Kld4IHMuXymHxknZrIyPyb5q81oxOyIkt1NAzbzg4/wRryI7BFZqL58fFIdm3PCbqpw3jnz8mq45DGCe2SagFFMl2VrNZ28eY2SikC/XYgL8pOhqKpEUh0Sl11UeEe42ZDgdzy6nt/+4ZwzwfZf2LLM0EglCAvCWKBnJiWrz2SiRSu+9IMoC7l7wiWqI6XtH8TFlYaLOsgP4coiXjk0g+XK1NhjaSiWyLjQG1ye1l+130jBAbR4zailn7k3i90ywRNcXVwlSo/0/w29KRbOrHntLG3sBqy7QtlP1G8m4DdFtPh4fV2xOPXkHlZ44USxcnn3+6PH57ngo4WNwaRNsKKKLQqvVYSgsnhE316DJ/nmndB4q58ukD6IdF/MvPDBTvEdfT9D91qeOVBbZ63Cty4n+WpZCDtAvB01TDlHsy46SBJss72ZFKkcoOeIg3gmEoeBjmCOFywaLTcRA5EySKUV8p328aKYWSEQ6gfJlySr3v0TRdLfCuGctSZMl846u0czqYJjbFg/eQtt76hkN1RwWr/nWm4lk0Df/eB/KHGXQ1nuQNCmlirhL1UhMJ+hSSEieC6ha7F6X+C37Wd0IYAbM7OILb+NDnnRaZ9pr/qqlgg233bprUGU7L7nsYDKQA==
X-Forefront-Antispam-Report: CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(39830400003)(376002)(136003)(346002)(396003)(451199015)(36840700001)(46966006)(7416002)(336012)(5660300002)(186003)(1076003)(2616005)(478600001)(47076005)(26005)(42186006)(316002)(36756003)(107886003)(54906003)(40480700001)(8676002)(4326008)(70586007)(70206006)(41300700001)(8936002)(82310400005)(2906002)(36860700001)(86362001)(81166007)(83380400001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 17:24:33.8668
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b37a73fb-24c0-4bfa-8fd3-08dabe8970d9
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource: AM6EUR05FT048.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB1480
X-TM-AS-ERS: 104.47.11.176-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.0.1006-27244.001
X-TMASE-Result: 10-0.757300-4.000000
X-TMASE-MatchedRID: 4RK2gbhxGJOnnQ0nwnZDJLnHu4BcYSmtwTlc9CcHMZerwqxtE531VCzy
        bVqWyY2NvJSHCxH3pnSZmElRg36A9RBxp8+zDVacK1L6TVkdgzuyzcnjmIvqX1c/CedjlcvkM9B
        ACw3vR8HF+Jbfj1Z0dyudgPSw6RX/7O2kJKpKRcp+yskgwrfsC30tCKdnhB58FMkUvzgg/cWVHV
        xP1hp9BfVTBEcb2VRMjaPj0W1qn0Q7AFczfjr/7LOb5nUQ6M6s4TnyFDNU8mbX6Pg6yOl4aHNcG
        1dP75ywKY6EyLG+LCM=
X-TMASE-XGENCLOUD: a0b47f48-abe1-4be4-8422-97c03b833fb9-0-0-200-0
X-TM-Deliver-Signature: 89AEB2F255038E32A7611941B5459584
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1667582676;
        bh=PJXRTHkOhPhnUijtkWHMPzqtRhjmU6Lee+Q9bJH6h/4=; l=1597;
        h=From:To:Date;
        b=ensthVaPf40u+XlT7SGvnvy5ZR+zKYBLONJU1lhoslb5HNVBLpT3STqHTQwThGMLp
         Qbjfy6fUvmJ9mDRlcbYRfb8yitPZj/I7FaOOsGjgJnTGfAqCRrsKJKZ2uc7HOvorDL
         MIFg+9XfGJWLHGwrBLrW4ac6LDtWNvNXCKHH61jpXElak3WLuFXVXMEmSl3YaBXQ5k
         mtU86DSkIOWzdjHbBT7GVSo4SS5wTPPhROW2cE4/Seb0lcWsxSmj95dYTDe5tXKzYr
         cLEFqeu2JKY4riJXUVRO7L0EkRDUdw6l5ONmKwuPw7WICwfbApu6nPg/znnwysXeBf
         ZHYkyP5R5aEwA==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harald Mommer <harald.mommer@opensynergy.com>

Signed-off-by: Harald Mommer <Harald.Mommer@opensynergy.com>
---
 MAINTAINERS                  | 7 +++++++
 drivers/net/can/virtio_can.c | 6 ++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 379945f82a64..01b2738b7c16 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21692,6 +21692,13 @@ F:	drivers/vhost/scsi.c
 F:	include/uapi/linux/virtio_blk.h
 F:	include/uapi/linux/virtio_scsi.h
 
+VIRTIO CAN DRIVER
+M:	"Harald Mommer" <harald.mommer@opensynergy.com>
+L:	linux-can@vger.kernel.org
+S:	Maintained
+F:	drivers/net/can/virtio_can.c
+F:	include/uapi/linux/virtio_can.h
+
 VIRTIO CONSOLE DRIVER
 M:	Amit Shah <amit@kernel.org>
 L:	virtualization@lists.linux-foundation.org
diff --git a/drivers/net/can/virtio_can.c b/drivers/net/can/virtio_can.c
index 43cf1c9e4afd..0e87172bbddf 100644
--- a/drivers/net/can/virtio_can.c
+++ b/drivers/net/can/virtio_can.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * CAN bus driver for the Virtio CAN controller
- * Copyright (C) 2021 OpenSynergy GmbH
+ * Copyright (C) 2021-2022 OpenSynergy GmbH
  */
 
 #include <linux/atomic.h>
@@ -793,8 +793,6 @@ static void virtio_can_populate_vqs(struct virtio_device *vdev)
 	unsigned int idx;
 	int ret;
 
-	// TODO: Think again a moment if here locks already may be needed!
-
 	/* Fill RX queue */
 	vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
 	for (idx = 0u; idx < ARRAY_SIZE(priv->rpkt); idx++) {
-- 
2.17.1

