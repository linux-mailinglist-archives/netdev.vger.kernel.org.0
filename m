Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FA260E1BE
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbiJZNQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbiJZNQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:16:35 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AA4A99D5;
        Wed, 26 Oct 2022 06:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666790194; x=1698326194;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mjFPBPmpLWz/562nklZTla4ladz+0IGVjIOFuv2LArA=;
  b=g2Yh5SKETTVgbyXjbhuqHF8wiqtjMF3HD/VnrHDKwvzXNmYOJDKFQxw/
   3u4XyEyUFqjIzr9LsK68QWeHA1zswcujuWJ5/ALwhaaqvcWdeqxVY3pE5
   1S0ZcUXDUtrKbdf9EfaNk4dAN4tkZe5ch89w0J4F4DeCGExBBX5vyDmcf
   V2+b5DSxKMaJ9phlsHoyAC+D7mTjnzt/QzDHpweZbj+1UxWhBXBWjgt3A
   EEL8Sweo/izH6dickrdNPA1t2ng/I78+hLL0y4aIz/v3knfSAimXt6Bj+
   FJJJVGRn6pu+pJnmZs0clvlRzh3eDVJHl3UTuGJxtwTWbTURlmaEL4wTj
   g==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661810400"; 
   d="scan'208";a="26988467"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 26 Oct 2022 15:16:31 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 26 Oct 2022 15:16:31 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 26 Oct 2022 15:16:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666790191; x=1698326191;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mjFPBPmpLWz/562nklZTla4ladz+0IGVjIOFuv2LArA=;
  b=VkLkxiFpxIRXSvtH9mdheulw/zvTruyrS/vc9L0P69NBK8JYa8AMRgYJ
   hEHrAkXwDGTMCnRVT3yX3frv80r/tPy4dAIfcw4LCm38awoH0Vhb8HOH7
   YWwetleT4ujenU/RvxoXQ2C85ybsZxE9caxuoY89vpapB+JyO7UZ1W99U
   PtlWKjo/aWDCmUwiVMye0cDfpowfV51SzGDFO0X55SBjdxO9w/SHuDvJV
   M1RBKlZ/FcnataEHlp2nlFDAKxqKcuATaVjAdDKZ0HTFh4LAjsqvh6DQL
   RlQz/n1KCzIVoVXfO6kMdVolcnzFfap1Mu/4efFQ76vsoduJJfNx5J87C
   w==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661810400"; 
   d="scan'208";a="26988466"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 26 Oct 2022 15:16:31 +0200
Received: from localhost.localdomain (SCHIFFERM-M2.tq-net.de [10.121.49.14])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id BFB01280056;
        Wed, 26 Oct 2022 15:16:29 +0200 (CEST)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux@ew.tq-group.com,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [RFC 0/5] "notify-device" for cross-driver readiness notification
Date:   Wed, 26 Oct 2022 15:15:29 +0200
Message-Id: <cover.1666786471.git.matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is obviously missing documentation, MAINTAINERS
entries, etc., but I'd like to solicit some basic feedback on whether
this approach makes sense at all before I proceed. If it does, the
naming is also very much open for bikeshedding - I'm not too happy with
"notify-device".

The basic problem that the notify-device tries to solve is the
synchronization of firmware loading readiness between the Marvell/NXP
WLAN and Bluetooth drivers, but it may also be applicable to other
drivers.

The WLAN and Bluetooth adapters are handled by separate drivers, and may
be connected to the CPU using different interfaces (for example SDIO for
WLAN and UART for Bluetooth). However, both adapters share a single
firmware that may be uploaded via either interface.

For the SDIO+UART case, uploading the firmware via SDIO is usually
preferable, but even when the interface doesn't matter, it seems like a
good idea to clearly define which driver should handle it. To avoid
making the Bluetooth driver more complicated than necessary in this case,
we'd like to defer the probing of the driver until the firmware is ready.

For this purpose, we are introducing a notify-device, with the following
properties:

- The device is created by a driver as soon as some "readiness
  condition" is satisfied
- Creating the device also binds a stub driver, so deferred probes are
  triggered
- Looking up the notify device is possible via OF node / phandle reference

This approach avoids a hard dependency between the WLAN and Bluetooth
driver, and works regardless of the driver load order.

The first patch implementes the notify-device driver itself, and the
rest shows how the device could be hooked up to the mwifiex and hci_mrvl
drivers. A device tree making use of the notify-device could look like
the following:

    &sdhci1 {
        wifi@1 {
            compatible = "marvell,sd8987";
            reg = <1>;
    
            wifi_firmware: firmware-notifier {};
        };
    };

    &main_uart3 {
        bluetooth {
            compatible = "marvell,sd8987-bt";
            firmware-ready = <&wifi_firmware>;
        };
    };


Matthias Schiffer (5):
  misc: introduce notify-device driver
  wireless: mwifiex: signal firmware readiness using notify-device
  bluetooth: hci_mrvl: select firmwares to load by match data
  bluetooth: hci_mrvl: add support for SD8987
  bluetooth: hci_mrvl: allow waiting for firmware load using
    notify-device

 drivers/bluetooth/hci_mrvl.c                |  77 ++++++++++++--
 drivers/misc/Kconfig                        |   4 +
 drivers/misc/Makefile                       |   1 +
 drivers/misc/notify-device.c                | 109 ++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.c |  14 +++
 drivers/net/wireless/marvell/mwifiex/main.h |   1 +
 include/linux/notify-device.h               |  33 ++++++
 7 files changed, 228 insertions(+), 11 deletions(-)
 create mode 100644 drivers/misc/notify-device.c
 create mode 100644 include/linux/notify-device.h

-- 
2.25.1

