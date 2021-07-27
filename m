Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A219D3D7C28
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhG0RbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhG0RbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:31:00 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D06C061757;
        Tue, 27 Jul 2021 10:31:00 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id a26so22922787lfr.11;
        Tue, 27 Jul 2021 10:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=WmlkGbrkM3a2AT1p/6eYnuGLhgp+ub6+Yuxgg6oi8yY=;
        b=ki2TicAWtsulBl81ZFe/Oh/bTHmtGyZaSnGcbCQPoZJTrtibOgW5Yany3+1UZxsxqd
         A3huph0k55HtDLbEeqsZPvVHZLI614dX0aePNJkMNrq+l39yK1ePuBUD0rxQy7Rbdtpt
         ozynXhzsJlh7BQDCgbc9QDK81xtpvopDWltT+9iK6WDxgEJGTYzc3t9cJogKB2L57FVh
         1VUYiAQg0kHpYrj15i+uIhJU0tIQWe2Gzzd5Czk7NPRnx8+KrTT0Nk1DK6WIbGB4fmZQ
         MxD4+/sIjcDgxFZvHIAlO+VPlIvQdkt+t6vU3BgkhUO0DuEoLQYXYnZw/NXW8jfZfGWv
         rW5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=WmlkGbrkM3a2AT1p/6eYnuGLhgp+ub6+Yuxgg6oi8yY=;
        b=frO7P3KXAf1nRjpNjExisvXPG+aZnCouffs4nLHt8SYBcWtCBhg0UP/uYGTkWIsyJK
         /41LiK5/bwosTclmYStMCC3XV3ji/xvdSpUV8K5+2IYt5nfpJio6M13rEusqFXID8P8K
         j/Quj9rz/imfFBqFab4kw8cXn82pxx9PbkBO0aT95d5jfzG9EMwR40Q7A3a131R8i3KB
         ogZyOMLxTnP8xAuZoLraFimTDfGFl0xakrGF7ee36URK8qKY053zdFXrSXFv1OFz8BzO
         ZwsDvGc3Thsp3ArsVsxxBhGMIyAmLDOf0jxDWV+4UGbsPGhY+opcTK8a+ACXbb+rRFnL
         8arQ==
X-Gm-Message-State: AOAM530T7qicWjiKqjm34qIa1AA/YlsfsQqLC8xo5wHWxVx2kJRbV7os
        vwVbNwZSoW23oiBfgualejI=
X-Google-Smtp-Source: ABdhPJxzK1adGqAHxZULx6sENBEuammItjvYBZv89tuUdbChr/yZtAAzZiikAjqXQXXwpWLz/2nG5w==
X-Received: by 2002:ac2:5e9a:: with SMTP id b26mr17876604lfq.362.1627407058841;
        Tue, 27 Jul 2021 10:30:58 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id n28sm346380lfh.176.2021.07.27.10.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:30:58 -0700 (PDT)
Date:   Tue, 27 Jul 2021 20:30:56 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     kernel test robot <lkp@intel.com>
Cc:     syzbot <syzbot+9cd5837a045bbee5b810@syzkaller.appspotmail.com>,
        clang-built-linux@googlegroups.com, kbuild-all@lists.01.org,
        davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] net: xfrm: fix shift-out-of-bounce
Message-ID: <20210727203056.377e5758@gmail.com>
In-Reply-To: <202107280113.ykJy6Oc4-lkp@intel.com>
References: <20210727174318.53806d27@gmail.com>
        <202107280113.ykJy6Oc4-lkp@intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/w+5mWJ0hzkLOGrIDgVYQu8r"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/w+5mWJ0hzkLOGrIDgVYQu8r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 28 Jul 2021 01:25:18 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi Pavel,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on ipsec-next/master]
