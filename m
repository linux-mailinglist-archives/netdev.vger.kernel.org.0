Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267173AC807
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhFRJxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbhFRJxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 05:53:36 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56D1C061574;
        Fri, 18 Jun 2021 02:51:24 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id b11so7823710edy.4;
        Fri, 18 Jun 2021 02:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=co8zLZLhH4fpYJR8rbvvlVreIN4wv0cCcb110nTXIco=;
        b=aJqTizihnPFNRJbJlR4hEa/jaxylwJHvjHSprP58rNZx1jYm/6B648RicbL3Zdg/nE
         Z/bsAu8DdauuN/1XmoFUevwft25shoQyWMPDWsGRowUWQbEvyGHfKRBApD2pRYCMJzJn
         r9Zbh0/uGIIOikvup9rodFylzYgzXC81tdfxgyjWlLSswwejKHG/5a9ihk/lHANKQI7H
         hE9En4ShTq4C08CrxSnA2xHJFiHsfKmpMuIlMXJv6fSAfulKMg03fpX/y92WRgel3uoE
         zTxYJn1NXgBf1CjS5U5FJ6lxQKZeHwtHbaq0+OFUJaIid+SLA/4FYhtjO4UT4vuZ9YzI
         bNwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=co8zLZLhH4fpYJR8rbvvlVreIN4wv0cCcb110nTXIco=;
        b=dnlgnWhEZrXLlH8LFor6bK2+KA8GG/LkoGgV4sQmMXmMdwodtUuj2nmvTH0PFaajUA
         t5/QEzxSxBRCqNLVmGIWn6Q6y4xOt9MMYJ6cdjbY5kjMVTuR6viaBHxfKqS4SkY3NNae
         2IMmetxHse8y2hwDRFIbR1BVFG3EiW5hLkV6+hV5LfT8eut+HXrrDkh/GiO5uJXj1Pgk
         TuR7cK88IPmHSzVFbgAa81VJYCMaY14RqwA+4v0JVQkYJV0xKqoLv/c8SnhctsDpyttH
         rkarl23FqaDSopbXuXdrZ7if4O0FhLHrhBw5FUss/BJJaVcG3Qbr7JNGIsmtfYBfYX+C
         KrdA==
X-Gm-Message-State: AOAM532Qi3vC3bwHUkpJZs008+05Tp5POipb+EI1bRYxfLCsYH7ilEBT
        C6sl1PD1XyZT5PEPbwSuJu1CH7l4zSnlJTeX
X-Google-Smtp-Source: ABdhPJwer1TlC7z3fsczahuCZild8iCO6b60wA6Xf5KmJlKT0OFI/ivwWgdAFBJW9lHHtzzDGZm4DQ==
X-Received: by 2002:a05:6402:2317:: with SMTP id l23mr3806944eda.265.1624009883077;
        Fri, 18 Jun 2021 02:51:23 -0700 (PDT)
Received: from DESKTOP-A66711V ([5.29.25.101])
        by smtp.gmail.com with ESMTPSA id i26sm5979945edq.54.2021.06.18.02.51.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jun 2021 02:51:22 -0700 (PDT)
Message-ID: <60cc6c9a.1c69fb81.70a57.7034@mx.google.com>
Date:   Fri, 18 Jun 2021 02:51:22 -0700 (PDT)
X-Google-Original-Date: 18 Jun 2021 12:51:22 +0300
MIME-Version: 1.0
From:   "Amit Klein" <aksecurity@gmail.com>
To:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, edumazet@google.com, w@1wt.eu,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4.14] inet: use bigger hash table for IP ID generation
 (backported to 4.14)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject: inet: use bigger hash table for IP ID generation (backpo=
rted to 4.14)=0AFrom: Amit Klein <aksecurity@gmail.com>=0A=0AThis=
 is a backport to 4.14 of the following patch, originally=0Adevel=
