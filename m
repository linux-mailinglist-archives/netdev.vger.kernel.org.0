Return-Path: <netdev+bounces-6294-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E04017158F7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:45:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8367C1C20AD9
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C224812B7C;
	Tue, 30 May 2023 08:45:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1C946B2
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:45:53 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2128.outbound.protection.outlook.com [40.107.215.128])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B091A1;
	Tue, 30 May 2023 01:45:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMi1h0jFTji8uOPri5kd6S/OQldMZNJy0jevX4Ahb4YWIO2N5hD4dPkIG3OxVc4T26xXO+I7f2SF3VmCciOx3A2rrLCViqQ6KswvToHhdimuCIwiSW/7Av31GTfOqRX/SKXntq4oa5YOvDi91sWRf1kAW723PmXkZUWGiFjZ41RwvLD1jhVfT4Ojy9TEcoIoG5lmNUhMfkK6Lht82c9oTwjfURSjrP+2b8Ob63LIWaIF65hoJVrJxL2KLNvbnZ5wbQcNnBjGRCiJEnNoW3ItwQKLsPgZLdFJUpP2qpaf77KbpFvFCpqRaLJFX33L9Z/hKng45wY0SWA8uRIXZwSO5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gxec+QlojZDbZO4XWxTUaQdUcZhwseYskfYJQntQvCY=;
 b=NNRbU74h6g/JkchZ1BvsP79klEMAgot0k9LqzwWwFyqW9QugVo5wVgOVydFK1OwyMCtriMFrRccw1o9ifFIsAUh2B/3W6PfHUkEOv4H1CCc3LWcEq1aCOEwCFLaaUtEKekvV/F+4Mfv1u2khNsL5nTIiXoZ9kYS3vopTi5f1acqVUccOEswb2rZXqKaa/ILqDCc8mYSotN2On0EbMvGu1bVY6Zmi1OtVN3/ev+lXYm/swDge54CiyvxKZNPctjG2c+AfV7/7egR5D7eEzmO06lWu7MG5QbVSsmqLYKzSfVPhDK40cJFymOVnUeix4BgX99IWTpb8Lulv7xg5lOnfMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxec+QlojZDbZO4XWxTUaQdUcZhwseYskfYJQntQvCY=;
 b=BQAGYqWhX9iYAUoWlv05TUT+CmlQewyXtwWqgupuBaeK8v3SsCAOnKOFN/LJozPH0raPpvN3YoJCESl3ARByyLdWK+ElH5o9vo7ROCKpzWpwrRe995QoXdO49HxbGxHBaR7vMeOe2b3kdLNIF0NaGOhX6428JA+kiB434wB+ds27mClKA0J0YNH4KAgAHyCsuMfipJ4fUXzngKCDgtyHFhVI9ASYt/5OWxKmcHcKL9kbCnjUTgLOu0aNJu/x4FkAoTXGX+zvcLssi1J+Vtj/JEwkHbDEhqyCKICxum++sRbOSjNpPjuWDvmzcgLiWHew0Pi4KMQnE6LwqPZznZYyJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB6697.apcprd06.prod.outlook.com (2603:1096:400:451::6)
 by SEYPR06MB5326.apcprd06.prod.outlook.com (2603:1096:101:6b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 08:45:47 +0000
Received: from TYZPR06MB6697.apcprd06.prod.outlook.com
 ([fe80::f652:a96b:482:409e]) by TYZPR06MB6697.apcprd06.prod.outlook.com
 ([fe80::f652:a96b:482:409e%5]) with mapi id 15.20.6433.018; Tue, 30 May 2023
 08:45:47 +0000
From: Lu Hongfei <luhongfei@vivo.com>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org (open list:ETHERNET PHY LIBRARY),
	linux-kernel@vger.kernel.org (open list)
Cc: opensource.kernel@vivo.com,
	luhongfei@vivo.com
Subject: [PATCH] net: Replace the ternary conditional operator with min()
Date: Tue, 30 May 2023 16:45:30 +0800
Message-Id: <20230530084531.7354-1-luhongfei@vivo.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:4:194::7) To TYZPR06MB6697.apcprd06.prod.outlook.com
 (2603:1096:400:451::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB6697:EE_|SEYPR06MB5326:EE_
X-MS-Office365-Filtering-Correlation-Id: 26689f37-ce37-4767-2787-08db60ea4360
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rjfF1Rt8iDCguQtN9VOFzhiufcLcyq+iRNbZ2SkVZcmwAjMWdV4boCmicEIWjQUQ8PDQFncArCcXIlXu4IIVQvsqEnlQbNpgOV3fDf6bWJYARuZJq3tZMekZli4MSxhHLYMLAgcMT5E+g0G4rU66XEEKhrSDJJzXCpbTilsaoGhmZ3LzEVgVpp3k0U+kT0rEwH+4uCvI4H1/ldwRhY1KZ7R7jqVz5YL2MegR3rK6LTt7BGEUvDh2qxF3ueaL/pKK76AeIZCmZI5GbBe2sH40QP717M7ZkgYI/jfsnz9456moA+tacBjvaTOiWzp8yL4X92rLtgUQEciAGkUawTTy8TL5sFqCi7iOLqrgIyh6uyNrfCTxvcHoL98tU8RJHMe9Mdod+GGVqfzxn9O5MhwNrJiAt5DjQXudxSs6r7eWkVilmiy+e7d2buRMMY3vjCA1jEmER9Ts/KAJshsIjd/g80fesQpEfuNQ8BsJSfkI+IiQiIWSo4+lzSpFZ54vxnHS4x+w+pZDnrBd/39wD36wBu2K7tcPqhFSuchJLADE2ERUhUkCdSQstD89BJFvhVoILDgzIuSLZoEVY5HiLiZdj0Rpzp0ksBo34PzMi7TptRDkSbDdSd2qYuTyiuFZBvXO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB6697.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(451199021)(186003)(107886003)(2616005)(38350700002)(38100700002)(41300700001)(83380400001)(6512007)(6506007)(26005)(1076003)(6486002)(6666004)(52116002)(478600001)(110136005)(4326008)(66476007)(66946007)(66556008)(316002)(5660300002)(8676002)(8936002)(2906002)(86362001)(4744005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IfS3s8dmQTGO8r1unO1KnVwL0d1/P8WqZ2azTwyCIXvrJjDKJ22WOkOAilkG?=
 =?us-ascii?Q?JGocIixhrJlEk+5FL7q0EygRCQ8tV94/YyfAkw0A8kqyMQSnS6PbhAoOwdtB?=
 =?us-ascii?Q?V3Wce8vSSdUQ/mJGEBiM2Avcrg13K/fi5w6Qnc0cMCafmLDqu301EVCOvPt3?=
 =?us-ascii?Q?WG35JceSCV5kOZ9zdqDURXoi54AzhLA1TMfjZs7uyqWlajtJD3sBOSZ+iLHX?=
 =?us-ascii?Q?6gWpg/2REs/YeAl4G+kMacBjZP/EJCtkyw/HiOfVfgvZpvUgpnG8K/srn2/A?=
 =?us-ascii?Q?NFl/1HQjUtgBZMkIo3JZYKebKOmWRHNGef55NAx6LroxZWQ01w1zvXHleVHN?=
 =?us-ascii?Q?xTJ93bTyimRaigls53QeHfbO6iquYBXd4q0Y24YakPa3BIlthBx1M0UTPOH4?=
 =?us-ascii?Q?vYjJHkL/AJNP1pX6FRv5M4pIDaG8WX9s0gwh4G068f/vFOTWdR5GAypRrdqJ?=
 =?us-ascii?Q?8RGDsJdfOoiYUf8l/oAPmxuTCmq8XapOhljsRZcF+FVPkyX/rpqRJVtSVfgY?=
 =?us-ascii?Q?Cmz8uFduybay8MrqzdTl/EisPbwUAt5WqS7RVlM7oKR+iEQ9g6EHQiY8lOvb?=
 =?us-ascii?Q?8J34ShmzIiTG2kQffq+FpWYcDQ4MQs5GnyLr0QibsTqgy1u6kBPoOtZmzQqi?=
 =?us-ascii?Q?7Lp0iQQof5shYQMFsB+kwWENVwWm98r58Gcc1Jmfw5SpOjcysAvZpFtIu71c?=
 =?us-ascii?Q?gbMtQYGLzBY9NkCgYYZOoaKzwUrh4RUe5frIhDiI8bRu+SuaR/OlUU5NDW/p?=
 =?us-ascii?Q?Y7KS+WCbgFw3nJ6H/7yJ4jjh3A9Wb2oEivj8s+Q7I0KMMzoj8Yq6f/s4m9S3?=
 =?us-ascii?Q?ja3gmtOSValIapGkizxjQZdi40iW2uxRstryrO+76GaBlH+xKffMXKu2GNCW?=
 =?us-ascii?Q?PB7DEodI9WYY1qYdKZY0aESSB0U4jH+Z1mdaXNlWUnb1YQFRuEaiWafFwl9J?=
 =?us-ascii?Q?MMRCQ9vUjQcl4kqHtAOqSU5RsKEQLeALzMBoG0xC6p1iWh7vX1ukTPJeTLGx?=
 =?us-ascii?Q?O7sL81TIHNmtiCRQDN1foiCi+dxdesxbNdF/O/E87s9yYNuLDHyOngfoQCil?=
 =?us-ascii?Q?IsK3o06Zm5IayJlBKk29hXyodowJCPG37k6SLu88xMRUzzEv1k5hlHlFc9g5?=
 =?us-ascii?Q?rsB+AIJ7+aiuOXfW6d66Echec9wKpxv578C3W6mPXZPL7tv7+BWSDgiP/r3k?=
 =?us-ascii?Q?KPrwQMXD4JITkrkVtLKg5YDnk7VEvwkz6DtTSkErrdm1GAGNKZhkCGfsErqC?=
 =?us-ascii?Q?3eKPqCG3OCSPIRt02M2zK129M0J46UXta90XvE9TZoO1UF08fpFA3DR0h8cr?=
 =?us-ascii?Q?hBRx253zc97lon1MOfb+QqPaVhq8nUe3dYY05OGx4Yh8t5ytt4QllIbHTJ9G?=
 =?us-ascii?Q?teYt2XRECyD54GGrrUhgzJUCEU1Q7VxuaqOKk8hldrlQ9QnVGSHSWVo5qbwI?=
 =?us-ascii?Q?r5a/E3PLVaZ3WuShKKuUtDCXisqPJzIEhDgG2L2tU1kAwdQwSpfqzMP+p+eR?=
 =?us-ascii?Q?9OuUAW0kvlTKWPCp5J92Ap+Ifcp4Sg+zlyQUoFssWVfL+0dDu4EXpFz6/Iw1?=
 =?us-ascii?Q?H7famWKhJmX3tHORjg20rgEwXLuLPpt+7Qi8Aos1?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26689f37-ce37-4767-2787-08db60ea4360
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB6697.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 08:45:47.4045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mTEhkT4vb2jpiuQ13cFeYSPvVL1rJ7cT2jbAKN1enaKwBGZSO654Jp8YTsYIR+imxZnqppOKYwfAzGk+1mmXQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB5326
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

It would be better to replace the traditional ternary conditional
operator with min()

Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 drivers/net/phy/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
 mode change 100644 => 100755 drivers/net/phy/phy.c

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 0c0df38cd1ab..a8beb4ab8451
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1002,7 +1002,7 @@ static int phy_poll_aneg_done(struct phy_device *phydev)
 	if (!ret)
 		return -ETIMEDOUT;
 
-	return ret < 0 ? ret : 0;
+	return min(ret, 0);
 }
 
 int phy_ethtool_ksettings_set(struct phy_device *phydev,
@@ -1526,7 +1526,7 @@ int phy_init_eee(struct phy_device *phydev, bool clk_stop_enable)
 		ret = phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1,
 				       MDIO_PCS_CTRL1_CLKSTOP_EN);
 
-	return ret < 0 ? ret : 0;
+	return min(ret, 0);
 }
 EXPORT_SYMBOL(phy_init_eee);
 
-- 
2.39.0


