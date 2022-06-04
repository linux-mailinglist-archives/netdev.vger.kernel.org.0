Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A6953D7CF
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 18:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238276AbiFDQcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 12:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238241AbiFDQcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 12:32:31 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0F32E9DE;
        Sat,  4 Jun 2022 09:32:30 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id z17so9429371pff.7;
        Sat, 04 Jun 2022 09:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rY6s6UKeLnm+D3xTqRvRX6JWn4apA8wvV2U2MEacJzA=;
        b=idvrIETV7qOZY97PHSWHUnCWf8gcAwnZBazj7jzwiTAFq/iWcJhMStIXw2SzjARl+6
         fdcOW5FzN7mofaD798x9KUgQOcGceIGvRGyVP3d9nE5l2EVvm/D3tEDS6jrDLSVj2UsZ
         +ewnoXqdZVP6nL+09YgX19tPi13WMZBgXqnfA7eOActNydhVIORH0vDuGVE3hUrAQzMS
         stuHCzwA92DrFbuIv69J9y2ST2eHmJEUeN+SfjpPT24XvzG/XuarQros4SldjtXroshR
         wqZ99PrLmH2aBtysRZghk13sUzXYlO4ubIdzQAGkNWIHInmXDjen6qMtIu2C0dF1vn+l
         ye5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=rY6s6UKeLnm+D3xTqRvRX6JWn4apA8wvV2U2MEacJzA=;
        b=spfm31x8OsyMCIWYIDlRX3KlSxvFX3NyxLi6ySArBccii6y5k2tD2Pihqwa/xYpA7H
         HwE4ZyBifFfmc7d/5nMrUJhdINISUBr4ANqaSFHRNN5Q0QiuIXhnnCPxxspwgJ9yp348
         XtJzL7ra+RVnoTt+M7zvpx1KQSk4WFhHLmdQ90IDeTJAfCYyuRBquwI9GmwLv9K2xV2H
         wI1KXsK5uO7NZuk2EU8Di7fTpl4FBW4Hy5S54Vu2B6Vzqqhx/M+G1vBTe5/rlJZk5xGr
         /ml3MysVOLZXCqvhA2xy0hqp4LxyOA7tcISWxUSG8FMGXCSu+dQAkTe6tcThJsLJ3Yny
         faUQ==
X-Gm-Message-State: AOAM530oYgVqGFCJRv0gy/Z62eKmFUYgsGrLOUfPBTu8mmruYbTJ3Fb1
        amC/tq3ETIkguDR2+JGC6sbOUfMZPc9oWg==
X-Google-Smtp-Source: ABdhPJwel/+bDRKY66D5kWyTVik9xKizDEUlOwYdxrZ+5hnFZbOtfV1kTAoIkMP0AfkggKe+xh8lTA==
X-Received: by 2002:a63:1c26:0:b0:3fc:602c:844d with SMTP id c38-20020a631c26000000b003fc602c844dmr13321006pgc.208.1654360349620;
        Sat, 04 Jun 2022 09:32:29 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id t8-20020a17090a3b4800b001e34b5ed5a7sm8424874pjf.35.2022.06.04.09.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 09:32:29 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 0/7] can: refactoring of can-dev module and of Kbuild
Date:   Sun,  5 Jun 2022 01:29:53 +0900
Message-Id: <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aside of calc_bittiming.o which can be configured with
CAN_CALC_BITTIMING, all objects from drivers/net/can/dev/ get linked
unconditionally to can-dev.o even if not needed by the user.

This series first goal it to split the can-dev modules so that the
user can decide which features get built in during
compilation. Additionally, the CAN Device Drivers menu is moved from
the "Networking support" category to the "Device Drivers" category
(where all drivers are supposed to be).

Below diagrams illustrate the changes made.
The arrow symbol "x --> y" denotes that "y depends on x".

* menu before this series *

CAN bus subsystem support
  symbol: CONFIG_CAN
  |
  +-> CAN Device Drivers
      (no symbol)
      |
      +-> software/virtual CAN device drivers
      |   (at time of writing: slcan, vcan, vxcan)
      |
      +-> Platform CAN drivers with Netlink support
          symbol: CONFIG_CAN_DEV
          |
          +-> CAN bit-timing calculation  (optional for hardware drivers)
          |   symbol: CONFIG_CAN_BITTIMING
          |
          +-> All other CAN devices

