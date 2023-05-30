Return-Path: <netdev+bounces-6393-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17623716162
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:18:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC7481C20C7C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 123581F16A;
	Tue, 30 May 2023 13:18:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F8D1DDD7
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:18:28 +0000 (UTC)
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36643EA;
	Tue, 30 May 2023 06:18:25 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UCQrk6018554;
	Tue, 30 May 2023 13:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=0+/bA8HgWaWY4f1OSPjWlKT53Lt7RqEzipLwsB3Ic2c=;
 b=r7DzZ8AQMc/ncvtf/OYNY71PBAb+vMIJg6CZZ6KmUuOsnyAXfp+LfDuBze05x5Vsy6Fv
 htpUSckPoCpU6ukaEvw2IorjjxrC8CNyFkl9+/ZODo/JnbHWj9IeOti8bCmtnv+erehS
 AZMmxebe2AOPfGC7h4tyDRPYsZtpB7Cotl1Ecpdp6flwJqJdjj4fLC0zdxHYNBBl3WvD
 6Y5rCGJoALHPEVrYUSXSUKIHZpmIRfhGE9zwGkgUksDYfiZPqhgYWLqbQDOfJt14azvd
 PlEMY5a7nwQH0TQiXTWQYlvT8n1As4DNw2sU/MA75YqmKgqai5IyfJg391Lei61cGdyz Qg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qu8u8jkef-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 13:18:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqXppFDBhRlwsBwBbRdEAxgjDathAshXUsAjrPmsNBstC5+0luNszV4+NDWZ26KoY9zUufYov+Xt3bdunud8rMavS1/vQ7lgNW1oMZW05er0mKELTjWsRmgdC3zLJXATBwQqeuJLoImQpZKB5XfEfJrw7E6v6+BYAoK6gRxGnWnvJSmkLVMQuAgwzqLjpDGtnNAhLGbToULwOji3KKOYifTNeVSzuRPJW1CmtoYboHSom91GmzgM4tkcq/c+kRPC7zacxdQLlO/wcg2nNJ13lYoeeJaNVVWYZ6HtptBoJfSMcd1/ayo/liAYo9NClFhY5hs8d2SZ0Ml9ueYMv5+EaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+/bA8HgWaWY4f1OSPjWlKT53Lt7RqEzipLwsB3Ic2c=;
 b=E7CrfU8GrKOd+dVDo4gQ6k7ceAblVtDDBkLWr8zf94Ak025PPSasK6n5vyxJfJYgJvzxswwGAsHqb2kr8i3LhXwDFQGRTMF9V7LK9vcKXvJx8mXdQ22ZPF/feBdr36DnJGD3UruHijoP8YVg6NgPTO/tCqi7F/2UVRH2IJqkuho9FiCd82PsAEb7nvqnixtiYjmifw/PD5H9/lsOv5yo3TtYBCiePLxqSGzVveZyk0tJi6dUyEMqeeqa6WdN9vVHtzejmn+YvT83PGNBCp9VB9ltyWYV3LvqItGVAxOdsKBi2NWPw/RrwzsMDTkvFjjF9MN92rxiKR49X0menl4vPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by IA1PR11MB7366.namprd11.prod.outlook.com (2603:10b6:208:422::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 13:17:56 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 13:17:56 +0000
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
Subject: [PATCH 4.14 1/1] bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()
Date: Tue, 30 May 2023 16:17:40 +0300
Message-Id: <20230530131740.269890-2-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230530131740.269890-1-dragos.panait@windriver.com>
References: <20230530131740.269890-1-dragos.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0025.eurprd05.prod.outlook.com
 (2603:10a6:800:60::11) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|IA1PR11MB7366:EE_
X-MS-Office365-Filtering-Correlation-Id: 88fc41a5-6d85-427a-1139-08db611047f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	pRBRZsCwuMnRFlr5ZHvZxdbYQBJ0Ox4y7MXqGf+7+GPCGOSG3+M6WAVPrDn4WPL4stKBv4gBqvXI8IgR9zJ7Bb+A1LOBueN9iFiAQMBuKUJ/lW83qlB3Ax4Ucd0TiubXVJQQIsH16GMo1swD55/MesW9Yn6jb8Tcj6E4NMtavKOksRxQ6e4GL4m5Ly06zymfgrXZ+ewUyh7VQaOZ43MbhckQQTtlo5UrW2HBiI0NzDI+JWHbJaugfd5+9f/Eo8CtrbdEcNbKL5xAhOmnRJkk2tCPqj2P0TFWxF9GKidZTJlRXE18Et2VhIY7sP7+UzSOnsGxGmVl8jKpePSrv4603WuxoNrEthENLZNJ4XvKbezSBcQUs2GrYSTz0aiVQRpYyhqHpnV9j2tKp910InEcJcxGPiXPGGgFPVBR6bK5EhzVAK2mq19iEiS5UTyH0Su8dslkN32EFsvmxWiRMdkd+F/2w+1YUhA4paMcs2msvNNet5xYWbLTG8yJx4UT19Th8ls3czoudxUohPUYn6RHtMz6jSejJOKcKtwbK8xLmhse9MjOmHd/zaj1dzkgL45Mhkj2D/RnvaRrBLgJ5rAGblvE8yXPnvI5Ze8C8jOxOYDPuISGFnYs7JMsdWd/qoBV
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(39850400004)(136003)(396003)(451199021)(6486002)(41300700001)(6666004)(52116002)(83380400001)(316002)(86362001)(186003)(36756003)(2906002)(6512007)(6506007)(26005)(1076003)(7416002)(8676002)(8936002)(5660300002)(2616005)(478600001)(38100700002)(38350700002)(54906003)(6916009)(4326008)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?pqbhK/29YvFt7nLzHWF3ZtelxyjFkGtUGPQua+Hm5douvMHDp8vHW4WTKDl3?=
 =?us-ascii?Q?5zsS2w4bA99O1lu/dn1DLuuYN5Ym4xELkX8pDOiyo4CB9NNCOtIK/LjUiOQg?=
 =?us-ascii?Q?ZPK605/yx3fl6jT3ZV9ljJkxURo5NhyHFONyZWlsD9h6YyQbdZDkvfuCgAmy?=
 =?us-ascii?Q?px1W27T6VJLZKLWCuIi/Mo7UBmKHUbQlDqILS3uB/HihtspkhVFjTQK/9rDe?=
 =?us-ascii?Q?GdcvbPynHFCHTrny7RQgnHUfi8s0mv+slmIG8dRDuquahB+fYu/RFxZ6mImt?=
 =?us-ascii?Q?mlSsnnCpLKKo+7xVqi3snBpLOP2iCkpehT4d6blZ/cRfoZuOefa3yW+TYs9k?=
 =?us-ascii?Q?D8JU4uHCN7QZhwVUFUfsB/am+kCRdTgfyN2+ZNp2B/Et9opCyPnPRuDyvjzu?=
 =?us-ascii?Q?Y4k1B7yQfL44cuX2t3rbxkZ05LdxAG3il894s7eTXzNXf1OyQXaVrwR6NG2b?=
 =?us-ascii?Q?+gNc+vrwF+nAAbb9GYxl7DGgrxJyZV3Td11dblnMPSSfbFZqz054xxKRFnSC?=
 =?us-ascii?Q?Otp5RGRfMPc7vYynLST79zbWV6tp4nG42oOZzmYHatB3/VPVxrAGmnuon9oy?=
 =?us-ascii?Q?tCcwqZBk5qiE8Z+l2dEDjUQECd93yIglsLa4ydLq+KYKSUmLhRuM6PH9Y8ns?=
 =?us-ascii?Q?moeCJT07YMX8ivIn3+nPzHHsnT/S4Deag4oIUOW+hEtOrboT4z9+XyeEjzrK?=
 =?us-ascii?Q?zQ052BBE4gn6UqSYUGiq7tbXjqJk2tyzTPZJk/8ZpKGVDAMqSe5JJphkYQl/?=
 =?us-ascii?Q?j12e3TcOhvRIftncS7WIfPrewYap8Ygo0kZPaTLyDmFHyzY2qrB+hhpvEVZ6?=
 =?us-ascii?Q?U44MboHYJj3j6ctE3qI70pMkiVgcyAi/l92Y5s+EtXV4FGmSzyywFOpnHGdy?=
 =?us-ascii?Q?Q8uZnsapFlIq64EukQodnP6BGNSGncToEqiXri+s0NrYq6q0I3ujoRCqMHDV?=
 =?us-ascii?Q?LlQrxNj5qP7BSeoLjGQldPXe4XfZroZr1ZDUkTAkqRJIWQpim3+RM/xTRvDy?=
 =?us-ascii?Q?g5a7jgt7VIqXSnuRXd0Lp8NtBf7xnbha0G22g2mCXXiVWp5Q17vNLEqdXqEM?=
 =?us-ascii?Q?XOdCu1HjOQBFUX45fX09ocghktuSu8YdgxftRLYgzjreaRyirXtriNlTv/fH?=
 =?us-ascii?Q?80ZLrpKxvDcb7qEiZVkn4gBxxplc1Yie1wblIUpgDyIn5p6PmrFphFBSuUKQ?=
 =?us-ascii?Q?wW79y4U+NaPxxQhJOmoIy5YDxXY6T9AbZCMeM4eZi+Vd4H/gHgu5x5Kx5T28?=
 =?us-ascii?Q?+gZle2Mp2oIDLTSf7yRuUPxq5kcWMH+BosLtS/dBSzJVB5JJ77whkLv92XZy?=
 =?us-ascii?Q?fNmtwNQg8UZ5gHz9ZMfI5/DHXI0k0RiINeFaj0nOj5fLAgMa1YTzE5L91Qy/?=
 =?us-ascii?Q?MlUsTFfwXqfLCORhi+T+fG4se0cxgwWfpBoq2GEcxRSYiTaMdGWRzeTMDjKF?=
 =?us-ascii?Q?+Z4Cwobe/sfWdwhoW2tBFxhF8kMVVsDb+B+mPu4rIMXEkJY2fbw3hJh5FPgm?=
 =?us-ascii?Q?K7rCOIemSg0V9aV3lsq9RtyfKVoT9bC1CoApDgwKE03AzSlM4k2rAu2jDyox?=
 =?us-ascii?Q?IQ3VnGTgupzroqhHrodxJ7LobqwqAneyYphGC9lI3aiHQLYK9jJ2QrDvyPrE?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88fc41a5-6d85-427a-1139-08db611047f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 13:17:55.9792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +c33P5b5bYl/kL1opn+gRYSI8MqBbGhluaLXnRGPjpb9lL+7nNFGlIDu3bRrC4M7F/8zHZ8tfZnuHTaNhQloFDJzHK156Ji9ZP8oCHpy4Dg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7366
X-Proofpoint-ORIG-GUID: i9Oa0iTh28HmzIlLZie_1O1SwCNKPq6c
X-Proofpoint-GUID: i9Oa0iTh28HmzIlLZie_1O1SwCNKPq6c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_10,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 suspectscore=0 adultscore=0 phishscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300108
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Ruihan Li <lrh2000@pku.edu.cn>

commit 000c2fa2c144c499c881a101819cf1936a1f7cf2 upstream.

Previously, channel open messages were always sent to monitors on the first
ioctl() call for unbound HCI sockets, even if the command and arguments
were completely invalid. This can leave an exploitable hole with the abuse
of invalid ioctl calls.

This commit hardens the ioctl processing logic by first checking if the
command is valid, and immediately returning with an ENOIOCTLCMD error code
if it is not. This ensures that ioctl calls with invalid commands are free
of side effects, and increases the difficulty of further exploitation by
forcing exploitation to find a way to pass a valid command first.

Signed-off-by: Ruihan Li <lrh2000@pku.edu.cn>
Co-developed-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
---
 net/bluetooth/hci_sock.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 837b0767892e..9b1658346396 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -968,6 +968,34 @@ static int hci_sock_ioctl(struct socket *sock, unsigned int cmd,
 
 	BT_DBG("cmd %x arg %lx", cmd, arg);
 
+	/* Make sure the cmd is valid before doing anything */
+	switch (cmd) {
+	case HCIGETDEVLIST:
+	case HCIGETDEVINFO:
+	case HCIGETCONNLIST:
+	case HCIDEVUP:
+	case HCIDEVDOWN:
+	case HCIDEVRESET:
+	case HCIDEVRESTAT:
+	case HCISETSCAN:
+	case HCISETAUTH:
+	case HCISETENCRYPT:
+	case HCISETPTYPE:
+	case HCISETLINKPOL:
+	case HCISETLINKMODE:
+	case HCISETACLMTU:
+	case HCISETSCOMTU:
+	case HCIINQUIRY:
+	case HCISETRAW:
+	case HCIGETCONNINFO:
+	case HCIGETAUTHINFO:
+	case HCIBLOCKADDR:
+	case HCIUNBLOCKADDR:
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+
 	lock_sock(sk);
 
 	if (hci_pi(sk)->channel != HCI_CHANNEL_RAW) {
-- 
2.40.1


