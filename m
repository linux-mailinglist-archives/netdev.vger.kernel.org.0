Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD76117AE7
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbfLIW6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:58:02 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19736 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbfLIWx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:53:57 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5deed07d0002>; Mon, 09 Dec 2019 14:53:50 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 09 Dec 2019 14:53:55 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 09 Dec 2019 14:53:55 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 9 Dec
 2019 22:53:55 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 9 Dec
 2019 22:53:55 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 9 Dec 2019 22:53:54 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5deed0810001>; Mon, 09 Dec 2019 14:53:54 -0800
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
Subject: [PATCH v8 05/26] goldish_pipe: rename local pin_user_pages() routine
Date:   Mon, 9 Dec 2019 14:53:23 -0800
Message-ID: <20191209225344.99740-6-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191209225344.99740-1-jhubbard@nvidia.com>
References: <20191209225344.99740-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575932030; bh=p0IrnUqP4remCwDP0ZXpn0mTFnqoqFciZQxO81/doUo=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=jNte32K+jkJEXqXtH29/6Ngn4/UkyIqdJccrR8WITJfeAJEVEmIYc7tdaC7PEd32g
         gU1xoLwuI6fP9Aiujgi6xbKD4gsOkG0O5gCSwus01hATli8uSmyhdbeC5bc+TjEqcv
         zBKUv/FGWZ+f/imXNwmfZux064iM3luX2b2j4lq/73RznAW9L+xX6XesN1qZCrwiTm
         3yumJ268cDhJSAjxr05jen5ofTF5+Q9O8bmohumeaWKN4womx5wIUfkl/+2W7Iqkfu
         GDxqiEhlT9xgsCrpXI6HmaSStDfLgusrFCh5IsilVmpK4MtXmgQVu0yCHjbiYn+utd
         e2q8XDnxyE2ZQ==
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
2.24.0

