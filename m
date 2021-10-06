Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98C2424A32
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239835AbhJFWvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239823AbhJFWtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:49:40 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30098C061755;
        Wed,  6 Oct 2021 15:47:47 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id z11so8530887lfj.4;
        Wed, 06 Oct 2021 15:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8cpRu0RJLTvuTv0MP6s2CEcPy04FEVktegoKcwYmZ1A=;
        b=B5iIAgINycNS4LHnP8gzU/Uv46JMCbNnnXdKG/yS33O/XixMy8nE3L8KY/QAODo9s9
         tG2CfwXn7sVNHtMdTa2R4TOrCd96NAOvePJceDOPqWAXil4029deBly3sTKHs6jkcyXz
         0qkrecz6D+NhInFLYAzDDEcSqy7JvzqnI2XICwSaWipnafq6LbdSOvnT6lvzuuDI+50I
         SABkdc+BKjfkp4IDnwjYfqP91xc/ZtIk0jKxHV2ZWSdY6COmOVF7rbuP6ikoXbFexUxq
         TmJww91nIF2h5KrsnavyGnvuvYN3J/ZzDoNECk/yBEdLuW+4KfU20ASf8JVHuQRuPf1Y
         FZfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8cpRu0RJLTvuTv0MP6s2CEcPy04FEVktegoKcwYmZ1A=;
        b=xyn682LYxyAkHKlEAJ0Ok6Vnm0a+SMLkV0z94IwQNfAf3mevELgabzmS/nX1OezvrG
         GMQq3bOdPxJRmjUvKiRbO7BqYW1oWge32t2E1X1F0sXoYXEeWfL5aO5kQz4hZ4m7pz9J
         CeJ7Yr8GoolJgR8TRGTI4Rk9dJTzUGsyA6BWKaBFkQCrlBbT2/ANjij9nJot83ZccDMJ
         jZo/tVLBQh/rcg5a1uSbgkOJZracZQFZXCC4TR+m94okYQG0qDeBasnCpsLPVWsRbvHc
         ttbCxyTPD7Fk/BBLL1HcJnslp8LQsy4KrcGKGnnQVoHH3TKRB1Jys6848kcMvEuq4DPt
         U9Lg==
X-Gm-Message-State: AOAM533UFBO/gl3AzPdqKyn8UMJ+xUBWrZd6puXh4esXGrFg0zKPQ6ZM
        WGnY3eSCDdaLe3jzXVDnCTM=
X-Google-Smtp-Source: ABdhPJypehLUcCIP9p1ISW4htweSfuq3lK15A+eX8/f2X6o/IGelQEVlf7Wp9Qv7hOSMcU8ZziE7vQ==
X-Received: by 2002:a05:6512:401e:: with SMTP id br30mr655217lfb.399.1633560465546;
        Wed, 06 Oct 2021 15:47:45 -0700 (PDT)
Received: from localhost.localdomain (h-155-4-129-96.NA.cust.bahnhof.se. [155.4.129.96])
        by smtp.gmail.com with ESMTPSA id p16sm2432052lji.75.2021.10.06.15.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:47:45 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH 0/2] nfc: pn533: Constify ops-structs
Date:   Thu,  7 Oct 2021 00:47:36 +0200
Message-Id: <20211006224738.51354-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Constify a couple of ops-structs. This allows the compiler to put the
static structs in read-only memory.

Rikard Falkeborn (2):
  nfc: pn533: Constify serdev_device_ops
  nfc: pn533: Constify pn533_phy_ops

 drivers/nfc/pn533/i2c.c   | 2 +-
 drivers/nfc/pn533/pn533.c | 2 +-
 drivers/nfc/pn533/pn533.h | 4 ++--
 drivers/nfc/pn533/uart.c  | 4 ++--
 drivers/nfc/pn533/usb.c   | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.33.0

