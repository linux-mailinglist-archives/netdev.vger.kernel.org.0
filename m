Return-Path: <netdev+bounces-6383-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62A357160D7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:59:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF57D1C20C47
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A191C76D;
	Tue, 30 May 2023 12:59:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226C719E5F
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:59:38 +0000 (UTC)
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FBD103;
	Tue, 30 May 2023 05:59:12 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UCNOsd001382;
	Tue, 30 May 2023 05:57:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=kI9Zo3fFkCHxqi623JLnhEv4feSEkvPl07NiLV+9i0U=;
 b=jzVbrDkNHbn++iDDRZf+xzxkKN7MpABMZnM8Pik6+lmVBVW6O157k+dqN2OeuRTR9VaX
 snPb79tsRFkiqNixdZ13/mjSJcDxr+uq+Rxr5AMI2txvADmd/iTDlaN4ZDNLPk2sDzc9
 +TbkYr1ndwuHHfQs3zvNgoDNUeEDZVN3pk4mGZi4htkafDfBf6K/r2B6tSj8D63OIvFR
 lNyfJqsqflFAHwF5+kmVZQUUgzuoa8aGggCZiA5kQdfXpbuG0jYMFQza8ZK4SZhLIf/p
 QyrCZIjanozBpAWIRA5vhRKPw7GCgk23X2giUY1xy1ZHGe6bqA/wLlzn2dqvcTuLTYs9 iw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qud53ad0k-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 05:57:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KhKTYb5BgTwySdKlSqHod7dRzzyuUOVJjrpO82azzuSifuGWPfGpyDg7JDEs9VayJ4t2nfqKoD7W6F5CoysalZEh3DQWtjzD/iXpCtKefahB5SmFOl4Q/uwbu4AHad7nu4gpL3XfMIqYBmas6PhNNgMW7NYPAOFf5951gimQf6qP3Vtnlf8cf5IQC99IlF1C8OHzLtuz2rZvfkZ2us4mUwybjMxqCspTVqH3tkHWHaaMl3gFm+DeKCFzp+NQr1ruu6trzLCaKD0jtBts7QCv1yzgqEmBX530pGI59gLf1510csukTxFKDFgyNMQYJUCtbjiryt6GATo5nBg73F5nEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kI9Zo3fFkCHxqi623JLnhEv4feSEkvPl07NiLV+9i0U=;
 b=KIP5GYuWZxrT66GUNJJNw3ewBrJkeHKW/913WGsRjVk31VQREsOLtYWH45s2lt9dbu6i6WOYPYHURcPj+CfEq4PyioaH1T+DQW1wls/jpEBzybR//OOm5g6O97incAYVgSSPZ6X8WB/KKX7Myyok/vUZTNSv6AcQNJuJJXi0l0qfh3bHYsPZ9LljaY47uX6UPEnqNvJhuf+DBKdBzHTGEeeOV0fZFiZunbcG6Oijg9sivSxUI/ZayF5vcGSOytdaQvlYsXeBgRQnh6PsBLul0bF5Ono3OnW2Uck8UxztYatoWy5V4HXwe2nJ6WNkwVlITCm7oROJ8TT3Dv8gocLeYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by PH8PR11MB6562.namprd11.prod.outlook.com (2603:10b6:510:1c1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Tue, 30 May
 2023 12:57:48 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 12:57:48 +0000
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
Subject: [PATCH 4.19 1/1] bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()
Date: Tue, 30 May 2023 15:57:31 +0300
Message-Id: <20230530125731.253442-2-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230530125731.253442-1-dragos.panait@windriver.com>
References: <20230530125731.253442-1-dragos.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0027.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::40) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|PH8PR11MB6562:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d393c40-1141-4312-abe5-08db610d781f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	dCuTvhLxNk+6jjH0o8+F75pAyKYnYCBlNJ9zoTzWdKaBgT8T6D8/F2sedSWiO9kWERz6ETn4ItVGFdsMc1ey/n5ISuTDSVFvTzeJAPbHAHK0oKS5pNG0BhPeOcJju37IbS28fga77+1a3vBVnD6GATAj+BKA6QnQ9bys44JsPve/B7KexvQ7raJdIDtQpM7qig3/h1CpwPQyBIwOIAByqYfP/XFFtIqYILiw1zBHqayQ1D7+JvREVg+avgXSoCfMxKor5b2gAAVjSW2hOTT2Bv1VCpIDeEYGva2APYpkk2bYr10kQHQ0w1ngVNBkGM2QJ8avfC/+jqR1NsaE+M6HM6jRnJJmsHdOBfBgXfVGqc5JmfuQviutQUR95/UfyQh386y7EaJOAaGWydykm5mYLCyqqbP7HCmhSeF5y+FqPcT9mRO092bVoctWSY567kZ+7x/XMXlPHi6f4G8cj/7eaOIUPlQWW67E4z/rR4W6kPMOaWIGHg9Azt/BqxeMsx2CaspaH2BzTidZY5MqN4nVOD5uRDPWZTiE/2oXSZCIh7ALZ1rPzPsyVk+CBYlt78U4QKimazK/OpMnG4G6qNPkvfNZKU2tAzG6qleFBP83P1gfFFZXOHCCcgHUHb5gQHbV
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(366004)(136003)(39850400004)(451199021)(6486002)(52116002)(186003)(5660300002)(41300700001)(6666004)(38100700002)(36756003)(8936002)(8676002)(6512007)(26005)(1076003)(6506007)(38350700002)(83380400001)(54906003)(86362001)(2906002)(66556008)(66946007)(6916009)(66476007)(4326008)(478600001)(2616005)(316002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?GGOsz1iHtC7CAXbmLfMNYj9H07T4SsHNy3ptvT7f7en3qof19QuVFfEreK6F?=
 =?us-ascii?Q?OhFE0ix8kaNTXo1i+pHF9Pmk/Q2miMw2jftM0I9VaeTVTeGw37nSREejIAbs?=
 =?us-ascii?Q?JR4YFjsKEvbCFt3hO86Po2rUbu0m7e6N1WNgV69EMvjFHw4EMJsSPCwnucGJ?=
 =?us-ascii?Q?Z+C/0AaQlDFu+84cUzZ9k3TLLX4cWuFZv81nIrkXhhx5kHx75uheTq+Tsj7S?=
 =?us-ascii?Q?WB9XiWh8B+uwiDB7sM7J6RmRkEm+Uautd2gvDpFqQxNC0YTQ5BGY8ZAHXL3P?=
 =?us-ascii?Q?p0GV5+YiYad3RSIZ8y34KryHE00Kne2jB4O8yvfYQHaDTNBj619XxWSJ4CdB?=
 =?us-ascii?Q?9Nl6k8GhreGhA3Uhem+Lbay+tzrS0FuuoXFGVQ/Ia0wSilb6+zLQidc+CqyQ?=
 =?us-ascii?Q?oqrX3paCQf3NKffvNZ0WE0iXe381kITH2YLVP1Yw94jZlzqu9x+dXfiRZm91?=
 =?us-ascii?Q?+lbVi5sWoK0ffbtfJuHfm0Nhkq91gYdaRmJ+4lDrG4OFGq/WwFMG5EcsA1TA?=
 =?us-ascii?Q?rapT+nNO/bB8ybvpCCQL2owkLHxewOJnzO72LsDJcT642z4Vf5cmteujY/zx?=
 =?us-ascii?Q?sO0haKSspHMrIrpWiENNpHxnad5VFPNogbtYeXVMcT20VyTU+6aLJVCz8KQR?=
 =?us-ascii?Q?94yCJyJLnPPkYO9L0SKPng+o0FIRGskQpusNJ8CkCtTC6Y5Wiz0qbDF3oPQR?=
 =?us-ascii?Q?lwL372HNTpgLLyPNSepQT6k4XjP0kD7YKrIenoP+ZaPlq9DmzrVOSmd4T5qc?=
 =?us-ascii?Q?M0w6YwDaWruH5eJiQkw8l+vFlt/IEgvMDROv6Verb4rrgFypY0SLwlEgXl0z?=
 =?us-ascii?Q?3RNqdGbyGzjk2dO5UTUnTayDfuB4xldt+P5lGV5VsNfmfv+HQfhW6vv8+xTa?=
 =?us-ascii?Q?S5HBKp2lf6o5TwQLw4y4dUyn7e6oxpdiROCIRb7jjixxf+QITeeQiCzCiOo+?=
 =?us-ascii?Q?eq0VgcDKFS8ctZPqBN/zZ69EbsCvFUp/JTFd93sXgHJ/pm0zSgjPXxceBavX?=
 =?us-ascii?Q?hKFyNQrbMA6qo7/91l7lEEW4bLLPt35RFfBIWfaS8TI+W4pMAp/pwiMFoeB2?=
 =?us-ascii?Q?pZPbcNVnottZhrufI7ZEGqTSF5TSb7Ohm6Ys/N4sKruQ3D6FBivVDhgSj/UP?=
 =?us-ascii?Q?E9TSJfG0Wc7f5gbuoZB0yXkZUI3G5OPHc2jsnoyML0NRRVmbklWtixr58ra+?=
 =?us-ascii?Q?+yC5dyVZ4wFoyV7axHI3jMI0YOeYaNgkuX9PAw7R2UGH5UEFwPV0Q6qdwsLa?=
 =?us-ascii?Q?iXuOb4jrA1q9YgVzePom807pWgodlMw5kZElU9EtECIpjMcTshNL9R2KLZB1?=
 =?us-ascii?Q?dq23h8v2Hq1deG/nx266tdRVomeKoTAImw8pseLoYvdWc5FyJzF0ojjQLqML?=
 =?us-ascii?Q?llZj2mEA0Un+1o03WwbL5Y56tIDIjH6wQoG/19IeZMlDzRZqJfUJH+HKz1t3?=
 =?us-ascii?Q?K6XmdpV0U8lRad8ztCZpYVPalhcMy8Sl04SUIeiqNj9bAWo3I272GeYEuk9l?=
 =?us-ascii?Q?JgUBLrmUbqFIW8r45/YEP/VigbEPD4LpBx0L0QHAUZ/Zc7AOtre92WEVFSDC?=
 =?us-ascii?Q?xkjBO1DOktrcDZAdXm9gxGTny2ByTc/2yARWAf+ad/JyKpwrmTA8if7ZU7xF?=
 =?us-ascii?Q?8A=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d393c40-1141-4312-abe5-08db610d781f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:57:48.3140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWSPVWLcrnTVVmIMUjx6TNatJmh/EhVSJqA1tycQmKlGipqPtbGV+kOpZaSQLPPwtmfJnEJji8IUfvfUbuybXjhOrhtQtkOzutrLBRFfAn8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6562
X-Proofpoint-GUID: U8DQ10O_Idp9d4QeOQdz54Doi0bn_zg8
X-Proofpoint-ORIG-GUID: U8DQ10O_Idp9d4QeOQdz54Doi0bn_zg8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_09,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300105
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
index 908a57578794..182c3c5b8385 100644
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


