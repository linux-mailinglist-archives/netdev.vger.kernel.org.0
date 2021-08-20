Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2996B3F27D4
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 09:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238949AbhHTHsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 03:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238603AbhHTHsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 03:48:14 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5534CC061575;
        Fri, 20 Aug 2021 00:47:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso6710784pjb.1;
        Fri, 20 Aug 2021 00:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NSFv+wO9M2SphOKGJXrg4MsTVB5sz3wlZBsp07YogIU=;
        b=N/SXYokExOcUICCbWuvAoyV2+dmu0DVWioxX/9dtFxrslu9wj8WEVsM+QWMYcyhjxZ
         VjyZW5HzrmMEkEMHXMURnFHeCDTwG0lV9HnjcL4Hv1ENjtgsJulZyiYQ52vhZLEhhUxX
         EkSqm9HUsjN9XQlPclx2Sjski6t6uc9MtYNuxp/7VlDvo9Q/QpwbIA+2if9ye24fwg5K
         SQzC5pNewka4QY/CyLHnzUiXqUH3FMltnNzQbNrRjll8PqaAiTIwp2d8EFkaJbWNm3nP
         V7ZRf+9ohZmepfTCq0zzIKuEWm3AjWIQSuBZ5O4MxhdPw1Z9ZyD3G4ZSON5SmSPXCTLG
         641g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=NSFv+wO9M2SphOKGJXrg4MsTVB5sz3wlZBsp07YogIU=;
        b=Wo7l/S6rotkPFl67dRd4ckJ+ik7LIrWmceSOKSGa1m8DBsTv2dvgdGqvpqfoxXre3e
         HxW5wSAl4t96FHBR5ECikuG75nBBXaSsa+Cn/Rs4zaMfYinWE+GVua7iQZKmmwN7yAoQ
         PNJC4ZtMmjI/APF7hWbxsjTQwyEhXSRe3yygvbiP4mId44bpaUBVnUnIyju/zEBs5sLI
         rsHTIU8apCbRRDSuyRXlE06RlKOwstJvtJOmQxIAdC3hiHQ2EVz+1vxueSGUT+BTnXO8
         DFP2WYdzBmzBeaHNTaLI4ttD2DyJwtm68mBYqI+4VnyDGn5/zD8ra4gDxpDXcca/rrwv
         AisQ==
X-Gm-Message-State: AOAM533BSIWe1vxcIX5eKbSFdjppwL938zKHu+CzKN4qh4VASqbiuiog
        XPbZ/yCO2295ZjBjXIsS3wQ=
X-Google-Smtp-Source: ABdhPJx2/lCSoAqUPh+04JoH3oYiEu3uZglDcxHWulgrSS9tSTd+rVHZbOybM1FsBvKz9kHcHB6fEg==
X-Received: by 2002:a17:902:d890:b029:12d:5878:420b with SMTP id b16-20020a170902d890b029012d5878420bmr15299723plz.37.1629445656725;
        Fri, 20 Aug 2021 00:47:36 -0700 (PDT)
Received: from localhost.localdomain ([45.124.203.15])
        by smtp.gmail.com with ESMTPSA id o11sm5937534pfd.124.2021.08.20.00.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 00:47:35 -0700 (PDT)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] net: Add LiteETH network driver
Date:   Fri, 20 Aug 2021 17:17:24 +0930
Message-Id: <20210820074726.2860425-1-joel@jms.id.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a driver for the LiteX network device, LiteEth.

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

 .../bindings/net/litex,liteeth.yaml           |  79 +++++
 drivers/net/ethernet/Kconfig                  |   1 +
 drivers/net/ethernet/Makefile                 |   1 +
 drivers/net/ethernet/litex/Kconfig            |  27 ++
 drivers/net/ethernet/litex/Makefile           |   5 +
 drivers/net/ethernet/litex/litex_liteeth.c    | 327 ++++++++++++++++++
 6 files changed, 440 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/litex,liteeth.yaml
 create mode 100644 drivers/net/ethernet/litex/Kconfig
 create mode 100644 drivers/net/ethernet/litex/Makefile
 create mode 100644 drivers/net/ethernet/litex/litex_liteeth.c

-- 
2.32.0

