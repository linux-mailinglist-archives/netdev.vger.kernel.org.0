Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC79492E68
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 20:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245348AbiARTWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 14:22:19 -0500
Received: from mail-co1nam11on2133.outbound.protection.outlook.com ([40.107.220.133]:63200
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245079AbiARTWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 14:22:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOZWCaFBbJ1yGmPCi/zCqscDUzpvo52FnB8ya2sAdT3bLnkNVsU55KfE4Vh2J00hTiH7psKEfwlzpWf9svRI8iEUkW8dSEnUcGDoJNFtZhS1/14qXL02MrKS0u24ue6n60lNzYLAdMuYWZrxtc5sJUp5I7R9HypYSdC4wQTpkP1h8JFeNeL9ZbapuBhQ7CcFkssld5r5Lyx3LqgXrOZNnMcbfVlyumd8zFzMMsthWarBcfwmACLpe4C8/h3bhgMRKkwZHbu+DpYmuVNdSBFD6XOVuFFXhW4iQlW0MSafzjteWDFDGeF/L4CdCkJ+3q2GMKcf5E6l+U3oCFcFuVaKYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/uELpcLySst5EkjpGrWmgmrOnV2umy9sEEszsuLpLnU=;
 b=balRezTOVW8Y8+m0pO/9tZ2Y2rnySptksg1j3HrjVSUO4i5mIlIJjFU59n/ufgCMK86XDK+ZlbvFiOvatrFJWLu9ysm1w10myuUCmGzwMGOTQWpUGt0b+byM4g/UMQm+fNY1JjZz4FDA4ug4NfgU/U4n/zGLspbeRsdYN7tl2Sg+3DoKzUrkzBediDXR9XSTgx87vEOytEP13DJnUI8fsgpJk+gCMfNW7oCvf/jBfqWWRQNEWOfcb9F+D8nKrt11F6xKYyiVdCMsB6AO/91b7fMIC3HcDMRv+DeZ820dEWUNHxhpNY3tEatiBusEV1W6kqlx+EO8iwycW9O9vpDAqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uELpcLySst5EkjpGrWmgmrOnV2umy9sEEszsuLpLnU=;
 b=G6nwk80kkMEtZb8LvGHWHNZ+iEWFU+nDB3ZL8W1CJI5HK1jw0yrsN6qwBTXThhNsRVpBDVLGV3S9J4mMjI+bMjrb2CF40c06gjstTF8EYdP1KBev1hwE/Cd2d5B1r2dAxKnQBePXa0XI0iFOqPsmDYYEeym75rVb2XUsUHx57jQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purdue.edu;
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 (2603:10b6:301:33::18) by MWHPR22MB0623.namprd22.prod.outlook.com
 (2603:10b6:300:f4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Tue, 18 Jan
 2022 19:22:00 +0000
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::a42e:ece:ffbf:4b3e]) by MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::a42e:ece:ffbf:4b3e%7]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 19:22:00 +0000
From:   Congyu Liu <liu3101@purdue.edu>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     yajun.deng@linux.dev, edumazet@google.com, willemb@google.com,
        mkl@pengutronix.de, rsanger@wand.net.nz, wanghai38@huawei.com,
        pablo@netfilter.org, jiapeng.chong@linux.alibaba.com,
        xemul@openvz.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Congyu Liu <liu3101@purdue.edu>
