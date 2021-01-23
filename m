Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610573013DC
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 09:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbhAWIHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 03:07:52 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42250 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbhAWIHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 03:07:49 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N82a1E163131;
        Sat, 23 Jan 2021 08:07:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=llzIADoeB26bjAHBPE/Oyqk0bSJd6IFuUBZT7dJQ/k4=;
 b=hr8a9Z9sNANp0tCBh6Qef0EuZykgYTJI1HnUDMGYxmAHbydjaw9qu73jP2s5tdYVxueJ
 zrUbrgkdMrkJbjgH3bAOsRiUaH7p78axntHunzeDwEBfr52DGOGzvmfNbczb1g9/BgLz
 XTgK1U51XHFsvGEBTB4tw8w3JzT72zm9cKvGZEbygSmGDNg+3SmdrG+qIszpASMeXbtA
 7TlnXwcfN64HvjZtMfp3j44217cIrDEdhYleFB3hGtiy5AudDpUcc+xFBXtMHi3IbbUK
 Xmj1WNYrJVzAoXcA/RwvixhqitNU9wkv0ShtYxD3HXi1hHWZGbtrNGN/H2iRcJLEhvwu Mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689aa8hch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 08:07:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N80rxC155890;
        Sat, 23 Jan 2021 08:07:02 GMT
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2052.outbound.protection.outlook.com [104.47.46.52])
        by aserp3030.oracle.com with ESMTP id 3689u9022h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 08:07:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z42n7R608MdB4vZmuGcTno3XLlNH0vZ8yYuJfJNf2edl0SCK0CuFO6qopALj70aS2BQa+d0tTqX7ouSyxTp28amoZP6g+AET8AY0gRAFnMGf2GvsLgZjgcwhAhNvax1BqujYhlqEREkx//6rErdliP/RCYRM4deFg4uA9Qan9yienN4X2lk1ydyijt+R6k2lV9PB4vSiXz12dTB7D+1dmMlr4v7Z2l6CiaQW+jI90qz+cp8g40wF1lxjTaPHygcA2QFGNNYYubhSL2iw0HplHEERElBZr1BRKShhrWD/WwvmRjhUjkxAp2Vfc76MNGabWaLlsVb+SWyCbMz8VDa3oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llzIADoeB26bjAHBPE/Oyqk0bSJd6IFuUBZT7dJQ/k4=;
 b=TmS7LeWWvUmc9odKLc7I5HMh2Nuk2yd3Dn0CWjd7F1alE8FU/93ohl5+rqqi4gaJlamsW1eaI9L1XcsBlS3CHKPtcmTf5mDMU/5i7mDP4PbRHv9Z+SOXe6NOJ/lQruZ/m37AxtdfeLZ/eElof0oj57n8HUwCtGdzgeKQZt4rguyHzo25PbF2aOn37FolNPlcoQwKKd8jvlPhU2SrYxQ51KfX1YqKPPucskbE6VMO93m5Iy4uztCsDNsnUJiIDunpd+5sMhkwoj427s6rf8K+OJtDp6+11NKUz1wS/2zj5BIF7tAxU5oDH0ks9In55zn6FP/3vRWzSwQK9j1JxQbC6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llzIADoeB26bjAHBPE/Oyqk0bSJd6IFuUBZT7dJQ/k4=;
 b=FaHWBDHmas81kPUI+thxrHOmWfrsrYAy3Yvx1hbGnNSIxIDzGEGpYwWWNIABRCQ+WvRcYakbMV9UYzdzghlw/07RdnS/DSbU4zfdIwoki5+CJ9tnZt6D/4wVllYUdg1IAInoAKYbvnDH0HKSESYE6hTVp79DumgAHvonUKquZEE=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BYAPR10MB3445.namprd10.prod.outlook.com (2603:10b6:a03:81::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Sat, 23 Jan
 2021 08:07:00 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::644d:92e4:7b5d:f8c1]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::644d:92e4:7b5d:f8c1%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 08:06:59 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, joe.jin@oracle.com,
        aruna.ramakrishna@oracle.com
