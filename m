Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C6935F6D4
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352053AbhDNOv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351969AbhDNOux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:50:53 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4D1C061756;
        Wed, 14 Apr 2021 07:50:32 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id f29so14577103pgm.8;
        Wed, 14 Apr 2021 07:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bVkRTqUPBzQHoWP1iz19JnEvLpWiwpbLKKeUDMKlliw=;
        b=E+2cIG4luSiauZCXt8F0KkKTk61dfk7whIIE/VHBZpNK6ARjyQdSQbpdQClQ4sSrp/
         dGr6hJu/fS4Ac4GvGFZRUctlN3UoGYzjwv/J4NIfKYbBrLXDX0DII3Kqd0z13GyzT7N9
         3K8eWfVsyRnUmawlgrvkAxuuTExFaWpsJRH42W4ZrmtKgAL9Ko81HY7WIxnfJaEZ8aiH
         Re9gsUe5b3chBVWCDNntU9qAIDzO3tUL22enF3c2ium4ZddwWgTLyh5yVJnZkUplcHhN
         5Di+lzE1Zg2G82MYEnz9s+UIXemJpVVS+BIdIcbJOLkBiyzwWmhzx/daa53C594lB6Z4
         MjZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bVkRTqUPBzQHoWP1iz19JnEvLpWiwpbLKKeUDMKlliw=;
        b=aDPftXD0vZ+cp0ekM59SlWDwFIKr348YQdK0x7vNhL7sfG9ZdWzWqLRz0Brktf47mJ
         Bly5vE8eVVMhJO8uBxSvHMDHMfF5gdA4sP5OXh80fLDPcLVMK37Tgi4FOwlE1JUCgW7W
         7/BCzuexFCZH25V6k+9B9l94LThQ4se/SX7PjRo0k4CVcGmxyniDCQqny87Gig3T2uVd
         IxBPGtIB9+Gut0Y9phvxFBpQ3VIOx/quuvyxUOiP+GnmWbXe2SbFphnq+PG/ASsUlMqw
         WagdgNM1JW6n/ch7Pw2lubs388W3wHUetPYY7gZiUO0IG1N3wT7tlVgx8+mPRCCGQ4AZ
         1u1w==
X-Gm-Message-State: AOAM533s0XiZ93jVavkCA5rkn8tONKfik7MoLMZaT77DVytldPZ/vh85
        r/e7Tzun/rBPp0qn7eg7SHk=
X-Google-Smtp-Source: ABdhPJyJQo3QYxkwZd2R/2jbCS/20DZeDnEWp76po+53FmLx6JhMmfhewCcVF2Q2CCy9ma7VhRrp6w==
X-Received: by 2002:a63:4e47:: with SMTP id o7mr37301695pgl.286.1618411832013;
        Wed, 14 Apr 2021 07:50:32 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:35:ebad:12c1:f579:e332])
        by smtp.gmail.com with ESMTPSA id w67sm17732522pgb.87.2021.04.14.07.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 07:50:31 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: [Resend RFC PATCH V2 08/12] UIO/Hyper-V: Not load UIO HV driver in the isolation VM.
Date:   Wed, 14 Apr 2021 10:49:41 -0400
Message-Id: <20210414144945.3460554-9-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210414144945.3460554-1-ltykernel@gmail.com>
References: <20210414144945.3460554-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

UIO HV driver should not load in the isolation VM for security reason.
Return ENOTSUPP in the hv_uio_probe() in the isolation VM.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/uio/uio_hv_generic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index 0330ba99730e..678b021d66f8 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -29,6 +29,7 @@
 #include <linux/hyperv.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <asm/mshyperv.h>
 
 #include "../hv/hyperv_vmbus.h"
 
@@ -241,6 +242,10 @@ hv_uio_probe(struct hv_device *dev,
 	void *ring_buffer;
 	int ret;
 
+	/* UIO driver should not be loaded in the isolation VM.*/
+	if (hv_is_isolation_supported())
+		return -ENOTSUPP;
+		
 	/* Communicating with host has to be via shared memory not hypercall */
 	if (!channel->offermsg.monitor_allocated) {
 		dev_err(&dev->device, "vmbus channel requires hypercall\n");
-- 
2.25.1

