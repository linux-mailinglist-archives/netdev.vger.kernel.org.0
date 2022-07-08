Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908EF56BF8A
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238717AbiGHSOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238770AbiGHSN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:13:58 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20112.outbound.protection.outlook.com [40.107.2.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E672F38B;
        Fri,  8 Jul 2022 11:13:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jS0j1puwOm6CWBAXptdRFluqAEr6gnqh8ivy69Ie+4OOSvO8K+JXM4DH72bNqtbOHR7sfybhB71kdJhyRdkkNH7z/dYkD3PHFZr7D5OUk4B7gQK6WiQXId91ZkuFHXMcoRgqmLtaShCkCsLT8k8jEyBNp6mydFh2pgI9kLKc4o8kxYyyU96HP6l9R9jCBYeVQUxrRNMiOplJChZOaCRfdELWN1ulWuVp7ppEr4OaLN7Uo7qnxA2sGd/o/2rLcwojzi0uNqJIuel+H8Nk8YBmmi7iLTzFjFNVFUTii4+RaqAMjBgXkUCIEC5JKvGU0mjn2nrN5KP6nBgyhKEO09AiLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KyfcjNMaO074Z9iej/qtxIghLMYz7YYj0PTbLR1XhhI=;
 b=Im9OEfE1OSPpLqv9iFGuv0ExVe9S9guBiD+wvtSQdGdxQ5kTMfZCidATj2ddRukkw4pPbvKu8Tea+iWFsoS38CAwmeTgNUnbTgO0Iz9P+gEfQvbVSEjx9mrcMBhwy48BIcplqTrr6OuAfKT2rPDG1bIDFEtQm3TPmk3HfW4wowV5Os0xTLN4yeO94ce/zO8c9nLkPJqbwV0/8u/bQdqQEMaEDQ5hhz9TwDP5lv9CMTimo3QLtkHoHepXF1VhczvDuSR+SZCfPdO1FmytkHwvBOt/6CTbmZ6yagA7qGRLWT9BJau/AqclWrNUcJLhFyhg5kYQIP0f1R3pt/MaiIJewA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KyfcjNMaO074Z9iej/qtxIghLMYz7YYj0PTbLR1XhhI=;
 b=RpfAdL51nD7Vkb/7GJIGEL1NBEgCBUuwGerb8k+nT0AAmP7vIlluy0OgDZ4OUv2lW34+6BSkjHBhS2GZL97cJQlRqwxF04I0JG8yih+gwK85ubrYcb+1wquGiEimdMOv0IN+y7Qces5iA3PtXRUI4tRu6NikbnAhXQ7vi9hmgD4=
Received: from DB6PR0601CA0024.eurprd06.prod.outlook.com (2603:10a6:4:7b::34)
 by AS8PR03MB6805.eurprd03.prod.outlook.com (2603:10a6:20b:29b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Fri, 8 Jul
 2022 18:13:55 +0000
Received: from DB8EUR06FT020.eop-eur06.prod.protection.outlook.com
 (2603:10a6:4:7b:cafe::84) by DB6PR0601CA0024.outlook.office365.com
 (2603:10a6:4:7b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16 via Frontend
 Transport; Fri, 8 Jul 2022 18:13:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (217.86.141.140) by
 DB8EUR06FT020.mail.protection.outlook.com (10.233.253.6) with Microsoft SMTP
 Server id 15.20.5417.15 via Frontend Transport; Fri, 8 Jul 2022 18:13:54
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id BCBB47C162F;
        Fri,  8 Jul 2022 20:13:54 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 7014C2E01E3; Fri,  8 Jul 2022 20:13:54 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 2/6] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT event (1)
Date:   Fri,  8 Jul 2022 20:12:33 +0200
Message-Id: <20220708181235.4104943-3-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
References: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 4a758cd8-76eb-4bfc-4640-08da610d9eab
X-MS-TrafficTypeDiagnostic: AS8PR03MB6805:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 11x27+snP6htArvFo6W6nxbyvZxpGHTWFxpka03/A4vVE0PBaT1dUBmfNoK1fYf6KXnxDZxysFU1enW8vOuex+B4ZPpJOAzM35TyMrz2IQm21936mpefVrdINtkAelduAS/4tMrZquHFvn/1AwXfaXgfSxXjkPkv+TeRoUoKUxumefS0uu+oN2C72QKq8QklfbvQ8hZez/WLtxA9X/MTOVF7I07CR4mZVm701OY75h6Ll4yv5WrexkE+ba32VreA+r75TVyD67+vWx2Tvfb2Zg2SEUs+as+wVfZ+K5TQmlXe1hOWIMCxxJn4FsZKENoJKkT4F/fOBBpM2j6nGrC7TVdHONw+gLvdi5BdZinCtLS4LPUHLocYy26UxkvA59xD1A0TSovjjWKybt4jafD56Bcdv4MgW/eukY9aTGtPzu4kZG2NZxNee2Iqj0BinI8fBl2C8PrX0nSdIvtNkJjc/zz/psiQCKRUmqFNaLnMwUF0d17CNJxsV/ZUpqr6+UThOYyhSO+b8uApfuUyE3mpK9TWLo7PjEFEpr2J+/5TRzekKd5KedFEhHcsvj6Z3mJLRwadZ8rzVUMkAvn89WSxwfBM2xfg8M8qccTV6nokXPW4BIReT9GZOlXJ+iqeExfe1sNKbDgo//Gs8MlcsUA1WbMMKiUuspMnMDcqM0q1Fp3WEhE8W+/DUjhIBedhVoLoueEOxjtqvIn+6qz4Ujt1ipic+nqKFodRhGtcGVG5Ffjh1+R480kJKCMVgmGrzxfC8/PA0dGUxz4oPShi5Xw9y2LnmpXDYjw5mMjhzdQk4X0=
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(376002)(39830400003)(36840700001)(46966006)(83380400001)(1076003)(186003)(5660300002)(2616005)(356005)(2906002)(47076005)(4744005)(36860700001)(44832011)(8936002)(40480700001)(36756003)(336012)(42186006)(54906003)(478600001)(41300700001)(6666004)(4326008)(26005)(86362001)(82310400005)(81166007)(8676002)(70586007)(6266002)(316002)(110136005)(70206006);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 18:13:54.9746
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a758cd8-76eb-4bfc-4640-08da610d9eab
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT020.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6805
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Always report CAN_ERR_PROT | CAN_ERR_BUSERROR if ESD_EV_CAN_ERROR_EXT
and ecc != 0. Before we missed those EVENTs when state was unequal to
priv->old_state

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 0b907bc54b70..e14f08d30b0b 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -274,12 +274,15 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 				rxerr = 0;
 				break;
 			}
-		} else {
+		}
+
+		if (ecc) {
 			priv->can.can_stats.bus_error++;
 			stats->rx_errors++;
 
 			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
+			/* Store error in CAN protocol (type) in data[2] */
 			switch (ecc & SJA1000_ECC_MASK) {
 			case SJA1000_ECC_BIT:
 				cf->data[2] |= CAN_ERR_PROT_BIT;
-- 
2.25.1

