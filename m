Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1253599773
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347740AbiHSIZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347724AbiHSIZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:25:48 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05266E1913;
        Fri, 19 Aug 2022 01:25:47 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27J6pnde001133;
        Fri, 19 Aug 2022 01:25:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=xl0RYAANYh+uj+tt6kBCujPxQ12cWavdAIQhuYGlTwQ=;
 b=KGzCi/nAIbQYxtLfa8Rcsni84hsfWx44E+b0a8Yh9NLzxlGgq08veO6mjAYIAq6/VDu8
 9vBumFPxiHLBAsr8JsNk5KLMkVLrkAHYnilSQhnq0I90SMqokbs8bRADG/nQYipkM+SA
 C4l/mLyaiLtRMBM0m7Eq6d5oRVUMd+TZY9xsn645joya+Wt+xq+mU073Tpvy5xNvWY0A
 CGoU9W2S/HeVWC1CE7M1lrxJX2BwJSsF4713TOZkQBZUeLZdtcto+ipvJtwJ5g7NrASf
 5XW11oPDZ80i2RLUNnsBQufuZONxy5YHuPxDOrFxtPrPbsOutafCqwuoJYUku8I2nMQG lQ== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hx783d30n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 01:25:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eMczjR3J2bnUwIVqLvPbyI8SS2dWkQaU5aOSYuq0EWWyQYIYmuUYHWwjatbqRj5X3bSVSfhKqOL1T0QInmaJS9JVj0OX4OFqpuQTZ7P8s5xoKIGab1TbiQu485BePzEFmr2QCh1WNbo63MhNWKg2PxTpEeWviKxU5DG4RAKwT+6HX1R78mGrxnj2VLtUdf5sr870zchOnRjCccz7lVPY3rDwp90V0tbxviE5WOtKTKsGrVLVFK/zKAnGwcQhaSJ/7uVj2BVEjOlW2TNScU2+xRZZ+Pwv9rJYavmjpaH2hhzc7gcb4UJ+CuYmF4ERk6NcK1o+rcUcFtqwAiLy1R9N7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xl0RYAANYh+uj+tt6kBCujPxQ12cWavdAIQhuYGlTwQ=;
 b=HdVE4GUKFFzT0+DyABaSRf+xyttDGlF4+3AVZd4++I1YMfSi+Rc/ygKuT0pg7r+Pju4oBMjWLjNL3QMz62L0LFER+/YGGLiRnmanS62wWlPKUZ7ASk7H830qz4o/7Sd64CU806nNjioM6ZW3SVqOYthuV8hxLRV/3pT/9UzTg9lEw6tcPNzK3eCIoWnvd6Y0jSf/GrrVB4WATcyZr8Ka9uRYOZCgv5hX2K3oXDWMadYnfBt36QL7wWGNq2dgeLuHRdatA++Gp+Wit0rFCfPVehKFMEMfLSif318h1QO0zJMEhHN8jreo/q386k3plX9K8DYEKCPHRd5QATqXB+hOlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by SJ0PR11MB6790.namprd11.prod.outlook.com (2603:10b6:a03:483::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 08:25:14 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::b411:e315:e210:73d2]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::b411:e315:e210:73d2%8]) with mapi id 15.20.5525.011; Fri, 19 Aug 2022
 08:25:13 +0000