oped by Eric Dumazet.=0A=0AIn commit 73f156a6e8c1 ("inetpeer: get=
 rid of ip_id_count")=0AI used a very small hash table that could=
 be abused=0Aby patient attackers to reveal sensitive information=
.=0A=0ASwitch to a dynamic sizing, depending on RAM size.=0A=0ATy=
pical big hosts will now use 128x more storage (2 MB)=0Ato get a =
similar increase in security and reduction=0Aof hash collisions.=0A=
=0AAs a bonus, use of alloc_large_system_hash() spreads=0Aallocat=
ed memory among all NUMA nodes.=0A=0AFixes: 73f156a6e8c1 ("inetpe=
er: get rid of ip_id_count")=0AReported-by: Amit Klein <aksecurit=
y@gmail.com>=0ACc: stable@vger.kernel.org=0ACc: Eric Dumazet <edu=
mazet@google.com>=0ACc: Willy Tarreau <w@1wt.eu>=0A---=0A=0A net/=
ipv4/route.c | 41 ++++++++++++++++++++++++++++-------------=0A 1 =
file changed, 28 insertions(+), 13 deletions(-)=0A=0Adiff --git a=
/net/ipv4/route.c b/net/ipv4/route.c=0Aindex 78d6bc6..81901b0 100=
644=0A--- a/net/ipv4/route.c=0A+++ b/net/ipv4/route.c=0A@@ -70,6 =
+70,7 @@=0A #include <linux/types.h>=0A #include <linux/kernel.h>=
=0A #include <linux/mm.h>=0A+#include <linux/bootmem.h>=0A #inclu=
de <linux/string.h>=0A #include <linux/socket.h>=0A #include <lin=
ux/sockios.h>=0A@@ -485,8 +486,10 @@ static void ipv4_confirm_nei=
gh(const struct dst_entry *dst, const void *daddr)=0A 	__ipv4_con=
firm_neigh(dev, *(__force u32 *)pkey);=0A }=0A =0A-#define IP_IDE=
NTS_SZ 2048u=0A-=0A+/* Hash tables of size 2048..262144 depending=
 on RAM size.=0A+ * Each bucket uses 8 bytes.=0A+ */=0A+static u3=
2 ip_idents_mask __read_mostly;=0A static atomic_t *ip_idents __r=
ead_mostly;=0A static u32 *ip_tstamps __read_mostly;=0A =0A@@ -49=
6,12 +499,16 @@ static u32 *ip_tstamps __read_mostly;=0A  */=0A u=
32 ip_idents_reserve(u32 hash, int segs)=0A {=0A-	u32 *p_tstamp =3D=
 ip_tstamps + hash % IP_IDENTS_SZ;=0A-	atomic_t *p_id =3D ip_iden=
ts + hash % IP_IDENTS_SZ;=0A-	u32 old =3D ACCESS_ONCE(*p_tstamp);=
=0A-	u32 now =3D (u32)jiffies;=0A+	u32 bucket, old, now =3D (u32)=
jiffies;=0A+	atomic_t *p_id;=0A+	u32 *p_tstamp;=0A 	u32 delta =3D=
 0;=0A =0A+	bucket =3D hash & ip_idents_mask;=0A+	p_tstamp =3D ip=
_tstamps + bucket;=0A+	p_id =3D ip_idents + bucket;=0A+	old =3D A=
CCESS_ONCE(*p_tstamp);=0A+=0A 	if (old !=3D now && cmpxchg(p_tsta=
mp, old, now) =3D=3D old)=0A 		delta =3D prandom_u32_max(now - ol=
d);=0A =0A@@ -3098,18 +3105,26 @@ struct ip_rt_acct __percpu *ip_=
rt_acct __read_mostly;=0A =0A int __init ip_rt_init(void)=0A {=0A=
+	void *idents_hash;=0A 	int rc =3D 0;=0A 	int cpu;=0A =0A-	ip_id=
ents =3D kmalloc(IP_IDENTS_SZ * sizeof(*ip_idents), GFP_KERNEL);=0A=
-	if (!ip_idents)=0A-		panic("IP: failed to allocate ip_idents\n"=
);=0A+	/* For modern hosts, this will use 2 MB of memory */=0A+	i=
dents_hash =3D alloc_large_system_hash("IP idents",=0A+					     =
 sizeof(*ip_idents) + sizeof(*ip_tstamps),=0A+					      0,=0A+		=
			      16, /* one bucket per 64 KB */=0A+					      HASH_ZERO,=0A=
+					      NULL,=0A+					      &ip_idents_mask,=0A+					      20=
48,=0A+					      256*1024);=0A+=0A+	ip_idents =3D idents_hash;=0A=
 =0A-	prandom_bytes(ip_idents, IP_IDENTS_SZ * sizeof(*ip_idents))=
;=0A+	prandom_bytes(ip_idents, (ip_idents_mask + 1) * sizeof(*ip_=
idents));=0A =0A-	ip_tstamps =3D kcalloc(IP_IDENTS_SZ, sizeof(*ip=
_tstamps), GFP_KERNEL);=0A-	if (!ip_tstamps)=0A-		panic("IP: fail=
ed to allocate ip_tstamps\n");=0A+	ip_tstamps =3D idents_hash + (=
ip_idents_mask + 1) * sizeof(*ip_idents);=0A =0A 	for_each_possib=
le_cpu(cpu) {=0A 		struct uncached_list *ul =3D &per_cpu(rt_uncac=
hed_list, cpu);=0A-- =0Acgit 1.2.3-1.el7=0A=0A

