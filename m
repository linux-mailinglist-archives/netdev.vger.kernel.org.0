Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1935221BF9D
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 00:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgGJWUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 18:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbgGJWUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 18:20:11 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B1EC08C5DC;
        Fri, 10 Jul 2020 15:20:11 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z2so7351704wrp.2;
        Fri, 10 Jul 2020 15:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sQSNR/BugIoJc6hRmCvyOY2T/BtHesGbyrXiTgar9dI=;
        b=E/WvXIbdBLzBijEIrHjy3ROSLzxYB5kRcgXlTWV5s6nTjk0sIxLxLV8dtFIH5vEf/H
         U3eWv/xfzqF2tIQrGPbwIRR+9fsr3gC+Af8kb4EapkgW9zT1y/O6QsdJtedCfC+yuMe/
         KhighYvpRyQnvVu4JLLuQojc1o28CCTGSLa/Vc7qo5GY/zFYL/85uWjW98zmkPmndBES
         mAL7VvNIpEqvxJ1y9qrWHkQw7gdl6GJkw3mcT+pmgsizutcBpX00cH6+jfPFxCmME6bi
         I2ZMDOM7hADKIDhEsG+aR5z3LW8kLVbqkzK9d8Ey3Xa9e5RkgEjZbSXxXl+6egvtEr7E
         enFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sQSNR/BugIoJc6hRmCvyOY2T/BtHesGbyrXiTgar9dI=;
        b=NWjnB7x1qLoeEAwuCZ8FziB5NmWpP255Qkg5QSm43J9pQ8337MUeMASzfTeiB01wYo
         edZ2mahnv6jHoCbgox8yIew4l2YMnX2V0Sgh316SNH0cqqqVm2QDG0SV6yBMMRDquWoK
         ZWpUuxeq6PAE6PRMJ2YIGHQQFTP/SIMUKeYVP8vhcZ+Z1A8/ulDIKF/jYufT0B+dRYyn
         CDbIdHrvHQWm80TOvNszuqOFfQN1NlLx4W48yfemfIi4444AK0nKCVjbBl9Hf+Xc1TMo
         E8HTGdR8mN9WUsbMamoj+ytUXlcCXbREONkmwm3DzMr8HDFuLQnfDUW1CerTWAmUlfHi
         U3mw==
X-Gm-Message-State: AOAM531NHqKYLsqRGBpnHKdZgNeDXA8k3xw/nNzO4sHvtCaKXARR1Ibd
        izLvHuCU0uXw1xr12BJmjzs=
X-Google-Smtp-Source: ABdhPJzS+uPpTiLsWNHg6xiOAW9CUTiS8ft4sXtfvWRv8joGH8d+W+t6FJyQoDufDDsZv9lKN31XXA==
X-Received: by 2002:adf:ef4d:: with SMTP id c13mr67998573wrp.315.1594419608520;
        Fri, 10 Jul 2020 15:20:08 -0700 (PDT)
Received: from net.saheed (54007186.dsl.pool.telekom.hu. [84.0.113.134])
        by smtp.gmail.com with ESMTPSA id l18sm12170281wrm.52.2020.07.10.15.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 15:20:07 -0700 (PDT)
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
Subject: [PATCH 0/14 v3] PCI: Remove '*val = 0' from pcie_capability_read_*()
Date:   Fri, 10 Jul 2020 23:20:12 +0200
Message-Id: <20200710212026.27136-1-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>

v3 CHANGES:
- Split previous PATCH 6/13 into two : PATCH 6/14 and PATCH 7/14
- Fix commit message of PATCH 5/14
- Update Patch numbering and Commit messages
- Add 'Acked by Greg KH' to PATCH 2/14
- Add PATCH version

v2 CHANGES:
- Fix missing comma, causing the email cc error
- Fix typos and numbering errors in commit messages
- Add commit message to 13/13
- Add two more patches: PATCH 3/13 and PATCH 4/13

MERGING:
Patch 7/14 depends on Patch 6/14. However Patch 6/14 has no dependency.
Please, merge PATCH 7/14 only after Patch 6/14.
Patch 14/14 depend on all preceeding patchs. Except for Patch 6/14 and
Patch 7/14, all other patches are independent of one another. Hence,
please merge Patch 14/14 only after other patches in this series have
been merged.


PATCH 6/14:
Make the function set status to "Power On" by default and only set to
Set "Power Off" only if pcie_capability_read_word() is successful and
(slot_ctrl & PCI_EXP_SLTCTL_PCC) == PCI_EXP_SLTCTL_PWR_OFF. 

PATCH 1/14 to 13/14:
Check the return value of pcie_capability_read_*() to ensure success or
confirm failure. While maintaining these functions, this ensures that the
changes in PATCH 14/14 does not introduce any bug. 

PATCH 14/14:
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

Check the return value of pcie_capability_read_dword() to ensure success
and avoid bug as a result of Patch 14/14.
Remove the reset of *val to 0 when pci_read_config_*() fails.


Bolarinwa Olayemi Saheed (14):
  IB/hfi1: Check the return value of pcie_capability_read_*()
  misc: rtsx: Check the return value of pcie_capability_read_*()
  ath9k: Check the return value of pcie_capability_read_*()
  iwlegacy: Check the return value of pcie_capability_read_*()
  PCI: pciehp: Check the return value of pcie_capability_read_*()
  PCI: pciehp: Make "Power On" the default 
  PCI: pciehp: Check the return value of pcie_capability_read_*()
  PCI/ACPI: Check the return value of pcie_capability_read_*()
  PCI: pciehp: Check the return value of pcie_capability_read_*()
  PCI: Check the return value of pcie_capability_read_*()
  PCI/PM: Check return value of pcie_capability_read_*()
  PCI/AER: Check the return value of pcie_capability_read_*()
  PCI/ASPM: Check the return value of pcie_capability_read_*()
  PCI: Remove '*val = 0' from pcie_capability_read_*()

 drivers/net/wireless/ath/ath9k/pci.c         | 5 +++--
 drivers/net/wireless/intel/iwlegacy/common.c | 4 ++--
 drivers/infiniband/hw/hfi1/aspm.c | 7 ++++---
 drivers/misc/cardreader/rts5227.c | 5 +++--
 drivers/misc/cardreader/rts5249.c | 5 +++--
 drivers/misc/cardreader/rts5260.c | 5 +++--
 drivers/misc/cardreader/rts5261.c | 5 +++--
 drivers/pci/pcie/aer.c  |  5 +++--
 drivers/pci/pcie/aspm.c | 33 +++++++++++++++++----------------
 drivers/pci/hotplug/pciehp_hpc.c | 47 ++++++++++++++++----------------
 drivers/pci/pci-acpi.c           | 10 ++++---
 drivers/pci/probe.c              | 29 ++++++++++++--------
 drivers/pci/access.c | 14 --------------
 13 files changed, 87 insertions(+), 87 deletions(-)

-- 
2.18.2

