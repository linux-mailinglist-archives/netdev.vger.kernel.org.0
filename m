Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647A56B669B
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 14:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjCLNZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 09:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCLNZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 09:25:56 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F02836688
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 06:25:28 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id ek18so7444127edb.6
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 06:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678627525;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9ThcQghjkQwieMSh7wX5ur2mSAR865773OCnkNSjcQE=;
        b=J+bE592whtHYre01ACa3tOCLnOc559XowWr4XwQqP9s6/mbmYAgwXv/0HxCXMpDvxh
         zknExAKWfxdEq8WwHrVK88RJ+29mlL5qPR25TKgXr1LwldNsYBMx/7n8wSxo8x6JokKn
         KLHU0gOi7xHewTlxCff4Sg2WOAOfaXGApzWTlsfFEesN+Ydh8UVF3YSpyIBKDoN6gyOp
         GLY16Y9cRUpnKW2442tUG10K2QbQEf2iaMcN5qouApiF6XCvB+Kf9kE+46nkmUR7P4OX
         TSl33QDFFgXuQq+XE9AuswIym/6CinvXvGAKUnHNsd88nmTgaZnAWG/uL5dcVXYxeF9T
         Vcew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678627525;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ThcQghjkQwieMSh7wX5ur2mSAR865773OCnkNSjcQE=;
        b=R6of1+IgGoLgLYzc7I/jIUXGDRiLdK+VHTbqUnUOKLtHV8OEk7Y2ARTUqW9Y+rTlBK
         XSa9Btkji6fVWV9nWZ6vUsWAhVIk3bNQOySY3txLsZt8c2QP27sJZD6oDMw8SzqfRUOc
         ZQo7OoGJas+Z4Wx7MwJVXe+Wbpk/usaMe9WnABEp8yxgW+O91muCUs1+yJuX3tavUtoD
         fFrNsSalWkZ/2MkQFaXmWElWlqoRhLVo+C/2ad8P4wfp76h1U6dslJ8VoQrd0XVs6ew9
         G1V7v6oeLZ/JpjJm0koTtC575p95dZS7JBg0vhP12quzm+/j/DKNmG743/duMN7D+ofy
         cFlg==
X-Gm-Message-State: AO0yUKWMzaFRY8zLISV6mdTqfzqxhZfjYaL5oiIvDc3szv63uvQGCxQ9
        D+HMaVpuTOtv3yeCXOwPPXVIlA==
X-Google-Smtp-Source: AK7set+3MZpD+zUgKuiyKWzYk7WDj9FzU1nmONK0pkP55mMTgCbK4aSjOXmEgn0hK+gju2WNAZxukQ==
X-Received: by 2002:a17:907:a686:b0:902:874:9c31 with SMTP id vv6-20020a170907a68600b0090208749c31mr6842213ejc.35.1678627524991;
        Sun, 12 Mar 2023 06:25:24 -0700 (PDT)
Received: from krzk-bin.. ([2a02:810d:15c0:828:d9f6:3e61:beeb:295a])
        by smtp.gmail.com with ESMTPSA id sk15-20020a170906630f00b009079442dd11sm2220275ejc.154.2023.03.12.06.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 06:25:24 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH] net: wireless: marvell: mark OF related data as maybe unused
Date:   Sun, 12 Mar 2023 14:25:23 +0100
Message-Id: <20230312132523.352182-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

The driver can be compile tested with !CONFIG_OF making certain data
unused:

  drivers/net/wireless/marvell/mwifiex/sdio.c:498:34: error: ‘mwifiex_sdio_of_match_table’ defined but not used [-Werror=unused-const-variable=]
  drivers/net/wireless/marvell/mwifiex/pcie.c:175:34: error: ‘mwifiex_pcie_of_match_table’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 5dcf61761a16..9a698a16a8f3 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -172,7 +172,7 @@ static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
 	.can_ext_scan = true,
 };
 
-static const struct of_device_id mwifiex_pcie_of_match_table[] = {
+static const struct of_device_id mwifiex_pcie_of_match_table[] __maybe_unused = {
 	{ .compatible = "pci11ab,2b42" },
 	{ .compatible = "pci1b4b,2b42" },
 	{ }
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index c64e24c10ea6..a24bd40dd41a 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -495,7 +495,7 @@ static struct memory_type_mapping mem_type_mapping_tbl[] = {
 	{"EXTLAST", NULL, 0, 0xFE},
 };
 
-static const struct of_device_id mwifiex_sdio_of_match_table[] = {
+static const struct of_device_id mwifiex_sdio_of_match_table[] __maybe_unused = {
 	{ .compatible = "marvell,sd8787" },
 	{ .compatible = "marvell,sd8897" },
 	{ .compatible = "marvell,sd8978" },
-- 
2.34.1

