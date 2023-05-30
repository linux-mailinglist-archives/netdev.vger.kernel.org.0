Return-Path: <netdev+bounces-6373-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1B0B716039
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66C692811BC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B690174DF;
	Tue, 30 May 2023 12:44:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56731154B0
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:44:17 +0000 (UTC)
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66E7133;
	Tue, 30 May 2023 05:43:49 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34U6i4i9028450;
	Tue, 30 May 2023 12:42:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=HVtqrGhWrkk74d1JWENu8WJMY9jkZAoP8i3ty87sbR8=;
 b=KnRtQph+rmkfoJ/Pf0mB2tnqZo1RaEpfmiyvicGLEiuJhv2Smu+jOUgt1FM604XHy9bK
 1jL0sdTvbWxSt3G0OSG1SA5Nqb/WAzChXs+2BLKrwUIwoC8WZ3Nox6bzcAx1qHANdIDg
 9sr+4Ktg6EN2K5SkGZWeUwIS1xDlDdnaJ28YBFgJfZroohxTS4QqJdQPcjn0vsoDM1Jt
 o5JnEq4LtF9/GDjJH0b0zU7+9nzLW9XwoOdbwK57w6SbOSqma4MJ9HAB9s13jZiuXLg2
 hYArPROu1Xi/DdQxmRUhv1SQdRRh8iEx5l0I0yqb8tBdnO7DX3wmiav4Scvi9pD5js/U Rw== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qu730tkyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 12:42:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dad6p38yVsB0tcZn7sZsmgUNrsufiA10xaG4ypdYhcsEadpfNlBsVCUHxvFczoAX9yFyoimQMkJLWOljWOqfB1OiFRdMqCMXht5O/0F44QVZap6hH4z3ktrSg9tgJZzZnhAX9jVIS+DNM0ktJtL1BCobyQeWg8GRj3LF5bNUSx9LBzZ+mJBcLtrxe+y8exv/Oa3V0OopZUIjwXFRUpFaqyYS/fQRtfGpmUDk231P0lT905av718v7m1ZCazfTA1oY0gQxfsL+VManl+dhNx13DthL8v7Pc6N97ITsoFV0jUc33e2vGXs4nNYN7zLwypIXip3yFUohnLEQnJDoJ787g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVtqrGhWrkk74d1JWENu8WJMY9jkZAoP8i3ty87sbR8=;
 b=lqE6/DntYglQG8r+PXFpbn0Yn2A23NDukxGQi5OEd6lDNvwC35+G3LxymlxbWAaXj2sG58mM/hCS+owMRRKfz7U+CqydjfDeAozxLW2lBnxH3dz+w0XjL6JccECVjrbYf1yPGh//GLCNo9Or7kYTHuMQXILRptLiIfLqMpx5Yt7IWi2EsMBR0Ss65PR9C56jXa4VfPFkUpdf8wTVDmjz9R4KGilsEQfQhnviaZh3lS2bAjErpo99Qu3sQTDYpN5B8ZVQa5vdARPZusiQ8LotvjfKnLygEUpxmdUuNDW6rrzcAA3lDAb29uiS/KkLQE+F9pf6ruZF7bMeLgAgLHxpXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by SJ0PR11MB5117.namprd11.prod.outlook.com (2603:10b6:a03:2d0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 12:42:26 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 12:42:25 +0000
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
Subject: [PATCH 5.10 1/1] bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()
Date: Tue, 30 May 2023 15:42:08 +0300
Message-Id: <20230530124208.242573-2-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230530124208.242573-1-dragos.panait@windriver.com>
References: <20230530124208.242573-1-dragos.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0076.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::44) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|SJ0PR11MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 2539ab34-2bb6-4be9-f844-08db610b524f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Qz+KL9/D2JNm750GyQEQeCnikanar6qK82cxPNzR0Bn373UekPoAZsvNngXcPjNW2tofA6eH1znh/ocwmD7geWLvr8II1n409rMUcvKMNCL+U0Q59pq0C0bqgbnMaB3nj/1aoIdeySR+7YvYjKZaYPeH6rsIA8CiRHVM8WG4AasafKwHW1GWQpOF8kjXiM0rycMU1lfzA/cJ1nd9U+sUArA/16RdzwETir88vqPzNuesOYH3Ko01Qo8zSLPu+9ijuzslReoUFR7iZT6Mlh6eP6iOMASW4jz4fDl+jrASgN+HNgjr8cdaRRh6F5wXIYH7vVsC1d2cOYBoUyk+FI3VCbBBG5Y+lItv56+JMLnOimr4IJlcZvwaCDV4lrh/5jdAqYWszB/nRMfT9FDM/u0FnV/mWO74qvgeenT2SpgeEa0OKo/6gnk2krEEb5t3CpWjROs71w6suRt2RICBhT7mPJ6cuMJe2J1uaevK2Gjxi0cbSCZJ65eLblgB2Ze0DLZ7Gf+YeQirxCDtryXseNJ3m9j70ipXSiMrbTb/RyVPkh4/rbeAJJC9i6mN0Q5L9Q/vj1XKaBZnq53ygw4Poj4EiF/vuGzjcuoz+0SewiKWkxxZOJ16ysneHzqWH2aNwtAa
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39850400004)(136003)(366004)(451199021)(186003)(1076003)(6506007)(6512007)(2906002)(2616005)(36756003)(83380400001)(6916009)(4326008)(6666004)(316002)(66946007)(66476007)(66556008)(6486002)(41300700001)(52116002)(478600001)(38100700002)(54906003)(38350700002)(26005)(8676002)(8936002)(5660300002)(86362001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Dg06al+LAf5oEsKthMD5LVccGecvIk5T0+mzOqz0GFjOGOK4gN/PSg+C0W9z?=
 =?us-ascii?Q?IxX1ojGDUbzdcZzFW19WUNpc0ueMVUexg0811MHNaGeHganYhsZS7wQV2zP+?=
 =?us-ascii?Q?T18StovRJ3lm2keH+KZEJlW008dYU+IwA9NbR6svYDMs5oO21cszSa0RGGuB?=
 =?us-ascii?Q?3KIudCksCm8/gHnfcj7HZjIna0ap4g4+MtCHxU1mHpMwyfLCPYpP6q3KfMFm?=
 =?us-ascii?Q?NmM2X8n9wgU+rHkKZsWicSO9s4bKEuvlPFHoC0JMxgPYqz4VpvTEPeQbYx4j?=
 =?us-ascii?Q?LpSAikV1ckSc4PUpKbRMWyYgNXvucjxRq043n/ShmWkx0IoxopAB8Vj4HBdi?=
 =?us-ascii?Q?y7IXPq3h+e+0JeAKR1AfdKC9p9YTExN/Ifv9VHHXV0MMZTVnbHazkgrEK6Q9?=
 =?us-ascii?Q?/japwUjwvAyLHXGO61jWBZhDu3xs+GMrqa7OazlMbkcsR8QsH5mBCnqDcwFS?=
 =?us-ascii?Q?gMNUIaxuUbtL/Cm74IVALFzvFpQiD8NO67ptP9dK8XVvKxdwn80HgfKMC7GB?=
 =?us-ascii?Q?rjT8Xjro24CwXYx0B69un4id56QQtFfkQ0QeQzgNfVadkEypXFeG62Rqs8n2?=
 =?us-ascii?Q?AxWyPK/x0saVm12I5/ZXzW1L68YjE1ZTniEw4DTPHcO1AUGM1/kufOI9eq5K?=
 =?us-ascii?Q?i5Ecv8WBJ1Tp38l89UPvfb2PV6RSeY/BQjskkaAoXfydf7allNR+lxEvq3bE?=
 =?us-ascii?Q?MJx4Eu8xlr1OGDhOtvmCLYTDnitqpNSZfbvD2ppyweYdo0VLbMlYGTviczbn?=
 =?us-ascii?Q?/Hecs5FRGTn/SL9bZFrcLmqHbAXhhdDshBTG64ayBWTxvROrvenLWPetd8uk?=
 =?us-ascii?Q?y+aRnIALvwyOlhHMoXI/8PXDDdPZlrWdlXpUePUX6xiHbqawuY/XkWR+VilP?=
 =?us-ascii?Q?DkkFQ4Up36wO2nBlqV+9X1NJU+zbPopp+I312VQ//V3cmZ9Y+DeuRftzYDCC?=
 =?us-ascii?Q?yVz8rzqdxX2B4+EiHFmuU6xSXv0AdFQZgi//Z0XQVd0yJoF49X+okdCsdFXx?=
 =?us-ascii?Q?Wn5nXY6OfUbsBfIkV9cDZDA0MeHMQgCWPnWhWYuBgLQuOX3B7K/qxUbc/DkR?=
 =?us-ascii?Q?816H5Dm9huQCIgPhqTDH4F3yDkX/7NJtgVQhQti2JRVJECHnsKhBzbRwike7?=
 =?us-ascii?Q?clu5ByV16AJsrZaJcEUiovXqkFAZ927PiKpHIPudMw4L1f0Xm9YRAY7rUzDT?=
 =?us-ascii?Q?Dx7y0GvsnJ56Jw6Lt1Oo57BPHPd8kmwHMypxxpZntFn9t7AsFr0/E31fY1hB?=
 =?us-ascii?Q?+tlka51pLpxzXVpw1xr/0h4yRHF7alQDSFL0XMmhlItu2QyzE/EAC9/b6Rd0?=
 =?us-ascii?Q?Qflc/MseIJYIPrplsoW8F7AqYOmCc4v/drEtxAxhHA6SwBNU5fcqJOcxP9oS?=
 =?us-ascii?Q?xlr6gd33ovR/CyQXocC2j83PlNtbe9llJ/MyIv2oJKojBzxfNEqrD46/aA54?=
 =?us-ascii?Q?XUoHXwE9wTPEvj39VSugt86vX/5FvlzldshVRY99ENsPdCDKa9FgVN6687wB?=
 =?us-ascii?Q?Gsuk24o2/DZ6RZ8NMs2kW2RieSchyna4XAPBjhqUIEYlaHL67uXzZ0T698vz?=
 =?us-ascii?Q?VpP7CNJnZvSR8fVUKvwXsISx4dEV60XLIT9yNFQxxENgI1UCaaVkYmUgdERe?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2539ab34-2bb6-4be9-f844-08db610b524f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:42:25.8527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TnAbNVOY6xJj41lhrRcuD6i3yzeFORhJ1x9RzLa41NL7yzvIuP+Ohqyu/pUB5pSuH9SSYDfXIU20Xq84JZ1xybZfj7ecgmqpJIMdyEItc2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5117
X-Proofpoint-GUID: AMF6Jan3yq4sdNhV6fdNNcBuf2cFbohk
X-Proofpoint-ORIG-GUID: AMF6Jan3yq4sdNhV6fdNNcBuf2cFbohk
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
index 4dcc1a8a8954..eafb2bebc12c 100644
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


