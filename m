Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35CD20359A
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgFVLPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbgFVLPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:15:11 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3358C061794;
        Mon, 22 Jun 2020 04:15:10 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j1so8279555pfe.4;
        Mon, 22 Jun 2020 04:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qYAXPW7DT0kbvzrQebyhhIbPbS864IccOljK5pvAni0=;
        b=lftijr+BoVI2hKAc7YoyK6NPtN166LMRGO8r4gck9Aa5QzCc6tqZOvR68LxyOR4rOW
         b3MdgwPqdDDW+/jySMgdBT4pSqbFHM/O3eydto3DTigvIh+fwwLgcICyHKXFAcZ4Aeqg
         c/qBlBZ2uHXBvXFO1InOJ57M5ErQFNAv5Aj15mtTRcMJOslpucX46ZesUofRzcTe4RJb
         FtI2kOva6fiKZoUVLWWHTJN7YlLvyQVZE/2CM9X/wXhY+OE0HD4teXffpw73mB2eUIc6
         EIu8WSrKdeLX0aPSlKaiLEeGHRL9+cpNUT9Eijng6rEMbEhKugVMaoCM6BFbfqmNJlkE
         djDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qYAXPW7DT0kbvzrQebyhhIbPbS864IccOljK5pvAni0=;
        b=RfiZgW5rWikCAzYBzRON/3+ylCIqTocT7ze38wfSh36xyNIdgiRyFjsnlU1hM+frPL
         hHA2HZWLLsyHTLAvshbi+tTcXSuYYFsRuNj/6nVCEyUVaKWTV4DlOSAAUZp7NQQ7ClE3
         vePuidF2k9g8YXKNy9yZX2snOxkrvkkiOmQJlJnQyFikCL3upMgmmwVtHrasUMDVoKKa
         vm3LhpNxxCe4wnd5hHb8hO650jrw/Vz4WfUfsLm5C/LSzx2ucFBVllPslmiaenRehmsg
         sgb9GaArJfgx5NPTGXkW2IdW5k5hGYk7i/kMI2FStAfXFJzkUwBafeat+7iFQl8Uibrp
         pRmA==
X-Gm-Message-State: AOAM531hOs3xpgx57fIc5oezFHmTEMC7smZg45xGq2e/PPXGqQs1Fk14
        45YLwWKNFQnOVMplBQOFeBM=
X-Google-Smtp-Source: ABdhPJyCOvfUH6liRGyVXYWOxijl72Ct8WwDBg0elvqKh/Vgh2QOd6SHNWiMZ8xVMdwX5xl9H9MANg==
X-Received: by 2002:a62:194d:: with SMTP id 74mr20748665pfz.21.1592824510388;
        Mon, 22 Jun 2020 04:15:10 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id n189sm13950150pfn.108.2020.06.22.04.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 04:15:09 -0700 (PDT)
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
Subject: [PATCH v2 0/3] ethernet: amd: Convert to generic power management
Date:   Mon, 22 Jun 2020 16:43:57 +0530
Message-Id: <20200622111400.55956-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
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
  amd8111e: Convert to generic power management
  amd-xgbe: Convert to generic power management

 drivers/net/ethernet/amd/amd8111e.c      | 30 +++++++++---------------
 drivers/net/ethernet/amd/pcnet32.c       | 22 ++++++++---------
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c | 19 +++++++--------
 3 files changed, 31 insertions(+), 40 deletions(-)

-- 
2.27.0

