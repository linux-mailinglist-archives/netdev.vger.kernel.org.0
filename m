Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FB0456857
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhKSC6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:58:07 -0500
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:40296 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234175AbhKSC6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:58:06 -0500
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AJ2rJvS005047;
        Fri, 19 Nov 2021 02:54:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=QetabUHB62KwcTYrS8cFeLR+YV8mbWCEkRBVIrfYTU8=;
 b=AUdWJyDBZdgPU/ZHyRHSjw5F+iDbMN9b3RUFXRIfN9EEICxlpCbm/0NQw9Q6qe3X7r4a
 yTkE1HiqIr491BznDNva9yiSGWQe7TGufh9xNqPyJWmFUWbibUkqucvHhLFWQDPd6S63
 /0P6UOpC4cYl2ZfQG0bNzRVEvUi/Xdxz/EjIw5oSbHLAUrzT4Amuugnk4mNnVreaFfUg
 y2JzSteQ6rKrQPhurLNqQ3JaAW4s8v2kSNFJU8/yTjTOSyMo4KXtB4s3i+Z9E/WAmR6q
 NgIMFILRJ9xOxuu1ojzNs6jHfWg4IYSi99tx6dPXbFbL7sbnQ+0NCTZehT1n5n3+gDgb zw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ce2sx00xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 02:54:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbnJxM+EDOGCLhEp8C4sd7XGZWNlqNHBNe45nlcBrHDcKRaEh7c6UZKBfda42Gxx8ns9hTeSBxuhq6FuwzWs74hbdA9e9F/0OtcJBKyinjPRkVDAA8cuYziZ9sYZEtrS160yYTjZJHOWGEDJx8oQiqOpQ1PMUNkWO1SPob1HBCcPwxblraKmTqutJZh0YltKRp2XOoB3FLxSNYKhYcbgcbDehRwTqHCD1loFV1mQu/MXz/pw1MGlsYOuY4I2oRanJh66Yg8kV1xc/Wt4AZdDYX8jgLounGSG5bbxFgDUlK1ZDnzuFNk5mbpNl+zYQQkvhdbrnj5QEfgFZCukWt2g7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QetabUHB62KwcTYrS8cFeLR+YV8mbWCEkRBVIrfYTU8=;
 b=UhcbdfrGjSU0WzCQRvHdNy5FvezllvDQB+9BJXteB3pAh7nmElVjo11UuXKpB4T3JvKvSmv4DHD8ObcxsC9KQRfNUU/+leg3EvZVv7ZS3ZH/xCYufzyqpjXc5McqWb/cwkWsgchARr0WVl+Ggac1D8Z9PSltmgPHmdQCkrSdfi69dWdebvl+nPFII0HJeX7oyXmxAF5V5PfhWc5An4piZOB/HG6+207wPP8EThcaXzLxrzVNSE9TcJHrv2AzyatRtpcFFVyZtiuMCPgM68YOOxW7i46LJv/4Nsl7HkIC6a0kgBeHdm++UwAeGRO8vCHXQgYrHQ3GOzfP1lbENswntQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 02:54:30 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a%9]) with mapi id 15.20.4690.029; Fri, 19 Nov 2021
 02:54:29 +0000
From:   Meng Li <Meng.Li@windriver.com>
To:     stable@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk, andrew@lunn.ch,
        qiangqing.zhang@nxp.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        meng.li@windriver.com
Subject: [PATCH 3/6] net: stmmac: fix missing unlock on error in stmmac_suspend()
Date:   Fri, 19 Nov 2021 10:53:56 +0800
Message-Id: <20211119025359.30815-4-Meng.Li@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211119025359.30815-1-Meng.Li@windriver.com>
References: <20211119025359.30815-1-Meng.Li@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0017.apcprd04.prod.outlook.com
 (2603:1096:202:2::27) To PH0PR11MB5191.namprd11.prod.outlook.com
 (2603:10b6:510:3e::24)
