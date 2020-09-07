Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A7125FCB5
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 17:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbgIGPLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 11:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730069AbgIGPCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 11:02:43 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2754C061574;
        Mon,  7 Sep 2020 08:02:39 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id m8so2859678pgi.3;
        Mon, 07 Sep 2020 08:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oCwcXoLsWMukL1+vXt1yI38gQtqXVGiihrBEQpJvTYo=;
        b=Jtd/zKbsueQrBTL7VJ5Slx40lKB2sw3dzum3wsYwe8BUGi4ZRFsOTM/4WGNeZEu5qE
         0s2kLBj/P6fuhzmqQ928pebpR1fUVFTqSdf2Hr/IJIGqVee1MBu3tx1w+p5rtMlH0cD3
         1OUJfHofzV9MBSWdR22VgdLFiQJk1YxoouJ2b9L1iunUB7TlTOYILIbfQ7+YRMuSYHn1
         XZWJQ2Oi7mNgfElOyCXmDuXAw5ErNN3Yx2Z84eE8AUMWnD6XWENsQWHWC8Cn5kSATaSe
         G3zOkE/GjyNRSQH3Gcl0ie2Y54csLZwH9wBh/0uEWuo45b1te7MdjctT8Ih24p44/fdC
         07Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oCwcXoLsWMukL1+vXt1yI38gQtqXVGiihrBEQpJvTYo=;
        b=pUWMwtwDpQ40THk/D5rnQGWu6H7NWr7BNV/tQXxV1L/zMMesVzmYDUmRHP84tV2pnk
         JDMTe74Fgq2+0EzscpsohsrjZZcjdHlgdZbYOEwFzzKp5IdD1goNEkKsoE3sYzYBmwBB
         AuYg0ezJNUajgUz30haVeFZvk6FVtBNONiLwLm5S0fty01b4A8LTPXkZtBtlAYmUV4vz
         uzLGaZJT7r1C/cuaozMjq6igaaGNNM3tQacqZnJFgpGraIcMa1/83AWif7CV67ayHIJP
         UDmqnfdD0C2/7Qsh7GxtUDoHkIqSpwf3ibaeGJBhn9Csy/WgmUNpFRz4GwKEdJj4BOeS
         +MAA==
X-Gm-Message-State: AOAM5315l7joYlUcZO8H9VeoETbNLpNuvwivaxhtkuaAhgU0DoaEfV1R
        RwzE8DeSbG1hnKRLSqPP5eo=
X-Google-Smtp-Source: ABdhPJzlb0YD6IjyVjw81EJMj1W/ABvKa4l/z7cI+rhquS1hPLeA60joniP+Kj27CgcmXo4K4UtJrQ==
X-Received: by 2002:a62:648c:: with SMTP id y134mr21292351pfb.114.1599490959561;
        Mon, 07 Sep 2020 08:02:39 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id g129sm15436022pfb.33.2020.09.07.08.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 08:02:38 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 1/4] xsk: add XSK_NAPI_WEIGHT define
Date:   Mon,  7 Sep 2020 17:02:14 +0200
Message-Id: <20200907150217.30888-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907150217.30888-1-bjorn.topel@gmail.com>
References: <20200907150217.30888-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The NAPI budget (NAPI_POLL_WEIGHT), meaning the number of received
packets that are allowed to be processed for each NAPI invocation,
takes into consideration that each received packet is aimed for the
kernel networking stack.

That is not the case for the AF_XDP receive path, where the cost of
each packet is significantly less. Therefore, this commit adds a new
NAPI budget, which is the NAPI_POLL_WEIGHT scaled by 4. Typically that
would be 256 in most configuration. It is encouraged that AF_XDP
zero-copy capable drivers use the XSK_NAPI_WEIGHT, when zero-copy is
enabled.

Processing 256 packets targeted for AF_XDP is still less work than 64
(NAPI_POLL_WEIGHT) packets going to the kernel networking stack.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock_drv.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 5b1ee8a9976d..4fc8e931d56f 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -7,8 +7,11 @@
 #define _LINUX_XDP_SOCK_DRV_H
 
 #include <net/xdp_sock.h>
+#include <linux/netdevice.h>
 #include <net/xsk_buff_pool.h>
 
+#define XSK_NAPI_WEIGHT (NAPI_POLL_WEIGHT << 2)
+
 #ifdef CONFIG_XDP_SOCKETS
 
 void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries);
-- 
2.25.1

