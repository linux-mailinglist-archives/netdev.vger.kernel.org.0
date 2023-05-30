Return-Path: <netdev+bounces-6364-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB44715F41
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:27:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C39931C20BE4
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A72119922;
	Tue, 30 May 2023 12:27:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4612119912
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:27:52 +0000 (UTC)
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E806618F;
	Tue, 30 May 2023 05:27:23 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34U6i4hE028450;
	Tue, 30 May 2023 12:26:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=Sqzwowbop0wapqOookzFR+jCdN68cDsEDQ9yQyn69Wc=;
 b=BDHOUOUhBwD764liTWqk0e8lI6iHeeJ3nlIXSXmYxlioyr9FGkavs9YcTSEyZN488ySi
 /IN2GUiw5VDafJOLCuhXJKlcWPtLdWj/8KhMLzTf5odISpPiNQ2trM6FP8tDhC7y77R2
 Pq8CjG3c2n4+3uJzObJx/CIICr2J1mnAXcpy93Yx96qnupo0w+pmHJbxR1hv+w29v1DH
 4QV/y7JaR3Q+5AOcbHLog98aJ4qWX2Dzrc/PGo1iw8iBggcZkvP1yq1F7YaIlI+DOF6g
 /5X6SKuK2g6pQ5+W/70iyoY6wz1QVAyjs3K2aiFiZ9W6C9fdv9OdLdQNoD0Rr8RKqg4H 5w== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qu730tkm5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 12:26:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HbrK5fn5Ogid6X/V6mOkFm8uQi+WUGwn3FpoNa1GHsRSVai0FdBaFS7YVXItNj/+5LXTXE1nDlnx8FDe3JULQBRZ01zKKX9t+ulnY5HBJZ1JPdocZhUAsKpocDn7zPkqXHIfixJIby3TGuleXkIBJHI7rtA2MIJSDyJ5h/+Wu3qrLTQKGOIPVNsdX7lVm31nkwqJ+yQ4RAgHz0TgdcSK9Wm476bE55kckAeSVjWsvh0Nlr7RKbhF2vAbw4SgON0abY4K/8Tjh7zPyvg56i35ypPvsfjECvXnDuoWc2jBxk+nCNT0u6Pc2CLUUIhd2Tieq2Z2qblExWObvmHckYEIEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sqzwowbop0wapqOookzFR+jCdN68cDsEDQ9yQyn69Wc=;
 b=aDcyEClF5SUqplsfGjXUEdIl6lWbXhaMpuAWwyOu1T/n+pFP3rjR/T/eH/LUTitprbP6/Bv1XmjGmTpRlVtyLzVK8Ccf7Z5OuqSOSPmQPwfE+KhjXkAcPpObLPiPiA31sT7pJNdFMVbYgRX6Ec5KSCU6WnYWpeKU5ed+BBlHwUf/Aue7So7e3pa6uG4zcy+GBRQrVibx41MkhQF/GO9UXtlly8ldZT8vIeFwXTMz8oZ02PPXqUWt5D0wHAboLAZD+Gp8+kZkQjYxInGhZ0tacI8cBocm1zW5tOib84UrxNm+vlkbbfvJ+M50uLJmjnKUTZFOvhimiXQT29kzDU24yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by IA1PR11MB7756.namprd11.prod.outlook.com (2603:10b6:208:420::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 12:26:48 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 12:26:48 +0000
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
Subject: [PATCH 6.1 1/1] bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()
Date: Tue, 30 May 2023 15:26:29 +0300
Message-Id: <20230530122629.231821-2-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230530122629.231821-1-dragos.panait@windriver.com>
References: <20230530122629.231821-1-dragos.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0129.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::31) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|IA1PR11MB7756:EE_
X-MS-Office365-Filtering-Correlation-Id: e093f779-f432-4eed-0de5-08db610923b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	0+g4n5kj91GmBk2Pmmbhu3vJprW1+LSO2a2fGTtcCKrXmPeomqtXSAqRSg+nlBb4AzrHVLVZHZ3YC8hV8qG8V375A4OH1fnyYzzljto1WmFLvwBlsZKqnJi2HyY+bHn/LWwESOgA4imYxmAaAa536wnklALCzcpEyfaA+9vUpaXRwtJ89cfwd8Pd7kcMVzDNa2c3qPn5yDAIjGmi3B6DEGUVGqT1jRKGZ+0HvdNzwlvldzuxw1IzaP48VnE0y2zpNWHbANofYLb+iyYG0IE2+bVyoU7yFdQ2K8x/SNSmgb+Hy5Z/wLdibn9ZCUOdmdYRahGVSizxZlmisANDa3Wq5aZ2TPRVC3OjXKKG407FekuVecErUDcllzyN3IldKBxOHYT/ycfk2ZhO3KfcBOHAsvr4BQfelrnie53136Ce1kCosaYhoI+IqEzgoPzmDD2pmcd5alfAbuuZh/iEo3SVJWnu9PuYggzRMuDNEMvbZryDXSYn4hSE6WgGQ3BNhjz/5ppUJEnE0zTGQGYQ5x41GUpBa/eLarxEtfbfbDpPfqcTIN5BPK690Vzele99v4pULAPsL2LE/l7wydV2p4448FsuQBXWz9S8Fu3J6R/wgEL3wpDBcRZaaCkUd3tWJSDf
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(39850400004)(366004)(396003)(451199021)(186003)(1076003)(26005)(6512007)(6486002)(316002)(6506007)(52116002)(6666004)(2906002)(5660300002)(41300700001)(36756003)(7416002)(8676002)(8936002)(478600001)(38350700002)(38100700002)(54906003)(6916009)(4326008)(86362001)(66946007)(2616005)(83380400001)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?+/fZ4lIOx1iqdG7u6EHv3ybulX6pnrymp3s3pBurNvHNQW/RnlEywOWRxxh/?=
 =?us-ascii?Q?1bobApBtJqoNxxLTEQxUaZA9nInLCZfiCAKbVfBs4RtWLLUyjRoMKD+iuD0d?=
 =?us-ascii?Q?QFqVvjGrAVNwuZTGk/04st9aDQKrezSqarLs5lxFTHY8KGNAqIC3q6s2Pq1U?=
 =?us-ascii?Q?J0W4rNsSY7254VtE7byLtk54TkksU5uMeoI2zlkKlJSCoJSPqtX+/TIvNEJG?=
 =?us-ascii?Q?ZKL1LeCNQiaLLOaBc696jc2Qn5VPnjoZ6+LQc/e166bZYK6pqDd1pfwJ7FcD?=
 =?us-ascii?Q?q1ER8dUJU2bAgSIoo8KlzRjAI6fTw4GixhnPXIJhD04tmtL+4SgavmOPIst3?=
 =?us-ascii?Q?6CoErgdQ0BLCq1OQV7pEk7jTw664ksiMoFfqEYCQGKKllgKBix/sti2LyUBc?=
 =?us-ascii?Q?ePBxvkV8Q6i/geQ4zbvzxikvXaAJC5m4cz7h2dmg1UaA0Y/wLoDlLg68LkaQ?=
 =?us-ascii?Q?hHE4bVzKYd8FDyZp1v/R7nL0A5SdAv5BCU95AYVtKjLCG3OFgtY8fQMFti+T?=
 =?us-ascii?Q?3ejD8s1fKfB2f5VlUiGO0pYPuaifsm5OjG6nDOlEVrwbcMqaz5ywJVci1Mbr?=
 =?us-ascii?Q?OP9Y6Z72AMIRgfaJNLggvWRF0+joPrNbzvLj4DLf4V86MX6BpBDbY5icr6vr?=
 =?us-ascii?Q?dbiJqkc2KnvL+cIxnsg+1j+eDto7dtCHDBvpP+TkskWdzJkohT34LxvUhqZ4?=
 =?us-ascii?Q?ydeH142zwYv2bjnwjMtyPLZEUcIg7QZnst9d+4n1QXCY9TCESzbQGVYq8qOI?=
 =?us-ascii?Q?/fR86zzzW5Xy929e1YczmKfDCvLmlcHahMIOz8AdVl1JdlugaOUHYpatI0lz?=
 =?us-ascii?Q?d2aq1r189dZL94/aSquCkCt/W1oPg4Pgcl/i+FKu7jy/aewW6882sWTs6V1g?=
 =?us-ascii?Q?cQscE4FG51jljHQzbpSSQqUThFsL2+3REWxWp2QwMiOCjVCcc6fPMnClfKab?=
 =?us-ascii?Q?z2RdTnFbZiNCMYa4jKDz2YvZpitHCPRTh034YZ6WE8scxneXTYRwKCTx0DNA?=
 =?us-ascii?Q?ztAZPQKLfRBQacGAy4X5d9pCnO+s6C141/iie2fJX5qn7FLqPkZTZn7Srgwj?=
 =?us-ascii?Q?foX3spMCueUYoHNUdgT52rBlOL+/8ZeKhviO2EXpndgZTcxGMWItgJvcOdRU?=
 =?us-ascii?Q?3klBMdrBnlqzeOWWuAUDZIGEajBncAXUPfsEoAd8O3SeAgImASrrrzmSoerA?=
 =?us-ascii?Q?0G5Bzq3XmqoGz2EumgdzqI34AR4NPsYeLa+P/Dea/4DnA5RFUw1Mnpvcva4W?=
 =?us-ascii?Q?eYJcQ6CUMlsS9LgDHP4sLJjtMb1+XbPWQyRIV5IhJlIhQu4I/P0fAiMcEzNT?=
 =?us-ascii?Q?B4dtrQ5e2dhiuj1Jlej2W9vA25Avzg21PTqIOv2NTxl3KHCQn0x1v3Hl6n7F?=
 =?us-ascii?Q?SqZlMH/Js04sIJCnklgzODGm4PN77N4d0px8J69o6WHYMRzMJCSH5w6Hfoz8?=
 =?us-ascii?Q?HBWT2b/H+ltaNY+uT7mTf6UlB2MDT42C67B44o3PF0Wh9QdtJg+g52foZVHQ?=
 =?us-ascii?Q?kO2OZ1bimiAUJnDFFO66FnzErZIbZRh+oXXdfz5FJmLLSH+T3E0FQ7IGo2B+?=
 =?us-ascii?Q?kLvydrDAUuGPUNIdydAGo+NpnkH08U16UzyA3bfcolGWjsymjCFMUPsU2Zx+?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e093f779-f432-4eed-0de5-08db610923b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:26:48.7526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c90AuOsBCeCH+OK+tPr9iqGEMPssgQZ6iBinOTNO58cnKkXGrQgtzq06oxB/T3El8yfmzagaLExZQZToYa/OF3iDRzufTQyKWnToCdb1oAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7756
X-Proofpoint-GUID: K20rgS3qDoN3YtIwh8AwOKzFnBh5ek7b
X-Proofpoint-ORIG-GUID: K20rgS3qDoN3YtIwh8AwOKzFnBh5ek7b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_08,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 spamscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300103
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


