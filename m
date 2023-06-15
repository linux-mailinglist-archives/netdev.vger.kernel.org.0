Return-Path: <netdev+bounces-11166-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6A9731D45
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 18:02:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8CD81C20EE3
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70DBB17FF5;
	Thu, 15 Jun 2023 16:02:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CF917FEE
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 16:02:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C01E2952
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 09:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686844922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E6zeZ2Y3tf2OPH/rRcIX6GxS4cB2PEK5LsG9Q9HL7Ww=;
	b=IHEHe75ulGtE0sCLpgdGJHkMfzAHyrMm1nBSI20/+/Wcw7DgeUltur8oC7PhdBkMCHaDAm
	gopWwRnvpep+afRl2ZbkuZgYgNrBgDRiQnqEdTny5shTaZivRPmYQ7Zivd6BuLC2mCFN32
	kK7XahlxJxThxqMjie8V9+j6p4gr/dg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-I4ftdIS-MyauR0oETNCk3w-1; Thu, 15 Jun 2023 12:01:59 -0400
X-MC-Unique: I4ftdIS-MyauR0oETNCk3w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2882D857D10;
	Thu, 15 Jun 2023 16:01:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E7496C1603B;
	Thu, 15 Jun 2023 16:01:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <000000000000b2585a05fdeb8379@google.com>
References: <000000000000b2585a05fdeb8379@google.com>
To: syzbot <syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com>
Cc: dhowells@redhat.com, davem@davemloft.net,
    herbert@gondor.apana.org.au, kuba@kernel.org,
    linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
    netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] KASAN: slab-out-of-bounds Read in extract_iter_to_sg
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <256754.1686844894.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Jun 2023 17:01:34 +0100
Message-ID: <256755.1686844894@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.g=
it main


diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 38d2265c77fd..e97abe6055a1 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4333,8 +4333,7 @@ static void *smb2_get_aead_req(struct crypto_aead *t=
fm, struct smb_rqst *rqst,
 		}
 		sgtable.orig_nents =3D sgtable.nents;
 =

-		rc =3D extract_iter_to_sg(iter, count, &sgtable,
-					num_sgs - sgtable.nents, 0);
+		rc =3D extract_iter_to_sg(iter, count, &sgtable, num_sgs, 0);
 		iov_iter_revert(iter, rc);
 		sgtable.orig_nents =3D sgtable.nents;
 	}
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index e97d7060329e..6fd20bfc01a4 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -1120,7 +1120,8 @@ static ssize_t extract_user_to_sg(struct iov_iter *i=
ter,
 	pages -=3D sg_max;
 =

 	do {
-		res =3D iov_iter_extract_pages(iter, &pages, maxsize, sg_max,
+		res =3D iov_iter_extract_pages(iter, &pages, maxsize,
+					     sg_max - sgtable->nents,
 					     extraction_flags, &off);
 		if (res < 0)
 			goto failed;
@@ -1129,7 +1130,6 @@ static ssize_t extract_user_to_sg(struct iov_iter *i=
ter,
 		maxsize -=3D len;
 		ret +=3D len;
 		npages =3D DIV_ROUND_UP(off + len, PAGE_SIZE);
-		sg_max -=3D npages;
 =

 		for (; npages > 0; npages--) {
 			struct page *page =3D *pages;
@@ -1142,7 +1142,7 @@ static ssize_t extract_user_to_sg(struct iov_iter *i=
ter,
 			len -=3D seg;
 			off =3D 0;
 		}
-	} while (maxsize > 0 && sg_max > 0);
+	} while (maxsize > 0 && sgtable->nents < sg_max);
 =

 	return ret;
 =

@@ -1183,11 +1183,10 @@ static ssize_t extract_bvec_to_sg(struct iov_iter =
*iter,
 		sg_set_page(sg, bv[i].bv_page, len, off);
 		sgtable->nents++;
 		sg++;
-		sg_max--;
 =

 		ret +=3D len;
 		maxsize -=3D len;
-		if (maxsize <=3D 0 || sg_max =3D=3D 0)
+		if (maxsize <=3D 0 || sgtable->nents >=3D sg_max)
 			break;
 		start =3D 0;
 	}
@@ -1242,14 +1241,13 @@ static ssize_t extract_kvec_to_sg(struct iov_iter =
*iter,
 			sg_set_page(sg, page, len, off);
 			sgtable->nents++;
 			sg++;
-			sg_max--;
 =

 			len -=3D seg;
 			kaddr +=3D PAGE_SIZE;
 			off =3D 0;
-		} while (len > 0 && sg_max > 0);
+		} while (len > 0 && sgtable->nents < sg_max);
 =

-		if (maxsize <=3D 0 || sg_max =3D=3D 0)
+		if (maxsize <=3D 0 || sgtable->nents >=3D sg_max)
 			break;
 		start =3D 0;
 	}
@@ -1294,11 +1292,10 @@ static ssize_t extract_xarray_to_sg(struct iov_ite=
r *iter,
 		sg_set_page(sg, folio_page(folio, 0), len, offset);
 		sgtable->nents++;
 		sg++;
-		sg_max--;
 =

 		maxsize -=3D len;
 		ret +=3D len;
-		if (maxsize <=3D 0 || sg_max =3D=3D 0)
+		if (maxsize <=3D 0 || sgtable->nents >=3D sg_max)
 			break;
 	}
 =

@@ -1318,7 +1315,8 @@ static ssize_t extract_xarray_to_sg(struct iov_iter =
*iter,
  *
  * Extract the page fragments from the given amount of the source iterato=
r and
  * add them to a scatterlist that refers to all of those bits, to a maxim=
um
- * addition of @sg_max elements.
+ * addition of @sg_max elements.  @sgtable->nents indicates how many of t=
he
+ * elements are already used.
  *
  * The pages referred to by UBUF- and IOVEC-type iterators are extracted =
and
  * pinned; BVEC-, KVEC- and XARRAY-type are extracted but aren't pinned; =
PIPE-
@@ -1343,6 +1341,11 @@ ssize_t extract_iter_to_sg(struct iov_iter *iter, s=
ize_t maxsize,
 	if (maxsize =3D=3D 0)
 		return 0;
 =

+	if (WARN_ON_ONCE(sg_max =3D=3D 0))
+		return -EIO;
+	if (WARN_ON_ONCE(sgtable->nents >=3D sg_max))
+		return -EIO;
+
 	switch (iov_iter_type(iter)) {
 	case ITER_UBUF:
 	case ITER_IOVEC:


