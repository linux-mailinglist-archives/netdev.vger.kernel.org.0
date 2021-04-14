Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02AF35F794
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352147AbhDNP1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352100AbhDNP13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:27:29 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111D7C061574;
        Wed, 14 Apr 2021 08:27:08 -0700 (PDT)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E23D522236;
        Wed, 14 Apr 2021 17:27:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1618414026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4woPntejFgdE9adUUbkurRbmOwOBb0k/Z9/BcHrVOWw=;
        b=hNByQzco/Yjh85Je8jcuYZz7vryI0ZdY1IeZ5zHfBiOAyAfYKoB0+oQUpDPCLSgSbeOYqN
        5YKcxlNUkh8RtddLwrefn43Jzgol2L0VHUjkNvrfS1NFADuJOTBaMp9Nzhjh0oFHM1NTS2
        Ocoqru2Gk3DaDeLmuHjJQldZa19mrRQ=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 0/3] net: add support for an offset of a nvmem provided MAC address
Date:   Wed, 14 Apr 2021 17:26:54 +0200
Message-Id: <20210414152657.12097-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Boards with multiple ethernet ports might store their MAC addresses not
individually per port but just store one base MAC address. To get the
MAC address of a specific network port we have to add an offset.

This series adds a new device tree property "nvmem-mac-address-offset".

Michael Walle (3):
  dt-bindings: net: add nvmem-mac-address-offset property
  net: add helper eth_addr_add()
  net: implement nvmem-mac-address-offset DT property

 .../bindings/net/ethernet-controller.yaml          |  6 ++++++
 drivers/of/of_net.c                                |  4 ++++
 include/linux/etherdevice.h                        | 14 ++++++++++++++
 net/ethernet/eth.c                                 |  5 +++++
 4 files changed, 29 insertions(+)

-- 
2.20.1

