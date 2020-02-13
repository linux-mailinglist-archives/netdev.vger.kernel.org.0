Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFA215BB4A
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgBMJOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 04:14:47 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:34277 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgBMJOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 04:14:47 -0500
Received: by mail-pj1-f67.google.com with SMTP id f2so2575161pjq.1
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 01:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=C0g0ZWsvnVAkvDlr5A1T3rJt/3DSdq8n9i3+QeVYxnc=;
        b=A2MyVV2/bede18+miCvlpy0F80zeAx4R34En7F803YgkCS7INxbKBK7QUFunxYEGNn
         qoweA8HBe3CC6KtILRID38Pi8SIF27Ee8ClU8fFrBL2Q3wm2bA5zySWfiLYf9ArJaLpC
         rWJcAU6abmBXSltLYDl0Z9iTPoAGNhF6kmySTmSZc4QYH4MHj3v8WQN7nFyTdwwXYPjc
         MMU6wjs4yogvQk4jufJkKaJlLsDCr+fl7s6pVvrGlWwUs5jqinkW3U0XiEwZfGTRikqQ
         fieM5lOE7r1LUX0h6iY9pIxjgciw3TeX55WHuziX0XtFUUqG9G/HjVWxXaCenWmqOLVE
         BNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=C0g0ZWsvnVAkvDlr5A1T3rJt/3DSdq8n9i3+QeVYxnc=;
        b=gzqzRqUs1PQjyvlLN0fsWBKsWCNzDReMfF2ZFwuO6ZVKKTWSP+bLZRYFGb/R3/123u
         ahqtyrYkjv1T9uoUL2OPlVcakCu+2+YiqpjWEqOW4XhdiKgdOXjFrt13tye1BqqvRQ/J
         fAl6Zkx/WpkuWEHNrLbnZy4ynHgtg00IwsiKEefQN7mwCi1oybtPxDDbGFd31P0JT3Yz
         pnWLe4N6ILIzVHwPiSFwLFDxsPuOcyxnU8cPjm6827dsJzeUaNsPdhPOcuceExgepWP7
         IsP/LQTmqMNRbAX1LzHOCM/TX5EALMlSYi6YISF4y0RElCQ5rtSOGprbg8PB2xR8iQ5r
         WQpA==
X-Gm-Message-State: APjAAAX64IdtjDhnWDJ8zSWX/2JhTzgYejQzOnhuo6cjKoaQAzV0WbCO
        sd/mTN/T0F4jaz1mQIWzKz06
X-Google-Smtp-Source: APXvYqz3Aj4S5eEXiROQ8hEF9pk617Pnk7erfbcP6U57Z3w3L9CTncDcx9PdzSPC0lo+apn08vHW1g==
X-Received: by 2002:a17:90a:9c1:: with SMTP id 59mr3981287pjo.65.1581585284756;
        Thu, 13 Feb 2020 01:14:44 -0800 (PST)
Received: from localhost.localdomain ([103.59.133.81])
        by smtp.googlemail.com with ESMTPSA id s206sm2294391pfs.100.2020.02.13.01.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 01:14:43 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 0/2] Migrate QRTR Nameservice to Kernel
Date:   Thu, 13 Feb 2020 14:44:25 +0530
Message-Id: <20200213091427.13435-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This patchset migrates the Qualcomm IPC Router (QRTR) Nameservice from userspace
to kernel under net/qrtr.

The userspace implementation of it can be found here:
https://github.com/andersson/qrtr/blob/master/src/ns.c

This change is required for enabling the WiFi functionality of some Qualcomm
WLAN devices using ATH11K without any dependency on a userspace daemon.

The original userspace code is published under BSD3 license. For migrating it
to Linux kernel, I have adapted Dual BSD/GPL license.

This patchset has been verified on Dragonboard410c and Intel NUC with QCA6390
WLAN device.

Thanks,
Mani

Manivannan Sadhasivam (2):
  net: qrtr: Migrate nameservice to kernel from userspace
  net: qrtr: Fix the local node ID as 1

 net/qrtr/Makefile |   2 +-
 net/qrtr/ns.c     | 730 ++++++++++++++++++++++++++++++++++++++++++++++
 net/qrtr/qrtr.c   |  51 +---
 net/qrtr/qrtr.h   |   4 +
 4 files changed, 746 insertions(+), 41 deletions(-)
 create mode 100644 net/qrtr/ns.c

-- 
2.17.1

