Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BF63AAE98
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 10:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFQIV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 04:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhFQIV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 04:21:28 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F61CC061574;
        Thu, 17 Jun 2021 01:19:20 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id t11-20020a1cc30b0000b02901cec841b6a0so3785281wmf.0;
        Thu, 17 Jun 2021 01:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=m23FkcTpSbNnpGC+SlBcypLFRWWqdG3+ErURqb57YnE=;
        b=miIM9//NWleAyVq9NBLFq/rFMnM1knoTUZ+2/qxJu/iT9OqQtkGla6HDlcHvIoES5+
         TmRQauP+1eX6mRVYeAcbyYwYUXfyo6uQBlNr21y9pB8FwA3lq8fXHAcVOxev41WGEttH
         bZPuB9g4qEPLRfzbWwHdXny6pXJz8bJzu5vKpTN95A9Rqin8tXWiYIE04veWrggd8kT+
         biJ/fDcWNe1Ovkyz7bCoqkqxJnPCEYaXZ/q/gTZLm0TO/6OYjr+VL0Vrv3oYeZXiScV9
         DxRgLm7jw4SSSXdxUJvotnNimvwOOwBlCFx+z/BRYurwExKuwvSg32z3T/BkXWq8mtOC
         St4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=m23FkcTpSbNnpGC+SlBcypLFRWWqdG3+ErURqb57YnE=;
        b=hb1EizEvaQoizPOwG+9VynsXV0wLDXai9Lobf5B6lPnOQACQto8OvbPZNuHURxbuqj
         JNyc+9ZL7jPeL6HLNN/jUC0BrG2Y8l7fkb11gzSwtUmc9OoFhqpq1qHuKmM7I8F0mxOW
         byo6exEKlTVmlAe/r9tbYNdXzA0WnAbS3dqyAE8HyZ7VXqCiyN6tairWzrx1Rog2PKh0
         +6GYJQd0uaWtgXciXUhESYsVMX6+6nxl7dlvqOdoC2NT56EgC2oY1AHJ74g/5qhRxUSR
         gtxMlUazMLARpWrcO52EdDZFsnWeozDtmsCaMZi0ZyLzfUpLHuHnjQ/jbjtfXK7Z0hUO
         OU9w==
X-Gm-Message-State: AOAM531fVK09Dr5MkaiuZBYYkWvVTt2a6MzubJOqEkNQHzVOZamHBEK0
        PjdPo3qQWDJ1umJYNMM8SeoOh9ar7vcBX4Nu
X-Google-Smtp-Source: ABdhPJzMLK29L+nxWeJsp/F9zI3AW8VTwosq64Vcj8KgXQFqQjkPx7TCVss4ZExsAhmMTX+LKitd5w==
X-Received: by 2002:a7b:c346:: with SMTP id l6mr3550663wmj.109.1623917958820;
        Thu, 17 Jun 2021 01:19:18 -0700 (PDT)
Received: from DESKTOP-A66711V ([5.29.25.101])
        by smtp.gmail.com with ESMTPSA id z12sm4573522wrw.97.2021.06.17.01.19.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jun 2021 01:19:18 -0700 (PDT)
Message-ID: <60cb0586.1c69fb81.8015b.37a1@mx.google.com>
Date:   Thu, 17 Jun 2021 01:19:18 -0700 (PDT)
X-Google-Original-Date: 17 Jun 2021 11:19:17 +0300
MIME-Version: 1.0
From:   "Amit Klein" <aksecurity@gmail.com>
To:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, edumazet@google.com, w@1wt.eu,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4.19] inet: use bigger hash table for IP ID generation
 (backported to 4.19)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject: inet: use bigger hash table for IP ID generation (backpo=
rted to 4.19)=0AFrom: Amit Klein <aksecurity@gmail.com>=0A=0AThis=
 is a backport to 4.19 of the following patch, originally=0Adevel=
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
mazet@google.com>=0ACc: Willy Tarreau <w@1wt.eu>=0A---=0A net/ipv=
4/route.c | 42 ++++++++++++++++++++++++++++--------------=0A 1 fi=
le changed, 28 insertions(+), 14 deletions(-)=0A=0A(limited to 'n=
et/ipv4/route.c')=0A=0Adiff --git a/net/ipv4/route.c b/net/ipv4/r=
oute.c=0Aindex 0470442ff61d6..ea916df1bbf5e 100644=0A--- a/net/ip=
v4/route.c=0A+++ b/net/ipv4/route.c=0A@@ -66,6 +66,7 @@=0A #inclu=
de <linux/types.h>=0A #include <linux/kernel.h>=0A #include <linu=
x/mm.h>=0A+#include <linux/bootmem.h>=0A #include <linux/string.h=
>=0A #include <linux/socket.h>=0A #include <linux/sockios.h>=0A@@=
 -452,8 +453,10 @@ static void ipv4_confirm_neigh(const struct ds=
t_entry *dst, const void *daddr)=0A 	__ipv4_confirm_neigh(dev, *(=
__force u32 *)pkey);=0A }=0A =0A-#define IP_IDENTS_SZ 2048u=0A-=0A=
+/* Hash tables of size 2048..262144 depending on RAM size.=0A+ *=
 Each bucket uses 8 bytes.=0A+ */=0A+static u32 ip_idents_mask __=
