Return-Path: <netdev+bounces-5712-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFE8C712859
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:32:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 660C62818CE
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90EB028C3C;
	Fri, 26 May 2023 14:31:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8111028C3A
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 14:31:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E397E5E
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 07:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685111482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WtUJzNGs4hI/qozgKZw9Ev1spnarsyg42e3BEFrKZ44=;
	b=QIQZmlgOdYfxh1f+PGX96sA02hF8hTK7v90uuy4JzlF6iJYfdN9hfsmqJ/Y3qTNECBbvLL
	zx351h/ums5b1DAjGv1T2DA1hEM8incNZhPZ34E+/BlDcpy5NVwJoM5WuxaFv4pXSAEYvn
	UBKIWwPX1IjYe7vgS5jWGAa6so6rQl4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-JW7yVrnSMTmdp0eU8oppyA-1; Fri, 26 May 2023 10:31:18 -0400
X-MC-Unique: JW7yVrnSMTmdp0eU8oppyA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDF71801182;
	Fri, 26 May 2023 14:31:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 39ACC2166B2B;
	Fri, 26 May 2023 14:31:14 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-crypto@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jeff Layton <jlayton@kernel.org>,
	Steve French <sfrench@samba.org>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>,
	linux-cachefs@redhat.com,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH net-next 2/8] Drop the netfs_ prefix from netfs_extract_iter_to_sg()
Date: Fri, 26 May 2023 15:30:58 +0100
Message-Id: <20230526143104.882842-3-dhowells@redhat.com>
In-Reply-To: <20230526143104.882842-1-dhowells@redhat.com>
References: <20230526143104.882842-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Rename netfs_extract_iter_to_sg() and its auxiliary functions to drop the
netfs_ prefix.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>
cc: linux-crypto@vger.kernel.org
cc: linux-cachefs@redhat.com
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: netdev@vger.kernel.org
---
 fs/cifs/smb2ops.c   |  4 +--
 fs/cifs/smbdirect.c |  2 +-
 include/linux/uio.h |  6 ++---
 lib/scatterlist.c   | 66 ++++++++++++++++++++++-----------------------
 4 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a295e4c2d54e..196bc49e73b8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4335,8 +4335,8 @@ static void *smb2_get_aead_req(struct crypto_aead *tfm, struct smb_rqst *rqst,
 		}
 		sgtable.orig_nents = sgtable.nents;
 
-		rc = netfs_extract_iter_to_sg(iter, count, &sgtable,
-					      num_sgs - sgtable.nents, 0);
+		rc = extract_iter_to_sg(iter, count, &sgtable,
+					num_sgs - sgtable.nents, 0);
 		iov_iter_revert(iter, rc);
 		sgtable.orig_nents = sgtable.nents;
 	}
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 0362ebd4fa0f..223e17c16b60 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2227,7 +2227,7 @@ static int smbd_iter_to_mr(struct smbd_connection *info,
 
 	memset(sgt->sgl, 0, max_sg * sizeof(struct scatterlist));
 
-	ret = netfs_extract_iter_to_sg(iter, iov_iter_count(iter), sgt, max_sg, 0);
+	ret = extract_iter_to_sg(iter, iov_iter_count(iter), sgt, max_sg, 0);
 	WARN_ON(ret < 0);
 	if (sgt->nents > 0)
 		sg_mark_end(&sgt->sgl[sgt->nents - 1]);
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 09b8b107956e..0ccb983cf645 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -434,8 +434,8 @@ static inline bool iov_iter_extract_will_pin(const struct iov_iter *iter)
 }
 
 struct sg_table;
-ssize_t netfs_extract_iter_to_sg(struct iov_iter *iter, size_t len,
-				 struct sg_table *sgtable, unsigned int sg_max,
-				 iov_iter_extraction_t extraction_flags);
+ssize_t extract_iter_to_sg(struct iov_iter *iter, size_t len,
+			   struct sg_table *sgtable, unsigned int sg_max,
+			   iov_iter_extraction_t extraction_flags);
 
 #endif
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 31ef86e6a33a..8612b9deaa7e 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -1101,11 +1101,11 @@ EXPORT_SYMBOL(sg_zero_buffer);
  * Extract and pin a list of up to sg_max pages from UBUF- or IOVEC-class
  * iterators, and add them to the scatterlist.
  */
