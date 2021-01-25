Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193E63049EF
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732096AbhAZFU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:20:29 -0500
Received: from mail-eopbgr80091.outbound.protection.outlook.com ([40.107.8.91]:12165
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730328AbhAYPoH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 10:44:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvpGLfNqOWKloeA2v95v68BFLd2Cd499JLo5bImp9aH5s2vZ4rtIPkaeVJWGnAYez0mKQsDwnf/NCo+C6w2C8lCWMBWDsxzExWV6h2A9sYznK0P2CQF8LWR6xiyh0DBbEoOyixux+1rr0aI8vJXXoe2fjQhOIVcEqqtXYF10WPe9S6sS9NELRNmzJDi3hqhdly9M9kcwoyeBWu3E+Pryhjp7x/Eaqd4mGrY1ERvLYjXc1tHkEWRi0JWSV91OsXiiq7STy6Z8SY0wPQh4FfpDIGZMfHo1QH0lixK2Elyocby4dKIkbOaeJK2s/sIVJ0lRTdWznSQY9zt96/IKYzgt+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3/Fxap1DysBcMnQcZvquAQC0w2LccdslgETEt2RNj0=;
 b=cM2UN2QAutssrw+lius0F1DAkzXtAemfMWTrFxjx5oWcnNm+5xsT0QiTr3p8V1QIiIhnR8epgcpV6yKvzdy5yOvD4EUvLMcdt8hGspviuDORm4P96ItEoId+btLhe32/votqG/hL7LPLV/pSo1Wu2jXf0MQrO7qm64K9A3H+ifgDN6xlFOADwvpr+aM6M8O56AIM2sJzJoaByykCWtZMEoc5eGFpJEsWNm2xQFV5sl1lwqnLwDIv9soB4hP/0q+dEVQONiqZZnME0jFUIQB/7xiHIsUKyT7JYONVBnehRvEiKQ+ADTIPpN9KNMRh5Buj49gj1cfKrCW+UXAk33Cg8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3/Fxap1DysBcMnQcZvquAQC0w2LccdslgETEt2RNj0=;
 b=jRHQm49qvsd0Wz7WRNvhD0reTuxHAreQZ30m+cCSc9zSsVSF5TAm4k5KuaEJj3Cm2R8EEPUktk/XOKMUXspNfObFJbDtFEGouzqcc/QhRNPAzOf4HRdt/aEBuxPMAxx2w8lxfyu6fBK75ccba6TYM68qV24kjx4x4c6f37mwf90=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3331.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:18b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Mon, 25 Jan
 2021 15:04:59 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a%3]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 15:04:59 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 2/2] net: dsa: mv88e6xxx: use mv88e6185_g1_vtu_loadpurge() for the 6250
Date:   Mon, 25 Jan 2021 16:04:49 +0100
Message-Id: <20210125150449.115032-3-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210125150449.115032-1-rasmus.villemoes@prevas.dk>
References: <20210125150449.115032-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR1001CA0048.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR1001CA0048.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Mon, 25 Jan 2021 15:04:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2bf1ddb-fd30-41aa-0340-08d8c142952a
X-MS-TrafficTypeDiagnostic: AM0PR10MB3331:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB3331C1CAE23A72B29CE6FF4E93BD0@AM0PR10MB3331.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YcUDoiz4Rc7FHk4rR6miotBIbKMdFp0o+NMtYkXfUWpphzaPGbsALlkcBkk3H+gLF9v5re8mEH46MbpmcQlJ/hLQNlzK/MzCSS3cVGSANKgs2tBiRymZRGSjc6dM/wSJBb9XKUIiVwHRxDSsrMC5MSuQSlpmEfiva6Ndeq2b+Wr2/d9hvINWSj6D1iXPTM0oU8Ek9EwMXuyox7uV7NFqgF4XtEs+3r225dpmJE21/ZPIdE3cWRds6p1GbOpP/+deL00JhTjRSKGqlfz71D/z8oc9xalsKNvGp47WANRm1zBfBTKXznWnK8cFfFAMbKM1WfgInuEvvUiJDTgi+KnoCsia92Gg4gVHPlDBShgA0iNwQanG+0J4XuTUPOPTr6yiVaOzFbM1524yG3+Dd/NcPaGWNWvCoU3KKBDvKvlY1hiv+U1AYhSbFCizeD7IMN2tQbIQ9MlT3lYmcMSLKzKarP11yxHxb2frx3lZGAANIWiKQ5A+YogO7Vfqp/D3sTzcocj7ta7YsaNPo43nK3UpmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(39850400004)(136003)(396003)(376002)(52116002)(83380400001)(4326008)(8676002)(6486002)(66476007)(5660300002)(66556008)(107886003)(66946007)(36756003)(54906003)(44832011)(6512007)(8976002)(16526019)(316002)(8936002)(478600001)(186003)(26005)(2906002)(6916009)(6666004)(1076003)(2616005)(86362001)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+UOcg5wnhfReMfFzCm0o/Pw8FzXYRkADX90Lvy1L57RwJZ+nhI+jkH/bvp4S?=
 =?us-ascii?Q?apQ1N3z+0E7YV4fz3WRykqGuOk78Rs4a7UtZPFC6Wjau4eW9CJdchg+ZJ3RR?=
 =?us-ascii?Q?9SLARev3kPyqfnQB31DJ1Ab/JsoTNnYb9xYwxnmPgkS0ZXGkBJsKKI293/Yr?=
 =?us-ascii?Q?9RrX0D54PTHp019EvK38D3nxQAGgxY0WYXI/ym28yRoV0s83XBMSuZ+pF7bN?=
 =?us-ascii?Q?JYlump8qxMWhbn+/1j7NdDPnYxNHvABg9tX2kklqC/pcKcCKROzUIe/k1APj?=
 =?us-ascii?Q?hcKfqbaJEwNdhsE1DMVkFtW+in6zC/grbg2EU81T3RsaBOcsMRi8ty1EgwAD?=
 =?us-ascii?Q?eFO1jOmEmHgPiAONMlcLgamizB6L1wGDWHF7i6vdYEP5e/kJpBYtNvThLjmT?=
 =?us-ascii?Q?WiM5PrkXuCg5sMCdAku0/cefD6HtEK+nqjsql0+dZa+Bbo5oZtbWEBeosoVt?=
 =?us-ascii?Q?syi+Sfnq1ZTynKhGDKNwskuMo8nqCgYLW1QdiJnIpEcBq63sljHsb/f2yNMK?=
 =?us-ascii?Q?RdlVT6xfhxxYmi7lZAifdnCItt+M5b2R/Zp3Oe2lfexpFgPl98+EpmBHzPhv?=
 =?us-ascii?Q?g8qvjKKLa18LeDpZraEjQelssHwD8lnykPYKEyb/bXXXF2Oc67R4h062SBfm?=
 =?us-ascii?Q?G7XzszFOPC7ENHQBIedKVOefpebF7ol5SOXE4v/dZMqqF6MhipfrYWIM4Q5E?=
 =?us-ascii?Q?8dzyrD3XeQygWc6j9swp4HCT4GhBpdK33N6FAtGlRZEEsoKs46dGaZK4qJ8Q?=
 =?us-ascii?Q?UkwjIfzwApvaKL31brjtmYFH6yM+TChsdjjHLixNVvY/U2pDtLMokSssIZPH?=
 =?us-ascii?Q?BUUR5fjdjyhgJrqByG6Wq9KxHBJ/pUm0VKBGliFgX4QfqBu4CBEvNubuWWfY?=
 =?us-ascii?Q?cRi6wvMGTe1U64r4MTLpGA2sxrm79YnErw3bDLJ3RyjOSAl5acUA8qVztf5N?=
 =?us-ascii?Q?9FL82qsKA0mlkneaQ8pupj7QjIFtQ8xzwUArqY1Wmo4bOsXXGCB4LM1EKrBI?=
 =?us-ascii?Q?CtAz?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: b2bf1ddb-fd30-41aa-0340-08d8c142952a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 15:04:58.9354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DiGwGfFhOfB9FY0FRKUVEUVUn4JIV48FPv9oPJUar4OkI02hmDM5g9JXsV6MhuGIM/ITyKNq2SoYGkXdo8wCpsTeMPHRSYZD6krf3BVKjww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3331
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apart from the mask used to get the high bits of the fid,
mv88e6185_g1_vtu_loadpurge() and mv88e6250_g1_vtu_loadpurge() are
identical. Since the entry->fid passed in should never exceed the
number of databases, we can simply use the former as-is as replacement
for the latter.

