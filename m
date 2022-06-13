Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5577254826D
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 10:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240356AbiFMIyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 04:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240716AbiFMIxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 04:53:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3305FF7;
        Mon, 13 Jun 2022 01:53:47 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 229AE21ABC;
        Mon, 13 Jun 2022 08:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655110426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+b4LT3xPTRW/dQ/mepnuYj9rWjiXM198baJsJGnsgOM=;
        b=Pr8t0e6gDUCHZT61ZzMzfLGEmfZEVNv75Jwznn3nfx5sGzrE5YlDyVrqMTqymogDf96Ej4
        09e7vdpknuZgxsqO4aifChvvDSDdaivsiIh7GRuTYzS3rq7TB4hxQpNUUpiF6OoWoNzdou
        wVX/v9RHweIqoC4Tf7/lS7dEkoOWDts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655110426;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+b4LT3xPTRW/dQ/mepnuYj9rWjiXM198baJsJGnsgOM=;
        b=qDM3E2M2KMhXDlcZ3whqqeNinFtpdP5WkWoD8Nd+Klu49E/yD7MrWa8u54+l4xgm8hkhTk
        AtVCto9/lL6TepCg==
Received: from [10.168.4.8] (unknown [10.168.4.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0425C2C141;
        Mon, 13 Jun 2022 08:53:44 +0000 (UTC)
Date:   Mon, 13 Jun 2022 10:53:44 +0200 (CEST)
From:   Richard Biener <rguenther@suse.de>
To:     =?ISO-8859-2?Q?Mateusz_Jo=F1czyk?= <mat.jonczyk@o2.pl>
cc:     Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        linux-rdma@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: Linux kernel: "mm: uninline copy_overflow()" breaks i386 build
 in Mellanox MLX4
In-Reply-To: <9cec2686-c2dc-2750-7e07-42e450ab6081@o2.pl>
Message-ID: <158898q2-nn8q-q31r-412s-no7475r53qp7@fhfr.qr>
References: <dbd203b1-3988-4c9c-909c-2d1f7f173a0d@o2.pl> <20220425231305.GY64706@ziepe.ca> <9cec2686-c2dc-2750-7e07-42e450ab6081@o2.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1609908220-854494629-1655110426=:3672"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1609908220-854494629-1655110426=:3672
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 9 Jun 2022, Mateusz Jończyk wrote:

> W dniu 26.04.2022 o 01:13, Jason Gunthorpe pisze:
> > On Thu, Apr 21, 2022 at 10:47:01PM +0200, Mateusz Jończyk wrote:
> >> Hello,
> >>
> >> commit ad7489d5262d ("mm: uninline copy_overflow()")
> >>
> >> breaks for me a build for i386 in the Mellanox MLX4 driver:
> >>
> >>         In file included from ./arch/x86/include/asm/preempt.h:7,
> >>                          from ./include/linux/preempt.h:78,
> >>                          from ./include/linux/percpu.h:6,
> >>                          from ./include/linux/context_tracking_state.h:5,
> >>                          from ./include/linux/hardirq.h:5,
> >>                          from drivers/net/ethernet/mellanox/mlx4/cq.c:37:
> >>         In function ‘check_copy_size’,
> >>             inlined from ‘copy_to_user’ at ./include/linux/uaccess.h:159:6,
> >>             inlined from ‘mlx4_init_user_cqes’ at drivers/net/ethernet/mellanox/mlx4/cq.c:317:9,
> >>             inlined from ‘mlx4_cq_alloc’ at drivers/net/ethernet/mellanox/mlx4/cq.c:394:10:
> >>         ./include/linux/thread_info.h:228:4: error: call to ‘__bad_copy_from’ declared with attribute error: copy source size is too small
> >>           228 |    __bad_copy_from();
> >>               |    ^~~~~~~~~~~~~~~~~
> >>         make[5]: *** [scripts/Makefile.build:288: drivers/net/ethernet/mellanox/mlx4/cq.o] Błąd 1
> >>         make[4]: *** [scripts/Makefile.build:550: drivers/net/ethernet/mellanox/mlx4] Błąd 2
> >>         make[3]: *** [scripts/Makefile.build:550: drivers/net/ethernet/mellanox] Błąd 2
> >>         make[2]: *** [scripts/Makefile.build:550: drivers/net/ethernet] Błąd 2
> >>         make[1]: *** [scripts/Makefile.build:550: drivers/net] Błąd 2
> >>
> >> Reverting this commit fixes the build. Disabling Mellanox Ethernet drivers
> >> in Kconfig (tested only with also disabling of all Infiniband support) also fixes the build.
> >>
> >> It appears that uninlining of copy_overflow() causes GCC to analyze the code deeper.
> > This looks like a compiler bug to me, array_size(entries, cqe_size)
> > cannot be known at compile time, so the __builtin_constant_p(bytes)
> > should be compile time false meaning the other two bad branches should
> > have been eliminated.
> >
> > Jason
> 
> Hello,
> 
> This problem also exists in Linux v5.19-rc1. Compiling with GCC 8 and GCC 9 fails,
> but with GCC10 it compiles successfully.
> 
> I have extracted a standalone code snippet that triggers this bug, attaching
> it at the bottom of this e-mail.
> 
> This indeed looks like a compiler bug for me, as cqe_size cannot be known at compile
> time. What is interesting, replacing
> 
>         err = copy_to_user2((void  *)buf, init_ents,
>                                 size_mul2(4096, cqe_size)) ? -14 : 0;
> 
> with
> 
>         err = copy_to_user2((void  *)buf, init_ents,
>                                 4096 * cqe_size) ? -14 : 0;
> 
> makes the code compile successfully.
> 
> I have bisected GCC to find which commit in GCC fixes this problem and
> obtained this:
> 
>         46dfa8ad6c18feb45d35734eae38798edb7c38cd is the first fixed commit
>         commit 46dfa8ad6c18feb45d35734eae38798edb7c38cd
>         Author: Richard Biener <rguenther@suse.de>
>         Date:   Wed Sep 11 11:16:54 2019 +0000
> 
>             re PR tree-optimization/90387 (__builtin_constant_p and -Warray-bounds warnings)
> 
>             2019-09-11  Richard Biener  <rguenther@suse.de>
> 
>                     PR tree-optimization/90387
>                     * vr-values.c (vr_values::extract_range_basic): After inlining
>                     simplify non-constant __builtin_constant_p to false.
> 
>                     * gcc.dg/Warray-bounds-44.c: New testcase.
> 
>             From-SVN: r275639
> 
>          gcc/ChangeLog                           |  6 ++++++
>          gcc/testsuite/ChangeLog                 |  5 +++++
>          gcc/testsuite/gcc.dg/Warray-bounds-44.c | 23 +++++++++++++++++++++++
>          gcc/vr-values.c                         | 11 ++---------
>          4 files changed, 36 insertions(+), 9 deletions(-)
>          create mode 100644 gcc/testsuite/gcc.dg/Warray-bounds-44.c
> 
> Applying this patch on top of releases/gcc-9.5.0 fixes the build (of the attached snippet and of
> drivers/net/ethernet/mellanox/mlx4/cq.c ).
> 
> Ccing Mr Richard Biener, as he is the author of this patch.

Note the patch simply avoids some instances of path isolation with
__builtin_constant_p by committing to constant/non-constant earlier.

Think of

 for (i = 0; i < n; ++i)
   if (__builtin_constant_p (i)) foo (); else bar ();

and GCC peeling the first iteration - then to GCC i is constant zero
in this first iteration but the remaining iterations will have i
non-constant.

The semantics of __builtin_constant_p are not strongly enough
defined to say whether that's "correct" or not given the
documentation suggests it is evaluated after optimization
(inlining given as example).

Richard.

> I'm on Ubuntu 20.04, which ships with gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1).
> It was with this compiler version that I have found the problem.
> 
> It looks unlikely that GCC in Ubuntu 20.04 will be updated meaningfully.
> Would a following workaround for Linux be acceptable?
> 
> ====================
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
> index 4d4f9cf9facb..a40701859721 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/cq.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
> @@ -314,8 +314,11 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
>                         buf += PAGE_SIZE;
>                 }
>         } else {
> +                /* Don't use array_size() as this triggers a bug in GCC < 10
> +                 * for i386. (entries * cqe_size) is guaranteed to be small.
> +                 */
>                 err = copy_to_user((void __user *)buf, init_ents,
> -                                  array_size(entries, cqe_size)) ?
> +                                  entries * cqe_size) ?
>                         -EFAULT : 0;
>         }
> 
> ====================
> 
> Greetings,
> 
> Mateusz Jończyk
> 
> --------------------------------------------------
> 
> /* Compile with
>  * gcc -Wall -std=gnu11 -m32 -march=i686 -O2 -c -o bugtrigger.o bugtrigger.c
>  */
> 
> #include <stddef.h>
> #include <stdbool.h>
> #include <stdint.h>
> 
> void *__kmalloc2(size_t size) __attribute__((alloc_size(1)));
> extern unsigned long
> _copy_to_user(void *, const void *, unsigned long);
> 
> extern void __attribute__((__error__("copy source size is too small")))
> __bad_copy_from2(void);
> extern void __attribute__((__error__("copy destination size is too small")))
> __bad_copy_to2(void);
> 
> void copy_overflow2(int size, unsigned long count);
> 
> static bool
> check_copy_size2(const void *addr, size_t bytes, bool is_source)
> {
>     int sz = __builtin_object_size(addr, 0);
>     if (sz >= 0 && sz < bytes) {
>         if (!__builtin_constant_p(bytes))
>             copy_overflow2(sz, bytes);
>         else if (is_source)
>             __bad_copy_from2();
>         else
>             __bad_copy_to2();
>         return false;
>     }
>     return true;
> }
> 
> static unsigned long
> copy_to_user2(void *to, const void *from, unsigned long n)
> {
>     if (check_copy_size2(from, n, true))
>         n = _copy_to_user(to, from, n);
>     return n;
> }
> 
> static inline size_t size_mul2(size_t factor1, size_t factor2)
> {
>     size_t bytes;
>     if (__builtin_mul_overflow(factor1, factor2, &bytes))
>         return SIZE_MAX;
> 
>     return bytes;
> }
> 
> int foobar(void *buf, int cqe_size)
> {
>         int err;
>         void *init_ents = __kmalloc2(4096);
>         err = copy_to_user2((void  *)buf, init_ents,
>                                 size_mul2(4096, cqe_size)) ? -14 : 0;
> 
>     return err;
> }
> 
> 

-- 
Richard Biener <rguenther@suse.de>
SUSE Software Solutions Germany GmbH, Frankenstraße 146, 90461 Nuernberg,
Germany; GF: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman;
HRB 36809 (AG Nuernberg)
---1609908220-854494629-1655110426=:3672--
