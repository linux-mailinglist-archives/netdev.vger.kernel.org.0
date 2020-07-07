Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3834217B90
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 01:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbgGGXEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 19:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729241AbgGGXEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 19:04:01 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E509C061755;
        Tue,  7 Jul 2020 16:04:01 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a1so48441840ejg.12;
        Tue, 07 Jul 2020 16:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TDNee8GVeUeyBsCjyc6danC/ynEOptI+9KXBNHn5gUo=;
        b=PD50e4vMzFR5le1ao1Ae6vuTHCknkbfKAiLbDT70l8X7nzwML3pjQqA/vBosHSFuHD
         G/LmYKcCftSPXGToiWf2pSbxg58KVWi8a9p117WWcHau/A7enRJRWV/wGFL9vKWZagej
         aVVo7PLCLbdnDwnv5hvhukqzop+1wL1PClfZ/fuZE8Z27Mna7vdlk3vbB5yUurj2KXxf
         piFaUYZZmp5oAUkoR1GPB9tSDp+AbcdaQoIXkRhNNiBiIOjdbUazjlJh0ZtSx0QMpi7x
         PJp3pV9sVay5rgP9GqI/ABxAKS4wW3STZIWur29NuukyNc4xcJ3Y3XC7CaduhYn5ha1x
         4sUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TDNee8GVeUeyBsCjyc6danC/ynEOptI+9KXBNHn5gUo=;
        b=IhA1Mb+8fub+0mdi5w5rW+VQ2Bkz50wSVIUY7ujpBKrs6+vELFK5dBeafVb4NIY6gO
         QYzrSP17K+O1BkNKraTLw9ih2FbJLeuzMxILKIIWNF70vOIBknpbZvhV5pP8IbJS+X8Q
         dw2+/VoWBkrRL65+OBVKj/G3/ygDB48pfH4j6WF3x+hQmgk2mhV6R6A8Azt6YxF+stlu
         VXp9SsPzGLvvrQvyrioQXIMF6ko6bkkTxeWrKFfUPhbfydcWyd5NBhShScIh3udc9IaN
         Jj5IxXHUvp9Vtkf7bxg3LGnbaxp1YJvMWoYFknUGewClDdoDfHgyKac8Wv41+OAFwfu2
         U42Q==
X-Gm-Message-State: AOAM530DRcx+gomMssPrLly9AEPEkylCDgV590H7G01Apc2vR5XpWAkG
        CIwYOFylWsJdkqLgxIvaGVY=
X-Google-Smtp-Source: ABdhPJy5RfHewjT0dnWFda9i0XhBHF0l10D3kiKEqleSJ0mL94SUpk1lTLn4o9t2bQPzn68Xo9d2yw==
X-Received: by 2002:a17:906:d217:: with SMTP id w23mr38205012ejz.292.1594163039774;
        Tue, 07 Jul 2020 16:03:59 -0700 (PDT)
Received: from net.saheed (54007186.dsl.pool.telekom.hu. [84.0.113.134])
        by smtp.gmail.com with ESMTPSA id f10sm27096310edx.5.2020.07.07.16.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 16:03:58 -0700 (PDT)
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
Subject: [PATCH 13/13] PCI: Remove '*val = 0' from pcie_capability_read_*()
Date:   Wed,  8 Jul 2020 00:03:24 +0200
Message-Id: <20200707220324.8425-14-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200707220324.8425-1-refactormyself@gmail.com>
References: <20200707220324.8425-1-refactormyself@gmail.com>
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

