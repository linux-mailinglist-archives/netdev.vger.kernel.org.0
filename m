Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060303B29B5
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 09:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhFXHwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 03:52:45 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:41832 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231630AbhFXHwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 03:52:44 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O7jwjb004879;
        Thu, 24 Jun 2021 07:50:20 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by mx0a-0064b401.pphosted.com with ESMTP id 39caqmre56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 07:50:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BClXcHBuBY2NoMpucp2clNm9cHmJBOQ7+l3Cy3Mn5ZVnVriwZBQXWCzSUEC6x3xwNMYSJo951BbB0eC+LcborSGoT+cy5puAkc0FwWdy6a8UP0vLQdyiW/BHuGweoxll9phEgC6HsXP9msQry9zOWQgsXA2JC/PWzU1Ev0KsoAbMPQrZMj2LAGADtdPwUqfSI9OafKZvvBC/hCCQIRcRNfg7I4aezpu2/9W33WO6NK3Vlm18PUX+E45fCmtd4R3XhG5yBsp0buhjZiaFEh71LwlHXf+x+DnSAnnpSua1+IhUxX8rqdMHQHRiPfce1phX18z2YAF6G9Q85G4IKkGpRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nz+KMWP0OXVjGFmtCgMONE4BxsjhTkyLTvsc4+YC3Pw=;
 b=WJquf8GegDshNrB66cEavsPQG75oo0btWX/4L780QH7d2pk2uGfvaJz/2coZiB3OQIfdVRdJqWjpRfSkxVdx3nMNpiXdMAGJ6gGuzzLUM9q5A8Wgij8R8xJC4giH2VdO96400nXvUhU9BM9ODVCkZSDpJzYbCfIPJSNSGF6Y02dVm0rs+a/Lxk7gOou1erd00V013rBwOiNI6trj0nR4Q3ORrIZ0YAkaxk5Y8ltffLcXaMutY768Z0lStLhsg+MfCBcog3m5ehu6RZ2U+0qQ+t8cG7PVgn5rrKY2egX6zb8igLKhrdFCJFQ8wFcsKTuLyuJNdq2EurdDjOFwFRNQ2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nz+KMWP0OXVjGFmtCgMONE4BxsjhTkyLTvsc4+YC3Pw=;
 b=aJwB1h48e1mRaEWmb8VB2k22TYB8fdUUX286VdKeLDRzDYCmxMNy7+wFFVjJKKx/8gY/lC2fsS4w4uvJlHP9D/gphUugEtoQmF5IJ+JCqCqU+75igAfzdKjVpnCYhlFzeNL5FvjvmkEYcxdVHbrfXqnsYixvhKsNvFb/fXmcLQ8=
