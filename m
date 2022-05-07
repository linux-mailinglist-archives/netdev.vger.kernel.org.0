Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4238B51E940
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 20:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386840AbiEGSps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 14:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiEGSpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 14:45:46 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB701E3CC;
        Sat,  7 May 2022 11:41:58 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id bg25so6260415wmb.4;
        Sat, 07 May 2022 11:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kewTTWx9DrsoNkFyYPFpRhSoXTo723KMXBl58gCLpBA=;
        b=HknaJKY79dBIY1D6VMFQLWs/WIhEgTfNuz3aI6k+tQd9aE8MMxrbCef1C/yUII7xHN
         JMqZ4mWeav2euIn+1sTGGS36vGdaSkoEV0ZoJj6tdyksJNIcsQjebk6QkYhpJkIdP+To
         hQjzgKi+EkJFEP2D67BbeYbAct4F/Ke/Rg0UUtSmVBGVDI9p5yroeXA4ehdPe/EJXP/f
         U2tsU/A1R96w85Rw/7HXno5FEAQ72UpbuoeZC4JgG1Gdmk4bJLTUjlCPJVtIWMYrb3qg
         PVTzgk0TOW3uxKqI/C+yNNs9XyR7Pn01N40Az7SZZWnLW+fbu06z1IX/bpi807y1shS8
         efFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kewTTWx9DrsoNkFyYPFpRhSoXTo723KMXBl58gCLpBA=;
        b=wPbzpC4ycWLL9N/naWxOKGBmBgCeV/JVUdcSD/lrOcKP5rsvfhINZSf8KdAK5NOTi+
         LggxLIvITxCDVIpwBL2CCBZHbXXgW8u2D9ooQvNcEGcSOzgUeKhqQ2JtAydW9CYTaBgB
         8LOKReFwLE8zVcNv+9eCk1SRib2WCZZpNESnqcf7x0QWo4DxuQNta5z03oss1J+dPsHy
         BXe8/foLoX5zVsKXtjSwhtKWXS++ukqIU4Pw6RPqWZNwvjVT43xR6yiTtJUDF2OvMyhD
         wzfcJMjKppEoCqNzcE8LYqp0TW4nDo0we+BUY4Zaz4idJR6LaCv+jB+Ilgt6w5nkYNWL
         28+g==
X-Gm-Message-State: AOAM531BGnlFTA8zS/6+fduQwoHlf2voEflqhS5gGUverT2HD2AbAW3O
        0bh5hIHSEYYr7bRWWhprIF0=
X-Google-Smtp-Source: ABdhPJzEhN7/ba6cBlDyUJyzxLGhN8q+DeRTHlhT4eK4i4nAt0Dp7nhCYEOoDXLCHHDpm1NuWdSmzg==
X-Received: by 2002:a05:600c:1992:b0:394:826a:d40d with SMTP id t18-20020a05600c199200b00394826ad40dmr3928485wmq.146.1651948916519;
        Sat, 07 May 2022 11:41:56 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id q1-20020adff501000000b0020c5253d8cdsm6617330wro.25.2022.05.07.11.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 11:41:56 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH] ath11k: remove redundant assignment to variables vht_mcs and he_mcs
Date:   Sat,  7 May 2022 19:41:55 +0100
Message-Id: <20220507184155.26939-1-colin.i.king@gmail.com>
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

The variables vht_mcs and he_mcs are being initialized in the
start of for-loops however they are re-assigned new values in
the loop and not used outside the loop. The initializations
are redundant and can be removed.

Cleans up clang scan warnings:

warning: Although the value stored to 'vht_mcs' is used in the
enclosing expression, the value is never actually read from
'vht_mcs' [deadcode.DeadStores]

warning: Although the value stored to 'he_mcs' is used in the
enclosing expression, the value is never actually read from
'he_mcs' [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1957e1713548..014eaabb3af4 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -1951,7 +1951,7 @@ static void ath11k_peer_assoc_h_vht(struct ath11k *ar,
 	/* Calculate peer NSS capability from VHT capabilities if STA
 	 * supports VHT.
 	 */
-	for (i = 0, max_nss = 0, vht_mcs = 0; i < NL80211_VHT_NSS_MAX; i++) {
+	for (i = 0, max_nss = 0; i < NL80211_VHT_NSS_MAX; i++) {
 		vht_mcs = __le16_to_cpu(vht_cap->vht_mcs.rx_mcs_map) >>
 			  (2 * i) & 3;
 
@@ -2272,7 +2272,7 @@ static void ath11k_peer_assoc_h_he(struct ath11k *ar,
 	/* Calculate peer NSS capability from HE capabilities if STA
 	 * supports HE.
 	 */
-	for (i = 0, max_nss = 0, he_mcs = 0; i < NL80211_HE_NSS_MAX; i++) {
+	for (i = 0, max_nss = 0; i < NL80211_HE_NSS_MAX; i++) {
 		he_mcs = he_tx_mcs >> (2 * i) & 3;
 
 		/* In case of fixed rates, MCS Range in he_tx_mcs might have
-- 
2.35.1

