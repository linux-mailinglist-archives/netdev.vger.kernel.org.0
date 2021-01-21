Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E112FE15E
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbhAUFGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:06:31 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44272 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727550AbhAUFEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 00:04:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L520Af147649;
        Thu, 21 Jan 2021 05:03:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=zKlunICeRZRHzu7ogVf19W538S3T89UdmgDP0LASK8c=;
 b=V2D7Mq/Kh0ghlPOptODm5KhmfsGmZonFc0C+av3Kih/E+PBRoJWpEAb/ZSBm+3KoRwX2
 jRW7ANysBbp+Caqxln9PxYiFqxkahBmNAFdvJ1wZVhjgdir3wIJPEZgMLrw7MAP6+1n8
 UCUgR9EBy6ja5z81h5XqUkSyJv9qJwbgqQxmturqaYwYJLQDayJGldFQ4KU6SiPYvSJW
 3TqOL6XPymxZf2vpg/IhcBj2ygHEu2Les+R6bdiinNLPOXxVZFC7aX9MDu8rFQQ1yKgm
 WQ2vRfKeNUWZeVo2TBCoZmgKmw9wlTK+JzpwDp4yAc2QTaQ+0Ps/c00thjJfFd8ddlJ9 pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3668qmwhjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 05:03:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L4xqIk061313;
        Thu, 21 Jan 2021 05:01:45 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2052.outbound.protection.outlook.com [104.47.37.52])
        by aserp3020.oracle.com with ESMTP id 3668rf39p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 05:01:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naTgH9Wt0kPBxh9BA3gbwodVgzYphvap9rzX3jo7EO03xzzhsfTm6MmcOQhSZOdBqIZzQYqyllUZdNL24UmWzRnPQiVie2nQu7a35uBVLIk3BRSWkOoWB3RYZ6AgZEZ7X0qSUhRp3jtju1braN80NpGaAHd6aFsS81NDd89KY1fgpqPR0CoLAEKQIkZbpCdWYPtY3pZUGyU6x9HupPelURnoPgby/ejfODex/PYuE93YHpDPqde/eg+1MfdCM8KMLPLT+0dz4/fD4OtOeql0yBS/TSRfbbfh4iQ5GAFOukdlmK/qJySDxj3ExNC1yIvrCN/D2RKOAf+AUYGoqcpgBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKlunICeRZRHzu7ogVf19W538S3T89UdmgDP0LASK8c=;
 b=TGdeiLNkfQKhmmoJICeWl8VNO4J2CwrkLhYtQDoJ9th4sC+xYSoTN2dEvMXDaHLCbmUGhL+rz9V3++UnTNW00xEt/2NqjrVrW/iu/O4AtbB4v3c7dwsScKowJ1L8m2AEc5IlFedpB6hbzPZpVT59qKf4F+mV7siyW/2tNvCmLwDxcAIlPoEQ52RHCtD/i9vY3lb5a3ltdUunpwxGTTJDAN/5k+Ve2fZqEI1p+cFtuFz0ANRyoSPsVmrRNvNSLCCM2YiN1/acKCaSVJmOY7P317gwqw04DE+AgXPgpe4BYUH7eQ6LJKK+Kd7ZLloqI3g7yuEBk/Y+ssBF7rvbtsFtCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKlunICeRZRHzu7ogVf19W538S3T89UdmgDP0LASK8c=;
 b=sClci4VlLwi48BwNEniuGAyKEFhxQ7J6LCVAHvdFZhkndPKUEz2Cu3Hyl83oOKUyNdBhpj/tP5uVuCYW/GMrWaQCphd16RuF6Oh1wfo8r1NnjSnaHwJIt+WCuYsf9KCsZ4gC0b6p5NSj1MsFWAIG0R5/alPJJMo9volC5G5viq0=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BYAPR10MB3255.namprd10.prod.outlook.com (2603:10b6:a03:156::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Thu, 21 Jan
 2021 05:01:43 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::644d:92e4:7b5d:f8c1]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::644d:92e4:7b5d:f8c1%5]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 05:01:43 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, joe.jin@oracle.com,
        aruna.ramakrishna@oracle.com
