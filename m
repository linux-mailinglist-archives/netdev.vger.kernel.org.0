Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE332710C5
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 23:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgISVua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 17:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgISVu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 17:50:28 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE67C0613CE;
        Sat, 19 Sep 2020 14:50:28 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id k25so8768023qtu.4;
        Sat, 19 Sep 2020 14:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FuUvgB8iMkHgcxvxhIPaKesqPeUDTnfXOpNMPbDpmVY=;
        b=a1U4iKqhfo4da2k6ZMM0pR3UEwpnjniDmb2MM9Ml7eYFtKSG4Ku8nDDx02mS0ysf2A
         zF/Qo8LRemksaeTJtLkCO/1e4oaYQkSd/Mq96dFWTLkuHfeZomuha1g9UvL00j+KtoiC
         4+1mLqqxrZQ0iIHLNOek3O/spp6usolVcdXfQiiF7AgnDINl43oRQkvU0zOn+qfLV26v
         Cy1O5i5hjsOxWwUU3B2y4YyWmkwtnpmBZLCj2p4XMorJOR+FLW87mes8h6mmchPMvkRW
         y20p00TJNqCjG6hF0BEoTGUnoAC67gPkqPQ7qavyHjQGWvTp40Vf3WIl9VE2L1aeFCGg
         KRdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FuUvgB8iMkHgcxvxhIPaKesqPeUDTnfXOpNMPbDpmVY=;
        b=NMKgUMttN4DAPqFd/7gW1rjQrBX+sLi42td9I4lYT2L3bh67mfEsK5n40N9oILX8nF
         QBJLvFsyiej59xhN9x1BjMNoiTYl8Ah7g3sUrpWOKWwWPJ9aVgxU1OMrtsBYR7CeGEsK
         DfTMTkOJXYqEUyjXDtUbSSJx2V6woldx3VnurFBHTCc78jEFAfM+Kozy1L21moKex4Ob
         I+lflPA7fcLcxwjzJ+UK432gmm5rXqvFXVL6lzY2VADaxezCiwelMHdiANUOaalGv10W
         3tcCJK+TenKEOvaWGEgf74Qv/U9eyx/qqX6/L7332B/Jd8Jbt8q47kpfNiZq8Y+sZlVW
         1keg==
X-Gm-Message-State: AOAM5306zDIPFTGy7EA1d4i+LagYGfJVXktNA+NKJXgq8JJeBo7ZfnWw
        KdcL2Tow8dcVnmVSi4/J+F4=
X-Google-Smtp-Source: ABdhPJzma4TX4Rjz79pVVDKKfg+gBUBcVH8tV+LWgy9AVIm0GMUcqLSOQvPA8LlC72BFBXfESKGGTg==
X-Received: by 2002:ac8:409e:: with SMTP id p30mr37958612qtl.208.1600552227678;
        Sat, 19 Sep 2020 14:50:27 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id y30sm5617173qth.7.2020.09.19.14.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 14:50:27 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 4/4] dt-bindings: net: Document use of mac-address-increment
Date:   Sat, 19 Sep 2020 23:49:38 +0200
Message-Id: <20200919214941.8038-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200919214941.8038-1-ansuelsmth@gmail.com>
References: <20200919214941.8038-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two new bindings are now supported by the of_net driver to increase (or
decrease) a mac-address. This can be very useful in case where the
system extract the mac-address for the device from a dedicated partition
and have a generic mac-address that needs to be incremented based on the
device number.
- mac-address-increment-byte is used to tell what byte must be
  incremented (if not set the last byte is increased)
- mac-address-increment is used to tell how much to increment of the
  extracted mac-address decided byte.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 .../bindings/net/ethernet-controller.yaml     | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index fa2baca8c726..43f2f21faf41 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -32,6 +32,25 @@ properties:
       - minItems: 6
         maxItems: 6
 
+  mac-address-increment:
+    description:
+      The MAC address can optionally be increased (or decreased using
+      negative values) from the original value readed (from a nvmem cell
+      for example). This can be used if the mac is readed from a dedicated
+      partition and must be increased based on the number of device
+      present in the system.
+    minimum: -255
+    maximum: 255
+
+  mac-address-increment-byte:
+    description:
+      If 'mac-address-increment' is defined, this will tell what byte of
+      the mac-address will be increased. If 'mac-address-increment' is
+      not defined, this option will do nothing.
+    default: 5
+    minimum: 0
+    maximum: 5
+
   max-frame-size:
     $ref: /schemas/types.yaml#definitions/uint32
     description:
-- 
2.27.0

