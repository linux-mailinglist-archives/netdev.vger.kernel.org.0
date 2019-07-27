Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5393E77930
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 16:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387757AbfG0OVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 10:21:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44695 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbfG0OVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 10:21:33 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so25815363pfe.11;
        Sat, 27 Jul 2019 07:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=y63nlDdoReiitfVEZgVBo7xRRyCxoDD8AEYgo5/VomM=;
        b=T+UzIYi/1THcC8I6GGTQVftBbmYmneEqyzoZFaOOV0bsgkD4/yotJY+aT39yhYMbKU
         hP7XuGXa26yH/rd2Nj/oFrTDYEcp5JUuY3kmmuDDU7fPuMGddkQghGbGlfTO+H8pKvVB
         pSe3h0PTMAUsbiz2LBWk2Z19ayzMznrnydOiG1Hn9M1yV6yTmgyr6pygeBUIKivIxRkK
         AslNgkHOQWvuyAhddym0LYgEWCybK94ah26A3c+j6bFoy1BFojsB3uQ/zIoW1PPLaFzG
         iRc8ls7OCAbEHg78NFqB9lL8kFZRs8DzukHcVHBv38OGkga6Mp045UeW3iThwjfRKg8C
         KTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=y63nlDdoReiitfVEZgVBo7xRRyCxoDD8AEYgo5/VomM=;
        b=gN+7gHPGpGXMgQIf2fTdVCCcQGyIYxFDwD1LgnM3Z6HSzmNp7Ty4C9fsV25Co/EifC
         /vcsQXY+K3cTSNQDtunfZEhcteRZk64oTogBH93bfyIUX+pKyd4/d6LIPSE/BobsIpLy
         F17XCo0vs1NpiH65BQgHUFYgXbucZcdrpYVHGkYLntXzm6GW6FfCcaNkmqT0aNSARQHJ
         +ZUdgWvTvzu4m5uIetTc/EMNnQ11bFd1dO7PMbl9wxHe1UR2If/rpPxQkp7LR4azXGpX
         uYeQPaptwQzF+fRUGYNqApt0hGi1vH5iK9lFgn5SIObeRuytR9ODNU/fNcU+KvCgaTWf
         vDRA==
X-Gm-Message-State: APjAAAUnertKEz0DK3+KUTjeUIURivcKM0sHPfg18wzHzSQtsk57ygpB
        RSqX0jfz0ETgmkqxsBrCWCY=
X-Google-Smtp-Source: APXvYqwImUJ0RccHZPsxX4PaZHY9X78k754oNQpfDLf2SEuy6uSlyklXeLtGbLK7+kjMFAkrLZ0G0A==
X-Received: by 2002:a65:5cca:: with SMTP id b10mr98493196pgt.365.1564237291919;
        Sat, 27 Jul 2019 07:21:31 -0700 (PDT)
Received: from localhost.localdomain (36-238-206-183.dynamic-ip.hinet.net. [36.238.206.183])
        by smtp.googlemail.com with ESMTPSA id c8sm63671109pjq.2.2019.07.27.07.21.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Jul 2019 07:21:31 -0700 (PDT)
From:   Pei Hsuan Hung <afcidk@gmail.com>
Cc:     afcidk@gmail.com, trivial@kernel.org,
        Russell Currey <ruscur@russell.cc>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        "Oliver O'Halloran" <oohall@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] Fix typo reigster to register
Date:   Sat, 27 Jul 2019 22:21:09 +0800
Message-Id: <20190727142111.20039-1-afcidk@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Pei Hsuan Hung <afcidk@gmail.com>
Cc: trivial@kernel.org
---
 arch/powerpc/kernel/eeh.c                           | 2 +-
 arch/powerpc/platforms/cell/spufs/switch.c          | 4 ++--
 drivers/extcon/extcon-rt8973a.c                     | 2 +-
 drivers/gpu/drm/arm/malidp_regs.h                   | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h | 2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                    | 4 ++--
 fs/userfaultfd.c                                    | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index c0e4b73191f3..d75c9c24ec4d 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1030,7 +1030,7 @@ int __init eeh_ops_register(struct eeh_ops *ops)
 }
 
 /**
- * eeh_ops_unregister - Unreigster platform dependent EEH operations
+ * eeh_ops_unregister - Unregister platform dependent EEH operations
  * @name: name of EEH platform operations
  *
  * Unregister the platform dependent EEH operation callback
diff --git a/arch/powerpc/platforms/cell/spufs/switch.c b/arch/powerpc/platforms/cell/spufs/switch.c
index 5c3f5d088c3b..9548a086937b 100644
--- a/arch/powerpc/platforms/cell/spufs/switch.c
+++ b/arch/powerpc/platforms/cell/spufs/switch.c
@@ -574,7 +574,7 @@ static inline void save_mfc_rag(struct spu_state *csa, struct spu *spu)
 {
 	/* Save, Step 38:
 	 *     Save RA_GROUP_ID register and the
-	 *     RA_ENABLE reigster in the CSA.
+	 *     RA_ENABLE register in the CSA.
 	 */
 	csa->priv1.resource_allocation_groupID_RW =
 		spu_resource_allocation_groupID_get(spu);
