Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BFA6BEB18
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjCQOZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjCQOZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:25:10 -0400
X-Greylist: delayed 1983 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Mar 2023 07:25:08 PDT
Received: from outbound-ip23a.ess.barracuda.com (outbound-ip23a.ess.barracuda.com [209.222.82.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5C43D0B3
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 07:25:08 -0700 (PDT)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169]) by mx-outbound42-42.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 17 Mar 2023 14:25:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CV+gCluvoYdzsg4tLao2X8Ib0zlg1lzR+CBR2YIx358fdVarc/0tMJKurnfXAYMHsec8C86g3E6DG3EHfKIjhA20S2n+m19xRBIgWfh9UmfVuE0vcOrYt+79jzVABFZ7ovsrvP67i8yPwroCjRJwBZoF8t40P9BNJ/X1vLucddgqzwozCgG6E6gxE+bu3QZT61f8wdk7+cKSPwAZ+D3GN9yTVDkwgbelF6o2ISyuqkEe5CHERJ2ufi91M7fDeAao3jWB2Y9nolneFvt3NOKIcUaSxn43KYp0yVR9OXZ0lJG2Vy3w+MgdKh4SbMC2pybtp7iRCrlyjGvsiyo3jprfoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIRlrXPvrslbnCWDn4OVbLG+d6QdYvk5i3t99g/n9B4=;
 b=MN3F8YmYXi8Vt6K28KXv38TE35YGRA/BL/bnJQYs0nVM1KsW85RBdO65a9ONlKmkxWElYjDCyp1g9XFrG0xjIJmA0Np30tvl2/uxankhOON6Ta3fXlKVsA8TCCoWNckcwZs6C0an+PJSW9hASrgMPPAslbVtKKWMSlIG3N0idpGG9VfV824p3rxFcxwPpACGU6mCcVx3naDvTqCZKTD0vEv8N1r5LoyFzM0o083CbZXiDDq398sxf/FSfTrbQRucmaRQKaCRF27lItwU+s+0ZVr2DT+A7hZ9O0TAp12jWQLKLIU2jurfO683KN5ihdZ+scrgVHiAM2oVhCnWYEO15g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 198.51.192.30) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=digi.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject header.from=digi.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZIRlrXPvrslbnCWDn4OVbLG+d6QdYvk5i3t99g/n9B4=;
 b=WSi2ux5XHR+1w3+/wbGGmReY2QtCUlnFDbEu8VRb8fE2QxXraTcSSSQqoM0MvjOOtAregfyQQPsUdIf996ykBwBGL1Q1sVYMUUCDFNcCu7xZa4fm0ErZQ5QcDQWer55FUW4IvNZgiLUKCovFx9XUNd9dzMKsSdA6nkyf5fRQ6ZCusnsiNJSYTdjdPfrMFKoCvCoqgJmkEq//L2a3PCwm6c9zmV/kqy3TlAj45fhgrWZ0pcWb0vT51JQUrYdq2cmf/62Lfxln0l0/S1IY3LoErNiLvMBT6n3CMD5uB4atHmnFOcBDUqYOKN95UC7K6/l1wtIdkNVpwwe8sUS65uT35Q==
Received: from BN9PR03CA0617.namprd03.prod.outlook.com (2603:10b6:408:106::22)
 by PH8PR10MB6480.namprd10.prod.outlook.com (2603:10b6:510:22c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 12:17:01 +0000
Received: from BN7NAM10FT028.eop-nam10.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::ce) by BN9PR03CA0617.outlook.office365.com
 (2603:10b6:408:106::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33 via Frontend
 Transport; Fri, 17 Mar 2023 12:17:01 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 198.51.192.30) smtp.mailfrom=digi.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=digi.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 digi.com discourages use of 198.51.192.30 as permitted sender)
Received: from HPK-VMS-XCH01.digi.com (198.51.192.30) by
 BN7NAM10FT028.mail.protection.outlook.com (10.13.156.237) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.20 via Frontend Transport; Fri, 17 Mar 2023 12:17:00 +0000
Received: from LOG-CLN-ABUZARRA3.digi.com (172.26.106.18) by
 HPK-VMS-XCH01.digi.com (10.10.8.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.6; Fri, 17 Mar 2023 07:16:58 -0500
From:   <arturo.buzarra@digi.com>
To:     <netdev@vger.kernel.org>
Subject: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
Date:   Fri, 17 Mar 2023 13:16:46 +0100
Message-ID: <20230317121646.19616-1-arturo.buzarra@digi.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.26.106.18]
X-ClientProxiedBy: HPK-VMS-XCH01.digi.com (10.10.8.195) To
 HPK-VMS-XCH01.digi.com (10.10.8.195)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7NAM10FT028:EE_|PH8PR10MB6480:EE_