From:   Xiaolei Wang <xiaolei.wang@windriver.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [v2][PATCH] net: phy: Don't WARN for PHY_READY state in mdio_bus_phy_resume()
Date:   Fri, 19 Aug 2022 16:24:51 +0800
Message-Id: <20220819082451.1992102-1-xiaolei.wang@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0108.apcprd03.prod.outlook.com
 (2603:1096:4:7c::36) To MW5PR11MB5764.namprd11.prod.outlook.com
 (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 475f34c2-955e-4176-f72f-08da81bc56c6
X-MS-TrafficTypeDiagnostic: SJ0PR11MB6790:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VYYqwMaPBxSwb0NBZwbZ7d8nMrQJqeMDjgNFf4d+M3j7d+3EsX8rgsku6lVf0zZ+56M46eB5mqvoRGCKDzYF1NWePGArCWSClitXU9g8zn6AU63zQNy2ryYRAeijq16yALXe/RnQz/6+RcqsifMM2whSQobZTb15OqN/ruCAN4Eej6f0BLQdojflWuvcUmPMlEwA9KV9T1UuA9Bz+UYQBSEo3hg4UUc14/sG2K61z5BLVNSIfN3p9fQTfACTiWWFE+WAE9PuoSY2usa0jSYreooJDjnvNIDWzA0BPzdSa1cj6B/tXhB+nZzkgO/YuTLGtwthkVe0WFoId3EPS0ZLLoyeQOoQsvAVemVIQPAWmeT0Bkrqx8lDByvwPd/mmhXl1hihL8CLgUVcqnwyeugNMLiNta3a6MP1Q2pWQXO+6WPERGQoIVfYaOVuHO7VcAIWcc6y4LUznDsPQno37nVVDshCqFSZN1IIKL4TMXR0o/Z8S/Fc4gpsDXVvivd2S5shwjVLMjMIf+jcN2pocLi8Siri3Bw1xJzdrTcg1MWtt82TR3ld8x3seA28kf/uL92LV3eZC0HASXzw1F4m2w1sr3rJvCGirO5n+dAVsdm1mtxDAHBKgDmV4XSiqDtODVwAHo7iftdt3YoaS46Y/zkOg37y4V8D3J5YK2nlqJzmOFXjs/IqUnvTpXhAFKM1i4z0a9eLNpSM760qR04cQb095s2PBsEkBymXkJiNwdyyvRyHVlJRtPi6GBqf3K2XQiKt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39850400004)(396003)(136003)(346002)(366004)(376002)(66556008)(8676002)(66946007)(44832011)(4326008)(7416002)(66476007)(316002)(5660300002)(8936002)(36756003)(2906002)(6486002)(478600001)(41300700001)(6506007)(6666004)(6512007)(52116002)(26005)(2616005)(86362001)(83380400001)(1076003)(38350700002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q/vY+I2h+JffAhXdXvqB2JCDiFjVu0bcVfgAt06Pr5Ie6AYveC5U6gTgsaax?=
 =?us-ascii?Q?4iIfwM8z0aXqr60chA0B/k9u/5s3j6YUop80koHpoGXRDYQRy9xsl3w6JFGj?=
 =?us-ascii?Q?SGcpUzTOjFV+3IkiQoiH2/ctGQSqQqMEE/REpsnlMy2QQKj58R2sEoCp+bbu?=
 =?us-ascii?Q?cmWg3uX2GJszsZ0tTaLzSMDsM/GC8rWwckoiEjYkzfU8AzbpEiuiIm5AWFtQ?=
 =?us-ascii?Q?8N05UhATKI9GN7v1Dn832OxXjKjONw9ExazXGG/nareOPGsFMTRJjUTBSUhz?=
 =?us-ascii?Q?qOwEH9BNlZ4XIqB20I6BTTDe6Ltr7YSBnrd2GuFoBpfhXWgj750ymj34ShO8?=
 =?us-ascii?Q?IcD3b5o9CeMz85TP1njxnkFNykwjQcCw4yQxzDLouZxfS3KnrW/DT/c1XTxZ?=
 =?us-ascii?Q?GiUEzSaC0snZEsuxGDb4eFmoj94zogxDc9nQOCcPOBoHgLstuvAFnZz014DR?=
 =?us-ascii?Q?ocOdDZhslgqMO9qAyXPKPdgktmgXgNvs+vkTyils8Lmq0FV146iSq0BGSG7Y?=
 =?us-ascii?Q?E3Dsn1fuEwiH9NKC5gIMDoQGjMLCfL4Mw+L/u/u3en9fdm/VMsCVAhyfeneu?=
 =?us-ascii?Q?7LdtbjyYlrF56U4nfqQ7qWxBxlzc+3Itx9oTg1VH0AzemGVjnyxXbAkbcwzY?=
 =?us-ascii?Q?eUyi0K7PNwrCeRk92588slarRIHfsV7Z74NuIBTegiYBxjfWny5dx7C/CkDc?=
 =?us-ascii?Q?3ZnL5ackCw8YQUzMuSZ1NyIZtq5KzkBW68iQEW8MlPG8CsNVdfO0VlkBvUiz?=
 =?us-ascii?Q?b9KKaGCZWV17SR3GFHWA3STtleJndHYw0uF8PfV5XaQpRd0ACM7cjjjVJvNx?=
 =?us-ascii?Q?BDnthRacgMJcwRYBtxYuryliT+CkLNTvqR0jSfq0AY5mXxZk5OJ6n+XUBEWQ?=
 =?us-ascii?Q?wjfEfEVcmBCvvDTj8QSrmhFxrkuDip291iSsp3yEP08eunyGeIv7AGLEPcjf?=
 =?us-ascii?Q?yNioR0bT0sa8SpMmSzNLWMiBt13YMfi1nHVJqn2PxCrYTNkBmI0JeyRUlwYU?=
 =?us-ascii?Q?xKFCpKT6r08BjH40Tv6qwvHizdBddoGhbFur85A9mr6Hb+dub6e7MnXeFBN1?=
 =?us-ascii?Q?BQlStu4RNMXZzZyn5o+M+5a/0jf2o+rBCXn5KZjBUjnwbf9pK5IqPgDnHPjG?=
 =?us-ascii?Q?iTC96U6nFOKm9qSfTvfvPYT3ABVhXJ9bjDO6B2EJx45H9xQxO/ulijMzEDWY?=
 =?us-ascii?Q?CXRYPdZNDAAZvYgR5HxE5yDmO+dfh6r/E5aQnp83ZHQi3DVk/mu2FOVFmbnH?=
 =?us-ascii?Q?My+1JxJpsknzE1b823L5JA+rvj03s6T0+++WP4N4X2WYFcHKqyMCbui4FDpv?=
 =?us-ascii?Q?Yr8th4t3d2jLsgExjp9NWzUdWXhtkAARYuXStPUMF99BWTKQ/VwD7nJHctep?=
 =?us-ascii?Q?jgf2dg/b/dam5ls2BwG16u7uq9gBYaoNGc5FTkkDxudaKjDcyD/BuHYi3gDu?=
 =?us-ascii?Q?YpGt2A/fLu1QLyjXRryc1DjwQr/wLX82504PVG6PORGzLGAD9g2IAXJSaX/8?=
 =?us-ascii?Q?bzxvg4shrmhLiHgHiWtHlzN2hIYTi7ptPmSFQH3YkdYiuBNFP8xmy0h807kY?=
 =?us-ascii?Q?NeDla9pZ9SSem6g0QzeqSTD+Cw1qSMkzFF+xoatxl+/Hbbcn/sWdfBN3I4Sd?=
 =?us-ascii?Q?gg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 475f34c2-955e-4176-f72f-08da81bc56c6
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 08:25:13.7623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EOSA6iepWrVCcCkeOxCoko/FT4Nq3iBwwYvt7vWCFk5JVu3Zx4cPK6Yt6ZEn7jmJ3ybGvT5roYBk5+kibZNznZvhjPsZ1GbVw2v3/ELbVhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6790
X-Proofpoint-ORIG-GUID: N2BVbmzK64V5FFj4yhggnwhLokkWP7wT
X-Proofpoint-GUID: N2BVbmzK64V5FFj4yhggnwhLokkWP7wT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_04,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=933 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208190033
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
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

