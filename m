Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8B63F7E50
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 00:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhHYWWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 18:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbhHYWWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 18:22:07 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE03C061757;
        Wed, 25 Aug 2021 15:21:21 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fs6so729706pjb.4;
        Wed, 25 Aug 2021 15:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ONTV/6h5S1vU2l9ga1yxEklvXb8skQWdW4raGQOKihQ=;
        b=pRD6NGgr5fLidDjGLVX9x0mmzMIPyIvpPkH/0rzsBuwf8IKLRk9wT+DHAeSGQitfbw
         eR73SAO1ZI9yvLixJGRzbg4y3uo7uYUZwT+KmwzGvyaKNDY5zF7Qk6TwXwWq4B38HZrx
         y0Q9VYjdtfcRfnCM9iCYXLZB884ijpafS+RAS3xmgRTaO3NGbNAQILtuVVekkYny/S+u
         057dC4Ogur3QL932IHoTAQ1BUIzocurCnEppcs+rKLwZ2Y1n8hvzy4RkcnPZOLt7z0Um
         B6kPrKlEBJw6QqKztPWSxkMWAIp/rW0iTqYB/4QDHYu/ePZxqdz6zyXEg1eT1xengejd
         wJdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=ONTV/6h5S1vU2l9ga1yxEklvXb8skQWdW4raGQOKihQ=;
        b=VBo61h27mOyjwoyy6Fm/CSnTAVGjaqDV21vB3qa3LKg9nhyULsYWq6czf+fvRw3WSa
         pAw1krbAtD/eP5JWGh5IVC6C4qLD3mgPyFwtnabiadsYnLq7rm8YlPKJx7ZapjMmN2u2
         iABtiyescsvrqGdksgOZ8V48iyGr0VYFY4NqL+MTmEd5KgiznPTsAmc2wcdJzCZ1DW6A
         +VGaiJ/b1YUxBNOvm6ctNaOy/lEJ07Uv8n+C5FGKvoI45HG0sE3VjZJyhTP0Ini6ZdCd
         ha6ECAmrao4DDYhTMBbn/iHP/tdSQJtqY5JbZFfQXZ0zTrU0kwA79mESVofKon/dyyIE
         Ygaw==
X-Gm-Message-State: AOAM533j+wKSp7NhPv9w3ctxwlow/NS0FuadQEjX8USFBE1+3VMwUS0t
        oImxgUqBJi/InNoKsE9uhkY=
X-Google-Smtp-Source: ABdhPJw3q9VkEKB6hZRPgxIBZrExC2fQ43L5rDzF3RBzS24b/Uw823jbEROn21RJbnNM8VpKF317Xg==
X-Received: by 2002:a17:90a:7e8b:: with SMTP id j11mr591137pjl.210.1629930080858;
        Wed, 25 Aug 2021 15:21:20 -0700 (PDT)
Received: from localhost.localdomain ([45.124.203.15])
        by smtp.gmail.com with ESMTPSA id t18sm616227pfg.111.2021.08.25.15.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 15:21:20 -0700 (PDT)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org,
        Florent Kermarrec <florent@enjoy-digital.fr>,
        "Gabriel L . Somlo" <gsomlo@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] net: Add LiteETH network driver
Date:   Thu, 26 Aug 2021 07:51:04 +0930
Message-Id: <20210825222106.3113287-1-joel@jms.id.au>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a driver for the LiteX network device, LiteEth.

v4 Fixes the bindings and adds r-b tags from Gabriel and Rob.

v3 Updates the bindings to describe the slots in a way that makes more
sense for the hardware, instead of trying to fit some existing
properties. The driver is updated to use these bindings, and fix some
issues pointed out by Gabriel.

v2 Addresses feedback from Jakub, with detailed changes in each patch.

It also moves to the litex register accessors so the system works on big
endian litex platforms. I tested with mor1k on an Arty A7-100T.

I have removed the mdio aspects of the driver as they are not needed for
basic operation. I will continue to work on adding support in the
future, but I don't think it needs to block the mac driver going in.

The binding describes the mdio registers, and has been fixed to not show
any warnings against dtschema master.

LiteEth is a simple driver for the FPGA based Ethernet device used in various
RISC-V, PowerPC's microwatt, OpenRISC's mor1k and other FPGA based
systems on chip.

Joel Stanley (2):
  dt-bindings: net: Add bindings for LiteETH
  net: Add driver for LiteX's LiteETH network interface

 .../bindings/net/litex,liteeth.yaml           |  98 ++++++
 drivers/net/ethernet/Kconfig                  |   1 +
 drivers/net/ethernet/Makefile                 |   1 +
 drivers/net/ethernet/litex/Kconfig            |  27 ++
 drivers/net/ethernet/litex/Makefile           |   5 +
 drivers/net/ethernet/litex/litex_liteeth.c    | 317 ++++++++++++++++++
 6 files changed, 449 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/litex,liteeth.yaml
 create mode 100644 drivers/net/ethernet/litex/Kconfig
 create mode 100644 drivers/net/ethernet/litex/Makefile
 create mode 100644 drivers/net/ethernet/litex/litex_liteeth.c

-- 
2.33.0