Suggested-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/dsa/mv88e6xxx/chip.c        |  2 +-
 drivers/net/dsa/mv88e6xxx/global1.h     |  2 --
 drivers/net/dsa/mv88e6xxx/global1_vtu.c | 33 +++----------------------
 3 files changed, 5 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8a0df1e903bf..7e1bbb400e8a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4024,7 +4024,7 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6250_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
-	.vtu_loadpurge = mv88e6250_g1_vtu_loadpurge,
+	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6250_ptp_ops,
 	.phylink_validate = mv88e6065_phylink_validate,
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index d2dd2f4e4730..7c396964d0b2 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -336,8 +336,6 @@ int mv88e6185_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 			     struct mv88e6xxx_vtu_entry *entry);
 int mv88e6185_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 			       struct mv88e6xxx_vtu_entry *entry);
-int mv88e6250_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
-			       struct mv88e6xxx_vtu_entry *entry);
 int mv88e6352_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 			     struct mv88e6xxx_vtu_entry *entry);
 int mv88e6352_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
diff --git a/drivers/net/dsa/mv88e6xxx/global1_vtu.c b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
index 519ae48ba96e..ae12c981923e 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
@@ -434,35 +434,6 @@ int mv88e6390_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 	return 0;
 }
 
-int mv88e6250_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
-			       struct mv88e6xxx_vtu_entry *entry)
-{
-	u16 op = MV88E6XXX_G1_VTU_OP_VTU_LOAD_PURGE;
-	int err;
-
-	err = mv88e6xxx_g1_vtu_op_wait(chip);
-	if (err)
-		return err;
-
-	err = mv88e6xxx_g1_vtu_vid_write(chip, entry);
-	if (err)
-		return err;
-
-	if (entry->valid) {
-		err = mv88e6185_g1_vtu_data_write(chip, entry);
-		if (err)
-			return err;
-
-		/* VTU DBNum[3:0] are located in VTU Operation 3:0
-		 * VTU DBNum[5:4] are located in VTU Operation 9:8
-		 */
-		op |= entry->fid & 0x000f;
-		op |= (entry->fid & 0x0030) << 4;
-	}
-
-	return mv88e6xxx_g1_vtu_op(chip, op);
-}
-
 int mv88e6185_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 			       struct mv88e6xxx_vtu_entry *entry)
 {
@@ -484,6 +455,10 @@ int mv88e6185_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 
 		/* VTU DBNum[3:0] are located in VTU Operation 3:0
 		 * VTU DBNum[7:4] are located in VTU Operation 11:8
+		 *
+		 * For the 6250/6220, the latter are really [5:4] and
+		 * 9:8, but in those cases bits 7:6 of entry->fid are
+		 * 0 since they have num_databases = 64.
 		 */
 		op |= entry->fid & 0x000f;
 		op |= (entry->fid & 0x00f0) << 4;
-- 
2.23.0

