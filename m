Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3593B880A
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhF3RxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:53:03 -0400
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:11714 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232409AbhF3RxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 13:53:03 -0400
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 15UDiihW016280;
        Wed, 30 Jun 2021 13:41:02 -0400
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2055.outbound.protection.outlook.com [104.47.61.55])
        by mx0c-0054df01.pphosted.com with ESMTP id 39gsrm060a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 13:41:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTC9FRqv2cHsb7MysHMw1vBb3VPs+/lf1b9jtTaR7i4qyHlJ54zSDLFHuamCfqKDjnrMA/V1J4Fa8zkiz6ZJfWwjsuDjUYpYN2zOX1BoP1vxqUSUlmnS18cLNgavmlEzIOuQZIpPT++PdLPhR/1XYEvmhhR4+TwqHYQtBfxbYR3EN1JHz4QkpU3lpp79uPllvAj2hAY1AsjQDY7H+1uqrSDo+tvfqpFHmgFYGIimla0cSu2hJku1AoUgQ+qyRhS0Q4BAA7Plq+vC2IBtUfM74mgTFUV86YX86z5bj634Kt20YeWISmlnCiKUK1Go5ZpTpqvSdofydzRSunSSoXhvbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rjlrs0n+kLQF8ptDfr4+Lqw2yuisaTw3ed5sug3czEs=;
 b=Mh3biWEgmgo7YM+47A/pcZv9JPeea7qcJK9wTNGlM2VSBhxg3IGnD+ex5CX0sc8KwvUMa4CSWfkJUy7vMx79+kPJAsfmPixhkfo8oGSfHHm7MvlEwORDd4/ERRhRYorIY5Tne9HsdFpAEH781NAumpWRISe0leOdIG0I12O7qARCohKrixRFpg6Ad8vCVC+6Eaz8eaIuC22gYNAionEK/6kSXNyv/SIEdyz0f2kQuIzyTtVI+aylF4gsidVrqXugd/fPXNwLgg1VY0CHti1smBBOifXKVvU2Gp4SwD0TjPDGfZVxR6yzUptkOcNlsqebtE2kbXYDQdueIvjlb3TRhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rjlrs0n+kLQF8ptDfr4+Lqw2yuisaTw3ed5sug3czEs=;
 b=hcsFefIGs1x7l80ajyv9tEmomEbNrG92rY4yrrQDIXEGut1SQN/KeeyfECvuvI75n79jIdgLYewsDpmY/YG+zkxsISwZNDj00DsWmWPHxSy+TGdt+Vng2zPy/9Q6y6Ryi4XGCjWhUVSKm/5QKTSfTniFfLBX6FFuRVZsNTgDbBA=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:27::23)
 by YQXPR01MB5619.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:2f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21; Wed, 30 Jun
 2021 17:41:00 +0000
Received: from YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::88bb:860e:2f3a:e007]) by YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::88bb:860e:2f3a:e007%5]) with mapi id 15.20.4287.023; Wed, 30 Jun 2021
 17:40:59 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next] net: axienet: Allow phytool access to PCS/PMA PHY
