Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AC22F865A
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 21:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388727AbhAOUKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 15:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388405AbhAOUKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 15:10:38 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F81C06179E
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 12:09:23 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id g10so8646009wmh.2
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 12:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yDzb65IKn3nwovbfX3R0K/7WXOxWh6GWTqzLuh+BAmI=;
        b=pZsRMv5bhHtvqYJamsuJ75nikyt6zcEJQlYa5vQNiBCiISvirtV/ccexo7zQxCL1hu
         FyMdw6tJFzSL+XN4ohF9JDJi5bNXyHBfqEqyKGKVtQFvIof1HSwxObDjQ06yYJD+Ny56
         MKCOrA9dCzWddMH10Sre5X+JgsGLmIc++r0XDgmiQQ/UVjhhhmCg2myrmmjsK0CckMSX
         aKr2n65VSUKW1Facr/jNVjR4IeSnYHdw2rTWy//Bt6I1nB7nbCnmxCW/lkikEvkBxrgY
         MzhZpHTN2iXSiKX9uLQIRu6p2MsCvQzueB4ji7GPjK5Z4qOIpiZbDuW1S0rybK4pqPFZ
         o0aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yDzb65IKn3nwovbfX3R0K/7WXOxWh6GWTqzLuh+BAmI=;
        b=NOW6zKVO1xuY2DnX3LXGuPPhxX5fUgzbXkghMcTbsEF4Od0oJMTEAuYFCNYtR/qPtl
         H25bj/tl4B5/XQepqgKgNkbCcOLtYlEwyjh0sdlLiYqO0PtkN1pIuXnDLChbBz2lAAOz
         j8sCQlRVSt7HioWVL+BYaqNsMFprWe/2eVCY3l92kE0fpXwREzbDcDxlSoozzt9HmvS2
         SmGOSyR2wGiRXni0o01aEh17KPAxFiKor3nn7AezsV9gDK1JENEMUxmTfgEGxxjAkCVQ
         FbFnPhgoQGiBFPfy/ANsXlBha9acsJf+HbAg1UmSNt/qBo8gAOO4BX3q/SL+1ELaXmAG
         mPzA==
X-Gm-Message-State: AOAM5300Be0JH9PlztMWStLODHFsc5JDiiZ8eZ6RX3JOSTGgEo0m6es9
        tUxevrT3IwxjWmptRY60jYo/8Q==
X-Google-Smtp-Source: ABdhPJwKdwqNYtrjcalQ/mSZfe/zNNTb1WZf+Bx43LDkCZUpxVVkCGbnv0e+Kgl19uj2hk4l/rtILA==
X-Received: by 2002:a05:600c:d1:: with SMTP id u17mr7533052wmm.20.1610741362266;
        Fri, 15 Jan 2021 12:09:22 -0800 (PST)
Received: from dell.default ([91.110.221.158])
        by smtp.gmail.com with ESMTPSA id d85sm9187863wmd.2.2021.01.15.12.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 12:09:21 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Santiago Leon <santi_leon@yahoo.com>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        John Allen <jallen@linux.vnet.ibm.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 5/7] net: ethernet: ibm: ibmvnic: Fix some kernel-doc misdemeanours
Date:   Fri, 15 Jan 2021 20:09:03 +0000
Message-Id: <20210115200905.3470941-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115200905.3470941-1-lee.jones@linaro.org>
References: <20210115200905.3470941-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 from drivers/net/ethernet/ibm/ibmvnic.c:35:
 inlined from ‘handle_vpd_rsp’ at drivers/net/ethernet/ibm/ibmvnic.c:4124:3:
 drivers/net/ethernet/ibm/ibmvnic.c:1362: warning: Function parameter or member 'hdr_field' not described in 'build_hdr_data'
 drivers/net/ethernet/ibm/ibmvnic.c:1362: warning: Function parameter or member 'skb' not described in 'build_hdr_data'
 drivers/net/ethernet/ibm/ibmvnic.c:1362: warning: Function parameter or member 'hdr_len' not described in 'build_hdr_data'
 drivers/net/ethernet/ibm/ibmvnic.c:1362: warning: Function parameter or member 'hdr_data' not described in 'build_hdr_data'
 drivers/net/ethernet/ibm/ibmvnic.c:1423: warning: Function parameter or member 'hdr_field' not described in 'create_hdr_descs'
 drivers/net/ethernet/ibm/ibmvnic.c:1423: warning: Function parameter or member 'hdr_data' not described in 'create_hdr_descs'
 drivers/net/ethernet/ibm/ibmvnic.c:1423: warning: Function parameter or member 'len' not described in 'create_hdr_descs'
 drivers/net/ethernet/ibm/ibmvnic.c:1423: warning: Function parameter or member 'hdr_len' not described in 'create_hdr_descs'
 drivers/net/ethernet/ibm/ibmvnic.c:1423: warning: Function parameter or member 'scrq_arr' not described in 'create_hdr_descs'
 drivers/net/ethernet/ibm/ibmvnic.c:1474: warning: Function parameter or member 'txbuff' not described in 'build_hdr_descs_arr'
 drivers/net/ethernet/ibm/ibmvnic.c:1474: warning: Function parameter or member 'num_entries' not described in 'build_hdr_descs_arr'
 drivers/net/ethernet/ibm/ibmvnic.c:1474: warning: Function parameter or member 'hdr_field' not described in 'build_hdr_descs_arr'
 drivers/net/ethernet/ibm/ibmvnic.c:1832: warning: Function parameter or member 'adapter' not described in 'do_change_param_reset'
 drivers/net/ethernet/ibm/ibmvnic.c:1832: warning: Function parameter or member 'rwi' not described in 'do_change_param_reset'
 drivers/net/ethernet/ibm/ibmvnic.c:1832: warning: Function parameter or member 'reset_state' not described in 'do_change_param_reset'
 drivers/net/ethernet/ibm/ibmvnic.c:1911: warning: Function parameter or member 'adapter' not described in 'do_reset'
 drivers/net/ethernet/ibm/ibmvnic.c:1911: warning: Function parameter or member 'rwi' not described in 'do_reset'
 drivers/net/ethernet/ibm/ibmvnic.c:1911: warning: Function parameter or member 'reset_state' not described in 'do_reset'

