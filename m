Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50E62A8114
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 15:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731013AbgKEOiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 09:38:01 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:51474 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727275AbgKEOiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 09:38:00 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A5Eb9L2032052;
        Thu, 5 Nov 2020 06:37:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=1ukUwmtpisJoLAUUtyAtMqP3F81avfCPKuuWB3oC+Jk=;
 b=uB3Q/3nBBxPfsvic1lRUEbH6bgwL+dGaEOQ8tHpo2ibAcVM9sKicH/kP1H16O2AGGpQF
 UWhkvP7Gd7R8P8ixHP5QMjCZaCIKPUD3XZde0j4JF4HcvR0sZg8aQoarMngFxRIHFepi
 hE0h7X9Tx1SHh70+Oyn879Ny7XWQLzWgZXQb2Pv1EhTxriuOLjwq9HABtbmB04f5RBnX
 QSDxyZdLqZrugbFuNkVxfZaUM7x11vqfQHx/NJMTAhXUpWxdu8MaIzFAyGDsOdw6XNAL
 mOwnlfUh7RWPhRaRB9u0haX7KZbs5J49WnV8GjeX/qpN9Fyi8xCVYWmfPjmoI5Ixss2p oA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-0014ca01.pphosted.com with ESMTP id 34h4fvn78f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 06:37:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ST7jg+0CeDzpfC1NZbDZMOXIeQdloEyyvFp2rpOJ2MUXLsukGsbT3QuZX3gjECAU657wLecGYSYe1PgJ8azGQtjsYHaurp9qUOkIifNvC2VefP8fqG+37I0CzgJoISBy0DPzR/nqBWfqKZHTG8+tFVFok+lSs7wuUJkxwpB+gEWf41Ip9w2XBOENJUWTR1/UUNH8/RXQtfbefKV8H/q/gl8apSF+AgrPxA831+gPcG23MI7duXAynWlDI2C42DJK4xy61hKo9CN2Q65A5Q9WzypYLDWBCmtl/Wd6RJrkAfJfmUQetW1E/3LB0XybV0aD2RZifsLaaEbwWntI88VrNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ukUwmtpisJoLAUUtyAtMqP3F81avfCPKuuWB3oC+Jk=;
 b=HtMmIIKVGu7H+e91lUo9bcSbJLLKuxd5NP6XRY7fLBNhaW7JCulrOzl5vjWcqOaNqpr723+20ps0y3MpKCk8kbW2S8fZZuT7rYztVxr2sPW1iZYCY36i7B7MN9LV2uW2PoGu3bXsc+Tb1GCK0olWtOIJcVGa5K6ZtbEdZ1zpSA6wj2mkDFF25ZtcurA/Vj9cv8q95HFmkl61cpqmqfrd4aqhlm59BsHupQv0XxOA2NDhGiDVqknPSHu8xpBuqi/mVUVWq0LdjdPbogOD1Bm+lcu5fq56H5kfjReN5qwdn0vFawEqr7LVia83kXnssfr0l2WhvMRulfn0IkwVhMYPTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.147) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ukUwmtpisJoLAUUtyAtMqP3F81avfCPKuuWB3oC+Jk=;
 b=dEV/SV5ZbuMI8eSMAO/87hxOgbcO/PIsAu2vsYO62ds8dzjwesron/Wk47/IPryTtKhQjAtVh6RwvUSAZ1GXRCZEw1E6X4gY+cBJjzjX94y1/PTceIROiDFkUVU16DNU38QJMU5sBvUNr2xDKK7TfJSZOZ5TFfuTblYcnF4wzAg=
