Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C9F333C5C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhCJMPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbhCJMP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:29 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3B0C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:28 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ox4so22631656ejb.11
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=70ar6MtM4I/ssnFLEWejVtLDarbaNeN6DESDTHNsN1k=;
        b=SoorARaQ2yLoQBjGEh4pyu8vzLetwyrAf/lKAyPkALWMIhyzSyf3jbUbmfE0pbX4Zp
         RlY8nvS5CSOH/mysgkuO5IN2c3iwjl0QgUW2tDoxLK32+aoPXXNbnWVySd+bJSv9HoZE
         bXGbVKOw0b6+4HvqC8dWkKc4vi2JARzqBbVjsNGmsH02xbezop0RM44fRN8gWUC/KW26
         OUQ9sCiTzyTH85pPrP/CtxHt4GE9SW/jorPvNjMidLeBX3B2IEzbYNpbHKuxuv4uGN9a
         kcouIIQh6DspnMGBdLCFPrjC8ZBf5aa0ZblHLAuXJGo0FQ2pt/BIGyq8y5HReFDIPtD1
         CA4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=70ar6MtM4I/ssnFLEWejVtLDarbaNeN6DESDTHNsN1k=;
        b=gfMBtDFi78uulK856i0MERnD8YYW2EOCF39FV7BYWA+GZHJdVX08ruqBHN1yMbJ9Qx
         Z9irIYu9pi0TfUfJp5ebGgyWpc0gnF58hmNcGoInFKz6J04pn7uFsmafJ1+lvo/CX8Qn
         eZt5907VMm99xAUE7odbWMwJxy1WTrL60rHORK9pDe0Y6sJE6S4+4At8mI/n/qozrx9m
         /lS4n8WOfzhKE6CVZ4wZM/1c4IvN7Yzhv3Hz9NTXAGxRVq16sMQQ7RWbtmEHzSYF13A/
         ATC4mkRTJDf+RAWixY+/xMpbTMRphennrIbBeNqNGjHPtDugY6mbgY0ZjeBgY1sPuHH9
         tihg==
X-Gm-Message-State: AOAM533A1nQZ9TICklZkfhPXBVVf4CDFRaRDNGAH8kvKHe8G11iCOylk
        mZGQK0ohXV6iwY2hEPKg24E=
X-Google-Smtp-Source: ABdhPJzcgOXdzJLLshyOnX0n04zynzn9Jxt1PAOc1GcqQ4hHHG7i9MfzvVYoKa5ecljidWHiYf0u5A==
X-Received: by 2002:a17:906:405b:: with SMTP id y27mr3420215ejj.332.1615378527502;
        Wed, 10 Mar 2021 04:15:27 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:26 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 00/15] dpaa2-switch: CPU terminated traffic and move out of staging
Date:   Wed, 10 Mar 2021 14:14:37 +0200
Message-Id: <20210310121452.552070-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

This patch set adds support for Rx/Tx capabilities on DPAA2 switch port
interfaces as well as fixing up some major blunders in how we take care
of the switching domains. The last patch actually moves the driver out
of staging now that the minimum requirements are met.

I am sending this directly towards the net-next tree so that I can use
the rest of the development cycle adding new features on top of the
current driver without worrying about merge conflicts between the
staging and net-next tree.

The control interface is comprised of 3 queues in total: Rx, Rx error
and Tx confirmation. In this patch set we only enable Rx and Tx conf.
All switch ports share the same queues when frames are redirected to the
CPU.  Information regarding the ingress switch port is passed through
frame metadata - the flow context field of the descriptor.

NAPI instances are also shared between switch net_devices and are
enabled when at least on one of the switch ports .dev_open() was called
and disabled when no switch port is still up.

Since the last version of this feature was submitted to the list, I
reworked how the switching and flooding domains are taken care of by the
driver, thus the switch is now able to also add the control port (the
queues that the CPU can dequeue from) into the flooding domains of a
port (broadcast, unknown unicast etc). With this, we are able to receive
and sent traffic from the switch interfaces.

