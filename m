Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DA229E50F
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731043AbgJ2HvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbgJ2HYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:47 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D85C0613B7
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:06 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id w21so1373747pfc.7
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=g10a5OajNED9wd0MQhu5bDOa9p3onZ6ZxUk5xH+bIE4=;
        b=bGR2O2cEHaU/KKxP84Bfc4DxQUrLF1GvPa+HFB6QS8Zk+mATrBIRczf1M+4w0qgXct
         9YC6ACeo2CwrBc8Ay7mGrQWHbmaz8yipDgefoRORaDPnteIOT1+RLo2TvVojbqvWBuTC
         rWZIwwdJGy5s9V354+EfvkgfkoyXn0AIJkWkB9HrHZy/Rsjbaa94L/WoppIorF+MGMb2
         YpL848QRlNYaznnKNvPiXQzMRjW37/j1jjQ6CdHXy69mvWhV5hVRX17VhuTQgbZ6Y7xk
         ifNkxWElkDUVqS6H/LCsXOV7EmX/K8rb/Xznz4a9vvxzASJvDKaE9WNLgN3UbU8USmrp
         Hs+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=g10a5OajNED9wd0MQhu5bDOa9p3onZ6ZxUk5xH+bIE4=;
        b=PsvZU2ojIH9BtotWu4ZSlw0nN+G4vIso4/FL5WBUFdWps4/F5WgelFDS8xMU/hVJdH
         ht8kCv4qd3Qj3iolDDcduTmRLoL/PJalL+eCk1x8KirCsOboJ5e88K8HFoiAjSFzXehe
         9qLwSTf9TZrYdgpJcM8Mr5jRyAbfCFVVnPlNfrSCgep/MJ92QNTJF9YgWwrbMSTGiAsQ
         xqiKP665drBJF7F+nmlrZfqLM4N0IuU9Px7eQJD3ej1eCJ6F/2da4O3od0Lv6gsF7xAD
         7BRcS9K6UfSD6EckEkoSz9kUZzn6QltILRjUS8yQCdmCSEgj9gvyMwY8ozFioMF35JG3
         wnNg==
X-Gm-Message-State: AOAM530L4gyySXZOv+t3hPWYA5U5MDEvTqqayO3qtZePJsm7rUX1fRat
        REZJcwoY2+iJk68v8vzgh7WvfQ6igQhtew==
X-Google-Smtp-Source: ABdhPJy42n9YKbWqFSqfETlfF3cewRH9mmsV0aZXpnULOtUs+JiHIvz06cuarU8hj4m70nVIWDamnw==
X-Received: by 2002:a63:4825:: with SMTP id v37mr2531977pga.256.1603948564668;
        Wed, 28 Oct 2020 22:16:04 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id k7sm1292242pfa.184.2020.10.28.22.16.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Oct 2020 22:16:03 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        netdev@vger.kernel.org
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [v2 net-next PATCH 00/10] Support for OcteonTx2 98xx silcion
Date:   Thu, 29 Oct 2020 10:45:39 +0530
Message-Id: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

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
from 4k to 16k. To support the 16k entries extended set
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

v2:
  Resending since net-next is open now


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