Subject: [PATCH v2 net] net: fix information leakage in /proc/net/ptype
Date:   Tue, 18 Jan 2022 14:20:13 -0500
Message-Id: <20220118192013.1608432-1-liu3101@purdue.edu>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:610:38::37) To MWHPR2201MB1072.namprd22.prod.outlook.com
 (2603:10b6:301:33::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1856115-01f4-484a-f1d2-08d9dab7ccdb
X-MS-TrafficTypeDiagnostic: MWHPR22MB0623:EE_
X-Microsoft-Antispam-PRVS: <MWHPR22MB0623032D0BAA494D53AC43A3D0589@MWHPR22MB0623.namprd22.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bra4mE+kxfCYh0q8+moLkJqIebvo2rHHKEbJLWl9NzRyeRUuGRCDIuNkgzGkP25wpukmq8xo5KR1onwwbFwAckT4se0hToBVZPfUO0CIL8uIrQC2n8drDYmLCn/zjEztYkBxobX9UqD04YbG/o3ODQyjsdDdw/RU8eADatjJPlqgxHgEMmIlUozVvYjXQfiaXegDYKoqbw9jfA4yQcbLjOy8M/ISi+nMd0oD4wWGBQqwKXJ1HYTsa3i31v2nOuFyGLViYGUGlg5LFb/D2YRDSOt78MTmBefZTaxHWc4LyDaQ+RjpAOOSmw32lfFaCTseHwFB9eK8BnRpSYydY3yD0X9mqh1j45Mo19GL7Bhr9/Cs3L4QOqZ0GbvxnXZk3SCZ5DA2I8LxTwlpjVUgpYNExbPfVG5z2Wfig2fN3LZNsxBgOa7gekR8owF7CFAgkaaQSDb/hm953QoPeWpqnhsjPe9VX0ww0/h77/CBADokdkLWEpJBzkuYFal87U3S46HEyoLczyKjCBVkKVVLrq6A8IDTwvrjbRT+c/X2Jxz73/QAanvdqpEto7g8bR/N5KJjRAIrzayM2x5I0CC6SKJ80612x5RWkh25yoT5qals1mSYHVQ2jCmVrsyeQPhrovYwuhIqACNPAvhy6IcLhMNFpOcIvFvapSCPlr3pPLITSctDph0A3P7jSi9Nj94nfcEFSsFoMGvQj3b854Wk5dsSlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR2201MB1072.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(6512007)(52116002)(2906002)(36756003)(5660300002)(6486002)(38100700002)(1076003)(508600001)(2616005)(38350700002)(66476007)(75432002)(4326008)(7416002)(6666004)(83380400001)(86362001)(186003)(26005)(8936002)(66556008)(107886003)(786003)(316002)(8676002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QBOczGQRn/wabRrYk+HEHjuk9IDns1av2fYE0izZGLDhIjQBgBI8sAeuS7dG?=
 =?us-ascii?Q?Qk+Zv0fzlT55ooxBKQS8M+ceEKjmEIMrTC08hEaXOJ8vI53kc48dhz1x14WV?=
 =?us-ascii?Q?nhWWsq7QpEGoGTWKLYSKeGmkglH6VSUzrtY3bp2RwJHvvVG3pM9A/TfncIAv?=
 =?us-ascii?Q?HqckGa8WZDMDECQ8+kJ5ONOlv92hjJlrpNFlAAgSxBy65wHPaFs6jQCdGd+V?=
 =?us-ascii?Q?i0v6xeoFeI3ewgcBMlYYfMzQbiARFjvFJbOVx0MbNnazThWWh3kuA2Er9tg4?=
 =?us-ascii?Q?ox1T3IaBYM3qoPKCfes6UB2kDMk3p5g9BzGNGAguoW5YBJauobiymKSUSlo+?=
 =?us-ascii?Q?jPcdEwS0g92I0kbKOBPeq5qftGmprD/y6gKx1GgBq/E7yK3D7lJxtCtTWyCA?=
 =?us-ascii?Q?aWcwyZG0YNX7QvjOgJHrJ0NSTWH1iLyj2nxWRA8y707SRS7cNpMcNUvG4sL8?=
 =?us-ascii?Q?zepmsfkymMjMHGItlkFWdeQexQ2rAFogdoKXXB3RWffWCHIYiI3bUKD+ek03?=
 =?us-ascii?Q?ricnGtNZB+xSNqrli597AsW+AQkuWtUySKSt0/kogwXOr6dwsZBO0cr0vKNJ?=
 =?us-ascii?Q?mYK4uoTaD3oaEOECndsFNw87S9vwMJZCOOGCZ7li0Jhh+ygxwS/AiaAV0TBv?=
 =?us-ascii?Q?yrtsxKF6vtwIGqIxdxnjag+5ncr/I8F+ZynOaoOcMbmAtuBvF6PMbsd/2sZq?=
 =?us-ascii?Q?DxcmTl8LSs5/0I3wQXGCQk3aRNThZ8ZOs9dZ8dPv2QIYLH4pRV4iIHXvyF/1?=
 =?us-ascii?Q?0W7zwgswKLKJ7D1bFGAsi+0vi/kAcIXRRIORcOy8bscvXNE9WwbUSAh8W5dS?=
 =?us-ascii?Q?J25eKevYkxnlZauamrw5jhr5ESJAWoIizg2EYkoJ4lJ+0AYSVDvuFP6GnMDd?=
 =?us-ascii?Q?7x8qqe4NV/dsVrvjjPFUOsCEQQmandLtdYD3aeIoPCcUN6smy183E/3ptHGR?=
 =?us-ascii?Q?2AZyYTY4H6p7s1UbAFg8daN3+9AQD4wDndS+9jfpqCkzECoNzxrC1CDG0gMv?=
 =?us-ascii?Q?bI5vMtpc1YQvRSoHHWCOj9X2iso2JtnM1oPdZ8VBcmpd/wLCfSo3vVydD355?=
 =?us-ascii?Q?ka14gMShKDquVb82nML5zP1qNhYxKgC/83EjTlVD/yWgmfWdesgE5c/i4TVI?=
 =?us-ascii?Q?3x4O8ywqWZ9DO1IppKh/N2D5KiTJhtH5WmDE6OyuZtz0WYNndJAmM8A10Hco?=
 =?us-ascii?Q?f4fWEyp1MlpPnj/23W02OdiT5Z1gTWf6OdtUmQ2U9kf+6CA/rClqI03b1XJ4?=
 =?us-ascii?Q?Knlbx9cI2FGdi4HICDZpCDEFTwCaE8e7L49N5fcsSVWszGkEJGSSL1QFSi0j?=
 =?us-ascii?Q?M1yfpkn9Bg2ov5OhSdfqefZB9re5wdIEWNwnoxG0EvBiexRmt4jW+RsnVAvy?=
 =?us-ascii?Q?valIUc/qJq0OTWo3XRVHO74z9Dh7NEBL/Uf7TaYZzv3jUkNqdTBMPW7Hu7Kd?=
 =?us-ascii?Q?2HFaInF9Fyn+8V/sWI9qCRx23faimlNtnPGrrk1f/9tK5iCWMuy4P83Gjlwi?=
 =?us-ascii?Q?37pQ5ZKV+a/9915nEHL+782sDo/YuZ3IGl++yGgUbJO4LlYzYbW2xme38oc3?=
 =?us-ascii?Q?2apymmF7bKmG7hKE9/iIdCdlLbhjSvQR5CSVpjIjFU5K2FEP56MKueq24Crm?=
 =?us-ascii?Q?1uNepgCyfA6HLx9XFcHJApI=3D?=
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: e1856115-01f4-484a-f1d2-08d9dab7ccdb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR2201MB1072.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 19:22:00.3128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LOnWs6+I2u0Pl5TChlUzB6BG7n+DeFZuQ8lA09JiMNnZgBw1Jgqy4Tlltosa8fjxXgwh+ZRaicibkz5+7aAJlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR22MB0623
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In one net namespace, after creating a packet socket without binding
it to a device, users in other net namespaces can observe the new
`packet_type` added by this packet socket by reading `/proc/net/ptype`
file. This is minor information leakage as packet socket is
namespace aware.

Add a net pointer in `packet_type` to keep the net namespace of
of corresponding packet socket. In `ptype_seq_show`, this net pointer
must be checked when it is not NULL.

Fixes: 2feb27dbe00c ("[NETNS]: Minor information leak via /proc/net/ptype file.")
Signed-off-by: Congyu Liu <liu3101@purdue.edu>
---
Changes in v2:
  - Add a net pointer in `packet_type` to keep the net namespace of packet
    socket.

 include/linux/netdevice.h | 1 +
 net/core/net-procfs.c     | 3 ++-
 net/packet/af_packet.c    | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3213c7227b59..e490b84732d1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2548,6 +2548,7 @@ struct packet_type {
 					      struct net_device *);
 	bool			(*id_match)(struct packet_type *ptype,
 					    struct sock *sk);
+	struct net		*af_packet_net;
 	void			*af_packet_priv;
 	struct list_head	list;
 };
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index d8b9dbabd4a4..5b8016335aca 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -260,7 +260,8 @@ static int ptype_seq_show(struct seq_file *seq, void *v)
 
 	if (v == SEQ_START_TOKEN)
 		seq_puts(seq, "Type Device      Function\n");
-	else if (pt->dev == NULL || dev_net(pt->dev) == seq_file_net(seq)) {
+	else if ((!pt->af_packet_net || net_eq(pt->af_packet_net, seq_file_net(seq))) &&
+		 (!pt->dev || net_eq(dev_net(pt->dev), seq_file_net(seq)))) {
 		if (pt->type == htons(ETH_P_ALL))
 			seq_puts(seq, "ALL ");
 		else
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 5bd409ab4cc2..85ea7ddb48db 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1774,6 +1774,7 @@ static int fanout_add(struct sock *sk, struct fanout_args *args)
 		match->prot_hook.dev = po->prot_hook.dev;
 		match->prot_hook.func = packet_rcv_fanout;
 		match->prot_hook.af_packet_priv = match;
+		match->prot_hook.af_packet_net = read_pnet(&match->net);
 		match->prot_hook.id_match = match_fanout_group;
 		match->max_num_members = args->max_num_members;
 		list_add(&match->list, &fanout_list);
@@ -3353,6 +3354,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 		po->prot_hook.func = packet_rcv_spkt;
 
 	po->prot_hook.af_packet_priv = sk;
+	po->prot_hook.af_packet_net = sock_net(sk);
 
 	if (proto) {
 		po->prot_hook.type = proto;
-- 
2.25.1