Also, the capability to properly partition the DPSW object into multiple
switching domains was added so that when not under a bridge, the ports
are not actually capable to switch between them. This is possible by
adding a private FDB table per switch interface.  When multiple switch
interfaces are under the same bridge, they will all use the same FDB
table.

Another thing that is fixed in this patch set is how the driver handles
VLAN awareness. The DPAA2 switch is not capable to run as VLAN unaware
but this was not reflected in how the driver responded to requests to
change the VLAN awareness. In the last patch, this is fixed by
describing the switch interfaces as Rx VLAN filtering on [fixed] and
declining any request to join a VLAN unaware bridge.


Ioana Ciornei (15):
  staging: dpaa2-switch: remove broken learning and flooding support
  staging: dpaa2-switch: fix up initial forwarding configuration done by
    firmware
  staging: dpaa2-switch: remove obsolete .ndo_fdb_{add|del} callbacks
  staging: dpaa2-switch: get control interface attributes
  staging: dpaa2-switch: setup buffer pool and RX path rings
  staging: dpaa2-switch: setup dpio
  staging: dpaa2-switch: handle Rx path on control interface
  staging: dpaa2-switch: add .ndo_start_xmit() callback
  staging: dpaa2-switch: enable the control interface
  staging: dpaa2-switch: properly setup switching domains
  staging: dpaa2-switch: move the notifier register to module_init()
  staging: dpaa2-switch: accept only vlan-aware upper devices
  staging: dpaa2-switch: add fast-ageing on bridge leave
  staging: dpaa2-switch: prevent joining a bridge while VLAN uppers are
    present
  staging: dpaa2-switch: move the driver out of staging

 MAINTAINERS                                   |    6 +-
 drivers/net/ethernet/freescale/dpaa2/Kconfig  |    8 +
 drivers/net/ethernet/freescale/dpaa2/Makefile |    2 +
 .../freescale/dpaa2/dpaa2-switch-ethtool.c}   |    2 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c}  | 1704 +++++++++++++----
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  178 ++
 .../ethernet/freescale/dpaa2}/dpsw-cmd.h      |  128 +-
 .../ethernet/freescale/dpaa2}/dpsw.c          |  328 +++-
 .../ethernet/freescale/dpaa2}/dpsw.h          |  199 +-
 drivers/staging/Kconfig                       |    2 -
 drivers/staging/Makefile                      |    1 -
 drivers/staging/fsl-dpaa2/Kconfig             |   19 -
 drivers/staging/fsl-dpaa2/Makefile            |    6 -
 drivers/staging/fsl-dpaa2/ethsw/Makefile      |   10 -
 drivers/staging/fsl-dpaa2/ethsw/README        |  106 -
 drivers/staging/fsl-dpaa2/ethsw/TODO          |   13 -
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h       |   80 -
 17 files changed, 2097 insertions(+), 695 deletions(-)
 rename drivers/{staging/fsl-dpaa2/ethsw/ethsw-ethtool.c => net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c} (99%)
 rename drivers/{staging/fsl-dpaa2/ethsw/ethsw.c => net/ethernet/freescale/dpaa2/dpaa2-switch.c} (51%)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
 rename drivers/{staging/fsl-dpaa2/ethsw => net/ethernet/freescale/dpaa2}/dpsw-cmd.h (76%)
 rename drivers/{staging/fsl-dpaa2/ethsw => net/ethernet/freescale/dpaa2}/dpsw.c (83%)
 rename drivers/{staging/fsl-dpaa2/ethsw => net/ethernet/freescale/dpaa2}/dpsw.h (73%)
 delete mode 100644 drivers/staging/fsl-dpaa2/Kconfig
 delete mode 100644 drivers/staging/fsl-dpaa2/Makefile
 delete mode 100644 drivers/staging/fsl-dpaa2/ethsw/Makefile
 delete mode 100644 drivers/staging/fsl-dpaa2/ethsw/README
 delete mode 100644 drivers/staging/fsl-dpaa2/ethsw/TODO
 delete mode 100644 drivers/staging/fsl-dpaa2/ethsw/ethsw.h

-- 
2.30.0

