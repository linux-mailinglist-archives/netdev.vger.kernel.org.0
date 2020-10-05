Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203D92832BD
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 11:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgJEJFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 05:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgJEJFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 05:05:43 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985DFC0613CE;
        Mon,  5 Oct 2020 02:05:43 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id az3so1984548pjb.4;
        Mon, 05 Oct 2020 02:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FeKTiv/QkrYt1MX3JAHgoWEVIukNsIw2zIykn9+ECKQ=;
        b=M2ChYg6Meiwrpyu2dTgNJoHM9l3CUf2ucjO+p2S8YKhuJ96lr86rDNwXSUrYRJ0TOV
         SF0s42qSKqexfUuPspJ88M0Rwsx038qzRuGI95fPMryyN6x61WpgIp1qrmQJtpgaFOip
         wLg3JdCSv+7dsk9l8doeHza3nzu47Z8uFcOZEQLq6NeeWg1e9N/nxFk9o+89jZahFm8D
         ZoNz0S6pbpp2YiippN6uLYZfh8VspyLjJdpGqpkYgeWs76KELWPuxiVMMOqw0tTBlFuY
         OEbDkdwXHm7OqaEcCsuMar4hisnxbSDG4f57En4TS5FVduAdEVGZYPJgk5IPlQc8n6dZ
         XKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FeKTiv/QkrYt1MX3JAHgoWEVIukNsIw2zIykn9+ECKQ=;
        b=EW+bkhLDGcd6DhLVeRz/5wUqWG36lMKHnZqLgUlqYnTlTQuWE+RyeTa/HghahG1fYt
         IxDqYpX66Zv/mVA/Nh1ezA7/Jyw2Da9rt2Zw/Subjiu2gs0qvuebeoYDGoOFU4feBSh9
         1i4m2xGUJdeXwTrvNpXcl9tttGvAF0y9W8gii9T0ETtAENhkzh3IAN0fxXhvOybLQCiw
         xDRQ6vbEwle8msNeisfRGjeFUDhkibY8YcoaWWZaUG6XaHwv/nVZovmy3iApIO89ZrEC
         ME+kHrOOabMMEa38xoK4t2Zqak/YqKND6OJNkXn0GwqRJoHM8xDRnGhDxr0zc/q1g6nt
         Lk9g==
X-Gm-Message-State: AOAM533mHq/0A0UJRnfEVo2NZBES2vQ5DcN4oehweOHO19S90fUlAS03
        um0OxOhsXU6GDmSGtCwFDR31wmm46Dwbeg==
X-Google-Smtp-Source: ABdhPJxMt22Kuv3Ibn/uW7/FbPvcIYTBWKZgue548vudqhRHF359e+3pYaDJoH+LY8ELGCA6wVx67g==
X-Received: by 2002:a17:90a:ff92:: with SMTP id hf18mr9474390pjb.171.1601888742779;
        Mon, 05 Oct 2020 02:05:42 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id u7sm2727014pfn.37.2020.10.05.02.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 02:05:42 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        hch@infradead.org
Subject: [PATCH bpf-next] xsk: remove internal DMA headers
Date:   Mon,  5 Oct 2020 11:05:25 +0200
Message-Id: <20201005090525.116689-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Christoph Hellwig correctly pointed out [1] that the AF_XDP core was
pointlessly including internal headers. Let us remove those includes.

[1] https://lore.kernel.org/bpf/20201005084341.GA3224@infradead.org/

Reported-by: Christoph Hellwig <hch@infradead.org>
Fixes: 1c1efc2af158 ("xsk: Create and free buffer pool independently from umem")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk_buff_pool.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index e63fadd000db..64c9e55d4d4e 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -3,9 +3,6 @@
 #include <net/xsk_buff_pool.h>
 #include <net/xdp_sock.h>
 #include <net/xdp_sock_drv.h>
-#include <linux/dma-direct.h>
-#include <linux/dma-noncoherent.h>
-#include <linux/swiotlb.h>
 
 #include "xsk_queue.h"
 #include "xdp_umem.h"

base-commit: 1028ae4069991e26d1522e957939fb61d2da1d12
-- 
2.25.1

