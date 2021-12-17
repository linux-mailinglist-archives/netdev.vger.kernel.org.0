Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB00B478EA7
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237663AbhLQO51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236556AbhLQO5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 09:57:24 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B02C061574;
        Fri, 17 Dec 2021 06:57:24 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id t18so4524406wrg.11;
        Fri, 17 Dec 2021 06:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SOW6uRhAhu6E0fNc47WgprJkrmQIdI9O2ko379Zcecs=;
        b=YbDvuiGpRGqOccMRDZhC2ahWCAQWZD5+w1ak+xbSApdf2yFVgLaBC8GXpwUvnA0DyO
         bztHPo9D6MG0GAbBsiSXS8SyqhdVzsnU62l2At5j0ma5czra0RTRtTFspiLsKG9i5BAd
         YXKXeg2dCPWUSGMxlrnm2zg7doD+Z3QhkOp5L3PeGJL0QGPBHDAG5Bq7skcCEjint4O0
         6V8I7b5/y8ph5e6dRSAoGhT4vIN3xIaqjewtQyPDxZZYiwVLv1rkCleDpf+R77Hh/F7L
         iipKmJL62ZpArTZxLtud08sg8nARBfmkWe9t8vCfLCF7+mpfFnqPZJOU/KC6TAwMOZzW
         3IOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SOW6uRhAhu6E0fNc47WgprJkrmQIdI9O2ko379Zcecs=;
        b=L9g52rNJXmBpcmiK58VCN1QVKuMdygystxK+zEqdIfr98Ml79SnuyzhU3r630uCQBM
         6/ZLka6syhgwQ8ZL302IHbYeocnmISak5aWzEEFVLJbZ0mKJg0brm9wmaLOp+qxGVEEn
         etgBZYvyI2eo6hVqLlWSv+lAagJcTUyV44Q93hELmxEPXh+0JKwjBpFC94Z8eTn3icuN
         Gw0ypj4c99lCRcJs+8B7uL+MJv2koj3WF335tncyIesOipSn4MZ3mZCRYLJOt/0e4lsj
         eUcgNx/3Q9r5Q9CNPUICf4Q/dMzjjFBeJwp5KWe3gq3vrUWdF72EeqnrhucwrD6mIlM1
         TEvA==
X-Gm-Message-State: AOAM532PmYVIlQb10C6MSNekYxKWL1wcsXxfdjDSN0N/KbKa/tZunfxG
        F3PzCz1+n0VdnRJOGnU7bu4QMYjWjco83scO
X-Google-Smtp-Source: ABdhPJx5ssBPAw9dcwyDH7MsltTJMrlyJtRmvdfo0/FTERi4ucA9TW0zZOQSILrFamA62j+gtSLBow==
X-Received: by 2002:adf:82f6:: with SMTP id 109mr357350wrc.169.1639753043036;
        Fri, 17 Dec 2021 06:57:23 -0800 (PST)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id d2sm7268775wmb.31.2021.12.17.06.57.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Dec 2021 06:57:22 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf] Revert "xsk: Do not sleep in poll() when need_wakeup set"
Date:   Fri, 17 Dec 2021 15:56:46 +0100
Message-Id: <20211217145646.26449-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

This reverts commit bd0687c18e635b63233dc87f38058cd728802ab4.

This patch causes a Tx only workload to go to sleep even when it does
not have to, leading to misserable performance in skb mode. It fixed
one rare problem but created a much worse one, so this need to be
reverted while I try to craft a proper solution to the original
problem.

Fixes: bd0687c18e63 ("xsk: Do not sleep in poll() when need_wakeup set")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 7a466ea962c5..f16074eb53c7 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -677,6 +677,8 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct xsk_buff_pool *pool;
 
+	sock_poll_wait(file, sock, wait);
+
 	if (unlikely(!xsk_is_bound(xs)))
 		return mask;
 
@@ -688,8 +690,6 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 		else
 			/* Poll needs to drive Tx also in copy mode */
 			__xsk_sendmsg(sk);
-	} else {
-		sock_poll_wait(file, sock, wait);
 	}
 
 	if (xs->rx && !xskq_prod_is_empty(xs->rx))

base-commit: 0c3e2474605581375d808bb3b9ce0927ed3eef70
-- 
2.34.1

