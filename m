Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D12F279C29
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730229AbgIZTdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:19 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:17545
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730184AbgIZTdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKP07KOqYRKGQdTaSTwvB8pJwI4cZkKu0JAFXTDMhX1J/Fm2MttS5JISd23alnyzO7ZOVKSWWrjEG5SsmHD5o5fitHt+qEqFVfQswgzC/45LOA4OLK3nldEJW6UwghIB6T5oxZcaMmoIS1gj1yoGJMKKzprb40yizUvVdMlD5IbGua+h2VFj+PBxAI6XcdUfh+jNQ6OlfoS4WRblY5eKQ0W6feenJGb3t3baNXEmpnQEmTbsELZFWCHyuJhY4AWTmtubWXFAEexedhb1gv83wj3ENPKMRXziDmr3l6tUWPOabQVvph7FRjOra0yG+rQ66SbFM3HS7uVtFh3W3ZQxsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TuL/a9+USuXclhSunkPCUv8+bJ+z6YOv0dk217C6FQ=;
 b=ioimrYPPLgb2nabtZn2uMvoe0EdwNJbwbJDFapd3V7e3bYVhePIeyVFOPIgltloIKbX/fwvKL2vpMlyMT0ehibOBF3RTY/KsJQDXV+Rv3j18mFq0SMlIHvpuWH3QKlNMwoJfDObnbJJflac6sXqGUzLeG/+Veleh4EPztpCaas2Zl+N2V2PxK592kq+QYljhAgAIQEGRpJV8Z0IbrycWO16mw7JSz4Z3g9HzzAv6AnlD9LJIe3UZ2KuXDKLsOIHDsfOkf2K23NdMb95VesBV+IIOA3saLU0Jonq/CBmxuTOddTM0lD95ezuC2g15RPrzkU19DtE4mkKSQR/0wPGUYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TuL/a9+USuXclhSunkPCUv8+bJ+z6YOv0dk217C6FQ=;
 b=CllOJXGyisw+jSl56HGynK1x05jXJkt11sH3b50MwvNNShzS2dEyCpypSaerTiZgqt7VceLfSUnqDUEAF1hIZ5iqAp3Sx9RewqRC6wrGWi64Rt5xYRrNBEc0Z3lErYUGJpTx+EM3BnaJP4D5iQ55/V0Vb52nwDO7zx2f4DM6Xx4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:33:05 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:33:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v3 net-next 07/15] net: dsa: point out the tail taggers
Date:   Sat, 26 Sep 2020 22:32:07 +0300
Message-Id: <20200926193215.1405730-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::27) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:33:04 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 531eef2b-5f7e-423a-cac8-08d86252fd56
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB52951875C96973D5C5141133E0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wbmPmwXwKZWLLBf6lKI9eTZocElyyHr7fJzqBJSPVSBafGHB/d8oGhMCDrYmUp2NMEZTx6npHlOdmhEqELmrZEYxMRbTcxeeXjUri/p4ZuWle4PI1V7fZ9xvUsl7CmRCWJdH2pzvxJRsZKU7XVdUMsCc6slUDiyJb/Zk0P0vgVIvyK4E0TQPyb7kWtg4tmfMy6416/replnUIKmVniUEpa4+IgZqblFouLYAKPMpZS4U/CiVpYkWa9fTIBXzaN+S8y02koCuMTnsHccHVUkHQ+SpbBXoLFrrep2dknZS16juWdRpykkK7iGBwZspGcCI7nltBaQOWxP9JNvLcQwexBiwifQx8oiIx74YmoTPTe0sx3tQgcvI+pWG9TvsitWFORoFu3inbxSVXUAnCIg1Pv9jUnbqPOdHkvgW5RXkx9294K7cHooVQspFRnRv7t5W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(4326008)(69590400008)(66946007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: F6ykQXpadTWCvwb886mXNNNitpL56EWv1Ny0gqk+gBceWXANXQhuWG/VB4N7okxPMyUiRy6O+Xpj62fanuFx77PV9LCjmW7ZZgz8f2JIp6geLsXLMH597Rr+CKTSch3b8PisvvgxhzaKjB9WwIR8R3uPAq2m4Yk2r6XYO+1KtTgLzOAuoM7OFE6NzVHEDtNFqm1bBluTwPgAkqXJsFDijrsYHkBn9C+pgof4G4pWceCFR57/g5xdrp2bMB5zkAeplMu29lgoDdfHQgmXc6vYPln2QHqwXkctnzLwWiC3hbbEY+Iv6GtIRVp9FUBkl88TLMsMVkl236xKWrBKT6GGItDlWKjBknPY8EUb21GVqyEPmALFR1aKokqx/Dg3i6BoA7m8TBZr/E4mPaj3E67+nD9uEPtCTz3zkteXDLcZS7ZrMJjC1M7pWoiKxG5FQHxhIVmmjiTrQxaody4MjC6LsNjtUkDoxXiR5uhOcAyynhKML7mSOAxXVw3ddTjGOnkazmPowEgPG1OiMnfJA5UnzLr2f+PHbL6SP1W9bBOtH/tTK+TZiiaKhV9rvKK64w4fxnRFD55g5nKzJqYuI3FUJHC4Dm4t2b/4qk7gYuxNWjreqZzelyCs4N1KPV6E6lcCDczkL7p6/oqlBuMQWBStnQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 531eef2b-5f7e-423a-cac8-08d86252fd56
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:33:05.2018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C28ziKergLWE6Y+o+VQCRiaNRS3XaGRXRzI3JwRzED4lvQMYCqoj6gZ9CftJx/8qdXLcf9pWkEk27N6zgNNf2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Marvell 88E6060 uses tag_trailer.c and the KSZ8795, KSZ9477 and
KSZ9893 switches also use tail tags.

Tell that to the DSA core, since this makes a difference for the flow
dissector. Most switches break the parsing of frame headers, but these
ones don't, so no flow dissector adjustment needs to be done for them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Patch is new.

 include/net/dsa.h     | 1 +
 net/dsa/tag_ksz.c     | 1 +
 net/dsa/tag_trailer.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 817fab5e2c21..b502a63d196e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -90,6 +90,7 @@ struct dsa_device_ops {
 	 * its RX filter.
 	 */
 	bool promisc_on_master;
+	bool tail_tag;
 };
 
 /* This structure defines the control interfaces that are overlayed by the
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index bd1a3158d79a..945a9bd5ba35 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -237,6 +237,7 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 	.xmit	= ksz9893_xmit,
 	.rcv	= ksz9477_rcv,
 	.overhead = KSZ_INGRESS_TAG_LEN,
+	.tail_tag = true,
 };
 
 DSA_TAG_DRIVER(ksz9893_netdev_ops);
diff --git a/net/dsa/tag_trailer.c b/net/dsa/tag_trailer.c
index 4f8ab62f0208..3a1cc24a4f0a 100644
--- a/net/dsa/tag_trailer.c
+++ b/net/dsa/tag_trailer.c
@@ -83,6 +83,7 @@ static const struct dsa_device_ops trailer_netdev_ops = {
 	.xmit	= trailer_xmit,
 	.rcv	= trailer_rcv,
 	.overhead = 4,
+	.tail_tag = true,
 };
 
 MODULE_LICENSE("GPL");
-- 
2.25.1

