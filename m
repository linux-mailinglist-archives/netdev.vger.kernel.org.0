Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27740CD3B4
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 18:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfJFQwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 12:52:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46546 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfJFQwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 12:52:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id o18so12421083wrv.13
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 09:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wwXdTKTajbJ7TPYKouzpxzEyxfxSC/Vyi6g2qa/sIn4=;
        b=c39iA/GFsfosiWBQ/mHiwpOoLIJ2P0l6VMMAoajm6fCMMS47vFNB/U1l1uDC3JGXYp
         Fmmt/YQ2tR1mTWJyNphgnYdLiAct4MlXSKxZQtlutSiFgbhXOZcIUprRo5UKpYbNhrwe
         kwi4nG9AbhP7LQlxbsHuzDMmMVQGfJegPPc5PSarra7n7MnTx15NVWpItrQWEtdaXIUG
         XuxcPnUeLbJkQ5hiMDNLFgBWGq+GH0X5iovqxRbbudWekug3JvGW4I76XTHeiI9cBd3V
         QcWk9fq8ibhvNleV2sabylxdXLU2s7Ov71DHNnMUIy7bV/r/Jo1HN3l2LRh3/y15Nos/
         Hn8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wwXdTKTajbJ7TPYKouzpxzEyxfxSC/Vyi6g2qa/sIn4=;
        b=RjOYSZtFd6VUaneiQnZAvh6ssPnp2P1IB91rPQwZuBcW26wqocr2QGHZhi/yjLuGMq
         ta2+GNjvyA4wYBuPMIrVIAJyRY+i4IIsOD5y96dz8gfKKwU68eIYQnmICUzicX7TZuFt
         eTBtiakKe+UiHJ1ZqfXhrfRyoAaG9aRcaB/4TAMe2vt+vx6xckc7tpd/uImVDGxNi02o
         O0fK9keqn3cZo3jADbbJF6fWtJ1AGWPzs9Fo1hWPmYpmIXWktqWj2qLcpRDgncESUZV2
         6T34M5g5lLFUOGJepDL1Wk3eWP5LLW0I1dR1NYy6T7SlGJBQsXAmFnovUQwPdIlSZIx2
         J17A==
X-Gm-Message-State: APjAAAWN0dzj3H6nYHRm4YkXUzFvbAMN93WAlZC0nXYY1wuaXU4iwF13
        j0Abh4O62ETqF6F2R+hZieezMVGj
X-Google-Smtp-Source: APXvYqxT+cO+MXO9W/JcWyHbNjJm1B3SSeyU+kWZzZ+D8DTJkuyhpOr+AbhkDkop5ULY1yj+Rhr7MA==
X-Received: by 2002:a5d:660c:: with SMTP id n12mr20069439wru.286.1570380767726;
        Sun, 06 Oct 2019 09:52:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:64e8:8137:5430:1a37? (p200300EA8F26640064E8813754301A37.dip0.t-ipconnect.de. [2003:ea:8f26:6400:64e8:8137:5430:1a37])
        by smtp.googlemail.com with ESMTPSA id y19sm29621745wmi.13.2019.10.06.09.52.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 09:52:47 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: core: use helper skb_ensure_writable in more
 places
To:     David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <26c7f285-1923-5f09-6ea5-24fd8a5c78b6@gmail.com>
Date:   Sun, 6 Oct 2019 18:52:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use helper skb_ensure_writable in two more places to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/core/dev.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 944de67ee..7d05e042c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3165,12 +3165,9 @@ int skb_checksum_help(struct sk_buff *skb)
 	offset += skb->csum_offset;
 	BUG_ON(offset + sizeof(__sum16) > skb_headlen(skb));
 
-	if (skb_cloned(skb) &&
-	    !skb_clone_writable(skb, offset + sizeof(__sum16))) {
-		ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
-		if (ret)
-			goto out;
-	}
+	ret = skb_ensure_writable(skb, offset + sizeof(__sum16));
+	if (ret)
+		goto out;
 
 	*(__sum16 *)(skb->data + offset) = csum_fold(csum) ?: CSUM_MANGLED_0;
 out_set_summed:
@@ -3205,12 +3202,11 @@ int skb_crc32c_csum_help(struct sk_buff *skb)
 		ret = -EINVAL;
 		goto out;
 	}
-	if (skb_cloned(skb) &&
-	    !skb_clone_writable(skb, offset + sizeof(__le32))) {
-		ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
-		if (ret)
-			goto out;
-	}
+
+	ret = skb_ensure_writable(skb, offset + sizeof(__le32));
+	if (ret)
+		goto out;
+
 	crc32c_csum = cpu_to_le32(~__skb_checksum(skb, start,
 						  skb->len - start, ~(__u32)0,
 						  crc32c_csum_stub));
-- 
2.23.0

