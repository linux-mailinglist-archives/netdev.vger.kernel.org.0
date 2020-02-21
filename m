Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01EDD166EAE
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 06:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgBUFDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 00:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgBUFDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 00:03:16 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B9FC207FD;
        Fri, 21 Feb 2020 05:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582261395;
        bh=6povgtDICNy6rt00hMC2bV5KyUQnbLUeg8HWDdszTfI=;
        h=From:To:Cc:Subject:Date:From;
        b=QRGHOaP+xdYivjb7ij51c0Hdsk/qYt1ABqgomy4OkzWdQool0i7mOp5dPr0Bd/yV8
         ey/mqNNsx/jhGjgtkQT9WJPQniUU0dh5TY62DiTSK11HouQTBGZc2bfHlAdO3rCwAU
         HNzem0IQCrbu2hwe/1YptAVCdfJZLxBVOXlqbyU4=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] net: Remove unneeded export of a couple of xdp generic functions
Date:   Thu, 20 Feb 2020 22:03:13 -0700
Message-Id: <20200221050313.68171-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

generic_xdp_tx and xdp_do_generic_redirect are only used by builtin
code, so remove the EXPORT_SYMBOL_GPL for them.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/core/dev.c    | 1 -
 net/core/filter.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a6316b336128..0aaacfbe07ab 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4649,7 +4649,6 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
 		kfree_skb(skb);
 	}
 }
-EXPORT_SYMBOL_GPL(generic_xdp_tx);
 
 static DEFINE_STATIC_KEY_FALSE(generic_xdp_needed_key);
 
diff --git a/net/core/filter.c b/net/core/filter.c
index c180871e606d..f17631c80f8b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3626,7 +3626,6 @@ int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 	_trace_xdp_redirect_err(dev, xdp_prog, index, err);
 	return err;
 }
-EXPORT_SYMBOL_GPL(xdp_do_generic_redirect);
 
 BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
 {
-- 
2.17.1

