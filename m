Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C78576F63D
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 23:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfGUVxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 17:53:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36069 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfGUVw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 17:52:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so37382546wrs.3;
        Sun, 21 Jul 2019 14:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ru8G2tF8BrtvXna3nOVM7mk9tZRakkkl3JaP7/Y/7kA=;
        b=qNIkZ2mzL8gmk9xGrHxKydBYYl4a/hdTaaj7/1xWyAUOLf5EN6tNbb0paiNIzJGF3P
         lXX/Rwv7nA4+XweAFGbyRAJZhUxOUx8bFDu32V0kD315YEKJTZuYh+PjaQjKh2uhh8FH
         ZtQ6WrX7j9VBr9+A96pkVWjE0DLRa6enpfSVdIcrQsuHhX8Q6TYHyHwIFgtHO/pc3xGl
         4KcCyed0yi2QtIRRz5nHcuxQiKNAwCV84juyKnfwJqoS0MKRbhzlmqkoBS4WTLi+l8s2
         wcyA7ykW3eLJ+VXzGuQKcPlsm7CEgeYiitGF+rFlcM+QYqJTP+kP2RXLPferKvuQJU1d
         XNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=ru8G2tF8BrtvXna3nOVM7mk9tZRakkkl3JaP7/Y/7kA=;
        b=gHswmcVJ7WA/fA8QMQJ0wBI92/uXVBNYg4uorM03T64QPeJllQNkJGaS7HtLVqMi9Q
         QjcAt7k+25J9tc9G4nRjiemLojXIgpyq7Ia9+S7t4lJs00RVmDqVVRaJR/yrOsP4um8z
         Xh5g3fxPesPC+7ODPdOwCMT/bPq4WmgZw4LYRIsZbkaS/rk/czpM8tgk9ApKRVSRwc/e
         Wtl4KaplZOitc8u8jMpClRH63ouSelhzFz77Dljcy0/t20zbPrlW3Q1TjBUoApz9SFrI
         edAHbTPiQ9t4ws9dejCk1ROHvEjzkVd7E2EPRanj0Vo46B4ywUp0CiUgpfRXVWkR5mWk
         vmWQ==
X-Gm-Message-State: APjAAAXSZ9plu73OZRw5O9h/nKOmI5GFPqHGcbseTDnkr9b/geAB0VN3
        9ex5fwcS1deHLKgq246ERQ==
X-Google-Smtp-Source: APXvYqxcUhQtJQz56kf3faYidicE72glm9BCqMWN7zJt3tWR4nw0aOJE4Sqh13+elPcz2/okCcNWNA==
X-Received: by 2002:a5d:6284:: with SMTP id k4mr36608218wru.179.1563745976784;
        Sun, 21 Jul 2019 14:52:56 -0700 (PDT)
Received: from avx2 ([46.53.250.111])
        by smtp.gmail.com with ESMTPSA id o26sm70069874wro.53.2019.07.21.14.52.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 14:52:56 -0700 (PDT)
Date:   Mon, 22 Jul 2019 00:52:53 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        axboe@kernel.dk, kvalo@codeaurora.org, john.johansen@canonical.com,
        linux-arch@vger.kernel.org
Subject: [PATCH] unaligned: delete 1-byte accessors
Message-ID: <20190721215253.GA18177@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each and every 1-byte access is aligned!

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

	There may be more unaligned stuff in arch/.

 block/partitions/ldm.h                      |    2 +-
 block/partitions/msdos.c                    |    2 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c |    2 +-
 include/linux/unaligned/generic.h           |   12 ++----------
 net/core/netpoll.c                          |    4 ++--
 security/apparmor/policy_unpack.c           |    2 +-
 6 files changed, 8 insertions(+), 16 deletions(-)

--- a/block/partitions/ldm.h
+++ b/block/partitions/ldm.h
@@ -85,7 +85,7 @@ struct parsed_partitions;
 #define TOC_BITMAP2		"log"		/* bitmaps in the TOCBLOCK. */
 
 /* Borrowed from msdos.c */
