Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96D92B0FDD
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 22:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgKLVNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 16:13:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8150 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727208AbgKLVNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 16:13:10 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ACL1glJ032123
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 13:13:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=J5r/PsCFBvk/+XqCSFwom2kfsQElkG5kuFU4C6pTSpU=;
 b=YwyOQdZICdTJdq0y6CRRk2SglGbofcxw58TI0lE11RTZTi0K+ZWrOu5iY/PyvsQ4UND4
 GFn6qNJQXUfidBPBvVO+E6oaSN8KHmcmmVWRImV1Px1hWuvVZk/IVugtrzUNyhHOUDo/
 rrGGVQdtjmoWL2jtYIdstcGLSKbh2Zy4vGg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34rf8sssn3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 13:13:09 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 12 Nov 2020 13:13:08 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 918ED29469C4; Thu, 12 Nov 2020 13:13:07 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 2/4] bpf: Rename some functions in bpf_sk_storage
Date:   Thu, 12 Nov 2020 13:13:07 -0800
Message-ID: <20201112211307.2587021-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201112211255.2585961-1-kafai@fb.com>
References: <20201112211255.2585961-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_12:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=527 adultscore=0
 impostorscore=0 suspectscore=38 phishscore=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011120123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename some of the functions currently prefixed with sk_storage
to bpf_sk_storage.  That will make the next patch have fewer
prefix check and also bring the bpf_sk_storage.c to a more
consistent function naming.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/bpf_sk_storage.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 001eac65e40f..fd416678f236 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -16,7 +16,7 @@
 DEFINE_BPF_STORAGE_CACHE(sk_cache);
=20
 static struct bpf_local_storage_data *
-sk_storage_lookup(struct sock *sk, struct bpf_map *map, bool cacheit_loc=
kit)
+bpf_sk_storage_lookup(struct sock *sk, struct bpf_map *map, bool cacheit=
_lockit)
 {
 	struct bpf_local_storage *sk_storage;
 	struct bpf_local_storage_map *smap;
@@ -29,11 +29,11 @@ sk_storage_lookup(struct sock *sk, struct bpf_map *ma=
p, bool cacheit_lockit)
 	return bpf_local_storage_lookup(sk_storage, smap, cacheit_lockit);
 }
=20
-static int sk_storage_delete(struct sock *sk, struct bpf_map *map)
+static int bpf_sk_storage_del(struct sock *sk, struct bpf_map *map)
 {
 	struct bpf_local_storage_data *sdata;
=20
-	sdata =3D sk_storage_lookup(sk, map, false);
+	sdata =3D bpf_sk_storage_lookup(sk, map, false);
 	if (!sdata)
 		return -ENOENT;
=20
@@ -82,7 +82,7 @@ void bpf_sk_storage_free(struct sock *sk)
 		kfree_rcu(sk_storage, rcu);
 }
=20
-static void sk_storage_map_free(struct bpf_map *map)
+static void bpf_sk_storage_map_free(struct bpf_map *map)
 {
 	struct bpf_local_storage_map *smap;
=20
@@ -91,7 +91,7 @@ static void sk_storage_map_free(struct bpf_map *map)
 	bpf_local_storage_map_free(smap);
 }
=20
-static struct bpf_map *sk_storage_map_alloc(union bpf_attr *attr)
+static struct bpf_map *bpf_sk_storage_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_local_storage_map *smap;
=20
@@ -118,7 +118,7 @@ static void *bpf_fd_sk_storage_lookup_elem(struct bpf=
_map *map, void *key)
 	fd =3D *(int *)key;
 	sock =3D sockfd_lookup(fd, &err);
 	if (sock) {
-		sdata =3D sk_storage_lookup(sock->sk, map, true);
+		sdata =3D bpf_sk_storage_lookup(sock->sk, map, true);
 		sockfd_put(sock);
 		return sdata ? sdata->data : NULL;
 	}
