Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A8A65B5E8
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 18:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbjABRaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 12:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236065AbjABRaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 12:30:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9F3203
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 09:30:13 -0800 (PST)
Received: from dude05.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::54])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1pCOdJ-0003fo-25; Mon, 02 Jan 2023 18:29:57 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 0/2] net: rfkill-gpio device tree support
Date:   Mon, 02 Jan 2023 18:29:33 +0100
Message-Id: <20230102-rfkill-gpio-dt-v2-0-d1b83758c16d@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAH0Us2MC/02NwQqDMBAFf0Vy7moSRW1P/Y/SQ9SNLrVJSFKRi
 v/eWCgU3mXgDbOxgJ4wsEu2MY8LBbImgTxlrJ+UGRFoSMwklyUXXILXD5pnGB1ZGCLos+INaqF5
 WbMkdSogdF6Zfjq0pc5lEa2jvvgTj6PzqGn9lm/3xNrbJ8TJo/r1pEgTvGp5mYv6XLZNBQJc/lY
 dzleHZnxFbw2t+YBs3z+oxO2ZywAAAA==
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
X-Mailer: b4 0.11.0-dev-e429b
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::54
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rfkill-gpio driver currently only seems to be used for the Broadcom
4752 GPS UART/GPIO device on ACPI systems, but the driver looks generic
enough. It is already mostly prepared for device tree support, this
series only adds binding documentation and adds support for the
"rfkill-gpio" compatible and the renamed "name" -> "label" and
"type" -> "radio-type" properties.

Changes since v1:
- Rename "name" and "type" properties to "label" and "radio-type",
  respectively, and adapt the driver.
- Drop reset-gpios property from DT binding.
- Fix some style issues, see individual patches for details.

v1: https://lore.kernel.org/all/20221221104803.1693874-1-p.zabel@pengutronix.de/T

To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Rob Herring <robh+dt@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: kernel@pengutronix.de
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

---
Philipp Zabel (2):
      dt-bindings: net: Add rfkill-gpio binding
      net: rfkill: gpio: add DT support

 .../devicetree/bindings/net/rfkill-gpio.yaml       | 51 ++++++++++++++++++++++
 net/rfkill/rfkill-gpio.c                           | 20 ++++++++-
 2 files changed, 69 insertions(+), 2 deletions(-)
---
base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
change-id: 20230102-rfkill-gpio-dt-f9a07ef1f036

Best regards,
-- 
Philipp Zabel <p.zabel@pengutronix.de>
