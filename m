Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7119A5A2738
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiHZL4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236536AbiHZL4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:56:19 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6C26B658;
        Fri, 26 Aug 2022 04:56:14 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 2F28D1256;
        Fri, 26 Aug 2022 13:56:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661514972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dZVABsOehYFJTO+b7L5shbbQcFUZ3x5Ca2bLU8ZP05M=;
        b=P15TTMzec0t1FXE/YXMeK4Q3vtKIYcFAn7cI9U+iNNye15cusqys6V70YUY5xt8iTbqSUk
        zf6U/R8IVTQZYWZ3zD6nAp3SV7x/eLp7RRKBkOqDN/WlZCg/tqtIf8sp3He6zx6iaBs3gb
        ycZznaqIg0YYvG959vkk+YG7zre3otF7xD5wfyd2G22VXpsM0M0AkfihWDISh9UCZsbBfc
        eGbFipYGFJA2iiPTUG+CkUlZpZlHQEs0mTLq6JYrvc2MCll26nd+L4WlXO8emNYQIc5St9
        veO26YKXRmjPZ/q7aN8i7HH7I+BLVkmrEoExFxX9yiErsu5zqIx5B0T/j+ohqA==
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH 0/3] reset: microchip-sparx5: fix the broken switch reset
Date:   Fri, 26 Aug 2022 13:56:04 +0200
Message-Id: <20220826115607.1148489-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reset which is used by the switch to reset the switch core has many
different side effects. It is not just a switch reset. Thus don't treat it
as one, but just issue the reset early during boot.

Michael Walle (3):
  reset: microchip-sparx5: issue a reset on startup
  dt-bindings: net: sparx5: don't require a reset line
  net: lan966x: make reset optional

 .../bindings/net/microchip,sparx5-switch.yaml |  2 --
 .../ethernet/microchip/lan966x/lan966x_main.c |  3 ++-
 drivers/reset/reset-microchip-sparx5.c        | 22 ++++++++++++++-----
 3 files changed, 19 insertions(+), 8 deletions(-)

-- 
2.30.2