X-MS-Office365-Filtering-Correlation-Id: a229b9fd-e169-4942-1b5e-08db26e18294
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ZvX12d7mATZQIszUPjcSEBoh0luSbJkdybpzeuScpijWUUxfzDvnsFvV1LaMDJsqnVJaILXDguXeK7RRy8uaeRRY+8RpOEjgSJqlc9MZoQVjFB+zcqzMbVOQUhuahbBiSehEcy45XYQHlVn9EWkJg1GooObH2u270yQj+3tilAP43EE2EGXQEpgylAj12eD9Mmwt+30jZAqOlnMDpsNAvh4jENxPROmC4CApBECH53/WfYK1lgGvL0nJlVY+edD0SodpuV+YzEOExsIj7ir6xemqieER0gqSNyORNhMdXraT/1vn6i7ahKS/OlrxJb1NXFTK+s6m9bRgN1vBpku267fmfE8A+skbAZuZiYtv3yExr2QISW6tgMiZGTAbYahepXyhpHcRCzFvKvTnBnBhsOaD7+2/Aa3LkWnf+Ehgru3EU0icMwVbc+8vMH7YLX/liuLjB31R8JzVFChxQorpAh80RmkDChUchbiFGIsr05vEFBNeKuX3FbK2A8eBLJbZBlID/hSF0Ju7FPlsq0NOgmfWP6zh0xY0HbVuq23dS6PNJ3U+SLlLCvLqs+0hTDqlaypeIvVEjyvNR1swdxU7hBvcM5N6yqUqlw9ZgTO6+HIFWQxYMdc+0YsXnVp74vEyzkYq0U0a9cO+a5l99nPZUWZ7/58gu9CGYvW2E2oDeTx7hq+45Q6YuGQ9HePDMjxVJvel66w8hC3O6d59FJLrQ==
X-Forefront-Antispam-Report: CIP:198.51.192.30;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:HPK-VMS-XCH01.digi.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(39850400004)(346002)(451199018)(46966006)(36840700001)(36756003)(5660300002)(83380400001)(16526019)(426003)(82310400005)(47076005)(478600001)(40480700001)(186003)(6666004)(7696005)(2616005)(336012)(26005)(1076003)(70586007)(356005)(70206006)(316002)(8676002)(41300700001)(36860700001)(8936002)(86362001)(6916009)(2876002)(82740400003)(81166007)(2906002)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 12:17:00.2517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a229b9fd-e169-4942-1b5e-08db26e18294
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=abb4cdb7-1b7e-483e-a143-7ebfd1184b9e;Ip=[198.51.192.30];Helo=[HPK-VMS-XCH01.digi.com]
X-MS-Exchange-CrossTenant-AuthSource: BN7NAM10FT028.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6480
X-BESS-ID: 1679063106-110794-5519-231-1
X-BESS-VER: 2019.1_20230310.1716
X-BESS-Apparent-Source-IP: 104.47.56.169
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaGZhZAVgZQMDnVOMnA0MzU3M
        goKTXJ3NTSzMQi1TjNMDXRLNHUONlQqTYWALAoaVNBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.246857 [from 
        cloudscan12-52.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
        0.00 NO_REAL_NAME           HEADER: From: does not include a real name 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, NO_REAL_NAME
X-BESS-BRTS-Status: 1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arturo Buzarra <arturo.buzarra@digi.com>

A PHY driver can dynamically determine the devices features, but in some
circunstances, the PHY is not yet ready and the read capabilities does not fail
but returns an undefined value, so incorrect capabilities are assumed and the
initialization process fails. This commit postpones the PHY probe to ensure the
PHY is accessible.

Signed-off-by: Arturo Buzarra <arturo.buzarra@digi.com>
---
 drivers/net/phy/phy_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1785f1cead97..f8c31e741936 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2628,10 +2628,14 @@ int genphy_read_abilities(struct phy_device *phydev)
 			       phydev->supported);
 
 	val = phy_read(phydev, MII_BMSR);
 	if (val < 0)
 		return val;
+	if (val == 0x0000 || val == 0xffff) {
+		phydev_err(phydev, "PHY is not accessible\n");
+		return -EPROBE_DEFER;
+	}
 
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported,
 			 val & BMSR_ANEGCAPABLE);
 
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, phydev->supported,
