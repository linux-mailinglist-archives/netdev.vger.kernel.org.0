Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886A058391B
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbiG1HDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbiG1HDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:03:05 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E30E5B07E
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:03:04 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id m8so991506edd.9
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nZj3FVBxKWQWzHTUYRIyjL/IBGzy/vAn7ewqW8rjIR8=;
        b=f42OwsnT9wKcuVY475gVHsDYoCC+OpxajdHImL51yEdpxocd54QorII/uh321iNpLk
         nLzhzKik/RBXK7v8IqV8/Hl2BBivmFYt6C3YbZkMb5De1EsaghddRpvezeo7iPAsSbaM
         tBOoksUhxbYP25RqcVchxS9d83sorUiPYZO4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nZj3FVBxKWQWzHTUYRIyjL/IBGzy/vAn7ewqW8rjIR8=;
        b=xAPjyD8Z4mk9Hmro2hNc+TwA7RO8ON5cosNBIwWrhW1knvhsQcvq9YqwTboJIM8CcO
         aY3Frgsl1fJzNKGuVIcov7M8eh7fdCkHDO8yBI5gaASBL5mmk8cl9U8hgtXHkHzEacbc
         deD4VD6lOPaBkBZKLlZEs5lx40VB7En9/jTYbwGmYwHzKvtnCIeuZ2EaJrobA6EsAzhR
         0WTBxl4E+Cmzs/SBaLTCYCTPmu/Dk5wxNfq+Rmnyy0pmMiPnY4018NJgPFHnI8dqcfo8
         ndLFqx9XNyWJJSDu/iYbK8fNLV+YwzEDU2JtK/tB2nBIaWmgglE7dwM82Qv8mEmnzgFX
         Gitw==
X-Gm-Message-State: AJIora9IWeCwNRESUb8PO7sZXRPaKyqWP7fM87fCwg5xsm7KCiBhz6hy
        USNyqOa9jfOIeSNLJLBa/awG9A==
X-Google-Smtp-Source: AGRyM1vBWERdkJYuFCNxqUjPJc6tZd0EdT40vckgqiOk0dpYdgduSquFN3g4x3mP+B35h84Pp+bUKA==
X-Received: by 2002:a05:6402:4016:b0:43a:f310:9522 with SMTP id d22-20020a056402401600b0043af3109522mr26262809eda.200.1658991782896;
        Thu, 28 Jul 2022 00:03:02 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-79-31-31-9.retail.telecomitalia.it. [79.31.31.9])
        by smtp.gmail.com with ESMTPSA id r18-20020aa7d152000000b0042de3d661d2sm154742edo.1.2022.07.28.00.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 00:03:02 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: [PATCH v4 0/7] can: slcan: extend supported features (step 2)
Date:   Thu, 28 Jul 2022 09:02:47 +0200
Message-Id: <20220728070254.267974-1-dario.binacchi@amarulasolutions.com>
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

Changes in v4:
- Add Max Staudt's `Reviewed-by' tag.
- Drop the patch "ethtool: add support to get/set CAN bit time register".
- Drop the patch "can: slcan: add support to set bit time register (btr)".
- Remove the RFC prefix from the series.

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

Dario Binacchi (6):
  can: slcan: remove useless header inclusions
  can: slcan: remove legacy infrastructure
  can: slcan: change every `slc' occurrence in `slcan'
  can: slcan: use the generic can_change_mtu()
  can: slcan: add support for listen-only mode
  MAINTAINERS: Add maintainer for the slcan driver

Vincent Mailhol (1):
  can: slcan: use KBUILD_MODNAME and define pr_fmt to replace hardcoded
    names

 MAINTAINERS                        |   6 +
 drivers/net/can/slcan/slcan-core.c | 459 +++++++++--------------------
 2 files changed, 144 insertions(+), 321 deletions(-)

-- 
2.32.0

