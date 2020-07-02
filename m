Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CBA211AC0
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 05:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgGBDxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 23:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgGBDxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 23:53:44 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE929C08C5C1;
        Wed,  1 Jul 2020 20:53:44 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a9so1437749pjh.5;
        Wed, 01 Jul 2020 20:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hcCDFvVNDv5tfHBu7VkyFE5uW3DJnle9jyk1SsEW+/A=;
        b=HQ3d90KI7yetZPuqqx7k8BY4KjIwP/0tv3uZF+dV+DW3Bz13WkomceOpelWoXBGXsc
         vX1Rftx/cbLSNYfwZUnZLrSyTL4UksHA4GSWjme/8qyohxEWEUzJFw4g3dyotyXrwZ9o
         J2Mdo7jpDppvBTIWEFLsHxz0GgUr/LQCNa+Ux07VIkktcj0rD5qSS3EXAjLx1XBTHnwl
         J9CIx42YO9CQvEdmTDU7IUXSadzxbe/tc8oDcLlsPvMw3FGrcZUYEgBAtZbKLXF5sMOJ
         rn3WjGSn1wAWS8ATEihsRoyNbwJYLQEuUbG7O5HNKU/htlWAKQMidubeEur0x5Raddmo
         GyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hcCDFvVNDv5tfHBu7VkyFE5uW3DJnle9jyk1SsEW+/A=;
        b=OSeDnmaALFTPOUdm4+ufCcB2KQ34tT31xKjVefweKpbSFowalhm2hqBSQcjI1EmIFI
         oM/o6Bu/fELniuTj5A9EpE/sz2l05ANCY57AerdWnMd6bjVgO23efQY2o9sAUiLW++LA
         zIgDwdRaHx/Y/H/oyjXidXgWL0z1+j4dl4nxxUlg7OI8EOHf85x3ds7R/jPN8In/53K6
         4RSIMQkaIfkXEtD829ZaYTj3F3ZvaPdveXu8Peylmt/7TzVuPtjiGGWi0/BjoXcJsNti
         OFzf0x8cGdt6ZfWtOj88SPeMJ9l9wmwlyRDbKHjPLoyQItreqkf2np/tDLXcQDbw/nDR
         idaw==
X-Gm-Message-State: AOAM530b5dE1bzVm0JS0rxVUmHrpYJspFsfP5VFXjN500iSW7TmVgp0P
        RMqD1n2aA8Q1sf1CsR2APxI=
X-Google-Smtp-Source: ABdhPJzQAlEoSv2wWBCHA+xcPr6SXxTyvg03M/f5jaWxBJ/sJLUUg4aleVJKBxDoQKVXd1eT0P+GTw==
X-Received: by 2002:a17:90a:2c0e:: with SMTP id m14mr7085307pjd.166.1593662024242;
        Wed, 01 Jul 2020 20:53:44 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id t187sm7308885pgb.76.2020.07.01.20.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 20:53:43 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 0/2] atheros: use generic power management
Date:   Thu,  2 Jul 2020 09:22:21 +0530
Message-Id: <20200702035223.115412-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to remove legacy power management callbacks
from atheros ethernet drivers.

The callbacks performing suspend() and resume() operations are still calling
pci_save_state(), pci_set_power_state(), etc. and handling the power management
themselves, which is not recommended.

The conversion requires the removal of the those function calls and change the
callback definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

Vaibhav Gupta (2):
  atl1e: use generic power management
  atl2: use generic power management

 .../net/ethernet/atheros/atl1e/atl1e_main.c   | 53 ++++-----------
 drivers/net/ethernet/atheros/atlx/atl2.c      | 64 ++++++-------------
 2 files changed, 31 insertions(+), 86 deletions(-)

-- 
2.27.0

