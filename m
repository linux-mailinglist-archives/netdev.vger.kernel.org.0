Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A42529FB91
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgJ3CqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:46:13 -0400
Received: from z5.mailgun.us ([104.130.96.5]:41107 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgJ3Cpz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 22:45:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604025954; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=iH1/bxkuvTL5kOeeFRa31zk03SipGT1AZdEjYVZAoGk=; b=FvQc9oIhiOfjDKSa1N9eUoHbaCieeKW0vZip9Fsmrp5k2w1sTxHwMYNHJHwEGsplOEtEojc1
 rN+VLXhTq/IOiloBjNL6m0scrcAI+ilzxvAHngu6QsOG8dYNwZh4NKmeruZD5bioiStIkqkX
 wKkn3K3E2rBl4at2LLgc2X6Ptss=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5f9b7e625177b1c5f92f7928 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 30 Oct 2020 02:45:54
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E5BF3C433C8; Fri, 30 Oct 2020 02:45:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F1EECC433FF;
        Fri, 30 Oct 2020 02:45:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F1EECC433FF
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
From:   Hemant Kumar <hemantk@codeaurora.org>
To:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: [PATCH v11 3/4] docs: Add documentation for userspace client interface
Date:   Thu, 29 Oct 2020 19:45:45 -0700
Message-Id: <1604025946-28288-4-git-send-email-hemantk@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604025946-28288-1-git-send-email-hemantk@codeaurora.org>
References: <1604025946-28288-1-git-send-email-hemantk@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MHI userspace client driver is creating device file node
for user application to perform file operations. File
operations are handled by MHI core driver. Currently
Loopback MHI channel is supported by this driver.

Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
---
 Documentation/mhi/index.rst |  1 +
 Documentation/mhi/uci.rst   | 84 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)
 create mode 100644 Documentation/mhi/uci.rst

diff --git a/Documentation/mhi/index.rst b/Documentation/mhi/index.rst
index 1d8dec3..c75a371 100644
--- a/Documentation/mhi/index.rst
+++ b/Documentation/mhi/index.rst
@@ -9,6 +9,7 @@ MHI
 
    mhi
    topology
+   uci
 
 .. only::  subproject and html
 
diff --git a/Documentation/mhi/uci.rst b/Documentation/mhi/uci.rst
new file mode 100644
index 0000000..4f706cb
--- /dev/null
+++ b/Documentation/mhi/uci.rst
@@ -0,0 +1,84 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================================
+Userspace Client Interface (UCI)
+=================================
+
+UCI driver enables userspace clients to communicate to external MHI devices
+like modem and WLAN. UCI driver probe creates standard character device file
+nodes for userspace clients to perform open, read, write, poll and release file
+operations.
+
+Operations
+==========
+
+open
+----
+
+Instantiates UCI channel object and starts MHI channels to move it to running
+state. Inbound buffers are queued to downlink channel transfer ring. Every
+subsequent open() increments UCI device reference count as well as UCI channel
+reference count.
+
+read
+----
+
+When data transfer is completed on downlink channel, transfer ring element
+buffer is copied to pending list. Reader is unblocked and data is copied to
+userspace buffer. Transfer ring element buffer is queued back to downlink
+channel transfer ring.
+
+write
+-----
+
+Write buffer is queued to uplink channel transfer ring if ring is not full. Upon
+uplink transfer completion buffer is freed.
+
+poll
+----
+
+Returns EPOLLIN | EPOLLRDNORM mask if pending list has buffers to be read by
+userspace. Returns EPOLLOUT | EPOLLWRNORM mask if MHI uplink channel transfer
+ring is not empty. Returns EPOLLERR when UCI driver is removed.
+
+release
+-------
+
+Decrements UCI device reference count and UCI channel reference count upon last
+release(). UCI channel clean up is performed. MHI channel moves to disable
+state and inbound buffers are freed.
+
+Usage
+=====
+
+Device file node is created with format:-
+
+/dev/mhi_<controller_name>_<mhi_device_name>
+
+controller_name is the name of underlying bus used to transfer data. mhi_device
+name is the name of the MHI channel being used by MHI client in userspace to
+send or receive data using MHI protocol.
+
+There is a separate character device file node created for each channel
+specified in MHI device id table. MHI channels are statically defined by MHI
+specification. The list of supported channels is in the channel list variable
+of mhi_device_id table in UCI driver.
+
+LOOPBACK Channel
+----------------
+
+Userspace MHI client using LOOPBACK channel opens device file node. As part of
+open operation transfer ring elements are queued to transfer ring of LOOPBACK
+channel 1 and channel doorbell is rung. When userspace MHI client performs write
+operation on device node, data buffer gets queued as part of transfer ring
+element to transfer ring of LOOPBACK channel 0. MHI Core driver rings the
+channel doorbell for MHI device to move data over underlying bus. When userspace
+MHI client driver performs read operation, same data gets looped back to MHI
+host using LOOPBACK channel 1. LOOPBACK channel is used to verify data path
+and data integrity between MHI Host and MHI device.
+
+Other Use Cases
+---------------
+
+Getting MHI device specific diagnostics information to userspace MHI diagnostic
+client using DIAG channel 4 (Host to device) and 5 (Device to Host).
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

