Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D8F1E1CD7
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 10:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731390AbgEZIE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 04:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbgEZIEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 04:04:54 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DE1C03E97E;
        Tue, 26 May 2020 01:04:53 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id bg4so3034802plb.3;
        Tue, 26 May 2020 01:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s99asDh3KqWhbtaAWLoxUL9KkIJuoxOh8yq3KY5BrWQ=;
        b=Tz1zKCSoTHHucRUc2yQMyukp4e4qrrwhsUh8b0LQrY+j7riVutzUZ3CdlTFW/zCDVc
         dnKevt+yNUl38GN2jcDl4l5Kvb2EIC6LSqa8H8/JFf55FpvMUDy0e60PpgI6GXxxC4Qe
         28awVQt3Hm+8J3+1SFfBLTURZKgQwr2qQAspbd6CoJMSA9M0TCdlwjrXXX6/RULjc2T8
         nc7NDHCX/ajltPg/trR5I8CnaKcaAFDRewfBGqkpphf4ryBTZelSLJEELCJCLHQKR/Bd
         +WGauubie/aXE4QWdEIzL/I8XvsvJFMu+RPerGK9qY5r62v44NBvdMtTmKVABFYdoYW6
         ms+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s99asDh3KqWhbtaAWLoxUL9KkIJuoxOh8yq3KY5BrWQ=;
        b=PBbtXGvDrgxbV8fUNOjY8eGAvFBh35iBk+KSPFKL7KdvJbAMTQ/HKKaHQh4yABerug
         76I54eUnjURUDEUz6ygORPctZyTJap5u1qWp75kf95D8/8DXDbnLlqJf89ZE8yv0Tj3t
         VGDq4NKnSmiWar6qk+i7WAxzP6JihOwsPz+YOnxPOXBdzTyrkFSMAZNegCJ/6lz8heFi
         u/A9+ODygq4pTvMgYUA+X3QbnLRNqS9EOn9tPjG/g3F+QVR7RBxnBX/r5TjH+iBa5JrA
         cwP3jbsLuiJsITJrVe9sjVpuAyHxx33puqUS5j8Xbwa4S+k62cmGwTGWHQyNRSrA7RFH
         1S1g==
X-Gm-Message-State: AOAM531qdMwwDrH5ORR32mj/B6aJdoCMiNp8FjNPi6ky7AnxrnB75QgB
        wdbrxQ9jfAL34AIxkHYzMFI=
X-Google-Smtp-Source: ABdhPJy9soyYLetfBPPjblNk1wYJKFUpB+0tOinBo70tQjNFkLGhKbqWqfN4gafp7nz51rwX6HIOhg==
X-Received: by 2002:a17:90b:3d7:: with SMTP id go23mr16352740pjb.9.1590480292908;
        Tue, 26 May 2020 01:04:52 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.209])
        by smtp.gmail.com with ESMTPSA id fa19sm8614477pjb.18.2020.05.26.01.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 01:04:52 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Don Fry <pcnet32@frontier.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [RFC PATCH v1 0/3] ethernet: amd: Convert to generic power management
Date:   Tue, 26 May 2020 13:33:21 +0530
Message-Id: <20200526080324.69828-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to remove legacy power management callbacks
from amd ethernet drivers.

The callbacks performing suspend() and resume() operations are still calling
pci_save_state(), pci_set_power_state(), etc. and handling the power management
themselves, which is not recommended.

The conversion requires the removal of the those function calls and change the
callback definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

Vaibhav Gupta (3):
  pcnet32: Convert to generic power management
  amd8111e: Convert to generic power mangement
  amd-xgbe: Convert to generic power management

 drivers/net/ethernet/amd/amd8111e.c      | 30 +++++++++---------------
 drivers/net/ethernet/amd/pcnet32.c       | 22 ++++++++---------
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c | 17 +++++++-------
 3 files changed, 31 insertions(+), 38 deletions(-)

-- 
2.26.2

