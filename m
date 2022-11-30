Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2012B63DC4F
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiK3RrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiK3RrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:47:15 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4546C52163;
        Wed, 30 Nov 2022 09:47:13 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so2978677pjo.3;
        Wed, 30 Nov 2022 09:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3N5Q6e+noIaCEVCaxbfUnFlF+ThohEHIJopf4VIMSyc=;
        b=S1/3uw3ywG3vphD7zeS2OydWptUTqs8mU98QrM46zbLPy15QW0548Ya8/9Ix5QnC7K
         vIIUBoxGnWriBbSa08uo4UKZwnTmXf8P1I9sDYSYNxVA9ORA/HHx/J8bvrnfg4z5nJGb
         LoqUD4F7GSA7Tyod7KYYSVu1PYGu8HY8VGzYUWwGTAs4bQCtbnmb4m3U+pgys8gVXdcM
         PTOiB2EjkI8McMEmT7wbHOkerNTBSBi7OXCqFEiTZrkz6rp8n8JhEOT9HrUwEBZ5Q+Gv
         J6NxEGBNeGqKJ5ANku35vWs7/OpGhglx5K9tadPAmYVXcgqi0mgl+dzdp41ffaKgEdvc
         +jPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3N5Q6e+noIaCEVCaxbfUnFlF+ThohEHIJopf4VIMSyc=;
        b=PlAraelGPWDBjxrWyKNDaiaj27MIPVSkx/V7CYxgl64DqAtj8bo7aoN4HI1caqDKBs
         9Z2g8e02iRHn4gaQpQ0BuYE5P9aeAxJgs4Ax/hc+9W/tlxYkfmYzIhYLDmca/FU/ocNM
         WTaLG8svJ7JwLqEWCOKGRHwJpPmUh651C3siPdCXHp7ogCv2JW1kDTdCidDCF14cYd/D
         U/Axdn+tPl0Ri0Oie7p3eQjqBlpYJq2i6TuA43arDEBYD06Ew2ZssvUWnyh7noYUXFQk
         uCwYHRgYvC/csHieuCQszNDn9sacb0jGmz/bfngSVr/1TjzQnnbImJr/y7LhqSNidhwa
         jlOw==
X-Gm-Message-State: ANoB5pmFs5GXL6fmcN0QucNayKFgC4EFlOaBvh88lA0dWpxIRs9D3GlN
        etmU0iYAIjF329fSjDqimK6SGlzR7Db3Aw==
X-Google-Smtp-Source: AA0mqf54bL8yQjYXXbnj3lTp5sn31uT7G2IToaiuVNnODJpC+YKhicE2YwWbOqBXVgzOXcxkRahW7g==
X-Received: by 2002:a17:90a:70c5:b0:218:985d:25a0 with SMTP id a5-20020a17090a70c500b00218985d25a0mr57153942pjm.168.1669830432290;
        Wed, 30 Nov 2022 09:47:12 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id p3-20020aa79e83000000b00574cdb63f03sm1714505pfq.144.2022.11.30.09.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 09:47:11 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 0/7] can: etas_es58x: report firmware, bootloader and hardware version
Date:   Thu,  1 Dec 2022 02:46:51 +0900
Message-Id: <20221130174658.29282-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of this series is to report the firmware version, the
bootloader version and the hardware revision of ETAS ES58x
devices.

These are already reported in the kernel log but this isn't best
practice. Remove the kernel log and instead export all these through
devlink. The devlink core automatically exports the firmware and the
bootloader version to ethtool, so no need to implement the
ethtool_ops::get_drvinfo() callback anymore.

Patch one and two implement the core support for devlink (at device
level) and devlink port (at the network interface level).

Patch three export usb_cache_string() and patch four add a new info
attribute to devlink.h. Both are prerequisites for patch five.

Patch five is the actual goal: it parses the product information from
a custom usb string returned by the device and expose them through
devlink.

Patch six removes the product information from the kernel log.

Finally, patch seven add a devlink documentation page with list all
the information attributes reported by the driver.


* Sample outputs following this series *

| $ devlink dev info 
| usb/1-9:1.1:
|   serial_number 0108954
|   versions:
|       fixed:
|         board.rev B012/000
|       running:
|         fw 04.00.01
|         fw.bootloader 02.00.00

| $ devlink port show can0
| usb/1-9:1.1/0: type eth netdev can0 flavour physical port 0 splittable false

