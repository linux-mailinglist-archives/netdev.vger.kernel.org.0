Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492252A6027
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbgKDJGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729037AbgKDJGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 04:06:42 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E892C0401C4
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 01:06:40 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id x7so21206350wrl.3
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 01:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hCoWNpiCY5I/CQYGLXURefOzHbVXVRlIXhsHqYI/w30=;
        b=vwJYvf5tSu7houONcmY2RH0gAqaH3s1DrvDwNkF4scpQukej3gO26Urf1rHRcXlx7G
         B2whz/j1yA3d9bp292+5xEZLWicfY9GfbwHm4C6yccYuE9OZmNKeLxI5PBb//bQitl+E
         v6nlckH1Km93jQw2G02u45i90OEKa58QkQJKwuVrgtTcvR2aoDTlVT2T+iFhz7AEFzBt
         4/GD1b8f73SRPihSSmP/Qu1gKvWTXZV54+o+y+7Dlakhv8SCIvaIOrhA7JHtfRDLugEK
         W+adwHbrSM4M/7sWpJ5Qu1vE6cyyvCWOjhiqzAcVRe3JrHoLI/3pZfXIMko92etRfCXg
         uymA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hCoWNpiCY5I/CQYGLXURefOzHbVXVRlIXhsHqYI/w30=;
        b=scGqo5dCNM37gc6dg8w3I4I1zas9hf2gh6Brt1lRSkZlbtXl7FmhxcFQS9n+1Qq1c1
         Z0yZ8dWKxuu/8Z2v/Xic5sJbtzs0tu88VZfvVEZcQxs9J/QyGLX+hHohGNSXdiMGQFbR
         EzZtRSubHcRjXytGgz3meGNX16j8nDedVwheW/dpuSEKNgawluwECFmSx2NGNaxaF9Aj
         uVeeDI4L1J9lUdLPakVP1cUghiq44dCm0TvBRw/yM+LdUtfmsVfHG2ApOBAYYMhXTt94
         uLdIvCbMDc90vfo6aXSfTahfEno3Xyr2sL87tCXtvyaYMSA7AkcQaKJ3yGH8ATAWI1bo
         kNpw==
X-Gm-Message-State: AOAM530vYorMsxbNFL9Mna+1HfFX6lsXsJPVTopnnYcwEShHntWJFB1l
        acup1T48KsqGfnxOlAemLUZU5A==
X-Google-Smtp-Source: ABdhPJyouHiD9Dbeluv3U+pp3NeWi36AECmXpnyN2oBwE+mQUrCkcIzIM6ScwsKBWyolVfD7r82PcQ==
X-Received: by 2002:adf:a195:: with SMTP id u21mr24545841wru.132.1604480799084;
        Wed, 04 Nov 2020 01:06:39 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id e25sm1607823wrc.76.2020.11.04.01.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 01:06:38 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Santiago Leon <santi_leon@yahoo.com>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        John Allen <jallen@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: [PATCH 12/12] net: ethernet: ibm: ibmvnic: Fix some kernel-doc issues
Date:   Wed,  4 Nov 2020 09:06:10 +0000
Message-Id: <20201104090610.1446616-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201104090610.1446616-1-lee.jones@linaro.org>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 from drivers/net/ethernet/ibm/ibmvnic.c:35:
 inlined from ‘handle_vpd_rsp’ at drivers/net/ethernet/ibm/ibmvnic.c:4124:3:
 drivers/net/ethernet/ibm/ibmvnic.c:1362: warning: Function parameter or member 'hdr_data' not described in 'build_hdr_data'
 drivers/net/ethernet/ibm/ibmvnic.c:1362: warning: Excess function parameter 'tot_len' description in 'build_hdr_data'
 drivers/net/ethernet/ibm/ibmvnic.c:1423: warning: Function parameter or member 'hdr_data' not described in 'create_hdr_descs'
 drivers/net/ethernet/ibm/ibmvnic.c:1423: warning: Excess function parameter 'data' description in 'create_hdr_descs'
 drivers/net/ethernet/ibm/ibmvnic.c:1474: warning: Function parameter or member 'txbuff' not described in 'build_hdr_descs_arr'
 drivers/net/ethernet/ibm/ibmvnic.c:1474: warning: Excess function parameter 'skb' description in 'build_hdr_descs_arr'
 drivers/net/ethernet/ibm/ibmvnic.c:1474: warning: Excess function parameter 'subcrq' description in 'build_hdr_descs_arr'

Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Dany Madden <drt@linux.ibm.com>
Cc: Lijun Pan <ljp@linux.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Santiago Leon <santi_leon@yahoo.com>
Cc: Thomas Falcon <tlfalcon@linux.vnet.ibm.com>
Cc: John Allen <jallen@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b30e1f5784bad..08dab7a94b7ea 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1360,7 +1360,7 @@ static int ibmvnic_close(struct net_device *netdev)
  * @hdr_field: bitfield determining needed headers
  * @skb: socket buffer
  * @hdr_len: array of header lengths
- * @tot_len: total length of data
+ * @hdr_data: buffer to write the header to
  *
  * Reads hdr_field to determine which headers are needed by firmware.
  * Builds a buffer containing these headers.  Saves individual header
@@ -1418,7 +1418,7 @@ static int build_hdr_data(u8 hdr_field, struct sk_buff *skb,
 /**
  * create_hdr_descs - create header and header extension descriptors
  * @hdr_field: bitfield determining needed headers
- * @data: buffer containing header data
+ * @hdr_data: buffer containing header data
  * @len: length of data buffer
  * @hdr_len: array of individual header lengths
  * @scrq_arr: descriptor array
@@ -1469,9 +1469,8 @@ static int create_hdr_descs(u8 hdr_field, u8 *hdr_data, int len, int *hdr_len,
 
 /**
  * build_hdr_descs_arr - build a header descriptor array
- * @skb: socket buffer
+ * @txbuff: tx buffer
  * @num_entries: number of descriptors to be sent
- * @subcrq: first TX descriptor
  * @hdr_field: bit field determining which headers will be sent
  *
  * This function will build a TX descriptor array with applicable
-- 
2.25.1

