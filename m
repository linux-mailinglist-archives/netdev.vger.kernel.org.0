Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9772FD182
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 14:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbhATMvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732588AbhATL5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 06:57:24 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB0FC0613C1;
        Wed, 20 Jan 2021 03:56:59 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id j12so2024850pjy.5;
        Wed, 20 Jan 2021 03:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5ciqHBudDYdod/bIfnJXN6ERypUAQCsPz7yvk11/qRw=;
        b=uVwQiXgYFpdw5DuHGtXhBVumDJ8YggqHu3QzSnWvDTWZpOdQbzav8hSlzIEnbUv6sR
         Z8dg3RF+LGJJIHT18PXELaPHFcHVFInDsqcQarTcBcpezUAKJE9Wxx4amTN3qnQzTN79
         v2Z4J/z7vvL4Eu4RYV9VvcbaHrvfby8AhAhx4x5GIuZ6bT/PAVmjoE9+zigrFmT/3EHP
         rr8Wtoyd0QlprjhJcceQdvR9B/PepF3zHJ+wqh5T8jm47YjT0w146mcpLWR8vicsPcBX
         k6gK4TALdiElcqEzWeIz5+cZlA1rRLv9RRgrOo3hE7FfjJKZuFUJGwMCsZE1t3Uo+xDu
         0m8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5ciqHBudDYdod/bIfnJXN6ERypUAQCsPz7yvk11/qRw=;
        b=NE4JqXJg8zRMHwWmjBC24G0ta4M7ae5YFhyIezo6C4tXMGd27DgkvvEmRJkal0L492
         EXVrYz6XNM3hUZ8w/Ml3rZz6hjQU6IiaVS8eDHAmUBXwVFtjtBYtlJZwC6Rf2GvXQ9CJ
         QKMzqWm47d+tl353vMaEQLKcBJaxa+mpt2oKyDkCbMgch//wBH2uamVWvB7k/8vBnNhD
         A4v8RtRGFZcbcJumuOvwDTFn3VDf22EIbAMTYDwCy6soqK8b+5g0nOGL8ItK48NfpoVs
         UQrbjmPe1qOvH5zDnMqz7XALS/mXzM7rIs8rVTCNdcmvbh1HD1BduTmTW5fP+Tfe1NIa
         vi7g==
X-Gm-Message-State: AOAM533QVA7d6w1q6czC+soAB/r6jvW9DM65KHV7uoIh8GhsydscPyzl
        2Bl8623siHabnIbxFZ0xifE=
X-Google-Smtp-Source: ABdhPJzVxazGkkCUGipHSo0jA8aEZJjv987UI+W41slbgRHxGIC80Q39eIuDbNaCE6MtdJqHAXnbWw==
X-Received: by 2002:a17:902:9005:b029:da:f580:c5f7 with SMTP id a5-20020a1709029005b02900daf580c5f7mr9633007plp.85.1611143819037;
        Wed, 20 Jan 2021 03:56:59 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id f13sm6487856pjj.1.2021.01.20.03.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 03:56:58 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     kuba@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next v2 0/2] Add nci suit and virtual nci device driver
Date:   Wed, 20 Jan 2021 20:56:43 +0900
Message-Id: <20210120115645.32798-1-bongsu.jeon@samsung.com>
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
for NCI is added. Test cases consist of making the virtual NCI device
on/off and controlling the device's polling for NCI1.0 and NCI2.0 version.

1/2 is the Virtual NCI device driver.
2/2 is the NCI selftest suite

v2:
 1/2
 - change the permission of the Virtual NCI device.
 - add the ioctl to find the nci device index.
 2/2
 - add the NCI selftest suite.

Bongsu Jeon (2):
  nfc: Add a virtual nci device driver
  selftests: Add nci suite

 MAINTAINERS                           |   8 +
 drivers/nfc/Kconfig                   |  11 +
 drivers/nfc/Makefile                  |   1 +
 drivers/nfc/virtual_ncidev.c          | 235 ++++++++++
 tools/testing/selftests/Makefile      |   1 +
 tools/testing/selftests/nci/Makefile  |   6 +
 tools/testing/selftests/nci/config    |   3 +
 tools/testing/selftests/nci/nci_dev.c | 599 ++++++++++++++++++++++++++
 8 files changed, 864 insertions(+)
 create mode 100644 drivers/nfc/virtual_ncidev.c
 create mode 100644 tools/testing/selftests/nci/Makefile
 create mode 100644 tools/testing/selftests/nci/config
 create mode 100644 tools/testing/selftests/nci/nci_dev.c

-- 
2.25.1

