Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5309043DE59
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 12:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhJ1KDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 06:03:34 -0400
Received: from mail-dm6nam10on2121.outbound.protection.outlook.com ([40.107.93.121]:38624
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229974AbhJ1KDc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 06:03:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qwtp3yTuo0uIQdj5/GeZzxFelll5Y3LqJD8epjh/BWM++fJsrmZdgrKChGcDgwn03BCbw8MLxjG2TB0WYzk6QNySlpRCAxM3zYZ8n92VJzrjCYzi19J/sQyYnkswNYYK6rZ4phYP3cDqJmfSXuCxHSK3Jb/qqJt/zNxLKZRdrHu2uzHrfOU9oTaM3CUOBElvJPTJo7LHI6PqKZ8ScKT2YwzGiTslm/nR7sUlZMSmXY51Yvm5piYhJE4vK1ubE9J1w8puipGtaWevkQnwyiR0DxG1t4zEfYrvLW2TaY16EqBIcLFwAd+PBMnyFcdSt3/31iMpK9UpgDyB/OdaDXBnmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPdouMOJI3zhtxu1653kN/OGmHIbxetZPRC22a1mVi4=;
 b=dqnqr+mTJdiH/uenUsMJQ2PzgiRT9rRiRqLfwxZaieegIZNfsyqkFe672R/KvELViNXYTRCn/y2mFg/jdHNqC88d9/cQaGuN6KZcUOysw00bE93xUdh0j2npvCrfuXEVsODRwuPf+tK98h2FeDB2fPWXZ2jZkCJdgnl9q5zTGT0APoNtXnz1VO3CXWjPln0av2P9/FZwc27L7vL1t6HRyQBk6Jh6MUzVsd27JYEf/n+BiGVkSe+DM1i3s/8s8JTrTut6pfiitxNUsXVYIGnPbw9IPPfZHEkRq5bM4mmzNe1qgaEuuK7rx9T+LHozHe7mNX3GMWIkP27mfYZNqX/aQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPdouMOJI3zhtxu1653kN/OGmHIbxetZPRC22a1mVi4=;
 b=tUtsCEMCmPSv9rbl4KluZqkasOrJ6AdYifGkj09Ct1aVnEoHPgT7ibNqN0uRsWDVL1qFep9/aOGeoXWONYtQxm1B8zitU3O4WTPYjECLtVjfp4OEcGm3NcXZ0Ze4P9ZRzwGMP3Z81JbHeJV6gwGS1h4X/wqaDFQMdVcJQZI0W/o=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5520.namprd13.prod.outlook.com (2603:10b6:510:12b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12; Thu, 28 Oct
 2021 10:01:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.005; Thu, 28 Oct 2021
 10:01:03 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Niklas Soderlund <niklas.soderlund@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net v2] nfp: bpf: relax prog rejection for mtu check through max_pkt_offset
Date:   Thu, 28 Oct 2021 12:00:36 +0200
Message-Id: <20211028100036.8477-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0024.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR07CA0024.eurprd07.prod.outlook.com (2603:10a6:208:ac::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.4 via Frontend Transport; Thu, 28 Oct 2021 10:01:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37747f0b-d747-452d-3ca8-08d999f9d9e3
X-MS-TrafficTypeDiagnostic: PH0PR13MB5520:
X-Microsoft-Antispam-PRVS: <PH0PR13MB5520C609B8B74FE6773B18E2E8869@PH0PR13MB5520.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /cbD3j2XX1SSZF5A/cNoZZRgfO3Fq3lOAyC5ilpUYph3qvgbJVoh0Y5JRr9RUtJIN87uawLM6Mxz6qWjLhIH7kz4zBPGe3WsIXxCQ56RD1VDKlbqq5rloPZ9yvzbJ/hdB3YfZ3oH2gknOiwoTdeHDhaswH8W4YADZJoVUyzL4oWXKVtpLUSvpTAET6riRNgyj+mERa68FbywBrWSAypDrV9bBvc5sW2/OJqR5MUTxQrblbCFtduXIMNiXQN8rCAcxz07PFuxIOCdsuZa6BA8b5vP2Mni1amZfDAP4BUV9bGxgJOsJNKPx4H7C/HoV+2Ye4Z79keNQzXqtSDzD5/uZB8RgPC/a7oSiElfCKOdTgxajMkV6O+c4cY29vJRZKX9aIpgqEubNtu3KoluMr3SB9ctwAfQlq/NrqX5qmFjgWcPkhD2Fl79ASCbZESdURvNrZ6PWro9LJnhIfVRh/NovhMAe+g2Gb8rTRJVAERdf7ksYs8n7t1GS8qYfhi3hLAE17zCW7ZlOO0GXOnORuok0/n7QSyhx0LM9b1v1bDCKpTzvOBSsF2EgV6xijt0i4y0pcWWMz6OLEyrCFlgco97RT6MKmvbOv6Gxa/PSdPQRy1PpHExzntmuW0dtdOEUaY1ttMDeVOONNnztPN/u3nwCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(366004)(39830400003)(376002)(66556008)(66476007)(36756003)(54906003)(110136005)(5660300002)(6512007)(2906002)(66946007)(6506007)(186003)(107886003)(6486002)(8936002)(508600001)(6666004)(2616005)(86362001)(44832011)(83380400001)(4326008)(8676002)(1076003)(316002)(38100700002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hr5Fh9qsOj1nSljt0lqN9QjGft2c1qupjN47c9WRMq+noLjOQgWZHejq1/Ae?=
 =?us-ascii?Q?3cQaeZ9YwWSXzd3aOVFMyDqXEDKnglll5JoJ7V5ecHExQQXlrf9mRmMR865T?=
 =?us-ascii?Q?l/R5SffC/ZaiH+RRzT7Qw0yAo4CsuwjMgH0t5PDtrqXnKI1ADLJDLdX5BtNV?=
 =?us-ascii?Q?BjUbNemDCh5KiSuS9yFyy6aU5XpcqmVhwjhxDrnH0JK4MGKw64YGKej5USG1?=
 =?us-ascii?Q?SVHs/0zZnjKQQWmPQChW+zkeZ1UvMbRGRu3Zl7kehB0306QHQxKwXkx/bYE7?=
 =?us-ascii?Q?aI+CTM4TjwtIxYZoTsr/1G3f5RmiVSYqlgIW4RmTW25YJ9fGSueUhnnQ6ZES?=
 =?us-ascii?Q?bAOogIFZlw3NhQ5F5RGtOuhcccsB5RruHFokY0G7dZmLV/Yl0RuapEzJPVjv?=
 =?us-ascii?Q?xmeHww1F3bv3KFVuoF8tWumTSTQuWGhXYFpqU09CLJqlY/1hHIVmca/p6fF3?=
 =?us-ascii?Q?/1MFKK+C5ov4LRwtN22uiuh1OmnNl8qo5w0eziNeDfGfbB4a8ab2oH5V8GLW?=
 =?us-ascii?Q?Tr61Zx/fLEem3GUMedDXdpAk0tMAPUB8hmjnnI3BMNbh9n1hag6ntqwjZ/gj?=
 =?us-ascii?Q?da2HZ7ucPf/qxhV5Lw76FqDvqhMIDiiCIYe6icvKWPxiSqEPKr/i8IkbTR40?=
 =?us-ascii?Q?TrCH+xaJDOuHUhw94gJbp/E7s185bdPjAPMi7Ew6Rs4gRekrDooSdMY6E0Pb?=
 =?us-ascii?Q?Vo5YO7PXnrEgkGPXD+qH+cpl7FZf3+senyuJnrBxz8ae/vk9MHC/9ywTIkMP?=
 =?us-ascii?Q?tDamD7QzKgPAkcBpeCe/469nuZJYclwHXos7KYUqdfAWm3rOtV2maq6QzSKm?=
 =?us-ascii?Q?nuRxNA+RjOIcg+uuDs8stc78VtK8SIfIFJTy8RpHuneHoCppRwCuMO6sLJxL?=
 =?us-ascii?Q?CPYwCeyZ0Cakl7VwM0GPhOLbSIhF/ZBqBGgEe6R3+x8bF1Ple+I8PSqnbWF0?=
 =?us-ascii?Q?2arhgMhPLolvxG02oUMqWpfIAiBYBNJqL7POxYFcFfLyDM451gjPkG9N8F+p?=
 =?us-ascii?Q?T4VuNTt4ErYfXyvWMxQ9midrl81qzvq5PmPEQWdQf6tKfRZyVJd9eap/JNsg?=
 =?us-ascii?Q?duGndFdClC8SchACGhh4L+mmEc0xgG/5IE1iB4HQmHaWr1NxKTzKm7+BmDuF?=
 =?us-ascii?Q?9qvzCGOpsIE9KZ108TdRp6CZ2sOI6ZanI3Ci3jsSx+DDw0XaiFUtuXGxkiad?=
 =?us-ascii?Q?/O4B5Fn1XGGwWI/lstLYqHaykg3aaT3gdfjs8yUw88G7KM5zI6/oSBUtitf4?=
 =?us-ascii?Q?GG2EuS+OCVbUt7BS/2JeOACG8m2q2RJ4e7Re7L+wSE0RAi0FZ93lpUNkUFbN?=
 =?us-ascii?Q?t/WKB4cc6xnOreSaUFNdrCNMpOznxLLjHiF1B9dsdJYn3mVtRjdQIv3YOvcX?=
 =?us-ascii?Q?rtSQZfVEPTPDkMCb/s6LnxbYUXYQFCFZ2cMKq69OSBUvLHMqzcVDwoMMLbR0?=
 =?us-ascii?Q?CDbWFtHt7vsXhT6kEqB+WQejgAydOTCezlwT/H+AmPpL8YfRqKDFhsWYwnpl?=
 =?us-ascii?Q?b1ukY0q6HrlNQrHosrvyZZAyMzcO1Gjv0qFeVQJrUoO3/Ir84VI2btlU3jMC?=
 =?us-ascii?Q?nV4mi58HrP+qIBhK3f/vPgTuSyyiDSBblCrs+8SWWsNriLjMyoxG556pNKvU?=
 =?us-ascii?Q?XUHRQkT9p4fMQ9WGV32hzTs2iOVGoqeqnminUTgwh2yt7yRvdVRNSDlok9ED?=
 =?us-ascii?Q?AA21UTLovcDbXf8q9jGyAJWgZa/sBJ1WS7q9usdMhQIZQ7tDnvR4QEgdxQ9F?=
 =?us-ascii?Q?tbk5P7Z9Eg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37747f0b-d747-452d-3ca8-08d999f9d9e3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 10:01:03.4624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CaoADtZYXMPFCPUJco1gEPY8dutfZ6XGRK8Q7Ls8MrKlVGzaXYBqM3oDeBva+fo8Gmm2+kwn4Fpl5dZGPkJ77uZBoCnMECTkONuJf1Nq+E0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5520
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

MTU change is refused whenever the value of new MTU is bigger than
the max packet bytes that fits in NFP Cluster Target Memory (CTM).
However, an eBPF program doesn't always need to access the whole
packet data.

The maximum direct packet access (DPA) offset has always been
caculated by verifier and stored in the max_pkt_offset field of prog
aux data.

Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Reviewed-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Niklas Soderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/bpf/main.c   | 16 +++++++++++-----
 drivers/net/ethernet/netronome/nfp/bpf/main.h   |  2 ++
 .../net/ethernet/netronome/nfp/bpf/offload.c    | 17 +++++++++++++----
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index 11c83a99b014..f469950c7265 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -182,15 +182,21 @@ static int
 nfp_bpf_check_mtu(struct nfp_app *app, struct net_device *netdev, int new_mtu)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
-	unsigned int max_mtu;
+	struct nfp_bpf_vnic *bv;
+	struct bpf_prog *prog;
 
 	if (~nn->dp.ctrl & NFP_NET_CFG_CTRL_BPF)
 		return 0;
 
-	max_mtu = nn_readb(nn, NFP_NET_CFG_BPF_INL_MTU) * 64 - 32;
-	if (new_mtu > max_mtu) {
-		nn_info(nn, "BPF offload active, MTU over %u not supported\n",
-			max_mtu);
+	if (nn->xdp_hw.prog) {
+		prog = nn->xdp_hw.prog;
+	} else {
+		bv = nn->app_priv;
+		prog = bv->tc_prog;
+	}
+
+	if (nfp_bpf_offload_check_mtu(nn, prog, new_mtu)) {
+		nn_info(nn, "BPF offload active, potential packet access beyond hardware packet boundary");
 		return -EBUSY;
 	}
 	return 0;
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.h b/drivers/net/ethernet/netronome/nfp/bpf/main.h
index d0e17eebddd9..16841bb750b7 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.h
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.h
@@ -560,6 +560,8 @@ bool nfp_is_subprog_start(struct nfp_insn_meta *meta);
 void nfp_bpf_jit_prepare(struct nfp_prog *nfp_prog);
 int nfp_bpf_jit(struct nfp_prog *prog);
 bool nfp_bpf_supported_opcode(u8 code);
+bool nfp_bpf_offload_check_mtu(struct nfp_net *nn, struct bpf_prog *prog,
+			       unsigned int mtu);
 
 int nfp_verify_insn(struct bpf_verifier_env *env, int insn_idx,
 		    int prev_insn_idx);
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/offload.c b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
index 53851853562c..9d97cd281f18 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
@@ -481,19 +481,28 @@ int nfp_bpf_event_output(struct nfp_app_bpf *bpf, const void *data,
 	return 0;
 }
 
+bool nfp_bpf_offload_check_mtu(struct nfp_net *nn, struct bpf_prog *prog,
+			       unsigned int mtu)
+{
+	unsigned int fw_mtu, pkt_off;
+
+	fw_mtu = nn_readb(nn, NFP_NET_CFG_BPF_INL_MTU) * 64 - 32;
+	pkt_off = min(prog->aux->max_pkt_offset, mtu);
+
+	return fw_mtu < pkt_off;
+}
+
 static int
 nfp_net_bpf_load(struct nfp_net *nn, struct bpf_prog *prog,
 		 struct netlink_ext_ack *extack)
 {
 	struct nfp_prog *nfp_prog = prog->aux->offload->dev_priv;
-	unsigned int fw_mtu, pkt_off, max_stack, max_prog_len;
+	unsigned int max_stack, max_prog_len;
 	dma_addr_t dma_addr;
 	void *img;
 	int err;
 
-	fw_mtu = nn_readb(nn, NFP_NET_CFG_BPF_INL_MTU) * 64 - 32;
-	pkt_off = min(prog->aux->max_pkt_offset, nn->dp.netdev->mtu);
-	if (fw_mtu < pkt_off) {
+	if (nfp_bpf_offload_check_mtu(nn, prog, nn->dp.netdev->mtu)) {
 		NL_SET_ERR_MSG_MOD(extack, "BPF offload not supported with potential packet access beyond HW packet split boundary");
 		return -EOPNOTSUPP;
 	}
-- 
2.20.1

