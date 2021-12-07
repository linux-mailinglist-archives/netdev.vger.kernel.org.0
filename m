Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191C946B5B1
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 09:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhLGI2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 03:28:22 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49036 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232440AbhLGI2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 03:28:21 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B74k73h004493;
        Tue, 7 Dec 2021 08:24:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=Se/pcJsNeLvZy4HBJrVEY6Pn4UoCc+jC/2zM2tJAzQ4=;
 b=JaS+j3pgzLzlOLiBRyYxDo+W16srzfEm6J7JT60uz0xpDEDfJMv6UPtaw7Ev7he/QDB4
 xXoV7vuBecn/5zdJ49M6vHlk4ckni9oOojNbhFwZqFV3FtvnAP/L1+Q6B+fPbUdpgTpT
 /DluMiXUFWjf/MvXczznr0thbBIY4vyB3uvZMXja5hBeug5CvBkRX286GpLZ8xCOtxOm
 o3VKafDBBs+GXNMM73mZ8G2o38RaBxQ1O5ABLoRjv8ZyKZrg4aZYkzjkumsanzwbq6pt
 S0snijGVYA0mFe7y4WERALmgDOsTuksYtVrRfN9BJcivODYZR4qWoP4gO4JexPrYWilr WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csdfjcfj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 08:24:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B78Keqc141017;
        Tue, 7 Dec 2021 08:24:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3020.oracle.com with ESMTP id 3cr1snkvsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 08:24:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJMeSZ7j0Qg/dxnoos++lXABS9REJu31jtLC86HxzsnJN9o4cVWcRybx0saoirLqhk8XBA60+H+MnUlU/nVTr6UUM7cVodVNm5uFQdVAPgmgBgUA1Ew6uqlc1ieg8iuoSq29EYoNbnw78Gy/O5gOD9gsBggrKsCT1bjJD1aPh8j1nkddCK3TCWii3FfgEe18nVN6781Z7u3IdVMB1O1TBEOtf1ZDK9gYVGXb1pNNnJlitj0vIHLsbhXP7ZA/5TFxH2hxKXAlnCjysRLSRcgjvPTxZcmHI+moaxne3xtvKK0BxEhhXJFUG4+1Ki04Wa9QKWqevEOZXRyOKfnj0seX1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Se/pcJsNeLvZy4HBJrVEY6Pn4UoCc+jC/2zM2tJAzQ4=;
 b=Mxp96iLP90omx+mzO5z6JU1OPypYlLxIGroav5FwLo8v1djHSTGtVxf5UTlpxLtc0K+FN3uNUX2MpSR8hxfqTJGjQSVbdusurP3ugQ650OOnYoy5b+SAXkoaDVE5qIHxWht0XkPQj8WiBGC4wdX/TkUyggVNj4smTRt3Ejujsr8KrhFliCKl2Z3lHnpEN3UgWweH8c2GFn0q8PlnlMwI4gfnlh61wN+UmznJ3TPqL8Cue+yN+dReX3LV6A2WVLFP9VFULSWEQoZI+Ox8KOzPUcHKyCBlD697KQ4VdeRDeYB/PwnJgQgIPIyGt443ulxSOJpCe+KZuCUhSPkO1qICDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Se/pcJsNeLvZy4HBJrVEY6Pn4UoCc+jC/2zM2tJAzQ4=;
 b=j1XY+qQRevqoMOkeU8Zg7r9F941aRTQREfN39n5Yz4G5D9K6oJypl+Jp5aAG6SipyC52lfU6B7EcDuq3vsFR9+LPZxRTBI5S4Qnuq/1pHWqRHM4lkjlx2tanpQdHuXbizG74z8sae94qONQyf/miJR59u3L5A5/6eyDHCWnHzoo=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2368.namprd10.prod.outlook.com
 (2603:10b6:301:2f::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Tue, 7 Dec
 2021 08:24:27 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 08:24:27 +0000
Date:   Tue, 7 Dec 2021 11:24:16 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     GR-Linux-NIC-Dev@marvell.com, Ron Mercer <ron.mercer@qlogic.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net v2] net/qla3xxx: fix an error code in ql_adapter_up()
Message-ID: <20211207082416.GA16110@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: FR0P281CA0069.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by FR0P281CA0069.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:49::22) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 7 Dec 2021 08:24:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3137a9a-64c2-4d7a-c2b0-08d9b95afbce
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2368:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2368358FAF02F53E5AE3DF5F8E6E9@MWHPR1001MB2368.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OchVr3XhkR33qpW1uXRGPfx3EAriDjbSgbTU67EOdb1EmxrARyockuSEqzBphimFCq3i7uLVOaFXkmMk3sTs1eGBLnRkqX3z6n3s3FpYFrFNXGv8cuLc/lKKfJkeExrhrO+rzHSh8NsqyNQg/RMJ5rUM3joJAieCFIdB9GpCFWcL4G/ubnlRATb2i4wcwLOQiH9HoRlqDNdAczqdyCdqHqAbRtMk3ChWdSqxHaoUjrElCe/kGyHte+anKh/sGkKptBiyYD/1BAlZATw/7plXCeAVFUEcrZi9uXvIagtoKjsaCXE8m4SQf17hNsXHo6nPGRCncWIRK0D3stVYsKD4NCvfAfYY0K6cnsyjbd4DoFZXPoYA9WueRBrMOFFg0hSU2jgtr7wa1rtiQti0f3G5FYM+C3kf0SdskzhPkwwKaal8MWI3epuNIWWXM6zqEuwXuhKmWoEP/G8GZ/NYvTP9FxMxqOmKxvndGXCFaikyqi/v3J+2vGYZP2EJD9MzQDRoLJSHvXx0PCX14cm/kCSxQ/tbDAHyWSHIG4WKiZC3NIa2/2TBcVQHr7oURe/duQNG1TaZc/CiG0H0mYWRnvVLN6M5rP/Ie3zcKbCTyGTnWDKu+Lr3ulhsAkEQvInwmM3R+OA89Cn1w/WCWuuNrgwd2UAhRccNOjPNWrTlXMfeuGX5jrNyzdPRABimS7p5Dsuw0cQC3Lm9BP7JZeMCnGR7IQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(44832011)(33716001)(6666004)(6916009)(956004)(1076003)(5660300002)(8936002)(8676002)(9686003)(508600001)(4326008)(9576002)(66556008)(54906003)(6496006)(52116002)(33656002)(316002)(2906002)(86362001)(66946007)(26005)(66476007)(38100700002)(83380400001)(38350700002)(55016003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E8FFQXTYIYets7R/EJWOc1f1SYFQvFSGoNWluqK0hSmdLUxG5uVLaaH/D+5Z?=
 =?us-ascii?Q?d4vM/5+cBNfWI6unyhh3oj+ajZoH8Sh9FEGVpSjD9W2oUtSbYxE1qymFowkd?=
 =?us-ascii?Q?NaPi68eM1V3sVqPceQ2V3Y+BJEM8Tuuvh7X/Lt7NdY93ZPUez6CYNqmFEX5y?=
 =?us-ascii?Q?JwTUej0hLiLARvPPne7bvswXfuCEbZBUTC3hTH+C2Pg5w+1yqHrkVkM4Qa0Q?=
 =?us-ascii?Q?cEAb5in3NLv1ZVtPqwzHF2uD21uxktyvVEj7Vcop8iSzKexa/8Bv0jN0MzTx?=
 =?us-ascii?Q?Dyp+v7uenWR802pR+DFqAvlVdNrGkWG+aePD5uNxItVQsPLTMWfz4KgrUes4?=
 =?us-ascii?Q?nJVMWka/+H4wtINKOyTU0pHsyQ4YUUrAQ7cHq+CyKBefduJA39zDdsDH2aJy?=
 =?us-ascii?Q?5YANHDWnJiZF7Z+pL72FF5Es09MBoI9jnltbPusdvO3Uyfbv3BLYX12BdPPp?=
 =?us-ascii?Q?j+gZgRtyGVOzjvTCo4+O1CIjJbWD1FzGkQBpl3UAFHryBy933JndUz9O4c4f?=
 =?us-ascii?Q?nzVuDkHYGtT/B9ZsiIRvCp7oY8UDafBnRG3nHM7Wn32JtnXbphXZ0qiu19mK?=
 =?us-ascii?Q?xWYdxu/Rdv7V56EZ7CIZh89XrHNyjtiuUrIkDMcWCi7GjpM2dvq3P15GYsAM?=
 =?us-ascii?Q?FjXj3p48hhTZjUvnaa07rHYc8i9mPHbJ2IA9Wsr0r39/0loP2qYN8z76Fpfc?=
 =?us-ascii?Q?mU1ea06omROsUsaU/7PWo3MWBvs0+8hub5BcIrzSdmlfBx0cjhdc9OXM8U6m?=
 =?us-ascii?Q?zfwyG1JByLmSpJBmdLZT//bdd66u6ivFLmXW1ljLryz0IeWkkHycqfQlpxYq?=
 =?us-ascii?Q?vvHW+q7s4ENwvMKLFtXkccxGhSj+rCZ83yr19fVbuo0fq7e/Clj7xOdvDknh?=
 =?us-ascii?Q?5h8m3E1VHbJ/do09ztBVxHklzpHDCpkFFuP1ZOWqBLpoXH3Ugc7/c8Ex7k6g?=
 =?us-ascii?Q?4AqGe7jcoiqrMX2IaBMCepYKulUJrFFk6qS45DZEMphtNSdl4siUtw0KAGdV?=
 =?us-ascii?Q?l30mwyiqqb+QXGsMzQgccvzMB39Kr6PSmu8b1LsOUKQCdCax/Qfi3QoJcW2E?=
 =?us-ascii?Q?ifF3NcVO6LN5/5EJMoRWS39FGfdgjN+fxoE7+St82x5t8nEmcFB2hoTJfG05?=
 =?us-ascii?Q?KuQIbKRFjv/LU8n6/kOvRv1RAhwFFYdXPTJfNGPK+h/Z6zpXes3vhVhSx3u1?=
 =?us-ascii?Q?Bz487HiP77KEeRZzyoG1NESMUDlmEpBnKsoJeaaGv2/boR8ZNySTAVplQ1QR?=
 =?us-ascii?Q?5gJurTQrH8XiznnzL5+7kbkAHr6PK2f9P4XKFXIbf0byPr8DUcKAETDeucSY?=
 =?us-ascii?Q?QsM+0TfHhGBuIIJPF4xfFBc61Oj7yf/SRtBDjC8TCeuCT8hmLOaHoRzYoAQM?=
 =?us-ascii?Q?AlzV3rgNvRuaRBw5PhA0WPjTlnioWvijljcaxEoT9x0Z4kcRoQ0AYqAS8szh?=
 =?us-ascii?Q?GpQ3L+WxQnbRUhs3FtG+VPekRUdPot1ViRPnVEfC6UoonAwlK+wINRwefjSP?=
 =?us-ascii?Q?6EB85uzpUgIL6HbwbjRKaOlXBj/gA1hrU6BHJw1WX+SNBbm8JZAPAkDD+VRf?=
 =?us-ascii?Q?LrPz9xAp4Jh6Nyw2pFV4gotvYI6pivtjdPDnG/DT/2T6ZQD+pBA+RMkffkhB?=
 =?us-ascii?Q?roqvGIBqm4t4EJYPa2p6OVCINH4/OsdlivT4FdoxNw80IpJF5sHN2D1Vmquh?=
 =?us-ascii?Q?2qXuDJyn2Xzq91ls5WadOna/BBg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3137a9a-64c2-4d7a-c2b0-08d9b95afbce
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 08:24:27.5410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RMgOIDr7Nic/nARW2VKarPzjU6EONWeGdhxA2LgQk/gtRQfXvECvlxRu4gkk7aejRlbE26xaKyg9aZLQAsQjY3SDGojbuLpbneeUv8j/WcA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2368
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070049
X-Proofpoint-GUID: HqOaBwl1oWa7tOoChjtywd78Zr8xJ6Av
X-Proofpoint-ORIG-GUID: HqOaBwl1oWa7tOoChjtywd78Zr8xJ6Av
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ql_wait_for_drvr_lock() fails and returns false, then this
function should return an error code instead of returning success.

The other problem is that the success path prints an error message
netdev_err(ndev, "Releasing driver lock\n");  Delete that and
re-order the code a little to make it more clear.

Fixes: 5a4faa873782 ("[PATCH] qla3xxx NIC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: fix the subject and Fixes tag.  Delete the bogus error message.

 drivers/net/ethernet/qlogic/qla3xxx.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 1e6d72adfe43..71523d747e93 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3480,20 +3480,19 @@ static int ql_adapter_up(struct ql3_adapter *qdev)
 
 	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
 
-	err = ql_wait_for_drvr_lock(qdev);
-	if (err) {
-		err = ql_adapter_initialize(qdev);
-		if (err) {
-			netdev_err(ndev, "Unable to initialize adapter\n");
-			goto err_init;
-		}
-		netdev_err(ndev, "Releasing driver lock\n");
-		ql_sem_unlock(qdev, QL_DRVR_SEM_MASK);
-	} else {
+	if (!ql_wait_for_drvr_lock(qdev)) {
 		netdev_err(ndev, "Could not acquire driver lock\n");
+		err = -ENODEV;
 		goto err_lock;
 	}
 
+	err = ql_adapter_initialize(qdev);
+	if (err) {
+		netdev_err(ndev, "Unable to initialize adapter\n");
+		goto err_init;
+	}
+	ql_sem_unlock(qdev, QL_DRVR_SEM_MASK);
+
 	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
 
 	set_bit(QL_ADAPTER_UP, &qdev->flags);
-- 
2.20.1

