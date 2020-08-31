Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC0D257B61
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 16:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgHaOiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 10:38:04 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:59495 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726948AbgHaOiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 10:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1598884676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=LwWG8yVSld32sVSBN53trOEXo7Kzcc46dqFc2N17+r4=;
        b=NyH3ZzQdr54u++TlS79UX9U0Thmy3MdlgjpZxDhAEQgl9nqmVb3MjFVCxzg6GgAvgT3bQy
        lf1Ecuz4qBq5LOMQKOZdwom6Fdj3jANoyNRfdGoYzN2vAkhE2IIU239+4xs++dozMhJhEp
        8MFDVMKTyNjrso1iZm1yHtDVIT/nw/Y=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2106.outbound.protection.outlook.com [104.47.18.106])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-16-feHQX6wdP6-F8c6bQTnydw-1; Mon, 31 Aug 2020 16:37:28 +0200
X-MC-Unique: feHQX6wdP6-F8c6bQTnydw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJn99N+o/+mxEN3IVk+PHqYZPoX4eGr6r2eYCUtShuDtwIhusbwsu3xjcnNTM9H6yhxUPGVhKZ4S8cI1NJ3KgHED7siHuepHj4+eSgcGYWcAoAnR3osnddSgG27SvnfhxyxdYHDKbz4kEo4DT/xowY3LG1CpVdakUI/z0Hh0NhQ62c6YDaMdF/zODJzNZ3VzAgzIj+DAWAkiMURZb3k4MslJMk3lN4JMQa7Q88atw5iuqQDqsu2QgpAx3GJZ8AvTdc9uPnnVnEsa08VNtzQ1botk+DfYtFWTBBRXUpzl5V7V1qxCzeV3O7DYMGa51alz6tw0oR8ySjq5JCsCpV+3ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LwWG8yVSld32sVSBN53trOEXo7Kzcc46dqFc2N17+r4=;
 b=cEIxr/g1qqW+ewcOauroTf5ehmHnEXNjNxu4w/MRwMP1V4L0bPdTZblNRGJc2OJSVuaxrYvCzWSGSn/Yy51cKcVvr0Qy1jogd+CV5G1ArzceRDuBXbUSqjn34JwY+JRzT27JVz4Vn24iW91urI4TiDPByZ33tU6ftsWjoUVWewAn9YMmE+qUyZ4w14R63QA3D/DnVoEBEG/6tYTWY4t0vm7MCg9vxlO2CzXZF6MSnTYMsj2ydHzs0x2FVScV0dFD8UyfxjepYxDJ93GeYvpo2dFNBJGtXp3DqwySvvmGgAvezSGn1w7Zar7V1WWlnW9lLvkq7PVPxxox1XgYTnNTeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com (2603:10a6:10:20::21)
 by DB7PR04MB4139.eurprd04.prod.outlook.com (2603:10a6:5:26::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Mon, 31 Aug
 2020 14:37:27 +0000
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::78ee:1d1e:bc6b:d970]) by DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::78ee:1d1e:bc6b:d970%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 14:37:27 +0000
Date:   Mon, 31 Aug 2020 22:37:09 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: ethernet: mlx4: Fix memory allocation in
 mlx4_buddy_init()
