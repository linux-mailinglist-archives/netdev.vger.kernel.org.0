Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E25C2024DA
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgFTPn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgFTPn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:43:58 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DFCC06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:43:56 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x93so10103898ede.9
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bt5iE6Wh9q4V98HzZ0TOHpcxyzjtcqgi6892zkyHmkA=;
        b=UpLog3FgiKhAVBpN9tQFSW0NY+cNpmmrIfc6Zz5aqV4/KR/fsO7A+pyV+6CXBSPmN2
         FD3grVFtDQHSte/r23kxQFEvPXBoPFLqzbnX33ele65nCLXWB6SIAvD2w81ig5HM1ynf
         QKuKiyEtegnPB0cKPyob7rm3BYScNHo0ZsO9gOywbWbfD8Bwb6gsNwjbGcD95Q8oIYb+
         w4YNoGPlAhJxNXcWLSxK4YMm8vGcAw4+AR+nzNcgBpl/e09TZ0TZIGgpzxqxGemd+rs5
         X3mkq17s/FuyUcZQrlhxZPAE9mDnFNOjDtoV8lkiMHeEjVUegrGHQOlHYN8Py6qkJlZh
         i+kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bt5iE6Wh9q4V98HzZ0TOHpcxyzjtcqgi6892zkyHmkA=;
        b=iusNhbtL7u0I3Rsg56XrUfro6X+QY8KGNWL676nFthR4xe6aUvj4pAuNO5/mQ/fLf+
         7YXSMs/rn+4B5+RX82biMNYs+vqRhRunaiYHKLHg+QmwS1mOV5ubVmllS8qkz21Z0dsc
         ATGkupDpMAs6CIN+7bfhUGhpXs11EDQ3xd5vV/xQoqfkJIdMk6SQEMc7SQF6iXcyquOJ
         SnKTtvDgtADQ3JRgV1jsNx5wolpANdsBD0T1yjCFJ1mooXhvCkLeiaFBOcZugb6WgTkz
         Efg52LCI3vOYOl8bd0kcPtH8M3bbLGhxUoCqMBvDX1Ud801YxfSFJApvFOOsYyULlRoQ
         Vo6Q==
X-Gm-Message-State: AOAM530cvNZ1q0bWt5V/XuzRXgU8cDflE5E5pevXYHHMSqLF39cTd6YW
        A6pSwxRWujErZJ8pxRKgr2E=
X-Google-Smtp-Source: ABdhPJx/RNK0Ald7fWtFZlds2d/A0AKOoPz4J0JV9jJ7lzzF3+MqIAhFjHmrPOPZbDnJjX0fxWB6Cw==
X-Received: by 2002:aa7:cd16:: with SMTP id b22mr8623924edw.308.1592667834897;
        Sat, 20 Jun 2020 08:43:54 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id n25sm7721222edo.56.2020.06.20.08.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 08:43:54 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 00/12] Ocelot/Felix driver cleanup
Date:   Sat, 20 Jun 2020 18:43:35 +0300
Message-Id: <20200620154347.3587114-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Some of the code in the mscc felix and ocelot drivers was added while in
a bit of a hurry. Let's take a moment and put things in relative order.

First 3 patches are sparse warning fixes.

Patches 4-9 perform some further splitting between mscc_felix,
mscc_ocelot, and the common hardware library they share. Meaning that
some code is being moved from the library into just the mscc_ocelot
module.

Patches 10-12 refactor the naming conventions in the existing VCAP code
(for tc-flower offload), since we're going to be adding some more code
for VCAP IS1 (previous tentatives already submitted here:
https://patchwork.ozlabs.org/project/netdev/cover/20200602051828.5734-1-xiaoliang.yang_1@nxp.com/),
and that code would be confusing to read and maintain using current
naming conventions.

No functional modification is intended. I checked that the VCAP IS2 code
still works by applying a tc ingress filter with an EtherType key and
'drop' action.

Vladimir Oltean (12):
  net: dsa: felix: make vcap is2 keys and actions static
  net: mscc: ocelot: use plain int when interacting with TCAM tables
  net: mscc: ocelot: access EtherType using __be16
  net: mscc: ocelot: rename ocelot_board.c to ocelot_vsc7514.c
  net: mscc: ocelot: rename module to mscc_ocelot
  net: mscc: ocelot: convert MSCC_OCELOT_SWITCH into a library
  net: mscc: ocelot: rename MSCC_OCELOT_SWITCH_OCELOT to
    MSCC_OCELOT_SWITCH
  net: mscc: ocelot: move ocelot_regs.c into ocelot_vsc7514.c
  net: mscc: ocelot: move net_device related functions to ocelot_net.c
  net: mscc: ocelot: rename ocelot_ace.{c,h} to ocelot_vcap.{c,h}
  net: mscc: ocelot: generalize the "ACE/ACL" names
  net: mscc: ocelot: unexpose ocelot_vcap_policer_{add,del}

 drivers/net/dsa/ocelot/Kconfig                |    4 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        |    4 +-
 drivers/net/ethernet/mscc/Kconfig             |   22 +-
 drivers/net/ethernet/mscc/Makefile            |   16 +-
 drivers/net/ethernet/mscc/ocelot.c            |  913 +-------------
 drivers/net/ethernet/mscc/ocelot.h            |   46 +-
 drivers/net/ethernet/mscc/ocelot_board.c      |  626 ----------
 drivers/net/ethernet/mscc/ocelot_flower.c     |  146 +--
 drivers/net/ethernet/mscc/ocelot_net.c        | 1031 ++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_police.c     |   49 +-
 drivers/net/ethernet/mscc/ocelot_police.h     |   25 +-
 drivers/net/ethernet/mscc/ocelot_regs.c       |  450 -------
 drivers/net/ethernet/mscc/ocelot_tc.c         |  179 ---
 drivers/net/ethernet/mscc/ocelot_tc.h         |   22 -
 .../mscc/{ocelot_ace.c => ocelot_vcap.c}      |  336 +++---
 .../mscc/{ocelot_ace.h => ocelot_vcap.h}      |   88 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    | 1068 +++++++++++++++++
 include/soc/mscc/ocelot.h                     |    4 +-
 18 files changed, 2510 insertions(+), 2519 deletions(-)
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_board.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_net.c
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_regs.c
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_tc.c
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_tc.h
 rename drivers/net/ethernet/mscc/{ocelot_ace.c => ocelot_vcap.c} (77%)
 rename drivers/net/ethernet/mscc/{ocelot_ace.h => ocelot_vcap.h} (75%)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_vsc7514.c

-- 
2.25.1

