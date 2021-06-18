Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097153AD023
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhFRQQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbhFRQQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 12:16:39 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A54C061574;
        Fri, 18 Jun 2021 09:14:28 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id r5so17565136lfr.5;
        Fri, 18 Jun 2021 09:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zcsXDvnwmdXXMs5g79zcf5bVX0T9W6JQcEu/YgdgQgQ=;
        b=RgJK+1RJop5RiodRQKI4j9397y9b3QFrEN4y/Re5GPbcvT4iexwDSnBAQM6r62v3B2
         BaV9+IbW9Xaz5G3IhoYVmEa0o4eZYQFSoLTrsyrzTXmEOf26LN/7n9EwkjPDQzft3x23
         AxHXROqZBKqKTr0HbNljaoX5t1feCl/esnaXRRQp7q1BlP701tcx0t0TtaiH6bW+anK+
         qkpPzaLzrDdCqANujNnj+lkuDvKjh9Eb7dv9/oDQvD9bR6Dm3H6IHDse/gJvPXo68u/T
         oCKCZy9jVd1dLdHMtXL3d/eem9cD0YlJg4rbIG0RVs2q1IKxBJWHhsDNFtuNicU+Cq3y
         RZwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zcsXDvnwmdXXMs5g79zcf5bVX0T9W6JQcEu/YgdgQgQ=;
        b=TxV/vb00O/lsFTkarmOUF4/PX3gtO3KlSqsDluzKr41M3r65HsSw13STBwbtW5JYuJ
         nyW90E4gexwsodoC9TXu4iL2NOQr/AYs2HTMT+RncBZDQxELIHr17tHQZdkwcRBCoG99
         pgsNMQu9wOynO4w2zWIRy63dv8epZLpOfWUzVpe4/tF8ERTq36zey+q1Z+SN8VbIqCP+
         hak9hjCSj4sUyWYLLsvRRaq/BbbBKg7I+DWA/OFtlY2+uIzITKmTI04YszqPhk3SyM/v
         Lwcz+Xy7i8zw4R4C102oiPpopCU2nB7SK4yBY2x5by/oj4CHqks11cEcpkYLjHZKS3u/
         d8Kw==
X-Gm-Message-State: AOAM532/zMOrw41PP2i3qZLmNO/e5Nvsxqud/2FYmcpoHLNYmavrPLVS
        Sxv/pXtnx7Pt119of3dZyUE=
X-Google-Smtp-Source: ABdhPJy+0sQDG8yeqqhjzMcbZcjHHcFPz9DZ0hCmOkYs4Gn7RU4h9fnurngAzj/Ekyd1/YZG/LtdAA==
X-Received: by 2002:a05:6512:15a1:: with SMTP id bp33mr3679512lfb.623.1624032866923;
        Fri, 18 Jun 2021 09:14:26 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id w24sm947603lfa.143.2021.06.18.09.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 09:14:26 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        michael@walle.cc, abrodkin@synopsys.com, talz@ezchip.com,
        noamc@ezchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 0/3] net: ethernat: ezchip: bug fixing and code improvments
Date:   Fri, 18 Jun 2021 19:14:23 +0300
Message-Id: <cover.1624032669.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While manual code reviewing, I found some error in ezchip driver.
Two of them looks very dangerous:
  1. use-after-free in nps_enet_remove
      Accessing netdev private data after free_netdev()

  2. wrong error handling of platform_get_irq()
      It can cause passing negative irq to request_irq()

Also, in 2nd patch I removed redundant check to increase execution
speed and make code more straightforward.

Pavel Skripkin (3):
  net: ethernet: ezchip: fix UAF in nps_enet_remove
  net: ethernet: ezchip: remove redundant check
  net: ethernet: ezchip: fix error handling

 drivers/net/ethernet/ezchip/nps_enet.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

-- 
2.32.0

