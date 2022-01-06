Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB7A486404
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 12:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238692AbiAFL6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 06:58:21 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11886 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238602AbiAFL6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 06:58:21 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 206AJlJl018918;
        Thu, 6 Jan 2022 11:58:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=VICRXe5mgR8w7eiIayeOOttRpxpfMLpgmYGF85O+ZhY=;
 b=t9ZBlsqfHLNbSPDRCKq/MO+keydJp+bWjSV4wmEsDjDFMRUBVyCLSfWXPZO8yrfAyD+v
 TsnJuoFdcy8W8WlyICXB/Gq04y98VIQ2vXTB/LfQQMpMAE6RMiH8gun1UqzowUl/PNU/
 4bZHIc/f2BS9YXO+L2sTjPzin9Udn4o+si1Arlh8OKM9VD4FGFsWdaLpunprpwLTZZ/x
 Nhn2EdqThzBN8F9g2kCU0cA3XeNSgt5FjKq8QablSogbd18dqWAB+AG3GlUiJJ6IoLXp
 V3PPA/5uuDyhFSDJSxMbh5sqvDbiBnaNS3REe1U83LMG2fE1Qighor4+oc/Xt3ykxEG9 xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpp9gdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 11:58:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 206BtLKp116694;
        Thu, 6 Jan 2022 11:58:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3020.oracle.com with ESMTP id 3ddmq6m8qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 11:58:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGznkFFEQ4MwjVZyhZpDlZy+nslxTAikBO5jZoRhAAxymTU2C8Bekz7CTZDKB24GTtU+0iUlyilzJYozP1FtZfoSyXiYmZitap6HfixtIRUfiR+3x0Iy88PJPmbZPWPL+iMMONuJqqDNcbOk1RZjh0/4Zo94N0LzYZBVUXmRZObIEXhygt2gUvNheKtumfbmwj/y2CjHIgi+uKnl1433UV/bxWrbFlwGbZUNaqe4HlPZRoS34Y3FtJmaNRU6EJir2SmKsbsbIOaCXSimvzzExeEJFWeKr8CLrVSQbiEjYrSVq8pKlze0uB3TX2KoIT26rS+keyvwp6SoFWS1AnFBgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VICRXe5mgR8w7eiIayeOOttRpxpfMLpgmYGF85O+ZhY=;
 b=Q+lpQF3vfFCS2wbdVcxDN/b2tiIrZJxA0rfrHBpBg8Xck8tLwyYYooVkFTMV0pBhWL+dGhYfrmGhqfck41s2WEt4AGZILuFoHSdMWeMn+cWktWoHqGNG3YYu7p1WX51qcEaQHbX/tFhdLM4UUQDewgsZfHBNyyYz7iUxUn7Jw201fdhuxtNXTZ6uCvSHeEV/Aoq/pWo9t6XCHaL9kZX4mV5PAra9Y9GZT31ml7l/lyn0KgPoE1yiZC9cH6d9lhBGaBdFmbyicVMDLFOmmHFXG3grDt+QGy1c0flYeFp6cpaGtT3/k/xGDN9G8BcRjBMiX2N4b7ycqj7RVAcrZE0oAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VICRXe5mgR8w7eiIayeOOttRpxpfMLpgmYGF85O+ZhY=;
 b=BjXs3VP14yNvKpoi2qUUdBo4BcYrbtAPYw0m6p4BMhFx2CI6LTdWHjr3i/mUCYvQpPTkZV80VKflTUOi9iJ6nlhlLT3CcFtya7byhlzJUob4y1k2L7uQ1FTpSBOCdLvQ3P/Kw2rWXozRbl9Em2pDrxH7TW6S21hmO48jCRcFWoA=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by CY4PR10MB1750.namprd10.prod.outlook.com
 (2603:10b6:910:9::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Thu, 6 Jan
 2022 11:58:11 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::38cc:f6b:de96:1e0e]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::38cc:f6b:de96:1e0e%4]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 11:58:11 +0000