| $ ethtool -i can0
| driver: etas_es58x
| version: 6.1.0-rc7+
| firmware-version: 04.00.01 02.00.00 
| expansion-rom-version: 
| bus-info: 1-9:1.1
| supports-statistics: no
| supports-test: no
| supports-eeprom-access: no
| supports-register-dump: no
| supports-priv-flags: no

---
* Changelog *

v4 -> v5:

  * [PATH 2/7] add devlink port support. This extends devlink to the
    network interface.

  * thanks to devlink port, 'ethtool -i' is now able to retrieve the
    firmware version from devlink. No need to implement the
    ethtool_ops::get_drvinfo() callback anymore: remove one patch from
    the series.

  * [PATCH 4/7] A new patch to add a new info attribute for the
    bootloader version in devlink.h. This patch was initially sent as
    a standalone patch here:
      https://lore.kernel.org/netdev/20221129031406.3849872-1-mailhol.vincent@wanadoo.fr/
    Merging it to this series so that it is both added and used at the
    same time.

  * [PATCH 5/7] use the newly info attribute defined in patch 4/7 to
    report the bootloader version instead of the custom string "bl".

  * [PATCH 5/7] because the series does not implement
    ethtool_ops::get_drvinfo() anymore, the two helper functions
    es58x_sw_version_is_set() and es58x_hw_revision_is_set() are only
    used in devlink.c. Move them from es58x_core.h to es58x_devlink.c.

  * [PATCH 5/7] small rework of the helper function
    es58x_hw_revision_is_set(): it is OK to only check the letter (if
    the letter is '\0', it will not be possible to print the next
    numbers).

  * [PATCH 5/7 and 6/7] add reviewed-by Andrew Lunn tag.

  * [PATCH 7/7] Now, 'ethtool -i' reports both the firmware version
    and the bootloader version (this is how the core export the
    information from devlink to ethtool). Update the documentation to
    reflect this fact.

  * Reoder the patches.

v3 -> v4:

  * major rework to use devlink instead of sysfs following Andrew's
    comment.

  * split the series in 6 patches.

  * [PATCH 1/6] add Acked-by: Greg Kroah-Hartman

v2 -> v3:

  * patch 2/3: do not spam the kernel log anymore with the product
    number. Instead parse the product information string, extract the
    firmware version, the bootloadar version and the hardware revision
    and export them through sysfs.

  * patch 2/3: rework the parsing in order not to need additional
    fields in struct es58x_parameters.

  * patch 3/3: only populate ethtool_drvinfo::fw_version because since
    commit edaf5df22cb8 ("ethtool: ethtool_get_drvinfo: populate
    drvinfo fields even if callback exits"), there is no need to
    populate ethtool_drvinfo::driver and ethtool_drvinfo::bus_info in
    the driver.

v1 -> v2:

  * was a single patch. It is now a series of three patches.
  * add a first new patch to export  usb_cache_string().
  * add a second new patch to apply usb_cache_string() to existing code.
  * add missing check on product info string to prevent a buffer overflow.
  * add comma on the last entry of struct es58x_parameters.

Vincent Mailhol (7):
  can: etas_es58x: add devlink support
  can: etas_es58x: add devlink port support
  USB: core: export usb_cache_string()
  net: devlink: add DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER
  can: etas_es58x: export product information through
    devlink_ops::info_get()
  can: etas_es58x: remove es58x_get_product_info()
  Documentation: devlink: add devlink documentation for the etas_es58x
    driver

 .../networking/devlink/devlink-info.rst       |   5 +
 .../networking/devlink/etas_es58x.rst         |  36 +++
 MAINTAINERS                                   |   1 +
 drivers/net/can/usb/Kconfig                   |   1 +
 drivers/net/can/usb/etas_es58x/Makefile       |   2 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c   |  98 +++-----
 drivers/net/can/usb/etas_es58x/es58x_core.h   |  50 ++++
 .../net/can/usb/etas_es58x/es58x_devlink.c    | 235 ++++++++++++++++++
 drivers/usb/core/message.c                    |   1 +
 drivers/usb/core/usb.h                        |   1 -
 include/linux/usb.h                           |   1 +
 include/net/devlink.h                         |   2 +
 12 files changed, 372 insertions(+), 61 deletions(-)
 create mode 100644 Documentation/networking/devlink/etas_es58x.rst
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_devlink.c

-- 
2.37.4

