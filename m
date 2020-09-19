Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D3B271123
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 00:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgISWao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 18:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgISWan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 18:30:43 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3C5C0613CE;
        Sat, 19 Sep 2020 15:30:43 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id r8so8795340qtp.13;
        Sat, 19 Sep 2020 15:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c4ohihBLzAbKs8Bu/1T1sqja6nMDJKebNRtsvfxozrU=;
        b=F1M+nA1BK8MrKcCRrhAR+fRA9MxHi6Uxh0pY04x9jQh/zRqIqpda7BM2qoyFq/zAim
         nPcr2l964AH1N/SS/2c9qq9g8rtyGxSDVUyb+RJ158cVeUt2hlmTJ3DsDqbYjfujBObP
         UsqsYK+WJkU05nfZJtBQsGhfibHHdIxs+9MU3+1+IahewsFVmj4g6iQ3+tLSkpGhMLMM
         Wd7Li4oyaOVdWWUYNvAkFGAssdfsIZqqe4TnJJ64W8Qs7VwsRS5insGrK0H11ubm3aXc
         gLkrzDjIdbrreRnSPjjeBS9FmoyrLH9BtgHrdphTftihjmJvAqcz04Y/kkgE4H9XjdmH
         w4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c4ohihBLzAbKs8Bu/1T1sqja6nMDJKebNRtsvfxozrU=;
        b=Pqq4rjRfRi2gBL8GmkxeC3El8Aoa9l71k3XcR1yvrG8kE2LLNTpx3oJP9flIt4b7hG
         qhAkfwNIteVF2aolAcrkEeksWxm6BsKDkyLkeev2j0h7GTnmGqhHnUtgBktK0epiUCMN
         WvYWUHWZtXBHDUzc0agCzPPuUYec0P78EDCza16sSbZSMR/Z3OCElLWqmezwFbWrowcL
         5VRsOXlLRszwZdIA2MECT9UdcSeBydty10i9G/keKvm3onLLvO10SHJbHLES2MGSIf78
         JNLN7A4gUyTMZ2XWB5M37s2finjWyF3klpN0o25JObA5ViVwpCKCS+v0fyUVnu0Lk69O
         ncpQ==
X-Gm-Message-State: AOAM5301vHZkx9vnH/OLSQVpZRSTmy+vXWxX22ad/JBUcyvp/KrH9FuI
        oAMWWRbTdDHLJ5ZOXEFKsZM=
X-Google-Smtp-Source: ABdhPJyy8Go+AqwEioL7G5p0Y7q3etaRJByxYyhWS9KBVNcx1f2oAfBAY6yN6okxvP5+o2cRDOP36A==
X-Received: by 2002:aed:3e3d:: with SMTP id l58mr40839873qtf.350.1600554642920;
        Sat, 19 Sep 2020 15:30:42 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id f24sm2581139qkk.136.2020.09.19.15.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 15:30:42 -0700 (PDT)
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
Subject: [PATCH v2 0/4] Actually implement nvmem support for mtd
Date:   Sun, 20 Sep 2020 00:30:19 +0200
Message-Id: <20200919223026.20803-1-ansuelsmth@gmail.com>
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
v2:
* Fix compile error (missing mtd_node in mtdcore)

Ansuel Smith (4):
  mtd: Add nvmem support for mtd nvmem-providers
  dt-bindings: mtd: partition: Document use of nvmem-provider
  of_net: add mac-address-increment support
  dt-bindings: net: Document use of mac-address-increment

 .../devicetree/bindings/mtd/partition.txt     | 59 +++++++++++++++++++
 .../bindings/net/ethernet-controller.yaml     | 19 ++++++
 drivers/mtd/mtdcore.c                         |  3 +-
 drivers/mtd/parsers/ofpart.c                  |  8 +++
 drivers/of/of_net.c                           | 53 +++++++++++++----
 5 files changed, 129 insertions(+), 13 deletions(-)

-- 
2.27.0

