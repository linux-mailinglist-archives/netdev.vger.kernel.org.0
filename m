Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BD553EF7A
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 22:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbiFFUWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 16:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbiFFUWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 16:22:31 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565F21003
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 13:22:28 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id kq6so18108263ejb.11
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 13:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NDvZ4UleUYUTKOU5gyNsiH8SYe6dt0N9haij8gkeJuQ=;
        b=ekAzTc3QPUODDMjzIXzdshCFY5ExrrFiCb6vYhkn4vj2sdRYhw90nR3veL6oFstY/A
         tmN89MKgKgXHx0XHoIMIl63g+XjpSQY91V0nzIj7yxM8Xe/VBkbALH/HyM25bemP+2PX
         LkASjRlhdMm8e69Ov6J94eQpEhZ7cO6woLOf0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NDvZ4UleUYUTKOU5gyNsiH8SYe6dt0N9haij8gkeJuQ=;
        b=wIH/UOmU8hsyiHqxSq52ao0u3jfC7xJfF2jaAYPleWSyl+mNDdIU0nwg7DhK0OzqCR
         JX4iLtpLJigi0wBPl1GRRFUXL+6Hfs6AdD6ADnKB32Al10Ha6BK1/sMFzSpiEKJdFLIi
         oJGKC/bnKETUVhsg6otABJewRaszttFozPuctEAUZwJUC6J7E0kKbH0XukxIwWQ9tDjk
         evOB9CXGtgNK4jHFC8yoYmRnIVmtRlMJSx7zsUpkOpqK0//Ps57Gg1Baod0IspK1lCKd
         TiJcy4dEFvQP4yX56HB3HXDOVmLAts6TeQzoY4zqiwGXlmNbMWxB8EtpLwqj1yWBXsWp
         OhfA==
X-Gm-Message-State: AOAM531q9tjwYpVVzu64pgvpOOHjU5j6GUFLuLhbTB6qTl55YTuUBd2/
        moy25XIJarF7y3t9W2aHsMzmNnW3TJ8Tlg==
X-Google-Smtp-Source: ABdhPJz7/yg9b/o2cR10nFFDSq2Ab2tXLzh90wmld7S+j8XDW6ylysOyvqFXG5LzqjkuOXraFTUIQA==
X-Received: by 2002:a17:907:629c:b0:6e1:6ad:5dd8 with SMTP id nd28-20020a170907629c00b006e106ad5dd8mr23026451ejc.641.1654546947118;
        Mon, 06 Jun 2022 13:22:27 -0700 (PDT)
Received: from prevas-ravi.tritech.se ([80.208.64.233])
        by smtp.gmail.com with ESMTPSA id d20-20020aa7ce14000000b0042dd4ccccf5sm9043789edv.82.2022.06.06.13.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 13:22:26 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Murphy <dmurphy@ti.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] net: phy: dp83867: add binding and support for io_impedance_ctrl nvmem cell
Date:   Mon,  6 Jun 2022 22:22:17 +0200
Message-Id: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a board where measurements indicate that the current three
options - leaving IO_IMPEDANCE_CTRL at the (factory calibrated) reset
value or using one of the two boolean properties to set it to the
min/max value - are too coarse.

This series adds a device tree binding for an nvmem cell which can be
populated during production with a suitable value calibrated for each
board, and corresponding support in the driver. The second patch adds
a trivial phy wrapper for dev_err_probe(), used in the third.


Rasmus Villemoes (3):
  dt-bindings: dp83867: add binding for io_impedance_ctrl nvmem cell
  linux/phy.h: add phydev_err_probe() wrapper for dev_err_probe()
  net: phy: dp83867: implement support for io_impedance_ctrl nvmem cell

 .../devicetree/bindings/net/ti,dp83867.yaml   | 18 +++++-
 drivers/net/phy/dp83867.c                     | 55 +++++++++++++++++--
 include/linux/phy.h                           |  3 +
 3 files changed, 67 insertions(+), 9 deletions(-)

-- 
2.31.1

