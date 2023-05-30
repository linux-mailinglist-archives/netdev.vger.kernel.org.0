Return-Path: <netdev+bounces-6423-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88C247163CD
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:21:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E3C31C20C07
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3963F21083;
	Tue, 30 May 2023 14:18:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2622B23C63
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:18:30 +0000 (UTC)
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0ACE60;
	Tue, 30 May 2023 07:18:06 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34U7eTRF018295;
	Tue, 30 May 2023 14:17:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=Sqzwowbop0wapqOookzFR+jCdN68cDsEDQ9yQyn69Wc=;
 b=sfscYL1A8WxrRRIvsRN/F9OrDvASqzsv3rerX9ux/MEbB+f6VvDnn5Ym0LJVO3DGYKCT
 zywCn8F0MbD5i9A8JGC1g+7LT1SY3Pv2xToYqLLWX8fEVARjxZQR+gnN3kYLkjoi3gdE
 hD5W/kEjAffmtoqYDz4ZnmkHrvnJNwlankwLcPSsDX7pKRMUmfCNCXCwIb4OTLbxvZnM
 kKCNnPk5mtJdp7X+17Gmv88ZOJPoOAefU3pQk6vpPoauLZkHegZvw2tU+SIT14Fk5T2J
 ZaJYibAG8yQX8xAHNEJ9LMwYTMIyx3tH2jfyocW2FjpzXc18sRyVRK06NZAlsHxlFtBc bg== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qu8u8jn41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 14:17:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hq7Uow7rzCKsSxVdYtYQVn3X5N8rw9gFvgmw4D53OMNpmMTwfnHnBydZztxAG9hlovjWkAenr8XaqMC/Ku2aJdGs0sO3BjfUbCmZQLAouLiB1YJ1uXom/0Yj4h2u+F/4kgHUZfLicAYZ5xjv6muSxtgkic0pZShYjXLtsg5w5vF+nSmYhAc7KWq3v/RH4k0vufKoFwFHTcg1zsF82h8rRky4HN5IALksVA4TTyUAfd9wuqYPybPfgHMiz+JkT/ER+MfH03F/+cPpEoQ3k7NsTLMPqKBQT4Rp7VHfVANbD3bx1k29Ec33163MpGYA/xDdOhQO1VJGuuVOjrXLQ/05Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sqzwowbop0wapqOookzFR+jCdN68cDsEDQ9yQyn69Wc=;
 b=C/8K6kJWNYXVDhOYXz/KJ0/CzIhXSh/57UmUQLOVdRDUU1vmvMDVKXMmgOJobqFaL9dvfsotm3c69K8jdINF7WHg1g8eK9cCoONAYjlkDlU+Wq0rtvtg0oc8iVl+90GZnxwpNhzwcY+vJ/YCgQxuCOXPANNhH0+7NQAv705sq+FfiQGnj+3oSZk3nAD1mVD8yzzNVqWZg3iivbJDXKzfESo2TkG2dYuxu/8ZEgEmxnkxiB/rLAj2i/ujPJKAR72a2f4bqlO1BHM70qADuz8Ny8Z29a3bvSjAOzYR93HwcLa44f38jCreWV6NFYMW2F5eqcJ/YBTb566TctXrxdxWDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by BL1PR11MB5509.namprd11.prod.outlook.com (2603:10b6:208:31f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 14:17:43 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 14:17:43 +0000
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
Subject: [PATCH 6.3 1/1] bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()
Date: Tue, 30 May 2023 17:17:30 +0300
Message-Id: <20230530141730.310580-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0107.eurprd04.prod.outlook.com
 (2603:10a6:803:64::42) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|BL1PR11MB5509:EE_
X-MS-Office365-Filtering-Correlation-Id: e6d59cc9-219e-4b35-199d-08db6118a1fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	bzRT/Hu8vd3wwSMlXFIBcqXHECKoEoNUPLdR0x+AvOd/jyOsR5eYA3woknJ21xj6kvO4L9jVZ6z55x+K2OtCWcDIJLaJMHG3sIQ/g+lcMoD5OkCefxO4zHPanOFHFPygNoYtFjkPkXtuII+LvRGtupK0OSQojld7flW+k1QQmBHsvo0sdQKzfgJt4v0aQmYTu1JP9sHetZArmIegg3fZB/OzgFpmF+cLVFqvSpfFae0y0qSXHK+/QQ8Ka0fT540BKUQXXJ5bqSAO4nAJH0k3ICJAoYHOUjNoo5VqoEz0s0U/ch7x7x8GEbawZeh/sz8XrgApCiGFjeejFRTXz0iuYwfJXGoeUOBPwMjmb/P8aSpONS5tkvk3ggQzpuOjhCryPSLgI01twm57nWX4oUyzuN3BsAsZTeZdgffDXTnq7fmrLZPBYl5/nn432WRYe88noHOfR/71kJ52/83OCZCOaDJaNr9UpQ/xCejckaEGZw0c0U734uGqFcY4aMLkPI0cJTCEGeTMtEdL24Ml7creS5oDSeUJzdrKTSzOfchqorHHRLue/rpaYSjvsTMYI0Vm+L2ZReFfV27XkQ8YTwvsn3n/A0RU7GQ9n2VCSC8OFQ09prbVyr3LlK+UBN0JUC4o
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(39850400004)(136003)(346002)(451199021)(38100700002)(38350700002)(41300700001)(6666004)(316002)(6512007)(6916009)(4326008)(86362001)(2906002)(6486002)(8676002)(8936002)(52116002)(2616005)(7416002)(66946007)(66556008)(66476007)(36756003)(54906003)(6506007)(26005)(1076003)(83380400001)(478600001)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?iCvfSAR10C7tKgWKCAaid38tluDbDDfNIJjMiURsbFtGojfiPMlcdY/9hy6N?=
 =?us-ascii?Q?bL51td/pVoJPmeB7dGzeL+gS4MCqzIqkYJY8F+DuaWVnDY2mXLIrlIZ10/HP?=
 =?us-ascii?Q?bbrixHB4UERCvawhAIR9KW3AZOLjSuKpUGOT8PhpV/R0bU/Qn9KEWo0f2Ckd?=
 =?us-ascii?Q?DvA+8BtoMaLAIuIPQQOT9h3MDbLNJoFaUeZOkrFCnkntKU9SqZeq/+DafPsy?=
 =?us-ascii?Q?cF14Pm8MKpBKbnBi/n8x0OWS298+cX1yP7lsvzG/rJF0T8S/O79n9WwVZasv?=
 =?us-ascii?Q?0+kJNXy4MMIsVo1zrxDS94qkUD9e1895x4/c6WpfayFflxhxDUj3FNFol3Ej?=
 =?us-ascii?Q?AUwZzmTvoKUgvVDkJxkBNzS6IL1ZmQBvXtEkR4k51Vt2Tip1vGe1DTs4Np51?=
 =?us-ascii?Q?uGLRdElSGcJzrqQMacAkKicyCslSGVHN90C8kwm8tt9DvNz6DMXd1MkjLnJy?=
 =?us-ascii?Q?hmLLgBpABqpf2MJDBpzClkEdGznMJyFJzJVlp+2yJ2YMr75FCRyM0+ZLlTQU?=
 =?us-ascii?Q?sw4KJsmTeEehOdKbe8IuJB1wnxQPiCQ2s3M2+y2HuMf9ltFhrUgniQvmlXrW?=
 =?us-ascii?Q?2qangW/5WWbAtmAb/DUD5biyNLDBYtBz60qD9oYUsRZDbfKk9DTsDV7I8wLC?=
 =?us-ascii?Q?tRYQKcKSjsMwf091eur1sS0BDRufhnIrId5ruXBKF9L0bO0wDq24eWiQgk27?=
 =?us-ascii?Q?B1E/3IM8fbzJvcvI+M39Flh2m1aTCejrCvQJw6IJef4gsy98HtE7ygojBIyu?=
 =?us-ascii?Q?lBBUFr/Zz3CFiSGXBrKrzOrzGwZbqvcHODiySzr2DeqVIu6FkapAE8gppb8v?=
 =?us-ascii?Q?EpeOV76e6hRV2PC2QE35h/BaTjCNyeYOXEareJQwl6rbXeGpTuX2fhEnmPnJ?=
 =?us-ascii?Q?0wUoTWFzjhnlThVcicrL2leLCMnqWlvFaMtzXUi+eDmmATsIsA9sb/xqLq1B?=
 =?us-ascii?Q?oHQ5vEQzcFRAyVnzdL6nZhMWft9XpFyEzEWvMfqOnXFKLe+yeV40EygPMcFn?=
 =?us-ascii?Q?Mj/tAF1egNhrlYSMnKC5CRJwxpE+kwn4vdZysc6SAW9v8xmouJrLCzv4WOP5?=
 =?us-ascii?Q?LwJOyRPTw0RFZ5QjgAEMHWlCJ8M19R29hKBcyBaZyV7vNxFl0sB4CxB8gsXo?=
 =?us-ascii?Q?HHzn5zCY2fpO4FU2ZRxRAoI4qyjT9noKU4o/QfPbY1B5fPvvAt8OK4fgZ8HK?=
 =?us-ascii?Q?cYKXx1y7s6zP6GzE560aS9LdFA5AVM4sXtm5j9tZfu/ZFbR5jDNhID/Y93wP?=
 =?us-ascii?Q?jU4b95zomzDdVlYoilr2mgCByazVrJ/3KtDpVm2J+2ldJPktJR7/WbSuwpbG?=
 =?us-ascii?Q?7CfsD0CYkvJb1HlxOFYJFCARu1Q8fHHMv9FoUBkPeiWK9UPq2r7ASrxeZ6iM?=
 =?us-ascii?Q?qr9mDToopmaG/y6NVknDxUDvb6IrTFQd4wpf+nx6xHFxfGnGTBFtn2WdlkZq?=
 =?us-ascii?Q?6xIF817Nuq/E6oEd9BQGX89xzO1F8+n0dLx5psiGFeJYuwzmwS3eCz52Oe7Z?=
 =?us-ascii?Q?+xzie30cCMFNnyNrhkN86kK9ww8buevKpOIg6MciTb4IYpW+BHHxBgmDvu7q?=
 =?us-ascii?Q?G0P8XGdZMRIRB4apqrHHC2Ct1hdL63e7gTuf2mKkh5/SuD0FJjtJ0LZFp7wm?=
 =?us-ascii?Q?ng=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d59cc9-219e-4b35-199d-08db6118a1fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 14:17:43.0024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +4yoAKuh5vqNepIU/j9X+VJfi/8/6mruq3fb0gnQw/xdEiIcjbcnaElOqhq7NHG/6u0fqgnIrvv5zpZmWBZTsUKHsbN/v5m6mHwiuRVum+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5509
X-Proofpoint-ORIG-GUID: GAmPZzdthYzVUqgGHM5BzTCu1X7uV9bT
X-Proofpoint-GUID: GAmPZzdthYzVUqgGHM5BzTCu1X7uV9bT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_10,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 suspectscore=0 adultscore=0 phishscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300115
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
index f597fe0db9f8..1d249d839819 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -987,6 +987,34 @@ static int hci_sock_ioctl(struct socket *sock, unsigned int cmd,
 
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


