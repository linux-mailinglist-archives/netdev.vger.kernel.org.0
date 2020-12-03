Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034002CD83E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbgLCNwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728754AbgLCNwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:52:19 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175FCC08E85E
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 05:50:57 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id cw27so2155772edb.5
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 05:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n6zxn0ciPWvecDtaO/9pXlIMYf7CJlzucbFrKBsiNoc=;
        b=QLZNuPrT5uf1X88NBcbBw2nY6+Q00yCrLLHBNqUgkv+bq7RHQycBWM+naJgy8x5d+I
         fO/O3DGJ6aa4jNOuR7IPbqGFVBBUv6yWbLnkr6s83m38BJFWQoMPRrSBLfBtUAiQgAyS
         J2zojUQpHvSTYTLRNgRnYvIKSxbscuGTkiG1+yM4+U3RDroUu2aKmjJjQWW3pFhYDrXg
         cbBB0enNCrFwbqPUTfBoTKzO0pqWiHdUHarykVYjoFXLZZwrwholGYK3buFMdyD9LDOe
         hAw7mBp2li26EuEbKgQbcAan1JzNyB1j3GEUJ/bj6Jq7jv41V1E15I4lH7/CJ3Mi2eq1
         g92w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n6zxn0ciPWvecDtaO/9pXlIMYf7CJlzucbFrKBsiNoc=;
        b=bo+T6vULh/jNCalg0J4C3FBukZeZcO9Wg7GjWuKUWN65pipvgLH+flfb10fM/zr+x1
         2wydeDRTbpV8m/TkS2AzJZCQIuYNwX7vqK/f0u8CVzMXHAqOCoa4+IOtYNzGZ0N9pz9J
         UZNSZLIOhHPxOXGhntmhArvZnQvINcP0xRO4Elolj/gAexnODFUKCCYGvTyuqp6lmVEA
         6GZucgAmmomNNmr4DUghQHl2Oe/IjIspjEXlQ1W4rL2y3Uyhvu6GpkfA03PYf7lwQ7pv
         4Ola19MN2MrcnAt5V5ZPh85DYhzj6FQ9Qrt/gTUkceUMS3KmHVLc8rSU+OCDBSWRmiqo
         M+TQ==
X-Gm-Message-State: AOAM532eiNts847JABDDLdDCb54ZxJV6cKRoRzzJ1T6b8n0xVwgHluFb
        fvqn2gvz3g5QKVx1zqyr/ntPSg==
X-Google-Smtp-Source: ABdhPJxEcPSsd9iZKtjM08Y/ZJsM6IA2escx5T41We/67gAoepdb9+qZzLph0YcUATXd/mVcw6PZ5g==
X-Received: by 2002:aa7:c3c2:: with SMTP id l2mr2861713edr.15.1607003455814;
        Thu, 03 Dec 2020 05:50:55 -0800 (PST)
Received: from belels006.local.ess-mail.com (ip-188-118-3-185.reverse.destiny.be. [188.118.3.185])
        by smtp.gmail.com with ESMTPSA id t19sm903192eje.86.2020.12.03.05.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 05:50:55 -0800 (PST)
From:   Patrick Havelange <patrick.havelange@essensium.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Patrick Havelange <patrick.havelange@essensium.com>
Subject: [PATCH net 4/4] net: freescale/fman: remove fman_get_mem_region
Date:   Thu,  3 Dec 2020 14:50:39 +0100
Message-Id: <20201203135039.31474-5-patrick.havelange@essensium.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203135039.31474-1-patrick.havelange@essensium.com>
References: <20201203135039.31474-1-patrick.havelange@essensium.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function is no longer used, so we can remove it.
The pointer to the resource that was kept inside
struct fman_state_struct can also be removed for the same reason.

Signed-off-by: Patrick Havelange <patrick.havelange@essensium.com>
---
 drivers/net/ethernet/freescale/fman/fman.c | 17 -----------------
 drivers/net/ethernet/freescale/fman/fman.h |  2 --
 2 files changed, 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/ethernet/freescale/fman/fman.c
index 2e85209d560d..bf78e12a1683 100644
--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -531,8 +531,6 @@ struct fman_state_struct {
 
 	u32 qman_channel_base;
 	u32 num_of_qman_channels;
-
-	struct resource *res;
 };
 
 /* Structure that holds FMan initial configuration */
@@ -1737,7 +1735,6 @@ static int fman_config(struct fman *fman)
 	fman->state->qman_channel_base = fman->dts_params.qman_channel_base;
 	fman->state->num_of_qman_channels =
 		fman->dts_params.num_of_qman_channels;
-	fman->state->res = fman->dts_params.res;
 	fman->exception_cb = fman_exceptions;
 	fman->bus_error_cb = fman_bus_error;
 	fman->fpm_regs = fman->dts_params.base_addr_pol + FPM_OFFSET_FROM_POL;
@@ -2405,20 +2402,6 @@ u32 fman_get_qman_channel_id(struct fman *fman, u32 port_id)
 }
 EXPORT_SYMBOL(fman_get_qman_channel_id);
 
-/**
- * fman_get_mem_region
- * @fman:	A Pointer to FMan device
- *
- * Get FMan memory region
- *
- * Return: A structure with FMan memory region information
- */
-struct resource *fman_get_mem_region(struct fman *fman)
-{
-	return fman->state->res;
-}
-EXPORT_SYMBOL(fman_get_mem_region);
-
 /* Bootargs defines */
 /* Extra headroom for RX buffers - Default, min and max */
 #define FSL_FM_RX_EXTRA_HEADROOM	64
diff --git a/drivers/net/ethernet/freescale/fman/fman.h b/drivers/net/ethernet/freescale/fman/fman.h
index e6b339c57230..e326aa37b8b2 100644
--- a/drivers/net/ethernet/freescale/fman/fman.h
+++ b/drivers/net/ethernet/freescale/fman/fman.h
@@ -398,8 +398,6 @@ int fman_set_mac_max_frame(struct fman *fman, u8 mac_id, u16 mfl);
 
 u32 fman_get_qman_channel_id(struct fman *fman, u32 port_id);
 
-struct resource *fman_get_mem_region(struct fman *fman);
-
 u16 fman_get_max_frm(void);
 
 int fman_get_rx_extra_headroom(void);
-- 
2.17.1

