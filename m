Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD4721219A
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgGBKzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728477AbgGBKzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 06:55:12 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53E1C08C5C1;
        Thu,  2 Jul 2020 03:55:12 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x8so10279674plm.10;
        Thu, 02 Jul 2020 03:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zVDLoXI8L+yFA0AKDZ7bUdoOmqmHzhsfGkRFres4Vo8=;
        b=hdNYyNcYxBMGp0vsVUVonQjCpRwp++MyCLX9Du8x4iyfHlecQ3mb2EMkm/m/IRvvZg
         xYlhVFm8LAbWcdOZh/gw0VTE60cuCuVZsNil/9zRwJBa1t9v+SEArbG5G+lATbyMuurC
         lBeVipe3KDJyN/pcqw0qvyF+czgN2bbwgAVBHHuF8HO0gr5lkOMhwW58KXF0rdAuQEL1
         CpCI6J2bR8HsWTADn+oPoV4ckqy/yAk7O1crJe08+MVmGyvDNbF2vKgz/NPPK1cHAsoT
         oJOCKClxm16+jGJcCrY+xmMUcrZ6+E5U5SHFSDISL8179bkNn6vaLzok3MU9/KpSCIG/
         DwUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zVDLoXI8L+yFA0AKDZ7bUdoOmqmHzhsfGkRFres4Vo8=;
        b=pvcHOo503MEC4q8bVG3HyB8OjXOkWUCfbLgHmVyIX3Id0T2wTc9nO3ziJCHGqlnk3N
         NaGJBe2GqQmgcogDlXDD5mgbKLNB/GeodGtXo8OFBl1m4LYgpsC3t1NS/W+HMk4+scMO
         8hpBtlgmZKCLbFotgCLqESBXbV75hvtEGaZniyFd4DWCtDKr0qWMga3v/Wj0oUh0vmNw
         k9szx5ehRMkpyeJi3Z3Wcm2mMgTKv+OvnoHg/SMWy9KIiNIlnkdCed9edyMF/bLij9uS
         87zLx1f+e6QHAaZVKOmn/P4Pe32Gukpr9h2w0aIaJOYCoa14jgU5QR53IwA8YjR6Hs99
         SEbA==
X-Gm-Message-State: AOAM530lQufr6FAfEODo3UPmUmgkjjyi2AB2/WXm7JpvuZ5XslEMiK47
        dJig18ajVTXBDuDll2mX2bpWWCKIE/ycnA==
X-Google-Smtp-Source: ABdhPJxp+jQqbymWxFOlaBxL4wvWCrVMPfYTU4e2ktouEmQs2F9WH9ppF7JvRDsVQrDg7te85eQ/lA==
X-Received: by 2002:a17:90a:d104:: with SMTP id l4mr32286340pju.65.1593687312256;
        Thu, 02 Jul 2020 03:55:12 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id z13sm8702393pfq.220.2020.07.02.03.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 03:55:11 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 0/2] smsc: use generic power management
Date:   Thu,  2 Jul 2020 16:23:49 +0530
Message-Id: <20200702105351.363880-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to remove legacy power management callbacks
from smsc ethernet drivers.

The callbacks performing suspend() and resume() operations are still calling
pci_save_state(), pci_set_power_state(), etc. and handling the power management
themselves, which is not recommended.

The conversion requires the removal of the those function calls and change the
callback definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

Vaibhav Gupta (2):
  epic100: use generic power management
  smsc9420: use generic power management

 drivers/net/ethernet/smsc/epic100.c  | 19 +++++---------
 drivers/net/ethernet/smsc/smsc9420.c | 39 +++++++---------------------
 2 files changed, 16 insertions(+), 42 deletions(-)

-- 
2.27.0

