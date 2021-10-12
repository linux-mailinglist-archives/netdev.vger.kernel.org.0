Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11C6429EEB
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 09:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhJLHsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 03:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbhJLHsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 03:48:53 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF06C061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 00:46:52 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ec8so27861807edb.6
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 00:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/w1BSv4gpHts5pi64GhkKCE68eH4ge2y9vDSMP18K4s=;
        b=SZN35mjpgreyWzpI6KHZ/9pt/KMv0Oy5Cq77LS5q3KkDkHvS6A/GHUs5PE7ZQhoccZ
         Db042ofSQxkLW2Pg6C9S8S/lzMCANBhimQLbqR+kDYhWwPlPZM7ADqv4o9G8Ve17qLNp
         5FNmP/HfbWIWqvZO55v2F/dKks7DkZNE2HuWooETa/h7WbTk+w7fFrCxQRVN0sMZcvt5
         Tg0IE/xU0pp0q4QHaBMbXGAYReddTQwXygBOF2gUF//+DccGd8W4M3ABmXk12i1VvVlN
         Sd0DawxwgEMQWyJki9kH5Qt9ifz7YkYkH0xBf0iUT66qCxfvFDQKbGhu+fUiXeFr3J8/
         RRFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/w1BSv4gpHts5pi64GhkKCE68eH4ge2y9vDSMP18K4s=;
        b=7JAD1W4lEXkh6ZhKDjh2oEP7pFuHCsZ84AFps9O8FVKYbX3Ktcw3DzLg4a29mV/U90
         wZrzCA2UGHh6DaZr0J7YOzau5hMc8v+WLemJfJcQazynytSpB9mCM0/HuLIvADkQCExQ
         WpuBVG+okAlZh6Gmv+ROPYcCoP0lVZC86MiyLhzj/0lCeuXuyc2TFhDUKaX97TQ4lGDi
         Ab8U4iBulg0lMZmjeGOhzveU2NDyD1PySt6OqU6QJ8JWyk0LIKdLvLaEhCBu8VUQGs5m
         FmEsUiWRYVkm84SA5SMHEa8mo8ewJNwHQdTSYeCFOO19FFUPB4GPRZKvW82QE5Xa2+2t
         flMQ==
X-Gm-Message-State: AOAM532q8iuaT3Bjp7BzWVJwarxha5MbdmHShz52dyTXOirfRRMJAZPB
        i82zmtE9vxrHOB1HuSKMC+MfkDmB5z4QKQ==
X-Google-Smtp-Source: ABdhPJxroSDcryIZ6JhcxzON4QhlYrAYiJiIh35N9JZ3QFBB1Ap+LZzJKnn9CeuHzMpuwKRb7Yk1QA==
X-Received: by 2002:a50:be87:: with SMTP id b7mr49818558edk.382.1634024810869;
        Tue, 12 Oct 2021 00:46:50 -0700 (PDT)
Received: from localhost (tor-exit-42.for-privacy.net. [185.220.101.42])
        by smtp.gmail.com with ESMTPSA id r22sm4408350ejj.91.2021.10.12.00.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 00:46:50 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: qed_debug: fix check of false (grc_param < 0) expression
Date:   Tue, 12 Oct 2021 01:46:45 -0600
Message-Id: <20211012074645.12864-1-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

The type of enum dbg_grc_params has the enumerator list starting from 0.
When grc_param is declared by enum dbg_grc_params, (grc_param < 0) is
always false.  We should remove the check of this expression.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index f6198b9a1b02..e3edca187ddf 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -5256,7 +5256,7 @@ enum dbg_status qed_dbg_grc_config(struct qed_hwfn *p_hwfn,
 	 */
 	qed_dbg_grc_init_params(p_hwfn);
 
-	if (grc_param >= MAX_DBG_GRC_PARAMS || grc_param < 0)
+	if (grc_param >= MAX_DBG_GRC_PARAMS)
 		return DBG_STATUS_INVALID_ARGS;
 	if (val < s_grc_param_defs[grc_param].min ||
 	    val > s_grc_param_defs[grc_param].max)
