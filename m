Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790FD1CD619
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 12:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbgEKKL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 06:11:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44564 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728574AbgEKKL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 06:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589191916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=ZN7xwg5CWZvOzQGTmaByrLX25ajcsG3GF52exfugwgc=;
        b=bGnAz+EvMKihQjuT4lj344jlprwrC+m0nsEX6URRFQ/Gby19OHhj8jcz8gn/XwVxIHVUN4
        dQ1rrVtP+YdHV1Y+87dPMTJPSMyKtIYFryv95DjFIz9/+HijpLOrifjf+N0YZU9Gh3soGp
        dfBGhnb+/2Pjl1KJjYVeTPIxyYiAqNU=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-K1AYPcCxP6ij4VSJ1Zk1fw-1; Mon, 11 May 2020 06:11:54 -0400
X-MC-Unique: K1AYPcCxP6ij4VSJ1Zk1fw-1
Received: by mail-pf1-f198.google.com with SMTP id z2so8404311pfz.13
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 03:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZN7xwg5CWZvOzQGTmaByrLX25ajcsG3GF52exfugwgc=;
        b=D0a4WvzGK9sX5PrMPzrUTgje0oOhFyUub01bNdU0KzdG/sVnPxadxgbaOEMJecHbbb
         jlps9r/XXNIps0u5GS+oqaVuiAFobEKrN2vne7Ywf2UWx4Y8AJWyH7LBIl4FLDtuVmS3
         wTCldYfO/n6y/3fJ9OYn9KuZzRgjuJTOkC7fHhanrzwCXWpTqVO7bEaCNvFH7tHEVz/G
         d/ntXHnvJUA+Fvu1ewdrupGzXFMIQutHEu7lE2tXV6DZM2oLWnsClCHbCuLzRTx+QzO2
         z0exHqfo8T26T8Iksv8Huf8y7Xu19nlJVbDjqcVJnkgJ2q5uICAD6k5SS8tvz+z3T7wJ
         dk+A==
X-Gm-Message-State: AGi0Pub9AfngxJ80J0cjk8B2y68NTssomZyQ4HM80ice1m/tgeB94MVi
        VMOycj8y0vECPcFqwMsiCQZqiRCX2zgmDgWWDTqa6Ju6a+g3KYuyrcVnXzU44t5f3k/cfCNaJQg
        xZPPezJ67IRXvG7MK
X-Received: by 2002:a17:902:32b:: with SMTP id 40mr14128020pld.73.1589191913262;
        Mon, 11 May 2020 03:11:53 -0700 (PDT)
X-Google-Smtp-Source: APiQypJWyWXGdAoto/0EXXwdx9Dr2HzYt8dFPCj8KebFaRpzS/r4xZule3kpAQxzMDRxJPy9o+z/rg==
X-Received: by 2002:a17:902:32b:: with SMTP id 40mr14127998pld.73.1589191912970;
        Mon, 11 May 2020 03:11:52 -0700 (PDT)
Received: from localhost ([223.235.87.110])
        by smtp.gmail.com with ESMTPSA id s136sm9033998pfc.29.2020.05.11.03.11.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 03:11:52 -0700 (PDT)
From:   Bhupesh Sharma <bhsharma@redhat.com>
To:     netdev@vger.kernel.org
Cc:     bhsharma@redhat.com, bhupesh.linux@gmail.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        manishc@marvell.com, davem@davemloft.net, irusskikh@marvell.com
Subject: [PATCH v2 2/2] net: qed: Disable SRIOV functionality inside kdump kernel
Date:   Mon, 11 May 2020 15:41:42 +0530
Message-Id: <1589191902-958-3-git-send-email-bhsharma@redhat.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589191902-958-1-git-send-email-bhsharma@redhat.com>
References: <1589191902-958-1-git-send-email-bhsharma@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we have kdump kernel(s) running under severe memory constraint
it makes sense to disable the qed SRIOV functionality when running the
kdump kernel as kdump configurations on several distributions don't
support SRIOV targets for saving the vmcore (see [1] for example).

Currently the qed SRIOV functionality ends up consuming memory in
the kdump kernel, when we don't really use the same.

An example log seen in the kdump kernel with the SRIOV functionality
enabled can be seen below (obtained via memstrack tool, see [2]):
 dracut-pre-pivot[676]: ======== Report format module_summary: ========
 dracut-pre-pivot[676]: Module qed using 149.6MB (2394 pages), peak allocation 149.6MB (2394 pages)

This patch disables the SRIOV functionality inside kdump kernel and with
the same applied the memory consumption goes down:
 dracut-pre-pivot[671]: ======== Report format module_summary: ========
 dracut-pre-pivot[671]: Module qed using 124.6MB (1993 pages), peak allocation 124.7MB (1995 pages)

[1]. https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/installing-and-configuring-kdump_managing-monitoring-and-updating-the-kernel#supported-kdump-targets_supported-kdump-configurations-and-targets
[2]. Memstrack tool: https://github.com/ryncsn/memstrack

Cc: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Ariel Elior <aelior@marvell.com>
Cc: GR-everest-linux-l2@marvell.com
Cc: Manish Chopra <manishc@marvell.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.h  | 10 +++++++---
 drivers/net/ethernet/qlogic/qede/qede_main.c |  2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.h b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
index 368e88565783..aabeaf03135e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
@@ -32,6 +32,7 @@
 
 #ifndef _QED_SRIOV_H
 #define _QED_SRIOV_H
+#include <linux/crash_dump.h>
 #include <linux/types.h>
 #include "qed_vf.h"
 
@@ -40,9 +41,12 @@
 #define QED_VF_ARRAY_LENGTH (3)
 
 #ifdef CONFIG_QED_SRIOV
-#define IS_VF(cdev)             ((cdev)->b_is_vf)
-#define IS_PF(cdev)             (!((cdev)->b_is_vf))
-#define IS_PF_SRIOV(p_hwfn)     (!!((p_hwfn)->cdev->p_iov_info))
+#define IS_VF(cdev)             (is_kdump_kernel() ? \
+				 (0) : ((cdev)->b_is_vf))
+#define IS_PF(cdev)             (is_kdump_kernel() ? \
+				 (1) : !((cdev)->b_is_vf))
+#define IS_PF_SRIOV(p_hwfn)     (is_kdump_kernel() ? \
+				 (0) : !!((p_hwfn)->cdev->p_iov_info))
 #else
 #define IS_VF(cdev)             (0)
 #define IS_PF(cdev)             (1)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 1a83d1fd8ccd..28afa0c49fe8 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1194,7 +1194,7 @@ static int qede_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	case QEDE_PRIVATE_VF:
 		if (debug & QED_LOG_VERBOSE_MASK)
 			dev_err(&pdev->dev, "Probing a VF\n");
-		is_vf = true;
+		is_vf = is_kdump_kernel() ? false : true;
 		break;
 	default:
 		if (debug & QED_LOG_VERBOSE_MASK)
-- 
2.7.4