Date:   Wed, 30 Jun 2021 11:40:22 -0600
Message-Id: <20210630174022.1016525-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM5PR10CA0021.namprd10.prod.outlook.com (2603:10b6:4:2::31)
 To YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:27::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from eng-hw-cstream8.sedsystems.ca (204.83.154.189) by DM5PR10CA0021.namprd10.prod.outlook.com (2603:10b6:4:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21 via Frontend Transport; Wed, 30 Jun 2021 17:40:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cef26a1-1bc0-4555-82df-08d93bee3922
X-MS-TrafficTypeDiagnostic: YQXPR01MB5619:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YQXPR01MB5619F4B3D2C4ED315D8C0D33EC019@YQXPR01MB5619.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6N6hmDiZTylDZO4ckEiM5zaEU3GnA6QUd9tH5j5Bu/00XE4MY4JrsoqRsM6K6ePM9oBTx6Kp0da4+Min2bqE8pNv9uXfJqYxrmxUJRjAPvQWO3ZDiMKndFSDGoJU8SkrBP40JqJDVUWxJEV50zuBfjGjElkq00PAUF0q8HWRo+YeBm1qId2XrU4KGaQxpacLw5cVZ8QLhnonD7AEUK9Q7L4PqcdtxVXAYyClc4wPtbs7wTVTXpLkIgSn4+hTWiQ3EK375Cm2QzfFA86Gvf0I6kc45J1EgEeB6hLiAjMO/rTueFS9SUaKmrdcqiaQk4DRcCS7dYiRuiYv0DRoXh+kM3NWfORRmq0Rdb3eTC789WA2MgiqsjelKAfZw91Fxe2Z9dx/fUdej6xdW66WHSTrxbklgPMdD1RJJltpHA8n+ylL6NNGHfTRux6I5zMmA79Gnk5lMbmswDTrOip2gZMfkU1acV4fqnZ3UfsK1SzKk1P3EeNWoaewWa21O/o9J0Uqd6pasWd1P15aJVbWE7+qfPCF6ZsBX3CC5cGNrpedWIumsXJOggREMQjKu1SlmkdJxShSqL/eWREQ+4nN5Sw+WDa/ObntIcWgownKSfhkNsFn3T/jeLiDwnq1O4wTZPRjUBLkn3QYSANBInTEel4zjLJMUSS85KytMmQQFXTlQiK4nCnk6F7slhSy2G/Fi9wwh1wH64s1lTlNcOwcqkSK3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(39850400004)(396003)(316002)(6916009)(107886003)(38350700002)(5660300002)(6506007)(38100700002)(4326008)(52116002)(36756003)(2906002)(186003)(16526019)(83380400001)(26005)(6666004)(2616005)(8936002)(956004)(6486002)(8676002)(1076003)(44832011)(86362001)(66476007)(66556008)(478600001)(6512007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?onneU4L0aJpy2Nu78i+ttAW82Xq8AAq6KoormAESmyzziqm5uku+s+cITTRE?=
 =?us-ascii?Q?DwtKLB9ykOLt2CD3oA5CvTfyb2tD4K3owvfmBZXw+LF8ur9gW0qhkdmu1BoU?=
 =?us-ascii?Q?FzPsRFqHu1AqBTI6XCSVBeUoD9xkhhiZp3Iw8k9AHeGhoxzhHL2Dx3uE9CuF?=
 =?us-ascii?Q?kf7ba3cFdZF2QUBv/JZSxn4GsQLqR59CbjUBXdc2tO2ZydOAJwe+EToSrYal?=
 =?us-ascii?Q?+hWPqHwcdn6VWiAch1RMWmnDdMFZ19TrNPIdJ8998TyGoRF8DkclM9eWM6CT?=
 =?us-ascii?Q?ivn3NmZoH4IEuKMQ6HzbRKXadOcQBs9OETEYmUIGd7LZkYGtsYs4ukoCVLdj?=
 =?us-ascii?Q?jUMOafO+czekBIH70MeLdRtRFtjPdhQaEnftRKlyLWvL5b188UQTLtwEB6gM?=
 =?us-ascii?Q?SVMsBv1zVHMY+R7NI7utqwqd9vsUcXRavA4kpr1JY66q/t8h5QiiwuMA7loW?=
 =?us-ascii?Q?NwFy5LyCOQX1fnr9iEYncvX8nCk01rAQNqRmPQZlOjX8aiF8IyuSwRa2KbhV?=
 =?us-ascii?Q?vTKcmJiDk9VOUe3CYh6AW743ZKWpGuhrnxRXc3oAsazv5qr5UMRnieyFs3y0?=
 =?us-ascii?Q?EqVMnzUOi+66ukxFEZ1qUdDAin4C8WCg3pTjz0WX2xbcnV7ssbLTfEf6hzKv?=
 =?us-ascii?Q?dtM29/VE66H4U6HagZBX68SHofap76czWCVJawrEp6FVUhn4Tb0Aomh0lewF?=
 =?us-ascii?Q?gtp52jU1vQH0j1xAYgLShRY3TYuAlQzRbqjrBMGOPe4lDns2TsYJm2wq7Vdy?=
 =?us-ascii?Q?PDghw3G3XlZdHFbDeOadfuqpssHIAiplT8Iy3o5X0jfjBPpLDwzsnOj4ijBl?=
 =?us-ascii?Q?U8R0iew/FNpcT454Fm0tA7M69w2ArVmkUXLI9EUb4GD82Hl+WzJASCQniKcM?=
 =?us-ascii?Q?lmtXIiijQbbAB5rY1r7zlO2DdMtFWsBCaIuQVtoBkIPrQIH/IpQhFwweIcto?=
 =?us-ascii?Q?IpXsRzW9S0ZhM+iLrGG+vfKzfn4+y1bVn8IMVYNEYh/OOEAZacfmTr77jkDs?=
 =?us-ascii?Q?uFkjg1SHiTYkDIgivuAJWNEjxRB0yMY1nmha4SHG3QjBQ3pPo1vhIIqGDxfA?=
 =?us-ascii?Q?NVpq4xu2eZV9qCAnspUxK+9VuZynS2JfPren4foHkOmZD4BcXk1WPrby40ea?=
 =?us-ascii?Q?O7oIX+owycDVl58PJ0I/q4XHKltVooIeZvHieNhNmrCn+cDZXxACY8u8vnhU?=
 =?us-ascii?Q?1e1i/rf8Zo6Vn7kc9V+6+ztuOi6vBrlQ11J3rIp1BFwPhII+AepX1Otvkt6h?=
 =?us-ascii?Q?dq2S+bB+Y/uBxtZFlFI9H409Xw8oGiS/fbd1On2E9O0bm6x9V9ItCDCa/Dib?=
 =?us-ascii?Q?NS+bRRGUNvfHCb/iv2elMFpH?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cef26a1-1bc0-4555-82df-08d93bee3922
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2021 17:40:59.9450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MydzsvfaUqZarPAgVUTTe/TX8qYq1uSvDEm6epOIZxYoVsvLHQeMllUarRNEDGpGOduXF6zBvAilTldv05O+xkZ/CdISx/HSzf6VRwVlOHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB5619
X-Proofpoint-GUID: vrnww5v4zIsEqdcJPoPHJt-8BbFNPsf-
X-Proofpoint-ORIG-GUID: vrnww5v4zIsEqdcJPoPHJt-8BbFNPsf-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-06-30_08,2021-06-30_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=814 malwarescore=0 clxscore=1011 impostorscore=0
 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow phytool ioctl access to read/write registers in the internal
PCS/PMA PHY if it is enabled.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 13cd799541aa..41f2c2255118 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1213,10 +1213,29 @@ static void axienet_poll_controller(struct net_device *ndev)
 static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct axienet_local *lp = netdev_priv(dev);
+	struct mii_ioctl_data *mii = if_mii(rq);
 
 	if (!netif_running(dev))
 		return -EINVAL;
 
+	if (lp->pcs_phy && lp->pcs_phy->addr == mii->phy_id) {
+		int ret;
+
+		switch (cmd) {
+		case SIOCGMIIREG:
+			ret = mdiobus_read(lp->pcs_phy->bus, mii->phy_id, mii->reg_num);
+			if (ret >= 0) {
+				mii->val_out = ret;
+				ret = 0;
+			}
+			return ret;
+
+		case SIOCSMIIREG:
+			return mdiobus_write(lp->pcs_phy->bus, mii->phy_id,
+					     mii->reg_num, mii->val_in);
+		}
+	}
+
 	return phylink_mii_ioctl(lp->phylink, rq, cmd);
 }
 
-- 
2.27.0

