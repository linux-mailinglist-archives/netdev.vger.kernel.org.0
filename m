Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9E329D590
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbgJ1WFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729966AbgJ1WFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:05:12 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EB2C0613D1;
        Wed, 28 Oct 2020 15:05:12 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id w25so409733vsk.9;
        Wed, 28 Oct 2020 15:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sBa77MmCFN0T1+VtUx1HDnNMT2/Xv5NhXqq896ClIPA=;
        b=ThThPoDIPRt59MZkfI1qQFRnAS2OlQaGLzpGPN2cxTSQfDtCdz08ENqwNG9U8jzOSq
         s34Q276RHnCcq8eK/nTv0czP0MtEL51wsFyO+l0/EF/aZx+dKou4D7B6eVgK94JVOkJy
         gNfNJgZzXGP//V7CiqZ3l8ybUm24uPVJ0zBOsk3MEzh+BQ/TucW/kMC61IEEHLyMgwnz
         6TaxNwP8l906lqpO77tS0TEDJFzAltKegGSigo6TgM+iVrTnY7ITYI4zxmNp2cKEmth2
         8o4dgHKzSDhquPjaHN+aQt5e/yANa4V1Nlnmnor+iDQiKXFMgUOhuOG8XxBJGAdtrER9
         PYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sBa77MmCFN0T1+VtUx1HDnNMT2/Xv5NhXqq896ClIPA=;
        b=CpanmAL7sESG0s+5JOewhFV3rblxzAaHakFJx7sD3yAuJQj50LYmJsEr50r8ID3Kor
         +wMVb3xQRm5P4ST60RnF83fnRwVaZ/TTy00x8QP6mGCEdSZytCCyxSROha3uiOwf4FP8
         EyZrLbidrcpQNdR+TWnarUpjvSt0aHTIixD6n2d29jBDJY3x40Ks8ZTM+s3WBq6xQHy9
         2oUjMJMM+enQan+OXcYUe/4ag2w7wVU4MlHjQsvyJMrkbXRq4eFCs2avtixKEFFDmqud
         83ywZiI9f0j1MWAwWY3PSW9DqEa3CDGK689U2PJTnxkATzaxYB5r2IufkbhT3UPwTh1Y
         DTsw==
X-Gm-Message-State: AOAM530JWLoBBhpQBvGrbdA9cMJVxWaWL/vfmGl7Qegzoanmt5VeeZuK
        XTiHrxZOTNkFqI252gaa5k7iL5rjk/Bho8E7
X-Google-Smtp-Source: ABdhPJx1sVLTojg+U9YZMBvRLhAg0GBPcu5nq1fPysti/X+d+Gmy//kTyoSjwtScwRHBrv8BGUyEYA==
X-Received: by 2002:a62:ea0c:0:b029:164:3789:547b with SMTP id t12-20020a62ea0c0000b02901643789547bmr7074341pfh.27.1603892133273;
        Wed, 28 Oct 2020 06:35:33 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q14sm5935393pjp.43.2020.10.28.06.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:35:32 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next 5/9] xsk: add busy-poll support for {recv,send}msg()
Date:   Wed, 28 Oct 2020 14:34:33 +0100
Message-Id: <20201028133437.212503-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201028133437.212503-1-bjorn.topel@gmail.com>
References: <20201028133437.212503-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Wire-up XDP socket busy-poll support for recvmsg() and sendmsg().

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 2e5b9f27c7a3..da649b4f377c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -23,6 +23,7 @@
 #include <linux/netdevice.h>
 #include <linux/rculist.h>
 #include <net/xdp_sock_drv.h>
+#include <net/busy_poll.h>
 #include <net/xdp.h>
 
 #include "xsk_queue.h"
@@ -472,6 +473,9 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 
+	if (sk_can_busy_loop(sk))
+		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
+
 	pool = xs->pool;
 	if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
 		return __xsk_sendmsg(sk);
@@ -493,6 +497,9 @@ static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int fl
 	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 
+	if (sk_can_busy_loop(sk))
+		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
+
 	if (xs->pool->cached_need_wakeup & XDP_WAKEUP_RX && xs->zc)
 		return xsk_wakeup(xs, XDP_WAKEUP_RX);
 	return 0;
-- 
2.27.0