Received: from DM5PR21CA0030.namprd21.prod.outlook.com (2603:10b6:3:ed::16) by
 DM6PR07MB5403.namprd07.prod.outlook.com (2603:10b6:5:28::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.27; Thu, 5 Nov 2020 14:37:33 +0000
Received: from DM6NAM12FT016.eop-nam12.prod.protection.outlook.com
 (2603:10b6:3:ed:cafe::e5) by DM5PR21CA0030.outlook.office365.com
 (2603:10b6:3:ed::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.6 via Frontend
 Transport; Thu, 5 Nov 2020 14:37:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.147)
 smtp.mailfrom=cadence.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.147 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.147; helo=sjmaillnx1.cadence.com;
Received: from sjmaillnx1.cadence.com (158.140.1.147) by
 DM6NAM12FT016.mail.protection.outlook.com (10.13.178.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.7 via Frontend Transport; Thu, 5 Nov 2020 14:37:33 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 0A5EbbCE020225
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 5 Nov 2020 06:37:38 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Thu, 5 Nov 2020 15:37:27 +0100
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 5 Nov 2020 15:37:27 +0100
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id 0A5EbRH4005697;
        Thu, 5 Nov 2020 15:37:27 +0100
Received: (from pthombar@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id 0A5EbKlx005690;
        Thu, 5 Nov 2020 15:37:20 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <nicolas.ferre@microchip.com>, <kuba@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
CC:     <Claudiu.Beznea@microchip.com>, <Santiago.Esteban@microchip.com>,
        <andrew@lunn.ch>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <harini.katakam@xilinx.com>, <michal.simek@xilinx.com>,
        Parshuram Thombare <pthombar@cadence.com>
Subject: [PATCH] net: macb: fix NULL dereference due to no pcs_config method
Date:   Thu, 5 Nov 2020 15:37:19 +0100
Message-ID: <1604587039-5646-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f88696a0-c8f5-47a0-f495-08d8819854e1
X-MS-TrafficTypeDiagnostic: DM6PR07MB5403:
X-Microsoft-Antispam-PRVS: <DM6PR07MB540351EB6E0D98683910C9CCC1EE0@DM6PR07MB5403.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lXakHthAcfHxAu0uZ62G2dr+bA9KHOzzabm4CD6DsTnfM6PNvdpNdEe+cxKYA8BAlEZZdYpGNsPG7vSBF/R52iuFPTyLZ7WBlUO2ANbLod0IbY10NNDJO8yQTV+IOOdbV/iiQE62tcXntNfbZ+/iSoOWj4fkhwP6A5izH+2H5fvUXTwzkpJR5A0bZMN0tjy1biHE5dkuObVb9GK5BfnqLqsEL8eGDw7uCl2ouSe6jZcoTb9dKeB9FDEYM4rq6jhtEaGgx3ay7c/vhtamQGIkn1IBmp6Qlmxp2vcWk7lFvBV+WAE/5tz63xQx0i2/EABMeedN3dgBROO8ZvYga08V8WVaJ7vFWRkkFSurai2ntGLcY65HwBt1bQ/OAdGTzNMTwnx83VvMwvQV+mTAJOeAchOkFPHF1d3e788d5BSu5xshstvBZgsBYK6gqa8YzfaGOHKi0SlnAmHIESyqV6p2+H8gs3jpLiS5YHPyUiMU5/1IGSRCQ6jbtJu4GQFHEHb3
X-Forefront-Antispam-Report: CIP:158.140.1.147;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx1.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(36092001)(46966005)(2906002)(8676002)(70206006)(86362001)(70586007)(54906003)(316002)(110136005)(83380400001)(7416002)(42186006)(8936002)(478600001)(966005)(36756003)(47076004)(2616005)(4326008)(356005)(426003)(5660300002)(336012)(186003)(82310400003)(26005)(82740400003)(107886003)(7636003)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2020 14:37:33.1042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f88696a0-c8f5-47a0-f495-08d8819854e1
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.147];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM12FT016.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB5403
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_09:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 phishscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 impostorscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes NULL pointer dereference due to NULL pcs_config
in pcs_ops.

Fixes: e4e143e26ce8 ("net: macb: add support for high speed interface")
Reported-by: Nicolas Ferre <Nicolas.Ferre@microchip.com>
Link: https://lkml.org/lkml/2020/11/4/482
Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index b7bc160..130a5af 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -633,6 +633,15 @@ static void macb_pcs_an_restart(struct phylink_pcs *pcs)
 	/* Not supported */
 }
 
+static int macb_pcs_config(struct phylink_pcs *pcs,
+			   unsigned int mode,
+			   phy_interface_t interface,
+			   const unsigned long *advertising,
+			   bool permit_pause_to_mac)
+{
+	return 0;
+}
+
 static const struct phylink_pcs_ops macb_phylink_usx_pcs_ops = {
 	.pcs_get_state = macb_usx_pcs_get_state,
 	.pcs_config = macb_usx_pcs_config,
@@ -642,6 +651,7 @@ static const struct phylink_pcs_ops macb_phylink_usx_pcs_ops = {
 static const struct phylink_pcs_ops macb_phylink_pcs_ops = {
 	.pcs_get_state = macb_pcs_get_state,
 	.pcs_an_restart = macb_pcs_an_restart,
+	.pcs_config = macb_pcs_config,
 };
 
 static void macb_mac_config(struct phylink_config *config, unsigned int mode,
@@ -776,10 +786,13 @@ static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
 
 	if (interface == PHY_INTERFACE_MODE_10GBASER)
 		bp->phylink_pcs.ops = &macb_phylink_usx_pcs_ops;
-	else
+	else if (interface == PHY_INTERFACE_MODE_SGMII)
 		bp->phylink_pcs.ops = &macb_phylink_pcs_ops;
+	else
+		bp->phylink_pcs.ops = NULL;
 
-	phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
+	if (bp->phylink_pcs.ops)
+		phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
 
 	return 0;
 }
-- 
2.7.4

