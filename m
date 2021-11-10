Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D65444BC60
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 08:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhKJHxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 02:53:40 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51570 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229613AbhKJHxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 02:53:39 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AA77M9T027729;
        Wed, 10 Nov 2021 07:50:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=mQP5jjWFsnkMQ2j7sriGLO0PGczfMMc8HXvJQdsopv4=;
 b=xumLl4KVSYW1H9GXQi66oCOpGTt1jDa268UWKEOkbRWNN5ucV97YtEiNuvt+vvSHw+85
 viItUUz/l8jfhL15xpcqBhim43swfVJJo8vhds8TlhU9kP0Ax7dzFd1M0Mkrs8BcHpLQ
 JxokloXADqsayT/u8k+fDvm603DhHjFNXZFeR6jLAY1JFWtkq2NTyth2pLxP2m/9C5/z
 RtfLfZKjoCwvq+dUfd+voYjzAYWaC+iId0AhlqiXnMu9qa8LoujgexhAfiB4R03tckhD
 0hVhbn/LMhfe0gl+TRH9s/4Ayu21PS52T97tWgFHFVkW2/XCtNPj1pZki2e63uB2WQ9Q 4Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c880rrm5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Nov 2021 07:50:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AA7ogAZ005913;
        Wed, 10 Nov 2021 07:50:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 3c63fu902p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Nov 2021 07:50:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vzw+Z+39H2z/QO/iJRtTtHVF+GIB6hJw0yCoeqMHPEl5zY/n6kPcPKklUKqNbR02DBgcRwJvuK/OE+InyOacl0B3l8lL6KwYT05JcdpcaQbdlMrjxJI334Tq0N0iudTgPgXo9YsJajcADz9hEAjx+LDAeTV4gomrVui5TqUHMAC5PmzcXlR4m2EHoC55Vm03/fbY0ut5xz8MbsHwNzJVT468ojqW5A9FVgh7ALC1SINCZIFKsF4rhjiBLRcLrbT8/EEcqcII8Nq7K1Ht602bCaPrb9NaysfdB9cCl+pGrrJ+P96766PQ2iwApErbHy2fkIizyftmPwcYmTHLQFy92g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQP5jjWFsnkMQ2j7sriGLO0PGczfMMc8HXvJQdsopv4=;
 b=Ff8yDSOH0JW3d5QaS2NIhWKz4914cIUK8n8nwpwX/4marGk7/kk2l1qOvOlyqs8jcqjLc97kbf9E+e8GMWvSo4UzKSC6TwfuL7gdqxvhRQjmgJKoufzqBwP1E13Qqnj5/2zGyQ6PWPErgwt8DoBnFiwMc+M0Tjut6iPUhUIMVZutk3L0VOgzntQiw8ofaasZeP/KteakfEvU11NpZFzSirOm5qC1jpZKQ3bgWPZikXO/63eL+hgooFZQCyM512pO8PNY2Ydia2L29vbelNPpHV4QYjrQot+kWV3JxfxmP/fcezahexh9PQCMgGE6jUTUC8aSSJDveJfF/Dw9NMHw+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQP5jjWFsnkMQ2j7sriGLO0PGczfMMc8HXvJQdsopv4=;
 b=wp6UpJNA7NeYdV4CzS57Y/eAy/7W+e/pBR1C2iL2b3yvqxgZ/sjl8Bf3jjdEVT4XMMOWiIWcBPk4+A2YLYa8n1bKctlt0Y0tMt23h334OAGS/AzvLsdyx1ZfJMwnJ8ZMzrYnZSWxOfBtXmQz1kLogedyuWKyfrNa1wdHQtkcI6Y=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1552.namprd10.prod.outlook.com
 (2603:10b6:300:24::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Wed, 10 Nov
 2021 07:50:36 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Wed, 10 Nov 2021
 07:50:35 +0000
Date:   Wed, 10 Nov 2021 10:50:23 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] ice: Remove unnecessary casts
Message-ID: <20211110075023.GC5176@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13 via Frontend Transport; Wed, 10 Nov 2021 07:50:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5505d46c-1518-443b-76c9-08d9a41ec7a5
X-MS-TrafficTypeDiagnostic: MWHPR10MB1552:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1552786288896C3D5197E47B8E939@MWHPR10MB1552.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f3F5pqn+xuKu4U0v4STqOLQjeDKYkWTB7cTQWIF5z+nAC7o34V/YYyEZ/fwwx2fas3Tul5hJyRsHM6DulBMlT4kTBakdwuVhcOVyxNiZ59Y7NPywJeIxyen142PUFBTblfXqREww6yZQd3AbkkUlkEmIzBM1eiF6nmsCPkfJfoItZATp8pHRLtRkTkNzVO5BPaHbIYs/bum0pIbRxgDbRVMNdPwFgFOmxxSb25OGv0i0sbL3oM0S7jumDphBS+RxRFAoV+LE6LOy+BCQBMyv0LOblbSZhVRzLS5GriEGJNJ6wCUnC9QPZ/DWhX4FDLoccAHtKlW2DGA9IjSvwbWzqYEuhbvUA/zZBdQwXtve7pIycLCSg3ZieeyPmbZcc1or9MLxZDZBdrIqpeak0kn00mmUkJSG5MCr5jp7CtdP+wkK4WjXdzTaZi3q7W3oITCBvdk+D/E0jFB/Milb9iHLuT907stWN3M55nLGEBe96xfmsnI8YumH2pH7unEYlrcJKaxn0h9MiNc5cfhe77mYrogo4X2zMPKFh2lEIU9Qr/oS3YXn+rJCiSo1aLk+6iUao6juHMkCmEdFMGBBaM1yhke+0iKVCFlZtd5FrbBCcY2kLc4Vtdc/ENFbSi7uch8lWLfrfBBrWgfha3Ar2yIrmoOIYYrYcR3w1MENAER1KcaVYhlvtbc9PZM+dUu+t20evmEUgEuCGNviD6z5qHOiIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(316002)(5660300002)(6916009)(9576002)(508600001)(8676002)(1076003)(44832011)(54906003)(66476007)(9686003)(86362001)(4326008)(66946007)(8936002)(55016002)(26005)(83380400001)(66556008)(186003)(4744005)(6666004)(33716001)(52116002)(38350700002)(38100700002)(956004)(6496006)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4mxb7oVWdHDNgcsYfXxITXTKahLIXlBIv65EbejTV/am/2w4U/Js2bR5HGA5?=
 =?us-ascii?Q?Sij0M96pHPJ2YoOL98feDb6Gv7oWgj6sOA4Vv4uXddC+t+VxwvAkWBJy/jvo?=
 =?us-ascii?Q?+eSuNnGNqr+vG0nFaDYj+T6fhHu5Yc5wUhsvBZHQ6B3JuMDrqwvjSvCN0gu4?=
 =?us-ascii?Q?XQmW4ktf5rggRVSKL/QB6PXYWfyX8JVysWiGVUdo7p35/Ddxx3DabR3pBYDU?=
 =?us-ascii?Q?v1ebJGAEv4cAV4JphS8ffrVtYs5/QN01PoTYLq5g6bQdSseJ44uqkbkmAZdB?=
 =?us-ascii?Q?e1ZsSSAeufCrGMH/DXCSxZjkRhzb0Jfa9rg+6XcBRFD8YLCDU+w0gQqfQqVe?=
 =?us-ascii?Q?WmDSM3gx06qkqzca7HiEacblFAScrJrzPlCkg4HOQSTAyPnFakXSANJ26x4v?=
 =?us-ascii?Q?KlNTFxJGGlW1nBnwoZmzKyLAu60QxE8dhVyU0WbxQ8PmZHwbnZIAkKGcMywJ?=
 =?us-ascii?Q?sj+CqD4YNvhyTSpuGdP+OZg85oDgTwMjDYAoaNhgyuvoUPLN1Lojd3Lpt4Zv?=
 =?us-ascii?Q?mG48DUfVW8cSQk2h6pLmDMJIh2NirnZGDDal2njwnhPaE2R3J4DZjsqiWZJO?=
 =?us-ascii?Q?qnBE6p/FQH98wvVauaQtg3KVsz/lhaBTukU9ZYn2IcsiusKb2lj2krUSpbj1?=
 =?us-ascii?Q?Zu7sMdDiaeTRZJ3q6YUE1EjHHwKf0Tnk3+qVKqCR/D/SWsCA05PQpV0Gi13h?=
 =?us-ascii?Q?a54KMTDVXAIWq5yKxvdlum8V9dc+Xg4T4huUZEP+l5RI+aIg0kQY8FIei7i1?=
 =?us-ascii?Q?fcsRPrFcswA5KWRPSZu17QLy+C8bXmkAQWXw7stjeQavb/r8t3Px4D7i6IYn?=
 =?us-ascii?Q?SH6M0Uy++xC9JGWux6OPsO90nAh85Pfz2IBfduHEsdUJNx+V/VtpjA/Yg8zh?=
 =?us-ascii?Q?hfoISNoI3lZMinjS9d37gUEdV53ihvG9m8XSic8w8IzLqz7tldixACevZZQR?=
 =?us-ascii?Q?txs1LwBk7P4k1d1XufKd7tNWY1Blq0afCMX51ddFfm2QZaF1HFdAAsQEHnvO?=
 =?us-ascii?Q?wIJV8TcNtbKCymKiJBsf7IDZnsf2c868u+m9HZnPqfkENeSypmSUEIlpJClS?=
 =?us-ascii?Q?ymYTzRPHVXBACZpbuyYePVB0/zcPYz7g9XzXWMivmhmLPWFtya+viQ4S+11S?=
 =?us-ascii?Q?bu//fpjT2/73DqZXB6FwnhuB0B6bFLjhy+rDeCqfmPM2dL+Vfm/VBPPKG12Q?=
 =?us-ascii?Q?15T76cFdblUkRb6qQ5dSQrafsc5faMgLZBcnaGw5UMaczizptOrnXd7kpFaY?=
 =?us-ascii?Q?RlKhL2VlIpJdDHLjISVo9/0Ap44mxlDjP/HoGtnRNbJ5bTQmj7Xe9Z8h4v7v?=
 =?us-ascii?Q?p+r/umWEJbHpM+lGP371EStuk0aMC5LexpWtQArD0y778o5cMSaS9tKZJY22?=
 =?us-ascii?Q?IF4GmfU+e31Vq/kSSMKIw6369+vcSIkhalMTKaN2QDF3rTW3szQhmbVsosN0?=
 =?us-ascii?Q?Ken0jVcz5bRUv2NIJqUIi50Rp6W+S16FGgDQtnKtmpM7kaHexr4TiNLofayj?=
 =?us-ascii?Q?qPURpL3B/9Y5oCESA93fZCKd0kUL5gPsflwaETvCZsk/o4UtTy/H+7UbzaXe?=
 =?us-ascii?Q?S+GM5CodNALL9cX3COL2l3Agjf8En5mMAxWcTFgEn9/NbD2DNeE+Djy1f3J3?=
 =?us-ascii?Q?tNxcI4MAd0+DEFB0ff9ffrh1Av0OccaV8pp+jPPONVQ6mKxjFy/bHQHOsI4p?=
 =?us-ascii?Q?tJAOsycE4KAKnGjM3OA1zOEhxGs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5505d46c-1518-443b-76c9-08d9a41ec7a5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 07:50:35.8417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: um2Qmpg0RsczPfZ7biLAfO3F6p6pZfsgP6I0+0FCCpEFCmWRnPrFW4QOzbR8hp+GRQgiXNB3/w0U8nROQo8p7BiaSRrh1/I7YYE+EBMu3ys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1552
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10163 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111100041
X-Proofpoint-GUID: GAXQXSh-n6gA5K06yot1pnx3BHSTHD_8
X-Proofpoint-ORIG-GUID: GAXQXSh-n6gA5K06yot1pnx3BHSTHD_8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "bitmap" variable is already an unsigned long so there is no need
for this cast.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index ce3c7bded4cb..61c3f88d6ed2 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -2661,11 +2661,9 @@ ice_cfg_agg(struct ice_port_info *pi, u32 agg_id, enum ice_agg_type agg_type,
 	enum ice_status status;
 
 	mutex_lock(&pi->sched_lock);
-	status = ice_sched_cfg_agg(pi, agg_id, agg_type,
-				   (unsigned long *)&bitmap);
+	status = ice_sched_cfg_agg(pi, agg_id, agg_type, &bitmap);
 	if (!status)
-		status = ice_save_agg_tc_bitmap(pi, agg_id,
-						(unsigned long *)&bitmap);
+		status = ice_save_agg_tc_bitmap(pi, agg_id, &bitmap);
 	mutex_unlock(&pi->sched_lock);
 	return status;
 }
-- 
2.20.1

