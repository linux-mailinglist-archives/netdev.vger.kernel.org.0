Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308506CFE5C
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjC3IeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjC3Idn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:33:43 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EED64487;
        Thu, 30 Mar 2023 01:33:40 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 38BB4C0007;
        Thu, 30 Mar 2023 08:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680165219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=x28SLEzPQdCr7C4E3A2BeD4cuGz8Y32FZhlqTQw6zlY=;
        b=AfgOq3A9RlfKIgj4134DuYfVT5F8UHi1E2qN5mshz6JOwnb4hwOSxqCvO3Gvi8BY0XrHT9
        +ML8kkj+LsFGw9NRWPHC6bOQ4QiemcIi/3GnV47/3QnYG9Bj9SXva845mZ+xyrisJQ3gOw
        W+jymxkz5TIRolgCXLMpRpZSOCvEEYiiIwLQPZrLblmSMYJkfGbpfvgSkIp0IZ/0l+HTj4
        Ags+Bg+EiueYD45Ag3J9eKrACvjg4qUKzaJwidtKLtisYd6IYfy8vZRgla6cSS2vVefwul
        Yqc4tVx97asPZNvKBI7BOb7E1UIaIEJm0cOrMXp8cMwByWoIBVGYdh8j941H2g==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        =?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH net-next 0/2] net: dsa: rzn1-a5psw: disabled learning for standalone ports and fix STP support
Date:   Thu, 30 Mar 2023 10:34:06 +0200
Message-Id: <20230330083408.63136-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series fixes STP support and while adding a new function to
enable/disable learning, use that to disable learning on standalone ports
at switch setup as reported by Vladimir Oltean.

Clément Léger (2):
  net: dsa: rzn1-a5psw: enable DPBU for CPU port and fix STP states
  net: dsa: rzn1-a5psw: disable learning for standalone ports

 drivers/net/dsa/rzn1_a5psw.c | 77 +++++++++++++++++++++++++++---------
 drivers/net/dsa/rzn1_a5psw.h |  4 +-
 2 files changed, 62 insertions(+), 19 deletions(-)

-- 
2.39.2

