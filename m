Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609F627133B
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 11:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgITJ5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 05:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgITJ5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 05:57:39 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34B6C061755;
        Sun, 20 Sep 2020 02:57:36 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id n18so9704031qtw.0;
        Sun, 20 Sep 2020 02:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uDVxCDw/mkuVh9Zb/S0gwKAdBr82bzOYeeKlHjwpmnI=;
        b=ofx1D1NqfH5dHW/dxhWg2l3xCNYBm6LiecHnTZc6vBJFnpQeWKX2clJOrlPHe7Ao00
         UT0RFEMsp51pob301SMzjdNLNa2paQDpaA16FUfCs5qUmp8g0i/epObbkH4bfte4T/St
         HXYJOjkV/RVEufB/ao2ntSqe6uB4z+pBTXH0ceHfk4RwtiGXov9TFxRoBZUrf8FtruzO
         b5lk5IADvtxrHkhWDtFRKry5EquXZY9yI0HtgcXXHrrI1crTb0OcXli8MOgA+4srkx1c
         otcCkpCWZenJ4WVl0JLln6AGVzgiWnelhAJuoBWRqznJ9i1MQrxYgaduAcGqkpyLljBI
         u/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uDVxCDw/mkuVh9Zb/S0gwKAdBr82bzOYeeKlHjwpmnI=;
        b=m1kIHovBGC+xMMvQn1wTW/vLfeZWNFAh2wXd44QAMUIerK4cOzsfwYNKWBwLyXKZcX
         Fk2M8OpYBpu4d9LovR0pHCJ6LtXmcQ6hK79QX4ubqaON8deRk35IIZ46DGetz1uYYehI
         DaPijrr2PaHWc0WTlQf0W9wqZ+dl4n/DMVU+d2n8oSLXFFJw4gc/9mznbnMje+zwJvGI
         uEp+Fig2V88UubdN6KzvxDvYpvg2SopRfWSDqWE8HwiiVzWw7CzhC/SCNMupOWtM0EOK
         VLJ1S3C17ugSpT4u/LLxTqRczzeExlX2PsX49EJpcgYFZkB1GHE/ZsBewCm99yO5Jbsi
         mxHQ==
X-Gm-Message-State: AOAM533y3sxdXWO19QNyAvZ48Jb511p0+HkSld80m+SzyqQxyVZ2KJo3
        CkTlTohnWQXH6A3Gj2ykdCo=
X-Google-Smtp-Source: ABdhPJzAMgo/CGiZ0Vsks0+7msEFUyUjYcOWlQTJtyjBuCh5bhXnmX0eMlVDb73ddJ8e6oyfhXVC6Q==
X-Received: by 2002:ac8:3848:: with SMTP id r8mr40698252qtb.205.1600595855672;
        Sun, 20 Sep 2020 02:57:35 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id w6sm6968323qti.63.2020.09.20.02.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2020 02:57:35 -0700 (PDT)
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
Subject: [PATCH v3 0/4] Actually implement nvmem support for mtd
Date:   Sun, 20 Sep 2020 11:57:18 +0200
Message-Id: <20200920095724.8251-1-ansuelsmth@gmail.com>
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

Changes:
v3:
* Fix const discard warning in of_net.c
* Add some info about overflow/underflow of mac-increment
* Limit mac-increment-bytes to the last 3 bytes
v2:
* Fix compile error (missing mtd_node in mtdcore)

Ansuel Smith (4):
  mtd: Add nvmem support for mtd nvmem-providers
  dt-bindings: mtd: partition: Document use of nvmem-provider
  of_net: add mac-address-increment support
  dt-bindings: net: Document use of mac-address-increment

 .../devicetree/bindings/mtd/partition.txt     | 59 +++++++++++++++++++
 .../bindings/net/ethernet-controller.yaml     | 21 +++++++
 drivers/mtd/mtdcore.c                         |  3 +-
 drivers/mtd/parsers/ofpart.c                  |  8 +++
 drivers/of/of_net.c                           | 57 ++++++++++++++----
 5 files changed, 134 insertions(+), 14 deletions(-)

-- 
2.27.0

