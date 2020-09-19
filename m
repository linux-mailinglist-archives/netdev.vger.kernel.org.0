Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2942710BC
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 23:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgISVuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 17:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgISVuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 17:50:04 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0095C0613CE;
        Sat, 19 Sep 2020 14:50:03 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id cy2so5191335qvb.0;
        Sat, 19 Sep 2020 14:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3hl1o3ICFuXiy7eA4eDYoCmO/Au2P6m1F0ozkchaXgs=;
        b=Uz8mi+lijtNLOM5wb/5Yk7OxXSqXl5fTEBY7PXi4nuO0+QLCl7qsbdZhtRlzWbi4QG
         tdbMEYnSfTvGVeIxXS8ZJP83K41jhJgNNfVxfPKrm4+bLPNbecb3L/gfyUut5QP9iV8c
         vGom8C4REFcJzu7P2gdHgUTNgPVQZSJTpWH3WcaGnvL5NG3WOodcUQviG0FcAcFsuBtS
         xrtbP5uCqQc4vpI+1hgoHKwFDX7uKgXC0ld7xBvLhQP5WpEj1N6nW5urAaTvm8sCrFg1
         NeF9HEzYLFN8oO76DOF7VpSPsjarccv36/5l8suDdjtqOR+qXUTKq2yu4veidiBzVN9W
         38Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3hl1o3ICFuXiy7eA4eDYoCmO/Au2P6m1F0ozkchaXgs=;
        b=j9k34ulbrOOzIB5jAUO7DnHuZFbWLXOlUQfRuaeaslHRXiuT2H0F7XDhqbR0RimAfq
         mUDpimVMPPRUezbn7wav1LxKmEnd0iNrTfLHr5u1FX8Pb0NEnwuvuvYjX/ll4WMO67AO
         agmgcpHSoDNt4uGEr9kuTVLAKVlWuGQiuQptNIN7500QWUWIKJYMufoX3lE4QuwRlFbC
         FTRicGyzAYKtk0V6rs4KurwgpZVXEjCAGnBGyLNgix/tv4wnoF2HRDTJPQjEu+0PbDn9
         F9oczV24ANg3zuKDdxZGw/sfcX2begmnjWFqP5XiCb954riSeAStNiVnnMXew8xt0aK/
         qU+g==
X-Gm-Message-State: AOAM533vPPeIo5IV/SZI2BL5QNBQCrw/xD3y3iaL9UxWa6RYY3IzRmzl
        Zh5RuFnv3+ZO8fZoWeGCEqk=
X-Google-Smtp-Source: ABdhPJzdzJ1kGDYMRHif8O/iBPP6dvdWrG9E2e77pdxXFPpqjWA/ABGx99WwnWT1CMkGNUt/ozlxnQ==
X-Received: by 2002:a0c:c543:: with SMTP id y3mr23404364qvi.47.1600552202469;
        Sat, 19 Sep 2020 14:50:02 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id y30sm5617173qth.7.2020.09.19.14.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 14:50:01 -0700 (PDT)
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
Subject: [PATCH 0/4] Actually implement nvmem support for mtd
Date:   Sat, 19 Sep 2020 23:49:34 +0200
Message-Id: <20200919214941.8038-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mtd support for the nvmem api has been stalled from 2018 with a patch
half pushed hoping that a scheme is found for the mtd name later. This
pathset try to address this and add a very needed feature for the
mac-address.

My solution to the already discussed problem here [1] is to keep it simple.
A mtd subpartition can be set as a nvmem-provider with a specific tag and
each direct subnode is treat by the nvmem api as a nvmem-cell and gets
correctly registred. The mtd driver will treat a direct subnode of the
subpartition as a legacy subpartition of the subpartition using the
'fixed-partition' parser. To fix this every nvmem-cell has to have the
'nvmem-cell' tag and the fixed-partition parser will skip these node if 
this tag is detected. Simple as that. The subpartition with the tag 
'nvmem-provider' will then be set by the config to not skip the of
registration in the config and the nvmem-cells are correctly registred
and can be used to set mac-address of the devices on the system.

The last 2 patch try to address a problem in the embedded devices (mostly
routers) that have the mac-address saved in a dedicated partition and is
a ""master"" mac-address. Each device increment or decrement the extracted
mac-address based on the device number. The increment function is
implemented in the of_net function to get the mac-address that every net
driver should allready use if they don't have a trusty mac-address source.
(One example of this implementation are many ath10k device that gets the
mac-address from the art mtd partition assigned to the network driver and
increments it 1 for the wifi 2.4ghz and 2 for the wifi 5ghz).

I really hope my mtd nvmem implementation doesn't conflicts with others
and can be used, since this would remove many patch used to get mac-address
and other nvmem data.

[1] https://lore.kernel.org/patchwork/patch/765435/

Ansuel Smith (4):
  mtd: Add nvmem support for mtd nvmem-providers
  dt-bindings: mtd: partition: Document use of nvmem-provider
  of_net: add mac-address-increment support
  dt-bindings: net: Document use of mac-address-increment

 .../devicetree/bindings/mtd/partition.txt     | 59 +++++++++++++++++++
 .../bindings/net/ethernet-controller.yaml     | 19 ++++++
 drivers/mtd/mtdcore.c                         |  2 +-
 drivers/mtd/parsers/ofpart.c                  |  8 +++
 drivers/of/of_net.c                           | 53 +++++++++++++----
 5 files changed, 128 insertions(+), 13 deletions(-)

-- 
2.27.0