Message-ID: <20200831143709.GA12996@syu-laptop>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-ClientProxiedBy: HK2PR02CA0173.apcprd02.prod.outlook.com
 (2603:1096:201:1f::33) To DB7PR04MB5177.eurprd04.prod.outlook.com
 (2603:10a6:10:20::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from syu-laptop (27.242.32.233) by HK2PR02CA0173.apcprd02.prod.outlook.com (2603:1096:201:1f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 14:37:23 +0000
X-Originating-IP: [27.242.32.233]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96a6b613-c12b-4e86-aad1-08d84dbb61f9
X-MS-TrafficTypeDiagnostic: DB7PR04MB4139:
X-Microsoft-Antispam-PRVS: <DB7PR04MB4139E7C5B383AAA72ECD4D09BF510@DB7PR04MB4139.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lmGsbyXLvgcIlJiEvka8CLJQhdY4pIULkQm7ebwtXMl9jM8K73eMT8usla5iusRdcHzBvFErIq8F1gYaeKYiIv/Yx79oYvpaJdDZtXjlMnCqKhCdz2ZE2YCcGM0p94TSWtlmF8h+nJgJFOD/5UF8OXg1BGBQ9LyHTIkF9htTpkhmtx+WurJMWBGKjxkM8dFm+GN3vumJxC1WJlYQt0zL+M7CP2TaH4fLu3A59L2UPeCojj7QtZ5YAlh+6P7DsrXOBn1H8Rbmy5pvra/S/4GOIge+rMc/u4vTIOimjZojMeMCTXeI0CJewdJbSB4mboTiOcuFaMJXeGhJeYAh3d4XHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5177.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(136003)(39860400002)(376002)(1076003)(9686003)(110136005)(6666004)(956004)(52116002)(55016002)(4326008)(5660300002)(6496006)(33656002)(186003)(66946007)(83380400001)(8676002)(478600001)(26005)(33716001)(16526019)(66556008)(66476007)(86362001)(8936002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +wFj+oOtQQTSnkO6a1CI/QIzqu4pQ7UwW61wRio//jRFfSOZbJWSHwhUU1SaVidkSu47RX6FNJUb4RZSDEr+jLzUqlEXj3Rsj3QogMtYHho0X4XG+5a515jLVl1dTyPcoNeJ1bWTtggi0UxD4ruoDfWWAQcrJ7DflpbdPFB3IAc5lqC6YPIqcicSWGPpdI8ymtbSL4ML2Ir/YQDjEM7s2YepHIn0yjqU1BFDVB1zFr70ZQ09gOJ+IW6PfDpRErN2qjcQsWw9MAk7oXYVUKlDqecv5/dV8AcVK/Df5U5NuuqPxc3MBMSLp1627Q5na8ONzTHXvIGleeZLS3hRl+Rze2kwNAIPldikwaQA4nFfKBFsW+dB8EmqaAa2sVqmlK0s5a/F6/T6s8A2LI7nY3cPO+BmmZPn2tmkhXhO0OBYU4iiFOh287HB9/eSSFYcdYj1gGT2vrRvQt8v1iIVc4+sPox7mdkQMyjqPnoOwy4ab6hmYiDA2U4KKpega3mBTj1xRYL8aOAHhiApuDXZhPs/ZmKKGLOpbBt//6kLewzb/Y+6YqRNYPDhJWu1q0PuyuCcnsKKxqWWVX/NYFXur/VjO7/NYVljiJoPQsZJa4GVUVlrEvyoxWFgfRBk2lv6kzH3eaWDLEfCMecnlxIs6EAPUA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96a6b613-c12b-4e86-aad1-08d84dbb61f9
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5177.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 14:37:27.2039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aoa2OjiDj5HPVnrUeVDK0rfw8/3RD5H7j22bRCcKXLMOasgX9fwJE4vKxhf/FnOcIl2XOq8JXbxlwYM7yKPc3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On machines with much memory (> 2 TByte) and log_mtts_per_seg == 0, a
max_order of 31 will be passed to mlx_buddy_init(), which results in
s = BITS_TO_LONGS(1 << 31) becoming a negative value, leading to
kvmalloc_array() failure when it is converted to size_t.

  mlx4_core 0000:b1:00.0: Failed to initialize memory region table, aborting
  mlx4_core: probe of 0000:b1:00.0 failed with error -12

Fix this issue by changing the left shifting operand from a signed literal to
an unsigned one.

Fixes: 225c7b1feef1 ("IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters")
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
---
 drivers/net/ethernet/mellanox/mlx4/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mr.c b/drivers/net/ethernet/mellanox/mlx4/mr.c
index d2986f1f2db0..d7444782bfdd 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
@@ -114,7 +114,7 @@ static int mlx4_buddy_init(struct mlx4_buddy *buddy, int max_order)
 		goto err_out;
 
 	for (i = 0; i <= buddy->max_order; ++i) {
-		s = BITS_TO_LONGS(1 << (buddy->max_order - i));
+		s = BITS_TO_LONGS(1UL << (buddy->max_order - i));
 		buddy->bits[i] = kvmalloc_array(s, sizeof(long), GFP_KERNEL | __GFP_ZERO);
 		if (!buddy->bits[i])
 			goto err_out_free;
-- 
2.28.0

