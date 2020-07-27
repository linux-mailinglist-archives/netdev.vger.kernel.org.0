Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF8D22EB84
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgG0LyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:54:25 -0400
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:41664
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726873AbgG0LyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 07:54:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCQS7YlfVfrr1arHgOWzww3OdegzUQZRukq+S0+sMKmYpUVglAGsvuodgmvbOITw/NAGRVuAiKF+RwQWn4OvODBIA6lUsK0uL/Cl9uJZkuHDknPUvy5GbIDvHlX13y490cqt5hsIHe6YqDbym7GvZApEb9uFKL2AkbUMnjefa6evMJL7QufTQnhnnVZtgLOuCqDyWgzXE6OTBKra7M6nZex7D2bWCGwsPAAFOQluzrIhGJQmTrhF8Ti8BvoW91ZJzSfcqr8HUSNpSDLQ7tW3BJaG4h+JJwe91b1yOuH3GJxti8eliiAu4CyTcu1lOFZswjvYEvMRb7CB242TQ8HRmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfxbfa66fI1EsLGheoSMzvJ8Xmwk1+mgL/5j5n39qIc=;
 b=EVOVfsrbnme9CAF2eAKIVapGKcEWSCQcHvvu4ETnGmRRu6sb9+bFCKxj51mUrBbsKgx7ruL+AF0tLGi2YlAKcyjxgUQ5JZ8oBS0h56SIgYOxTsRc/eHXRhz/mv/UuFGAdS8ytDV74A8cAi1mpja6PBpfqHUtXkc6KZwEzNI9uBdxgBp8IlWhs+G7LRaJsZdyr2+aq0bPWDMXACWP51jfNYFFEp0xofIk82yCUAWZdzzY1KEF0NNWvcXUhFzkyNCQ8Q2WR494WUQ+4YY6/GDmw1iO8xuKI4kfyZtbws95ADLEatw5nOuB8QzXKP1GFwQVK0XpwOTmyfMNU2cE1XyguA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfxbfa66fI1EsLGheoSMzvJ8Xmwk1+mgL/5j5n39qIc=;
 b=Vc4D6Kyk/+4vovrOssVX3YjPtQwYXVHS3bI/EYQpjBp2p6McUcm+/GtvkbRi76d3fae26wDTQqWsg2qcR+rp6kYP8Iy3+PERs9JK0C3lhWbmwilJA0dHIHeDruMM2HBQtW5Z3OKrGAmJWW1ND5DP+ry9Mcxi7nlwoc9sRKZ/bBE=
Authentication-Results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB4647.namprd03.prod.outlook.com (2603:10b6:a03:12e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Mon, 27 Jul
 2020 11:54:21 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 11:54:21 +0000
Date:   Mon, 27 Jul 2020 19:51:42 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-nex 1/2] net: mvneta: fix comment about
 phylink_speed_down
Message-ID: <20200727195142.0452c064@xhacker.debian>
In-Reply-To: <20200727195012.4bcd069d@xhacker.debian>
References: <20200727195012.4bcd069d@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0044.jpnprd01.prod.outlook.com
 (2603:1096:404:28::32) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYAPR01CA0044.jpnprd01.prod.outlook.com (2603:1096:404:28::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Mon, 27 Jul 2020 11:54:19 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f50dd4dd-2539-4d11-b7b6-08d83223ccc0
X-MS-TrafficTypeDiagnostic: BYAPR03MB4647:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4647EC2BF0E20C9C852DBDA8ED720@BYAPR03MB4647.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AOtDjRuItZmS4rNzWPsHrGJFkEFO4J+7FWbIA3yfviNeDdrqyaKaxQ6QIUgWywh1yzg2qOYFeV3OA9KWMtgicpXkav56pUWapKC+yumW4ajCsK+byqvL+QCMQiTKdyTiIv7H4bmMr2DXhBSMU2BRTWGNalXZFzMTkdG2F+1saeVfv0GkiYzR5TNKHUz8YNprvV59CvhGl7BkDoIhc76iDFy4gfL0E2oUpGkGMepCfTa021ao8IaA7XxHXM8CwfwleYZ7jPOjoB9flRSxP6ogi47O+kDEFR2PXxBWOeoL1yxmUZGibUYDxg7apv4c2gVq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(396003)(376002)(346002)(366004)(478600001)(52116002)(6666004)(9686003)(66556008)(66476007)(66946007)(86362001)(7696005)(8936002)(4744005)(8676002)(83380400001)(5660300002)(2906002)(316002)(186003)(4326008)(1076003)(110136005)(16526019)(26005)(55016002)(6506007)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6o/W+t+tBkyv/Wm8Bq1djwbuhLqs7WYD4hUrnrYH7edfWYIOj7q5EPnj/X9ue/+81YoqTW6yVY0YUuCl3PGa/g+WuB01jyRGZkTei1zvxQkMJm4wrOnnFUFMbDoe909NPS/1Lle4i3mwJ4uA1HLcSbC4GrS4BMPhj48vd7SvPx0V3bt6373TzobBL8MD5K7dwXzjxcM5I4Jcv6/LBlxrjoMYAY4WzyUAdrwY/uKDcY9QVhkkwvad+DFQ75HjReGiTJSWAuukLTD2uclOqrpEg2cmgXMMZnT0+sRXtnudSzVnaka5XYM9LkOH2469LipZdHGNOwEk6J4Ei4pvtHn22l+zrwYaZoficSHrW4AEp7o45+zVnIaXi2JJ3lirg1ih3CTAhajwwyvpKCQI50L/BILVMy7qSfcx7e2o0rZDk4rHqhg3BhEZzBppq1vzoH6Il5144IwDJcMKdHKzBqt+fNjQKdtRkRXlMyR1BQfwnkA=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f50dd4dd-2539-4d11-b7b6-08d83223ccc0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3573.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 11:54:21.6289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n6DR+87bHPOSXVJB/KbkszMqc8R0w6P0SD0U9cadQWxSNe6+UNqQbUHqCo682TupfAiWGPWKJUbiDtzEiE1CTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4647
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mvneta has switched to phylink, so the comment should look
like "We may have called phylink_speed_down before".

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 2c9277e73cef..c9b6b0f85bb0 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3637,7 +3637,7 @@ static void mvneta_start_dev(struct mvneta_port *pp)
 
 	phylink_start(pp->phylink);
 
-	/* We may have called phy_speed_down before */
+	/* We may have called phylink_speed_down before */
 	phylink_speed_up(pp->phylink);
 
 	netif_tx_start_all_queues(pp->dev);
-- 
2.28.0.rc0

