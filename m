Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48C72745BF
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 17:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIVPvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 11:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgIVPvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 11:51:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F24C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 08:51:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b3so16615548ybg.23
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 08:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=QduIUPI8M0Jyasp3rgQs27f0auOCJKur9ovSruhKBDE=;
        b=lUupqbDXR3SdQaGCGoYuzxwEDK0oAo8uEqs8lJZQrC4Fgbcvf94XEMvwa6yRxcgZPh
         Hc/iLq6xGinG8A9Q+tkOZ/nTf+UZVhza/B4NPe9gY5w57AXDSxXDqzzJPuchJR9mFTH2
         7g4Rn99m1AZ4bLm3vpm/4weZax1fYTmetcxkoNmKkcXHSJLXwwupGVZyRva1EgFh1sHF
         eXwnB+abCRLUdeINz6fdSAdocOqW0pIpcs/K5G7wioeZn5Ejc7ug5g3tU4HSUAe6w9in
         iN6Uki91Y3m0So0DAfh1lidWoIndNZMt+H+7Zx+UgewFPeW5cGADxTtQ90uAklRwEKG0
         A0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=QduIUPI8M0Jyasp3rgQs27f0auOCJKur9ovSruhKBDE=;
        b=s97Sp4c5IrNZHtrdkCxAmCwjO++ZHQyRGO4mv9NgtYwhtL3pf2x1wwPAd01MOHzUb6
         zWeVebklHjOvw6FTVWrYGGe2vOsQRJTecrkTv0iUlkVlNMxFgCLhm/ReQh4gdrTvkY8E
         1heiXcmq7O8nRM3gxHQkN8cjt1nY4/PC9IbKwQMdmD9InGH8RSbXSEpAZ5yRAse6GT8p
         I9S7/mtkMJqkEK/+5GV/hJxx4TK7To8unj64yqxdZ1IjivRziGcEZRK43VxRcJo38TkD
         myoYDbgWNGH/v/kdDAz6pWSL50LKsmB1DImIsZ7PUaC3ITjGXIWTO418ga5UQyBm8wDf
         1TTQ==
X-Gm-Message-State: AOAM5324dw8JSLRhl2F0jYBKD8lmIRA8BR0OdlOvhDFq8/kAFhwLsejQ
        fI7+qTTdzVGTfng8+ZPlp+zmAiQiWlTNlteKhdzFcvbqG+LvE7iYT2nVUVGFXtK3JrYbDomqxkp
        xygKGdQDI/yNvI+RtOF0BDOXgz8LjkyUZ9KKHeLKmYdLGn4YM4hJv7SC9CahjQIqECdH5/B3O
X-Google-Smtp-Source: ABdhPJy4/1I9LUnvtpqT081zcDJwIex5EzJjAzXUNBSHKYoF142sb4igeNb7USkOFYgPcudlzvhZXyMbguWcPZG/
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:242:: with SMTP id
 63mr7851474ybc.478.1600789863629; Tue, 22 Sep 2020 08:51:03 -0700 (PDT)
Date:   Tue, 22 Sep 2020 08:50:57 -0700
Message-Id: <20200922155100.1624976-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH net-next v2 0/3] GVE Raw Addressing
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from v1:

Patch 1: Remove incorrect indentation change in gve_adminq_describe_device.

Catherine Sullivan (3):
  gve: Add support for raw addressing device option
  gve: Add support for raw addressing to the rx path
  gve: Add support for raw addressing in the tx path

 drivers/net/ethernet/google/gve/gve.h        |  40 ++-
 drivers/net/ethernet/google/gve/gve_adminq.c |  65 +++-
 drivers/net/ethernet/google/gve/gve_adminq.h |  15 +-
 drivers/net/ethernet/google/gve/gve_desc.h   |  18 +-
 drivers/net/ethernet/google/gve/gve_main.c   |  12 +-
 drivers/net/ethernet/google/gve/gve_rx.c     | 342 ++++++++++++++-----
 drivers/net/ethernet/google/gve/gve_tx.c     | 207 +++++++++--
 7 files changed, 552 insertions(+), 147 deletions(-)

-- 
2.28.0.681.g6f77f65b4e-goog

