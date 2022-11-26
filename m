Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54CF639713
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 17:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiKZQWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 11:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKZQWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 11:22:35 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD2B6258;
        Sat, 26 Nov 2022 08:22:32 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id mv18so5970017pjb.0;
        Sat, 26 Nov 2022 08:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u0hxFFmy8oYwIx+3AY8R3T8lDZ42Z6Hf4DtqyJhNml8=;
        b=H5WP8UEekhWEksR7km+aNgxBCjgC8nZgcDTtUpuZRC7um3IvsdvfBKNNdYwDxO52BP
         oSzB5kWb0+4DPRMkqqc7jIX2RXGpcERhAlMBfe6w34ccY6AgkQY0oxZhiMkKwhef3hQN
         DlXcHVGexEd15lJOwpfjcWdWlEFH4xCnEA0Gkz/XwVM6IDJyFFwWQeuVHvn5cps40q9D
         w1t44y6qa5VTb0Nf7mLdA6BNTHgOnfELVG7gBBL+Em6NXFpTdDLLcAgtfLceOPdL4s3c
         9+G11YyJOzD8xMPFubse2+COdvUtp4KxDOdfHwrDpWqUqCzPLnJO4KWEjGk0UhVrTZCm
         dwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u0hxFFmy8oYwIx+3AY8R3T8lDZ42Z6Hf4DtqyJhNml8=;
        b=QAvn2ynTLTuclfsmYgq4bGY5R3C0cyli6O53uxvW6hda3vPfGIbjudk1WXWzMckMAM
         S7ubSDIDIV/DIwlK25q4XZ419zlqwvUHge3rw0NlGNnKhtNEFpbmnBRBufyqYIrvtgPr
         vD2l3mmy3TLINydkUs539ur2Veq+e2PFrysl8ZyD08Hpd2v/Dti0ohfwUHRXyNNxtcTS
         GE9Ap7KnNLVEp3GpT7i3s6xmSR20AVzBC0/aDeEFikbh81A4T0/7Aj9eahovCXPu4NY/
         ob0v1O1VQm+TuMMUSM6g5Korszf/Y9wcJWCkVzazszaRiajeImwZP2ZWcbRcfSAUvEHI
         dtRw==
X-Gm-Message-State: ANoB5plON5JtDxFCKDmLklZTYf5lJHOpLrTSqbkjz5OKmVYCl1knKamp
        88Pz08Wa/JQICwBqSmaCCnNbtQ5wzvX0jw==
X-Google-Smtp-Source: AA0mqf5bNsd6E6mvEeuWX94ikTWtkdsiayv+1UsA3MuozsoA9NENM0ycaW1MywRyURrKBl95LOZrBA==
X-Received: by 2002:a17:90a:3e4e:b0:218:7ee7:899a with SMTP id t14-20020a17090a3e4e00b002187ee7899amr41738267pjm.204.1669479751962;
        Sat, 26 Nov 2022 08:22:31 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id y14-20020a63e24e000000b00460ea630c1bsm4169601pgj.46.2022.11.26.08.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Nov 2022 08:22:31 -0800 (PST)
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
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 0/6] can: etas_es58x: report firmware, bootloader and hardware version
Date:   Sun, 27 Nov 2022 01:22:05 +0900
Message-Id: <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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
devlink. In addition, the firmware version is also reported through
ethtool.

---
* Changelog *

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

Vincent Mailhol (6):
  USB: core: export usb_cache_string()
  can: etas_es58x: add devlink support
  can: etas_es58x: export product information through
    devlink_ops::info_get()
  can: etas_es58x: remove es58x_get_product_info()
  can: etas_es58x: report the firmware version through ethtool
  Documentation: devlink: add devlink documentation for the etas_es58x
    driver

 .../networking/devlink/etas_es58x.rst         |  33 +++
 MAINTAINERS                                   |   1 +
 drivers/net/can/usb/Kconfig                   |   1 +
 drivers/net/can/usb/etas_es58x/Makefile       |   2 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c   |  85 +++----
 drivers/net/can/usb/etas_es58x/es58x_core.h   |  73 ++++++
 .../net/can/usb/etas_es58x/es58x_devlink.c    | 207 ++++++++++++++++++
 drivers/usb/core/message.c                    |   1 +
 drivers/usb/core/usb.h                        |   1 -
 include/linux/usb.h                           |   1 +
 10 files changed, 352 insertions(+), 53 deletions(-)
 create mode 100644 Documentation/networking/devlink/etas_es58x.rst
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_devlink.c

-- 
2.37.4