Subject: [PATCH 1/1] vhost scsi: allocate vhost_scsi with GFP_NOWAIT to avoid delay
Date:   Wed, 20 Jan 2021 21:03:28 -0800
Message-Id: <20210121050328.7891-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [138.3.200.16]
X-ClientProxiedBy: CH0PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:610:b1::34) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (138.3.200.16) by CH0PR13CA0029.namprd13.prod.outlook.com (2603:10b6:610:b1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.8 via Frontend Transport; Thu, 21 Jan 2021 05:01:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37813143-6823-431c-3364-08d8bdc9a542
X-MS-TrafficTypeDiagnostic: BYAPR10MB3255:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB32558115C01C3555EDE28AB2F0A10@BYAPR10MB3255.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:519;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n4ZHJ4jt1Oa6YWUrEvh0Sd1NOmREhKxD4e58V5DZPkbTK+ilv2+4rccYBfsEmmRfsM8tQSFzTR1lOsUNUnd+usPr+yXEJqys7jjxDwNo9AgENJm88hP3qbPz30EZhFeItxVZ8N6EgLr49z9UMCExLMTWvad0BEKLRBxqPgbg4FZ0SqjSLPHY8Teyq3wh29eR1SJoH6MwZYi/cJ4php5zZJn1OTFjdFxvJ6b4gZFaVN/UbH2GAolf9+RcztWh1WKQksgpWvUfxvLYWSXbqGw4FFo6UuWJxHyOHlaZzbjNPEUOSGVJc+y3r8PBo9jz3q20EjgQ51PU3blrFyqw2CNDFCbAhvKuMpzvWnEnvys5jIYekvHV1C5AnhczeYt5znQeUPuoZAfQgub+3klZRJvFIqEb10RDje0vJ0vuP0Bl5hmNAJ9dvevn2m9JCsch23eYMhGYMaZ+41AdGycxBViKLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(366004)(376002)(39860400002)(5660300002)(86362001)(8936002)(36756003)(186003)(508600001)(2616005)(83380400001)(316002)(6506007)(66476007)(52116002)(956004)(66946007)(8676002)(4326008)(44832011)(107886003)(66556008)(2906002)(1076003)(69590400011)(6512007)(6666004)(26005)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?s7dBf+6Bc4hmkHwqtALaDHXiuZk0nreKrdl5BTpoTqOcLJvlL0TlH7fBMfi7?=
 =?us-ascii?Q?+umrQ22rSCafCIS3dulD9AOOCYxgHD9EHffcZgByO3VwYtczmYZ/mflYrScz?=
 =?us-ascii?Q?lyZpfAY2b6PqMEQuVkzm8CCRaMF/u7RaUzTrOaLI8mq2lK6cLTnKlu1u6Yuz?=
 =?us-ascii?Q?62HIApO3bfy0X647UQMdC3NPSD45N0WJPl/z+LJmxO9Hb8wEWuVqKT2hRINj?=
 =?us-ascii?Q?4w+Cgr2lvRN0U4AbIYXIkuI081srCjMyO0WRsTde2iFNmXBWf1lQxtaNAoIq?=
 =?us-ascii?Q?ZfzIsc++wtUXb8x9vA7LpPgqV+TIDqo2qiy1lym04GL976O5YmPk6azdDcqD?=
 =?us-ascii?Q?bZR50bG457b+flcIlUizNWKesN7fUEdWsSNtGTo89rfnCbllJx5gRdHnwNJU?=
 =?us-ascii?Q?IoN0Eo2jYzqe4k9k8UXdCrU8UgOMQBqZEUzOtJ7HLNHeFKL1w6bdbzd8czRb?=
 =?us-ascii?Q?hGEn96SxWBrerkqWLXsnDzk5AnGxQR9OJsiV/1RGJx1hwt9+JVXw+uQPZ4qb?=
 =?us-ascii?Q?jSUiVTuQ68SemEe6Y2emx+BhHd9290Ytdc2bv0SbBv+I30G2tXV0w3My/tJm?=
 =?us-ascii?Q?DbeOTbqKAhTpXegj0eH6B5lEcWMWGdC6LE/K56vughBNRVczV1/hCpa1K0p5?=
 =?us-ascii?Q?8kMfh4cSzw7TuOuzCkG9Pqoe+wVUTYv4QjpTIWepVwStunXev+4VWtmf6rl7?=
 =?us-ascii?Q?gWmCSnNroXqELAi2PzOAyglvNkzWT1oW/O7FTrwnFKGA2OboKbXSBKQDuGO8?=
 =?us-ascii?Q?G+2JlFJeRspQf4vfctaTRN8Wyym53+wpFQtPi1MdRzJAdovk311IW53Io7NI?=
 =?us-ascii?Q?WX/aErIxy/QilmWicoVzzNKfivgLLED4ZC1MLAWIq2eIsOP7Bf5x3V+TyUqI?=
 =?us-ascii?Q?6A+TRDFZGgPvcxsOABg9KOOcns/StJlMVg6lmtOA3eYUgbfLSBwxBMtGPftA?=
 =?us-ascii?Q?ycxpRZrDeERDbL8gV4Cq6gK8tUQyCOQ7CE6ANAbUxLc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37813143-6823-431c-3364-08d8bdc9a542
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 05:01:43.3779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TNqSupVapbHCXJfqpXi5oGjpriUC1UrC6UX7/6Bup8tHPOcsI+AKWX5JqUC+mm8+q5g8JWyHh8ZE0zlweBWh3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3255
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1011 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210023
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The size of 'struct vhost_scsi' is order-10 (~2.3MB). It may take long time
delay by kzalloc() to compact memory pages when there is a lack of
high-order pages. As a result, there is latency to create a VM (with
vhost-scsi) or to hotadd vhost-scsi-based storage.

The prior commit 595cb754983d ("vhost/scsi: use vmalloc for order-10
allocation") prefers to fallback only when really needed, while this patch
changes allocation to GFP_NOWAIT in order to avoid the delay caused by
memory page compact.

Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Another option is to rework by reducing the size of 'struct vhost_scsi',
e.g., by replacing inline vhost_scsi.vqs with just memory pointers while
each vhost_scsi.vqs[i] should be allocated separately. Please let me
know if that option is better.

 drivers/vhost/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 4ce9f00ae10e..85eaa4e883f4 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1814,7 +1814,7 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 	struct vhost_virtqueue **vqs;
 	int r = -ENOMEM, i;
 
-	vs = kzalloc(sizeof(*vs), GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL);
+	vs = kzalloc(sizeof(*vs), GFP_NOWAIT | __GFP_NOWARN);
 	if (!vs) {
 		vs = vzalloc(sizeof(*vs));
 		if (!vs)
-- 
2.17.1

