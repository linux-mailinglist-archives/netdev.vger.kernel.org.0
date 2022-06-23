Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69069557D1F
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbiFWNej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbiFWNeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:34:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE942F38D;
        Thu, 23 Jun 2022 06:34:36 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NAno32003411;
        Thu, 23 Jun 2022 13:34:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=Od4l89a3OVr772WC0aaLhRrN7sfzg0w8uiqG2NmnVGQ=;
 b=DcGOZVQ2lSC6b8zRQxXMMbGXxySdzHSlybAJ85K8ymCdSDn2ltyNx6DNx7q7E75LCx0W
 rZqZdiObjW656Zj6+0+1/sm7dAlum/kOlk/a/16E5ej94g8HNkVpzW5lHvEen6ak7rPk
 nK4kl7T10wFn/PhqnL8oi+mo2nf0YAxYPjFyjzmj/qsz2rEw1lGTi9YwDdtr9EgHVJdm
 gcoSDkpabueto4/7q8afzOcPH5Ywn9JmWgLGofLHxUDxHBP8/TFfwCvXg2qQ/jcstQ7T
 LvLSBwABH106/OQYJuJbCA0BuPyxwKjvHFpmXyxtvDQ2rUV5uW8+K5z6QeqgoXmnM69W sg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs78u356n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 13:34:16 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25NDU6XQ020526;
        Thu, 23 Jun 2022 13:34:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtkfwn57u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 13:34:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YU4YSF+iadZ3jAqUd1vjPZSNZ55rtj6M3338MRxc3ycWY4VlpgDQSdwfbIhGwEA9DPwpsaKqfdi3WepEQA7jVjKw6mwvfdluR7z76aY7Bnv0mLw2aK6cGa8JAc54W+Pz9MS0xaYz2ZIm5hxT47lJCoNjWRcQn67mRik6KLKQwAAlPgUaImoYE+0EBH1YghPA58qg1wao3QqxF3gRa7tlqPD91dsUmzAIx9zkyHMybok9qHPxaAKnGRxTGESns7puK3RJFkXw6kINHbTJbV+kNiO59bN8cHqCko4HU753zObfGAX94jil5LwSAhUdf+niPAJDxDbsueNMexrAU1k3vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Od4l89a3OVr772WC0aaLhRrN7sfzg0w8uiqG2NmnVGQ=;
 b=CljwwC3XFSzFxpdd2+MR8akL6ivxHSiHh3066T49ToEV0J9doERyNZFvjD7QLb2iYDLlQHAWhbr3l6Cu8g/ATwGNhl1od6Hu4KRPimFbF5u5dtD7EO5YyXIqL3shdTYZ5BHR4O4Wv1S0zBKYy9JJ6KuBM31PXveqRBAdD2q9p44GNw8N+g3QORK+kzVKUtqeYVucH7pJ6qqFRKK+3HtSi4AkVEg4DrExfh1ocwGOXaDmXqxaE86GP7GWs8f0QNbQyFWIB3nIJF8Crx+aQPs6Jk64OnDpzcIn//TfHECL8UBurJQl9Rg8gBVdwz/qZC8/0PurZUt1kpEONCePIXCmng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Od4l89a3OVr772WC0aaLhRrN7sfzg0w8uiqG2NmnVGQ=;
 b=aiVfgF0aRJ+j5mGfI6XFjO02hPobhZCiFYLY7BJIBIbn8YR834Rqqt5q0XE0+5DN5AgViyI3m/xZL4Nx8f2wvL75II0iJxbMe9LalztFxeYm8asKHdjyILpb8hrwrANv2shyzwdPu2S1re0CYlyEmaKU6yDH+YVrSM1UvXHAl3c=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CY5PR10MB6010.namprd10.prod.outlook.com
 (2603:10b6:930:29::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 23 Jun
 2022 13:34:13 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5373.015; Thu, 23 Jun 2022
 13:34:13 +0000
Date:   Thu, 23 Jun 2022 16:34:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: lan743x: Use correct variable in
 lan743x_sgmii_config()
Message-ID: <YrRry7K66BzKezl8@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZRAP278CA0013.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::23) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27366cce-fd47-4189-04ca-08da551d0ffe
X-MS-TrafficTypeDiagnostic: CY5PR10MB6010:EE_
X-Microsoft-Antispam-PRVS: <CY5PR10MB6010A241D2AF42F490DC73A58EB59@CY5PR10MB6010.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ECILWQP0NA1Y67TyO9NFDO4uuQ/PsmtQauogIekX1/nW2YDiHaeb8O4alcIdfqnZJuuVTu4bHYfwxM+u3JCjwaYbtR+1iI+IWVi7LliwRcaJW20OoMzGkVtDQsXyMgqt8KndYpX/g52vL8OP13RzN0zLKLukynI6QqKnvqhlwWDJ3DZP30G3redhbigSmuUxgTmfTe8+UQjDXpN+GaB4cROadhiviqHfAT+NhIoGlo5p9/APjQPli3CMO44yrOH6tz6iMABlMFg0yII9+E4rKae7WglUhL2MPcSIlQI/rgrmThzH8fToEk1PghYuS1qGK7gHoFpp2Ocp4+T3w8S909RfPyCa9w3yni9n/R7rZ2pE8SDecmTFw3dz2QQL2QdI4017S9QiPrIBvpvy0x2tJcQN0yZK82e5+fs9alHXvigdpPtE5kEyxS5mLVDILW7ZQxS2voaa34x7tQstdxax44iggO9RG8BRJnH/8rXPAKv2m5vfSqUFr01Xxw67Z8tNOJRjrSsh6Q/8KinG74QIcxANrsEIgfUSsyZh2/9ockQXDX8b52BxctxwdMrFWftMB+SX32TfBJJEvha1I1/ZBo1tK8Xa0ucfaDRw1rW2gBSf/4ep0EAgqjtitF0GbCo4JpLAlu638JA9eOEM8FuKCq9yo7FlejwygskGF/X0w5bImOwpGp00Glw7CckaZlq3nA4DGdEFRO0eiUikqy9txfpYb95O6maJ7+qlh7Inb3AGJuskJflF/5EP0G/xNHEk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(376002)(39860400002)(366004)(396003)(136003)(83380400001)(66946007)(8676002)(38100700002)(110136005)(54906003)(41300700001)(186003)(316002)(38350700002)(33716001)(4326008)(66556008)(66476007)(6512007)(26005)(8936002)(2906002)(44832011)(86362001)(7416002)(52116002)(6666004)(5660300002)(478600001)(4744005)(9686003)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+CUJYMGtZyHptfSDm18V+aX9xJNy25898TryzWhCANgXIySe4mvwURbIg7M8?=
 =?us-ascii?Q?ejxmA4oPxgxAnP0W+8nLJmCVGvASYnTPfRJj0axWZNgOqipyS878EvzO5/ey?=
 =?us-ascii?Q?Fjcm10ptBzpObfoCkRLNwx2PrFD48DZbm0VmgZiFxGh1lT9BmqnTvCypIhWy?=
 =?us-ascii?Q?J88VfR34177CqDTtcWAIUYIzJ3UVCElKl/lgZ6+xfAgm1LskL+nJN5nuDEsa?=
 =?us-ascii?Q?m9P8owsZOQ/1rgki4FRGwYd5ji3mlFsw+KbPjg0GkpnYsDm+OVUYSaVsyCzt?=
 =?us-ascii?Q?YTwT4h2EoDpgVm0/AFYR6nqIgVCjPjv36rqhYy2U4MZ5/OdtUpDa3tQtZvPE?=
 =?us-ascii?Q?xL3GjWlJiBJb98uJb1+ycYzMwSFe+/1GMWOk0bMKUbFYS1NOX5IuEtnTC7+v?=
 =?us-ascii?Q?BaXJy0nhw0No3AMcSZY77KMJf5DR02hExgilJyFqWd5wMBYD23cFM+O4AyHN?=
 =?us-ascii?Q?+mZ8/jbyeETT+WCMSsLtcgok9j++m9mScXOlWgtVtaZyQM66hWqPEpQDd0jI?=
 =?us-ascii?Q?7wIz/ZU5DzMHCm5Kq1XF+q37HZ0uia8sat3zU9VHTiBlwcVUA+B/1d+Wb4Lp?=
 =?us-ascii?Q?KC881N7Bp2FSou9fc7/CzeGr2T/dcBLFerQ5aDwQqzCzj33axenCvJjLmuEx?=
 =?us-ascii?Q?qd46hxKUDmTMtYMse3rmL6aYLeCdw66N6KNY7VgC5eSnCYs182U5a60xDcJu?=
 =?us-ascii?Q?WilyKUOY9TMHqsWrThgjAcolKBdQ5NMh5IlHvNlTWEv4L1VM4q7MykuqYqIf?=
 =?us-ascii?Q?lS2d/7LYMB8vUr/VR5kWbzlQq24z0Evk3sl3/4pH0in5Q7BvOJ5ZMoe4Y9yl?=
 =?us-ascii?Q?MCy70T8yiCEc04U+sLFvli/f8jAjzUHpJhHWlT5+KYfGJRztbsOpzhQHhcU6?=
 =?us-ascii?Q?8X/P0x/jNZgj4uT5jwou6fBfd0+ywmJYED+vAlWO2QbzEzsCXTzYA5+YODd6?=
 =?us-ascii?Q?9Pf/QIB5CQzHva6chN5+LHlI2Q2GOE5TRdDcEgRVU84soe0ANJgcC/VZDFbO?=
 =?us-ascii?Q?2xsfIMRs8vw2nrjJ3PEeSAEzsGZByABVJKP7lueiN4pUE8jBRGGWBSwvCLKS?=
 =?us-ascii?Q?GFgXgA2pGlImStzUASL4NbOjxNrbMNW+NR6TJbNOb6K8rHu/U02TereY7pj3?=
 =?us-ascii?Q?kQDo39Wtmm+58nbzyWnxe/0aAvnEmkpi83Z75gwto1v9SACEW3YX0uFMxCg/?=
 =?us-ascii?Q?FN1X3Ht7eUCmrdZQKKSnRPpoAWsG+LvJXjjdiAJuvnbJsm0V6IToq+2f+t1+?=
 =?us-ascii?Q?nVZacPrLc6TYHBiZ4LhxxHRP5TiFRQfY8Gcg1XDcj8etCR78aEFse8h+7VH1?=
 =?us-ascii?Q?nqzzDwIDw3bPIV6s2GPUhps6DriowpyxUKjaGySDRcQD3s1x9sW1tn+O9lc3?=
 =?us-ascii?Q?rYp2JoDxqHdO5gmiDerVpZBwP6pikR7RSjoJ2KEN3v90/WD6XoKuTwB5tGOg?=
 =?us-ascii?Q?CA/X7lZl4E+q2p1fazPOIrfMneUIzDL5MsaU+wjc0rCsMZaBCETMqAWLm7Q6?=
 =?us-ascii?Q?rlYkOXmGPlIarMeYrs4b8bkiCORzVviuV+I4y3U7CKHBPBaBXupZ9qIppbJC?=
 =?us-ascii?Q?AsWj8pw2tj26ZufjbWgvvOAPmxaFnaGqob5s77qi58r6+8wSJPnPsRzLRzfb?=
 =?us-ascii?Q?OQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27366cce-fd47-4189-04ca-08da551d0ffe
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 13:34:13.8470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sH/yXbJmHjTQ0aDArum+13RgCrCl05LP/kF5N8KrBw3jd6gtTBCr2FjZgm6FHAGWNfmX8kX0hCZoVDIV+Q+BuEAbqrKeVP5gm8rorlai75M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6010
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-23_05:2022-06-23,2022-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206230055
X-Proofpoint-GUID: WBgDOGvc39lDNWovzwG3jnyOKthSiULw
X-Proofpoint-ORIG-GUID: WBgDOGvc39lDNWovzwG3jnyOKthSiULw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a copy and paste bug in lan743x_sgmii_config() so it checks
if (ret < 0) instead of if (mii_ctl < 0).

Fixes: 46b777ad9a8c ("net: lan743x: Add support to SGMII 1G and 2.5G")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 79ecf296161e..a9a1dea6d731 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1212,8 +1212,8 @@ static int lan743x_sgmii_config(struct lan743x_adapter *adapter)
 
 	/* SGMII/1000/2500BASE-X PCS power down */
 	mii_ctl = lan743x_sgmii_read(adapter, MDIO_MMD_VEND2, MII_BMCR);
-	if (ret < 0)
-		return ret;
+	if (mii_ctl < 0)
+		return mii_ctl;
 
 	mii_ctl |= BMCR_PDOWN;
 	ret = lan743x_sgmii_write(adapter, MDIO_MMD_VEND2, MII_BMCR, mii_ctl);
-- 
2.35.1

