Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69D13E2307
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 07:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243201AbhHFFtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 01:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243079AbhHFFto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 01:49:44 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F7AC061798;
        Thu,  5 Aug 2021 22:49:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so11803408pjn.4;
        Thu, 05 Aug 2021 22:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zqMZMqZJHFbP2V0kxEUSf4W659vCCPUOGtyXObXbhd4=;
        b=FEA/jsHnYicr8hEmI9Hd6v+L9GtwBlSEh7zhEwMiFbdVuhL5GvVUXEf26vRYX4jQn7
         rCJWXVgDmkaj3RStDaHNBVk2ceo49m1MkIWbi/yzsH7BBW7YDZk0jYfpkz5RXcqo/fEo
         UwV0OqrrQq2ZeQRmuLSABvtv4xOZFYq6sN5mrYdAfCumJGB0dayv8OIC/BwMizokUJko
         mA//yFub12pd+E1cxoVYx7kVzRhvm+suJqri4e60jLWdQ9pd0EkOeDecZLpV8g+aBkjK
         Nr75J3P2ggECgTL0Un5yiTJ0GWAYt0a4QKmU0aPcFaYrUpdoRWx0Et+M8dolqy4DvrI1
         8cIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=zqMZMqZJHFbP2V0kxEUSf4W659vCCPUOGtyXObXbhd4=;
        b=oBIk5+xoiSbTK8zesM3A+N+TWYMWlUuEfQEkt1Jn2vbbe2kaKfcU6ieGtwXO7eqcPN
         UDH1nByndZhUrSQ+JtZhJBm7Yxfp3mE5aRxY3j450HQB6R1cjlt2oXrA7eT4CwD61jHs
         MhgBgkuewmHQgxK7WACNEwzXUdQdR3mEJhWi1ZeISqejoDVnLyZuycr3LSUBqurbUoz8
         v1bkgxkWgTw0CAJ1Ahm2nJhYOMFIzyi7ydxlGjE1Ul0w9FiGFmGU/ij5R3j+FoiNz5GS
         Lh6DujRJgSsgYy9C2r2/S0u424MwBMGA2l9PwtBXdSOqRWbhexiBsZy8iQZgb/qnsROv
         /FbA==
X-Gm-Message-State: AOAM532j57f9ZfOgvncRzlsFUpByfYdqHAsXjy6SWfydZkFBrFqQwxWp
        tm+kWsJykWUJVvoU9e5K1YQ=
X-Google-Smtp-Source: ABdhPJyAhj0uidaqzzVLr1t2NkUtFKfKpVBBS+rg0myzv8o9nBjCsMfLgZL8Wt00+07AUc33CFduMQ==
X-Received: by 2002:a65:670f:: with SMTP id u15mr1282279pgf.205.1628228968377;
        Thu, 05 Aug 2021 22:49:28 -0700 (PDT)
Received: from voyager.lan ([45.124.203.15])
        by smtp.gmail.com with ESMTPSA id z2sm10902205pgz.43.2021.08.05.22.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 22:49:27 -0700 (PDT)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Stafford Horne <shorne@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Gabriel Somlo <gsomlo@gmail.com>, David Shah <dave@ds0.me>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] net: Add LiteETH network driver
Date:   Fri,  6 Aug 2021 15:19:02 +0930
Message-Id: <20210806054904.534315-1-joel@jms.id.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a driver for the LiteX network device, LiteETH.

It is a simple driver for the FPGA based Ethernet device used in various
RISC-V, PowerPC's microwatt, OpenRISC's mor1k and other FPGA based
systems on chip.

Joel Stanley (2):
  dt-bindings: net: Add bindings for LiteETH
  net: Add driver for LiteX's LiteETH network interface

 .../bindings/net/litex,liteeth.yaml           |  62 ++++
 drivers/net/ethernet/Kconfig                  |   1 +
 drivers/net/ethernet/Makefile                 |   1 +
 drivers/net/ethernet/litex/Kconfig            |  24 ++
 drivers/net/ethernet/litex/Makefile           |   5 +
 drivers/net/ethernet/litex/litex_liteeth.c    | 340 ++++++++++++++++++
 6 files changed, 433 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/litex,liteeth.yaml
 create mode 100644 drivers/net/ethernet/litex/Kconfig
 create mode 100644 drivers/net/ethernet/litex/Makefile
 create mode 100644 drivers/net/ethernet/litex/litex_liteeth.c

-- 
2.32.0

