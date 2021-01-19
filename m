Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4ED82FBAEA
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390999AbhASPLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:11:50 -0500
Received: from mail-eopbgr80109.outbound.protection.outlook.com ([40.107.8.109]:4165
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390097AbhASPK7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:10:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crKs+l8FAknJ3TRw4bOVGaBdrD1+toFEsUdwIPujnzAogskpwC7ztpWTSI4Zi5S3cLJPgq/rQmOkyoz2V8jhZGs2QtkRzYVToIKzRySav//+n8BtsAdbfI37TcBY/ldXxsKck+xI7jpWo8ZdGvzS3VD2qUHQMN/7gbB2Bj7zqYZIno35uR4lvo7W7I6b2sMhbytPEEvC8hJcWUBdM9RAzghjDKD9ENDl+jsd3TK0lt87VsrPAr0ycizU59+cb29QNQL23VKZFdJ2j/HRfQjmmDMdlwrOHHR+0IpkM7sjkYbMEypQQ83OFt4XlIZjn2VEdiPZkkUlDwj+WYSM9+T1DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYzjOdQ8h1EAsdEpyt+zGe6t3sotCIotg1GvB9bPKWw=;
 b=Uttu/S56QU75pW81nheCwADFNVAlele8OxMKv3sPLxyQu+VVoeRKzR1UKPW4nCxcr18Dj2nIo+MD45N9e0QsShYWBBYvHl0VPJUNOpvGVDjEgvldzyw9DS/Ec89FfuI88sTtrBk24LQ4gygSKDUsgMsPLvThScsrMpkx3u5mUbHj4w1oPQZyfdL1jFR6HGN9FSIY7eew+UkrVVLY6Rc0XgBtmM9SKBGOpvhJ/0t6XaHLqsHM4E4Wcl6lPE0Ry62pdCTBmx1NNzCPacU1Zta9fzbd5/lV09AR07Ow/bP4WFnZAFVdtY2h4Gj3n5B2f76OZlMQ+v8VcHc3FKkodw+fJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYzjOdQ8h1EAsdEpyt+zGe6t3sotCIotg1GvB9bPKWw=;
 b=Gus+TxLTB+TCLcJft1wjqdGMHXmR4Rb7DnJ+Z+BfyMwgfuHzvqOspdJL1iN9hD4D6Emh/cvAayTDzE1hWTgfmAoAlrUFNCYh7s5H5vqP/3Kg9ZzuH2dgOkILbJ/7jnGK+pqW4CzGIcxFP2l8Q0qw/WhbYUhhtnN1V+JwBHVPgxw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 19 Jan
 2021 15:09:04 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:04 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 03/17] soc: fsl: qe: store muram_vbase as a void pointer instead of u8