Cc: Dany Madden <drt@linux.ibm.com>
Cc: Lijun Pan <ljp@linux.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Santiago Leon <santi_leon@yahoo.com>
Cc: Thomas Falcon <tlfalcon@linux.vnet.ibm.com>
Cc: John Allen <jallen@linux.vnet.ibm.com>
Cc: netdev@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 27 +++++++++++++--------------
 drivers/net/xen-netfront.c         |  6 +++---
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index aed985e08e8ad..4c4252e68de5a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1384,10 +1384,10 @@ static int ibmvnic_close(struct net_device *netdev)
 
 /**
  * build_hdr_data - creates L2/L3/L4 header data buffer
- * @hdr_field - bitfield determining needed headers
- * @skb - socket buffer
- * @hdr_len - array of header lengths
- * @tot_len - total length of data
+ * @hdr_field: bitfield determining needed headers
+ * @skb: socket buffer
+ * @hdr_len: array of header lengths
+ * @hdr_data: buffer to write the header to
  *
  * Reads hdr_field to determine which headers are needed by firmware.
  * Builds a buffer containing these headers.  Saves individual header
@@ -1444,11 +1444,11 @@ static int build_hdr_data(u8 hdr_field, struct sk_buff *skb,
 
 /**
  * create_hdr_descs - create header and header extension descriptors
- * @hdr_field - bitfield determining needed headers
- * @data - buffer containing header data
- * @len - length of data buffer
- * @hdr_len - array of individual header lengths
- * @scrq_arr - descriptor array
+ * @hdr_field: bitfield determining needed headers
+ * @hdr_data: buffer containing header data
+ * @len: length of data buffer
+ * @hdr_len: array of individual header lengths
+ * @scrq_arr: descriptor array
  *
  * Creates header and, if needed, header extension descriptors and
  * places them in a descriptor array, scrq_arr
@@ -1496,10 +1496,9 @@ static int create_hdr_descs(u8 hdr_field, u8 *hdr_data, int len, int *hdr_len,
 
 /**
  * build_hdr_descs_arr - build a header descriptor array
- * @skb - socket buffer
- * @num_entries - number of descriptors to be sent
- * @subcrq - first TX descriptor
- * @hdr_field - bit field determining which headers will be sent
+ * @txbuff: tx buffer
+ * @num_entries: number of descriptors to be sent
+ * @hdr_field: bit field determining which headers will be sent
  *
  * This function will build a TX descriptor array with applicable
  * L2/L3/L4 packet header descriptors to be sent by send_subcrq_indirect.
@@ -1925,7 +1924,7 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
 	return rc;
 }
 
-/**
+/*
  * do_reset returns zero if we are able to keep processing reset events, or
  * non-zero if we hit a fatal error and must halt.
  */
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index b01848ef46493..811ddc8a94eea 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1582,7 +1582,7 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 	return ERR_PTR(err);
 }
 
-/**
+/*
  * Entry point to this code when a new device is created.  Allocate the basic
  * structures and the ring buffers for communication with the backend, and
  * inform the backend of the appropriate details for those.
@@ -1659,7 +1659,7 @@ static void xennet_disconnect_backend(struct netfront_info *info)
 	}
 }
 
-/**
+/*
  * We are reconnecting to the backend, due to a suspend/resume, or a backend
  * driver restart.  We tear down our netif structure and recreate it, but
  * leave the device-layer structures intact so that this is transparent to the
@@ -2305,7 +2305,7 @@ static int xennet_connect(struct net_device *dev)
 	return 0;
 }
 
-/**
+/*
  * Callback received when the backend's state changes.
  */
 static void netback_changed(struct xenbus_device *dev,
-- 
2.25.1

