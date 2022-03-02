Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B40E4CAEA8
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238968AbiCBT0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239565AbiCBT0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:26:18 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3E6C12E5
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:25:34 -0800 (PST)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 8C8863F610
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 19:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646249133;
        bh=15HOmnObJXsVXxZJ5x/3DtxcDfRhMgZoa5zrHrITnNA=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=PKpplZhszbhJBuaAHLd6jCxXsHl9zjkiFVgZMG863un42zRgGs+HnE+bgl4xuzcBL
         M/jyqWnVP3jq+1AVzSiJJDUj+AhO+tlSDClcAr5uUMk3MFjIrKNbUgeEXObSon8Y4m
         XlJPOsPQ64VehcQUrlyOLx5jfdDXwyk6PHG10i22jT0noFffSsR+8IN+21xZIQtaB2
         KLu/pMeYZj4zXM/kRjlAqUe3mynxwHjOAVGfRKG7q5J9MbCWpqyP4NIF22Ggaumn0X
         tCW/Y5WAIV9jMat707vXcHZNEYu5SCWhWblGe/wZXP6UeS3QlKqbw6dMVxinS6CO3D
         EZw84xfDQVjLw==
Received: by mail-ej1-f70.google.com with SMTP id k16-20020a17090632d000b006ae1cdb0f07so1479434ejk.16
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 11:25:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=15HOmnObJXsVXxZJ5x/3DtxcDfRhMgZoa5zrHrITnNA=;
        b=VGKlQX1bTskTYYxyDz+VwK6SX2qI6lSbC3tdSAGQmFBDYKZHIaePNYMzHa3m2gQfig
         e80mrDMjpQPKb3AH9uMszzWmq6nON+aG6sAOsC6racccodrwZoxnd8+ihx4wcXPF9miw
         m+loSvFIZge7bR8S1/tQI7ZWkC/ldpEEuhtF/6NL97P13b92WclYkq5oGgBI0CVRNWIB
         QP57Z4IarVPVSAhG48PC66naI3BOWDbQ/p7UXfgXKkBfkU3F6cB4ntFvozfzk2h/3NTS
         9V73ocZEvOah/4PFTHMgMwCU3M+ZOiU/w7KQM+GNqe6JWjdKRbvLMAZG+uJsaUE4OWNA
         yOJg==
X-Gm-Message-State: AOAM532P6f+aq2u8zK/omxgRhR1wlGyr4/sSj0fiOundb4sMY0IDpxee
        OcCEWbnKrmgVpnqbgWu6P8zYdJ+pTqp3cV2py3Fc7unt76KBOmy4GMcq+pYi3zDPU5qtA0485C9
        S4aT0ythzVKc5dWsiog1/9vpydF54ihIQLw==
X-Received: by 2002:a17:906:7751:b0:6ce:e3c:81a6 with SMTP id o17-20020a170906775100b006ce0e3c81a6mr23328452ejn.278.1646249132425;
        Wed, 02 Mar 2022 11:25:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzoNWOZ7D/uCsO1FWpSxrBelZ9YFjgouGbue8Nl1lS/Y1LnCK8P6xOlohDZjyDgtT/p5sfpXA==
X-Received: by 2002:a17:906:7751:b0:6ce:e3c:81a6 with SMTP id o17-20020a170906775100b006ce0e3c81a6mr23328438ejn.278.1646249132223;
        Wed, 02 Mar 2022 11:25:32 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id i14-20020a50cfce000000b00415b0730921sm1482765edk.42.2022.03.02.11.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 11:25:31 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v2 4/6] nfc: llcp: use test_bit()
Date:   Wed,  2 Mar 2022 20:25:21 +0100
Message-Id: <20220302192523.57444-5-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302192523.57444-1-krzysztof.kozlowski@canonical.com>
References: <20220302192523.57444-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use test_bit() instead of open-coding it, just like in other places
touching the bitmap.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/llcp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index 5ad5157aa9c5..b70d5042bf74 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -383,7 +383,7 @@ u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
 			pr_debug("WKS %d\n", ssap);
 
 			/* This is a WKS, let's check if it's free */
-			if (local->local_wks & BIT(ssap)) {
+			if (test_bit(ssap, &local->local_wks)) {
 				mutex_unlock(&local->sdp_lock);
 
 				return LLCP_SAP_MAX;
-- 
2.32.0

