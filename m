Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C712A67E6
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730714AbgKDPlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728380AbgKDPlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 10:41:06 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023CDC0613D3;
        Wed,  4 Nov 2020 07:41:06 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id v4so22933218edi.0;
        Wed, 04 Nov 2020 07:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SCsF/FbSj6nbVShumTDk6izo4ej98gBDvIxnGN9oxUw=;
        b=U/LuFwxZFBEzOLjq6xLBLgKo3e2n5Bw+X9W4UQrsEqm1UTW8KMniJThIR45B2O7dwz
         +awA0MNGZEDa7Al+nLWZeA6OznVqZ+Ly/Jw17SDSP6t0Ae/LtpICpzDfpJF8hp/Sds1z
         IyWFMCtpAgZP8Jw9mteObF3PJP9NM2Tx6FAQ8O9avA3OpVjOeAw/uqmdJkZVPdXm6ENK
         MIgVN4/RFC3H3UbJ5vkBJ7iYMxgtvMnCfoTVTezCsoBAOoHAnpWRFPTIiLeGk2P5f2pd
         VYW9R6qW6T3/owyzF2z1DfAg2jVJr0VU7ezLEURGgEJpBy/ePvX9YpcsuytPoPfhSq9V
         GEnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SCsF/FbSj6nbVShumTDk6izo4ej98gBDvIxnGN9oxUw=;
        b=hgg+9nHVcFtfQrwxOtvGMastTJTmjYB/pnl74CdMKBanB9YslxfyVnhAj+s6E7CHjV
         vBbONvL1R2VHRN4n8UEqsb3gz8irEjcxq5APg579kleE3YGRla/kUaYL9YnIonxjGq+M
         PAUlLTP6Qdnto9mEYOU1Ukgz6mhSGwLIWu/1rv6nw5et9O+gQ7WMKufWVjS3RoFcBN6L
         WKdY6PSFNcycFqLsGuEJp7nicKpUwkuptAx4Z1RAuGLP8rPe0F/b9EyMfmhEjZKCi3V1
         EbRP+Z4GVu6vFqD9Uh66f+2goFCatKVcrNqLW88vEBPS8+kP7RTQSjTBLHyl+QhfdSWy
         YxBw==
X-Gm-Message-State: AOAM532MH8gMeGmI2HSFq4Vqkrpph/MpjhoNLjl6bp0+NDYN95cuNKkY
        woQsn/LfmdSrBig2XY0TVAuJl5f58cBCfg==
X-Google-Smtp-Source: ABdhPJwSF+RY7HvwiVlmSYFlbNkfYZrvqSShAQSNDXYNvegOAC4bBugbPym4oP63itwWgiJ2gvZaeg==
X-Received: by 2002:aa7:ce8c:: with SMTP id y12mr28633429edv.185.1604504463857;
        Wed, 04 Nov 2020 07:41:03 -0800 (PST)
Received: from localhost.localdomain (host-87-7-71-164.retail.telecomitalia.it. [87.7.71.164])
        by smtp.gmail.com with ESMTPSA id y14sm1218548edo.69.2020.11.04.07.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 07:41:02 -0800 (PST)
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
Subject: [PATCH v8 0/3] Drivers: hv: vmbus: vmbus_requestor data structure for VMBus hardening
Date:   Wed,  4 Nov 2020 16:40:24 +0100
Message-Id: <20201104154027.319432-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This is a resubmission of:

  https://lkml.kernel.org/r/20200907161920.71460-1-parri.andrea@gmail.com

based on 5.10-rc2.

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
 drivers/hv/ring_buffer.c          |  28 ++++-
 drivers/net/hyperv/hyperv_net.h   |  13 +++
 drivers/net/hyperv/netvsc.c       |  22 ++--
 drivers/net/hyperv/rndis_filter.c |   1 +
 drivers/scsi/storvsc_drv.c        |  26 ++++-
 include/linux/hyperv.h            |  23 ++++
 8 files changed, 272 insertions(+), 18 deletions(-)

-- 
2.25.1

