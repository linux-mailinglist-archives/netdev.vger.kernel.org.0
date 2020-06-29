Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF8F20DB0A
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388715AbgF2UC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388703AbgF2UCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:02:53 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704B3C061755;
        Mon, 29 Jun 2020 13:02:53 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b16so8333035pfi.13;
        Mon, 29 Jun 2020 13:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version:reply-to
         :content-transfer-encoding;
        bh=BzZHVC0iAgOjnmp+banoepd5A4N8/DrSMscTABsdBD0=;
        b=gxQtO2x15mMvNYI3GfhGgpm7fHc4g2nms0huDE+15T7xCQEsuc78OuuetjDqsyn6tx
         xt1bW8kG6CaMAQlYpXKV31hcSl+YsH6TVPlGZFoKlZvXii2v1a+tQaJaVk/ibhnpbAa/
         LiUz1qO/nP3My6mMwN1cjB3duRmDtnh8HZ1S1z3v4KmqjYNKMkrYmU0vaXVnEj+gJIFK
         fgoxxPpk8L+kTtAZGf3e7NwTCZ0Wsydn5eL0cttdGfXLNXbBdUjTbdRIrbz65uP6fxWQ
         d0q1/6sLZKmlQQm98PX1njG2izxpGsj2HbZq/CLT+MWlt9h1KlF4iipkvuL4ZFHmam8G
         3M7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :reply-to:content-transfer-encoding;
        bh=BzZHVC0iAgOjnmp+banoepd5A4N8/DrSMscTABsdBD0=;
        b=ki76yRQ+dO5qWM3T+rxfq9hGa0b2utMO6OsOvRFDRCiIb/DCEJZCa9zr6o5IxNVgZc
         /+zkPLiGugbFTpSYnKw3nJGBFmt8yP+DvvHvOQ7ewVO4BDyghfQdqQLb6fWj85CNWrKn
         1yYiy94pjszpOSc1AJr1GHtljCZyxdcMqJNr1c2u7bp64mp8zG7s3q9Ej+tLoZJ1q6iq
         BwvMzkH2J/D965Rekua//+L8V3dizsmfJQaMwTcWlzPe4EUWEPsR0aAHKyqvmLFvY8VZ
         SSRIUOFXWIvUOHzIvPo4L/7RYzAqqW5C7hHje/0GzQXIP147wqOgLCUdmso1W0MkItT7
         ZMNA==
X-Gm-Message-State: AOAM531MMRLDGSqXglXFxCJaW9G7COpBIR0BOlkFRjh+3r3YswQJlCzZ
        k8jVVq9S5rPU3ISXlkySFj4=
X-Google-Smtp-Source: ABdhPJytEAzHyixe1kECCeyJXTT86jjUfyrwVMZsO1pdGsd1R/rkhiznp9a2++5gEXsLfcS37CRmng==
X-Received: by 2002:a63:7b15:: with SMTP id w21mr12350457pgc.386.1593460972852;
        Mon, 29 Jun 2020 13:02:52 -0700 (PDT)
Received: from localhost.localdomain ([131.107.160.194])
        by smtp.gmail.com with ESMTPSA id j10sm531558pgh.28.2020.06.29.13.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 13:02:52 -0700 (PDT)
From:   Andres Beltran <lkmlabelt@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikelley@microsoft.com, parri.andrea@gmail.com,
        Andres Beltran <lkmlabelt@gmail.com>,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 0/3] Drivers: hv: vmbus: vmbus_requestor data structure for VMBus hardening
Date:   Mon, 29 Jun 2020 16:02:24 -0400
Message-Id: <20200629200227.1518784-1-lkmlabelt@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Reply-To: t-mabelt@microsoft.com
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

Thanks.
Andres Beltran

Cc: linux-scsi@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>

Andres Beltran (3):
  Drivers: hv: vmbus: Add vmbus_requestor data structure for VMBus
    hardening
  scsi: storvsc: Use vmbus_requestor to generate transaction IDs for
    VMBus hardening
  hv_netvsc: Use vmbus_requestor to generate transaction IDs for VMBus
    hardening

 drivers/hv/channel.c              | 146 ++++++++++++++++++++++++++++++
 drivers/net/hyperv/hyperv_net.h   |  13 +++
 drivers/net/hyperv/netvsc.c       |  79 +++++++++++++---
 drivers/net/hyperv/rndis_filter.c |   1 +
 drivers/scsi/storvsc_drv.c        |  85 ++++++++++++++---
 include/linux/hyperv.h            |  22 +++++
 6 files changed, 321 insertions(+), 25 deletions(-)

-- 
2.25.1

