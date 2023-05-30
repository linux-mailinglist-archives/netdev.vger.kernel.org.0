Return-Path: <netdev+bounces-6377-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 047DD716072
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:48:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD570280A70
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:48:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD7271993C;
	Tue, 30 May 2023 12:48:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80441992B
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:48:33 +0000 (UTC)
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C71E59;
	Tue, 30 May 2023 05:47:59 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UAmLcF027498;
	Tue, 30 May 2023 12:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=adOxDax3xWJx67dcMZjqQ9HlkuuhpykEE0duM3xMz0c=;
 b=rRa5vRmgRy4i/0uy5GDbyk6mGU4uQnJwRNAioZrMv7HM/kBVbR410TaGZ5kFT7MMfVhP
 B0YpGgZs7qTBM+nlpafog6ljr7qKB24yoY5HAEH0qn5fKyOPv5ZdF8Ja2KhuKUvIS1bq
 NR4xXSI5dKy+h/5ufFTqSOcRr9H85jxlyU9CpZZp8tkc3XVuYPKeXxvvttU9HGQmtZWG
 mx66DjlVC6Ls3hFPTOTI22VUOJbjz0TXhHaFRRELwykW9N5QioRe9R3Nc9BHD+ipGOGp
 2K2S9dMYOBhMW64a+hmLlnZdGqn+MYcqLSoy587yYrXRr4Gjq5AHedthDuM7iXmamyEJ cg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qu730tm44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 12:47:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8E2OmZGryLBpr8qEp5Adx1tjgUUK5U57G+ObzPgEfwCjLCELAYTVFdN204Fnz7JW8o2mkDkuMzSU1nJZUz1rgmaERmMq6qLP1FxFpaAqhXpKxvCUop2MaOAJViIdHfUruMNSROs/THrUsaXfmH1oFAYAP+InMKt1zp4mxPa082ATY3I8zNaBWSqx9iVDCmxH8i5CzdK2GBtNFiDutXgxbzKMaB3PdIlV1jU1aq8RfW8Sp/wLZlGfBRE8SYdjcVVX6+0WB+s96IAxdwg5lfH6ks1JqRJLK/ld9NDAJUNvR1SsyRhEF4iC09oaW0dszI2495+ZNecv34YymZd/vEWBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=adOxDax3xWJx67dcMZjqQ9HlkuuhpykEE0duM3xMz0c=;
 b=V3Y074QLSWA1khTcyC5AJjU1h0uaJp2o1i+ByEnGQm42+1xmwRjDkwi5RMQbl/BpSdwVEjPIqvAHRaoSv4P76V+WSLAOtTcM1uy3TInnWtZt9zw6av3X5iI5S6C+sh+iFxP/UnIXFG4XoJ5TXnvwSeocPMxCblQhj0xD6fdeYMwPWBURJVuBApzvaEARxt7ZHhN4n80o3BHcIFjW8BbNvmM/18vTiMVccQ0cxUnyQxaoPjLgc0VxXE1+rxzVDhpjRHlKTc2y8ofVZzR6MJLJI6cGY3ejbQPWEGNW/d0KuaoAeZfTLirtT9C0hYXnUFh2aXEKXWg2k54ZKIScakVg0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by DS7PR11MB7835.namprd11.prod.outlook.com (2603:10b6:8:db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Tue, 30 May
 2023 12:47:31 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 12:47:31 +0000
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
Subject: [PATCH 5.4 1/1] bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()
Date: Tue, 30 May 2023 15:47:15 +0300
Message-Id: <20230530124715.248505-2-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230530124715.248505-1-dragos.panait@windriver.com>
References: <20230530124715.248505-1-dragos.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0036.eurprd03.prod.outlook.com
 (2603:10a6:803:118::25) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|DS7PR11MB7835:EE_
X-MS-Office365-Filtering-Correlation-Id: 56d0ac40-251e-4d2b-0493-08db610c0868
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	gX7ELb/hlO8OAKXnX4XVOSQbtACEa7jtMxFlQGuKCxii9nUF4oxFzqJ7GFkzimmSD2ThLsoNfhgZOm3zq/UuJCe74C14a3oF/BXqnPNUDnSWA/Y5IG8RU0mVQA9FIR+zM/KlU0pmsC+N0HLtjd2rteUZ1bLsK/73dS8H/bUZyUMr6/heQJ8LQT8h5bwoDufqKVayxezdseNgt2ZHyPXotjloERjzoZBhU+TH5u8894b7OtSVupfpRhh+k9eD5hJPqEb2jEbSeu5+eLWXky3zLZfSp+WqG7K1f40IiqenXNd0V3A0hupOZRgdJN7yAJE7Op0bGHKU64qJQLkppIVzrAWqmnpVJLgAGrD5znMPO5UWme1PZ8W5EK9y403k1wzys/BDRY+5vuESVaZ054pWOKiwi/htpFoFlhyINMxjxSMEWM5iX/YfITYZyifjEo4yMigIN+f3kFYtgHVQNj639JQZ6sOOwpPB2HIpvq59qb7nHMUyTNrCPHzAPYTadQXKs0fNtgUUTgxBydt5N29AOsiQEZds7b/20rhiQ8sUCgWLlbHNnQi+ymh38qjCTv99fTfNl5t9Bk1ErdiMKY0HFyZHPNgnCOadmT65JVxqpmJtgeB6EWKSR72r0mxcXyIT
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(136003)(396003)(39850400004)(451199021)(41300700001)(6486002)(52116002)(5660300002)(186003)(6666004)(8936002)(8676002)(36756003)(38100700002)(6506007)(6512007)(1076003)(26005)(38350700002)(4326008)(6916009)(66476007)(66556008)(316002)(66946007)(2906002)(54906003)(83380400001)(478600001)(7416002)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?9aITHt9iTnANfN0n9oNEU3ApRg7HQULA3HnXOI+FBB7IEfQNWyDgBn/gMSu9?=
 =?us-ascii?Q?xEPFHfeEe9fGal43epQGJWm31TgU9Is9b37eD3fMCnpBdqGPhezEe1FWJnRn?=
 =?us-ascii?Q?tHDGBQZZm/TgKJyDHmkmi/ZigwNzv0gMJ3Y3aJxUoKf/IbSTXk1OglUiAlVp?=
 =?us-ascii?Q?MADFMDgxzutcgN+vlLJFUdPmkKxEay0jXFsKkUITABqqJeJNEEE48LV+WD4N?=
 =?us-ascii?Q?WUQtKBERBWDo+azBbR0sbzSIkq9RM63sFD+ap9OxuJ9sjUBqLHtDZfGHDVvP?=
 =?us-ascii?Q?orGsmHX5ULrrni0+iEhcKdq1un80l0Gnu++HEE+/sX+O4ubVS4zkmw4TI87A?=
 =?us-ascii?Q?56CvBqyR9RI6/yhHRRMggtGn5O/Y6A3IbNhsRRWpwvus1nW1PtD9gUY3mnB+?=
 =?us-ascii?Q?6mczGEHl7zZ0vQ2GNs2nHlM5xThhUe+qVeL/tjCU7QSq2dhjPRZd4WfD3tzf?=
 =?us-ascii?Q?PD4oyQmPai82j2JDZoyNa7iAwUBLsHESBxLste1Z6YjV05A78Jko+zqy4+Is?=
 =?us-ascii?Q?YiCsBTHzzVU0/jmn92ClM7YieeaiVBNYsNDNybeHgHXZkKJOcYKfI7hamVuZ?=
 =?us-ascii?Q?LkDbKklfD56P/sH1oO0l4bS0t7/ZqVAsRR1v3cqodKxkbRabbPM+TRcxEeTk?=
 =?us-ascii?Q?MTV/2ALxU+M8qPNsG1n6SrXuluWN0XK38B4i46n/sp21gCTsRqGbXE7oqU8y?=
 =?us-ascii?Q?DInIGen2YZ/TsgJ397M1LFQoYyteJgIQ+HDLwfGPQ6JF+dWvE6vZd7vYPP4N?=
 =?us-ascii?Q?WVV0POMwlVqvq+buAF2o+QBf9Fw6YBBWSZXaz3j75scQBzKhPE2WbOWAjzcA?=
 =?us-ascii?Q?zUIonMtRPLNkeynmI+b6Eaya+3GBa1fKfkfonoWylHxtOlT4UvZ/8SCEt5Wh?=
 =?us-ascii?Q?xFuZdCjjo6qajYDDptAVBhwyREfXHXhwPmsov874ejEWzGXbQX5F5eH767qg?=
 =?us-ascii?Q?f5zamiSgIzOwZDrYUOPcepA0N1Z/Qnofnmwh4LMT2tsxLNZHjzP2+zg3OPj3?=
 =?us-ascii?Q?A9P+QK02bp50S1Pc4DkS36BeGHqJm4IWxawJsIsIuaFeTZ1cEeG8GcYO855F?=
 =?us-ascii?Q?FPhjIEU4cYmhvjAYG6D1EHBqRKZE8cXZ9qk53TPUqDKrk5YP+HuON24/a6hQ?=
 =?us-ascii?Q?HIRq4YZa5w5i06253ErV4WANamuotGCHm9OEGC93rg5jfMzF33OFWuf8IGBn?=
 =?us-ascii?Q?M01f09uvvcng5B4c9mpZQ4pPmKGft0JNxHVKZBM9NfVnsBpxgrAotR54psOM?=
 =?us-ascii?Q?weKz8UMlH/+aDGJyu3fc0Ae7A5XhGKLqqvz2uRq77LRjnTk/fBct+ed5MeG6?=
 =?us-ascii?Q?HBQVfpYtjwLEomnxP9XgQRD62pPa3gMbVNlH0waq50B+We9gZRLal3JJXbLn?=
 =?us-ascii?Q?VnfFnen0pFzQnsygdJl1Gs8XsG10TPRQbmXA9FMe4V1LOAZgQP4SW8sB/bIk?=
 =?us-ascii?Q?+eoZK09RIaZq8zjahYD5QzgpcWz6vTFTOXdV5goh9s75dXI4XrRDk0519F5I?=
 =?us-ascii?Q?hhasKTEqrvlq8GEEBfijBjP3nkslx4G0tDi8Gk5TCYgu+2rnU8nPGWfF1P0v?=
 =?us-ascii?Q?9MKKlZWMtS3a4BSMEh4W1uxZSxnk5X49/Happp+OPHtc510GDPsKdQ7CtOdg?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56d0ac40-251e-4d2b-0493-08db610c0868
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:47:31.3280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lakmmy55dRboK6415RAEvjS0a5yQZFmPOS2mPtGDRrq5HjqyLvBc1A9N7LXrk8BCk+4U5+zvaZAlfV3nZbp6NjA9ewXMxR/4wSCyE+GsBk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7835
X-Proofpoint-GUID: R5SITlkGmJD_YshV2CVcNKwJLufz9UfR
X-Proofpoint-ORIG-GUID: R5SITlkGmJD_YshV2CVcNKwJLufz9UfR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_09,2023-05-30_01,2023-05-22_02
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
index 4f8f5204ae7a..45f6ce1f380e 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -973,6 +973,34 @@ static int hci_sock_ioctl(struct socket *sock, unsigned int cmd,
 
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


