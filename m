Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1C41E6321
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390783AbgE1N7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390757AbgE1N7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 09:59:08 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCC5C08C5C7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 06:59:06 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id d128so2163040wmc.1
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 06:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z4Mht0hOJ/x269vYNUbhZmvFvBpXKo/z9k8ZE3MlgiM=;
        b=miP7UbEnqGNLwbuCqX3AjlcLiVr/EEW+iM9ZpMml9MEg9sEtBhsE1bnK0HHD2uRhfF
         ADhtu3NmeTdU1c/V4b/dzY7krJThryWtxqu9nO06W+kDnFqn9IS9Sfknoz7lVfmo899S
         eDnBBRKKKyv6X5DgQFNmSm6ReWWv49Rd3VQbPJ2J0GJTRVXxJVR4yKEPRHo/F/K2rrur
         wtwbTHAPGLqhAzcaiKZCw8Sxw3dIK8TCHAMTYW2WnbKUh9rmUlyYwoziHLLhZm6zhmnw
         XokQF5+qlAi+Y/cFuLWs/+HMfeny26GRAeu553j7xxdsSymRXQPvz3pB+w/CKf3GFHJX
         0S9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z4Mht0hOJ/x269vYNUbhZmvFvBpXKo/z9k8ZE3MlgiM=;
        b=Rw9wCxYEBsM/DnMIzkOHYhOfZYPC8+jmQ+Nsc7BIGf619Upol3x73DAJj2IUKr8/0V
         flN51kMhvInOOEyTmuzmfNypyQGsA7/xh/TS8J04G7jyyL2pCS3o+FoSIgoO5IWWnZj3
         M/5oO8qfWaAkfuuUfDRIDNk9maN3ZQ8nLJo7Jp3OX7lMyEXq5mi4bGul1c4Rnjjdpfns
         4zOIpGnKjV/1hJxYU/DhpZacman1l/8OEJvt8QFAAsVDwCpM3HqbpGRSZzTYk5vti+r3
         pnlMwzy9QSOKMwr9oarf5RimOtsZagMTjdBpa4PSfXXtVhMxDQCEPFxJpv5W7829LFmf
         9k0w==
X-Gm-Message-State: AOAM533kaPduwjAwekpbq16Ux1wCKM+4sX+bKFkTAdo/cef3VJrd0q4x
        70snU3inmeCPYzkF3ixWqGgoew==
X-Google-Smtp-Source: ABdhPJwa2kiLYWJHItumPfhGeufMSpJNKjrDcHYRwjVY19oFSl+hS6FpEyyraLAC5F2EWT/iMGIlLA==
X-Received: by 2002:a7b:ca47:: with SMTP id m7mr1760608wml.173.1590674345652;
        Thu, 28 May 2020 06:59:05 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id f2sm6395917wrg.17.2020.05.28.06.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 06:59:04 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH net-next v2] dt-bindings: net: rename the bindings document for MediaTek STAR EMAC
Date:   Thu, 28 May 2020 15:59:02 +0200
Message-Id: <20200528135902.14041-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

The driver itself was renamed before getting merged into mainline, but
the binding document kept the old name. This makes both names consistent.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
v1 -> v2:
- update the id field as well

 .../net/{mediatek,eth-mac.yaml => mediatek,star-emac.yaml}      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 rename Documentation/devicetree/bindings/net/{mediatek,eth-mac.yaml => mediatek,star-emac.yaml} (96%)

diff --git a/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
similarity index 96%
rename from Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
rename to Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
index f85d91a9d6e5..aea88e621792 100644
--- a/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 %YAML 1.2
 ---
-$id: http://devicetree.org/schemas/net/mediatek,eth-mac.yaml#
+$id: http://devicetree.org/schemas/net/mediatek,star-emac.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: MediaTek STAR Ethernet MAC Controller
-- 
2.26.1

