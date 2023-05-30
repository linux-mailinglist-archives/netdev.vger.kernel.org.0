Return-Path: <netdev+bounces-6370-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9A3E71601F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 949351C20C3E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12CF174FB;
	Tue, 30 May 2023 12:41:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3AB174DF
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:41:39 +0000 (UTC)
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870FAE60;
	Tue, 30 May 2023 05:41:15 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34U7tbGl023706;
	Tue, 30 May 2023 12:40:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=NleqgRGdnex923H7ywjKjiAkgwTon2qBTYzzl0ahE2g=;
 b=pZEtBBNbUxRYYbNnhvurpCWpjoMMasuJ8/u+u45Y4PFGw/1RsTHW19iVbILlrrqfZHsD
 aaqulFIKpIMDbe8/AkgVDDzkTIVojFmpITjyke6USAIpjBWiSk4WWGTBJjumdPQWW4YD
 t9d4a0p4oQJpcis+6tyJQXklcBJG/wt7XN5ziTICtHkIsZBKz3kEf4GZjOYfC065Awzt
 SsXcdoZkuDzZm/tZpG/4i9mA866McnzG0WPcR6CE9QaMT/P4NgAgnUV/iy2lpmb5L7pN
 aWI9pDY0xZMDlKfT/KBRkEjizM6YRuoopIYGjk0w13IBtOjatmQOBlh+BCBuH50O/we+ iQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qu730tkx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 12:40:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Thd/jv5YG0CQtLWfmjh7FqSM8CJ2CGtluofYMBHHsi9VkD1Y7RmffYdJAnOpAQK/7imr7rLfdq8WLDux8RZjuAffnNQqLGVq+bJpo5FRQqhCxGhj2943ia0ypiuOA44Zi6VIuVs5F3HkXdMlAIBRnMKSr84+Wo8viW+uRmVSJvS30HLVHVmsv729cEmYq1gVcXEep+vtslbdewyIwg8lDDvRaxzB8gA9SZk63y9T56P+ndkf/Ny5NG4T64gZYMmAgowcH6FnQBPBdAho0zo4pwuIZCw23bHER5ZDQnkkUKpzKnKUNqbYxD7fMWxtVzh4chLTU9TBa8Mo7xpi04wfkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NleqgRGdnex923H7ywjKjiAkgwTon2qBTYzzl0ahE2g=;
 b=an4yE9ExpP0aw73zbEx84Pxfv+bv5DzL0P5nyiPHdDiGSCBh0ph/CyyIADdAXBWdS9Y7IaPHuLKPrg9LPZkq/zJT6zejCyllz18NRUur4cZ+Z4VBNacPjL3JRiH2lddlCXi2vc8RIShjKNwWdlkP5lc1NtSC8drk8sfgzmocrr5cH1hPq3K9X33Z9nx299qmzZRKIaqj6tpj1lAYkWuhckqJxdD78+cas/Cpd4iLecYLIBKXcOfu658UaawdQeuEIhLFUtQt49LDaC4CQif8uZEN+edpFhMbby1W8WX6rK7eNdNhtiLeWVsZC3IojLM+4XFB2M3oIEKAq/1WTpu8FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by SJ0PR11MB5117.namprd11.prod.outlook.com (2603:10b6:a03:2d0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 12:39:59 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 12:39:59 +0000
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
Subject: [PATCH 5.15 1/1] bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()
Date: Tue, 30 May 2023 15:39:44 +0300
Message-Id: <20230530123944.241927-2-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230530123944.241927-1-dragos.panait@windriver.com>
References: <20230530123944.241927-1-dragos.panait@windriver.com>
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
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|SJ0PR11MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 91975bf6-e77b-4c4e-556e-08db610afb28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	4apExzcX3AsoApJkGXy4hnvPs4RDKq8Qz+0s7ltJWOicSAXkv6Y3zXDz7yWDVxETHBnPvfJpQGu8ESyqZTl5yDuC4R9pVIoUMln+Att7hLdso0FXWF4qzlqlwiMeF2OKAzPYdlN0Pn2I1tGZO0qVMAYITjtNK1KJOd6J+Gnx60Zm6Zzoo7wv7ot/4hXkHx/pkzg+se66YKmreTEwlSGHk3oFbpDIeHcTlygEQ8RFD3pw+OYIXFhwONq2jD+hW9XHwqrYntiPaD97vln45FknETLkhyYre1c2I0oUULMsnAKy3GdUdOj9pe6DwEFdzYi6TfVIEUQHDs+q7Axa06akpc0Q6EmLaEhNK3/rh/vyiAxwY+XBVmbuTuK29b52k+nNfdd4wcdY3NSmWmPTXVJoQyPA+0ke3Q4w80lbcuUTYhmHpb+DjsRJJGo9WCILF2A1everqcvAmaHsROGLR0tFAmXkNr8mRtu24/ObDUga+gPjLcn4i5KOyn1ZNtn95dYSoy6pgOCvf00NX4iGm/2RV+UcQJR3M5BtckfXKCoF5wseOAuYwqk8u56RrmCZWUSpg8zjzHWWsw/pOP5wyvO8xBI2vP18EoyfFxNFqnxgAz1UftjLaT89Yq+dEAr2gUJC
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39850400004)(136003)(366004)(451199021)(186003)(1076003)(6506007)(6512007)(2906002)(2616005)(36756003)(83380400001)(6916009)(4326008)(6666004)(316002)(66946007)(66476007)(66556008)(6486002)(41300700001)(52116002)(478600001)(38100700002)(54906003)(38350700002)(26005)(8676002)(8936002)(5660300002)(86362001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?lAipuJTl6TMXf65k3rFwp2/Vgs/+q9vVHZponCdD8WxCIOtFOqhoUuERCACa?=
 =?us-ascii?Q?BxkiAmXG1CSErstPXd6kr9+p/zwPp6Ec4kN4exg4L4VxgKllIr7j6tqLvjuk?=
 =?us-ascii?Q?A9S94b6GX3IG0mIsPnu+3n2M3iJcD/+0a214AvwNcoS+1HkmSutNMoCctGUq?=
 =?us-ascii?Q?W8KDS5iR6Msmp2h0bRHHJBef8ew0jF60xN9wF+pR2VMP0nMxkg4nA4Q/sngK?=
 =?us-ascii?Q?yhwAtLFKjahT7GEKBUSn52aepeWP26ZLW7/PnEW/x0PIQXyjw8cs+kJJ3POb?=
 =?us-ascii?Q?h6ptfQIHkBn2f96tSuC68Cxvd6fRHJjEPg0NBLiOywImB9+rSjzR26VHQhPn?=
 =?us-ascii?Q?xTwW1BJfffoPfSRn2fvJmmL89CKAYFxuXL7HtSgKyMqtrjZcwOM4cpDKVcGO?=
 =?us-ascii?Q?RKVCe6jzVSs4/JqVRE7+eLD/qG9UoMGnPIbTacQeFIZHthEEM/hwKMuEiZ+n?=
 =?us-ascii?Q?RW3ZGuDGjkVacKkdSFrpBRlViVAOxmi+bby1lSVIi+OrBLneYx9tB0uNqbuR?=
 =?us-ascii?Q?urVlnGfKKEPPf6suhuhZiu5KN3suuY2Spy9iBC5JBVlrUX9S67dFeZ4DC0yn?=
 =?us-ascii?Q?oZqsRBj8LfuHWIr8/GWbGsaSAcNjDpDnhqUiV3oXy+pwbvd7nqrFrLfy3gE4?=
 =?us-ascii?Q?mFTLs8h988BgwUhxWEbmvDaekuRxXNyaNZTvI7X9G2PCXyxsFpksoqq0aImt?=
 =?us-ascii?Q?0k2NiN9KhxgHj+P89EcBjTDpIRo/ClTbrm8cJqZ0cemmmUIR+gEFnKn2Wuoh?=
 =?us-ascii?Q?8zw4122r9HuaZPE+kmzhyY93XJYwwcndgtGPBA+Tk9TH1H6fGBuEWXGPAO2k?=
 =?us-ascii?Q?QtKdHaa7AeWXHVpPEbHeS7p4o9rAVlQnjt33gRMKAgHtswgfZmJ6YBTt0xGx?=
 =?us-ascii?Q?57zxdYQigGrHVlnhneBrjltE914oj5Gk5PuwLC2Upb99unLLOBuZ49ewoWBH?=
 =?us-ascii?Q?He5TlhXdjffbVZXOrPyNxrqMCl6UqCohKRXl6yS3Ul8G97zPaT/BRS5/WdOZ?=
 =?us-ascii?Q?U4mb8joE1KG+ilO1XVAlm4vHIj0xHNy8EloUHxKjF92sfbr2V2oBzF2LNMOm?=
 =?us-ascii?Q?Sh/L9yjKMWRH0BwgxZcvS32UtqPFpUK4OduEXfU0ef6QLopu8UbwCAu9ZZrG?=
 =?us-ascii?Q?4WM5EW+mYyLPQ9mw4lhbDTugvkyOXl26pwbk6lQPBZKhk6qRotB9L/deO1Ap?=
 =?us-ascii?Q?UPCIer+H4lhf8L47/gT7JcI4NEKYARdKaV86aYzFGySw51hyvv7hPJWiFs8o?=
 =?us-ascii?Q?4AAEWgf9IaNP8rmDiL0xUfO/2VIN0xsHcJNC5X8tRG/GVZ7mpIuyu6B1ejeG?=
 =?us-ascii?Q?cBo27Cup2DTHhIHlDI1YGOI+UoiwFcZsfuMdAsOAoXRUdUd1gYSJZInomBxn?=
 =?us-ascii?Q?k/4e2i39MEXf0HGw5v2SetT1VCFqzMIeJXVwOAnMbAau/Usg/lwHffloX5Fv?=
 =?us-ascii?Q?fWQWysZ+ZZw0uHVXzXEPbYwM5lbdi5fKrJPmMTnM8aBIX4M5vtqHmtWl4Q4w?=
 =?us-ascii?Q?JblKUlTltChwbrbD1TjSI/p11OJcSPNopBr1ythV2yduJPxs5DX8X63u05/K?=
 =?us-ascii?Q?/Dn9mfbWSEjWpcJJ7cQ68GisJQ8U0/MCuqO3qVIy4M44V0wN6g72QAOGINFN?=
 =?us-ascii?Q?ig=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91975bf6-e77b-4c4e-556e-08db610afb28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:39:59.6066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0budJJ9HF+spvISo+V3bVzhaA4ALaAz5xUq3/iRCC1suUyvl0DIHTRrE5Wb8DiVGuLvh9Q83dt3YuKS9MjAD/Y7n51XnL7pcDEMxVbvWi2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5117
X-Proofpoint-GUID: RMmG0GtMdgzhWEsSHsN2TQhMXFhB37Bw
X-Proofpoint-ORIG-GUID: RMmG0GtMdgzhWEsSHsN2TQhMXFhB37Bw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_08,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 spamscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300104
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
index 7905e005baa9..315f9ad3dc4d 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -980,6 +980,34 @@ static int hci_sock_ioctl(struct socket *sock, unsigned int cmd,
 
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


