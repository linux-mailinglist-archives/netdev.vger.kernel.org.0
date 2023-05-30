Return-Path: <netdev+bounces-6392-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C63C5716161
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:18:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56AA41C20C76
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0490D1EA96;
	Tue, 30 May 2023 13:18:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D86134C8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:18:28 +0000 (UTC)
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D672CE5;
	Tue, 30 May 2023 06:18:25 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UCQrk5018554;
	Tue, 30 May 2023 13:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=5JAWP9UH606r5C0h/RjYpcXMxncX2hdFyFXSwKepAuE=;
 b=LeOQIM5rMQtoQcYw/0fVo1jce+i4dUJQqPDjanTXzvhpX2FUPS4uNvS8tS67tzqDbUAM
 wu9EiCSXw578W4TqHvNfAG2GNY5U4n3HirS0mcqn/hx99+qfGJIwEb9z3+CGm1SH3HsA
 97s06FSOKv2Mca6oE8jnzZO27yfExMYLFe1N8TbobPes60gZYBUWPSdzy/UtyPfah9XY
 HyIlO1kqSpMhsKhIOI/DhZsuAKjamG+a3dSn6MU0AIHPFpHYR3Qk5tbWi1cBmru/HC22
 n/y1vxaU3vcbBQpzY25O0YUKIj1Z+LrcWw+t86DQV0slLWYdx1R1w6+ROthO7c+nF5sx 2A== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qu8u8jkef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 13:18:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XL45CBwXAy//9IjwAnYz1ly52G8APBilxs+O6GTVnQjUnC1Gfvt81d4DMnWT7WcX3aYiQRu4cjWrmbdGFZ4HD5RNRqw1itDSInSO5EvgdWRQgT8uAy/8KJsbLQT9zLJiRq+gEPMjdKmvfmNaQHvIkbCfXENtyF4CgbXvxQGrDX+BliZIY672bysHxuZw0+Eg9OkuuONHXanfIKntL52GfEJ8+MvIVko3m1Vx7T30lbwuTzuuwbowArF00wmi3/UuzTolmOmj4a7JbB53tCFhTbPPlZXlUC6ewrHw0tJIWr4nsw50pksxCBlvn/dMCx7OsN1LNQkYIb/GYRwH1Zh75w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JAWP9UH606r5C0h/RjYpcXMxncX2hdFyFXSwKepAuE=;
 b=DRa+rqP0ZwtBsraKmeJkW2dkgMIMXrZdEvSMJxtDvKobm1OU5Fdq3oX2aRvIcn49gdkrWUcaWfFcfUgiNqL8LiAK/BDUHzz3KPYU1oKeG/104tGNjMFDCH07JgoqnCA07bmOxf5J0CM4NAEEK/euBg3CtvDeeAQKvolFD2DAu8CzmOGc7MlGQxq5X8t3qN54pCdhxuz9/dT96Ti3qP2PE6KKojUJGnHTB1x3WNrem3CYMUa09VM1+3a+pdKns0VJIpjuPRLlJSt/TdSCqSYsmvFtB7cogTrcDWD0npuUWTzqRLwQtShJ0sucYx+XPVrk6g9mVAtTzcmid7Ck2rL1Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by IA1PR11MB7366.namprd11.prod.outlook.com (2603:10b6:208:422::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 13:17:53 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 13:17:52 +0000
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
Subject: [PATCH 4.14 0/1] Hardening against CVE-2023-2002
Date: Tue, 30 May 2023 16:17:39 +0300
Message-Id: <20230530131740.269890-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-Office365-Filtering-Correlation-Id: 5d01ad0b-a15e-4265-de8b-08db61104603
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xWdVonYG1AS1V5uvEUAjZJYA9wwNCfNHWTTH2I2Zpb0ottWeuVsDRuJLvhH6cL8JO9OTyDUw4zD2e8wL6Zc3gpUym4j502k7nx3DP4815+eoCsKlgGCHZ7LlDAKPZw+4lWnvN7UqOoA+BBI1p7H4LRIsPU2TnX5GOlLvZs1zTWk7pMfUVoG9mjvIQNDnqNxm88d3AC2gMKv1tjPb8A1gZvFyH6F1j3+US01oj3rRFhFsYUpNLjV68u8XM4eQCvjAnN2sk/fZJZv54UIMSBmTyQOP1siBSf22FyatpUbFi7SXihfaMzNVEEmOL1aMmmcyAk6UjkWRH2OW8K0Rt+9okwhoNKad4a6Qnl54B1UnX5gKv5IerHxHcswTriWmppN5WM/PWotf9IHykI2epGifPo6hqvWYxDmyna5gXiBNkv+aviZaMtr2dAWkMmW/MF3E35bJtuVpDsX6o0MDfhlPdJrtBxVnJPijEpwYEAI1CljFUICjGpha9H7ULQJfXTI6pjQUNRptdkt9X6xaFT/OqemWyGoXPAXxZVnCyGdo6axvUbMeWsNqckSE3a5QDYWfPfQtWL3Nd2gFC3IH8/y/Fd84FExdhnoO2U1EjkCGnz4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(39850400004)(136003)(396003)(451199021)(6486002)(41300700001)(6666004)(52116002)(316002)(86362001)(186003)(4744005)(36756003)(2906002)(6512007)(6506007)(26005)(1076003)(7416002)(8676002)(8936002)(5660300002)(966005)(2616005)(478600001)(38100700002)(38350700002)(54906003)(6916009)(4326008)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?V5ZixhYqgHefq3tARBYmjfKMY4mROk1cr1aY0wD3HiVefnSpkUOYH5iriD9B?=
 =?us-ascii?Q?DSZ1vghSi4bn+emODs80U4tkkBuEaMXRnq/9U6cPEB61VrjB0kOuqFUwgFJu?=
 =?us-ascii?Q?2w3MEE6JZLYmCPdBW9XbAqfW3lj3TOpoGuiuHyWqA+9XBnz/c8YDIPuNV4Te?=
 =?us-ascii?Q?o7O6ze+MtkaHAR8R/9+WsqaGgBPJ4Pn24RoJyuRGfWoyC6Agg3TyPnkC/8t4?=
 =?us-ascii?Q?qylCoG75gECTXbQEVafGjMV3sJdyFmkOVspb9e0a4ehOWHI45M5Ob6eD8stn?=
 =?us-ascii?Q?d0m3MGiVTV+PY7kNOf2MI8AEbPQtAiDWKGhR6HXnL0K1s+i776mOc29g9mIF?=
 =?us-ascii?Q?ACv5l9mqJzA0KW7i7t+1svNjQ0wP6X9kEYdhHamSu3Hst5oitDX7gDLw5SBZ?=
 =?us-ascii?Q?lncLehhlj1unR1WTfoqYIXGztVM7udQMu1JvWeXj6MWusb8NZbdR8bM1Ilpa?=
 =?us-ascii?Q?qLXWL7wODMNugOroEM6OfX5FcyhxOrWBQMcUHEOkZ58twoqPxd/FH7OyqWjC?=
 =?us-ascii?Q?/reE0Agy/9a2jaXegA2JKsJVHRqzDzv321FLDB9VPZCi6M5Rjk/zcTT11P1q?=
 =?us-ascii?Q?nFEmDpMzIk2ErWrmuvUrbDqOhc8WvLIEaWNBsGfD0PTfJo3QAYr1b40zLgQD?=
 =?us-ascii?Q?kwL/IRtoDn/rjvolpOE18+fVtyPCzKR9iQt84I5fWQW3mzGLP9x7TM1O116G?=
 =?us-ascii?Q?t6OAE8K/85a6zU7dBwoLZVW517p1KFzRFyTXvQZrUbyWy5QwxFJrrEu67Jaa?=
 =?us-ascii?Q?MjLs3DuVGiu+U2wce5N5qYOmOSmbEJ8Ft5OH5QHFb/0sXBNkim9mOabIyhYc?=
 =?us-ascii?Q?f8t42qSIghcrTnfTNY0kRb7mT8Fh/+O9eyhE3GdxKffh28rCyBOxG+7pga7S?=
 =?us-ascii?Q?b2pCDl0SxxUaAT31Qo8gbZzdMkO3EgPda0EX8G0nkRtGpSoSufGMhtBq56DM?=
 =?us-ascii?Q?4eppIt/oGZ2x2deCYmEregSPXd4U9nvh0t92UmPcQvKA/oSY9GDjC7V7CBkz?=
 =?us-ascii?Q?MoirA8GtB+mykT8Ry1D50ruIvv67GR2smXghjHayGQQybZJAVt7e/7fRWrrB?=
 =?us-ascii?Q?39KvV+dERJd/fjTGa+b70ZyJKJjvHms2W4sXdQvNhBSJjETivsbbUsQOFOEB?=
 =?us-ascii?Q?3UWdi/sqWsGx4LFLfRnS2r8a3H4ziGYooGnIOaeeNP06rv8J2+9PVc3K5DlG?=
 =?us-ascii?Q?Um7k4TxxuxVCRdcIhd9AFs+tkYoV4Ji1FOleHWlxcH9GzdhxgtjKXrU5+wDT?=
 =?us-ascii?Q?+LNVgk9PfphXZMhwLnxcYD7JYdWAGTibVvdTzJTVVNAsrahsXtEkv3Z6Xf0B?=
 =?us-ascii?Q?tlcH5SaRqzbvvuxC1ctx9AuqpXmXlBDMMrqLO2tTDJp6djLgxogz1zjAs8sm?=
 =?us-ascii?Q?SH+PjEN60BJh/aqEqbvMLtRGKtWcmLWUOkQlS4h4DA6VWZkOXloZKimUP4Wf?=
 =?us-ascii?Q?DtID/QvEgYe6+Vq1EmNHDHUiPEVVEyNb5HObFmxRTGoBfMIb1+6CZbd4y4km?=
 =?us-ascii?Q?DyVSrCCk0aTK8Bw7ndhUQxcxVjXRWfObA0hmE1ayNC1SE3iJk38bkVZnenYQ?=
 =?us-ascii?Q?wUSilX3QkONSRsByDZN8cfcJSV+08GGZ+z4gfdziAajwBlNUyqGmwma+q7k+?=
 =?us-ascii?Q?oA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d01ad0b-a15e-4265-de8b-08db61104603
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 13:17:52.8353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AJgQeqZ488nue8eOaqmSCpgkfzgCHOQ+CXQX2Z8aFXa1lqI3RN9189jmulmJth2kZgR/wAtyaklXH7CQwcUPHCFNXWQRb4Hd824wYzqX2UE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7366
X-Proofpoint-ORIG-GUID: x4cIq-HlchNO5g6enZOcraIxMFw9FT8J
X-Proofpoint-GUID: x4cIq-HlchNO5g6enZOcraIxMFw9FT8J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_10,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 mlxlogscore=602 impostorscore=0
 suspectscore=0 adultscore=0 phishscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300108
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The following commit is needed to harden against CVE-2023-2002:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=000c2fa2c144c499c881a101819cf1936a1f7cf2

Ruihan Li (1):
  bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()

 net/bluetooth/hci_sock.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)


base-commit: b3f141a5bc7f877e96528dd31a139854ec4d6017
-- 
2.40.1