read_mostly;=0A static atomic_t *ip_idents __read_mostly;=0A stat=
ic u32 *ip_tstamps __read_mostly;=0A =0A@@ -463,12 +466,16 @@ sta=
tic u32 *ip_tstamps __read_mostly;=0A  */=0A u32 ip_idents_reserv=
e(u32 hash, int segs)=0A {=0A-	u32 *p_tstamp =3D ip_tstamps + has=
h % IP_IDENTS_SZ;=0A-	atomic_t *p_id =3D ip_idents + hash % IP_ID=
ENTS_SZ;=0A-	u32 old =3D READ_ONCE(*p_tstamp);=0A-	u32 now =3D (u=
32)jiffies;=0A+	u32 bucket, old, now =3D (u32)jiffies;=0A+	atomic=
_t *p_id;=0A+	u32 *p_tstamp;=0A 	u32 delta =3D 0;=0A =0A+	bucket =
=3D hash & ip_idents_mask;=0A+	p_tstamp =3D ip_tstamps + bucket;=0A=
+	p_id =3D ip_idents + bucket;=0A+	old =3D READ_ONCE(*p_tstamp);=0A=
+=0A 	if (old !=3D now && cmpxchg(p_tstamp, old, now) =3D=3D old)=
=0A 		delta =3D prandom_u32_max(now - old);=0A =0A@@ -3557,18 +35=
64,25 @@ struct ip_rt_acct __percpu *ip_rt_acct __read_mostly;=0A=
 =0A int __init ip_rt_init(void)=0A {=0A+	void *idents_hash;=0A 	=
int cpu;=0A =0A-	ip_idents =3D kmalloc_array(IP_IDENTS_SZ, sizeof=
(*ip_idents),=0A-				  GFP_KERNEL);=0A-	if (!ip_idents)=0A-		pani=
c("IP: failed to allocate ip_idents\n");=0A+	/* For modern hosts,=
 this will use 2 MB of memory */=0A+	idents_hash =3D alloc_large_=
system_hash("IP idents",=0A+					      sizeof(*ip_idents) + sizeo=
f(*ip_tstamps),=0A+					      0,=0A+					      16, /* one bucket =
per 64 KB */=0A+					      HASH_ZERO,=0A+					      NULL,=0A+				=
	      &ip_idents_mask,=0A+					      2048,=0A+					      256*102=
4);=0A+=0A+	ip_idents =3D idents_hash;=0A =0A-	prandom_bytes(ip_i=
dents, IP_IDENTS_SZ * sizeof(*ip_idents));=0A+	prandom_bytes(ip_i=
dents, (ip_idents_mask + 1) * sizeof(*ip_idents));=0A =0A-	ip_tst=
amps =3D kcalloc(IP_IDENTS_SZ, sizeof(*ip_tstamps), GFP_KERNEL);=0A=
-	if (!ip_tstamps)=0A-		panic("IP: failed to allocate ip_tstamps\=
n");=0A+	ip_tstamps =3D idents_hash + (ip_idents_mask + 1) * size=
of(*ip_idents);=0A =0A 	for_each_possible_cpu(cpu) {=0A 		struct =
uncached_list *ul =3D &per_cpu(rt_uncached_list, cpu);=0A-- =0Acg=
it 1.2.3-1.el7=0A=0A

