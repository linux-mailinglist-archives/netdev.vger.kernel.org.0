Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B2635BB13
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbhDLHns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236968AbhDLHnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 03:43:47 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94557C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:43:29 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id l131so7519988oih.0
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P/T6Ns85BhUFKOc+ZeWiNGWVmab9FfDlLPs5EqVU/fs=;
        b=Zufe5x1eph7jQ7xKlAUGSVrxI8KxJKaOuwQQOPXoryvn+8fC6pzHdzC4WlvbRQCmZl
         T/JUyjzK2FocHQ1aeQaHdAlvbEthkgnHi5/g+5vbAWtroXk+aRPAizRQ3PigfBMRN2hB
         Are43VK6WwfkRxdZ0bXGNtNE4NJmKNi5hPG2pRs8LlM5pIUKrrDbebxjd4PDLz4ETxDX
         oQoiJ7ZUDANeFIiCuPl4ilLqJrYRB25btElA9fMazpTJWRASDwgZppVtQ0nKE0j+cs92
         bu5COvJBM9wSACjbIlNapDArd5m8plqEfwCV4w/LLqhOxLj7tMD5ZOAqkWKpoAfePUw9
         3Scw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P/T6Ns85BhUFKOc+ZeWiNGWVmab9FfDlLPs5EqVU/fs=;
        b=DA+Eh1H++4Ckk+zgv/pCdDbYvO8ra1ojPxK2/AXpQ+n9vU4IZANFLT9581gdYUbmRG
         1sGi2MxfoZrPISif4oL/DAF6xJkrHzf60FFF3YVbvXV1tvWFo7aLeAXzo7bUkiHoCPYO
         ZyQ4hf3CAcvlV15tVN56Sb5jN7k6KePTXIN98/4d8/j7zrLNmtTE4/tYdKjOt3AWtMUo
         /tdYn6NMWZUT9j7eMcCnAV1MYjLCiXeMyCZChIUtcddIdBavYgJylw0GRgw6LRqpYZEU
         F7sxNYhZQJORdBMqyGgRW66vJBtBeY7s6NMeG0PmCcxB6oVHdzGJ2Ku80etp2uhJ8YLL
         gdBw==
X-Gm-Message-State: AOAM5321/zilcD9s9JkkHJ3QiuV9h+Bjn07Qeg7+2hBYKeJqL24Idigo
        jVWQkvlW1YFhZYduOgXeTlSF93tt2mU=
X-Google-Smtp-Source: ABdhPJwwLCSnX9H748XejI4ea5RP1AfArsUj2p3kp3Ma16W+zcAHoCIS3BSzUBLIZaRZMQO7wJIUYQ==
X-Received: by 2002:aca:bb06:: with SMTP id l6mr18421185oif.121.1618213408848;
        Mon, 12 Apr 2021 00:43:28 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:70fe:cfb5:1414:607d])
        by smtp.gmail.com with ESMTPSA id f12sm2485676otf.65.2021.04.12.00.43.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Apr 2021 00:43:28 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next 1/2] ibmvnic: improve failover sysfs entry
Date:   Mon, 12 Apr 2021 02:43:29 -0500
Message-Id: <20210412074330.9371-2-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412074330.9371-1-lijunp213@gmail.com>
References: <20210412074330.9371-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current implementation replies on H_IOCTL call to issue a
H_SESSION_ERR_DETECTED command to let the hypervisor to send a failover
signal. However, it may not work while the vnic is already in error
state, e.g., "ibmvnic 30000003 env3: rx buffer returned with rc 6".
Add a last resort, that is to schedule a failover reset via CRQ command.

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index ee9bf18c597f..d44a7b5b8f67 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5512,14 +5512,14 @@ static ssize_t failover_store(struct device *dev, struct device_attribute *attr,
 	rc = plpar_hcall_norets(H_VIOCTL, adapter->vdev->unit_address,
 				H_SESSION_ERR_DETECTED, session_token, 0, 0);
 	if (rc) {
-		netdev_err(netdev, "Client initiated failover failed, rc %ld\n",
+		netdev_err(netdev,
+			   "H_VIOCTL initiated failover failed, rc %ld, trying to send CRQ_CMD, the last resort\n",
 			   rc);
-		return -EINVAL;
+		ibmvnic_reset(adapter, VNIC_RESET_FAILOVER);
 	}
 
 	return count;
 }
-
 static DEVICE_ATTR_WO(failover);
 
 static unsigned long ibmvnic_get_desired_dma(struct vio_dev *vdev)
-- 
2.23.0

