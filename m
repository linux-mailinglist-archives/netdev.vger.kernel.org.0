Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B0020CC27
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 05:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgF2Ddk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 23:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbgF2Ddk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 23:33:40 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F42FC03E979;
        Sun, 28 Jun 2020 20:33:40 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f2so6542627plr.8;
        Sun, 28 Jun 2020 20:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fYJKmE7yRo1ixIz8HpJIKtPVneklCF0ayYZCHIK8EeE=;
        b=ccEw8pDgO7NJNzDs8/7IFb44i/405jgQahmjmw0raESl6GJAwudPJl180HDwTGkU5e
         m9zB6pFPv73MAAbRbVnUMpdnbfsfT6uSWw81J4okpgmBtFr3tKTSp+wwoIkvMzUAO7BH
         aGc6sEa3/+MeaXkgXdnUtL7nd/Ze0m6L56MgGDTN3c32wyW6wrb2oXoa/J9miE2qLHT4
         ByBWtU8m3FeX1BhoZfTUgMZGBF+d5jFkEzkoEjUNwHKIoV4lHjOkdXumOjzRSi0njIBD
         U0bcJOaNPqsscII0jzSX6EZlbGuSk2uZmqR0jLIslptv4DutAKZ1HN7akNTVlTSFxL/v
         cWbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fYJKmE7yRo1ixIz8HpJIKtPVneklCF0ayYZCHIK8EeE=;
        b=EaH+chBXTwLGmW5qSrJSv6p63mJDTMdWFZBfRgLaTVN4FysoUPb+M9DImeE3FWCpPe
         TJ1DyId/2yiQgybck004SKKjjp7BRL+Z7Tk5OS84SJ47azugCNZnbqqCAVhrCOX349IX
         67PQFE0dvxO0NiLkwsggK/U35JGavgh8FZOCp8UvUkzWDnY5it7iMZGqUl+BLOAVkUH1
         ip+53iHKr5zvRC0aNCaJ/IV/vElh0seBCBimNFRoeah8REV9FjHPnurFkt3DYdKFaTlq
         1tq7AseCjvKUBxtTCqLfffs720g7H1aCunfKoFmricUpcCK8ci8aTK2Q6VvFAePR+Q2G
         Iqqg==
X-Gm-Message-State: AOAM5321VI4HTPtnkX0i74PQMnQosWAyEv025qzbWrKNK8CbJOxBSaMu
        AM5MtLM2IQIcmRQyI3zepbgCuhz1Ofs=
X-Google-Smtp-Source: ABdhPJz+JdBvOqVV/+8nOkMDZE+YnbOlM+MtB6ZHTco9p5/atAcS3aB8wtXbL2GHSw//dWLW9U0lww==
X-Received: by 2002:a17:90a:ea84:: with SMTP id h4mr4007676pjz.128.1593401619651;
        Sun, 28 Jun 2020 20:33:39 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id e191sm10679196pfh.42.2020.06.28.20.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 20:33:38 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 0/2] ipw2x00: use generic power management
Date:   Mon, 29 Jun 2020 09:02:24 +0530
Message-Id: <20200629033226.160936-1-vaibhavgupta40@gmail.com>
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

Vaibhav Gupta (2):
  ipw2100: use generic power management
  ipw2200: use generic power management

 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 31 +++++---------------
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 30 +++++--------------
 2 files changed, 14 insertions(+), 47 deletions(-)

-- 
2.27.0

