Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AFC20F861
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 17:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389474AbgF3PcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 11:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389403AbgF3PcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 11:32:08 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E148C061755;
        Tue, 30 Jun 2020 08:32:08 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t6so10129951pgq.1;
        Tue, 30 Jun 2020 08:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version:reply-to
         :content-transfer-encoding;
        bh=MkaGNDtMY/NRjHtJ37AHiDdfQpm5dAJJXn18jrcf3a0=;
        b=t81FJtYHDU1oMziHtEQddR8ifoGMD/S3rfdbwL0W9hzjL5KMbw1Rh+vhMsBDxwMQSd
         hBf2mL5chtfCyG+W3F8V+3yjtXPlelee6+tyV4CGMYCepdnJz6CD1Ec6b9wj23zMEDHC
         RR5pYGTPkuh8egT/qdjvZhNuatHwsR7hdVbKLmwaLSxxghv7ZCVm+CCsNljmyC72qe3P
         GR02iT15ifnSaZJf36C+VymnzWDHNIbmih0RadoKUcvhht01bzfnNNRPwDbOhpAhrMv5
         4wpN1l1afxo64RXLzCSpAzzU6XDdK7EpGFEwP4ayArDKfoaO8+7aHEe4Hsu61y6gF8BC
         YLyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :reply-to:content-transfer-encoding;
        bh=MkaGNDtMY/NRjHtJ37AHiDdfQpm5dAJJXn18jrcf3a0=;
        b=Ewm91QXTEEOjAg5SEnS/1IKpt07shoYhe7Pf6S0mqghbHZ9zaCzl0lzdtiLtK3LHRu
         T+zD532GKyNnJSCXt3TuRk6EzonwTZXy3N27eIvwEs8A+mCrFA2VsnTxDoR68GIR1eKB
         hVG0NyDf9Kug++kWIafx7CBYDw0Lg89KMS3bTpDKtK+mOAYdVHn+sjVxbzBW9KDJNFiR
         EI7uMSdyPYSuGVK6kJuGGpzoXa4KjHTFsRjX3+r8Pc0xxJiEt/pcrhIH9C3F8K4YjYP2
         RZ3fpNo/haWMijVroJN4QtsGLWXetYSvwkQq91fjQmy0qOCPEVoBhLQ2FuEXJvQ9XKFU
         qTLQ==
X-Gm-Message-State: AOAM533raV7Zjo+CG7TvFZ0TV+E5fS4kvLhyHw/8OIjo68fznT9M8gZV
        w0Rvf3RYQ3GCTS21Xgl8W3s=
X-Google-Smtp-Source: ABdhPJwRsXEuMGybs81Dv5ER0nufXLdqv1A8Hw5GNQ9lgs8VOgl+sBpBo332N7IT3uzVbb623krG5g==
X-Received: by 2002:a63:6e08:: with SMTP id j8mr15426916pgc.187.1593531127662;
        Tue, 30 Jun 2020 08:32:07 -0700 (PDT)
Received: from localhost.localdomain ([131.107.174.194])
        by smtp.gmail.com with ESMTPSA id 140sm3067433pfz.154.2020.06.30.08.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 08:32:07 -0700 (PDT)
From:   Andres Beltran <lkmlabelt@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikelley@microsoft.com, parri.andrea@gmail.com,
        skarade@microsoft.com, Andres Beltran <lkmlabelt@gmail.com>,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v3 0/3] Drivers: hv: vmbus: vmbus_requestor data structure for VMBus hardening
Date:   Tue, 30 Jun 2020 11:31:57 -0400
Message-Id: <20200630153200.1537105-1-lkmlabelt@gmail.com>
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

Tested-by: Andrea Parri <parri.andrea@gmail.com>

Cc: linux-scsi@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: David S. Miller <davem@davemloft.net>

Andres Beltran (3):
  Drivers: hv: vmbus: Add vmbus_requestor data structure for VMBus
    hardening
  scsi: storvsc: Use vmbus_requestor to generate transaction IDs for
    VMBus hardening
  hv_netvsc: Use vmbus_requestor to generate transaction IDs for VMBus
    hardening

 drivers/hv/channel.c              | 154 ++++++++++++++++++++++++++++++
 drivers/net/hyperv/hyperv_net.h   |  13 +++
 drivers/net/hyperv/netvsc.c       |  79 ++++++++++++---
 drivers/net/hyperv/rndis_filter.c |   1 +
 drivers/scsi/storvsc_drv.c        |  85 ++++++++++++++---
 include/linux/hyperv.h            |  22 +++++
 6 files changed, 329 insertions(+), 25 deletions(-)

-- 
2.25.1

