Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A596851329E
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345616AbiD1LoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344842AbiD1LoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:44:10 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3122161281;
        Thu, 28 Apr 2022 04:40:56 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id F323B22238;
        Thu, 28 Apr 2022 13:40:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1651146054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zSG2YRXQ8jHbxXXgSf+3I2XkD4FVyM24hqOSyCmfcZE=;
        b=okgsCDAvSUkhZKE41miMlW/DQ8IYOSn5qOxU3Y4b3flUMzpKNFq5P+9DrP06ruIzhHQIQr
        3tq4ZlbTKiwcD/RmW9JLZxIzAkRL9amDYZHBOgJmIl8b3h6yCoPXFbLaiwMuS21AmFs8UA
        cJwew70PnP7Uq6yo9vVAJrs74SshYTY=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 0/2] net: lan966x: remove PHY reset support
Date:   Thu, 28 Apr 2022 13:40:47 +0200
Message-Id: <20220428114049.1456382-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the unneeded PHY reset node as well as the driver support for it.

This was already discussed [1] and I expect Microchip to Ack on this
removal. Since there is no user, no breakage is expected.

I'm not sure it this should go through net or net-next and if the patches
should have a Fixes: tag or not. In upstream linux there was never any user
of it, so there is no bug to be fixed. But OTOH if the schema fix isn't
backported, then there might be an older schema version still containing
the reset node. Thoughts?

The patches needed for the GPIO part are just waiting to be picked up by
Linus [2,3]. This patch and the GPIO parts are the last pieces of the
puzzle to get ethernet working on the LAN9668 on upstream linux.

[1] https://lore.kernel.org/netdev/20220330110210.3374165-1-michael@walle.cc/
[2] https://lore.kernel.org/linux-gpio/CACRpkdbxmN+SWt95aGHjA2ZGnN61aWaA7c5S4PaG+WePAj=htg@mail.gmail.com/
[3] https://lore.kernel.org/linux-gpio/20220420191926.3411830-1-michael@walle.cc/

Michael Walle (2):
  dt-bindings: net: lan966x: remove PHY reset
  net: lan966x: remove PHY reset support

 .../devicetree/bindings/net/microchip,lan966x-switch.yaml | 2 --
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c     | 8 +-------
 2 files changed, 1 insertion(+), 9 deletions(-)

-- 
2.30.2

