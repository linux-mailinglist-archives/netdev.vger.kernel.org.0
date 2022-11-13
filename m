Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F003626D9D
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 05:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235104AbiKMECl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 23:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiKMECi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 23:02:38 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DA6DFA0;
        Sat, 12 Nov 2022 20:02:34 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gw22so7648377pjb.3;
        Sat, 12 Nov 2022 20:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aNSRPUO1v1OYkd49ueorKmsNQJVAAcCUYPFtGJiFcIg=;
        b=JTpfsZ0jn/PD0C35/LkjaBbGMoaWE3MXg98oU61ZKtOaUvnmhYkOcm5uuUuPVAbe8E
         qZ3zTlbJ13UwN8KEWcCPRoZcXKk6sdX8bO/RfYmuIxYhjHRtN2iqPJBQm3hTQqHX+FLP
         yImkWB9lVND4OXHkMIBVT/LJYThmLf+N8ArHGhQVCWT9zyiC4OkHt1GXck1VC1HPZG8u
         0qswhUyM22N0gBV3iOK0gWHJsrGVfYiUxN9UG0mXH7jIbzf88pN8RTrt+lDh8mo8pHc4
         aPYjbK5m3z/VzznjLB3Iu7qhnWhAjHbu/27kROjxik5HdXRbDjb7iX6uA8IULDQZKbYg
         ThAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aNSRPUO1v1OYkd49ueorKmsNQJVAAcCUYPFtGJiFcIg=;
        b=o7IHAy7jSdwnxGquoP3xH2RRvAwyU8M6t0v5PVBKLruQ9D0ynkGu6rpUYJbCCxrf9n
         J3QC91w552QszqSfuVggg7ufoL7MicZXa6pcTnb0yrpXR/blQkgClDP/VcpJw0+2gx65
         OF5vohuzqsgo6kJ/d/FLJKgKk2GvWUIsEUxc90lAYOuiKNt6nbY7+kgfolZ22pM1SXPD
         sY7dSiLEH81aNOPcJbll7N+mJNikZLY30ksplJ7XZ1PzJhkPu8V8xNnL2ABgf2KrnRRt
         wW5H5woqUSEW9v7Afn1wUqODf7Z7JkRRi8tw8d+gnTuDO0LSoHcm3dBHaaDhmrmfYo+2
         dA4g==
X-Gm-Message-State: ANoB5pnJn3YgCSZk/7jlvlYG8c81jowBZqWRlzY03BDFhXuk5qvvUVtb
        E2BUoMufSMz+OtXNefnTv/w=
X-Google-Smtp-Source: AA0mqf4/qaAdXICwWYKtgHRrE3yobAei9bI2c3f/qDckf95tp7Ej5g8/0czkS1vnOzLL/PZ7qSYC3A==
X-Received: by 2002:a17:902:e3d4:b0:188:53b9:f003 with SMTP id r20-20020a170902e3d400b0018853b9f003mr8500917ple.170.1668312153584;
        Sat, 12 Nov 2022 20:02:33 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a5ac500b00200461cfa99sm7122686pji.11.2022.11.12.20.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 20:02:33 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 0/3] can: etas_es58x: report firmware, bootloader and hardware version
Date:   Sun, 13 Nov 2022 13:01:05 +0900
Message-Id: <20221113040108.68249-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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
practise. Remove the kernel log and instead export all these in
sysfs. In addition, the firmware version is also reported through
ethtool.


* Changelog *

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

Vincent Mailhol (3):
  USB: core: export usb_cache_string()
  can: etas_es58x: export firmware, bootloader and hardware versions in
    sysfs
  can: etas_es58x: report firmware-version through ethtool

 drivers/net/can/usb/etas_es58x/Makefile      |   2 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c  |  70 ++----
 drivers/net/can/usb/etas_es58x/es58x_core.h  |  51 ++++
 drivers/net/can/usb/etas_es58x/es58x_sysfs.c | 231 +++++++++++++++++++
 drivers/usb/core/message.c                   |   1 +
 drivers/usb/core/usb.h                       |   1 -
 include/linux/usb.h                          |   1 +
 7 files changed, 309 insertions(+), 48 deletions(-)
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_sysfs.c

-- 
2.37.4

