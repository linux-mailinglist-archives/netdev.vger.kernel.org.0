Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB42206A0D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 04:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388288AbgFXCV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 22:21:29 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:63460
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388095AbgFXCV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 22:21:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TwAI2x7bOCWWrmxMRpic8/s9Vp/Ohoo88s4QxsHDbUEuw9DuMqMye5G+SATMnIugSZ9xsL+BHS/IHzhywwmZ+RXLkELtuNLd/Nafu/ob1FewYzfuGELpBXPvV16JYyxpK307RH0OVNdb5ip1XiBYwW8Zu/ReE4YZpQvjnxp7mp/l3i3LHO6b+/SyHWDlu8rru9bV8dhFDGGDNLd43WFVGgc9mPlw9T35RstWA47i8NpI8Ff5kIW/YJ74hQi7ws8ZfoaZV3q2olsN+5+BCceNWp9Kl7bkvvm+jBVw67xAnt3Uts77/ovnr5tDmraVT+J2ofGeQCj7pFUPTKEGRBIFdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvlrTmQHnXAEK9ooKha8cL1GrEdP0cdhD8iDygZfaQ0=;
 b=kDkHX7/y1jE6ybm8+UOPM4A6y/XDiyh3cLIYCr6JC3/XiaRFSNy9WwovD7iQQDCSrW5gQJ6PrFfQZmu8ZRL/wDG/EF00ziv2Zm2VGmteC3HeiIveTiSD5/hCszz5Ml+R3ELGnDad1Z36t0avlSlqz6nVleuLcXyGCGoikP/SKkOoJnmoG+PcyDRPn4GpzENIDm/0JPPZ0eJP20h6VI7r89fbZ5lASsLNx1GGD9fijLVhASKZ70o8TBXS33Ej8wYVzV3wLQer8STG1zzQDzZ1FWzM0kpc5uQPZtR4KrRmqk0QBIczmgoThcasf1CM0orBMBXL8Jkfi7kLyLFzo6QoPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvlrTmQHnXAEK9ooKha8cL1GrEdP0cdhD8iDygZfaQ0=;
 b=hMAz2TjmwQNNWAZGQ34F59P0ZVHXs6ub67+iGvghEyKTpCVWiuSxH7Od1syTD+UqHzzQNQOJBBTr7N6j2H8spkGB3k6+X62M38YjxCoPeprwJabW1sTBcKwBbtLC051c4BufMeIKjKPVnlt1nhBrHPFpMXH75P24vXqP9LgePxU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7022.eurprd05.prod.outlook.com (2603:10a6:800:184::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 02:21:17 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 02:21:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 05/10] net/mlx5e: Remove unused mlx5e_xsk_first_unused_channel
Date:   Tue, 23 Jun 2020 19:18:20 -0700
Message-Id: <20200624021825.53707-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624021825.53707-1-saeedm@mellanox.com>
References: <20200624021825.53707-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0077.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0077.namprd07.prod.outlook.com (2603:10b6:a03:12b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 02:21:16 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f9741a04-0b11-454e-5ed6-08d817e546a8
X-MS-TrafficTypeDiagnostic: VI1PR05MB7022:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB702246B831E69FCC4AB45F62BE950@VI1PR05MB7022.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:162;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fq2rQh6z3VwbnfTTBsWiZMktPCmtwKEhWSwrpLOPkQR0rFiV+iHJGJY69323jeqzP1H/ZKStJh3gIbt4243C/z26uKo9W1DI7MSb1xasLnoH0wdRJKFGx2qRmHeL/9jb0ddRc/YaunA7Yt4ATpXdSoSlb/Foqn8oybKwGxCodXjo8Dzxdlw3YUek7CStFk1sx6Tcc6My6zEzHjUCIYnYr45y1xrmsvaH8nOpgyvslsWaiitz5ZZa6X0odNp3MXRNaQ2nrvV0NTJe9oJoFiZaBV9ysZX/5X9/EuFDT20NpyygY5wCBSGA8LNBU08EZpIOjmu19pcySgMKV4ca3i0B5zOvnkxIjPoMmEpGODNOzVdKatXthe0jSggB50/OhYcw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(8936002)(316002)(478600001)(107886003)(2906002)(2616005)(16526019)(956004)(6666004)(186003)(1076003)(26005)(4326008)(8676002)(5660300002)(6486002)(66556008)(66476007)(83380400001)(6512007)(66946007)(52116002)(6506007)(86362001)(36756003)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jwjjUvwrtedTCtenSwvoG9NmjfZ6Gso9/ubbveqeQzBnrKmg94KTSNvgnxF3kdP922Y8mdQ6jUz2h/562n0MYMiZUiSU0IptEKHLdc9CZd/1eG6D7DdefZo0PpvpgI4XktP/mOhFJb7gJVHkCNLGfs7QNKPeIcwO4iVKEEpNzNC7gvhhW1QmsUlaVIvlQ6C10qaCJMVmEf87P49NPWdMwmJRhxLcwQmWQkZ5n0/djwttF8lWM1Uv+P8m2fsyKDYJpHZ3Do/1XIGlnRXEqFXntKuOi5YA4zA4KNyomZNwBOL2oTC24jGkUBfKMDhvxYiOl8wumr2qeF1IeCW/pReSS0SYX5QHm7qn3knwd7/v7bQ9SP12CoYk373BzIWX60SUdsk59ceHL7hsXFEmVOnbf5Vmlg5W1bJf+Esk3roLlVGOz5FAUmDdX1Od6IlFIU0StzUtZ/2ALv1bEqnqnNKKJE+IuHuxNMltqIX2m5CaxbU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9741a04-0b11-454e-5ed6-08d817e546a8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 02:21:17.5213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DE4wce2YL9yCdXf8NRdvR139EV523qv59/60cgcFA/qx6j45JBrLzZOUFaxDQ2nnpApFnH2WlY8nec/kl2EhKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7022
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

mlx5e_xsk_first_unused_channel is a leftover from old versions of the
first XSK commit, and it was never used. Remove it.

Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c   | 13 -------------
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h   |  2 --
 2 files changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
index 7b17fcd0a56d7..331ca2b0f8a4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
@@ -215,16 +215,3 @@ int mlx5e_xsk_setup_umem(struct net_device *dev, struct xdp_umem *umem, u16 qid)
 	return umem ? mlx5e_xsk_enable_umem(priv, umem, ix) :
 		      mlx5e_xsk_disable_umem(priv, ix);
 }
-
-u16 mlx5e_xsk_first_unused_channel(struct mlx5e_params *params, struct mlx5e_xsk *xsk)
-{
-	u16 res = xsk->refcnt ? params->num_channels : 0;
-
-	while (res) {
-		if (mlx5e_xsk_get_umem(params, xsk, res - 1))
-			break;
-		--res;
-	}
-
-	return res;
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
index 25b4cbe58b540..bada949735867 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
@@ -26,6 +26,4 @@ int mlx5e_xsk_setup_umem(struct net_device *dev, struct xdp_umem *umem, u16 qid)
 
 int mlx5e_xsk_resize_reuseq(struct xdp_umem *umem, u32 nentries);
 
-u16 mlx5e_xsk_first_unused_channel(struct mlx5e_params *params, struct mlx5e_xsk *xsk);
-
 #endif /* __MLX5_EN_XSK_UMEM_H__ */
-- 
2.26.2

