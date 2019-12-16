Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE22D121DDE
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 23:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbfLPW3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 17:29:49 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11881 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727741AbfLPWZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 17:25:44 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df804490000>; Mon, 16 Dec 2019 14:25:13 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 16 Dec 2019 14:25:40 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 16 Dec 2019 14:25:40 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Dec
 2019 22:25:40 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Dec
 2019 22:25:39 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 16 Dec 2019 22:25:39 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5df804630006>; Mon, 16 Dec 2019 14:25:39 -0800
From:   John Hubbard <jhubbard@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Paul Mackerras" <paulus@samba.org>, Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v11 05/25] goldish_pipe: rename local pin_user_pages() routine
Date:   Mon, 16 Dec 2019 14:25:17 -0800
Message-ID: <20191216222537.491123-6-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216222537.491123-1-jhubbard@nvidia.com>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576535113; bh=dU9rqRUjoEJDMl6YIDFuRWeBjP0SXaLfZLqPqCiHWKI=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=P+PIjSI3I1iHc5I5vkc8gOS6YYkqyr+GpsnGV6PG49oHbGEYWa7J0Suj0tdoPDlfL
         gx+X78c6WUOEdvIuXLA9yrYrdiSpnclXxt+lZYM4BeS0CngKx2fUv5UbMES9IufxLo
         E4VWus81MH1kM82pYHzVGVBnGdSysNwwGEqkCO820JNyKflEYoZfENMTcNTFJ15DHJ
         uEqMlxWrrXy88Rbb5/UbgD5mKfYa4e2w9EGFra3ZkNsfceK0mzq+55zYnQXpf08lH4
         aRLE2Q4JgAbf1AYk5P9fxcujvgH7z3T3qK1HEdma25YBU+9Tnn4JbUeBUS6xCjHr/P
         kS8LftXPp8HxQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Avoid naming conflicts: rename local static function from
"pin_user_pages()" to "goldfish_pin_pages()".

An upcoming patch will introduce a global pin_user_pages()
function.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/platform/goldfish/goldfish_pipe.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/g=
oldfish/goldfish_pipe.c
index cef0133aa47a..ef50c264db71 100644
--- a/drivers/platform/goldfish/goldfish_pipe.c
+++ b/drivers/platform/goldfish/goldfish_pipe.c
@@ -257,12 +257,12 @@ static int goldfish_pipe_error_convert(int status)
 	}
 }
=20
-static int pin_user_pages(unsigned long first_page,
-			  unsigned long last_page,
-			  unsigned int last_page_size,
-			  int is_write,
-			  struct page *pages[MAX_BUFFERS_PER_COMMAND],
-			  unsigned int *iter_last_page_size)
+static int goldfish_pin_pages(unsigned long first_page,
+			      unsigned long last_page,
+			      unsigned int last_page_size,
+			      int is_write,
+			      struct page *pages[MAX_BUFFERS_PER_COMMAND],
+			      unsigned int *iter_last_page_size)
 {
 	int ret;
 	int requested_pages =3D ((last_page - first_page) >> PAGE_SHIFT) + 1;
@@ -354,9 +354,9 @@ static int transfer_max_buffers(struct goldfish_pipe *p=
ipe,
 	if (mutex_lock_interruptible(&pipe->lock))
 		return -ERESTARTSYS;
=20
-	pages_count =3D pin_user_pages(first_page, last_page,
-				     last_page_size, is_write,
-				     pipe->pages, &iter_last_page_size);
+	pages_count =3D goldfish_pin_pages(first_page, last_page,
+					 last_page_size, is_write,
+					 pipe->pages, &iter_last_page_size);
 	if (pages_count < 0) {
 		mutex_unlock(&pipe->lock);
 		return pages_count;
--=20
2.24.1

