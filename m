Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1599040285B
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344082AbhIGMTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:19:30 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:36844
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343867AbhIGMT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 08:19:29 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 65EEE3F046
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631017102;
        bh=YRlo3nZk5ArGV6WwvlTiTe3l09axCD12jul04F8OPD4=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=nzJtVJmbtzaqIcDkqC8KMC1uJbexdfbAydVpFsHbABcEbUA1AuqGNaMAyhgcBBbcS
         7TSFFzaOKRgUBtShpccXsXcLvL3BDWEqgJFWLE3pgTzWYWRU+kleg+cKeYl0KA0CN6
         qBYzhSUXjzLCSSlFGVCo8Rd6tnZR3HHxiMrVR9x0onW2wXaj4dJBeE5K7OLt6zG84W
         SSroVuzvxwq+Qevnhgd5k/YtwVjJ+V6vdy7SFJJT+mwhkd/xdFKz/jQZA8lSftv9Me
         phteiQe+KzXheg4EqTCkXmhZfnetUX4FE0BiDTo7bKS16SqRXvhukh266sBt9aFsex
         oztXPYn9dpUaQ==
Received: by mail-wm1-f71.google.com with SMTP id s197-20020a1ca9ce000000b002e72ba822dcso1112320wme.6
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 05:18:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YRlo3nZk5ArGV6WwvlTiTe3l09axCD12jul04F8OPD4=;
        b=ooTFBslTpP2YOfxCt5QdfvzmeJoB8jCwrKZw2D0Rg2/lsLppE7Efd2ZnEPX7TIQ8ED
         Ag6nhHYIS9B2BklJRVtOcgcIo9DYEUSyuxrfkVLMSE7HwmAsunpGkY+sU0OE0Uf/XHDf
         B3tOpVLvtNVW9ZYGxg1r9+jYO0sUsMJ5w/ToRu5rXETWDafc13KylvD0EuNECGTgTHBt
         hKLqE2lEomC/gbCWUI41WGx7VVbksHognba9YE11E65grHhSfszM1Eeh1iueLLnwM7Kw
         5NVI8lPSFoqp69FTUu1vJmnHCYofbmkNngLAicZbmArI65XKl0Ozc2908mFWVUYu392Q
         kd0w==
X-Gm-Message-State: AOAM53185O7MuXgTIDcV9FMpVeVBpf9jyavP1BXU+MCzxDCm0DQMQskz
        hOrwKVCxaBAnmC3Cr8+sJWmwNk4njMgWGybub+UA1XgmmlJe4RLLFT9KmBjxCdlqMuP7MAAoZsD
        bK2qdbwwjO0Te3u609H5R7kQUDuA9TdVMiw==
X-Received: by 2002:a5d:4043:: with SMTP id w3mr18531827wrp.15.1631017102102;
        Tue, 07 Sep 2021 05:18:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7BsAVATcBM4EgZcgR0syj5gOVbXmAk+X5F/H8PDMeYrVY2fTt9ht8q++8LSzCq0F5JNa9Eg==
X-Received: by 2002:a5d:4043:: with SMTP id w3mr18531794wrp.15.1631017101859;
        Tue, 07 Sep 2021 05:18:21 -0700 (PDT)
Received: from kozik-lap.lan ([79.98.113.47])
        by smtp.gmail.com with ESMTPSA id m3sm13525216wrg.45.2021.09.07.05.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 05:18:21 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 00/15] nfc: minor printk cleanup
Date:   Tue,  7 Sep 2021 14:18:01 +0200
Message-Id: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

No dependencies, patches can be picked up as is.

Best regards,
Krzysztof


Krzysztof Kozlowski (15):
  nfc: drop unneeded debug prints
  nfc: do not break pr_debug() call into separate lines
  nfc: nci: replace GPLv2 boilerplate with SPDX
  nfc: fdp: drop unneeded debug prints
  nfc: pn533: drop unneeded debug prints
  nfc: pn533: use dev_err() instead of pr_err()
  nfc: pn544: drop unneeded debug prints
  nfc: pn544: drop unneeded memory allocation fail messages
  nfc: s3fwrn5: simplify dereferencing pointer to struct device
  nfc: st-nci: drop unneeded debug prints
  nfc: st21nfca: drop unneeded debug prints
  nfc: trf7970a: drop unneeded debug prints
  nfc: microread: drop unneeded debug prints
  nfc: microread: drop unneeded memory allocation fail messages
  nfc: mrvl: drop unneeded memory allocation fail messages

 drivers/nfc/fdp/i2c.c          |  1 -
 drivers/nfc/microread/i2c.c    |  4 ----
 drivers/nfc/microread/mei.c    |  6 +-----
 drivers/nfc/nfcmrvl/fw_dnld.c  |  4 +---
 drivers/nfc/pn533/i2c.c        |  1 -
 drivers/nfc/pn533/pn533.c      |  4 +---
 drivers/nfc/pn544/mei.c        |  8 +-------
 drivers/nfc/s3fwrn5/firmware.c | 29 +++++++++++-----------------
 drivers/nfc/s3fwrn5/nci.c      | 18 +++++++----------
 drivers/nfc/st-nci/i2c.c       |  4 ----
 drivers/nfc/st-nci/ndlc.c      |  4 ----
 drivers/nfc/st-nci/se.c        |  6 ------
 drivers/nfc/st-nci/spi.c       |  4 ----
 drivers/nfc/st21nfca/i2c.c     |  4 ----
 drivers/nfc/st21nfca/se.c      |  4 ----
 drivers/nfc/trf7970a.c         |  8 --------
 net/nfc/hci/command.c          | 16 ----------------
 net/nfc/hci/llc_shdlc.c        | 35 +++++++++-------------------------
 net/nfc/llcp_commands.c        |  8 --------
 net/nfc/llcp_core.c            |  5 +----
 net/nfc/nci/core.c             |  4 ----
 net/nfc/nci/hci.c              |  4 ----
 net/nfc/nci/ntf.c              |  9 ---------
 net/nfc/nci/uart.c             | 16 ++--------------
 24 files changed, 34 insertions(+), 172 deletions(-)

-- 
2.30.2