Date:   Thu, 6 Jan 2022 14:57:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] rocker: fix a sleeping in atomic bug
Message-ID: <20220106115754.GB28590@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0182.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::15) To CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0405345-aedd-4b27-5243-08d9d10bd011
X-MS-TrafficTypeDiagnostic: CY4PR10MB1750:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1750D4F542356E41E75C0C758E4C9@CY4PR10MB1750.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OKtfM8eVlD+mISVusBOY6kx6Ex/m6xX2bl7RDu8KlqTlMc9KTKOg7GJGpbjSvHImkSlVK0EyfXSJpjl58FjJpws+3CBeMsBUopJ3/dH7/C1LP/rUpp93UpHT2xhg/ENc/2t2PtyZ1e3YRHlWdOW1KfqLO404wRkBG4rsod8rTtOcDvJ38QgEHxIciMreWmtY6u7nYeRmDzj5EAXO9wC22BuPZ34/DqtpjHdIJ3Wqd8sszJTuD5O5OPhOc1QnP3t6r7b+thta80tt2x9r5f/uazpnSzf1JqBohxnhZJDgzSSAffQ8E6tNmBH239joReBo79ZZCqhvIQK4+2g9owWOmiANPzKsH2TbmNBZLHjgUOEJSBF9spATLt1EYsa/6CyS01nEczZBeMR1sIKawM/VXIerHP2eXLeLjOHalJ7NSQ/XXkaOdT4IaRxFqvGyOLJKACEHoFxVTdDUXqLFSdUlQI4H9BuuKC+6zrxxa1OvpPOP6TLXro+BDtLEwer6axbf1oJW5iDga7yS+qaEzd4kTFreywBSHHGPpZLMip79WfWJi+9KfbSSqRoaImv1+mUmKGhA6AViGDUZGx/nTUIFFt9rQkC+99FDBzZb++OduzMxkIsj1DQ4GpFuk1AGchtauj+ET5coF9rsju0JiKlB9dgSmWjJq3nMNigRn9eO3eoVbqtacQqCNK300foE9bETzxrVNHhCYUVHx92cS6bKSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(5660300002)(8676002)(6486002)(33656002)(508600001)(52116002)(26005)(6916009)(86362001)(4326008)(6506007)(66476007)(66556008)(54906003)(33716001)(6666004)(186003)(9686003)(83380400001)(2906002)(8936002)(66946007)(1076003)(44832011)(38350700002)(38100700002)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I19MKd2fFRlgveJrHbFvM//ao3srBvbhC8mtVOIKWdWcugXEY7YXS2YZCaWq?=
 =?us-ascii?Q?0kdQdWB9NK7P/hiJl9dzu9XGnUoYce9AJvOd54VjWShKFOu5bx+tEqpQ1N2R?=
 =?us-ascii?Q?dX5fCKjs1Q2v7VQpVQNd4Uk9cdg2sxTnJ+cFTuI+gXWrFD0CuwsRAsSIDKeL?=
 =?us-ascii?Q?phBV7w+35h5dJxnozXGw+PnurDEb8g1PQgWX92TYNSZXFS+LwWECjGdqcYih?=
 =?us-ascii?Q?xz+fMoQX+td0TZEYAc3kHm5EzUbLz2xaqdM/mvLFtFKnU9A7EGYM+bX+PLxf?=
 =?us-ascii?Q?z2BjcZW8VOczmqbQhI3HHz8CBQk5r0TqAfq33TVDVGj/Un8YYM2JgMKUJ8uh?=
 =?us-ascii?Q?4tuLLM8XY7MNNBlOUt5rBBcoL3PMccfBg5zl5JHQPdyR9tQfoNKbxLL+EhXB?=
 =?us-ascii?Q?HAkMNNtjcAahwPvoS4Gghou7SrxNgK9+DqrmdnaR8xN4FUrXEOw1/YqNAgqW?=
 =?us-ascii?Q?HdQtzdYckUF7WJ//ZnxGlp3HGrb+xOfcRq0jOComh3YaUwh9KhUatY0jsaH0?=
 =?us-ascii?Q?XxX7KoM1DtmXKLzYlsqeLZ+gezX0mMEoZVTtH8P5Ju8xE4Kn6WjwUKiSRczl?=
 =?us-ascii?Q?YNhr8Dj7J7tbuKOC89/mWIe+iI9cPSH1/ZuRsMqLIvJV61f3fAWSKAOkTc2Y?=
 =?us-ascii?Q?Or4zGAQL66kq+9po3aa/FXzwFhUwUxfygko6anZPgnUAAYsxLu/zqMKMMnPT?=
 =?us-ascii?Q?b4xXd4iLTXt7r3qWhLXZL+l9UqdIuTs50tHfBmQoPueZqKuy3TvIRw1rEdyT?=
 =?us-ascii?Q?/jPS0OK0NZzraTcLat8132Cz33Ht9aFJx8lIaiOoNzuB3tKZGyIkKSMrJWov?=
 =?us-ascii?Q?DXdIjmbFvHdvYSBGOrA6aRGqlQfD8JFQ4kHSkz7t+vymnO3uZmBzgjO5JlOr?=
 =?us-ascii?Q?OszsPoQMPdkrMa6Zq7GyqwZc12JrOmvlA64MaG5DfF4zRiy8AL4G0ockQ1Nn?=
 =?us-ascii?Q?hdIW9f36chmqs5PxBUdua899Iekv0MSZBrUUJHhGwuTmOWbZLgS0SQqCcmih?=
 =?us-ascii?Q?jOum2Yv2r4XSdWr1Awu6K0HjulWyKWvcQ+nGha84JjDdkMc0IZjU9LojbNxa?=
 =?us-ascii?Q?YM98NG14Uj+XiMTkppyqY5o9ckEgqTgcL0XQTipjigE10Cd6o849ztt/X1X6?=
 =?us-ascii?Q?kES0okqB4Vlpw5w+3MfAVdN+OQKGN94qZthLcyDefh4yfaGu6JZpopRFptJc?=
 =?us-ascii?Q?dYVC0IPF0hOX02nRqBAB21aHGwL7JrDT/UkDOWZl/KmEDVOxFDC6OD4hZ1P0?=
 =?us-ascii?Q?bT95i4lEoPriHLIiOTA4iKnJDfVJm0GZo531RcwJFWcE2evChkA5VyD69UwX?=
 =?us-ascii?Q?JYAm1vuPdryA7DgsQtmDA69ScgaPwedeP6tzYyLkXj/aY7loVr1lIWZHwaWV?=
 =?us-ascii?Q?0EXxnbGSZmKTeqDH7Jv0LPIm1bXtER5RHLgSRbIy2Tap6gMZ1UwFTCrkUIKm?=
 =?us-ascii?Q?PKdUKi3Skiykfn765JSIHYC6TZeFC/SYrCv9hfG5XqJY2MdIwPMdWf0qjW4h?=
 =?us-ascii?Q?/u2FqRM9v4schG4K+9HQaBWxOhm/pNUH++1SuXEKf0PoNkpC/YV9KEPhjIZQ?=
 =?us-ascii?Q?OHGtW3dAYsOmnwW8LQ3+S8LeNgpYtPcPaVFkJf1MZqv3gwafMg56Jx8B+X2g?=
 =?us-ascii?Q?gRQ1OwYYl4baJ2rTieq6kCFV+CEu2R0AGdcTjyo0RcgsJ0Vu7rrxAUWEvUka?=
 =?us-ascii?Q?0q8OYFGxTZFnHNNr2K3UDavfn0Y=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0405345-aedd-4b27-5243-08d9d10bd011
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 11:58:11.6371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hxjWdmotZ3A79/62bPY6VHpD33itZt7sThi5eQLTwceDtQWrhtZhLxWmzJX1hpywnL8tTX0yozFSCw6nMjZpq6LY1dQV9fJk6xKF3n7jHDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1750
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 mlxlogscore=886 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060084
X-Proofpoint-ORIG-GUID: bHvSAkkRL3YAZ5ZtizdvXwRmSZCJP4vp
X-Proofpoint-GUID: bHvSAkkRL3YAZ5ZtizdvXwRmSZCJP4vp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code is holding the &ofdpa->flow_tbl_lock spinlock so it is not
allowed to sleep.  That means we have to pass the OFDPA_OP_FLAG_NOWAIT
flag to ofdpa_flow_tbl_del().

Fixes: 936bd486564a ("rocker: use FIB notifications instead of switchdev calls")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
From static analysis.  Not tested.

 drivers/net/ethernet/rocker/rocker_ofdpa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 3e1ca7a8d029..bc70c6abd6a5 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -2783,7 +2783,8 @@ static void ofdpa_fib4_abort(struct rocker *rocker)
 		if (!ofdpa_port)
 			continue;
 		nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
-		ofdpa_flow_tbl_del(ofdpa_port, OFDPA_OP_FLAG_REMOVE,
+		ofdpa_flow_tbl_del(ofdpa_port,
+				   OFDPA_OP_FLAG_REMOVE | OFDPA_OP_FLAG_NOWAIT,
 				   flow_entry);
 	}
 	spin_unlock_irqrestore(&ofdpa->flow_tbl_lock, flags);
-- 
2.20.1

