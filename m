Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD2D80D9C
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbfHDWvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:51:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35881 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbfHDWuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:50:08 -0400
Received: by mail-pl1-f194.google.com with SMTP id k8so35702182plt.3;
        Sun, 04 Aug 2019 15:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4iYkOl3aeyTERThJenFq1/3UwJx4Onl0nTT+k7YLDaI=;
        b=amp4rnRki7aZFblJwd+WR3AEEzT5jM0SqyuAgEV5CpAXAAopEM+ITm1VpHO/SXfmvR
         bo3NeFkBoHD+nAtlrBJ99G13P743PgNgDEkm2beH5ytNMeAvvksIb5/nFkswd7I26BcB
         Cu1H5Ec5GdgS9K1iSW46QqjiHGOk9ncTBdveqncGI12f820ka+y3wAT0qtpPsphaALcE
         KARWU4xHW0EFsjyrCk3ygT7cspgIvwlFXf07QJTASmi0+CbMzKJ+WTLfULPC2/v9VrXO
         To6FnxsBZLTmhG738lrtTmoKuXplA6aK9GPBNooGQXp1H7hHSJ+TLir+Hjd5setkxK8q
         WV8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4iYkOl3aeyTERThJenFq1/3UwJx4Onl0nTT+k7YLDaI=;
        b=m0nAzF7yCwUfzXbFv5+TfnVTxqSG37u7YuTjm6y0teScABHJuanhEK4kJlmefLRLfP
         CZcq/gtHJoo6ZbF6OZoV5jzfvti/k+Ns6aRnVvLU0jvr1KZ9KSoNMWaBNi2LgSyl6dU+
         Rdx2lcrANb/epXU9qJi9XQ+AJnVFBeasOv2dkpii6liTVDv6oZo68YbG6brKFqveHeJ2
         GeCtZg+kyFPV3iUW+lOdJeFXTOwD53XV0gypeOhrRVI+FcZr/Zi+XVNSC6q8YV0NHnlH
         gQ8HTYgy7Vjv8ygwypUd7uL1cWCdboKrISAD+JmNHTkC1iaBw3sJHDYKdHcHordxEyLZ
         Z0Xw==
X-Gm-Message-State: APjAAAVhyDn7IrCDPiHbod17dC4KmXAGV1UxsbdeUdoscQh//jY1/B+3
        CcEikeYFVd+pCEkPIMWr2to=
X-Google-Smtp-Source: APXvYqxMhyr2kFbHr1O04Zbn2AO0Z+HHRdZeT7lsPwl/97dZ/e7++C1RY1spQOQBhYkgPZq+HBfy0Q==
X-Received: by 2002:a17:902:20e9:: with SMTP id v38mr45178412plg.62.1564959007040;
        Sun, 04 Aug 2019 15:50:07 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.50.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:50:06 -0700 (PDT)
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
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v2 30/34] crypt: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:49:11 -0700
Message-Id: <20190804224915.28669-31-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190804224915.28669-1-jhubbard@nvidia.com>
References: <20190804224915.28669-1-jhubbard@nvidia.com>
MIME-Version: 1.0
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

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 crypto/af_alg.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 879cf23f7489..edd358ea64da 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -428,10 +428,7 @@ static void af_alg_link_sg(struct af_alg_sgl *sgl_prev,
 
 void af_alg_free_sg(struct af_alg_sgl *sgl)
 {
-	int i;
-
-	for (i = 0; i < sgl->npages; i++)
-		put_page(sgl->pages[i]);
+	put_user_pages(sgl->pages, sgl->npages);
 }
 EXPORT_SYMBOL_GPL(af_alg_free_sg);
 
@@ -668,7 +665,7 @@ static void af_alg_free_areq_sgls(struct af_alg_async_req *areq)
 		for_each_sg(tsgl, sg, areq->tsgl_entries, i) {
 			if (!sg_page(sg))
 				continue;
-			put_page(sg_page(sg));
+			put_user_page(sg_page(sg));
 		}
 
 		sock_kfree_s(sk, tsgl, areq->tsgl_entries * sizeof(*tsgl));
-- 
2.22.0