Authentication-Results: sipsolutions.net; dkim=none (message not signed)
 header.d=none;sipsolutions.net; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB4739.namprd11.prod.outlook.com (2603:10b6:5:2a0::22)
 by DM6PR11MB3148.namprd11.prod.outlook.com (2603:10b6:5:6f::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Thu, 24 Jun
 2021 07:50:17 +0000
Received: from DM6PR11MB4739.namprd11.prod.outlook.com
 ([fe80::600f:ab96:ee86:2ec4]) by DM6PR11MB4739.namprd11.prod.outlook.com
 ([fe80::600f:ab96:ee86:2ec4%6]) with mapi id 15.20.4264.020; Thu, 24 Jun 2021
 07:50:17 +0000
From:   Liwei Song <liwei.song@windriver.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        David <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liwei.song@windriver.com
Subject: [PATCH] mac80211: add dependency for MAC80211_LEDS
Date:   Thu, 24 Jun 2021 15:49:56 +0800
Message-Id: <20210624074956.37298-1-liwei.song@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HKAPR03CA0001.apcprd03.prod.outlook.com
 (2603:1096:203:c8::6) To DM6PR11MB4739.namprd11.prod.outlook.com
 (2603:10b6:5:2a0::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp3.wrs.com (60.247.85.82) by HKAPR03CA0001.apcprd03.prod.outlook.com (2603:1096:203:c8::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend Transport; Thu, 24 Jun 2021 07:50:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 310f9d6e-fc39-4d42-90d8-08d936e4b522
X-MS-TrafficTypeDiagnostic: DM6PR11MB3148:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB3148684A129763B0A27F841F9E079@DM6PR11MB3148.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: arDsDGqR78EGv4DBjSrz/aQiN4JGwPDFLF7uU5E6qXaytS74uU60SKuTySXay0baFK6PSYUIjouni6VOAH9usQa56O5H+lh5J714fpOHSseBKEpYXDREeQlMt6XYCMPtd8fNleH+Fx/b2PZ6zHsUSZuYSj51483dSJvpR4noCEnKSOofhK348Ja5xzuZngLuLRKv1r08VONxGKyPhBzY8VG8X8yfPSu/AZAus/FSg0D4qU9Snaln3cPVMfW6tExDJ5ahDcUF0GyvvuCpO0Z2+kyrmJTcTjDF4h216G2RPu6YwTIxjN/qnsnlPBRMvxQZdNdISOHvDzEUqLGjndxazgy1/x/kLqfOakoWdytFfnKjR7eshTM2Lk7ionnbYLD4Rwn+CErFec7cBzmasGM3bNGHZlDCdrMr5DVTIdJS4n9u82bnLvjHId9xlmYQRZKMHeOW75KyQwOp2iJhDoK3/avRsqITkxnAQmHwkKHF5llfRfw3fqLMle4wuZUZFwoxHbLzZB5bJZ6JnzM4TR8HApwJkdUiwXWVHFlik2pv6zHU7vx9bST9dlqaZcMSikXZ529gH8bsBXLQRbi7ycDzXh83FyTRSnr3zE/q28qeJpy6YXi2j0O4eakROku4sGkoWvNj6V81glarwZ/K0GWTw+PBcvYXKQoJsc4lFF6gzisPiQ2gLNEANtmbG3ev68wxBlGpdgauaKHBPS3EjheOMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(136003)(396003)(366004)(376002)(16526019)(83380400001)(66946007)(186003)(66476007)(478600001)(6486002)(2906002)(86362001)(1076003)(66556008)(107886003)(8676002)(316002)(6666004)(44832011)(6506007)(52116002)(36756003)(2616005)(38350700002)(110136005)(6512007)(4326008)(956004)(26005)(38100700002)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+tDgUSifTu7hY936iuYMVKG5SlplFJmeVOphGl4/9F8XW5m4BVYL5MQmx1le?=
 =?us-ascii?Q?KvtCY/FD4TekI8tVFHMbLW1o9B/ze1zR8sDmBebBAHihSpEo2KyYsWPJHS1Q?=
 =?us-ascii?Q?HX4HH9q9o09bSMo3pDQgN3VHpiZckeq5Uk5SxkJxfc7wCQs2nzyAAp3VXt+B?=
 =?us-ascii?Q?gsu8qmqOzyuR4ArETeRd/KCmy+u27gZhcxOzOabPsCvhTbWk0jr1jiXjEIlV?=
 =?us-ascii?Q?XT5DyAZjTH+4HS3xB/KDJODw4ugSxV751U5NNV/ePtVBB8U70PMJzhJHTOmY?=
 =?us-ascii?Q?LN1TuFEzQYGZrVa/8xWI893o89/Egqdr/rqISZOFjtMdxzEJ7Q9eefDSS1qt?=
 =?us-ascii?Q?LKOGAwAdzkCeRR9zmMLQuYmnclqzLBJnfalUZMUYtQPzRLQsFc/qI+JCsyVP?=
 =?us-ascii?Q?WZruKW66qQ3qSXdc1fiagG5/L/hdqFxhXkqTQL3QetA8OVqIkNr8LrooMxM4?=
 =?us-ascii?Q?RRL+QUASEgevMr5Lk9iJ+IPj38HkJ9cUNO+7409LQEM+C5n93EcysFIPqJwD?=
 =?us-ascii?Q?WrLl/gV/9HQJazo2vGQplgChDmoiZphoWVchHVB8FOr3WOoh5tAqw3DeCrIk?=
 =?us-ascii?Q?yP4Hl4Vp67qSrb683PFdd3oWWcBk6Z4sfE/CPlzBYfqvbwzl/OgQIFMZVV/N?=
 =?us-ascii?Q?AM0/tPbCGAVZ3snDPamLhyqodGVxrEREHKIurc+SdfLcFQs/bzlDLMQGyOWM?=
 =?us-ascii?Q?YEKCAVFZ8VykxKq4KAsjLVcXnhs+SSz30WGUZxYcvuaNkJafYPSzfXN/irZV?=
 =?us-ascii?Q?W3I7XSM0EeKUwq57XZnR2h6ynku28GBaHqsBuKK43n5L1HlA++BoQqDrCzTo?=
 =?us-ascii?Q?6L3QivyeI9ZiMd9kIbuOrccH43T7410j0w8QFzorezIB0D+Ns+faqJNARwnb?=
 =?us-ascii?Q?ArgkK2sSY3lqlhNSqhkl4DWofIJIqmdS18A1mtDpF4ju4jAkrDZkaYlk6Swb?=
 =?us-ascii?Q?zdlFMaTpxoZ5G1USJEKJyODc1Vn+gVM3A9n5MdwRk6dJCACAjhYWpH/vU3a3?=
 =?us-ascii?Q?ZQwWnrV0yVSL3OQ+nCHKU4rQY4F2+DYujBvn0q012u6dXPljc6nu8G65xPo8?=
 =?us-ascii?Q?x9LQL18ZvR3TUeusFCAxBspWeJGiFS8upCChUXef6PsoQaRhDb+psIjCEQeU?=
 =?us-ascii?Q?UCcCGMlO42hC5BrX61Q4EvK0vLqDZ1JNYaZDG796LPPIbMt4JyP4f3m8g03R?=
 =?us-ascii?Q?DrmgMfIRkeAyqdiiCqs/cRVsPfRTSaeM6uZYyquk2ORDQSt3iYDlwAkQtfak?=
 =?us-ascii?Q?KNKMQ5656z/h+CaLlWaGpGhmt90J4HFbvl9qkxM11S5/++/Edppw2/b+bcH5?=
 =?us-ascii?Q?vdll70veVJUrhxWOyv5lD6Cg?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 310f9d6e-fc39-4d42-90d8-08d936e4b522
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 07:50:17.2375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IiImf0ccw70SoY4IFyAVpP21FPsCj8kYeJlre2JpdIvbaYWu70VE2sl8f3hbTG8OzwO01j7CCgbj3BP60+RXS6BYQGRmHqmp0kcoJ8qBC80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3148
X-Proofpoint-GUID: 1QsxfaJxwjY_TfnL3QW7BBzq9Od1dcBc
X-Proofpoint-ORIG-GUID: 1QsxfaJxwjY_TfnL3QW7BBzq9Od1dcBc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_06:2021-06-23,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 adultscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106240043
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let MAC80211_LEDS depends on LEDS_CLASS=IWLWIFI to fix the below warning:

WARNING: unmet direct dependencies detected for MAC80211_LEDS
  Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=y] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=MAC80211 [=y])
  Selected by [m]:
  - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_INTEL [=y] && IWLWIFI [=m] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=IWLWIFI [=m]) && (IWLMVM [=m] || IWLDVM [=m])

Signed-off-by: Liwei Song <liwei.song@windriver.com>
---
 net/mac80211/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 51ec8256b7fa..918a11fed563 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -69,7 +69,7 @@ config MAC80211_MESH
 config MAC80211_LEDS
 	bool "Enable LED triggers"
 	depends on MAC80211
-	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
+	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211 || LEDS_CLASS=IWLWIFI
 	select LEDS_TRIGGERS
 	help
 	  This option enables a few LED triggers for different
-- 
2.17.1

