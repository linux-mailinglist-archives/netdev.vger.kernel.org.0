Return-Path: <netdev+bounces-6374-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5377D716053
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:47:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F2BD281189
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97DD8174DF;
	Tue, 30 May 2023 12:47:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E1414AB5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:47:03 +0000 (UTC)
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DB0192;
	Tue, 30 May 2023 05:46:42 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UBTJZM018560;
	Tue, 30 May 2023 05:40:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=tzk9yKRyFaPq6jMprEiZkkKl/EqG0S5Ng59Zq+GGtkM=;
 b=jL5kqNkdMmaTHh/yV978n38RPg8HO8tLIKoFGSMRY7G6LGQv5w9ZoZgsIXco212hxz9j
 KDBLdmUTS/+2QQ9Kb7jAd8GQ7JoqBopqiZyFQPXr76eSFD9Kc9UFGAGNlcNF5iyG+5u/
 ViHcYEGZx4Oj2cVobT+uuuG8yqL3Itqjf/vPacBnGZllJjK1cebdNUzKY8i30k/dbzAi
 tzmNkhzENUIitQRxnJDtwxOZ91MbSXa2Gbjbo8V/pRMmoSabsRzHaqKva5bXwjPUGlFi
 OLV6W+E7a6jG+ZZME1Nt2FMytBNc9/KNKK4h1vx05RHHSA1KzynvykN0C1F88RN9NwPC 4w== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qud53achb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 05:40:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEMB6xiMT8p3SEMZH6VBk3bTJRZ/F9/IxY/l+0E7U4I7k4MsDNv9bQnJ7B/S5ri8AV4b+mHyBdjkGhnsHFcAGvn3Ng1QlXETfbIyr9bOlIa6nnWMAr7YcbbexRphKdN8yBBoVDNhm4kARJT30oHLuEaQymIC1VnqU4PTPMZERq4sWYIdP5dtFibolvbSX5P+Fuy9VU0Yt5RUvNNEJmXAfpALZj/H21CIgKe2kyN6IkDEfb58Gq7GnBKINtc5EnNbBhhWjGX7dUxD2SvDqCVKcGWjAzwX5etcApI75D/w/AN03/udTVkZupYwXszJsQoW9HPiYR/YUy41br0eNWV2xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tzk9yKRyFaPq6jMprEiZkkKl/EqG0S5Ng59Zq+GGtkM=;
 b=F7H84oMV7E5PgEF8suYi1MB2ZnOs5T9+nrtNarUVFuT+O/tRLSXthb20YDcbagy+sL8IEb5QUyU1XP32z2OSn/ombf5ufnWS1Dm1nqyTvcZnCEH+g34j/LvxXZMZDV5KIqvEy8isCxyP7yWHmrD7aOg0XI3c8beAD2tAa0IILQMOOBP3yD5Uje01RZEFH6UbQa8/YKBPvUS6fzyFieZ7pWy/nrvrcUR9eT28niYz196xZRoV0outrS/QqnMleIw5ycra3wlfhUMOQmBS4zoho2srh0peR7vpz7pWoj0ZJewT0O9S4qMaxA2iyIT/9ApxN9cXYig/Jb10AkNoHQMIeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by CO6PR11MB5619.namprd11.prod.outlook.com (2603:10b6:5:358::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 12:39:56 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 12:39:56 +0000
From: Dragos-Marian Panait <dragos.panait@windriver.com>
To: stable@vger.kernel.org
Cc: Ruihan Li <lrh2000@pku.edu.cn>, Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.15 0/1] Hardening against CVE-2023-2002
Date: Tue, 30 May 2023 15:39:43 +0300
Message-Id: <20230530123944.241927-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0059.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::48) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|CO6PR11MB5619:EE_
X-MS-Office365-Filtering-Correlation-Id: 5beb0e2f-e998-4e13-5e50-08db610af931
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qkUwEnCFyThuODncO/BUVNWZ/EMwoS01To/0CY85XymDnINAVtZvmoIohRojJ6kj5OhB56G4fs8cpzs3Exgb5N8EKEF4CK8qOc5XWGjWMrjamWzBvTGyNiXzlM9QeqWfdkr3Gft1UGsqNPVXEmLyTF/jFT6mbTuWeLXT/gZ7u3q9noy/fqauTbZzVKlN43OhfwOZpKdyN0B9edjJfbZhOqqdGwR8CCorZW/3ikxttqUVnOTk2oFz4pXDXPezX+pRKM25KG2vsPJg8yhzSdNbrjR21ovplcV92b3y/6EVJ5a3iS/2z4n9op9esJyY6YNA3TbpBW8GamvlbvtjihH7WdTcn/nCbe/aGSGzjuWWA8Xvj8ZiFgfDQZgE/ta6LXSO84ZYYQNaTJLxFOIo9rjae6cGuxl0gw43PrvR+HwkNTf5hAM+wttvYeqd61D0Tck4Ttui9cyWYqRxOhGurkmjlRdigP08SktjKocfI8zqZRaA938siYDc6yCx79vAIZuVWnvqivdNxxFdXzS5+IIhwgi5bqqvX4XomFut2dMu5X0IZNXBQq7OL995vr9B/+Uqe/Jn3fYe1fQD7BdDiWDmPKyo4CL5o/fsOrXOvsrfUKo=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(39850400004)(366004)(346002)(451199021)(36756003)(86362001)(52116002)(54906003)(4326008)(316002)(6916009)(66946007)(66556008)(66476007)(478600001)(966005)(6486002)(6666004)(8676002)(8936002)(5660300002)(41300700001)(2906002)(4744005)(7416002)(38350700002)(38100700002)(2616005)(6512007)(6506007)(1076003)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?pbCCWrnSeh/+J8AVv6k3WW6iKpJwbd9NGbTqp1PLmudf7xQq4Jq5Imnu81sO?=
 =?us-ascii?Q?0A9RMgsQyPS/d0fpFhwmcY1jChfPZRHTWA8N+MpxMARNzdGAYXUQB3PHIcN/?=
 =?us-ascii?Q?vK47qDttWaxMInv/sWn1VVXFl5a2RNYd4JsDp7nGjJwGJZko/Gt1SkBRWXsA?=
 =?us-ascii?Q?qFoBuTT6TOn7+5pCkICgXKHh5hX5sknJscRCagHUtV+F4MRRvIi24CZkOBGC?=
 =?us-ascii?Q?eJTXcg0LIGPRxml1AnKqsLJtEOww+XIFp2VQ9iZmE1mDjj39fjZipR32NH3l?=
 =?us-ascii?Q?pN/GG2szmACtymZ4DnUTq2u9pC7cJ3IJ8FCEh0yCFhFaQIl+tNBkBw3X8TBv?=
 =?us-ascii?Q?xyDAjbo+QcXkr32oftYWgvqun1ryH4PFtG9PuLixV4Mi4tgaXRvvfYLmDMJ1?=
 =?us-ascii?Q?ARgHt4TVWAjql4AanDuhphx7N0PfDX5KkU+VxcP5ogD1LUikUnexVPWwzOWj?=
 =?us-ascii?Q?EnWD5x02YUdZG3aTC6QFrxXgZ0yeVgI2C3kP3RFqUM/V9WRw+zbzobgoexGc?=
 =?us-ascii?Q?weavOC0Z8ZylspMHuOw4AEqcdAocQjEx40hl4NzWV72Kz3kW5sDmr/pJ0hEg?=
 =?us-ascii?Q?mNzpzMOM5/F7Del+yeooAUPWQF6ZAvajzDEfoX1RhYu7JPtvfI/ohR3AQroE?=
 =?us-ascii?Q?40CieUl0ndh+YMCw0iiS7c0hxy57JNuSJ7FfLWlcKm/RSOIkMVfQwN43tvzv?=
 =?us-ascii?Q?LLGlDkti9kkIDuO0WDkDZWAZ319WgGeI+kU150PE0UuQYPv8V1r85dESR9ps?=
 =?us-ascii?Q?0okiNguZ06zH8kpew8UU4sBAD8Ei9gVGOBzK2SnjDzYlD5K9RvC3jLbU1col?=
 =?us-ascii?Q?1FwoLY2BJXR7GQUTZokfUqdk2VpQQfTB1u+Bjnhy3JuYOjzdw4GYX8w4ytcv?=
 =?us-ascii?Q?z086yM6BdhIsF3BR/H88WCjPh63oH77ZTlTHKlwpeoYBnkB2CMvhs77Vu0M+?=
 =?us-ascii?Q?jzXjK6obk74dlNdIH7aIas1obgOFen5N1nsKDA/lrs5Sah/8p0O0BIOnjB09?=
 =?us-ascii?Q?tVbPqTutDecmgmA2HxLz063/+aDZ2XnyDKlxsjIFN4AOILAqw8NJtqwi+bZo?=
 =?us-ascii?Q?m0idz1KGSiNmgXD0Sd/JucYaQOH79acZpgUDecbRKsfUjAww3bYzlaa7W2ZY?=
 =?us-ascii?Q?5pxIKXJtz1cJwaEj0ZXGYoOz1aCKKtmZsfdzqrAi3+8KiwN06Jeg1p5NQg16?=
 =?us-ascii?Q?Yzm5xcJKYFBfczq988hjiRgGA98tiJnn7pgqM+1NwlyK/0JX2tSJYShJZOrB?=
 =?us-ascii?Q?U/ypRTXS1o/M9CL6yNtqje2kQRuJglgAwOWAC7yP2t7n6oA2cSfJ7rtuT7Uz?=
 =?us-ascii?Q?Cri/TpSstySeFE4H0386SHvMx9ppKQ3KfXejJVx3UFTUvpFwjkJrZDgtChuT?=
 =?us-ascii?Q?hOQ4GcrHjhzoECxO8+zlSQQJC+4cwx9PdvBQYNvcrhcKQR5mcs+5gDrmLjNX?=
 =?us-ascii?Q?kBb1jyLosLQ1z+py0yg1Pd2HCyrC31FvMFposfpk59k/dNJn5drIyVVHlGZv?=
 =?us-ascii?Q?ozmaMRNYGuIUuPcpJUwxBwQYF6eepff03zc+B0O38YNvkMRcQfDuE66JLU4E?=
 =?us-ascii?Q?yE1f6Tat+ZO5Z0Jyqb0Vo/WkkdUXRiOhAJvV+SJWXkFbCJwf13DxH6IsN6a7?=
 =?us-ascii?Q?Dw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5beb0e2f-e998-4e13-5e50-08db610af931
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:39:56.4805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rrGQIWO2D78g0Ojcw8eSsmFT61K0ZDibUnFnY9s40f/UZjNSssNJj0GEHZR/tf/BN+xnL6qR90s6VsY2wlu6P8B0xeof9CCQw/3AuQcbYDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5619
X-Proofpoint-GUID: NEE1lUTSfAaTF52i4tOtxtiIqOWZ6Aqc
X-Proofpoint-ORIG-GUID: NEE1lUTSfAaTF52i4tOtxtiIqOWZ6Aqc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_08,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=602 spamscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300104
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The following commit is needed to harden against CVE-2023-2002:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=000c2fa2c144c499c881a101819cf1936a1f7cf2

Ruihan Li (1):
  bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()

 net/bluetooth/hci_sock.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)


base-commit: 1fe619a7d25218e9b9fdcce9fcac6a05cd62abed
-- 
2.40.1


