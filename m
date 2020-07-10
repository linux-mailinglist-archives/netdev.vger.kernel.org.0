Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8856521BFB3
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 00:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgGJWU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 18:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgGJWU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 18:20:27 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481BAC08C5DD;
        Fri, 10 Jul 2020 15:20:27 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id o11so7350538wrv.9;
        Fri, 10 Jul 2020 15:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TDNee8GVeUeyBsCjyc6danC/ynEOptI+9KXBNHn5gUo=;
        b=Eyf7Dqdco0XD7yMgVIUmRlSHWZB3Yqq8yEWV6erE3fEu1ZVDFybSEoai1AU2qlB8nC
         tHOY1GTRGb0ZrmdlrlWHPoD5Q5jDdZig1hTAELuRNjP5qYKhynkh2LXjSw5gvSW0wbMI
         Hr1zTWrE2ZeZJiCUnsHnw5mJ1Et3f8gOoxwmhG7Q42fVi+sb4gmCFzl1cCcbPRkvMTRI
         CE/T9r99ELm4jgXAYzcrG7cCFNg06rWI5ZD78vepUnm4DNCzqgitB0kLfshyEnyOpkgN
         k57LCFynEjxTokoNDId4z1pkPe06ZoR7KjXhZ0lTkDKyDTUz4mTuGObVAisk47mhj7so
         ZrbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TDNee8GVeUeyBsCjyc6danC/ynEOptI+9KXBNHn5gUo=;
        b=PGdhr4Ym+YCgY6GL5zawKRUf7/PdpvjAr+Gvod+a6AXMVZEFhSeyotM8Iqpap9Mrb0
         QysOQnP5C86MZjq8BetqjmMiCgd4rRYjwWQzcGXVlGlL7tOldESBE10vm4gGMYriSwDK
         44dr9oL/RF2n0ME3kyR3BFo99Nfr402SucJwIxaCljchOV3ZfNtGjVJyja0sv76BSrIe
         DtdgVCWONH8a+RUlo3RpYttV6th7qCMk2GaOzqBYRdqqOBMkk8rRt3Z88PbrhaOD6QIH
         jbo60cqxklrgbP7AEnHXOWMJO0f3dbXHKgcBr9YtzVpEwfPfxCQU69sM111WE2HzWjWH
         buGw==
X-Gm-Message-State: AOAM531zOEKHA0QTbjF8CkWeKzP2uH0gtL8Wr613KG0JvEz+6dmknAFh
        VBpxDoL5IYQwC1BSGzafD+o=
X-Google-Smtp-Source: ABdhPJxrYIsBkfnBH9S5RucmDZWvO0yCzpX9cyPyswpKtcK/fL4BpEXiODFaS1wjD/qMUUJfHrsJHw==
X-Received: by 2002:adf:ef46:: with SMTP id c6mr69693527wrp.34.1594419625955;
        Fri, 10 Jul 2020 15:20:25 -0700 (PDT)
Received: from net.saheed (54007186.dsl.pool.telekom.hu. [84.0.113.134])
        by smtp.gmail.com with ESMTPSA id l18sm12170281wrm.52.2020.07.10.15.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 15:20:25 -0700 (PDT)
From:   Saheed Olayemi Bolarinwa <refactormyself@gmail.com>
To:     helgaas@kernel.org
Cc:     Bolarinwa Olayemi Saheed <refactormyself@gmail.com>,
        bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-pci@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, Russell Currey <ruscur@russell.cc>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        "Oliver O'Halloran" <oohall@gmail.com>,
        linuxppc-dev@lists.ozlabs.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Lukas Wunner <lukas@wunner.de>,
        linux-acpi@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 14/14 v3] PCI: Remove '*val = 0' from pcie_capability_read_*()
Date:   Fri, 10 Jul 2020 23:20:26 +0200
Message-Id: <20200710212026.27136-15-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200710212026.27136-1-refactormyself@gmail.com>
References: <20200710212026.27136-1-refactormyself@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>

There are several reasons why a PCI capability read may fail whether the
device is present or not. If this happens, pcie_capability_read_*() will
return -EINVAL/PCIBIOS_BAD_REGISTER_NUMBER or PCIBIOS_DEVICE_NOT_FOUND
and *val is set to 0.

This behaviour if further ensured by this code inside
pcie_capability_read_*()

 ret = pci_read_config_dword(dev, pci_pcie_cap(dev) + pos, val);
 /*
  * Reset *val to 0 if pci_read_config_dword() fails, it may
  * have been written as 0xFFFFFFFF if hardware error happens
  * during pci_read_config_dword().
  */
 if (ret)
	 *val = 0;
 return ret;

a) Since all pci_generic_config_read() does is read a register value,
it may return success after reading a ~0 which *may* have been fabricated
by the PCI host bridge due to a read timeout. Hence pci_read_config_*() 
will return success with a fabricated ~0 in *val, indicating a problem.
In this case, the assumed behaviour of  pcie_capability_read_*() will be
wrong. To avoid error slipping through, more checks are necessary.

b) pci_read_config_*() will return PCIBIOS_DEVICE_NOT_FOUND only if 
dev->error_state = pci_channel_io_perm_failure (i.e. 
pci_dev_is_disconnected()) or if pci_generic_config_read() can't find the
device. In both cases *val is initially set to ~0 but as shown in the code
above pcie_capability_read_*() resets it back to 0. Even with this effort,
drivers still have to perform validation checks more so if 0 is a valid
value.

Most drivers only consider the case (b) and in some cases, there is the 
expectation that on timeout *val has a fabricated value of ~0, which *may*
not always be true as explained in (a).

In any case, checks need to be done to validate the value read and maybe
confirm which error has occurred. It is better left to the drivers to do.

Remove the reset of *val to 0 when pci_read_config_*() fails.

Suggested-by: Bjorn Helgaas <bjorn@helgaas.com>
Signed-off-by: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
---
This patch  depends on all of the preceeding patches in this series,
otherwise it will introduce bugs as pointed out in the commit message
of each.
 drivers/pci/access.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 79c4a2ef269a..ec95edbb1ac8 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -413,13 +413,6 @@ int pcie_capability_read_word(struct pci_dev *dev, int pos, u16 *val)
 
 	if (pcie_capability_reg_implemented(dev, pos)) {
 		ret = pci_read_config_word(dev, pci_pcie_cap(dev) + pos, val);
-		/*
-		 * Reset *val to 0 if pci_read_config_word() fails, it may
-		 * have been written as 0xFFFF if hardware error happens
-		 * during pci_read_config_word().
-		 */
-		if (ret)
-			*val = 0;
 		return ret;
 	}
 
@@ -448,13 +441,6 @@ int pcie_capability_read_dword(struct pci_dev *dev, int pos, u32 *val)
 
 	if (pcie_capability_reg_implemented(dev, pos)) {
 		ret = pci_read_config_dword(dev, pci_pcie_cap(dev) + pos, val);
-		/*
-		 * Reset *val to 0 if pci_read_config_dword() fails, it may
-		 * have been written as 0xFFFFFFFF if hardware error happens
-		 * during pci_read_config_dword().
-		 */
-		if (ret)
-			*val = 0;
 		return ret;
 	}
 
-- 
2.18.2

