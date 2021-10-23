Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA38043829E
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 11:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhJWJ2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 05:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhJWJ2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 05:28:49 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F156C061764
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 02:26:30 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r4so2360917edi.5
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 02:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pnvj9w+N6cYaQeza77luUvf5BBAXfB2qtISkL7r812s=;
        b=NTBl8jR4/NH8W+UY1qeSs+KzSQ6KEL8rWF4tMeVfcw67KqMlvEilk8B6auBIHnHnDr
         Lu/sy0BvJpdKvoJ98734c/qwOXoJ/cktECN8jtQQQsTyPJ1Nq3Qk+u/uzR4nOT9l+lZ6
         oSBkiIs3vrXhqksgSLagvqLzVeyNlyGRc8ZZ9z89V8KNqpu0ocKGh8LXvGcTMUROeeGo
         iLO7ishpRvncSZUFFHGRerkS+L3VUTHGfEDUiAKLLsEmCHH1MP/pEi/qxFQQIwLczOfV
         B2iPFAEbpFQu1cOfTtw2K/TkbHmoyCItFWyMahxfHMKzzZ4LbsACfNO5ZVtiJnIoB4VC
         ERKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pnvj9w+N6cYaQeza77luUvf5BBAXfB2qtISkL7r812s=;
        b=LryvnjLGSCFxuFqWrbwLVHGnFUBHjHvtR4kJrKim/P922mvcYLZ0bvYRipMD+xtOpj
         mORHkTveo0uzxwDveBVe4Uryr398Oua/rnQ+E7XU6pDIs6aJe4uO/DzN1GGFDtuamMIO
         Dd7RthCLi6CkdpL1OzydY4VLQEGgcB3gyt17xdG9XkbRTxU0BylkGMtiI/M12OY0bYIu
         8UTevU3DuqPT8lfvEDOh9wUfGWa7U4JpcnOkktHx4vI1CH7Pxyu5uusGro07E+TUzQ0+
         RJ+00bWjjtLz6o2RfzLx2mgtnL6mJ95u8S78wgCcrC+9//gwrs0TA9qCR2Yi7+jDiTs4
         h/rg==
X-Gm-Message-State: AOAM530Zj7YMgt+YaqBqAABEsJwQYDsmohXqktuP6SjUxE2+eKzbTSnz
        NxyIdtUIAlfArpB50FwJWw0=
X-Google-Smtp-Source: ABdhPJyPgPkAdI9Cc+UTRLNAwFsTHJiQN5y8ecZOeGx46kYbKwtYr1F8n6dN+sHAwjBKuAcTcSSUeA==
X-Received: by 2002:a05:6402:2690:: with SMTP id w16mr7740460edd.372.1634981187191;
        Sat, 23 Oct 2021 02:26:27 -0700 (PDT)
Received: from localhost ([185.31.175.215])
        by smtp.gmail.com with ESMTPSA id f9sm5653611edy.9.2021.10.23.02.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 02:26:26 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: qed_dev: fix check of true !rc expression
Date:   Sat, 23 Oct 2021 03:26:15 -0600
Message-Id: <6e14d07c53460c5da938832b92b4e6a193cd3c7a.1634974124.git.sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1634974124.git.sakiwit@gmail.com>
References: <cover.1634974124.git.sakiwit@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

Remove the check of !rc in (!rc && !resc_lock_params.b_granted) since it
is always true.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 18f3bf7c4dfe..cc4ec2bb36db 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -3992,7 +3992,7 @@ static int qed_hw_get_resc(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	} else if (rc == -EINVAL) {
 		DP_INFO(p_hwfn,
 			"Skip the max values setting of the soft resources since the resource lock is not supported by the MFW\n");
-	} else if (!rc && !resc_lock_params.b_granted) {
+	} else if (!resc_lock_params.b_granted) {
 		DP_NOTICE(p_hwfn,
 			  "Failed to acquire the resource lock for the resource allocation commands\n");
 		return -EBUSY;
