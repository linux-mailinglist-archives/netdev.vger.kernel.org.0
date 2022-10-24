Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2981260BDF2
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 00:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiJXWzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 18:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbiJXWyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 18:54:46 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04565AC75
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:16:29 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h9so6933443wrt.0
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gMy8fNjmNzlGvq0/9Re1VqvlS3AEt0sKadKDb4szu5Q=;
        b=shGu8u/X7rau+Qjr01j/O/+w/o4okP+Q6G0rU6XQkrdZARkbCGqY46PYugDR8YsEuK
         7eIxQ0lQiV7eD8UWws9Joj+Iy8DhqFw4dwl6lt2bVqI9dnzZ1qIAOglvK3FNsh+AHF5A
         Gg/+g4oB3HS4+QqWWHSbirSy22P06pvxiOU1MPKBkT4CF75o6HlqJvgx1KPVlsQX7g2r
         1yyHUlbDD8kk1kjHomL05FAmSH7/vBfHfKa9mfRbmFtGymbByznnV6Z5tLH3VZGETmqo
         +GNyqzU962M+CuaGKE7P7Bk62Oh/sPV/oq93WY+c/Z6pXm7ua2xvNu4QfbIgHoV0zsB5
         qrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gMy8fNjmNzlGvq0/9Re1VqvlS3AEt0sKadKDb4szu5Q=;
        b=RDApURIUE60a1Ljrz6w1xFxLgQ76orR0ysm2YKI2Rv5fz8XvalhFA3DhJ1cRZatahu
         AzCKgcEVfuoKWcwQPQVjOSdnuNT6EDSdIc1rfubXKFHBmqMNS/6Ec1k9wsWHikzZb3Hm
         q1oYTYdNzlVPUhcfS2/OCVA8zxl93Eh3cS7YLzBsCsRqSQPw3hR3LnM2ZUAAY2mL2otU
         yvIF0nxslhrmN51gHA5dVsNoFeahqSAX0U1Ng1Y/Aex3kNq6MXvP6hqkin9YLGTPzJ88
         w22FM3wy9GOnrvEGCurRRkYEBfu/kG2vQG7lWyqEjDd9SyT5TAcC2d65jEUy7pf+JfOc
         lCqw==
X-Gm-Message-State: ACrzQf3oCJOsuPoU1OnkByD0y+1h8e7p1AwCOdTU5ZadFM3e5bYvBymm
        aE8Chvfrivon0WillOhDqtu1I7w2crVe1A==
X-Google-Smtp-Source: AMsMyM5dWN9Uu9Z7dN9E2s7zGgqJjEQTVqEqRRh94AVZB4dUYWvzM6C+TGJK5sQXoOISEm/TJ7Gpxw==
X-Received: by 2002:a5d:5a86:0:b0:22e:57ef:ce3c with SMTP id bp6-20020a5d5a86000000b0022e57efce3cmr23167776wrb.433.1666645433041;
        Mon, 24 Oct 2022 14:03:53 -0700 (PDT)
Received: from localhost.localdomain (cpc76482-cwma10-2-0-cust629.7-3.cable.virginm.net. [86.14.22.118])
        by smtp.gmail.com with ESMTPSA id i17-20020adfded1000000b002364835caacsm602371wrn.112.2022.10.24.14.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 14:03:52 -0700 (PDT)
From:   Caleb Connolly <caleb.connolly@linaro.org>
To:     Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jami Kettunen <jami.kettunen@somainline.org>
Cc:     Caleb Connolly <caleb.connolly@linaro.org>,
        Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 1/2] net: ipa: fix v3.5.1 resource limit max values
Date:   Mon, 24 Oct 2022 22:03:31 +0100
Message-Id: <20221024210336.4014983-1-caleb.connolly@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some resource limits on IPA v3.5.1 have their max values set to
255, this causes a few splats in ipa_reg_encode and prevents the
IPA from booting properly. The limits are all 6 bits wide so
adjust the max values to 63.

Fixes: 1c418c4a929c ("net: ipa: define resource group/type IPA register fields")
Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
---
V1: https://lore.kernel.org/netdev/20221024165636.3979249-1-caleb.connolly@linaro.org/
Changes since v1:
 * Apply the correct fix for v3.1 which has the opposite issue where the masks
   are wrong rather than the values.
 * Split into two patches
---
 drivers/net/ipa/data/ipa_data-v3.5.1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/data/ipa_data-v3.5.1.c b/drivers/net/ipa/data/ipa_data-v3.5.1.c
index 383ef1890065..42f2c88a92d4 100644
--- a/drivers/net/ipa/data/ipa_data-v3.5.1.c
+++ b/drivers/net/ipa/data/ipa_data-v3.5.1.c
@@ -179,10 +179,10 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 static const struct ipa_resource ipa_resource_src[] = {
 	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
 		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
-			.min = 1,	.max = 255,
+			.min = 1,	.max = 63,
 		},
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
-			.min = 1,	.max = 255,
+			.min = 1,	.max = 63,
 		},
 		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
 			.min = 1,	.max = 63,
-- 
2.38.1

