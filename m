Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A346F49E6
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjEBSsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 14:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjEBSsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 14:48:20 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D3E10C6
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 11:48:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXzeH39zVhLOU3sgt0//I0Z3S9HjFX7odXfJpNWzDpo51vYEpA6Sgee3HcLY9pwfrLg4ROC7tP6DjUb2FsiaGYybIWB+hZC5MptRrFoHp/QIQrJldPyU7aLshxSpOk2Od+mlopLuCvl3xzEYXbuz4HmzIi1U8GOb9B7iGDc7g9hRrXgGICbgOv0qDJyxuhhCMjYPIs5DVFELHWsR5S7xzo1ySZj7Nn0UK5b9lomKIk/mkqjLr3Cf/LMzg6IHCfnVaHjLscL8mtTEHP7h+xieO7hl8nILqRPoP/YECDRoEzMiwk9N2JK8Y5OZaqGx2z3U2RPirKW3heJRDKqwD/8P/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3/d7AG06gzXV4tyTSWg9Jmq0LflRO+iFh2CDtEhmBws=;
 b=YpZGGDc+j52HR7WOzpHrLfKWeiymK/Bf1Y5ypda1IFnnPz0h2nRzOvj+Yt06GypsAcNlfj11BB9TLmEXLPLXd2WQuNtnfO3JEQdvZvpJ+NGaaqQk4//DP7K9g8mfPb0S/Px5bKRa4ad/K6MMahbVXba0U55i0UXKecblCuxuw5Pa8ek6kQwiBy4WWd6ER6dkNY6Fj4PdIwUllG7/pFhpX0yb5mvQ0hkDr6iQsH+O3fjL7xbGUP9wFEmAgOpG7rmQuTaEHzOxIV+UJGq9gDhbRlfLip/vhwsAT4wL5Q50gUkiLLETPz/9Opm4qRtQ8zD+HWP7m4LMZXmw8VCtEQW8mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/d7AG06gzXV4tyTSWg9Jmq0LflRO+iFh2CDtEhmBws=;
 b=adYUeNwTgIDrZ2/vuaItTPCQ/4vLUFF/xV+3iVe13W//kJaiJcs7YZ/238ery1SrKyOQf7NXziTAjKQowCsx577JheDnpIBDCOtI6vrxcIVUGgKuoA40dLawtto6XrfCU0uL9uM/bABC+4hVNb/jM68zLFXFOx4VilBoRuS375E=
Received: from DM6PR11CA0039.namprd11.prod.outlook.com (2603:10b6:5:14c::16)
 by CH2PR12MB4117.namprd12.prod.outlook.com (2603:10b6:610:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 18:48:16 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::51) by DM6PR11CA0039.outlook.office365.com
 (2603:10b6:5:14c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30 via Frontend
 Transport; Tue, 2 May 2023 18:48:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.20 via Frontend Transport; Tue, 2 May 2023 18:48:16 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 2 May
 2023 13:48:14 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net] ionic: remove noise from ethtool rxnfc error msg
Date:   Tue, 2 May 2023 11:47:40 -0700
Message-ID: <20230502184740.22722-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT012:EE_|CH2PR12MB4117:EE_
X-MS-Office365-Filtering-Correlation-Id: a2c49ca7-c248-4cc1-dede-08db4b3dca64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /BKHIQoNB4NJkX/vIK5gkYGRoW/ogK9ijZIIGMUYmhhSxbM67NxmFfqDu4rSgcXiDFXQNl8I+40ACvlawwNQTmGBnGIdagPMThNRZYzzfvAZQTVAfadreWTqbOnrWVN06E1DRJYCazpEo2cCkU07EwOiD8xd7s7+YgHSMmUyk3Zc+JSPUYnEOJjCV2W6uxk5porDGHqZpjeHGXGKquLvM1eQZfcFmbpwFPJugJsmhX6+mu6FIiXfM14X5iWP39cFVauPLEn5itBVuSOdrrNXsbLWbDM6da4ai/xjIKEfQy1vAjE2QAy0qn6/11UgUyvmJWDaCSNnFyhAfqxKSc8VvXMrYTm1wSOPmlFqyXM4Sp/XsYqEeVTSUcanuvtnp72GclwVzV2jU1CfDK7jsNEztley6bVNlAdbkGmCIqiPkcJvGaAe6iPMz3D7rb7q5IZuLKX3jzr2JS2ahCpdnzqpNo7qpWsgDkSvnRdUQkSdS6O4jCDoXedMIGMzyGVc7Ci1w6hVk7lW9e/joEeYyoDXvTOZ2srlPWfZcvlG1m0PFHzcaxigMfCQws++1xk1Kqi4CWxTS9gy6cQpLXrFfXU5L6v+qu5TrQ/pRIn+LTAwCRXKDsjr7nI2ZwV2wHpBwzxA7Mim/jOZkVyPPq3CZP91b3f4dWPkwN0GoIkJ5h6Of3QPbOB3iCGn/0GFOm5MgaSKt/UdxqFkMGlD2f5g71UnR026gHmC7ynj3vAHObkP35o=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199021)(46966006)(36840700001)(40470700004)(36756003)(86362001)(110136005)(316002)(4326008)(54906003)(41300700001)(70206006)(70586007)(6666004)(478600001)(5660300002)(2906002)(40480700001)(8676002)(8936002)(4744005)(82310400005)(44832011)(426003)(82740400003)(81166007)(356005)(2616005)(16526019)(186003)(26005)(1076003)(36860700001)(336012)(83380400001)(47076005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 18:48:16.2972
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2c49ca7-c248-4cc1-dede-08db4b3dca64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4117
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that ethtool is calling into .get_rxnfc more often with
ETHTOOL_GRXCLSRLCNT which ionic doesn't know about.  We don't
need to log a message about it, just return not supported.

Fixes: aa3198819bea6 ("ionic: Add RSS support")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index cf33503468a3..9b2b96fa36af 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -794,7 +794,7 @@ static int ionic_get_rxnfc(struct net_device *netdev,
 		info->data = lif->nxqs;
 		break;
 	default:
-		netdev_err(netdev, "Command parameter %d is not supported\n",
+		netdev_dbg(netdev, "Command parameter %d is not supported\n",
 			   info->cmd);
 		err = -EOPNOTSUPP;
 	}
-- 
2.17.1

