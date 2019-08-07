Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0D884140
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbfHGBd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:33:59 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33785 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728729AbfHGBdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:33:55 -0400
Received: by mail-pl1-f195.google.com with SMTP id c14so38504737plo.0;
        Tue, 06 Aug 2019 18:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o0zfkIFt+6JH2qCeaVwPptBUW8DYTI9b55PprZaXkM8=;
        b=JTummjFBnv/C+O19cpD5WnNljDRNFTGhD+ZhdI4mJ0KthoLkEPnz/XxGJof7+/5P4n
         NHHwYbiLQNiC7TcqgsQ/ovMZm7D6aJYiNSrmCXoGWlQrghDLY3t836yj0IsY0+4YC7xI
         eQkZg6NO1m+ejC4ev3+3CL0uIAy7xorACp1mEOdDq8740Rm+KlATM1Sc7ZQ3MeqeRt4O
         7cYGE39/ttj6uSJue/JhAE5of4ahDgxaps2hbC4CGOdXTBLt0I5b2m9zlW7Y/wUMcwRM
         CKumpnCTxX+R2m3tIGG+Kc4MncXcm2KfRB66iumh4vvbbc51XwcZQfEKOAaVsSQiCWNy
         JHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o0zfkIFt+6JH2qCeaVwPptBUW8DYTI9b55PprZaXkM8=;
        b=HXLGnZ+2O3nAP6FFdEcL1tlf2YMYzPaP5wvJ4ZogO6eamb18tZJvJZnYFlULb96Pkr
         VHG48GA4VO72jWlLzQnpaHGtSO2t9QPb1tYgTUMl00mp81/AnWn9HUgHigdG3iwfjdha
         IPT+kqQdfkrLTaWB+PXb3xpG8XeJ3TihquG+NAYNewjkZrqQDWkj+h/RQnAZ4Zs2akuy
         l3akWcmIDI0OrS4cnrpq9KLfQDvQFbvsfxpsxmqwM7+uXsQIol0UE7JG5CRWHdK0F4HG
         0rU+zFx2i8l1iOX5jBebyKjL8+PBrwj/OIkV4x8lzR0Un0kdpIWZ0owOxTAOdaFnwVuB
         eNng==
X-Gm-Message-State: APjAAAWaCO39rht1CrPECXANwiuErdKc71hTCQQIazRwObuQxwpRnzeo
        UtmbjWH2fc5DEbjjgrH+h+I=
X-Google-Smtp-Source: APXvYqyrNSY9uu6qIRB6tCHKaxkbamRoI3EYz9mMxQODHddaqnRle1Efzwc3BX/1sry+PskKxKx5MA==
X-Received: by 2002:a17:902:4401:: with SMTP id k1mr5853733pld.193.1565141634169;
        Tue, 06 Aug 2019 18:33:54 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.33.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:33:53 -0700 (PDT)
From:   john.hubbard@gmail.com
X-Google-Original-From: jhubbard@nvidia.com
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, devel@lists.orangefs.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        sparclinux@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 06/41] x86/kvm: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:05 -0700
Message-Id: <20190807013340.9706-7-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190807013340.9706-1-jhubbard@nvidia.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

For pages that were retained via get_user_pages*(), release those pages
via the new put_user_page*() routines, instead of via put_page().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 arch/x86/kvm/svm.c  | 4 ++--
 virt/kvm/kvm_main.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7eafc6907861..ff93c923ed36 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1827,7 +1827,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 
 err:
 	if (npinned > 0)
-		release_pages(pages, npinned);
+		put_user_pages(pages, npinned);
 
 	kvfree(pages);
 	return NULL;
@@ -1838,7 +1838,7 @@ static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 
-	release_pages(pages, npages);
+	put_user_pages(pages, npages);
 	kvfree(pages);
 	sev->pages_locked -= npages;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 887f3b0c2b60..4b6a596ea8e9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1499,7 +1499,7 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 
 		if (__get_user_pages_fast(addr, 1, 1, &wpage) == 1) {
 			*writable = true;
-			put_page(page);
+			put_user_page(page);
 			page = wpage;
 		}
 	}
@@ -1831,7 +1831,7 @@ EXPORT_SYMBOL_GPL(kvm_release_page_clean);
 void kvm_release_pfn_clean(kvm_pfn_t pfn)
 {
 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn))
-		put_page(pfn_to_page(pfn));
+		put_user_page(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
 
-- 
2.22.0

