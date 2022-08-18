Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F58597F37
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 09:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243856AbiHRHam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 03:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235891AbiHRHal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 03:30:41 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E505923EE;
        Thu, 18 Aug 2022 00:30:40 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27I6taNZ032725;
        Thu, 18 Aug 2022 00:30:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=r9XBfV4oBeyn+Nbhpzt9QDrMJeP2SS9eBkqwJfw06FA=;
 b=qwZDmLCefVIMYmACU9Tg3AFT+uZdzvskPugyqzimprrGIPEfFhdXN8pgc3CdJUmV7kmJ
 sA7D+UCpiB9co0w4Bk9WjeS2efHLkM/7L153jBPgZu7NIj1Ys/zuOOgf8qcG2tDG0TbG
 Q+wfeoLL7A/UiJL79MXJCBBgKXWbRiwZkyRSQfikAQ/X9l2qa56CuIbkUAwc1tea0eqB
 9Hec4M9wbUTciaiGKc++uBMfWhCdBBzs67u4AiZtNQX32FD/Z0I/3/8PSXLnPZpTXcuq
 G67EYF6TO3GPbC3ATVgvmf2aNKgOGywYFFSm8sOEBHX7ioT7k3jZQst+Jn6pTajRnGtr Qw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hx783c2xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 00:30:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hmkrei0J2Lk6Ss8KIQK/7c+awarPkpewLdyx6hqni9xtNoVnTSiKcrmssZlpBYfM093DvAVpXZyKbzOeZCnbbV56YxysWDpy3ZXAkwj/YWSTIMreCwwsLPgY/82BK9VNqd03JEICEy7mF0MtrqFZOUWJLuUdSbUoxCDuZgSOrb1IhbakgQtPR77Cfy4gWD7yTnRkNAdJnDGn/UpOfvob5hg8ZAm2vRgyS2IVWMRuKx+mBIZtmmasgJbpB1GI+Fjv1FsXiQAr2fmZF8kx/loxk6xaScrYLAFBN/y3SVJGhMEAz18bqdxKGMKcHkCJyxcSbqJDqewjZZn/pbqwrXoxkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9XBfV4oBeyn+Nbhpzt9QDrMJeP2SS9eBkqwJfw06FA=;
 b=HWU/49tSRlBy79iE+yMXMF0N2lZ68BJfW9yIu6PCXdJxZrckyexBCv+iU36AA/2jxXiwE9KIFGzJY8HAP/kkv6r2gXT4a5X/UaqX5Dlv/z3Q1skaHWW0b2Trk26Y7v9XoGxwatGI+vsgwXxyyrhI4LN4A7pfbUKeU2Y1+hymJpI/vRZ2rnDeBtgDuyii1GoRKRudEVeJAlkGBoG65Q057kfBzdJcwQVg3j6nTUeOAyvbNv7PmveBQw6jQ8O0Wz7pWIrHNiqbIsdfAaVgvaaOmVbQqMZRi2UsJPH66H8ZihYwEqa/FH5+3SSBRzOAH10GDn+BiFbPR+W4jUiwYHQ9Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by SA1PR11MB6686.namprd11.prod.outlook.com (2603:10b6:806:259::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 07:30:02 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::b411:e315:e210:73d2]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::b411:e315:e210:73d2%8]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 07:30:02 +0000
From:   Xiaolei Wang <xiaolei.wang@windriver.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: Don't WARN for PHY_READY state in mdio_bus_phy_resume()
Date:   Thu, 18 Aug 2022 15:29:43 +0800
Message-Id: <20220818072943.1201926-1-xiaolei.wang@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::14)
 To MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31b2b6b6-53d1-40fd-7813-08da80eb7667
