Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DFF2AA720
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgKGRZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbgKGRZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:25:06 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC3BC0613CF;
        Sat,  7 Nov 2020 09:25:06 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id w7so1007936pjy.1;
        Sat, 07 Nov 2020 09:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6NEkJsCiyEXeyvYU2Km3eijMSDhBwKPdqNY1wwXuuTc=;
        b=gcXi/Nxl6mkjZ5c+J0NgVW8x5zzRctDLMZdPNpEVCH0QBXXOy0JOes0z1ZXgQ5kY/K
         BWzjhxu+rriFvMIuZoS+XO7zvPY4Yh8cZjrRrkUbRvI3DdGodmSHZHMkoaVKvn+Pz9oO
         esm36yqExYQfy3LOScKMrwD9Cy4hCzXUELRvWd2g3b9D5b/cq2cGW1glbgSH74H1IXxh
         5zQCnDL4g86qnjORrd9V//kmZSubaI7aiUh2gFOJEDd0w3zq3Tjns9A3IvBLFRZcomM4
         YCft1zQh/N9t6CuJfuhiRM4Y+eUgCg/1rqCdynnr3c1K1riSoZsYP+PrwTcgdjCMAeRz
         Gstg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6NEkJsCiyEXeyvYU2Km3eijMSDhBwKPdqNY1wwXuuTc=;
        b=jnntXOecETwJ9+E5Pv+9OoP+ZTIDs5DPdIKa5Fs/rVkHR4Aff7yiM3TYxK1R+Cc/Gg
         7EL87VqjJbzsitR2hOyhNgf+Xdi1zPEuCx6R6HIQpkLO74pwLknbAOCnjO64XSkYeFVe
         VU2ZKJrAhhBsp3rIjN1dEMg7Y5AntfVuVtyXM2U7ffpP6hemBEEHnaUyTMdHk+WMWPut
         TkiqL2Q6x4B2uSOUsbfuakF+WuCuzcJSa4oaV8HtF60Y4iLvv3q9IavpBrDwSScVykGU
         bem9qyPwlECmxTXty7jWglyd9xk9QP4dHYtduhNAaOiWBV1fWcRqE6gNieTkR/xs/9Vs
         icaA==
X-Gm-Message-State: AOAM533EseoC1KPGKqjgEa2YIQYdSSHQwHJkx1xsc1/Ndt+Pi3vJXsrC
        qhQYtJukxBgnMBkLOJHwf9k=
X-Google-Smtp-Source: ABdhPJyRLHKYTsDtz5wqN37i7lr22hS/6sJhIGcoGC7rNLCoKvrEmuIkLa4K5QCNoQJfKLQvYvh0Wg==
X-Received: by 2002:a17:902:8502:b029:d5:b4f4:8555 with SMTP id bj2-20020a1709028502b02900d5b4f48555mr6117232plb.76.1604769906070;
        Sat, 07 Nov 2020 09:25:06 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:25:05 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, David.Laight@aculab.com,
        johannes@sipsolutions.net, nstange@suse.de, derosier@gmail.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, michael.hennerich@analog.com,
        linux-wpan@vger.kernel.org, stefan@datenfreihafen.org,
        inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        stf_xl@wp.pl, pkshih@realtek.com, ath11k@lists.infradead.org,
        ath10k@lists.infradead.org, wcn36xx@lists.infradead.org,
        merez@codeaurora.org, pizza@shaftnet.org,
        Larry.Finger@lwfinger.net, amitkarwar@gmail.com,
        ganapathi.bhat@nxp.com, huxinming820@gmail.com,
        marcel@holtmann.org, johan.hedberg@gmail.com, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chung-hsien.hsu@infineon.com, wright.feng@infineon.com,
        chi-hsien.lin@infineon.com
Subject: [PATCH net v2 16/21] cw1200: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:47 +0000
Message-Id: <20201107172152.828-17-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline

 drivers/net/wireless/st/cw1200/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/st/cw1200/debug.c b/drivers/net/wireless/st/cw1200/debug.c
index 8686929c70df..bcb8757c34ae 100644
--- a/drivers/net/wireless/st/cw1200/debug.c
+++ b/drivers/net/wireless/st/cw1200/debug.c
@@ -355,6 +355,7 @@ static const struct file_operations fops_wsm_dumps = {
 	.open = simple_open,
 	.write = cw1200_wsm_dumps,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 int cw1200_debug_init(struct cw1200_common *priv)
-- 
2.17.1

