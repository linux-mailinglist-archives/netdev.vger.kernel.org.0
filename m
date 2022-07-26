Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6D1581B77
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 23:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239312AbiGZVD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 17:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiGZVD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 17:03:27 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C922CE2D
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:03:25 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bp15so28288602ejb.6
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/Fix0ZZRTMX4dxRXPKnOmcw0/YjyjkpPTfrxJEvmQ4k=;
        b=FTfM21nXEhHg2f8iPQNXpgPVJtjKJh6CWrgnOeZPrXrjEhfiEiUijbyPWBpJ+8n4+W
         Ocmun4adiTy37fjtMjLHLL4ks+ORQWEXed8BCfxgMjPC7F9JUYC6HsdZ7ULO20uVhLHV
         eQtjq4wyNZbT2ISo+NysRfBFvLv5epV751x4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/Fix0ZZRTMX4dxRXPKnOmcw0/YjyjkpPTfrxJEvmQ4k=;
        b=QS6fBoORk2Jhg6IeMauY0mEU/OyCePGdEGPL+45nmA/110fjGZ/rQ6fB0AqWrSWX3j
         mFnRncYQsHVrzMAd8/mZUjNTJSAcAR+RUGLFubD9RplILxK6Jn0NQfC2F64xHGaNRZ9o
         Nu/zAWQ3PeDgwAyJXku+G+R3I8r/PLq4B0sbBNga1OzT0H8GTgHfJ+8kaLpjgdo/a6YX
         g0t+8IGjQNVu/c2NUAGI1DNhJ5f95x40hWzZ8I6fqYae6dViG9wDrVZcziHXymF4M4Id
         sl39M/mIruBjLjftep3k6Bqs9BXtOWRLcXCRsAwoCBhqxSxyQhb5KjcysL6gCCRB+w89
         wiIg==
X-Gm-Message-State: AJIora/V9l3UhsSiNOCVgO4UfSSccr3eXvrgcc6WNTsfwu3iIlLKbCb8
        zpTSL4Rb/t/UhGInk574d5icoQ==
X-Google-Smtp-Source: AGRyM1v4xl1rfOBKqE3/bYUDthCvWJ6l+y4YoDodnW7VXZEl6q+teDw/Z3IadP8uylt+rwPRVyTsjg==
X-Received: by 2002:a17:907:6890:b0:72e:dc8f:ad42 with SMTP id qy16-20020a170907689000b0072edc8fad42mr14787713ejc.683.1658869403619;
        Tue, 26 Jul 2022 14:03:23 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-87-14-98-67.retail.telecomitalia.it. [87.14.98.67])
        by smtp.gmail.com with ESMTPSA id y19-20020aa7d513000000b0043a7293a03dsm9092849edq.7.2022.07.26.14.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 14:03:22 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Hao Chen <chenhao288@hisilicon.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Tom Rix <trix@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Yufeng Mo <moyufeng@huawei.com>, netdev@vger.kernel.org
Subject: [RFC PATCH v3 0/9] can: slcan: extend supported features (step 2)
Date:   Tue, 26 Jul 2022 23:02:08 +0200
Message-Id: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this series I try to finish the task, started with the series [1],
of completely removing the dependency of the slcan driver from the
userspace slcand/slcan_attach applications.

The series also contains patches that remove the legacy stuff (slcan_devs,
SLCAN_MAGIC, ...) and do some module cleanup.

The series has been created on top of the patches:

can: slcan: convert comments to network style comments
can: slcan: slcan_init() convert printk(LEVEL ...) to pr_level()
can: slcan: fix whitespace issues
can: slcan: convert comparison to NULL into !val
can: slcan: clean up if/else
can: slcan: use scnprintf() as a hardening measure
can: slcan: do not report txerr and rxerr during bus-off
can: slcan: do not sleep with a spin lock held

applied to linux-next.

[1] https://lore.kernel.org/all/20220628163137.413025-1-dario.binacchi@amarulasolutions.com/

Changes in v3:
- Update the commit message.
- Use 1 space in front of the =.
- Put the series as RFC again.
- Pick up the patch "can: slcan: use KBUILD_MODNAME and define pr_fmt to replace hardcoded names".
- Add the patch "ethtool: add support to get/set CAN bit time register"
  to the series.
- Add the patch "can: slcan: add support to set bit time register (btr)"
  to the series.
- Replace the link https://marc.info/?l=linux-can&m=165806705927851&w=2 with
  https://lore.kernel.org/all/507b5973-d673-4755-3b64-b41cb9a13b6f@hartkopp.net.
- Add the `Suggested-by' tag.

Changes in v2:
- Re-add headers that export at least one symbol used by the module.
- Update the commit description.
- Drop the old "slcan" name to use the standard canX interface naming.
- Remove comment on listen-only command.
- Update the commit subject and description.
- Add the patch "MAINTAINERS: Add myself as maintainer of the SLCAN driver"
  to the series.

Dario Binacchi (8):
  can: slcan: remove useless header inclusions
  can: slcan: remove legacy infrastructure
  can: slcan: change every `slc' occurrence in `slcan'
  can: slcan: use the generic can_change_mtu()
  can: slcan: add support for listen-only mode
  ethtool: add support to get/set CAN bit time register
  can: slcan: add support to set bit time register (btr)
  MAINTAINERS: Add maintainer for the slcan driver

Vincent Mailhol (1):
  can: slcan: use KBUILD_MODNAME and define pr_fmt to replace hardcoded
    names

 MAINTAINERS                           |   6 +
 drivers/net/can/slcan/slcan-core.c    | 515 +++++++++-----------------
 drivers/net/can/slcan/slcan-ethtool.c |  13 +
 drivers/net/can/slcan/slcan.h         |   1 +
 include/uapi/linux/ethtool.h          |   1 +
 net/ethtool/common.c                  |   1 +
 net/ethtool/ioctl.c                   |   1 +
 7 files changed, 204 insertions(+), 334 deletions(-)

-- 
2.32.0

