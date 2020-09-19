Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5A5271130
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 00:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgISWbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 18:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgISWbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 18:31:09 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F99C0613CE;
        Sat, 19 Sep 2020 15:31:09 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id w16so10866678qkj.7;
        Sat, 19 Sep 2020 15:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FuUvgB8iMkHgcxvxhIPaKesqPeUDTnfXOpNMPbDpmVY=;
        b=Kq1HpGi/RYvFJutzgEITb+4XKoQsYcQaiw+JEkrWbrHSNHzflhnewbfX+OA/ayuomc
         x3AwuO3t6ZN/vhnJYTiArWB+c8Pu0QJUMS+brIYBidpJNVGEz9z7sTUTkkkivAKtsgGU
         RGezSP7qEpItLVMgIEcxuxHKBWu3MIDWlAM9tqgm57ObEzYKGqa9JVYmkTrGUo2mfwzS
         ZxY6ejgJBoT5TwyAYgFIDcg+QaX4gXcG4FmbOK2w1IA4Ubx7QgTojiH/B/H1cDuKif55
         Y92TBtPpPRCIIrht7fIqeMgQx1pNYJw+mSfl6uw8QaKuMUI0/0a+UTtuhH46eDnZwOVW
         01Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FuUvgB8iMkHgcxvxhIPaKesqPeUDTnfXOpNMPbDpmVY=;
        b=N8UnoZd9YzYjClP8pLLdHKWvuoc3+AFc/gzIyte9Il49DmctXxyBeinGMZL4JIvZEN
         /gPOn/2G1IiF8AKts4D2ziujnPlRUyMTiLllIpwGSUxCGYfqeLkz3mhR4s4ij3ooHwIs
         LxvpGSnaMVHAugsbfPX8lpSZVRwdjC/hHw9nsXVTZ8HWR/kVaYOOjqP8HUQTxe8ToLpt
         JaGSnRZvAC+fMeuw878P69FqZp3ytuLhAemcqL09ZYIpZQgKNPs6q+7gTdOTxHkg4+1T
         +58Rjf3X5pxXNK98U7N7fVHuX/1cG5dmPBlPqeOuyLXDlqPNCFtk+eV0/wf5rjUSBmKx
         hi2g==
X-Gm-Message-State: AOAM532BsGVgEY6dgBM/wau8KqcYYcba3IVTZYW0sYxuq9yxxetZ0zYG
        5layRWw557DyAa0oBNo+13c=
X-Google-Smtp-Source: ABdhPJwMQqLUYfruyEYwvtNhOG0DwZqLC/uJ2hsFUBlKE0cn+xgwFxVAVeYLm/LOL9qALxmfXyYNrA==
X-Received: by 2002:a37:76c2:: with SMTP id r185mr38929715qkc.122.1600554668713;
        Sat, 19 Sep 2020 15:31:08 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id f24sm2581139qkk.136.2020.09.19.15.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 15:31:08 -0700 (PDT)
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
Subject: [PATCH v2 4/4] dt-bindings: net: Document use of mac-address-increment
Date:   Sun, 20 Sep 2020 00:30:23 +0200
Message-Id: <20200919223026.20803-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200919223026.20803-1-ansuelsmth@gmail.com>
References: <20200919223026.20803-1-ansuelsmth@gmail.com>
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