> [also build test ERROR on next-20210726]
> [cannot apply to ipsec/master net-next/master net/master
> sparc-next/master v5.14-rc3] [If your patch is applied to the wrong
> git tree, kindly drop us a note. And when submitting patch, we
> suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:
> https://github.com/0day-ci/linux/commits/Pavel-Skripkin/net-xfrm-fix-shift-out-of-bounce/20210727-224549
> base:
> https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git
> master config: s390-randconfig-r034-20210727 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project
> c658b472f3e61e1818e1909bf02f3d65470018a5) reproduce (this is a W=1
> build): wget
> https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross
> -O ~/bin/make.cross chmod +x ~/bin/make.cross # install s390 cross
> compiling tool for clang build # apt-get install
> binutils-s390x-linux-gnu #
> https://github.com/0day-ci/linux/commit/0d1cb044926e3d81c86b5add2eeaf38c7aec7f90
> git remote add linux-review https://github.com/0day-ci/linux git
> fetch --no-tags linux-review
> Pavel-Skripkin/net-xfrm-fix-shift-out-of-bounce/20210727-224549 git
> checkout 0d1cb044926e3d81c86b5add2eeaf38c7aec7f90 # save the attached
> .config to linux build tree mkdir build_dir
> COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross
> O=build_dir ARCH=s390 SHELL=/bin/bash net/xfrm/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from net/xfrm/xfrm_user.c:22:
>    In file included from include/linux/skbuff.h:31:
>    In file included from include/linux/dma-mapping.h:10:
>    In file included from include/linux/scatterlist.h:9:
>    In file included from arch/s390/include/asm/io.h:75:
>    include/asm-generic/io.h:464:31: warning: performing pointer
> arithmetic on a null pointer has undefined behavior
> [-Wnull-pointer-arithmetic] val = __raw_readb(PCI_IOBASE + addr);
> ~~~~~~~~~~ ^ include/asm-generic/io.h:477:61: warning: performing
> pointer arithmetic on a null pointer has undefined behavior
> [-Wnull-pointer-arithmetic] val = __le16_to_cpu((__le16
> __force)__raw_readw(PCI_IOBASE + addr)); ~~~~~~~~~~ ^
> include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from
> macro '__le16_to_cpu' #define __le16_to_cpu(x) __swab16((__force
> __u16)(__le16)(x)) ^ include/uapi/linux/swab.h:102:54: note: expanded
> from macro '__swab16' #define __swab16(x)
> (__u16)__builtin_bswap16((__u16)(x)) ^
>    In file included from net/xfrm/xfrm_user.c:22:
>    In file included from include/linux/skbuff.h:31:
>    In file included from include/linux/dma-mapping.h:10:
>    In file included from include/linux/scatterlist.h:9:
>    In file included from arch/s390/include/asm/io.h:75:
>    include/asm-generic/io.h:490:61: warning: performing pointer
> arithmetic on a null pointer has undefined behavior
> [-Wnull-pointer-arithmetic] val = __le32_to_cpu((__le32
> __force)__raw_readl(PCI_IOBASE + addr)); ~~~~~~~~~~ ^
> include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from
> macro '__le32_to_cpu' #define __le32_to_cpu(x) __swab32((__force
> __u32)(__le32)(x)) ^ include/uapi/linux/swab.h:115:54: note: expanded
> from macro '__swab32' #define __swab32(x)
> (__u32)__builtin_bswap32((__u32)(x)) ^
>    In file included from net/xfrm/xfrm_user.c:22:
>    In file included from include/linux/skbuff.h:31:
>    In file included from include/linux/dma-mapping.h:10:
>    In file included from include/linux/scatterlist.h:9:
>    In file included from arch/s390/include/asm/io.h:75:
>    include/asm-generic/io.h:501:33: warning: performing pointer
> arithmetic on a null pointer has undefined behavior
> [-Wnull-pointer-arithmetic] __raw_writeb(value, PCI_IOBASE + addr);
> ~~~~~~~~~~ ^ include/asm-generic/io.h:511:59: warning: performing
> pointer arithmetic on a null pointer has undefined behavior
> [-Wnull-pointer-arithmetic] __raw_writew((u16
> __force)cpu_to_le16(value), PCI_IOBASE + addr); ~~~~~~~~~~ ^
> include/asm-generic/io.h:521:59: warning: performing pointer
> arithmetic on a null pointer has undefined behavior
> [-Wnull-pointer-arithmetic] __raw_writel((u32
> __force)cpu_to_le32(value), PCI_IOBASE + addr); ~~~~~~~~~~ ^
> include/asm-generic/io.h:609:20: warning: performing pointer
> arithmetic on a null pointer has undefined behavior
> [-Wnull-pointer-arithmetic] readsb(PCI_IOBASE + addr, buffer, count);
> ~~~~~~~~~~ ^ include/asm-generic/io.h:617:20: warning: performing
> pointer arithmetic on a null pointer has undefined behavior
> [-Wnull-pointer-arithmetic] readsw(PCI_IOBASE + addr, buffer, count);
> ~~~~~~~~~~ ^ include/asm-generic/io.h:625:20: warning: performing
> pointer arithmetic on a null pointer has undefined behavior
> [-Wnull-pointer-arithmetic] readsl(PCI_IOBASE + addr, buffer, count);
> ~~~~~~~~~~ ^ include/asm-generic/io.h:634:21: warning: performing
> pointer arithmetic on a null pointer has undefined behavior
> [-Wnull-pointer-arithmetic] writesb(PCI_IOBASE + addr, buffer,
> count); ~~~~~~~~~~ ^ include/asm-generic/io.h:643:21: warning:
> performing pointer arithmetic on a null pointer has undefined
> behavior [-Wnull-pointer-arithmetic] writesw(PCI_IOBASE + addr,
> buffer, count); ~~~~~~~~~~ ^ include/asm-generic/io.h:652:21:
> warning: performing pointer arithmetic on a null pointer has
> undefined behavior [-Wnull-pointer-arithmetic] writesl(PCI_IOBASE +
> addr, buffer, count); ~~~~~~~~~~ ^
> >> net/xfrm/xfrm_user.c:1975:54: error: expected ';' after expression
>            dirmask = (1 << up->dirmask) & XFRM_POL_DEFAULT_MASK
>                                                                ^
>                                                                ;

Oops :) Thank you, kernel test robot.

#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master


With regards,
Pavel Skripkin



--MP_/w+5mWJ0hzkLOGrIDgVYQu8r
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-net-xfrm-fix-shift-out-of-bounce.patch

From e7cf3838979bf3079a511b6809e971945f50eb25 Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Tue, 27 Jul 2021 17:38:24 +0300
Subject: [PATCH] net: xfrm: fix shift-out-of-bounce

We need to check up->dirmask to avoid shift-out-of-bounce bug,
since up->dirmask comes from userspace.

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/xfrm/xfrm_user.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index acc3a0dab331..4a7bb169314e 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1966,9 +1966,14 @@ static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_default *up = nlmsg_data(nlh);
-	u8 dirmask = (1 << up->dirmask) & XFRM_POL_DEFAULT_MASK;
+	u8 dirmask;
 	u8 old_default = net->xfrm.policy_default;
 
+	if (up->dirmask >= sizeof(up->action) * 8)
+		return -EINVAL;
+
+	dirmask = (1 << up->dirmask) & XFRM_POL_DEFAULT_MASK;
+
 	net->xfrm.policy_default = (old_default & (0xff ^ dirmask))
 				    | (up->action << up->dirmask);
 
-- 
2.32.0


--MP_/w+5mWJ0hzkLOGrIDgVYQu8r--
