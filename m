Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F23234609
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 14:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387432AbgGaMnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 08:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733294AbgGaMnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 08:43:16 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39046C061574;
        Fri, 31 Jul 2020 05:43:16 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a26so5480429ejc.2;
        Fri, 31 Jul 2020 05:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z7WaVDyC31Xqp9aG4vaiaHbvwp6b775oA7lj7CzrKBo=;
        b=Boub8lNC8OOZzaDP7HakRmCigQ9s+TmAZKT/FvTXISovow+eY1+3iv9s7tVr5dADQb
         tIF5zqqI08ULoL0yyrXmhoapYfXxmRW0lyX2RCJXcewDU1EB9xdyPBrZABXn08aJJ28c
         Ix6TlonWfWSChmEA3cZnWfApy3SwFu1s8TocFkM7yBDwtH78cBXTAF1xTDgYs+VIg8UE
         kcTAWODekL0CEEpa/XJHHc7Z1xM6Zm5QjgRxMYhQQz3mO4eSz2plfe9QNw1SAJHLLj1J
         ZA6BNEbFTnFQK6vaB1h+hfyveE/uv2QDJ4RmDfBaoT3ERtSvXRg9SGL9BruBwod71w3x
         jyzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z7WaVDyC31Xqp9aG4vaiaHbvwp6b775oA7lj7CzrKBo=;
        b=odC0C2Z8qjc/R3Sxg0m4I69+a65FMfT2PdfWwCtNsIWoRrbgPdA+xt0zGud2eEx0/5
         ngabfGy3s7C4W9vCCQ0o1gmzVhzDwrJHa+wrLnWQIZayyjumBn8lNQRm3lYMXBMtA584
         LBXgkCEGQh2jyKGcN9NghACKAH4M7awzVYg1VpZs3kayTb10Qn+5lo/f00IJ9C41ipul
         jiZdEfgvwsirvdJvFev6GW5oGPl5s3uN+oJbhsoXzVbvVl5nWXJL4eBGM0NZvzTv44zI
         FPZvuIULjyCzNbGLSbnhZq93NPV4mixtQKviRH9hWBdcgs9bLaB4sAdkYnqQYEs/cU9h
         8+Vg==
X-Gm-Message-State: AOAM532XKTpbopjI5UTUXS/eMRcU41K8ehA6w8GKqZdSMzL3D1mGOAqk
        tM+vhD+Xftju+LX5tijJ6sc=
X-Google-Smtp-Source: ABdhPJz2I4wMlXEMP6P1KRM4mmo8+jpv64fXNEUIP720yCcVBp2o7uTyVYR6ab20bRx5VLVhSw6mFA==
X-Received: by 2002:a17:906:3281:: with SMTP id 1mr3932259ejw.132.1596199394967;
        Fri, 31 Jul 2020 05:43:14 -0700 (PDT)
Received: from net.saheed (95C84E0A.dsl.pool.telekom.hu. [149.200.78.10])
        by smtp.gmail.com with ESMTPSA id g23sm8668514ejb.24.2020.07.31.05.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 05:43:14 -0700 (PDT)
From:   "Saheed O. Bolarinwa" <refactormyself@gmail.com>
To:     helgaas@kernel.org
Cc:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Russell Currey <ruscur@russell.cc>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        "Oliver O'Halloran" <oohall@gmail.com>
Subject: [PATCH v4 12/12] PCI: Remove '*val = 0' from pcie_capability_read_*()
Date:   Fri, 31 Jul 2020 13:43:29 +0200
Message-Id: <20200731114329.100848-5-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200731114329.100848-1-refactormyself@gmail.com>
References: <20200731114329.100848-1-refactormyself@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
Signed-off-by: Saheed O. Bolarinwa <refactormyself@gmail.com>
---
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
2.18.4