* menu after this series *

Network device support
  symbol: CONFIG_NETDEVICES
  |
  +-> CAN Device Drivers
      symbol: CONFIG_CAN_DEV
      |
      +-> software/virtual CAN device drivers
      |   (at time of writing: slcan, vcan, vxcan)
      |
      +-> CAN device drivers with Netlink support
          symbol: CONFIG_CAN_NETLINK (matches previous CONFIG_CAN_DEV)
          |
          +-> CAN bit-timing calculation (optional for all drivers)
          |   symbol: CONFIG_CAN_BITTIMING
          |
          +-> All other CAN devices not relying on RX offload
          |
          +-> CAN rx offload
              symbol: CONFIG_CAN_RX_OFFLOAD
              |
              +-> CAN devices relying on rx offload
                  (at time of writing: flexcan, m_can, mcp251xfd and ti_hecc)

Patches 1 to 5 of this series do above modification.

The last two patches add a check toward CAN_CTRLMODE_LISTENONLY in
can_dropped_invalid_skb() to discard tx skb (such skb can potentially
reach the driver if injected via the packet socket). In more details,
patch 6 moves can_dropped_invalid_skb() from skb.h to skb.o and patch
7 is the actual change.

Those last two patches are actually connected to the first five ones:
because slcan and v(x)can requires can_dropped_invalid_skb(), it was
necessary to add those three devices to the scope of can-dev before
moving the function to skb.o.

This design results from the lengthy discussion in [1].

[1] https://lore.kernel.org/linux-can/20220514141650.1109542-1-mailhol.vincent@wanadoo.fr/


** Changelog **

v4 -> v5:

  * m_can is also requires RX offload. Add the "select CAN_RX_OFFLOAD"
    to its Makefile.

  * Reorder the lines of drivers/net/can/dev/Makefile.

  * Remove duplicated rx-offload.o target in drivers/net/can/dev/Makefile

  * Remove the Nota Bene in the cover letter.


v3 -> v4:

  * Five additional patches added to split can-dev module and refactor
    Kbuild. c.f. below (lengthy) thread:
    https://lore.kernel.org/linux-can/20220514141650.1109542-1-mailhol.vincent@wanadoo.fr/


v2 -> v3:

  * Apply can_dropped_invalid_skb() to slcan.

  * Make vcan, vxcan and slcan dependent of CONFIG_CAN_DEV by
    modifying Kbuild.

  * fix small typos.

v1 -> v2:

  * move can_dropped_invalid_skb() to skb.c instead of dev.h

  * also move can_skb_headroom_valid() to skb.c

Vincent Mailhol (7):
  can: Kbuild: rename config symbol CAN_DEV into CAN_NETLINK
  can: Kconfig: turn menu "CAN Device Drivers" into a menuconfig using
    CAN_DEV
  can: bittiming: move bittiming calculation functions to
    calc_bittiming.c
  can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
  net: Kconfig: move the CAN device menu to the "Device Drivers" section
  can: skb: move can_dropped_invalid_skb() and can_skb_headroom_valid()
    to skb.c
  can: skb: drop tx skb if in listen only mode

 drivers/net/Kconfig                   |   2 +
 drivers/net/can/Kconfig               |  66 +++++++--
 drivers/net/can/dev/Makefile          |  17 ++-
 drivers/net/can/dev/bittiming.c       | 197 -------------------------
 drivers/net/can/dev/calc_bittiming.c  | 202 ++++++++++++++++++++++++++
 drivers/net/can/dev/dev.c             |   9 +-
 drivers/net/can/dev/skb.c             |  72 +++++++++
 drivers/net/can/m_can/Kconfig         |   1 +
 drivers/net/can/spi/mcp251xfd/Kconfig |   1 +
 include/linux/can/skb.h               |  59 +-------
 net/can/Kconfig                       |   5 +-
 11 files changed, 349 insertions(+), 282 deletions(-)
 create mode 100644 drivers/net/can/dev/calc_bittiming.c

-- 
2.35.1

