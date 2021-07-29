Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7063DA131
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 12:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbhG2Kki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 06:40:38 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:47686
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234236AbhG2Kkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 06:40:37 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id DB1063F10E
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 10:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627555233;
        bh=U5ZMYZkwqc8RmbQysqq1OTMd/Wgw4WsrTPEA4vYur0c=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=a3YPY3vYsKli7a7OqllP817DBrBPZwa7ng3bBFMBl/U1emu09C+a4XJ+/FUjGz2bw
         nsdLbmSUgTohopPTT2wajAk1iatWcBwh/vEJUvhSFu9JcAWg6DpxMs04OHnYrKsvhH
         zGHgBkXT8S6Z3Ed5w0uljGUcqVRPynivowlaNFRdOFTpudkyjtQF8zMdz5w3lfC1Ga
         sk6xKE4XLH2jYdIKfFBJitYPFovJcUWyl8IDxMslxe1INiMQ9sVv4XHG7rBDOpXe1q
         Eh/Iqk3wv9g7cjLWOcDWc7rz7NjO4ezhp3t7ohEh2vb/DWT+z3U5kALlnbw0ieV0t1
         n5Zorq4HVyjTw==
Received: by mail-ed1-f72.google.com with SMTP id de5-20020a0564023085b02903bb92fd182eso2765199edb.8
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 03:40:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U5ZMYZkwqc8RmbQysqq1OTMd/Wgw4WsrTPEA4vYur0c=;
        b=BIbnTczghIfgOWRGoxbRqo8YjKWu8XMuHsTmrtqG2rA53A1TYoKo64Jo0EKw4eAF2E
         7QX6N0q6DukVFOBst7Um/ZxbyD59j85+C/cQpViE9iZALfQ7WHhNvd/NUeLgbpecwaAj
         96+FG6nA2mVTHv0HFmrigS56UCRmQJiQXYc1ERWh8W0jzD/rl2SWvTg6vWH78lnMszfv
         vHmk3xZDqrVm7855SijpyrXoL1qYuw0ZtyIaVfwlxFTdBRJyqVSD2CZpFIevNO81CsHj
         A0Ne5SkXeaVXTxcJ2p0hsssX3GsapoDmSK/gQxwPSEWQeXX4oki7gr8yWvI6Dk4tMUCL
         Xceg==
X-Gm-Message-State: AOAM532No2QJ8akgxbGWGbSIFCsQm1WDcYJsEAiLFjknn7NVmdAOVy3P
        sjBloQZDXsMd5vrVL3cCg67ivSh1QSvGgB5x9EI36RkgOHSGfA3G8+cGa8G0kldvLw7vuAVUdW3
        OTaB/RAMHopU5jVxXkXE2P4YN83hTx+2Jjg==
X-Received: by 2002:a05:6402:278e:: with SMTP id b14mr5191726ede.277.1627555233653;
        Thu, 29 Jul 2021 03:40:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0zzZMt4FRxj6/pkKudrZrKtAC8UcrWt1V+5uDuEVakkenlwbpg5EabX2DWunH4RtcpYeAvw==
X-Received: by 2002:a05:6402:278e:: with SMTP id b14mr5191710ede.277.1627555233472;
        Thu, 29 Jul 2021 03:40:33 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id c14sm824475ejb.78.2021.07.29.03.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 03:40:32 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 00/12] nfc: constify, continued (part 2)
Date:   Thu, 29 Jul 2021 12:40:10 +0200
Message-Id: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On top of:
nfc: constify pointed data
https://lore.kernel.org/lkml/20210726145224.146006-1-krzysztof.kozlowski@canonical.com/

Best regards,
Krzysztof


Krzysztof Kozlowski (12):
  nfc: constify passed nfc_dev
  nfc: mei_phy: constify buffer passed to mei_nfc_send()
  nfc: port100: constify several pointers
  nfc: trf7970a: constify several pointers
  nfc: virtual_ncidev: constify pointer to nfc_dev
  nfc: nfcsim: constify drvdata (struct nfcsim)
  nfc: fdp: drop unneeded cast for printing firmware size in dev_dbg()
  nfc: fdp: use unsigned int as loop iterator
  nfc: fdp: constify several pointers
  nfc: microread: constify several pointers
  nfc: mrvl: constify several pointers
  nfc: mrvl: constify static nfcmrvl_if_ops

 drivers/nfc/fdp/fdp.c             | 27 +++++++++++-----------
 drivers/nfc/fdp/fdp.h             |  2 +-
 drivers/nfc/fdp/i2c.c             |  6 ++---
 drivers/nfc/mei_phy.c             |  2 +-
 drivers/nfc/microread/i2c.c       |  2 +-
 drivers/nfc/microread/microread.c |  4 ++--
 drivers/nfc/microread/microread.h |  2 +-
 drivers/nfc/nfcmrvl/fw_dnld.c     | 16 +++++++------
 drivers/nfc/nfcmrvl/i2c.c         |  4 ++--
 drivers/nfc/nfcmrvl/main.c        |  4 ++--
 drivers/nfc/nfcmrvl/nfcmrvl.h     |  6 ++---
 drivers/nfc/nfcmrvl/spi.c         |  6 ++---
 drivers/nfc/nfcmrvl/uart.c        |  4 ++--
 drivers/nfc/nfcmrvl/usb.c         |  2 +-
 drivers/nfc/nfcsim.c              |  2 +-
 drivers/nfc/port100.c             | 37 +++++++++++++++++--------------
 drivers/nfc/trf7970a.c            | 17 +++++++-------
 drivers/nfc/virtual_ncidev.c      |  2 +-
 include/net/nfc/nfc.h             |  4 ++--
 19 files changed, 78 insertions(+), 71 deletions(-)

-- 
2.27.0