Subject: [PATCH v2 1/1] vhost scsi: alloc vhost_scsi with kvzalloc() to avoid delay
Date:   Sat, 23 Jan 2021 00:08:53 -0800
Message-Id: <20210123080853.4214-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [138.3.200.16]
X-ClientProxiedBy: BY5PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::22) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (138.3.200.16) by BY5PR03CA0012.namprd03.prod.outlook.com (2603:10b6:a03:1e0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Sat, 23 Jan 2021 08:06:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1e8f6f0-e7e0-4900-f053-08d8bf75dc0e
X-MS-TrafficTypeDiagnostic: BYAPR10MB3445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3445C5F804893F9EA8821934F0BF9@BYAPR10MB3445.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Hgtt9xmblV3c+dlmiiote90Yzuq3FoqXtf2kBCcIhJZUiuU65xyQ4NgIP/Gttl2/UZZGvyskA+Il2+AaVL7rO6KeDcxvSQs0So4+ivHtZoGed2fHasFWw6fsJFB6EY8arnPvvH2I1u845OEiVb3o5nEAwnwMwFAvxWQAJWjlq4NVciuLJSKrB67pwP3Jzwx2dsmu7N+644LBsZ+VVetRSKnK5e1j8tNY8xaK4nQXBt5haMDcJUYEN0j+hJ9cMaGp+39J4L7H1oi3d3C8XBTqJykquk3dsQDkqnW+JvA1HK5FDqLnXpqYKHHzxxpqzNgsYOyoxH84CYA7R50CtDfJXNzKviwsh65Lf7TgV5shrILMssr7gfgdcuQR/ArtjVPmKBPOMPEf0LpXsFLrYx62L8iGTPoRNJIFcubfE+g1zVbDo+Kh9SNj5w6BHH6L4COyBbw+uHBvzqhEw0GixuZzr9pjWug51+VL0CiUGRwbWn7Isup/2c+ESVWi2gJ6StJEirUk8zm4q1K2LE4geKpd615pRILGjNBPvJJeAwawMVLEej++8FFrqytmDOut04bQ3JlJuifInQIEK1A41pEQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(366004)(136003)(6486002)(83380400001)(44832011)(2906002)(1076003)(316002)(52116002)(4326008)(69590400011)(8676002)(956004)(6666004)(478600001)(66946007)(107886003)(5660300002)(66556008)(186003)(66476007)(26005)(6506007)(36756003)(86362001)(2616005)(8936002)(16526019)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+DOKApOjMVe4gBtY594LU4WXkPDebK75hAkpFHBwq8o+pIACKzjWnClTtdc5?=
 =?us-ascii?Q?TO1q3u//8XRFmP9I0fYSkIolFJjD+qt55dk9hw/w2KBecVGow3bdpA4yIk+q?=
 =?us-ascii?Q?jXgFtAHs7PEYkHQfcUVjvhtI+sH8b/DIrJ0J7f3ba09afvRTub9hBuoSsaRs?=
 =?us-ascii?Q?YMPZW3c/hvlmXYeIhEgqxMxQZhwkxRbu+WR2uy/5sSSCNHZ0J0NMFKlBYHm1?=
 =?us-ascii?Q?BIwRdywDz6bljsBnCaPczQmhGikmzw/FFrknhrFMGRBcjk+OiVk+JO9KQFv/?=
 =?us-ascii?Q?WwpCvNY7upEXAqVo6OoRzRJS12i56XzHU2nGxIPgUFDT6aEoWRZLEUe3FK96?=
 =?us-ascii?Q?xRPN7reG6r3tT4pUW5dhjsoFVcKxiPSW/Mf+Tlw4evYULAAOhrqmR+BBKoR7?=
 =?us-ascii?Q?zF/BBacKppvvrB8IZfGZiPPYqmpgVOCtxoleoT5aLZFps6hFgQsgYpKUWZd7?=
 =?us-ascii?Q?ci2dyAQ6SrqXiGJ9SbCo5gwrsz4NhpO0Ul0OJeFsP7vAhksRZBlMI/4v239x?=
 =?us-ascii?Q?0FW9qnd28BC51GdxJsRi5D5r9OBOuyrt3MTx/FMtu6H/HQyFDLS367K60AfM?=
 =?us-ascii?Q?j4o6vjsFnXbtJu/WqzjB6voEhWWsUg1rLhMNXvL3DKvpLbdumLrCYE0SB4CQ?=
 =?us-ascii?Q?0gaixfa1LYegE8aKLkFRvvQFCvy0jtJwTikvz6yAmaMPlQ+2VPsvQzgI0I0H?=
 =?us-ascii?Q?87UZhGGRhkFzxcgj/a5bgobLX2eneG3cV7POghU/VHXQsCeFabgDco3fZSiW?=
 =?us-ascii?Q?R+kJqQR3qVaAV8Rp1Jtrb5YbR84OX+OJoHS4aJxQaL5AjKKRuSazbCCurrl6?=
 =?us-ascii?Q?2yOOGNy7bkGROAyRT1zuB5MHzwk92NdRLJM8pXCgflUR2Ppgkonv5LKhKVUi?=
 =?us-ascii?Q?cXAw50KL2p+9S8lugohFX1Zq1aSs7nQjhdPTLTIl99a2GhF/93RaBSFmd136?=
 =?us-ascii?Q?d5ROPk6QxLw/8zNp0jYDWS25EXUFL2z4dl/Ris/1imITBDJbM3vqYovvOgPQ?=
 =?us-ascii?Q?JS/8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e8f6f0-e7e0-4900-f053-08d8bf75dc0e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 08:06:59.8539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LDLTZd+7YWNr64zbVxKAXuzDTCO900wUMIVVRQZXV0rmGpK/BHQeW0b+uGN72lfqOmGmeoprH0U9J+B56DxzdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3445
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=785
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230043
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=907 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230043
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The size of 'struct vhost_scsi' is order-10 (~2.3MB). It may take long time
delay by kzalloc() to compact memory pages by retrying multiple times when
there is a lack of high-order pages. As a result, there is latency to
create a VM (with vhost-scsi) or to hotadd vhost-scsi-based storage.

The prior commit 595cb754983d ("vhost/scsi: use vmalloc for order-10
allocation") prefers to fallback only when really needed, while this patch
allocates with kvzalloc() with __GFP_NORETRY implicitly set to avoid
retrying memory pages compact for multiple times.

The __GFP_NORETRY is implicitly set if the size to allocate is more than
PAGE_SZIE and when __GFP_RETRY_MAYFAIL is not explicitly set.

Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
  - To combine kzalloc() and vzalloc() as kvzalloc()
    (suggested by Jason Wang)

 drivers/vhost/scsi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 4ce9f00ae10e..5de21ad4bd05 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1814,12 +1814,9 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 	struct vhost_virtqueue **vqs;
 	int r = -ENOMEM, i;
 
-	vs = kzalloc(sizeof(*vs), GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL);
-	if (!vs) {
-		vs = vzalloc(sizeof(*vs));
-		if (!vs)
-			goto err_vs;
-	}
+	vs = kvzalloc(sizeof(*vs), GFP_KERNEL);
+	if (!vs)
+		goto err_vs;
 
 	vqs = kmalloc_array(VHOST_SCSI_MAX_VQ, sizeof(*vqs), GFP_KERNEL);
 	if (!vqs)
-- 
2.17.1

