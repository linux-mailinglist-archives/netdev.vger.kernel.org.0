Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE984B9E96
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 12:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239757AbiBQLau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 06:30:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239805AbiBQLao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 06:30:44 -0500
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C64826A2D2;
        Thu, 17 Feb 2022 03:30:26 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Jzt0x2QyZz9sS8;
        Thu, 17 Feb 2022 12:30:25 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XUnYJCICrvgh; Thu, 17 Feb 2022 12:30:25 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Jzt0x1Ty7z9sQv;
        Thu, 17 Feb 2022 12:30:25 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 25F258B77C;
        Thu, 17 Feb 2022 12:30:25 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 4HxbiZsXw0US; Thu, 17 Feb 2022 12:30:25 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.6.225])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id DC7C08B763;
        Thu, 17 Feb 2022 12:30:24 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 21HBUEOe399195
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 12:30:14 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 21HBUC30399194;
        Thu, 17 Feb 2022 12:30:12 +0100
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH net v2] net: Force inlining of checksum functions in net/checksum.h
Date:   Thu, 17 Feb 2022 12:30:10 +0100
Message-Id: <6e2d915b5fc8a7edc3557bcde2fa06d82edcf974.1645097288.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1645097408; l=8024; s=20211009; h=from:subject:message-id; bh=HcE97JbRKL/kvh1JeDkyVDbNMuB70rD3eT2NwCu2/Kw=; b=bEJ9jjTQGGBmJg6n/t9KzGdpavvqwn2W6x8Ax6i92YSI6+mSoN/O9CyiChojjrkhC8uYVkUPQpLe oEd8FwurBZ4lur5Rq/y0y8f3YDxEUEJU3q3V6oeacFQxHd0j/6Ru
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All functions defined as static inline in net/checksum.h are
meant to be inlined for performance reason.

