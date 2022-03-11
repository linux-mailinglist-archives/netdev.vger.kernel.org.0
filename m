Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67B34D6A66
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiCKXDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 18:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiCKXC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 18:02:28 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D266326AD6;
        Fri, 11 Mar 2022 14:56:12 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id n33-20020a05600c3ba100b003832caf7f3aso6602062wms.0;
        Fri, 11 Mar 2022 14:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zy99wYs9INav6M+ySXDMbZ4xodBN9Of1pEI1cnAd+IU=;
        b=YFFd/bnQJxeEEeMYOwwsSTbyCr+f8rdr616qqP+QY1ExSLUq3ssa6RC7sMOL/8H9Dv
         nW6rQP2YPvZXtANAWlm23tcjBBOh59DLjKr5kfo5BJ4u9nMh/LOmyD4dC3jfd/iVvu6Z
         sSLS1Bbpt3MShIjl+mExU9FMV6j0MaUGQ7s+Vh9mlGVVP9pYPXDAODsrvD+cD1CAryld
         O2LEZek9PED++b6JclN3ln1G9jw5Sr9WoW1VfZG/APrGnVzAOALWJExp0eBUilml8gtL
         CLkRtuKMqSNZcTlcZBGorPaettgPwxtkhF0ae7x9CHtugeQ99b7xfHsICdgcEA2hyHed
         vBEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zy99wYs9INav6M+ySXDMbZ4xodBN9Of1pEI1cnAd+IU=;
        b=ByoVqrE49WHCjq2FuMmvY+0B7zLdl5AAZbXto4fIAg01iNxhFs4yflUE3lcZkajIYV
         0VSLDo/opbTsMZ82M/JAoqrBctEbARM6g1UXi/Urvv6CY8+dr6jG2a5m8gz66IIlU2Md
         TEE9M77nf3jc+2mri3TjaMheao9v4CafLZgfViA+DlS/VemNwbGhrKUD1qAHfx/WZ1k3
         4XO5zb5zJoqN9zGUu1T0wjd3MGgehb4IO/Hts7rHUaao69cSXDxXIQuE1pt2RqamhnL6
         18MIdTRTKU1w5udKddN0QhRYZCA190h7rnD8TnN8O6v6uiMLYHj3WZY+5W+h28ZVij0Q
         7Qpg==
X-Gm-Message-State: AOAM530YdG7GsTOx6mir3a2Fj+lU6UgdwF4Wbah39RjR0lLYYNNRL8QR
        DQQv0oxLXCfyS8i+Sq6ouOv0DJ6FpOs=
X-Google-Smtp-Source: ABdhPJzUnhOjVhBQKglAYTmPJ0DMk1ouF5Z9hNagJaoeLjx8vEAlx70nCsM8tihGtMP3bdv1+UVDKw==
X-Received: by 2002:a05:600c:4a12:b0:389:9c7d:5917 with SMTP id c18-20020a05600c4a1200b003899c7d5917mr9028457wmp.0.1647039371326;
        Fri, 11 Mar 2022 14:56:11 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id l8-20020a5d6688000000b001f04ae0bb6csm7346837wru.58.2022.03.11.14.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 14:56:10 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: make read-only array wmm_oui static const
Date:   Fri, 11 Mar 2022 22:56:10 +0000
Message-Id: <20220311225610.10895-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Don't populate the read-only array wmm_oui on the stack but
instead make it static const. Also makes the object code a little
smaller.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
index 18e89777b784..630e1679c3f9 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -389,7 +389,7 @@ mwifiex_set_wmm_params(struct mwifiex_private *priv,
 {
 	const u8 *vendor_ie;
 	const u8 *wmm_ie;
-	u8 wmm_oui[] = {0x00, 0x50, 0xf2, 0x02};
+	static const u8 wmm_oui[] = {0x00, 0x50, 0xf2, 0x02};
 
 	vendor_ie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
 					    WLAN_OUI_TYPE_MICROSOFT_WMM,
-- 
2.35.1

