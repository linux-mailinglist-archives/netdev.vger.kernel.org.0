Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F102B054F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 13:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgKLM6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 07:58:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728253AbgKLM6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:58:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605185890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DAVAInVcp6zb/CSQMkiobU5XXmB1jibPH4NSxa0idq0=;
        b=I/aNE1D/2yuSv72lZtKu/yVaE7/x4RAKkRysmRU/nXHyFY1Gq4d0LOcRATO+vc9xXvPYQ1
        hMQwUWtiq2BCwXcYGLXEfjRsXfnGVdake1eLoN1c9GxfoKy9PSa3gfjBI7u/FpG3nOWVNi
        k1Xkq2PJFdTaGYfEH6sq7IZAEy2bWnY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-Cv7XutOCNf62MnfBD1BTcg-1; Thu, 12 Nov 2020 07:58:06 -0500
X-MC-Unique: Cv7XutOCNf62MnfBD1BTcg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 714EF64156;
        Thu, 12 Nov 2020 12:58:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 944E65B4AD;
        Thu, 12 Nov 2020 12:58:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 02/18] crypto/krb5: Add some constants out of sunrpc headers
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:58:01 +0000
Message-ID: <160518588181.2277919.13100188317180416955.stgit@warthog.procyon.org.uk>
In-Reply-To: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
References: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some constants from the sunrpc headers.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/crypto/krb5.h |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/include/crypto/krb5.h b/include/crypto/krb5.h
index 2bd6cfe50b85..a7e4ab4e1348 100644
--- a/include/crypto/krb5.h
+++ b/include/crypto/krb5.h
@@ -15,6 +15,45 @@
 struct crypto_shash;
 struct scatterlist;
 
+/* per Kerberos v5 protocol spec crypto types from the wire.
+ * these get mapped to linux kernel crypto routines.
+ */
+#define KRB5_ENCTYPE_NULL			0x0000
+#define KRB5_ENCTYPE_DES_CBC_CRC		0x0001	/* DES cbc mode with CRC-32 */
+#define KRB5_ENCTYPE_DES_CBC_MD4		0x0002	/* DES cbc mode with RSA-MD4 */
+#define KRB5_ENCTYPE_DES_CBC_MD5		0x0003	/* DES cbc mode with RSA-MD5 */
+#define KRB5_ENCTYPE_DES_CBC_RAW		0x0004	/* DES cbc mode raw */
+/* XXX deprecated? */
+#define KRB5_ENCTYPE_DES3_CBC_SHA		0x0005	/* DES-3 cbc mode with NIST-SHA */
+#define KRB5_ENCTYPE_DES3_CBC_RAW		0x0006	/* DES-3 cbc mode raw */
+#define KRB5_ENCTYPE_DES_HMAC_SHA1		0x0008
+#define KRB5_ENCTYPE_DES3_CBC_SHA1		0x0010
+#define KRB5_ENCTYPE_AES128_CTS_HMAC_SHA1_96	0x0011
+#define KRB5_ENCTYPE_AES256_CTS_HMAC_SHA1_96	0x0012
+#define KRB5_ENCTYPE_ARCFOUR_HMAC		0x0017
+#define KRB5_ENCTYPE_ARCFOUR_HMAC_EXP		0x0018
+#define KRB5_ENCTYPE_UNKNOWN			0x01ff
+
+#define KRB5_CKSUMTYPE_CRC32			0x0001
+#define KRB5_CKSUMTYPE_RSA_MD4			0x0002
+#define KRB5_CKSUMTYPE_RSA_MD4_DES		0x0003
+#define KRB5_CKSUMTYPE_DESCBC			0x0004
+#define KRB5_CKSUMTYPE_RSA_MD5			0x0007
+#define KRB5_CKSUMTYPE_RSA_MD5_DES		0x0008
+#define KRB5_CKSUMTYPE_NIST_SHA			0x0009
+#define KRB5_CKSUMTYPE_HMAC_SHA1_DES3		0x000c
+#define KRB5_CKSUMTYPE_HMAC_SHA1_96_AES128	0x000f
+#define KRB5_CKSUMTYPE_HMAC_SHA1_96_AES256	0x0010
+#define KRB5_CKSUMTYPE_HMAC_MD5_ARCFOUR		-138 /* Microsoft md5 hmac cksumtype */
+
+/*
+ * Constants used for key derivation
+ */
+/* from rfc3961 */
+#define KEY_USAGE_SEED_CHECKSUM         (0x99)
+#define KEY_USAGE_SEED_ENCRYPTION       (0xAA)
+#define KEY_USAGE_SEED_INTEGRITY        (0x55)
+
 struct krb5_buffer {
 	unsigned int	len;
 	void		*data;