But since commit ac7c3e4ff401 ("compiler: enable
CONFIG_OPTIMIZE_INLINING forcibly") the compiler is allowed to
uninline functions when it wants.

Fair enough in the general case, but for tiny performance critical
checksum helpers that's counter-productive.

The problem mainly arises when selecting CONFIG_CC_OPTIMISE_FOR_SIZE,
Those helpers being 'static inline' in header files you suddenly find
them duplicated many times in the resulting vmlinux.

Here is a typical exemple when building powerpc pmac32_defconfig
with CONFIG_CC_OPTIMISE_FOR_SIZE. csum_sub() appears 4 times:

	c04a23cc <csum_sub>:
	c04a23cc:	7c 84 20 f8 	not     r4,r4
	c04a23d0:	7c 63 20 14 	addc    r3,r3,r4
	c04a23d4:	7c 63 01 94 	addze   r3,r3
	c04a23d8:	4e 80 00 20 	blr
		...
	c04a2ce8:	4b ff f6 e5 	bl      c04a23cc <csum_sub>
		...
	c04a2d2c:	4b ff f6 a1 	bl      c04a23cc <csum_sub>
		...
	c04a2d54:	4b ff f6 79 	bl      c04a23cc <csum_sub>
		...
	c04a754c <csum_sub>:
	c04a754c:	7c 84 20 f8 	not     r4,r4
	c04a7550:	7c 63 20 14 	addc    r3,r3,r4
	c04a7554:	7c 63 01 94 	addze   r3,r3
	c04a7558:	4e 80 00 20 	blr
		...
	c04ac930:	4b ff ac 1d 	bl      c04a754c <csum_sub>
		...
	c04ad264:	4b ff a2 e9 	bl      c04a754c <csum_sub>
		...
	c04e3b08 <csum_sub>:
	c04e3b08:	7c 84 20 f8 	not     r4,r4
	c04e3b0c:	7c 63 20 14 	addc    r3,r3,r4
	c04e3b10:	7c 63 01 94 	addze   r3,r3
	c04e3b14:	4e 80 00 20 	blr
		...
	c04e5788:	4b ff e3 81 	bl      c04e3b08 <csum_sub>
		...
	c04e65c8:	4b ff d5 41 	bl      c04e3b08 <csum_sub>
		...
	c0512d34 <csum_sub>:
	c0512d34:	7c 84 20 f8 	not     r4,r4
	c0512d38:	7c 63 20 14 	addc    r3,r3,r4
	c0512d3c:	7c 63 01 94 	addze   r3,r3
	c0512d40:	4e 80 00 20 	blr
		...
	c0512dfc:	4b ff ff 39 	bl      c0512d34 <csum_sub>
		...
	c05138bc:	4b ff f4 79 	bl      c0512d34 <csum_sub>
		...

Restore the expected behaviour by using __always_inline for all
functions defined in net/checksum.h

vmlinux size is even reduced by 256 bytes with this patch:

	   text	   data	    bss	    dec	    hex	filename
	6980022	2515362	 194384	9689768	 93daa8	vmlinux.before
	6979862	2515266	 194384	9689512	 93d9a8	vmlinux.now

Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
v2: Rebased on net tree

 include/net/checksum.h | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/net/checksum.h b/include/net/checksum.h
index 5218041e5c8f..1e2e011c51f6 100644
--- a/include/net/checksum.h
+++ b/include/net/checksum.h
@@ -22,7 +22,7 @@
 #include <asm/checksum.h>
 
 #ifndef _HAVE_ARCH_COPY_AND_CSUM_FROM_USER
-static inline
+static __always_inline
 __wsum csum_and_copy_from_user (const void __user *src, void *dst,
 				      int len)
 {
@@ -33,7 +33,7 @@ __wsum csum_and_copy_from_user (const void __user *src, void *dst,
 #endif
 
 #ifndef HAVE_CSUM_COPY_USER
-static __inline__ __wsum csum_and_copy_to_user
+static __always_inline __wsum csum_and_copy_to_user
 (const void *src, void __user *dst, int len)
 {
 	__wsum sum = csum_partial(src, len, ~0U);
@@ -45,7 +45,7 @@ static __inline__ __wsum csum_and_copy_to_user
 #endif
 
 #ifndef _HAVE_ARCH_CSUM_AND_COPY
-static inline __wsum
+static __always_inline __wsum
 csum_partial_copy_nocheck(const void *src, void *dst, int len)
 {
 	memcpy(dst, src, len);
@@ -54,7 +54,7 @@ csum_partial_copy_nocheck(const void *src, void *dst, int len)
 #endif
 
 #ifndef HAVE_ARCH_CSUM_ADD
-static inline __wsum csum_add(__wsum csum, __wsum addend)
+static __always_inline __wsum csum_add(__wsum csum, __wsum addend)
 {
 	u32 res = (__force u32)csum;
 	res += (__force u32)addend;
@@ -62,12 +62,12 @@ static inline __wsum csum_add(__wsum csum, __wsum addend)
 }
 #endif
 
-static inline __wsum csum_sub(__wsum csum, __wsum addend)
+static __always_inline __wsum csum_sub(__wsum csum, __wsum addend)
 {
 	return csum_add(csum, ~addend);
 }
 
-static inline __sum16 csum16_add(__sum16 csum, __be16 addend)
+static __always_inline __sum16 csum16_add(__sum16 csum, __be16 addend)
 {
 	u16 res = (__force u16)csum;
 
@@ -75,12 +75,12 @@ static inline __sum16 csum16_add(__sum16 csum, __be16 addend)
 	return (__force __sum16)(res + (res < (__force u16)addend));
 }
 
-static inline __sum16 csum16_sub(__sum16 csum, __be16 addend)
+static __always_inline __sum16 csum16_sub(__sum16 csum, __be16 addend)
 {
 	return csum16_add(csum, ~addend);
 }
 
-static inline __wsum csum_shift(__wsum sum, int offset)
+static __always_inline __wsum csum_shift(__wsum sum, int offset)
 {
 	/* rotate sum to align it with a 16b boundary */
 	if (offset & 1)
@@ -88,42 +88,42 @@ static inline __wsum csum_shift(__wsum sum, int offset)
 	return sum;
 }
 
-static inline __wsum
+static __always_inline __wsum
 csum_block_add(__wsum csum, __wsum csum2, int offset)
 {
 	return csum_add(csum, csum_shift(csum2, offset));
 }
 
-static inline __wsum
+static __always_inline __wsum
 csum_block_add_ext(__wsum csum, __wsum csum2, int offset, int len)
 {
 	return csum_block_add(csum, csum2, offset);
 }
 
-static inline __wsum
+static __always_inline __wsum
 csum_block_sub(__wsum csum, __wsum csum2, int offset)
 {
 	return csum_block_add(csum, ~csum2, offset);
 }
 
-static inline __wsum csum_unfold(__sum16 n)
+static __always_inline __wsum csum_unfold(__sum16 n)
 {
 	return (__force __wsum)n;
 }
 
-static inline __wsum csum_partial_ext(const void *buff, int len, __wsum sum)
+static __always_inline __wsum csum_partial_ext(const void *buff, int len, __wsum sum)
 {
 	return csum_partial(buff, len, sum);
 }
 
 #define CSUM_MANGLED_0 ((__force __sum16)0xffff)
 
-static inline void csum_replace_by_diff(__sum16 *sum, __wsum diff)
+static __always_inline void csum_replace_by_diff(__sum16 *sum, __wsum diff)
 {
 	*sum = csum_fold(csum_add(diff, ~csum_unfold(*sum)));
 }
 
-static inline void csum_replace4(__sum16 *sum, __be32 from, __be32 to)
+static __always_inline void csum_replace4(__sum16 *sum, __be32 from, __be32 to)
 {
 	__wsum tmp = csum_sub(~csum_unfold(*sum), (__force __wsum)from);
 
@@ -136,7 +136,7 @@ static inline void csum_replace4(__sum16 *sum, __be32 from, __be32 to)
  *  m : old value of a 16bit field
  *  m' : new value of a 16bit field
  */
-static inline void csum_replace2(__sum16 *sum, __be16 old, __be16 new)
+static __always_inline void csum_replace2(__sum16 *sum, __be16 old, __be16 new)
 {
 	*sum = ~csum16_add(csum16_sub(~(*sum), old), new);
 }
@@ -150,7 +150,7 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
 void inet_proto_csum_replace_by_diff(__sum16 *sum, struct sk_buff *skb,
 				     __wsum diff, bool pseudohdr);
 
-static inline void inet_proto_csum_replace2(__sum16 *sum, struct sk_buff *skb,
+static __always_inline void inet_proto_csum_replace2(__sum16 *sum, struct sk_buff *skb,
 					    __be16 from, __be16 to,
 					    bool pseudohdr)
 {
@@ -158,7 +158,7 @@ static inline void inet_proto_csum_replace2(__sum16 *sum, struct sk_buff *skb,
 				 (__force __be32)to, pseudohdr);
 }
 
-static inline __wsum remcsum_adjust(void *ptr, __wsum csum,
+static __always_inline __wsum remcsum_adjust(void *ptr, __wsum csum,
 				    int start, int offset)
 {
 	__sum16 *psum = (__sum16 *)(ptr + offset);
@@ -175,12 +175,12 @@ static inline __wsum remcsum_adjust(void *ptr, __wsum csum,
 	return delta;
 }
 
-static inline void remcsum_unadjust(__sum16 *psum, __wsum delta)
+static __always_inline void remcsum_unadjust(__sum16 *psum, __wsum delta)
 {
 	*psum = csum_fold(csum_sub(delta, (__force __wsum)*psum));
 }
 
-static inline __wsum wsum_negate(__wsum val)
+static __always_inline __wsum wsum_negate(__wsum val)
 {
 	return (__force __wsum)-((__force u32)val);
 }
-- 
2.34.1

