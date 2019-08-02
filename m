Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E36C47E807
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390718AbfHBCUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:20:24 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43841 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389247AbfHBCUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:20:20 -0400
Received: by mail-pl1-f194.google.com with SMTP id 4so26013389pld.10;
        Thu, 01 Aug 2019 19:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pwlX9Z4uen7Ts0pUwmBLgDhtihaB/D0UZN8JDoMe4ZA=;
        b=cXVKp+Dgxhj784uTGfvPyG1yYJG0TluF022pFhUyHpRdik351Pihe9of7XZeuP0Vwt
         h/i6WlGcIKVNKfHSeDSEUHKJX3j3X/NshFFci/lhMH4/SgEjIokRiJ+YouFN6I+GBm4y
         zUjQOfq6557LaDfB1SW3dyyvMia7x+7GSnkQpaKA5dSoAhqdxSb/NVVqK5YIHjTvA0IX
         6H4EsdOomJX2kg/hRhJVVxm3sX/zmn87r9Fum/tKlkDFYTmAnDUVoJ7rlCgUuzHH8DwS
         QuPnhojZwqXr2XSW6HhlWm7VIgfEjZi50Ea1bZ4R+3m+Y3fnnezSFaVuWGen2JpYqC8g
         nI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pwlX9Z4uen7Ts0pUwmBLgDhtihaB/D0UZN8JDoMe4ZA=;
        b=PnxGCf+asXpDzasTTibrLFvEkF4HP3FjzuPgfY0xLPC3tSQVfCZwT3pIeaQBI44LZw
         f3eMpbKqYnp4eJnRXXeACnMQcJsGLd2k0v2oC6FPvd3uwasAxgvmEotq0sveK9v7mR6P
         cvyoJqBSP/tQFCRcL0Ec0qxu7L9UtqytYlFx7D14KB7uz5GUf6aZUGSyuAVTl9P/Oe7t
         9eyz4J4T9K7nN98vSgrDid9CY3kRkje9l1jf2oKxhxB8SO5wXtuA/XvsGhKyIvjnLF9o
         jsJeqq6EJy02hanYuE9LXOX7mpJUYuKlIbwu+Rhpf+4elHZWhEE1nTiBcV8qt7Odn01x
         c3HA==
X-Gm-Message-State: APjAAAVEwCbHU5M6a5niyZDwCHI4f1ZDHiGYKm7Ip0KlDBsoyAv3WS/9
        MwXnJsXHvJRgU9iczw5OFIY=
X-Google-Smtp-Source: APXvYqzjw3eL+xmFFeLCY8pAtt0uU+dboybjV0Tj2XnMiuSE8KPva7u+GlTOi6iXLJ1oNBX2ZlUCDA==
X-Received: by 2002:a17:902:a413:: with SMTP id p19mr129958448plq.134.1564712419691;
        Thu, 01 Aug 2019 19:20:19 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:20:19 -0700 (PDT)
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
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 05/34] drm/etnaviv: convert release_pages() to put_user_pages()
Date:   Thu,  1 Aug 2019 19:19:36 -0700
Message-Id: <20190802022005.5117-6-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802022005.5117-1-jhubbard@nvidia.com>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
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
via the new put_user_page*() routines, instead of via put_page() or
release_pages().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/gpu/drm/etnaviv/etnaviv_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem.c b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
index e8778ebb72e6..a0144a5ee325 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -686,7 +686,7 @@ static int etnaviv_gem_userptr_get_pages(struct etnaviv_gem_object *etnaviv_obj)
 		ret = get_user_pages_fast(ptr, num_pages,
 					  !userptr->ro ? FOLL_WRITE : 0, pages);
 		if (ret < 0) {
-			release_pages(pvec, pinned);
+			put_user_pages(pvec, pinned);
 			kvfree(pvec);
 			return ret;
 		}
@@ -710,7 +710,7 @@ static void etnaviv_gem_userptr_release(struct etnaviv_gem_object *etnaviv_obj)
 	if (etnaviv_obj->pages) {
 		int npages = etnaviv_obj->base.size >> PAGE_SHIFT;
 
-		release_pages(etnaviv_obj->pages, npages);
+		put_user_pages(etnaviv_obj->pages, npages);
 		kvfree(etnaviv_obj->pages);
 	}
 }
-- 
2.22.0

