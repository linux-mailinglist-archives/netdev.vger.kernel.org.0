Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D263AF4B1
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhFUSRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbhFUSQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 14:16:55 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A829BC08ED7E
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:56:34 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id s19so9372275ilj.1
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d/cuSVPf2C9JoDJEerp4ashep36Ed4c3PDe794UkqTE=;
        b=QXBOq+qDq/k6P+u1/Wa9tu3UyvJ16dlS685s534u+p6G2XXrpywLgruYhQ9aKMS32M
         BmyCZXGwKno+l0V04csxLdMkwGUbqARpcesvrL1jfwpQsneLisD/Pmj2EvaJsksW0xBC
         qNJSq4mHnFa063RyTp8RhBxQNu6OkYP+Tnja8LaqWsc/s6yjc8BmXhU0ht51BYBVy0t+
         7sZ9rA/gUGCPclPYVLDPmBq81XU9wReGS+9eUdkl8202P6WJN5Gzm7Mj6kTqQ+maCm5o
         pxOXXR5tKfunt8pSWpPpM8b4AMXIVum9XRXREywdLth2NjSIHRPWEuJCBEnFQwonkyD2
         T1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d/cuSVPf2C9JoDJEerp4ashep36Ed4c3PDe794UkqTE=;
        b=d6bGrBgGPLVtj5fux/OXXWqed1TCWw1OtC/jZ4EeH54L07h2uNyy5d015z7lKhSETl
         VO4/bWiTSESRDucIflPUiXDiKdzFaHRzPjTfMAd36v+rw9dpCoyGM20oDbO4EDHZlml1
         USAAI1iJpi0qYTlTHlqlSlKd8MrlXUH410Y/62TwQB1t1neH/a/NL5rX9QVhDdvxL8O/
         yazi1NyFKVlUvgv7EtLJYNTRwFYyJNMu7b8cEAZirDLVoK/LlQKXog68zbpUsj88iUcQ
         W6ms8Ustbk7Tx/mpp5GrOfOJesPYdXKbKL686Ce/2PD/NxC9mg1fmh5z8d4qvQzA8hRc
         UuXA==
X-Gm-Message-State: AOAM532f5e4E3YLFUT0Y7EOJxWvHCUMuF+4eh53ieGpkUvX6F2z+FfkH
        ODXJzpro+Tj9qZCOKo5zffXEdA==
X-Google-Smtp-Source: ABdhPJzNmw1xwymLiMqFyT/7Hd7Ddo69DcqidsbPNUL4gsGaYjY/Jk3R0CeF4cSq5h6qge68As+QhA==
X-Received: by 2002:a05:6e02:20c2:: with SMTP id 2mr18928806ilq.222.1624298194066;
        Mon, 21 Jun 2021 10:56:34 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m13sm6259264iob.35.2021.06.21.10.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 10:56:33 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, angelogioacchino.delregno@somainline.org,
        jamipkettunen@gmail.com, bjorn.andersson@linaro.org,
        agross@kernel.org, elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: disable misc clock gating for IPA v3.1
Date:   Mon, 21 Jun 2021 12:56:24 -0500
Message-Id: <20210621175627.238474-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210621175627.238474-1-elder@linaro.org>
References: <20210621175627.238474-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For IPA v3.1, a workaround is needed to disable gating on a MISC
clock.  I have no further explanation, but this is what the
downstream code (msm-4.4) does.

This was suggested in a patch from AngeloGioacchino Del Regno.

Link: https://lore.kernel.org/netdev/20210211175015.200772-2-angelogioacchino.delregno@somainline.org
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index f82130db32f6d..20a83c7f671f3 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -400,16 +400,20 @@ static void ipa_hardware_config(struct ipa *ipa, const struct ipa_data *data)
 
 	/* Implement some hardware workarounds */
 	if (version >= IPA_VERSION_4_0 && version < IPA_VERSION_4_5) {
-		/* Enable open global clocks (not needed for IPA v4.5) */
-		val = GLOBAL_FMASK;
-		val |= GLOBAL_2X_CLK_FMASK;
-		iowrite32(val, ipa->reg_virt + IPA_REG_CLKON_CFG_OFFSET);
-
 		/* Disable PA mask to allow HOLB drop */
 		val = ioread32(ipa->reg_virt + IPA_REG_TX_CFG_OFFSET);
 		val &= ~PA_MASK_EN_FMASK;
 		iowrite32(val, ipa->reg_virt + IPA_REG_TX_CFG_OFFSET);
+
+		/* Enable open global clocks in the CLKON configuration */
+		val = GLOBAL_FMASK | GLOBAL_2X_CLK_FMASK;
+	} else if (version == IPA_VERSION_3_1) {
+		val = MISC_FMASK;	/* Disable MISC clock gating */
+	} else {
+		val = 0;		/* No CLKON configuration needed */
 	}
+	if (val)
+		iowrite32(val, ipa->reg_virt + IPA_REG_CLKON_CFG_OFFSET);
 
 	ipa_hardware_config_comp(ipa);
 
-- 
2.27.0

