Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013A128CB8F
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 12:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbgJMK0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 06:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbgJMK0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 06:26:46 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0ACC0613D0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:26:46 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id p3so323647pjd.0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hgC++MTV1b2C7KuOI+QX6kJ+XFUNYYxjfw5A6FCuBWQ=;
        b=XsMENkNojw8tiNLMpwerACrZDbfv46Cm1XXswBzo3henwfRJpn2n7CE+pX0xCxQIK5
         fRO2z9Ze5lN2qyF30EyrLWD32PLGe7muY/pvaY03bftOUSeCgkW7ebH0aVsWA6RT4sGY
         DoflzGXTfArjzXE/Vy0KOFqzv4Lykteyz7mDQINJMBSeW7JYorMiFeULLIElLamlqgTH
         reylsP7SOtHf4yPobPrraOxLg5o104acspzlH4OAFAzvJH9zPNbV7w9jxAO9G5+PxU+v
         Xz6hrDNyJnePSPc9UNzUFaS1STwUz+edsYf+xF/Hro/xDpXVKdUvZNJmHEn7KpwB3aZ8
         ti2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hgC++MTV1b2C7KuOI+QX6kJ+XFUNYYxjfw5A6FCuBWQ=;
        b=aQDpt68R9bNZPhyNK/1YDcWtytBq725wAomRnMzWxR9KAPdhvy9OJIUVU0OzCu9qhj
         2gAQUbvI38ttd7csrkbXiyGJ+Y2vqgpePxWaHMVQ5qkzsAsntqEP9nS8yL7jG4go2X1G
         2XG3rVuhjWhKFGuRaucLRVQvzPLE+/0gvgL432QhmUggcCTKcRpvWUpA2Oi7deDkAKAl
         F9xf71tXt+Pd6cMHMY2DnWcrps8Bx1dLp/eruF3OIhGcGXJOYXKCzP61rE1AMrsYvfvW
         bffbcozdfw0USyxCpX6MJIgfHGL9Xu16VHF+dUMp20Oiy1pANY7RJeMO/VL411VfO+Y2
         H8Cw==
X-Gm-Message-State: AOAM5334jw2IeMft5/Vk0mlJJlqs2NvIVW6cMhwUGYXfeRccH7N2wUFl
        7S3CK7itbG8j/SO206jv7ps=
X-Google-Smtp-Source: ABdhPJzobGHKi20glq6d11RPBLKr/p8uJQEVTJ8yar4Deq0yyqZjcd5mhOcnwucMENbuEh1EvViekw==
X-Received: by 2002:a17:90a:77c1:: with SMTP id e1mr24085132pjs.39.1602584805849;
        Tue, 13 Oct 2020 03:26:45 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id g4sm22034444pgj.15.2020.10.13.03.26.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 03:26:45 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     rsaladi2@marvell.com, sgoutham@marvell.com,
        Subbaraya Sundeep <sundeep.lkml@gmail.com>
Subject: [net-next PATCH 00/10] Support for OcteonTx2 98xx silcion
Date:   Tue, 13 Oct 2020 15:56:22 +0530
Message-Id: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sundeep.lkml@gmail.com>

OcteonTx2 series of silicons have multiple variants, the
98xx variant has two network interface controllers (NIX blocks)
each of which supports upto 100Gbps. Similarly 98xx supports
two crypto blocks (CPT) to double the crypto performance.
The current RVU drivers support a single NIX and
CPT blocks, this patchset adds support for multiple
blocks of same type to be active at the same time.

Also the number of serdes controllers (CGX) have increased
from three to five on 98xx. Each of the CGX block supports
upto 4 physical interfaces depending on the serdes mode ie
upto 20 physical interfaces. At a time each CGX block can
be mapped to a single NIX. The HW configuration to map CGX
and NIX blocks is done by firmware.

NPC has two new interfaces added NIX1_RX and NIX1_TX
similar to NIX0 interfaces. Also MCAM entries is increased
from 4k to 64k. To support the 64k entries extended set
is added in hardware which are at completely different
register offsets. Fortunately new constant registers
can be read to figure out the extended set is present
or not.


This patch set modifies existing AF and PF drivers
in below order to support 98xx:
- Prepare for supporting multiple blocks of same type.
  Functions which operate with block type to get or set
  resources count are modified to operate with block address
- Manage allocating and freeing LFs from new NIX1 and CPT1 RVU blocks.
- NIX block specific initialization and teardown for NIX1
- Based on the mapping set by Firmware, assign the NIX block
  LFs to a PF/VF.
- Multicast entries context is setup for NIX1 along with NIX0
- NPC changes to support extended set of MCAM entries, counters
  and NIX1 interfaces to NPC.
- All the mailbox changes required for the new blocks in 98xx.
- Since there are more CGX links in 98xx the hardcoded LBK
  link value needed by netdev drivers is not sufficient any
  more. Hence AF consumers need to get the number of all links
  and calculate the LBK link.
- Debugfs changes to display NIX1 contexts similar to NIX0
- Debugfs change to display mapping between CGX, NIX and PF.


Rakesh Babu (4):
  octeontx2-af: Manage new blocks in 98xx
  octeontx2-af: Initialize NIX1 block
  octeontx2-af: Display NIX1 also in debugfs
  octeontx2-af: Display CGX, NIX and PF map in debugfs.

Subbaraya Sundeep (6):
  octeontx2-af: Update get/set resource count functions
  octeontx2-af: Map NIX block from CGX connection
  octeontx2-af: Setup MCE context for assigned NIX
  octeontx2-af: Add NIX1 interfaces to NPC
  octeontx2-af: Mbox changes for 98xx
  octeontx2-pf: Calculate LBK link instead of hardcoding

 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  13 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   5 +
 drivers/net/ethernet/marvell/octeontx2/af/common.h |  10 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  19 +-
 .../ethernet/marvell/octeontx2/af/npc_profile.h    |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 361 ++++++++++++++++-----
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  26 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  15 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 223 ++++++++++---
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 199 +++++++++---
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 328 ++++++++++++++-----
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.c    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  87 ++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |   6 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   8 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   2 +
 16 files changed, 1008 insertions(+), 298 deletions(-)

-- 
2.7.4