-static ssize_t netfs_extract_user_to_sg(struct iov_iter *iter,
-					ssize_t maxsize,
-					struct sg_table *sgtable,
-					unsigned int sg_max,
-					iov_iter_extraction_t extraction_flags)
+static ssize_t extract_user_to_sg(struct iov_iter *iter,
+				  ssize_t maxsize,
+				  struct sg_table *sgtable,
+				  unsigned int sg_max,
+				  iov_iter_extraction_t extraction_flags)
 {
 	struct scatterlist *sg = sgtable->sgl + sgtable->nents;
 	struct page **pages;
@@ -1154,11 +1154,11 @@ static ssize_t netfs_extract_user_to_sg(struct iov_iter *iter,
  * Extract up to sg_max pages from a BVEC-type iterator and add them to the
  * scatterlist.  The pages are not pinned.
  */
-static ssize_t netfs_extract_bvec_to_sg(struct iov_iter *iter,
-					ssize_t maxsize,
-					struct sg_table *sgtable,
-					unsigned int sg_max,
-					iov_iter_extraction_t extraction_flags)
+static ssize_t extract_bvec_to_sg(struct iov_iter *iter,
+				  ssize_t maxsize,
+				  struct sg_table *sgtable,
+				  unsigned int sg_max,
+				  iov_iter_extraction_t extraction_flags)
 {
 	const struct bio_vec *bv = iter->bvec;
 	struct scatterlist *sg = sgtable->sgl + sgtable->nents;
@@ -1200,11 +1200,11 @@ static ssize_t netfs_extract_bvec_to_sg(struct iov_iter *iter,
  * scatterlist.  This can deal with vmalloc'd buffers as well as kmalloc'd or
  * static buffers.  The pages are not pinned.
  */
-static ssize_t netfs_extract_kvec_to_sg(struct iov_iter *iter,
-					ssize_t maxsize,
-					struct sg_table *sgtable,
-					unsigned int sg_max,
-					iov_iter_extraction_t extraction_flags)
+static ssize_t extract_kvec_to_sg(struct iov_iter *iter,
+				  ssize_t maxsize,
+				  struct sg_table *sgtable,
+				  unsigned int sg_max,
+				  iov_iter_extraction_t extraction_flags)
 {
 	const struct kvec *kv = iter->kvec;
 	struct scatterlist *sg = sgtable->sgl + sgtable->nents;
@@ -1261,11 +1261,11 @@ static ssize_t netfs_extract_kvec_to_sg(struct iov_iter *iter,
  * Extract up to sg_max folios from an XARRAY-type iterator and add them to
  * the scatterlist.  The pages are not pinned.
  */
-static ssize_t netfs_extract_xarray_to_sg(struct iov_iter *iter,
-					  ssize_t maxsize,
-					  struct sg_table *sgtable,
-					  unsigned int sg_max,
-					  iov_iter_extraction_t extraction_flags)
+static ssize_t extract_xarray_to_sg(struct iov_iter *iter,
+				    ssize_t maxsize,
+				    struct sg_table *sgtable,
+				    unsigned int sg_max,
+				    iov_iter_extraction_t extraction_flags)
 {
 	struct scatterlist *sg = sgtable->sgl + sgtable->nents;
 	struct xarray *xa = iter->xarray;
@@ -1307,7 +1307,7 @@ static ssize_t netfs_extract_xarray_to_sg(struct iov_iter *iter,
 }
 
 /**
- * netfs_extract_iter_to_sg - Extract pages from an iterator and add ot an sglist
+ * extract_iter_to_sg - Extract pages from an iterator and add ot an sglist
  * @iter: The iterator to extract from
  * @maxsize: The amount of iterator to copy
  * @sgtable: The scatterlist table to fill in
@@ -1334,9 +1334,9 @@ static ssize_t netfs_extract_xarray_to_sg(struct iov_iter *iter,
  * The iov_iter_extract_mode() function should be used to query how cleanup
  * should be performed.
  */
-ssize_t netfs_extract_iter_to_sg(struct iov_iter *iter, size_t maxsize,
-				 struct sg_table *sgtable, unsigned int sg_max,
-				 iov_iter_extraction_t extraction_flags)
+ssize_t extract_iter_to_sg(struct iov_iter *iter, size_t maxsize,
+			   struct sg_table *sgtable, unsigned int sg_max,
+			   iov_iter_extraction_t extraction_flags)
 {
 	if (maxsize == 0)
 		return 0;
@@ -1344,21 +1344,21 @@ ssize_t netfs_extract_iter_to_sg(struct iov_iter *iter, size_t maxsize,
 	switch (iov_iter_type(iter)) {
 	case ITER_UBUF:
 	case ITER_IOVEC:
-		return netfs_extract_user_to_sg(iter, maxsize, sgtable, sg_max,
-						extraction_flags);
+		return extract_user_to_sg(iter, maxsize, sgtable, sg_max,
+					  extraction_flags);
 	case ITER_BVEC:
-		return netfs_extract_bvec_to_sg(iter, maxsize, sgtable, sg_max,
-						extraction_flags);
+		return extract_bvec_to_sg(iter, maxsize, sgtable, sg_max,
+					  extraction_flags);
 	case ITER_KVEC:
-		return netfs_extract_kvec_to_sg(iter, maxsize, sgtable, sg_max,
-						extraction_flags);
+		return extract_kvec_to_sg(iter, maxsize, sgtable, sg_max,
+					  extraction_flags);
 	case ITER_XARRAY:
-		return netfs_extract_xarray_to_sg(iter, maxsize, sgtable, sg_max,
-						  extraction_flags);
+		return extract_xarray_to_sg(iter, maxsize, sgtable, sg_max,
+					    extraction_flags);
 	default:
 		pr_err("%s(%u) unsupported\n", __func__, iov_iter_type(iter));
 		WARN_ON_ONCE(1);
 		return -EIO;
 	}
 }
-EXPORT_SYMBOL_GPL(netfs_extract_iter_to_sg);
+EXPORT_SYMBOL_GPL(extract_iter_to_sg);


