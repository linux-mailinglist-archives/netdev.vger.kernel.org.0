Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1EB25FE9D
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgIGQTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730448AbgIGQTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:19:38 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2979AC061573;
        Mon,  7 Sep 2020 09:19:38 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x14so16324037wrl.12;
        Mon, 07 Sep 2020 09:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VC4zobdVL9f1IObtPBVliyuUnIYG6v4DFmLKqvmd31Y=;
        b=Wc5H6/kIDY5mWYMQpWS0wD+CvzuNF7AkUVpvj7AJb0jOcajSzpEVQ9nMTMLnXv/RCc
         tjLp0vSmewbHQseS4GZNAL4H4+JI4Pau9HhLCo7qkzKytSIOhxjwj8uIiKKjo8ZrIAQ4
         2pd6MH/Xp7JBOwmeZFv9+5k0PQ+BNKSLpuPCNmy8PN8OT1KEcZhasM2q0G2FV1DuAsk/
         1tORDiLCqfkhkkV2OV1rW/Qvg1L5sm/hlgM6Y9wjY56DUhU+AlSJTChGoV53hDX98VeJ
         hjp+4K7UEGIYDdVNSVNOGMhdReiOlAAS6TDbd/plwxcX57YnlFLd1xCUtdTzjXm+u65R
         NdzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VC4zobdVL9f1IObtPBVliyuUnIYG6v4DFmLKqvmd31Y=;
        b=NjtSZ89wQ68VGMX+0FFPMEynSMRb4fOV62meVHLcJXEOUQeU7js2Qk5CR8JMQLA00I
         X7mEKFbe3LvJdqiKai6vEGiya1ZNO2CXTaJe7SaV7M8SXBJ8Or+0NF/n5ErS+mSSESRy
         RrPzEndH/ioBP217Xgx5KB0Org5OXiJqsWXL6mzi6jMHlOaKPdJOTVAzUIzOLexlQCzc
         c0E+tch3x31SJ3r7O+WSTa+gOLbC9MyOZ7baBkcimkcXmbywaw4tsdtXcWdifbtTMCbD
         OCmns9FvDax4I2geKnJnTK1NwDy6UWBEnGPS/13aKKjo+E33p1zqQ5bMAvFckLUya2JW
         vPlg==
X-Gm-Message-State: AOAM5331nkpELu6NvcyuXDn74TkRgCV40A4PmypuLhX+nUPv84yNCQws
        Qg5JKgeKUVYi9TS+KhYXMYhbTWWbmTR95qwJ
X-Google-Smtp-Source: ABdhPJyXjjnMiookPIAqzFwNKnDH4WV+wwMJVUV2twhyKG44oA0tI09a3Amr04Bx3rbc06XU4oTGbg==
X-Received: by 2002:a5d:40c7:: with SMTP id b7mr22488103wrq.300.1599495576113;
        Mon, 07 Sep 2020 09:19:36 -0700 (PDT)
Received: from localhost.localdomain (userh713.uk.uudial.com. [194.69.103.86])
        by smtp.gmail.com with ESMTPSA id y5sm19313717wrh.6.2020.09.07.09.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 09:19:35 -0700 (PDT)
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
Subject: [PATCH v7 0/3] Drivers: hv: vmbus: vmbus_requestor data structure for VMBus hardening
Date:   Mon,  7 Sep 2020 18:19:17 +0200
Message-Id: <20200907161920.71460-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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

This version of the series moves the allocation of the requst ID after
the data has been copied into the ring buffer in hv_ringbuffer_write()
to address a race with the request completion path pointed out by Juan.

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

