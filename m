Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06755232C23
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 08:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgG3GzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 02:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgG3GzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 02:55:22 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD09C061794;
        Wed, 29 Jul 2020 23:55:22 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k18so7249138pfp.7;
        Wed, 29 Jul 2020 23:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T0Z6YHYdP/kQD0cMS+cNQldOhqY6T8q1pjXPvT/YgO4=;
        b=sJHQjWFeZapA7zrwZIxIE8REiDhJKS03BGHy+fv+exmhsouiDjKNP6pB4JPX6oJZ2N
         9LRNoYnHYkWEMol453LnXg0cnizulm7UuBl5vdtL6/HD+Klx4JeEi1yWxGWXJy5mFZJ8
         oCmq4EV6O6hPuAIYlZ7sxo68dimM0sR6v5oNO2f3HyoJn4H4Sy89qV1c0suyEOcjJnaX
         GpJxiHwT3BKx4yDEWe4MpSnKGCUDQACea8cjQspPoM1U5EIPd2MP0B1iSxR2R8BLTUTV
         pu5HckTjI36WcWzG0jjeVa3ScxQhgex7oAoTZ5yypcd4DV/OOrcr5RK8LVkTwtRN6nRk
         VQ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T0Z6YHYdP/kQD0cMS+cNQldOhqY6T8q1pjXPvT/YgO4=;
        b=qew/DCATdJQw38r8Ayqu+sK9OmN1SKrwMlvLn5u15szbHQC/N8QoZJeEKonBzEfI0r
         pkzGx1cItTINwYqQrzti5gnq5TDlvZqKkhpax51YDjD2VEueNvY89gV6GMfHMI+4hMA6
         udJ+nwPP/IKvz8gKmJyUBUqAM2Rz5ihqS9KEyeGtMXGoUXQpDGaDd8IPYL1sj+Lt1czP
         W5FswfVZ4fO8y4omX8N79XwdY84XstjgVmFZ5xs8ZbY6TcDxs9TzJZB1eeRBpePOHohY
         VTIBmWeVbZ6d+ovRTL4jODFj6qxGoAyctL8efgkTOlvKMHeIzyXxUZvdGJoEoFI6jN0n
         vwGg==
X-Gm-Message-State: AOAM531oVwkhFi+9XGppHRF5ahzYpEluCrf3fqpeGKj1tYeYpSx36Ymo
        lojKZ1MCPws5GzyGgKkpfSU=
X-Google-Smtp-Source: ABdhPJyW4LPZe2cOetF8buGl87aOKuA3qtxG5q99ovH3JqxYH92fEEjJEt3HYNlIotq5+HrbpuIEcA==
X-Received: by 2002:a63:a06b:: with SMTP id u43mr33043681pgn.294.1596092122063;
        Wed, 29 Jul 2020 23:55:22 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id v2sm4232299pje.19.2020.07.29.23.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 23:55:21 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniele Venzano <venza@brownhat.org>,
        Samuel Chessman <chessman@tux.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v1 0/3] net: ethernet: use generic power management
Date:   Thu, 30 Jul 2020 12:23:33 +0530
Message-Id: <20200730065336.198315-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to upgrade power management in net ethernet
drivers. This has been done by upgrading .suspend() and .resume() callbacks.

The upgrade makes sure that the involvement of PCI Core does not change the
order of operations executed in a driver. Thus, does not change its behavior.

In general, drivers with legacy PM, .suspend() and .resume() make use of PCI
helper functions like pci_enable/disable_device_mem(), pci_set_power_state(),
pci_save/restore_state(), pci_enable/disable_device(), etc. to complete
their job.

The conversion requires the removal of those function calls, change the
callbacks' definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

Test tools:
    - Compiler: gcc (GCC) 10.1.0
    - allmodconfig build: make -j$(nproc) W=1 all

Vaibhav Gupta (3):
  sc92031: use generic power management
  sis900: use generic power management
  tlan: use generic power management

 drivers/net/ethernet/silan/sc92031.c | 26 ++++++++---------------
 drivers/net/ethernet/sis/sis900.c    | 23 +++++++--------------
 drivers/net/ethernet/ti/tlan.c       | 31 ++++++----------------------
 3 files changed, 22 insertions(+), 58 deletions(-)

-- 
2.27.0