@@ -154,7 +154,7 @@ static int bpf_fd_sk_storage_delete_elem(struct bpf_m=
ap *map, void *key)
 	fd =3D *(int *)key;
 	sock =3D sockfd_lookup(fd, &err);
 	if (sock) {
-		err =3D sk_storage_delete(sock->sk, map);
+		err =3D bpf_sk_storage_del(sock->sk, map);
 		sockfd_put(sock);
 		return err;
 	}
@@ -260,7 +260,7 @@ BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map,=
 struct sock *, sk,
 	if (!sk || !sk_fullsock(sk) || flags > BPF_SK_STORAGE_GET_F_CREATE)
 		return (unsigned long)NULL;
=20
-	sdata =3D sk_storage_lookup(sk, map, true);
+	sdata =3D bpf_sk_storage_lookup(sk, map, true);
 	if (sdata)
 		return (unsigned long)sdata->data;
=20
@@ -293,7 +293,7 @@ BPF_CALL_2(bpf_sk_storage_delete, struct bpf_map *, m=
ap, struct sock *, sk)
 	if (refcount_inc_not_zero(&sk->sk_refcnt)) {
 		int err;
=20
-		err =3D sk_storage_delete(sk, map);
+		err =3D bpf_sk_storage_del(sk, map);
 		sock_put(sk);
 		return err;
 	}
@@ -301,8 +301,8 @@ BPF_CALL_2(bpf_sk_storage_delete, struct bpf_map *, m=
ap, struct sock *, sk)
 	return -ENOENT;
 }
=20
-static int sk_storage_charge(struct bpf_local_storage_map *smap,
-			     void *owner, u32 size)
+static int bpf_sk_storage_charge(struct bpf_local_storage_map *smap,
+				 void *owner, u32 size)
 {
 	struct sock *sk =3D (struct sock *)owner;
=20
@@ -316,8 +316,8 @@ static int sk_storage_charge(struct bpf_local_storage=
_map *smap,
 	return -ENOMEM;
 }
=20
-static void sk_storage_uncharge(struct bpf_local_storage_map *smap,
-				void *owner, u32 size)
+static void bpf_sk_storage_uncharge(struct bpf_local_storage_map *smap,
+				    void *owner, u32 size)
 {
 	struct sock *sk =3D owner;
=20
@@ -325,7 +325,7 @@ static void sk_storage_uncharge(struct bpf_local_stor=
age_map *smap,
 }
=20
 static struct bpf_local_storage __rcu **
-sk_storage_ptr(void *owner)
+bpf_sk_storage_ptr(void *owner)
 {
 	struct sock *sk =3D owner;
=20
@@ -336,8 +336,8 @@ static int sk_storage_map_btf_id;
 const struct bpf_map_ops sk_storage_map_ops =3D {
 	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D bpf_local_storage_map_alloc_check,
-	.map_alloc =3D sk_storage_map_alloc,
-	.map_free =3D sk_storage_map_free,
+	.map_alloc =3D bpf_sk_storage_map_alloc,
+	.map_free =3D bpf_sk_storage_map_free,
 	.map_get_next_key =3D notsupp_get_next_key,
 	.map_lookup_elem =3D bpf_fd_sk_storage_lookup_elem,
 	.map_update_elem =3D bpf_fd_sk_storage_update_elem,
@@ -345,9 +345,9 @@ const struct bpf_map_ops sk_storage_map_ops =3D {
 	.map_check_btf =3D bpf_local_storage_map_check_btf,
 	.map_btf_name =3D "bpf_local_storage_map",
 	.map_btf_id =3D &sk_storage_map_btf_id,
-	.map_local_storage_charge =3D sk_storage_charge,
-	.map_local_storage_uncharge =3D sk_storage_uncharge,
-	.map_owner_storage_ptr =3D sk_storage_ptr,
+	.map_local_storage_charge =3D bpf_sk_storage_charge,
+	.map_local_storage_uncharge =3D bpf_sk_storage_uncharge,
+	.map_owner_storage_ptr =3D bpf_sk_storage_ptr,
 };
=20
 const struct bpf_func_proto bpf_sk_storage_get_proto =3D {
--=20
2.24.1