-#define SYS_IND(p)		(get_unaligned(&(p)->sys_ind))
+#define SYS_IND(p)		((p)->sys_ind)
 
 struct frag {				/* VBLK Fragment handling */
 	struct list_head list;
--- a/block/partitions/msdos.c
+++ b/block/partitions/msdos.c
@@ -33,7 +33,7 @@
  */
 #include <asm/unaligned.h>
 
-#define SYS_IND(p)	get_unaligned(&p->sys_ind)
+#define SYS_IND(p)	((p)->sys_ind)
 
 static inline sector_t nr_sects(struct partition *p)
 {
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1090,7 +1090,7 @@ static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 
 	mwifiex_dbg(adapter, INFO,
 		    "alloc_scook: sleep cookie=0x%x\n",
-		    get_unaligned(card->sleep_cookie_vbase));
+		    *card->sleep_cookie_vbase);
 
 	return 0;
 }
--- a/include/linux/unaligned/generic.h
+++ b/include/linux/unaligned/generic.h
@@ -9,27 +9,22 @@
 extern void __bad_unaligned_access_size(void);
 
 #define __get_unaligned_le(ptr) ((__force typeof(*(ptr)))({			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
 	__builtin_choose_expr(sizeof(*(ptr)) == 2, get_unaligned_le16((ptr)),	\
 	__builtin_choose_expr(sizeof(*(ptr)) == 4, get_unaligned_le32((ptr)),	\
 	__builtin_choose_expr(sizeof(*(ptr)) == 8, get_unaligned_le64((ptr)),	\
-	__bad_unaligned_access_size()))));					\
+	__bad_unaligned_access_size())));					\
 	}))
 
 #define __get_unaligned_be(ptr) ((__force typeof(*(ptr)))({			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
 	__builtin_choose_expr(sizeof(*(ptr)) == 2, get_unaligned_be16((ptr)),	\
 	__builtin_choose_expr(sizeof(*(ptr)) == 4, get_unaligned_be32((ptr)),	\
 	__builtin_choose_expr(sizeof(*(ptr)) == 8, get_unaligned_be64((ptr)),	\
-	__bad_unaligned_access_size()))));					\
+	__bad_unaligned_access_size())));					\
 	}))
 
 #define __put_unaligned_le(val, ptr) ({					\
 	void *__gu_p = (ptr);						\
 	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		*(u8 *)__gu_p = (__force u8)(val);			\
-		break;							\
 	case 2:								\
 		put_unaligned_le16((__force u16)(val), __gu_p);		\
 		break;							\
@@ -48,9 +43,6 @@ extern void __bad_unaligned_access_size(void);
 #define __put_unaligned_be(val, ptr) ({					\
 	void *__gu_p = (ptr);						\
 	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		*(u8 *)__gu_p = (__force u8)(val);			\
-		break;							\
 	case 2:								\
 		put_unaligned_be16((__force u16)(val), __gu_p);		\
 		break;							\
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -408,7 +408,7 @@ void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 		ip6h = ipv6_hdr(skb);
 
 		/* ip6h->version = 6; ip6h->priority = 0; */
-		put_unaligned(0x60, (unsigned char *)ip6h);
+		*(unsigned char *)ip6h = 0x60;
 		ip6h->flow_lbl[0] = 0;
 		ip6h->flow_lbl[1] = 0;
 		ip6h->flow_lbl[2] = 0;
@@ -436,7 +436,7 @@ void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 		iph = ip_hdr(skb);
 
 		/* iph->version = 4; iph->ihl = 5; */
-		put_unaligned(0x45, (unsigned char *)iph);
+		*(unsigned char *)iph = 0x45;
 		iph->tos      = 0;
 		put_unaligned(htons(ip_len), &(iph->tot_len));
 		iph->id       = htons(atomic_inc_return(&ip_ident));
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -301,7 +301,7 @@ static bool unpack_u8(struct aa_ext *e, u8 *data, const char *name)
 		if (!inbounds(e, sizeof(u8)))
 			goto fail;
 		if (data)
-			*data = get_unaligned((u8 *)e->pos);
+			*data = *(u8 *)e->pos;
 		e->pos += sizeof(u8);
 		return 1;
 	}
