Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245772CE5D2
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgLDCmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:42:52 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:11090 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgLDCmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 21:42:51 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607049750; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=yneIfdaseUAg7oSHUMq1XthCRxBcTj7aSJWNLSkOLfk=; b=C57yFsDvf3W4wdqnqD/TJ/PwPkBtlGjnTQjsoQfM0Lpe/cyhV9vsD4lKjxEGNyK2jCP2M6bF
 Hg+h1+cSBC9gSFokWBxvkdiI9JTfa4d/vyf6NivAbL4tOBSLKP1U2mcl9SDq3y0Ox7QzM6pM
 2ogCmAWX9VawHvkBdGcuNgVuxkk=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5fc9a1faaac945509780ad65 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 04 Dec 2020 02:42:02
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9F0A2C43467; Fri,  4 Dec 2020 02:42:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6B1CFC43462;
        Fri,  4 Dec 2020 02:41:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6B1CFC43462
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
From:   Hemant Kumar <hemantk@codeaurora.org>
To:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: [RESEND v15 3/4] docs: Add documentation for userspace client interface
Date:   Thu,  3 Dec 2020 18:41:50 -0800
Message-Id: <1607049711-31776-4-git-send-email-hemantk@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607049711-31776-1-git-send-email-hemantk@codeaurora.org>
References: <1607049711-31776-1-git-send-email-hemantk@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MHI userspace client driver is creating device file node
for user application to perform file operations. File
operations are handled by MHI core driver. Currently
QMI MHI channel is supported by this driver.

Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
---
 Documentation/mhi/index.rst |  1 +
 Documentation/mhi/uci.rst   | 95 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+)
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
index 0000000..df1f0c4
--- /dev/null
+++ b/Documentation/mhi/uci.rst
@@ -0,0 +1,95 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================================
+Userspace Client Interface (UCI)
+=================================
+
+UCI driver enables userspace clients to communicate to external MHI devices
+like modem and WLAN. UCI driver probe creates standard character device file
+nodes for userspace clients to perform open, read, write, poll and release file
+operations. UCI device object represents UCI device file node which gets
+instantiated as part of MHI UCI driver probe. UCI channel object represents
+MHI uplink or downlink channel.
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
+ring is not empty.  When the uplink channel transfer ring is non-empty, more
+data may be sent to the device. Returns EPOLLERR when UCI driver is removed.
+
+release
+-------
+
+Decrements UCI device reference count and UCI channel reference count. Upon
+last release() UCI channel clean up is performed. MHI channel moves to disable
+state and inbound buffers are freed.
+
+Usage
+=====
+
+Device file node is created with format:-
+
+/dev/<mhi_device_name>
+
+mhi_device_name includes mhi controller name and the name of the MHI channel
+being used by MHI client in userspace to send or receive data using MHI
+protocol.
+
+There is a separate character device file node created for each channel
+specified in MHI device id table. MHI channels are statically defined by MHI
+specification. The list of supported channels is in the channel list variable
+of mhi_device_id table in UCI driver.
+
+Qualcomm MSM Interface(QMI) Channel
+-----------------------------------
+
+Qualcomm MSM Interface(QMI) is a modem control messaging protocol used to
+communicate between software components in the modem and other peripheral
+subsystems. QMI communication is of request/response type or an unsolicited
+event type. libqmi is userspace MHI client which communicates to a QMI service
+using UCI device. It sends a QMI request to a QMI service using MHI channel 14
+or 16. QMI response is received using MHI channel 15 or 17 respectively. libqmi
+is a glib-based library for talking to WWAN modems and devices which speaks QMI
+protocol. For more information about libqmi please refer
+https://www.freedesktop.org/wiki/Software/libqmi/
+
+Usage Example
+~~~~~~~~~~~~~
+
+QMI command to retrieve device mode
+$ sudo qmicli -d /dev/mhi0_QMI --dms-get-model
+[/dev/mhi0_QMI] Device model retrieved:
+    Model: 'FN980m'
+
+Other Use Cases
+---------------
+
+Getting MHI device specific diagnostics information to userspace MHI diagnostic
+client using DIAG channel 4 (Host to device) and 5 (Device to Host).
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

