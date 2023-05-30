Return-Path: <netdev+bounces-6413-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A8171638E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:18:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA9FC281148
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:18:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523FF21097;
	Tue, 30 May 2023 14:17:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406D321072
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:17:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1381113E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685456227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrEG3Id6KDn/gSf5yv4D68QElxexhX3bro3X0CJ6lE8=;
	b=WzfNTn4OY4x4ikmCLQsjXr6Gq3b/uaTD2GZgJJgSyDdz0TsIGBHX9hpnt3KW3dKm+Nw1q+
	bUCnjLjFwO7nwNdvEhreFx4NIS8RaBIK060vnVw+cQ6U6J/LgO414VnLQ/gcyTXIAaYyUx
	6QnGWA5SuphhAZZOhjAn+4bgp1V9MAM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-GYtZWPrcPFKGze4E1bwesg-1; Tue, 30 May 2023 10:17:04 -0400
X-MC-Unique: GYtZWPrcPFKGze4E1bwesg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAE3B3C0ED43;
	Tue, 30 May 2023 14:17:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 46E7917103;
	Tue, 30 May 2023 14:16:57 +0000 (UTC)
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
Subject: [PATCH net-next v2 01/10] Drop the netfs_ prefix from netfs_extract_iter_to_sg()
Date: Tue, 30 May 2023 15:16:25 +0100
Message-ID: <20230530141635.136968-2-dhowells@redhat.com>
In-Reply-To: <20230530141635.136968-1-dhowells@redhat.com>
References: <20230530141635.136968-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-crypto@vger.kernel.org
cc: linux-cachefs@redhat.com
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: netdev@vger.kernel.org
---

Notes:
    ver #2:
     - Put the "netfs_" prefix removal first to shorten lines and avoid
       checkpatch 80-char warnings.

 fs/cifs/smb2ops.c     |  4 +--
 fs/cifs/smbdirect.c   |  2 +-
 fs/netfs/iterator.c   | 66 +++++++++++++++++++++----------------------
 include/linux/netfs.h |  6 ++--
 4 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5065398665f1..2a0e0a7f009c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4334,8 +4334,8 @@ static void *smb2_get_aead_req(struct crypto_aead *tfm, struct smb_rqst *rqst,
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
diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
index 8a4c86687429..f8eba3de1a97 100644
--- a/fs/netfs/iterator.c
+++ b/fs/netfs/iterator.c
@@ -106,11 +106,11 @@ EXPORT_SYMBOL_GPL(netfs_extract_user_iter);
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
@@ -159,11 +159,11 @@ static ssize_t netfs_extract_user_to_sg(struct iov_iter *iter,
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
@@ -205,11 +205,11 @@ static ssize_t netfs_extract_bvec_to_sg(struct iov_iter *iter,
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
@@ -266,11 +266,11 @@ static ssize_t netfs_extract_kvec_to_sg(struct iov_iter *iter,
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
@@ -312,7 +312,7 @@ static ssize_t netfs_extract_xarray_to_sg(struct iov_iter *iter,
 }
 
 /**
- * netfs_extract_iter_to_sg - Extract pages from an iterator and add ot an sglist
+ * extract_iter_to_sg - Extract pages from an iterator and add ot an sglist
  * @iter: The iterator to extract from
  * @maxsize: The amount of iterator to copy
  * @sgtable: The scatterlist table to fill in
@@ -339,9 +339,9 @@ static ssize_t netfs_extract_xarray_to_sg(struct iov_iter *iter,
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
@@ -349,21 +349,21 @@ ssize_t netfs_extract_iter_to_sg(struct iov_iter *iter, size_t maxsize,
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
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index a1f3522daa69..55e201c3a841 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -301,9 +301,9 @@ ssize_t netfs_extract_user_iter(struct iov_iter *orig, size_t orig_len,
 				struct iov_iter *new,
 				iov_iter_extraction_t extraction_flags);
 struct sg_table;
-ssize_t netfs_extract_iter_to_sg(struct iov_iter *iter, size_t len,
-				 struct sg_table *sgtable, unsigned int sg_max,
-				 iov_iter_extraction_t extraction_flags);
+ssize_t extract_iter_to_sg(struct iov_iter *iter, size_t len,
+			   struct sg_table *sgtable, unsigned int sg_max,
+			   iov_iter_extraction_t extraction_flags);
 
 /**
  * netfs_inode - Get the netfs inode context from the inode


