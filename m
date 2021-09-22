Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A57D414300
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhIVH6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbhIVH6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:58:14 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7551EC061574;
        Wed, 22 Sep 2021 00:56:44 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id u15so4107306wru.6;
        Wed, 22 Sep 2021 00:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pqWW7JH7XrVMnPVs8pggenZXrCw2bQ7cPdXmHZ23P6M=;
        b=WZBgNCWathND4+pqerIViXsJHvoLCkaM4kIlbvROac4528d2j7SMaBu/PZcf5iNC8U
         hDBTJQ+6/UjO17uAM2q8ieVlOl2LFt4J43dwlBn2nIESwUoWTOTax2Dq5VIJLPkuJf3S
         IJT3owVJ1IzMaemRf6JaDpqK2KlbP+tU77FONdjL+LYKYSxJQjKuld6fzcgsn2e6pbQh
         u71TbDFreJHOxuoPF8D+EN6wM6zMpwzDJln/PXzvqRh+Rjgq0mpecZgO6u3U6RVMS252
         OrLOpxZhmGAshA0tQGlr4PkwPHn/28Btayk8bWNaAN39KcybdeYJvTHkXORrSzHV+egb
         5qwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pqWW7JH7XrVMnPVs8pggenZXrCw2bQ7cPdXmHZ23P6M=;
        b=sRb+Ql3vyOkJraVxGHC8C6f++8mPgkujCSEJsO/93Z0V5J6bvUzegmEmP6MCCQ48TW
         P81rNF5h7LgDUaG4fJvDbPzNaRNFgH1YxOCPqVAihMEn0ihesuO6vt7knH5CgJh4GjYg
         dC6SP+itY0WvV0METQ1OEER78KwYOvkse4VQGMHWYfBiLdL4vvbD9jDWkzpcQjZwg3PL
         l9MxBebKc0yOapBHC0pjtMbkqHw3xUHP/uN48N/qYtSKfcTYiVdxs4odESwKr5F9J8+D
         wiUqqWsJuyMIZzgtlTldVSdZRpicROpMdrhXU4e0BR8pTjnqhQxhu/TTfNuuyuuMUf77
         bNjw==
X-Gm-Message-State: AOAM531nRjEmhqs9HUtMgSLOXVPL0IePX91lGICKrPT7GGcrx7xuDEz9
        tm4X4lrJISa7+DY7NQ13aZE=
X-Google-Smtp-Source: ABdhPJyx+62BqVr+yKxLHAIYFRyXrlE2C22/3JIKG3Wf5j6vL6zEy+MkysKbkvskuLwbmGSIQbhPMQ==
X-Received: by 2002:a1c:3b09:: with SMTP id i9mr8742345wma.175.1632297403008;
        Wed, 22 Sep 2021 00:56:43 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id j7sm1673087wrr.27.2021.09.22.00.56.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:56:42 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH bpf-next 01/13] xsk: get rid of unused entry in struct xdp_buff_xsk
Date:   Wed, 22 Sep 2021 09:56:01 +0200
Message-Id: <20210922075613.12186-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210922075613.12186-1-magnus.karlsson@gmail.com>
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Get rid of the unused entry "unaligned" in struct xdp_buff_xsk.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xsk_buff_pool.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 7a9a23e7a604..bcb29a10307f 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -23,7 +23,6 @@ struct xdp_buff_xsk {
 	dma_addr_t dma;
 	dma_addr_t frame_dma;
 	struct xsk_buff_pool *pool;
-	bool unaligned;
 	u64 orig_addr;
 	struct list_head free_list_node;
 };
-- 
2.29.0