X-MS-TrafficTypeDiagnostic: SA1PR11MB6686:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 79Ysma4owhn/Fx4PxxIFijSDg77feZ4dsG42yev2bieTYN1Cv0mczM05XUCTFy106CmAOMjP9wiTFGAmNcGoCTr8iTK5QbTELV1dFpyechtuoNshgr8S+jiQq/oREI+cQJvsgxNNZ59GkgZEQp3yFfd6URR/sK8XfO2sck+Cj1Fxk1OtU25V6Pu4dDK/dOH03yA3Bpm49g2eTlGd/DTnGYvcwS3EFdGPci21VZOdxhi4+oSdUzr8vOYf29lEWqMUFWUewAjuMUstidRbFT3BKb8v/5sy/0ubBzuweW7X7K8of0DlsPhkaFzLY8SoBwtFzHqd8cjXnpiUKxVODYtz0mKO6hskk1qxfkJrDP6t4s3PpnhB9M/34cUiu+Zosyiaq14SyFAEL8DgL/2MAU8efM4TDy7fBRGo3TJL4PzHMKp3iiH4mGamLYgERqsemTuyOz2S1OpZJlTuaWk0BNRykBJ/hCZ57asE/GIU/peJz8oZU66FO4cwZGW9cgSYg4eHXLof7UdovmHTZxMX/uT/z8IWlAWvsLbXcU+fbhHX0hUGcdOES54zGw3mQwdfTSvs/d66QSf8KuT8RefqlMES1lQ9WT7a4MrXL11xYyLMnwPdSyUlfYPXRjJSNJf7dRlyVlU2X3VsFTKd8Hp0cT5oepZfl1pLoEDvcXnC8ORY0AHQY+LC7NKTYPSlQzL9FX4J/+GgkAV8onVN4Tx4N/I33UextujZSDcmJ312zdqM4ZOh8/GcR4nq5xf5dtqpJNPe6G9dqy7Gtxs6r+3/Hyoljw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39850400004)(396003)(366004)(376002)(136003)(66476007)(478600001)(66946007)(66556008)(6486002)(4326008)(8676002)(41300700001)(2906002)(52116002)(86362001)(6666004)(6512007)(26005)(2616005)(186003)(1076003)(5660300002)(44832011)(8936002)(36756003)(6506007)(38100700002)(38350700002)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RaD3/HvwiZLtuIKzocLfqJRzTdeS2Z8+ZkIYGDvs4ZU2VQCL9I4YzHVny075?=
 =?us-ascii?Q?1xHyLgzjp2zfnKqtRoQKCxPjwHC658Cj9TMa8QGcmusxpjVDZVOdE4lfFVPg?=
 =?us-ascii?Q?TZQMHoWSso5ZIkJp1NDlp7ZMNpWUH/suDv1yD2tWNedqfzbt+WpI6vQLq8sX?=
 =?us-ascii?Q?W/LQMAuxx75BdQ0emWXCHo1FtGRcINMob7c53BzuU/E4NIqFViPqJhmnnrk/?=
 =?us-ascii?Q?Lloe4iT5jgsu5QwJ4qwHWfX/W7sT0llcMhDNhrJGFXMV3nunCaaG3XFGDA/h?=
 =?us-ascii?Q?QGfbXFUfk+1irX/5tm4lGytZ/9CT94p+odEGC/rpE/1GdxpRCrxlgtkCK59h?=
 =?us-ascii?Q?ThVIcGEJ/fB8morGy0yxZs5HJjzvBJtoZfv6PnqaxJX8sdbH+O6sW2v9LfR1?=
 =?us-ascii?Q?zdalqxxV2yo4/xhDnmYosXbu9136EAUT1nHWS8uR4Kkhv+lbpD1mtaUU2ApV?=
 =?us-ascii?Q?Rt9owFP70gR5Z/VoHnC4IT34qFgfetciqBLzdaBvlaCf5PI5FXwt4a23NdOQ?=
 =?us-ascii?Q?Z3L0OJMeuqNgaCVvMw2ifskDwc9bdX2CZTy4tcJixjB1y85wD2x3hj/MBDxK?=
 =?us-ascii?Q?HRndT81lcYb6oxS0pONIynPkMmfAAe++mQi6/8hf8N9dXZb8EN1AkQNhmsV3?=
 =?us-ascii?Q?YAicTuS/N+eM5teroe6SE6p3d+pzlzNsFTpgKG28+hB1leWAV2mFDwUJJ7ds?=
 =?us-ascii?Q?2R6OcC90HZdhEhPSzJQ0nG5LWLfZqVj7X98CSeU/cwvYbEP7tgh3GX5exmcm?=
 =?us-ascii?Q?EiJQZqE64z/1UNE33itukRqhSFOdNqVHxmYMrMKNzld6xA3a/fSnPVXvXX9I?=
 =?us-ascii?Q?FZKmp3N5s1zUbty9neLE6nzc0Pt/IzSiTRIezVmIUZegXYvTQiYrfRRRJDmr?=
 =?us-ascii?Q?jE047aEJixma+xMOTgPqvpzm0WAsJCJKuEXVtro5PcR4+rETChCBfMWLwIB1?=
 =?us-ascii?Q?eeIN8QoSc2ltAEH/zj3VZ3xf5MXe+rJHx2HD/Fewao9YG/eiZJ0B1cuxl+zH?=
 =?us-ascii?Q?jfE4wuIy1p6L343GaT42IJor6jNvyQQLMOuP93SC6DRYZkx9naCpJS87Tc7e?=
 =?us-ascii?Q?KEzl14ytedj6Wb4aTskHmARbXqVgaYP1yI6zd0l1hJ6Lke3h0QROzZO39nLE?=
 =?us-ascii?Q?K/UE3zKug9mz80BlgjAyYods/WPIp91I/Z0MNzLPitQJaLoRTljaHkxC/aFo?=
 =?us-ascii?Q?0RALD27GCLIUj4LPsX9vwp3z7IWQ2vr113ruAdCp13HvKlLNrirPTHQE3JdA?=
 =?us-ascii?Q?1C+h6utrn7n31u/bXAgswu7yMxVUmNLD2ntF7Wtk/gQTDnVRG6iXpn1zxuBy?=
 =?us-ascii?Q?jPtiaVVH4Wv65u3zCKhowTb9IVxth1jFPa/8PNDKnDdFtvx+bgXlmhde1rcf?=
 =?us-ascii?Q?NxAXhxKVC4aWRR6dB/JaYwU9M3ayE07SwcplJUxJ5XS2fIWuCVkbiDoDWNFy?=
 =?us-ascii?Q?FZk60uQ/CwYYAOGjdtT/PorgD9+ffforzyKc5DQg7DIs74+xsWm9o2aoC2qr?=
 =?us-ascii?Q?TV4Nt5bAP9B1o5Isb1nQmOS9orfMonbIkYk2B+oaI05E2zk2dj8keAEptVaX?=
 =?us-ascii?Q?MPsng1L/fGHNCx5y55XlijLYKjaiUhuOCTkUt7VJOHHN/N5DfFmdexsGaNDL?=
 =?us-ascii?Q?9Q=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b2b6b6-53d1-40fd-7813-08da80eb7667
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 07:30:02.0695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gC+GghQRUtv2F3yWbmzFRuvf8wUF1++O6D/jQFC4ohlMuH0VKnMXKY63W1UslV7LY8hf834bUKa20GPuI+Q10MDpBudfCHDa0SOM6SFdm3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6686
X-Proofpoint-ORIG-GUID: NLmQkaWfAQ9prJyVrzKGzQGUI3DNkPSb
X-Proofpoint-GUID: NLmQkaWfAQ9prJyVrzKGzQGUI3DNkPSb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_02,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=933 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180022
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some MAC drivers, they set the mac_managed_pm to true in its
->ndo_open() callback. So before the mac_managed_pm is set to true,
we still want to leverage the mdio_bus_phy_suspend()/resume() for
the phy device suspend and resume. In this case, the phy device is
in PHY_READY, and we shouldn't warn about this. It also seems that
the check of mac_managed_pm in WARN_ON is redundant since we already
check this in the entry of mdio_bus_phy_resume(), so drop it.

Fixes: fba863b81604 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
---
 drivers/net/phy/phy_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 0c6efd792690..12ff276b80ae 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -316,11 +316,11 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 
 	phydev->suspended_by_mdio_bus = 0;
 
-	/* If we managed to get here with the PHY state machine in a state other
-	 * than PHY_HALTED this is an indication that something went wrong and
-	 * we should most likely be using MAC managed PM and we are not.
+	/* If we manged to get here with the PHY state machine in a state neither
+	 * PHY_HALTED nor PHY_READY this is an indication that something went wrong
+	 * and we should most likely be using MAC managed PM and we are not.
 	 */
-	WARN_ON(phydev->state != PHY_HALTED && !phydev->mac_managed_pm);
+	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY);
 
 	ret = phy_init_hw(phydev);
 	if (ret < 0)
-- 
2.25.1