Date:   Tue, 19 Jan 2021 16:07:48 +0100
Message-Id: <20210119150802.19997-4-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR02CA0036.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::49) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5077d9d-c313-402a-5719-08d8bc8c291a
X-MS-TrafficTypeDiagnostic: AM0PR10MB1922:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB19225AAEA83FDB2AC9D5055D93A30@AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8JjON7+TRD7mGp1mH1Q08pxk2JQttgewmfB7bag6rXC1NMYsM0cpFNUoie+hr0eRf4zgrNzfQKN9hb5fF6iz8eg4Y2+I29zF/3BX+vS3Mx1x27T0DZsYiX/J0NbBe/22vSjf0zX/WOkQ/hQDVGNH9BBv1SlMKyqnn6pKgQYOSa/Mljjc/LtKLgIFrlPtwNg+Vhu60adPqUZKG3svtLvszK5f3inARQKEp3sW5zdw3KrbGXDY9lv065kZwgaF6Z/O96Q8+BIGeCozVLrJqEGygkg+ZlZlLjvAkKGV1vvwA/Ei1C26a2LZ9E6Qg88H51QF83my7Yd14jHongp54DQDrg2WOn0OcXnivlAm5osItwjrzRAXwUckYfwanJqYPXaJ0o8KqJz2oHk7FlXwgqOBfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(136003)(396003)(1076003)(186003)(956004)(2906002)(6512007)(44832011)(86362001)(16526019)(6666004)(2616005)(83380400001)(6916009)(107886003)(8676002)(26005)(36756003)(52116002)(66556008)(66946007)(6506007)(54906003)(4326008)(6486002)(5660300002)(478600001)(316002)(8976002)(66476007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?v3DtnhJJc7VxT6bzmq432ouvFrMnRVR+ubgm7nSK6ftEf5NqRWXY4mu4v/tK?=
 =?us-ascii?Q?4UG1rZYzxgVKeYR2+etUXd3s1sNrptSiLAYi7vM8D/y3IF94Y7CqliuraIwP?=
 =?us-ascii?Q?sHxL87Ex5iiB9LEDqt6nQ16zFerUyn78faec+xWgETuxUiSh8bGQJiIEv9T+?=
 =?us-ascii?Q?6pSEjNdWoT5g2TwAtGgX8nAxl+5hNXmICQ/nrwx1FzTBs2YvF4nblEGmilQB?=
 =?us-ascii?Q?L8HdEfY0oTBWTlLSY0aEaDdEzhFs5Q+4/G4nAI2F80iHQ/8MVJSVKn6jKTCr?=
 =?us-ascii?Q?ZUAh905+Rlmj37+eYYjOeigWTRl1SGxF1KJKUe7Wm39vPZ4GblxkjfpEB160?=
 =?us-ascii?Q?7eWRLigIt2CtRbbZoYQYwBEFr6xh//3Io2LGkEPKAK5+jqUeqkIllitFOIhR?=
 =?us-ascii?Q?ErD8TC6nEoKbgv3WRvaqcBcsKjbotraPFdjr8T7judCsgs4gkDJosdl842HF?=
 =?us-ascii?Q?AjmwixMzhE9LidsH7xGoVMqnG30hp5Adgy3/emySi/RjlyAYiii8rSZGh7XV?=
 =?us-ascii?Q?k3UtbSkHrdkDOIkRHMLoJI4JJiUxZpe2Zft+qvOBtJ+Q/yynLzqcm0a2sFdg?=
 =?us-ascii?Q?fqX8tShufFp+tcWpSeOBR4srmGJWJU9HkdZhXD+M30wZr9flO+ZbanAbHezE?=
 =?us-ascii?Q?xbiRzTOaR9HJ9gUfdPmk/KSW3Nq39yM5j5azIX6mDabVEkbbA7CisaYgYa+X?=
 =?us-ascii?Q?9cG9gF26Ji23y9ajXZeE4R1iIB5AGqIe5OWRWloe1SX2fzYmrFPdFD0sr+Uv?=
 =?us-ascii?Q?1+9fpGnVWE87qMzASll9QUqYUJDGdpPKF3Tv2wu47Qg3GgFtfcucUGOZtaA0?=
 =?us-ascii?Q?qlb57XMkAfU7JfIk3x9s45O2OQV99Pe4s30OhmyZWniUi3mxsblbFzp7rvr7?=
 =?us-ascii?Q?9eWF3lUTvlMku+DsgyZAj3XNg1xsm6hrTVVy1jLDZzatB0nyqW7u9W0KxLnz?=
 =?us-ascii?Q?1rVNFBbRK04q7QYJcVmgwVW88xLMHVfxWyNMcA4dklr+02pa1G6HIX7hpoKJ?=
 =?us-ascii?Q?29V8?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: b5077d9d-c313-402a-5719-08d8bc8c291a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:04.6279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUcgNjJKWVUpcE9dZGkQKzq8BdybC5w09IyeVjEoIDttBudBQhBBVkcnYp1Vrz8uZajFEafizCBJ3omeRhhSM4DkoHw/oZV8zBcR9TPYLRU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB1922
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The two functions cpm_muram_offset() and cpm_muram_dma() both need a
cast currently, one casts muram_vbase to do the pointer arithmetic on
void pointers, the other casts the passed-in address u8*.

It's simpler and more consistent to just always use void* and drop all
the casting.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/soc/fsl/qe/qe_common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/fsl/qe/qe_common.c b/drivers/soc/fsl/qe/qe_common.c
index 0fbdc965c4cb..303cc2f5eb4a 100644
--- a/drivers/soc/fsl/qe/qe_common.c
+++ b/drivers/soc/fsl/qe/qe_common.c
@@ -27,7 +27,7 @@
 
 static struct gen_pool *muram_pool;
 static spinlock_t cpm_muram_lock;
-static u8 __iomem *muram_vbase;
+static void __iomem *muram_vbase;
 static phys_addr_t muram_pbase;
 
 struct muram_block {
@@ -225,7 +225,7 @@ EXPORT_SYMBOL(cpm_muram_addr);
 
 unsigned long cpm_muram_offset(const void __iomem *addr)
 {
-	return addr - (void __iomem *)muram_vbase;
+	return addr - muram_vbase;
 }
 EXPORT_SYMBOL(cpm_muram_offset);
 
@@ -235,6 +235,6 @@ EXPORT_SYMBOL(cpm_muram_offset);
  */
 dma_addr_t cpm_muram_dma(void __iomem *addr)
 {
-	return muram_pbase + ((u8 __iomem *)addr - muram_vbase);
+	return muram_pbase + (addr - muram_vbase);
 }
 EXPORT_SYMBOL(cpm_muram_dma);
-- 
2.23.0

