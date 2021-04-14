Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83AB835EAEC
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 04:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344516AbhDNCfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 22:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhDNCfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 22:35:40 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C0AC061574;
        Tue, 13 Apr 2021 19:35:19 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id a85so12295180pfa.0;
        Tue, 13 Apr 2021 19:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=onJ7uZ3p8s/gKYB2XhKDCCe0q8Rs1VMepIA3BYKB0DU=;
        b=Lf76OYaMA5bhIGPnuA0rAWAsgXyge80EA9BgGy8o+1VXvM8FP6WhN/cHP1e4LZYYBO
         4yF/I0exQMYmvrduW+IXfAbg6/AxUNpT0tcN7gA72Zq2Ba8yfOg87iQN8yHZhLD8hmeB
         qDQfe+ob4c+00ZXCVa7s1Fzu7ZGKXyBOlAh7ldFk/1HpxdXb/0OXdKtEWjE4JBjZhAXx
         7rZ6lorLr6QgTj7yBRtpHDscYhJmS6ISrd9BJM52ZZxMoELQAgC17MW4W9mdXjcSqpox
         Jx08xklBNBVlNS0dlTrGEsEkXPw+Qy+NMblWfiIZ63Ip3cbcdrj+xpwqq2kCHQ4avnzp
         RfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=onJ7uZ3p8s/gKYB2XhKDCCe0q8Rs1VMepIA3BYKB0DU=;
        b=osckRrF3BUrmPfKXR4cZC5S2IldAf6Inkc22i7+7/D97HWYdXzGkZagl5uX/UMnMqL
         3n2B2LxXIlTLgtqtl1wuXGSOO17kTK3O9gseyrWXDeIoRDjlB4v4X7c6B1Qgx/G1FY7h
         Qx/OglzGQjM9H5qsqfKqZg4bn1XJDwEfsyB2pgFBRmJota3VrYkJEqvzqyPl6hJMUH0K
         nysE4oR1RYUVP5X+0/JufNJ2ULpOlHDwW+phRW+FeP7KvLWZWh03888E26eByzYSkhlZ
         lKRHT26EbbCOqTFx/MznPY7/P3WKaQXFGCGSvQcMbuuNbHQSDmw0b1yo5uC5dkYxtZCB
         VsDQ==
X-Gm-Message-State: AOAM531ZdHdadgTKseQO+YIpqZcWdGd9rgUQY2hUU2uV4ysrWv+8X34Z
        W9PGqeeYjiIHJR5/QaAMiaI=
X-Google-Smtp-Source: ABdhPJyp6z+TiBTp0H57GdxdQPdnbE3dIbUCkYCnADULGHr44ZkS+S0tCL9NDDiTHv9WgWkI9IQ74w==
X-Received: by 2002:a62:7907:0:b029:23e:9010:3844 with SMTP id u7-20020a6279070000b029023e90103844mr32223691pfc.58.1618367718317;
        Tue, 13 Apr 2021 19:35:18 -0700 (PDT)
Received: from localhost.localdomain ([103.112.79.202])
        by smtp.gmail.com with ESMTPSA id r1sm3403988pjo.26.2021.04.13.19.35.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Apr 2021 19:35:17 -0700 (PDT)
From:   kerneljasonxing@gmail.com
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Subject: [PATCH net v3] i40e: fix the panic when running bpf in xdpdrv mode
Date:   Wed, 14 Apr 2021 10:34:28 +0800
Message-Id: <20210414023428.10121-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20210413025011.1251-1-kerneljasonxing@gmail.com>
References: <20210413025011.1251-1-kerneljasonxing@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <xingwanli@kuaishou.com>

Fix this panic by adding more rules to calculate the value of @rss_size_max
which could be used in allocating the queues when bpf is loaded, which,
however, could cause the failure and then trigger the NULL pointer of
vsi->rx_rings. Prio to this fix, the machine doesn't care about how many
cpus are online and then allocates 256 queues on the machine with 32 cpus
online actually.

Once the load of bpf begins, the log will go like this "failed to get
tracking for 256 queues for VSI 0 err -12" and this "setup of MAIN VSI
failed".

Thus, I attach the key information of the crash-log here.

BUG: unable to handle kernel NULL pointer dereference at
0000000000000000
RIP: 0010:i40e_xdp+0xdd/0x1b0 [i40e]
Call Trace:
[2160294.717292]  ? i40e_reconfig_rss_queues+0x170/0x170 [i40e]
[2160294.717666]  dev_xdp_install+0x4f/0x70
[2160294.718036]  dev_change_xdp_fd+0x11f/0x230
[2160294.718380]  ? dev_disable_lro+0xe0/0xe0
[2160294.718705]  do_setlink+0xac7/0xe70
[2160294.719035]  ? __nla_parse+0xed/0x120
[2160294.719365]  rtnl_newlink+0x73b/0x860

Fixes: 41c445ff0f48 ("i40e: main driver core")
Co-developed-by: Shujin Li <lishujin@kuaishou.com>
Signed-off-by: Shujin Li <lishujin@kuaishou.com>
Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 521ea9d..4e9a247 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11867,6 +11867,7 @@ static int i40e_sw_init(struct i40e_pf *pf)
 {
 	int err = 0;
 	int size;
+	u16 pow;
 
 	/* Set default capability flags */
 	pf->flags = I40E_FLAG_RX_CSUM_ENABLED |
@@ -11885,6 +11886,11 @@ static int i40e_sw_init(struct i40e_pf *pf)
 	pf->rss_table_size = pf->hw.func_caps.rss_table_size;
 	pf->rss_size_max = min_t(int, pf->rss_size_max,
 				 pf->hw.func_caps.num_tx_qp);
+
+	/* find the next higher power-of-2 of num cpus */
+	pow = roundup_pow_of_two(num_online_cpus());
+	pf->rss_size_max = min_t(int, pf->rss_size_max, pow);
+
 	if (pf->hw.func_caps.rss) {
 		pf->flags |= I40E_FLAG_RSS_ENABLED;
 		pf->alloc_rss_size = min_t(int, pf->rss_size_max,
-- 
1.8.3.1

