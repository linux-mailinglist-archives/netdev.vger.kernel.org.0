Return-Path: <netdev+bounces-6424-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9939A7163D0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:21:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49480281148
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3396223C6A;
	Tue, 30 May 2023 14:19:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2095921094
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:19:21 +0000 (UTC)
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FB610F7;
	Tue, 30 May 2023 07:18:56 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UChkdd018467;
	Tue, 30 May 2023 07:18:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=Sqzwowbop0wapqOookzFR+jCdN68cDsEDQ9yQyn69Wc=;
 b=Qds0EQYu5vFwWTAyCY52mmMKLgXV+JTogyIPWAIXW3fOO3kQCM3rpTpUn13n4zkWL5+a
 U2giAHdNIHuZULQ9Q9ataoQdCKiRqEEqQR+QQ+2jxc3JGcRDR3TnO3CTTiuajJ8gQ3IE
 A/y2EsxD7X+w+so4h0BVl9d5KSt5sBa0HWDNvQfgHzTDOdBK2P/yuVFSW+uSvytIXp7P
 KY+gohc7kcGjbhGUfrPXTUYK/ZgBhYJJGHU6348PvW+XV3bP7LtqrP/lLhTCFP3NLPeD
 0RTY2NmChzRmw9tGuNAa9m07GLJNXE37sIi9/pmj595CjAZ29Z/RMHJ8AcjGBxUUJRCA Mg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3quhcjaayq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 07:18:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMygkxi8ImcuDfcGVdiLXeB206DbWVeWkRYcVjV9sQwY3c8Y0J3eUD043c+urdALycBomC1/BsVjMNnSDfN9443WdGBEQ4nWkJPpYP/rTBopcJiMPV0gU4rB1gMDPsNtwSblQOaLFjrRhLg4i55epVTWC9j6PUgHkHDb5JLT5eFmNOBmHnMa6SUD4DWWdE5aT/3YbtFO84z/Tdfr8S76X7YHa2mSzOt5WZaQQlUCHq+YD99zLrFbQdWb4KaXKKBVcAECkgtFmwhndxg1k/jOiUDQFTO/VnLMTLZfph25rQ/f5N+8eAih7sL9wtAYUf4Z+ixGk6eccKZdAddqXT6CBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sqzwowbop0wapqOookzFR+jCdN68cDsEDQ9yQyn69Wc=;
 b=MgYHEFkFApxK1x9wM/5SGI6WAcbH9G6aj3WwogLSrRZkAN21p/JTMaMOu+ltOHUbaPawEYmkAM8rQyRxDXK10xkR2gaGAu7SD3whDIvW2ddT2uIx70daHiD5zbHHR/jxyFgfYbmbhI/6Y6a5OvwIdFS5rSYUo4Gwy7KgnlXIISjS3S+DgBhf64sXSKsrwWpQg8k1znT3+m+vUVZvbTByiHcoFPEbI9Jcn6PzTl4lpXtPzNUYcs0ftCVsgQoBfcDiYMaH3CdC8KltyKNBIZ+kemXxb37+WGQNphNPUVCTiGcV1Yj8L3V08hKuCemnVbihRSpoOa09QdHYTBXJ7H+v8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by MW6PR11MB8312.namprd11.prod.outlook.com (2603:10b6:303:242::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 14:18:16 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 14:18:16 +0000
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
Subject: [PATCH 6.2 1/1] bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()
Date: Tue, 30 May 2023 17:18:04 +0300
Message-Id: <20230530141804.310745-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0026.eurprd07.prod.outlook.com
 (2603:10a6:800:90::12) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|MW6PR11MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: 870fe021-0663-4930-6935-08db6118b62e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	LgrthgQSACDXidfDG95zM515AGU8LJY3lKT/QpP1f4khTtT8JdRRHbLPz3SB2G+EIPzx/vfEPmqBRbDEMghkJ7dvLbkL/F8IwTNpwQA4UMUATdLSVF8w1rIIp3d3a1j0+LZDDIkd1FfqL4jbV0AyxIcTsr/ZhRokInVOR98jO4Pz6SrKf0QpHzFog4nrGTbZdUaYA8IPobsNbCnhdLALap+FPvKMMWrQEJIHlKMRScgbnnBnQLGLWok22OndG38TfZLdMlY+8RyPgraWPxF3sCp9s969NPJVuJXFTWA8xeqpPAO+mg6j9en9kxc7KyL2xDXIeKL+KPO3L70Az8xFLYOBoxDQypmkEXJsaUBDzwfsP5slsTHV6bms03p4fbHkv6jgqMqdiz0lEQOdbYLqnn/qfY7w3+/uIBLnty0+MNdlFHnx6D8HORSnQg07pncMEn5Yas1moM+Um+0qGkPUSG5pzucZrJ0sm4faaCSbPQ1ZCvXI27iN/u9I8CA2BwOajYALsjtUCHrPuQnu+B0AYgtqs3opGJ1u8mpkJADPW+3wvLn21KxQ5uf8bTywMW/UtW/DBgyKU7n9ziQyLUhKBomrUkWt3HgXMeQCq/91TQZ9WovtJASS4LYVgIJ6ARij
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(346002)(366004)(39850400004)(451199021)(26005)(1076003)(38350700002)(38100700002)(41300700001)(6486002)(6666004)(52116002)(186003)(83380400001)(6512007)(6506007)(2616005)(478600001)(54906003)(6916009)(4326008)(66556008)(66946007)(66476007)(316002)(5660300002)(8676002)(8936002)(7416002)(2906002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?tr8X/oWKEswiylXhvOY48ILRVDGjMHfjsEGtwMbAuhf2ATaOg0Y62MhXKoKD?=
 =?us-ascii?Q?QrmtWkX6Of8VdjdX4rlp/LLCMNqblimUUetnOiKOM0ZsO/c3TcCmeONWwjnr?=
 =?us-ascii?Q?7trA8+5k1cEym4iDT/yEFuPe2nECOITI9heaIYnqcBg/q/5le4Swl6Gh9z5r?=
 =?us-ascii?Q?XRE8soch+bPBg4ya23QSCy7OlmSz0eR6ve+jI3tDSOZHQHRrsGpIHExFkfGA?=
 =?us-ascii?Q?RrFIxBMvr+3PIq8NyFuy1TkIBT5AyfN0pCKfnn1Lt/f5E1H1WkG/0Uog5wHR?=
 =?us-ascii?Q?E0jBOaUu1jPH+vuxU86E0OSP/x4AFlMY4DyRAvy3zYsobBD0MgoREK4rkWHz?=
 =?us-ascii?Q?22qlpfPgrz34NwlLf3+r2ruRahTr/knHM7BgbUNA7dMbCtTL/qz0b8fPNcZn?=
 =?us-ascii?Q?bEOHNtgAzFJGhS0SnpCthP/d5O0T0ucAtlZNHygsznmMvaUyFTjuXrN8ZsLS?=
 =?us-ascii?Q?Hx/3QWNJA4gEwMFxv4KO/yJBuGPC4bMzQFF7fE2eCNfOUx9bT2kFhJNIEiB1?=
 =?us-ascii?Q?X9/4Gz/qcXRtP0kN48Y3fQtiS1wMmgf0EtBzv5P9XWHkkisYALsJIMlDTI2h?=
 =?us-ascii?Q?Bns8gxI/cwFLKYBzEemgeERGQZ6UXZs69uoUYiEJxeO3mMOHWAKbnkpCW+t0?=
 =?us-ascii?Q?ZTtYegnJeFTTUouWogbXSQ5+wnI6y5IRTy+7wicBycPLI+Tixq4H7LO4UVM/?=
 =?us-ascii?Q?xUYAaTpxl3k8JcvIkeo/qUiMiMdxYjzJEGIf0wqjs4WVlPfQ0UfWJKMgi9Ew?=
 =?us-ascii?Q?Vq2MwBMvODP0CqiU60+ZrUEJM8EUpkT8Ez6gKRo8Ayniip2ZU4ZgJtHLC6AN?=
 =?us-ascii?Q?/76LF609R0H+3HcoNmGUbc0HxEyfoHAb++QJpG3HT1qCNd630DWz0zp88nt2?=
 =?us-ascii?Q?hrQZZkB/hBfcgOjcpK3GEXrb+xWpaTpqmumx+ke9bsKDZBnN18smiUXV0laP?=
 =?us-ascii?Q?4xN3EIfMbErCSI07YPIZHNtPv2ZYgCNjRcxn6sunZdrO7uFO74mEr4RWxiHn?=
 =?us-ascii?Q?jkGYJX1Zk7Z7f6SWLIogVapri08+t69Ovj/hEx8bb52FxkvdpWzE9CUPHriV?=
 =?us-ascii?Q?rI+SKkHACKk2oYm2Ebjbi1CyksQWGUjHVElhlbHyguo1+fPglWhwAo8mXbFd?=
 =?us-ascii?Q?qDSwc3Svic8HKjM+Zhj/iwC6x4Oive3MD9Myu5UBjVc864OYj87Vsmr7P4Yz?=
 =?us-ascii?Q?oK4ODFUCHuI9moBLGp5bSVZylyE1N0p2drzQ0l2AZuMZp9i+9MV7eGzuPAPy?=
 =?us-ascii?Q?HaYylcYM1eF7dxPew4m2A95wOq4jK2oFFq7OVVzHCtQ83oFNrkbSUk1b03ci?=
 =?us-ascii?Q?IKj7VkuIey40tZLWY9LZNu5y76sKfmaTC2oIlzfnJE1eIx0mMK6Jvuxy4kf/?=
 =?us-ascii?Q?SUoZxqZrKJBPSA70jnuCijSGzuzzWd9EGXyrt5Hhy37wHhBoxFILuex8y34F?=
 =?us-ascii?Q?1RtS6ST6fbibrTdgjRP0W6qlexjas+xYEhQ5IEhbpNaDIWCS5zD9hWeT7B+b?=
 =?us-ascii?Q?r7wZTRnJzxpAfGdyitTpyLFI1cVqky6vzcyJipn87PqOPS56I5Ku/UQORdi4?=
 =?us-ascii?Q?ioq8hIKFqsUoANyNmanKskcAboEuK+4Dr1OrrqTiSSru7f27HVCT7Emqcuon?=
 =?us-ascii?Q?JQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 870fe021-0663-4930-6935-08db6118b62e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 14:18:16.8526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pxVw4SGfWPB07VMV81a/GW6lr7SotoVXm6a1iwjQw3NRWpU+KHpIT4825vf5AsSTAiw8zV2awZF7+Uq6Xbh2vfWivuq8XHH938FlDz/BHEY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8312
X-Proofpoint-GUID: rJKcRat6Ck3pGotZ6SEX3P002TwG21LD
X-Proofpoint-ORIG-GUID: rJKcRat6Ck3pGotZ6SEX3P002TwG21LD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_10,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 phishscore=0 adultscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300115
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
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


