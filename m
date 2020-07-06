Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB475215446
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 10:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgGFI7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 04:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbgGFI7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 04:59:18 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EE3C061794;
        Mon,  6 Jul 2020 01:59:18 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m9so6445286pfh.0;
        Mon, 06 Jul 2020 01:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zB8UGJwVVuUJ7z3/tn8lFjXFFz4cB0VoK0RQrWVh/kA=;
        b=uY9d/63Dp+ffxpmCL07ExtVosl/D32ZNJg4ja/bHrJhk/IV/UUHToL53A/IHxIo7C1
         qD/AXxdx1siGqrKKEOxrZNvtasyRNeJZCLCfb8BtvqcBxn9JNAHA13cizHUgoRLByiWO
         7L7hg//e2h8O8b4xXUrS3dv6/y7CHfbMTK/G6NxfcU8VM6xEPSuH5hNdMc3qXVCG0JK/
         2h99miDaU36t1SUrfybO4NVlMTlPl8Rm7l7smOVT5mpssxn7xEqN2tIlftaIcmH5ZT6I
         IeV1Ovf9TPgzQWbfQ2pnU/W2zX6dOExvriSFUTqAEicasSf+ikXzNmn8SQpj7Wt+k3oe
         4WhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zB8UGJwVVuUJ7z3/tn8lFjXFFz4cB0VoK0RQrWVh/kA=;
        b=EFZB5c3lmDELe+yb1YKFlNF/NAccRsTPy2g08afO3+r3ob/WiXC7PrlH6p0v5Nta6T
         wsHNjKzTLhLtJamRIFAx8A3Ghfme+LXOtOzXgkavFyP71DlF+SkFa4xSGIFwb0j3yX7/
         n9+S+fZbVatSeYa9QJyt6HE8MMiumJeMedphzJcaqenZpiyp2v23BNdsY1DjoAIbjCn6
         kK1jlmeKwxN/PPMfLZW4AvRd5Qd+8YWE1L0FeRIprgJpK98mb8/xl2OZwUKSIWqnpURe
         QVfbAhtRBBWUBrmFtSCeWJf4w3oGKilFonZ0nbYPOPM/ajWj1sgx2ZQ6GcrZnTjTq5Tb
         y4IQ==
X-Gm-Message-State: AOAM530OpJ8GNVSP7J8O369EoKdiT/GEVAoSSbzKgc2026mrjNaCtb6V
        uJ1Rdqv7QLGQRJ+qZPo/8+Q=
X-Google-Smtp-Source: ABdhPJwp6m7DYniWo1fOmyV+2e0zCqDDXlJnFgjk/KIBDiKmQnuJ+/xhXasYN/AnUW0PDcs0uTH+dg==
X-Received: by 2002:aa7:86c1:: with SMTP id h1mr30044632pfo.175.1594025957343;
        Mon, 06 Jul 2020 01:59:17 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id a19sm10068149pfn.136.2020.07.06.01.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 01:59:16 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 0/3] ethernet: sun: use generic power management
Date:   Mon,  6 Jul 2020 14:27:43 +0530
Message-Id: <20200706085746.221992-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to remove legacy power management callbacks
from sun ethernet drivers.

The callbacks performing suspend() and resume() operations are still calling
pci_save_state(), pci_set_power_state(), etc. and handling the power management
themselves, which is not recommended.

The conversion requires the removal of the those function calls and change the
callback definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

Vaibhav Gupta (3):
  sun/sungem: use generic power management
  sun/niu: use generic power management
  sun/cassini: use generic power management

 drivers/net/ethernet/sun/cassini.c | 17 +++----
 drivers/net/ethernet/sun/niu.c     | 17 +++----
 drivers/net/ethernet/sun/sungem.c  | 76 +++++++++++++++++-------------
 3 files changed, 57 insertions(+), 53 deletions(-)

-- 
2.27.0