@@ -1227,7 +1227,7 @@ static inline void restore_mfc_rag(struct spu_state *csa, struct spu *spu)
 {
 	/* Restore, Step 29:
 	 *     Restore RA_GROUP_ID register and the
-	 *     RA_ENABLE reigster from the CSA.
+	 *     RA_ENABLE register from the CSA.
 	 */
 	spu_resource_allocation_groupID_set(spu,
 			csa->priv1.resource_allocation_groupID_RW);
diff --git a/drivers/extcon/extcon-rt8973a.c b/drivers/extcon/extcon-rt8973a.c
index 40c07f4d656e..e75c03792398 100644
--- a/drivers/extcon/extcon-rt8973a.c
+++ b/drivers/extcon/extcon-rt8973a.c
@@ -270,7 +270,7 @@ static int rt8973a_muic_get_cable_type(struct rt8973a_muic_info *info)
 	}
 	cable_type = adc & RT8973A_REG_ADC_MASK;
 
-	/* Read Device 1 reigster to identify correct cable type */
+	/* Read Device 1 register to identify correct cable type */
 	ret = regmap_read(info->regmap, RT8973A_REG_DEV1, &dev1);
 	if (ret) {
 		dev_err(info->dev, "failed to read DEV1 register\n");
diff --git a/drivers/gpu/drm/arm/malidp_regs.h b/drivers/gpu/drm/arm/malidp_regs.h
index 993031542fa1..0d81b34a4212 100644
--- a/drivers/gpu/drm/arm/malidp_regs.h
+++ b/drivers/gpu/drm/arm/malidp_regs.h
@@ -145,7 +145,7 @@
 #define     MALIDP_SE_COEFFTAB_DATA_MASK	0x3fff
 #define     MALIDP_SE_SET_COEFFTAB_DATA(x) \
 		((x) & MALIDP_SE_COEFFTAB_DATA_MASK)
-/* Enhance coeffents reigster offset */
+/* Enhance coeffents register offset */
 #define MALIDP_SE_IMAGE_ENH			0x3C
 /* ENH_LIMITS offset 0x0 */
 #define     MALIDP_SE_ENH_LOW_LEVEL		24
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h
index 99c6f7eefd85..d03c8f12a15c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h
@@ -58,7 +58,7 @@ struct fw_priv {
 	/* 0x81: PCI-AP, 01:PCIe, 02: 92S-U,
 	 * 0x82: USB-AP, 0x12: 72S-U, 03:SDIO */
 	u8 hci_sel;
-	/* the same value as reigster value  */
+	/* the same value as register value  */
 	u8 chip_version;
 	/* customer  ID low byte */
 	u8 customer_id_0;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 28ecaa7fc715..9e116bd79836 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -6551,7 +6551,7 @@ lpfc_sli4_unregister_fcf(struct lpfc_hba *phba)
  * lpfc_unregister_fcf_rescan - Unregister currently registered fcf and rescan
  * @phba: Pointer to hba context object.
  *
- * This function unregisters the currently reigstered FCF. This function
+ * This function unregisters the currently registered FCF. This function
  * also tries to find another FCF for discovery by rescan the HBA FCF table.
  */
 void
@@ -6609,7 +6609,7 @@ lpfc_unregister_fcf_rescan(struct lpfc_hba *phba)
  * lpfc_unregister_fcf - Unregister the currently registered fcf record
  * @phba: Pointer to hba context object.
  *
- * This function just unregisters the currently reigstered FCF. It does not
+ * This function just unregisters the currently registered FCF. It does not
  * try to find another FCF for discovery.
  */
 void
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index ccbdbd62f0d8..612dc1240f90 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -267,7 +267,7 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
 #endif /* CONFIG_HUGETLB_PAGE */
 
 /*
- * Verify the pagetables are still not ok after having reigstered into
+ * Verify the pagetables are still not ok after having registered into
  * the fault_pending_wqh to avoid userland having to UFFDIO_WAKE any
  * userfault that has already been resolved, if userfaultfd_read and
  * UFFDIO_COPY|ZEROPAGE are being run simultaneously on two different
-- 
2.17.1

