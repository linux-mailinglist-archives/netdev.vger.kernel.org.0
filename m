Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C211946BE87
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238370AbhLGPDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbhLGPDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:03:25 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DF3C061574;
        Tue,  7 Dec 2021 06:59:54 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id w1so57969320edc.6;
        Tue, 07 Dec 2021 06:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6gmvf4kad8B7qWBeIjM93Zh4WCfUGy5N39jKIOTD+ok=;
        b=OLX6X0HYrZ1URftwu4lcJtxGIgMLJvKrtpnTzfC0jVYiYccT6J7nOYNp/zxacg+GWP
         7OuH0O4sl6OubO0ZMV62xze1ixqHFHvC02Db6qxpVmrfc7XSkM+4Vmhz2WPMBc4uMEU6
         RQ0sRvju4uAtr0eZNu6TR34xw5VBF8a9QfS385r8iE9qgm7slf7ySvndvdumPm4Zj2PT
         mVem/Dz9xg4d3xAJak1kx7u8hwTChQi/XYnk91iVe7vdzSxcvy7ced1E/KuyflKbLd/H
         mQsCFOb7NRiBzT5k6ZLSTDXvLixam8slbF1eF7dA5daaHFBUoSprCZmyRG69yBRKtmy5
         9Jgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6gmvf4kad8B7qWBeIjM93Zh4WCfUGy5N39jKIOTD+ok=;
        b=J9QAvKpl1+wRm7SD4vcoMJT/ky2wifEVT2EvXgz14q/ro+oKZFbnbwyuEMl5HwHshv
         5hgNtbE2vUsZTKgqKQaSC6OwuxCiQAl3EVZ4wvogqk3JP9I5Cmz7NKs7PYEAl++XeAXD
         AnPriP3O/exzmuL/ByuICezyShXYhFn1FOcseHjrVZmhtVSsQ8hZCbZQalIOHUubV3Oa
         fbrnmqeT0BL5OTzLO4PFjG5EbkkhjkuqsxCcMG1Ho6s7TgixqpDnrc3SehQrTAmHGj6D
         O7jT1FG45O5rEX9BElaoDnQDtvhBCaXXUjGZEHOwM4BfWzw9jIK3X3+oi5+cSzRlWTBb
         12fQ==
X-Gm-Message-State: AOAM532SIScmHFhfFVO/GsLuNrlUPBEfUAPFjQR3QLrukaKMRdqgg6ya
        pRP5d7m6VOQqRFTLox1/kr0=
X-Google-Smtp-Source: ABdhPJw4LVyPWa4uJ8OwoRJ11Rz7Y4pCzh0YIanezh+fgG6SS1ef/m9XqNVt+tUqDXa39K2+cTW2vA==
X-Received: by 2002:a05:6402:1450:: with SMTP id d16mr9984886edx.144.1638889193089;
        Tue, 07 Dec 2021 06:59:53 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id i10sm9131821ejw.48.2021.12.07.06.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 06:59:52 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in Ethernet packet
Date:   Tue,  7 Dec 2021 15:59:36 +0100
Message-Id: <20211207145942.7444-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is still WIP and currently has some problem but I would love if
someone can give this a superficial review and answer to some problem
with this.

The main reason for this is that we notice some routing problem in the
switch and it seems assisted learning is needed. Considering mdio is
quite slow due to the indirect write using this Ethernet alternative way
seems to be quicker.

The qca8k switch supports a special way to pass mdio read/write request
using specially crafted Ethernet packet.
This works by putting some defined data in the Ethernet header where the
mac source and dst should be placed. The Ethernet type header is set to qca
header and is set to a mdio read/write type.
This is used to communicate to the switch that this is a special packet
and should be parsed differently.

Current implementation of this use completion API to wait for the packet
to be processed by the tagger and has a timeout that fallback to the
legacy mdio way and mutex to enforce one transaction at time.

Here I list the main concern I have about this:
- Is the changes done to the tagger acceptable? (moving stuff to global
  include)
- Is it correct to put the skb generation code in the qca8k source?
- Is the changes generally correct? (referring to how this is
  implemented with part of the implementation split between the tagger
  and the driver)

I still have to find a solution to a slowdown problem and this is where
I would love to get some hint.
Currently I still didn't find a good way to understand when the tagger
starts to accept packets and because of this the initial setup is slow
as every completion timeouts. Am I missing something or is there a way
to check for this?
After the initial slowdown, as soon as the cpu port is ready and starts
to accept packet, every transaction is near instant and no completion
timeouts.

As I said this is still WIP but it does work correctly aside from the
initial slowdown problem. (the slowdown is in the first port init and at
the first port init... from port 2 the tagger starts to accept packet
and this starts to work)

Ansuel Smith (6):
  net: dsa: tag_qca: convert to FIELD macro
  net: dsa: tag_qca: move define to include linux/dsa
  net: dsa: tag_qca: add define for mdio read/write in ethernet packet
  net: dsa: qca8k: Add support for mdio read/write in Ethernet packet
  net: dsa: tag_qca: Add support for handling mdio read/write packet
  net: dsa: qca8k: cache lo and hi for mdio write

 drivers/net/dsa/qca8k.c     | 205 ++++++++++++++++++++++++++++++++++--
 drivers/net/dsa/qca8k.h     |   5 +
 include/linux/dsa/tag_qca.h |  75 +++++++++++++
 net/dsa/tag_qca.c           |  69 +++++++-----
 4 files changed, 320 insertions(+), 34 deletions(-)
 create mode 100644 include/linux/dsa/tag_qca.h

-- 
2.32.0

