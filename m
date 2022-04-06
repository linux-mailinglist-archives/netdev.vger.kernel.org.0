Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5504F6D53
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbiDFVue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbiDFVtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:49:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4C02AE6;
        Wed,  6 Apr 2022 14:38:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A68B61BA2;
        Wed,  6 Apr 2022 21:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA37C385A5;
        Wed,  6 Apr 2022 21:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649281079;
        bh=A0fW3syI/3Or0fXGJCHpbOxcC3mWosW/4h17ME4o2Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8zTYeiU+sYoQrmOOlzp8mbxsrFjNGCWUiWe59vTNc/4rCC8bctgHQnXZcdf20iSP
         Ry8P63L8FZcYs/lUGGRY39S+zNI/DmcCtToumgR/Kq3PTl1X6+s6lsB/G6hXL1rghS
         9TsAUNRmYWxgb0rY3v6+Od87VEd/ae9W9SCae8F1oFejA6V+FIhs97O6ksqxaP+jIV
         taFGoVPLWJcCsODHHXSKpVyV6bdYnf3GE/ylYZRSQWkB/hamlt6hwSoiQAhtDHtL1m
         0iS4eFO8jgpEGGPyF8daaf7PFjI27A7BUvri4GtsLw9nMQxNyglVNh5ZiMGrZicwN+
         7gwjoloqd8stg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, hawk@kernel.org,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net-next 1/3] net: hyperv: remove use of bpf_op_t
Date:   Wed,  6 Apr 2022 14:37:52 -0700
Message-Id: <20220406213754.731066-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220406213754.731066-1-kuba@kernel.org>
References: <20220406213754.731066-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following patch will hide that typedef. There seems to be
no strong reason for hyperv to use it, so let's not.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: kys@microsoft.com
CC: haiyangz@microsoft.com
CC: sthemmin@microsoft.com
CC: wei.liu@kernel.org
CC: decui@microsoft.com
CC: pabeni@redhat.com
CC: ast@kernel.org
CC: daniel@iogearbox.net
CC: andrii@kernel.org
CC: kafai@fb.com
CC: songliubraving@fb.com
CC: yhs@fb.com
CC: john.fastabend@gmail.com
CC: kpsingh@kernel.org
CC: hawk@kernel.org
CC: linux-hyperv@vger.kernel.org
CC: bpf@vger.kernel.org
---
 drivers/net/hyperv/netvsc_bpf.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
index 7856905414eb..232c4a0efd7b 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -137,7 +137,6 @@ int netvsc_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 int netvsc_vf_setxdp(struct net_device *vf_netdev, struct bpf_prog *prog)
 {
 	struct netdev_bpf xdp;
-	bpf_op_t ndo_bpf;
 	int ret;
 
 	ASSERT_RTNL();
@@ -145,8 +144,7 @@ int netvsc_vf_setxdp(struct net_device *vf_netdev, struct bpf_prog *prog)
 	if (!vf_netdev)
 		return 0;
 
-	ndo_bpf = vf_netdev->netdev_ops->ndo_bpf;
-	if (!ndo_bpf)
+	if (!vf_netdev->netdev_ops->ndo_bpf)
 		return 0;
 
 	memset(&xdp, 0, sizeof(xdp));
@@ -157,7 +155,7 @@ int netvsc_vf_setxdp(struct net_device *vf_netdev, struct bpf_prog *prog)
 	xdp.command = XDP_SETUP_PROG;
 	xdp.prog = prog;
 
-	ret = ndo_bpf(vf_netdev, &xdp);
+	ret = vf_netdev->netdev_ops->ndo_bpf(vf_netdev, &xdp);
 
 	if (ret && prog)
 		bpf_prog_put(prog);
-- 
2.34.1

