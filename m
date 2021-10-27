Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D1D43BF1F
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 03:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbhJ0Blg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 21:41:36 -0400
Received: from out0.migadu.com ([94.23.1.103]:48474 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232003AbhJ0Blg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 21:41:36 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1635298750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mRZIULQTVpfWrdp8Uq4dI5NvJfRTMnh/7wjuYGzhzms=;
        b=C1nH96Ez3/9CFNNNB5mqCJCzMnqYk/kdCDE5BB8Uil0iy3AfHT639oQlCSU9xad99Nfqbs
        sFCGVrT8+JcwPnLdrW+3wX75W+EkGSXJEkOnkhAaGUys1FHKw/WrmTel7TwsMYlmAdVhS6
        YvvjR7ULfPfaw4i6Ep1tqUImkykcZx8=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] xdp: Remove redundant warning
Date:   Wed, 27 Oct 2021 09:38:56 +0800
Message-Id: <20211027013856.1866-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a warning in xdp_rxq_info_unreg_mem_model() when reg_state isn't
equal to REG_STATE_REGISTERED, so the warning in xdp_rxq_info_unreg() is
redundant.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/xdp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index cc92ccb38432..5ddc29f29bad 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -143,8 +143,6 @@ void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq)
 	if (xdp_rxq->reg_state == REG_STATE_UNUSED)
 		return;
 
-	WARN(!(xdp_rxq->reg_state == REG_STATE_REGISTERED), "Driver BUG");
-
 	xdp_rxq_info_unreg_mem_model(xdp_rxq);
 
 	xdp_rxq->reg_state = REG_STATE_UNREGISTERED;
-- 
2.32.0

