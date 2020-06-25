Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06DA20A21A
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405888AbgFYPhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405159AbgFYPhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:37:37 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B82C08C5C1;
        Thu, 25 Jun 2020 08:37:37 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d194so89642pga.13;
        Thu, 25 Jun 2020 08:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eKf/0lxOewQJNcyUw6TguSyEm4wSYJQCqTzuEz6QHDI=;
        b=ilwQ2Uulb1xjp/tK5MQHOUK+bIid5rWWRdDzOZGrO/2KJcOjgX91/pFrJJYpVv08cM
         WNJbLqJrt7jhsY4dI6GH9OljGn1WGkRkNiKQQ2vcojTPrjAq4YkQ/mg+nB6nNQR8eQ6S
         8uzbs9doCD3F7on4ZZEJ+tMl0c0Ylrx5mLbb5Zjwpj1i/CrpA9BfCH2496q72RSj/y6R
         3caexTQppWUu0kQRhnc7UH+KSQlpRGiaOFHM8A5ATNy0WVpP2DrfE5kxv+jiMDCKn7/C
         xHhtiGg1VfxDiKzd1QsW+606pyH3sgyyUgmiRI1F0oJQi1EcQLdQLC+C9l0UVfoCc5di
         SkQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eKf/0lxOewQJNcyUw6TguSyEm4wSYJQCqTzuEz6QHDI=;
        b=m5UAAhfIhwPVEK2rcw1lThW4MgFUgd6tJV1uftBrgugtfsrD8oIMCyfIanFuOE4gQX
         QZzEc1z4JRYSulILM5Ef45tI54j+Mz3OhqhJwpsjonZkByz2WIGBE5PYAHYyFOL+kXRB
         qfQX9CNAQTLzzbX5yKs4XLhVctGGudU6edJpX+h1YFge21yIOKx13Jqa6j/haGj4YtW6
         kh0hnQPdiNLYahkF5wOhYDjpYkwxv7j8Pz66VByXM3yqEDDTFZ8Zqkf48Gh7lpZ00T8G
         xgAqaZ5oCO4HRPdw6HSa2h5vnlgG2QC+Qhg8vdZFBNvZEOQrEXy7DuB74M7K8BWfdL6S
         u/FQ==
X-Gm-Message-State: AOAM5334FMKXRc/1OnIdXmKaevlozldSGFNT3DIPPX+DzdYEqP3gX5c7
        LmgFskTYEx32DwyfB+qL+yA=
X-Google-Smtp-Source: ABdhPJxtgGcsYUZbF7sgwR0aNIKuXXwsjT1VUKFe2v8vGMWGijcY1u/KUMstQcuM2xt0X6XfojQYeA==
X-Received: by 2002:a62:8683:: with SMTP id x125mr35592234pfd.211.1593099457135;
        Thu, 25 Jun 2020 08:37:37 -0700 (PDT)
Received: from localhost.localdomain ([131.107.147.194])
        by smtp.gmail.com with ESMTPSA id i14sm22980813pfo.14.2020.06.25.08.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 08:37:36 -0700 (PDT)
From:   Andres Beltran <lkmlabelt@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikelley@microsoft.com, parri.andrea@gmail.com,
        Andres Beltran <lkmlabelt@gmail.com>,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/3] Drivers: hv: vmbus: vmbus_requestor data structure
Date:   Thu, 25 Jun 2020 11:37:20 -0400
Message-Id: <20200625153723.8428-1-lkmlabelt@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andres Beltran (Microsoft) <lkmlabelt@gmail.com>

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
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>

Andres Beltran (3):
  Drivers: hv: vmbus: Add vmbus_requestor data structure for VMBus
    hardening
  scsi: storvsc: Use vmbus_requestor to generate transaction ids for
    VMBus hardening
  hv_netvsc: Use vmbus_requestor to generate transaction ids for VMBus
    hardening

 drivers/hv/channel.c              | 150 ++++++++++++++++++++++++++++++
 drivers/net/hyperv/hyperv_net.h   |  10 ++
 drivers/net/hyperv/netvsc.c       |  56 +++++++++--
 drivers/net/hyperv/rndis_filter.c |   1 +
 drivers/scsi/storvsc_drv.c        |  62 ++++++++++--
 include/linux/hyperv.h            |  22 +++++
 6 files changed, 283 insertions(+), 18 deletions(-)

-- 
2.25.1

