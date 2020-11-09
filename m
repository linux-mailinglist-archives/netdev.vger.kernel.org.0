Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D412AB453
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgKIKEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbgKIKEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 05:04:22 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A82C0613CF;
        Mon,  9 Nov 2020 02:04:22 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id p19so5110414wmg.0;
        Mon, 09 Nov 2020 02:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r4nJVMcVXyeSNGliK+OKnPS1DW/M6pE2tauCbHrhVNg=;
        b=sv8VDD99EDQKRUHHYWhNzmvr29ToOfjGdwAkmf45K7JwkiCC4hz/umidSte2zIE46g
         imH8ms3hAFSjABW11LgmgAzg0k/2BAEc+8lefRQa1mdrC6HLXhpfFY1m/IVOeVyXQC3+
         mg2jfbgyrolcY02WmhBtAABl8P/jvm9NCywhjwCCnyF1Wt8bhvH8tz8T77ujSx9nOSjc
         MZBbmmwr10lzn+SPK7vK9G1MfiV5uzDsBacdF1W7SOzlUJYl1xAmFquS8HjMMs3PT7JX
         c14Mt+0tImqEfvvYGkMcVrZbpPp46hzleSYCql+q0cmNI02yOzP4FGSkXtX+2lBTF070
         OZ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r4nJVMcVXyeSNGliK+OKnPS1DW/M6pE2tauCbHrhVNg=;
        b=t15Hrdbd33AR4+D82zYPzvNgTj/s4qm1khvjjxfoJO8HjjDOZH56RHPCK+RKd71fuF
         /aIPFrO7w994LpHm+NBBPr1DqXYT8FGonaMgC4AzKowM9BoVtSctmtCrr7OMzc4n1g+i
         c341NP5MYpvDSVNtr945IM9dnCi/EAxVU5ImWRY0XiBQMgDJayJyOZQyhdW3cKDDTKVX
         XbNJAfbaSVKcqIvt4I7tUiPeKOszzYMfFNkOQM0dduMuSuP2l8NokjA6Ejr5ZqmEjtEx
         HVZpSEPFE+WhvniPquqFKLCmoZXChS3UJcH8VTV1KAJu/JoerF99d+5a/Ockz0sa1Vus
         yg/g==
X-Gm-Message-State: AOAM531pjh5+wK/MJHp09Fvvg7mJCS+E4Ct+joNe9BLuVHu1MgGZpABa
        N+qlz3JM8TRGGO4LvnDMa1V+7t7UeoRSxg==
X-Google-Smtp-Source: ABdhPJylkCLm47ZABGOmnUFDl+mj6x3wCSK8hVbNgoKK/Su8yYiWSfdWD+UkSyp4HGAsa7gUh6Qm0A==
X-Received: by 2002:a1c:9950:: with SMTP id b77mr13601643wme.123.1604916260448;
        Mon, 09 Nov 2020 02:04:20 -0800 (PST)
Received: from localhost.localdomain (host-95-245-157-54.retail.telecomitalia.it. [95.245.157.54])
        by smtp.gmail.com with ESMTPSA id 71sm13117885wrm.20.2020.11.09.02.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 02:04:19 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org,
        Andres Beltran <lkmlabelt@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v9 0/3] Drivers: hv: vmbus: vmbus_requestor data structure for VMBus hardening
Date:   Mon,  9 Nov 2020 11:03:59 +0100
Message-Id: <20201109100402.8946-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, VMbus drivers use pointers into guest memory as request IDs
for interactions with Hyper-V. To be more robust in the face of errors
or malicious behavior from a compromised Hyper-V, avoid exposing
guest memory addresses to Hyper-V. Also avoid Hyper-V giving back a
bad request ID that is then treated as the address of a guest data
structure with no validation. Instead, encapsulate these memory
addresses and provide small integers as request IDs.

The first patch creates the definitions for the data structure, provides
helper methods to generate new IDs and retrieve data, and
allocates/frees the memory needed for vmbus_requestor.

The second and third patches make use of vmbus_requestor to send request
IDs to Hyper-V in storvsc and netvsc respectively.

The series is based on 5.10-rc3.  Changelog in the actual patches.

  Andrea

Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-scsi@vger.kernel.org
Cc: netdev@vger.kernel.org

Andres Beltran (3):
  Drivers: hv: vmbus: Add vmbus_requestor data structure for VMBus
    hardening
  scsi: storvsc: Use vmbus_requestor to generate transaction IDs for
    VMBus hardening
  hv_netvsc: Use vmbus_requestor to generate transaction IDs for VMBus
    hardening

 drivers/hv/channel.c              | 174 ++++++++++++++++++++++++++++--
 drivers/hv/hyperv_vmbus.h         |   3 +-
 drivers/hv/ring_buffer.c          |  29 ++++-
 drivers/net/hyperv/hyperv_net.h   |  13 +++
 drivers/net/hyperv/netvsc.c       |  22 ++--
 drivers/net/hyperv/rndis_filter.c |   1 +
 drivers/scsi/storvsc_drv.c        |  26 ++++-
 include/linux/hyperv.h            |  23 ++++
 8 files changed, 273 insertions(+), 18 deletions(-)

-- 
2.25.1

