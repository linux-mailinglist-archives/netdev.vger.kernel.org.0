Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7AAC1BC194
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 16:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgD1OoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 10:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727803AbgD1OoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 10:44:03 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D46AC03C1AB;
        Tue, 28 Apr 2020 07:44:03 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id c21so7633701plz.4;
        Tue, 28 Apr 2020 07:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TmxpJsxXAhcqB+ToVZExhvip4vVPdz5UbfhJp3pb3Rg=;
        b=JpEdhd4cifBh5c7FfGbQpg7esariuAxGZdmCnyS/MuOKKFBlwHW46H+u1qAsGkWl2h
         4zsWi/VrJlXbHu2CYHRUPR8FdH6YM7fffG20ZpEkzng0T+DtKmC1H9/5dQLJRCNMRcQa
         4ED3iCvKAwqCjZNfyGqwfdqN5vXclVNZoOeViUVVt/8pmrJscHsJFlDwK8J43xsZwEt1
         u/qhIc6lEJyZp8T3pBgvhLjqZpJjnDttudRto6wWbva5vb2YHplTH8wq8Re/V+hYO8Vj
         USNMAP8K5ZuSDjJD4nEPMj+G2fUUFVQ2z9yRkyupnmoBFtpYnoAJbhf8Va1tuig3gSIX
         fVaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TmxpJsxXAhcqB+ToVZExhvip4vVPdz5UbfhJp3pb3Rg=;
        b=M8bCgYQ6zwlPtZEQFasWqyGRFuhTmavTnseT6BdZjxZDq2DihpQllaW7OxN2IFrAR5
         ECUTUK/ExXE3XRKKn3bYFCPJv96d79Dml0ZMxKanSMVb/rKsT8moNqQj5VMqELwIVH9r
         Pi0oju/Exs8ZaJQCR83IUKRqHREvNAfjqbZe1aDKOLwd7neVDpaGJ3RpgdYnXttbyNLK
         +HkE1mcr5jOcoBiI5dW2sj9blawqe33/zJPiyCWZUvAn5a9GV/5Sb+uxgrpBiUpp4ksY
         qa8QUuWAfSbcRk5fb02ALxmYfIxWZnwJaccOMFJvrPLkjPJ1wTcciIguZGyDtXTBYbaH
         YTzg==
X-Gm-Message-State: AGi0PuYj+btVWUxn5vIbVzJHVvsFSp4DDByIOXjhwgw5x+UFYlfb7JvK
        dr2f0PMUs1GATmxROB1ZhN8=
X-Google-Smtp-Source: APiQypLErRiVfS2BcM1F3SXg4qY/JpZaLDKctoUkSw9scfkA5By0Gg4GrF2ZF7DuR5iYOoa+PNuylg==
X-Received: by 2002:a17:902:5ac2:: with SMTP id g2mr13356131plm.167.1588085041193;
        Tue, 28 Apr 2020 07:44:01 -0700 (PDT)
Received: from varodek.localdomain ([2401:4900:40f3:10a2:97c1:b981:9f1:d7d0])
        by smtp.gmail.com with ESMTPSA id d203sm15053203pfd.79.2020.04.28.07.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 07:44:00 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Martin Habets <mhabets@solarflare.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        netdev@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        linux-kernel-mentees@lists.linuxfoundation.org, rjw@rjwysocki.net
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, skhan@linuxfoundation.org
Subject: [Linux-kernel-mentees] [PATCH v2 0/2] realtek ethernet : remove legacy power management callbacks.
Date:   Tue, 28 Apr 2020 20:13:12 +0530
Message-Id: <20200428144314.24533-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patch series is to remove legacy power management callbacks
from realtek ethernet drivers.

The callbacks performing suspend() and resume() operations are still calling
pci_save_state(), pci_set_power_state(), etc. and handling the powermanagement
themselves, which is not recommended.

The conversion requires the removal of the those function calls and change the
callback definition accordingly.

Vaibhav Gupta (2):
  realtek/8139too: Remove Legacy Power Management
  realtek/8139cp: Remove Legacy Power Management

 drivers/net/ethernet/realtek/8139cp.c  | 25 +++++++------------------
 drivers/net/ethernet/realtek/8139too.c | 26 +++++++-------------------
 2 files changed, 14 insertions(+), 37 deletions(-)

-- 
2.26.2

