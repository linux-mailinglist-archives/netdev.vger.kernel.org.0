Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB95A30142A
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 10:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbhAWJ1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 04:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbhAWJZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 04:25:02 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0383EC0613D6;
        Sat, 23 Jan 2021 01:24:37 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id cq1so5312032pjb.4;
        Sat, 23 Jan 2021 01:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k3QR3JKXwG7wDIj5UwkwcvzwKyrFi2u7DZslhTlOQTU=;
        b=ARNxYjMQKp/eKXPWu1Iz4DS2LcecIhnFDEC8G7h3rmHC3qKLcS3Mn4JvGmOWIpeEQA
         63g2FSqAtphthauJ9wkrEn0m0i9HBSExCeiOf3ZEYi8Kui5RYhNmm2m1kzTvWURprDpa
         rWJPlcOXDhZ4/RpvX29HZwoXsaYmq7j7dhhyXYbu/SskmqUMiJkA9T/yGManXB2lAchP
         MxchhqEHr6Ej/eUnEBLdn6h9nFFHV9/y2zQKZLC+iKr+JlH6fox41M6PEA4GV8SlpV4S
         tT/kqEMLj9Z1uzJ6v6zOsC91IYbIlFPi5YhCmkYINISTuHm59P7bNblWnorFUsyGPYfa
         JaNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k3QR3JKXwG7wDIj5UwkwcvzwKyrFi2u7DZslhTlOQTU=;
        b=W60/HCT3QJVjYYp7kSRY248NuSQ7dI0aJZB7lACK62Yeam7up/c+z7ezU6/EvmktC6
         wUWn8jcqEyZ0eKASFcZycvGQML6eIcTJRcgkIORfOt2wbeVoEolp3x2zsyUddoKoBYiL
         hYHDlaDc3+GloVlZjBv8OzaBDwopbqPJdc64Crq4Thdah+NaqaUlCdu4gAOBLW8LvP+F
         owPDUZwy3Z83iC/oPmGI11pTCgqI95ahfVi44nF3xH3A9h9EEVDAWNRs9EG4YTTHIeYb
         nOurfVlu2G4uenKMyDQzZ6MyOs7deghXJEVUqvIcEdVSG7jbnoNNUNqfNtHB/PeE5Ugv
         Njmg==
X-Gm-Message-State: AOAM532Ou9AYtH6H2dRrFHG+73fGpVxPoY9R94CD+TBEhMg64qJj5ZJa
        v4VMCT0eRKU9fSroiugCjI+ckf+QIedXww==
X-Google-Smtp-Source: ABdhPJwp8S6t2yuqcDQHJpnqNcv3dB33tVAXer+vBpR9lznPa2NoI0f/1lYy8Ixu+bBOZ82Tr1QhGg==
X-Received: by 2002:a17:90b:513:: with SMTP id r19mr10424293pjz.38.1611393876660;
        Sat, 23 Jan 2021 01:24:36 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id bt8sm16314808pjb.0.2021.01.23.01.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 01:24:35 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     kuba@kernel.org, shuah@kernel.org
Cc:     krzk@kernel.org, netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next v3 0/2] Add nci suit and virtual nci device driver
Date:   Sat, 23 Jan 2021 18:24:23 +0900
Message-Id: <20210123092425.11434-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

A NCI virtual device can be made to simulate a NCI device in user space.
Using the virtual NCI device, The NCI module and application can be
validated. This driver supports to communicate between the virtual NCI
device and NCI module. To test the basic features of NCI module, selftest
for nci is added. Test cases consist of making the virtual NCI device
on/off and controlling the device's polling for NCI1.0 and NCI2.0 version.

1/2 is the Virtual NCI device driver.
2/2 is the NCI selftest suite

v3:
 1/2
 - change the Kconfig help comment.
 - remove the mutex init code.
 - remove the unnecessary mutex(nci_send_mutex).
 - remove the full_txbuff.
 - add the code to release skb at error case.
 - refactor some code.
v2:
 1/2
 - change the permission of the Virtual NCI device.
 - add the ioctl to find the nci device index.
 2/2
 - add the NCI selftest suite.

 MAINTAINERS                           |   8 +
 drivers/nfc/Kconfig                   |  11 +
 drivers/nfc/Makefile                  |   1 +
 drivers/nfc/virtual_ncidev.c          | 227 ++++++++++
 tools/testing/selftests/Makefile      |   1 +
 tools/testing/selftests/nci/Makefile  |   6 +
 tools/testing/selftests/nci/config    |   3 +
 tools/testing/selftests/nci/nci_dev.c | 599 ++++++++++++++++++++++++++
 8 files changed, 856 insertions(+)
 create mode 100644 drivers/nfc/virtual_ncidev.c
 create mode 100644 tools/testing/selftests/nci/Makefile
 create mode 100644 tools/testing/selftests/nci/config
 create mode 100644 tools/testing/selftests/nci/nci_dev.c

-- 
2.25.1

