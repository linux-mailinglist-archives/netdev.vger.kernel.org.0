Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D443AFFB2
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 10:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhFVI7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 04:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhFVI7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 04:59:30 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28853C061574;
        Tue, 22 Jun 2021 01:57:15 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j2so12129568wrs.12;
        Tue, 22 Jun 2021 01:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=FG0AmbsSXTq8aZKNtsn7qS7XkGzSZ8NL2jrigaWI+cc=;
        b=dQM1cqmfZIDA4EaULsoVcI3RAMKrX41ul7kX4Wtg3Zdqmj3LBl6x5hY1Cds5MVl6et
         xj/qBCwARkSOc74ozQepZDW1mE/fP/75TcFJjfJsKZjR7zy8I1emDv/Ja0TBwFyraeN3
         6nkAYSAaYyyVnKcO0J5MH4Ls/BeceZqelLtYwjFf11GyvWt/LO3ZLtdWxE7JFdePFjgE
         vOXIU9Hr5y+C0V9KStzhv5qmyf70pdKE9gS72UzUUJktOfLwhKtAQteKXh/VyyT1Rzwd
         vyK3FHZeg8xCLEg7I83f4KbylBpbfFNxG8N6v9A1ZAPztlKusWAsn9I6jOZPuOm9tpAW
         KwZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=FG0AmbsSXTq8aZKNtsn7qS7XkGzSZ8NL2jrigaWI+cc=;
        b=NiAjsM8gc/VWIMf1lVZBer7La1ph6rjNq5BwTmlxL6vcv1qMvd9vqagxZkbi7R0qil
         ByiA46X4mFwlvid1qU0JhJsFeiSt3urojfY9wtueAW6k3E98ox+30rJAsUgoU0g67tgV
         3NLPQSyvdgKRlPDF2CsOLZAL/Iy9Y+8hotBL0IoVCM66ytagf+WDAheWGNIuxjFJZkFx
         kg6BCzb0lcxPq1auZHxSokTAxRZgDSuwRTvvxgM44eERMjKc23qoNlM2gUVefsmpo265
         nexV7jKn5yVYC7j3IzqoNRf0J25mJMW3vsswpdoF35DJDVG2DJR9b0tFxDiN+Qda/GIZ
         ZdHA==
X-Gm-Message-State: AOAM5315YVePrzgKDSFLNUAgBXqkuRuLUMON94Iupx5oSzhCdocK6HJl
        t2egJYW/GF7ADXu2BBQ6Rtzljm4llwU4Le5G
X-Google-Smtp-Source: ABdhPJzObstSbscLENNm/C+3vJyNLfRtj3jIxzaOBOkXNCu3wXIhowoUiYmvG8PechJ7JKAh0zhiEw==
X-Received: by 2002:adf:dcca:: with SMTP id x10mr3332298wrm.39.1624352233510;
        Tue, 22 Jun 2021 01:57:13 -0700 (PDT)
Received: from DESKTOP-A66711V ([5.29.25.101])
        by smtp.gmail.com with ESMTPSA id p11sm10799591wre.57.2021.06.22.01.57.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jun 2021 01:57:13 -0700 (PDT)
Message-ID: <60d1a5e9.1c69fb81.7f729.b892@mx.google.com>
Date:   Tue, 22 Jun 2021 01:57:13 -0700 (PDT)
X-Google-Original-Date: 22 Jun 2021 11:57:13 +0300
MIME-Version: 1.0
From:   "Amit Klein" <aksecurity@gmail.com>
To:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, edumazet@google.com, w@1wt.eu,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4.9] inet: use bigger hash table for IP ID generation
 (backported to 4.9 and 4.4)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject: inet: use bigger hash table for IP ID generation (backpo=
rted to 4.9 and 4.4)=0AFrom: Amit Klein <aksecurity@gmail.com>=0A=
=0A[ Upstream commit aa6dd211e4b1dde9d5dc25d699d35f789ae7eeba ]=0A=
 =0AThis is a backport to 4.9 and 4.4 of the following patch, ori=
ginally=0Adeveloped by Eric Dumazet.=0A=0AIn commit 73f156a6e8c1 =
("inetpeer: get rid of ip_id_count")=0AI used a very small hash t=
able that could be abused=0Aby patient attackers to reveal sensit=
ive information.=0A=0ASwitch to a dynamic sizing, depending on RA=
M size.=0A=0ATypical big hosts will now use 128x more storage (2 =
MB)=0Ato get a similar increase in security and reduction=0Aof ha=
sh collisions.=0A=0AAs a bonus, use of alloc_large_system_hash() =
spreads=0Aallocated memory among all NUMA nodes.=0A=0AFixes: 73f1=
56a6e8c1 ("inetpeer: get rid of ip_id_count")=0AReported-by: Amit=
 Klein <aksecurity@gmail.com>=0ACc: stable@vger.kernel.org=0ACc: =
