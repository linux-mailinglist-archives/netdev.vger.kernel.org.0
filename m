Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3944ACE7E
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344425AbiBHB4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345806AbiBHB4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 20:56:17 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50B4C061355;
        Mon,  7 Feb 2022 17:56:15 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id m25so12606713qka.9;
        Mon, 07 Feb 2022 17:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5iD3JAv2NJY5TryKV7Dj3UeZLdxf5ObNApLJn3kqghU=;
        b=pI2HVe8/S4Y+G8xDNV/doYes7BMdmEzKOwMNl7CDEObwsbuznhLtxXks2G0+fmmtqk
         OSyX7Z8b5Cw098Dal46LDTktIPK7mkbN9+/iqg0/oz2SC6OyjrfsxvjIG+1eI+S2pRLe
         LN0MuicP9WdOvLvvxpWVtJeHt5nsFOgC5KiRzkgPHe1Glk4rl5+NVOc0ErrapRH1RLxm
         N/4eiaijhDREgdPR3442hjLOZ88Y0dRiXhbXqLf4LY1CNZGO0AB6qIwhcUzflIGsP4Xs
         lq9LKc7x/Jmuec8Rn6XmyylUnXgWfFD65WnYLKkObMGsrzSTnIkVpB+mdvGGkjz9lEgt
         +pdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5iD3JAv2NJY5TryKV7Dj3UeZLdxf5ObNApLJn3kqghU=;
        b=cv4hckLoF2iUh7WP44PHeoc7PHVd1XtJtjMgbT0MPMRmJEIDR2WmhADKtF9TvBtDAm
         MC/d0O4TDj/t6+3kzV57DERzJ90MjBCRjNjB85MAgyri9CsMFRuo/ebldCjPwyJ1Kbgl
         joSdZkKO8qr3lYJ+bqJUzG/SGeUBitgO26vAJBj05tANzZLBUTlay9DmydlZYWUJOiwN
         IyVP18aqzLCjMhC/ncQuGx6gli3UlAAfUxYqDEzgIZn7JmlZQPw8np9CwZ/QaV+2FWav
         MWEe2oYSGutIIaJjOY0/NC8a0gfNhoo5Ti2cGrVO9j8HFM9eahqGmIhcDzkL4A9aH56h
         CdDA==
X-Gm-Message-State: AOAM531KcDTU4Q52aU1SkkQud2XqbpAS9l1DmG0KKxd5NkogwDR+HyYb
        kFXWs76XtmOybi9R5uiA3SGy3JvDpic=
X-Google-Smtp-Source: ABdhPJxFhOahqPUMM3z6x7O2UdmmKk2bvzsAtCng2yMFFMl9tpErPaNvbD7C4dAkwpclDF1KH6PNaQ==
X-Received: by 2002:a37:a707:: with SMTP id q7mr1512997qke.229.1644285374971;
        Mon, 07 Feb 2022 17:56:14 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id f14sm6395153qko.117.2022.02.07.17.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 17:56:14 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH V2] wcn36xx: use struct_size over open coded arithmetic
Date:   Tue,  8 Feb 2022 01:56:06 +0000
Message-Id: <20220208015606.1514022-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>

Replace zero-length array with flexible-array member and make use
of the struct_size() helper in kmalloc(). For example:

struct wcn36xx_hal_ind_msg {
    struct list_head list;
    size_t msg_len;
    u8 msg[];
};

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index caeb68901326..59ad332156ae 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -3347,7 +3347,7 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
 	case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
 	case WCN36XX_HAL_PRINT_REG_INFO_IND:
 	case WCN36XX_HAL_SCAN_OFFLOAD_IND:
-		msg_ind = kmalloc(sizeof(*msg_ind) + len, GFP_ATOMIC);
+		msg_ind = kmalloc(struct_size(msg_ind, msg, len), GFP_ATOMIC);
 		if (!msg_ind) {
 			wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
 				    msg_header->msg_type);
-- 
2.25.1