MIME-Version: 1.0
Received: from pek-mli1-d2.wrs.com (60.247.85.82) by HK2PR0401CA0017.apcprd04.prod.outlook.com (2603:1096:202:2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 02:54:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecba7704-33f4-48d1-2dde-08d9ab07e80a
X-MS-TrafficTypeDiagnostic: PH0PR11MB4951:
X-Microsoft-Antispam-PRVS: <PH0PR11MB49518A6D0457054E1324AE93F19C9@PH0PR11MB4951.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:475;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q+kmbL8VvsP5xKMwZnr47k95kbXss7MFoXObJjhfbmvVwExL4mJKL/zL5jdYPlcGrEt4iusbdY+q5VW9PcbKdX7TjIwoyOh9MCldXCGBWpxLCxjHryyLkJesxueEgSf6g28GbS+gJNTMUZjjVJTHdX7G8X3diCpZO6koFRY1XsA5h3f8pk+a3Cm8x1bxiaOUcMPdpJsvyGD3W2QXf3UYa+2S3mx/Dhw9dbT1XD0/0MtsdoBlnnUCurjiD0HstmIOv5NAfyQEnicquHj/5fG38bg6bu5mo3mNoVvblH1+203V2ICZVZBhTYbyq22+77bbeVl3I3CXpZE0rlUsOY0OLN57wo0ZPgtxwaXcOjG/Ful5ShjY9iioW+PSlXBu609sg+QJHnMYiqwwIs8yCHraq1NIEGmh9zIkNaHKzsZIGLa47q0PmtgMV1YS9ljT1nLVRt16enF3OGVwmTC+F5QtaZyuowZvUlJMBB00OATcB5z22lrxh4qPO8aLPeQeAPESa6a7a0vyiXZgjYr9/m+oK52BxHV4LL+ANTeAzpeq6gVCRhUs2Psp8bOfG3r999zqbyCzU2F19K0FDBV+chJzF+i1p7pkD1rDpSbZnxphtx1TCl+Ujc9NGFSZ/b2qugiYQJ7QWpDofp/QuSviJrrtQchHbGPhKTOk7LdTFBB0f7155urciRLGtE8hlE3h5i4/AlockMlHAfnTSNL4KuyVHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(83380400001)(5660300002)(186003)(107886003)(6512007)(4326008)(38350700002)(38100700002)(2616005)(508600001)(8936002)(1076003)(36756003)(956004)(52116002)(66946007)(66476007)(6486002)(2906002)(316002)(26005)(86362001)(66556008)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KBrzLxz4s+5238+NWlgl3/RZUlGvEjjGN2lCjkCjWYI5BibchdzZAnYbqK+v?=
 =?us-ascii?Q?qD9KFf4O8c8y8Av834trrrThqAflDlkBfBQnvPWE+S/LtkwRzYiFJUXzPjdz?=
 =?us-ascii?Q?v9qK6tJEh6w+AsKoGrngc7BpnjUKjp3JFG0WQUOeNnNNTn7IrM7G7NiVAj3l?=
 =?us-ascii?Q?/JikqFb/rC64RPC1VxwhBeDlRlbJRwFDDBFIm+19VulFw5pSsNbyHudk5kKV?=
 =?us-ascii?Q?eHil3Ex8TLB/i1fqMzmKeIOb46YwW29Ww3hXpSklX3HCtu0BSFu6rpFroH28?=
 =?us-ascii?Q?vbacH4iCYA81IikRK5L8qmpzBiy2WDdMOC8aCkoTXvVn2fyt2ZBd8sKnIbo0?=
 =?us-ascii?Q?AiKTDjeGQwBdTAqKBW9O2lJf6h7cze0VrF1LFqp0CnheIHGvP8KjRIUFNViC?=
 =?us-ascii?Q?o3Euu2RDwxINpesZ2DaRKIwS+fNVw09FjF4q4KZ+Oj3kx3nY+go/bg81NnjB?=
 =?us-ascii?Q?2HnQW7hIlRX2VvhV1a+X3kOpwbOnrjF7mNloLPLFMWOm8u8XgR4cZ1G+S6/p?=
 =?us-ascii?Q?wdMldbJIBLNWNMYqlaEihHjjo7IoKTrVZ2jJGwjILv40ZUdBtL2EYM8M+pSa?=
 =?us-ascii?Q?4o65/IkQ/1Lk+y9+lbcfNdBW5vGECkzis0NDI1z+01Yz6zkE5GPJEjTrYyBj?=
 =?us-ascii?Q?5OyK0hVweAnMI82x6cyw0cmz0eJjEIfX0iX80SbaBQHoluCORQSFJD0TeVbp?=
 =?us-ascii?Q?Ev55ut10OpL5lFrIGLF7EzTO6xPsDr6yUltGd4PieiYOnC9d0VpH7OZvynVJ?=
 =?us-ascii?Q?QAx1pL/rJo+2IH7ZnXIXPr8V65QKjK6HkxabX+kR02+Pg+WeJRLY0D/loevL?=
 =?us-ascii?Q?NwzQNojE6sLS1wB2CwwU4w2MHEkwYRDUtZYoQpY2RfiBZbDrOaUN2DFfyc1t?=
 =?us-ascii?Q?bNaE+0I6SIZ3aj/LAYPKax2HDTx98P+cWk9IwQOdTkGWVrEQrznHfQ+lC0CH?=
 =?us-ascii?Q?ph6cWoczwAFNPrGTsAMjtl08mW9FNqYkK69u7muOmch53yxRwboTh/F62X/X?=
 =?us-ascii?Q?uc4l4U8StdmYNPq/ezClt4zaXa0/unT7DkMxEX2WyAq4lAsCjLeGCTldRQ/r?=
 =?us-ascii?Q?Ysyy6s8hm7rwVTv4yhxPfJNaFIshcNky110xgasGBKxgNjHi5h5hz0bH9Tox?=
 =?us-ascii?Q?oqRtaBYpFk6eXwOmUyZEarBaMsK8jXmgBssxmvxXAVrrBa3E08rIL+6jrnxJ?=
 =?us-ascii?Q?L0nWzRlS/69C063gQ/wyaZXXrKl8IE+OYthCNBRV/w3Gd44eu/FmxOR5iT/V?=
 =?us-ascii?Q?G3656++8OyylV2LqwsWmjAYb9mpRQ8vOWizdAlZetinY9dyzeN5h7Rz9dhjS?=
 =?us-ascii?Q?zk6+OONtoPmRIOoYNLOA25ZyPOLqCHM6MDmZS7XDr4kZ+8g/uXqyxXYOj0Ed?=
 =?us-ascii?Q?JHr/UtYRTmcH08tj0UVEGIWvy4glAig8nsO69xTGoIgEVLcquVClT+tqJXrJ?=
 =?us-ascii?Q?r6l2CPYLxL1jGMsVk+AXV+yTBHL/RkWIOzR9vHCerd9gRsVmD2RQpOzTA/9l?=
 =?us-ascii?Q?IbFFx7oqSyzk7uNiocFNG9mK+C8q3NMHg1U/E9CAsKIuFj/NJD/mv+IVRPeg?=
 =?us-ascii?Q?qp5TIjDqNemx4v2CdfOUQt/2X4koKK2vH/uckeBnrKJ6AYV7kx/LKn5QkXGe?=
 =?us-ascii?Q?328FPB2uQtb5pRXIeKokNcc=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecba7704-33f4-48d1-2dde-08d9ab07e80a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 02:54:29.8575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ntf6THgovjvuH4AQxxBpBAty7auf/KrefaD0lxIBqFQPlFG8NZV9K/nTqfD60kNYBEzegG85Mb/Sa0bPTFYW5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4951
X-Proofpoint-GUID: nXMg5miZmutp2QQcomsupaNwMr3oRGkb
X-Proofpoint-ORIG-GUID: nXMg5miZmutp2QQcomsupaNwMr3oRGkb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_02,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=844
 priorityscore=1501 malwarescore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111190012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 30f347ae7cc1178c431f968a89d4b4a375bc0d39 upstream

Add the missing unlock before return from stmmac_suspend()
in the error handling case.

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Meng Li <Meng.Li@windriver.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 498962c4b59e..51626edc6a4c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5275,8 +5275,10 @@ int stmmac_suspend(struct device *dev)
 		/* Disable clock in case of PWM is off */
 		clk_disable_unprepare(priv->plat->clk_ptp_ref);
 		ret = pm_runtime_force_suspend(dev);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&priv->lock);
 			return ret;
+		}
 	}
 	mutex_unlock(&priv->lock);
 
-- 
2.17.1

