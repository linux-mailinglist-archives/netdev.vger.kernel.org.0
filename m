Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177BF35DFFB
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhDMN0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbhDMN0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 09:26:05 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB45C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:25:45 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k8so11918794pgf.4
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/S7/N5lEtSb7cWcsyefRu1pPHWTiPcaA2bM99wEcug=;
        b=B56qqb3Fy6xm++RAz5RuCbWEq5GSNebVydjkrDfrjZrWQAgTB5LyPXdFIBMp/NrJWD
         AHU3lOxfVAjHoE7CUavuCeh+e24vaBY/edsh8wuf31qo89tHjsoFMavrMnxoBp7RB3jZ
         gFYaiHVXlyRZvcEwHHM5wL7JePvzRNP+KejJr4PlJ8C0xfu6XcpINYA/wh/U3yHzAg7E
         rFFv7muUZb28qkbNlxfglVGEgjbRQJh45j8+b+cBttZu14HOUd055KqJ79gHqmjKwnuc
         M35QZUqeyirSb+iWNpfUEyw3++55mhZbqjrbMUK+DP9OKdUeS4M/ZrTVptAKBTdFXaJC
         7daw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/S7/N5lEtSb7cWcsyefRu1pPHWTiPcaA2bM99wEcug=;
        b=QHUmguqckFMtEo5HxpR5I0GS5dpfEjV/DrR4RGIJSTHYxOgPZ7x7HPVI5NiVi8gYd+
         msxyQ7FHl7hsYrHIerA1A36sYmVOEC6PoPbq3qhtbmhZ7a+CFampT8VqYuzW+Iofyj/D
         FkdTGrbTC6oS+9CP2A5v0FEa7ljgkKXcst6L9n3IfhsmghrMtaDG8A7ohaoS5xGl5KqZ
         MrBk9gwoz1QMlZE04MDmqmO3Xb72St7z0LcjLVhIPXZE9DHCc+l18+bJjqEODRX/th6j
         X4huVKTUloFx0PBvgUN9aYcbs4Obua2oRPMJhnSq2sUiHzgNJuZw9kV8eaOuBModQYIb
         Vdgw==
X-Gm-Message-State: AOAM532pzG/5fMYSOwWk9uIvkDSHXwgoBjbSX77kk3Vu8mR9BaYZdy1w
        694stMAFhmEWOsCFkqHtVVE=
X-Google-Smtp-Source: ABdhPJy4ALp8UXmpHeE+epeNsFczVQ45G/xPr2mP40W3AgVWCmGL3VWmOxHDS5L3EGt8dwWQCJ8HPw==
X-Received: by 2002:aa7:8d84:0:b029:1f8:3449:1bc6 with SMTP id i4-20020aa78d840000b02901f834491bc6mr28716988pfr.76.1618320345063;
        Tue, 13 Apr 2021 06:25:45 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id z18sm12417650pfa.39.2021.04.13.06.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 06:25:44 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/5] dpaa2-switch: add tc hardware offload on ingress traffic
Date:   Tue, 13 Apr 2021 16:24:43 +0300
Message-Id: <20210413132448.4141787-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

This patch set adds tc hardware offload on ingress traffic in
dpaa2-switch. The cls flower and matchall classifiers are supported
using the same ACL infrastructure supported by the dpaa2-switch.

The first patch creates a new structure to hold all the necessary
information related to an ACL table. This structure is used in the next
patches to create a link between each switch port and the table used.
Multiple ports can share the same ACL table when they also share the
ingress tc block. Also, some small changes in the priority of the
default STP trap is done in the second patch.

The support for cls flower is added in the 3rd patch, while the 4th
one builds on top of the infrastructure put in place and adds cls
matchall support.

The following flow keys are supported:
 - Ethernet: dst_mac/src_mac
 - IPv4: dst_ip/src_ip/ip_proto/tos
 - VLAN: vlan_id/vlan_prio/vlan_tpid/vlan_dei
 - L4: dst_port/src_port

Each filter can support only one action from the following list:
 - drop
 - mirred egress redirect
 - trap

With the last patch, we reuse the dpaa2_switch_acl_entry_add() function
added previously instead of open-coding the install of a new ACL entry
into the table.

Ioana Ciornei (5):
  dpaa2-switch: create a central dpaa2_switch_acl_tbl structure
  dpaa2-switch: install default STP trap rule with the highest priority
  dpaa2-switch: add tc flower hardware offload on ingress traffic
  dpaa2-switch: add tc matchall filter support
  dpaa2-switch: reuse dpaa2_switch_acl_entry_add() for STP frames trap

 drivers/net/ethernet/freescale/dpaa2/Makefile |   2 +-
 .../freescale/dpaa2/dpaa2-switch-flower.c     | 492 ++++++++++++++++++
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 363 ++++++++++---
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  64 ++-
 .../net/ethernet/freescale/dpaa2/dpsw-cmd.h   |   1 +
 drivers/net/ethernet/freescale/dpaa2/dpsw.c   |  35 ++
 drivers/net/ethernet/freescale/dpaa2/dpsw.h   |   3 +
 7 files changed, 893 insertions(+), 67 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c

-- 
2.30.0