Eric Dumazet <edumazet@google.com>=0ACc: Willy Tarreau <w@1wt.eu>=
=0A---=0A net/ipv4/route.c | 42 +++++++++++++++++++++++++++++----=
---------=0A 1 file changed, 29 insertions(+), 13 deletions(-)=0A=
=0Adiff --git a/net/ipv4/route.c b/net/ipv4/route.c=0Aindex e9aae=
46..5350e1b 100644=0A--- a/net/ipv4/route.c=0A+++ b/net/ipv4/rout=
e.c=0A@@ -70,6 +70,7 @@=0A #include <linux/types.h>=0A #include <=
linux/kernel.h>=0A #include <linux/mm.h>=0A+#include <linux/bootm=
em.h>=0A #include <linux/string.h>=0A #include <linux/socket.h>=0A=
 #include <linux/sockios.h>=0A@@ -463,8 +464,10 @@ static struct =
neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,=0A 	ret=
urn neigh_create(&arp_tbl, pkey, dev);=0A }=0A =0A-#define IP_IDE=
NTS_SZ 2048u=0A-=0A+/* Hash tables of size 2048..262144 depending=
 on RAM size.=0A+ * Each bucket uses 8 bytes.=0A+ */=0A+static u3=
2 ip_idents_mask __read_mostly;=0A static atomic_t *ip_idents __r=
ead_mostly;=0A static u32 *ip_tstamps __read_mostly;=0A =0A@@ -47=
4,12 +477,16 @@ static u32 *ip_tstamps __read_mostly;=0A  */=0A u=
32 ip_idents_reserve(u32 hash, int segs)=0A {=0A-	u32 *p_tstamp =3D=
 ip_tstamps + hash % IP_IDENTS_SZ;=0A-	atomic_t *p_id =3D ip_iden=
ts + hash % IP_IDENTS_SZ;=0A-	u32 old =3D ACCESS_ONCE(*p_tstamp);=
=0A-	u32 now =3D (u32)jiffies;=0A+	u32 bucket, old, now =3D (u32)=
jiffies;=0A+	atomic_t *p_id;=0A+	u32 *p_tstamp;=0A 	u32 delta =3D=
 0;=0A =0A+	bucket =3D hash & ip_idents_mask;=0A+	p_tstamp =3D ip=
_tstamps + bucket;=0A+	p_id =3D ip_idents + bucket;=0A+	old =3D A=
CCESS_ONCE(*p_tstamp);=0A+=0A 	if (old !=3D now && cmpxchg(p_tsta=
mp, old, now) =3D=3D old)=0A 		delta =3D prandom_u32_max(now - ol=
d);=0A =0A@@ -2936,18 +2943,27 @@ struct ip_rt_acct __percpu *ip_=
rt_acct __read_mostly;=0A =0A int __init ip_rt_init(void)=0A {=0A=
+	void *idents_hash;=0A 	int rc =3D 0;=0A 	int cpu;=0A =0A-	ip_id=
ents =3D kmalloc(IP_IDENTS_SZ * sizeof(*ip_idents), GFP_KERNEL);=0A=
-	if (!ip_idents)=0A-		panic("IP: failed to allocate ip_idents\n"=
);=0A+	/* For modern hosts, this will use 2 MB of memory */=0A+	i=
dents_hash =3D alloc_large_system_hash("IP idents",=0A+					     =
 sizeof(*ip_idents) + sizeof(*ip_tstamps),=0A+					      0,=0A+		=
			      16, /* one bucket per 64 KB */=0A+					      0,=0A+					=
      NULL,=0A+					      &ip_idents_mask,=0A+					      2048,=0A=
+					      256*1024);=0A+=0A+	ip_idents =3D idents_hash;=0A =0A-=
	prandom_bytes(ip_idents, IP_IDENTS_SZ * sizeof(*ip_idents));=0A+=
	prandom_bytes(ip_idents, (ip_idents_mask + 1) * sizeof(*ip_ident=
s));=0A =0A-	ip_tstamps =3D kcalloc(IP_IDENTS_SZ, sizeof(*ip_tsta=
mps), GFP_KERNEL);=0A-	if (!ip_tstamps)=0A-		panic("IP: failed to=
 allocate ip_tstamps\n");=0A+	ip_tstamps =3D idents_hash + (ip_id=
ents_mask + 1) * sizeof(*ip_idents);=0A+	memset(ip_tstamps, 0, (i=
p_idents_mask + 1) * sizeof(*ip_tstamps));=0A =0A 	for_each_possi=
ble_cpu(cpu) {=0A 		struct uncached_list *ul =3D &per_cpu(rt_unca=
ched_list, cpu);=0A-- =0Acgit 1.2.3-1.el7=0A=0A

