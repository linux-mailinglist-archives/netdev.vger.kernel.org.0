Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1794B326D
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 02:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243831AbiBLBb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 20:31:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242868AbiBLBb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 20:31:28 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A86C7C
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 17:31:24 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id t14-20020a17090a3e4e00b001b8f6032d96so10389144pjm.2
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 17:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Sf+D83VFteubkIWWnQK6iBRTei26KbE7lUHObftFxtI=;
        b=e6PY6smXNMv+C6/yHJwfQcGHU7R691GXDIwJVs1Qjr/oOgtnHWabWrynWOfSPAKiqA
         lBbl8ozLekS7tJ5vyAQjhwhPXldRDqdhisKhUfYY+JTq+iKorhCkqHCnJxR0Bvt8CyzH
         ayvXAMn8eihCZApI4801/8kBxGfFzDQEJHV0A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Sf+D83VFteubkIWWnQK6iBRTei26KbE7lUHObftFxtI=;
        b=cyNwPeo6cgJhtyEqvYuRLPuR27mmMOSafN4vTwByTjwajN8p7e2JRjuhnb6ZWqLfjf
         wzr01ROt9Z/6GF9ZoMPM5gb6EcC3QDlMWZUEY1tMw+X/a8tpkbVQeUfrQmIaDIFcl7rF
         4pnLUW1APCg3YUrFFP+ThN2fPkZfkxcu9mlC7YlqmsZg6sr0xJYDJ9j8VGe0E5pBh2Kd
         0JeB57ScAvTlSZGho4aE1f2ab5vppdNuahVo5ppOOBUyv2ersx1GPJp1phibHE1M87Dv
         L3yRI5EK9C1Up+zqlY2GpsKkAzOIlUDH9XJnylmHVNDL2sdMZOBrmKXLaaC1bvH2cRG9
         fyHA==
X-Gm-Message-State: AOAM532QzdQ0/mki10/V4X25rGMXzLtkg0cz6IK9AOiUf+JMr8u/CNXr
        TMuUiNXAaL2G13Hl1++M+UF6qw==
X-Google-Smtp-Source: ABdhPJzbxpARNA+LnQJYj96ZGe/+xnYqo2gSwndkUZGJsra0t21eMM65eRWrUfEe0J8ZEtjItOzk1g==
X-Received: by 2002:a17:902:ec82:: with SMTP id x2mr4113599plg.63.1644629484308;
        Fri, 11 Feb 2022 17:31:24 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h10sm29528294pfc.103.2022.02.11.17.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 17:31:23 -0800 (PST)
Date:   Fri, 11 Feb 2022 17:31:22 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: ether_addr_equal_64bits breakage with gcc-12
Message-ID: <202202111642.EF22DF8BD@keescook>
References: <20220211141213.l4yitk7aifehjymp@pengutronix.de>
 <20220211163541.74b0836a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220211163541.74b0836a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 04:35:41PM -0800, Jakub Kicinski wrote:
> On Fri, 11 Feb 2022 15:12:13 +0100 Marc Kleine-Budde wrote:
> > Hello,
> >=20
> > the current arm-linux-gnueabihf-gcc 12 snapshot in Debian breaks (at
> > least with CONFIG_WERROR=3Dy):
> >=20
> > |   CC      net/core/dev.o
> > | net/core/dev.c: In function =E2=80=98bpf_prog_run_generic_xdp=E2=80=
=99:
> > | net/core/dev.c:4618:21: warning: =E2=80=98ether_addr_equal_64bits=E2=
=80=99 reading 8 bytes from a region of size 6 [-Wstringop-overread]
> > |  4618 |         orig_host =3D ether_addr_equal_64bits(eth->h_dest, sk=
b->dev->dev_addr);
> > |       |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~
> > | net/core/dev.c:4618:21: note: referencing argument 1 of type =E2=80=
=98const u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
> > | net/core/dev.c:4618:21: note: referencing argument 2 of type =E2=80=
=98const u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
> > | In file included from net/core/dev.c:91:
> > | include/linux/etherdevice.h:375:20: note: in a call to function =E2=
=80=98ether_addr_equal_64bits=E2=80=99
> > |   375 | static inline bool ether_addr_equal_64bits(const u8 addr1[6+2=
],
> > |       |                    ^~~~~~~~~~~~~~~~~~~~~~~
> > | net/core/dev.c:4619:22: warning: =E2=80=98is_multicast_ether_addr_64b=
its=E2=80=99 reading 8 bytes from a region of size 6 [-Wstringop-overread]
> > |  4619 |         orig_bcast =3D is_multicast_ether_addr_64bits(eth->h_=
dest);
> > |       |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~
> > | net/core/dev.c:4619:22: note: referencing argument 1 of type =E2=80=
=98const u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
> > | include/linux/etherdevice.h:137:20: note: in a call to function =E2=
=80=98is_multicast_ether_addr_64bits=E2=80=99
> > |   137 | static inline bool is_multicast_ether_addr_64bits(const u8 ad=
dr[6+2])
> > |       |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > | net/core/dev.c:4646:27: warning: =E2=80=98ether_addr_equal_64bits=E2=
=80=99 reading 8 bytes from a region of size 6 [-Wstringop-overread]
> > |  4646 |             (orig_host !=3D ether_addr_equal_64bits(eth->h_de=
st,
> > |       |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > |  4647 |                                                   skb->dev->d=
ev_addr)) ||
> > |       |                                                   ~~~~~~~~~~~=
~~~~~~~~
> > | net/core/dev.c:4646:27: note: referencing argument 1 of type =E2=80=
=98const u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
> > | net/core/dev.c:4646:27: note: referencing argument 2 of type =E2=80=
=98const u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
> > | include/linux/etherdevice.h:375:20: note: in a call to function =E2=
=80=98ether_addr_equal_64bits=E2=80=99
> > |   375 | static inline bool ether_addr_equal_64bits(const u8 addr1[6+2=
],
> > |       |                    ^~~~~~~~~~~~~~~~~~~~~~~
> > | net/core/dev.c:4648:28: warning: =E2=80=98is_multicast_ether_addr_64b=
its=E2=80=99 reading 8 bytes from a region of size 6 [-Wstringop-overread]
> > |  4648 |             (orig_bcast !=3D is_multicast_ether_addr_64bits(e=
th->h_dest))) {
> > |       |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~
> > | net/core/dev.c:4648:28: note: referencing argument 1 of type =E2=80=
=98const u8[8]=E2=80=99 {aka =E2=80=98const unsigned char[8]=E2=80=99}
> > | include/linux/etherdevice.h:137:20: note: in a call to function =E2=
=80=98is_multicast_ether_addr_64bits=E2=80=99
> > |   137 | static inline bool is_multicast_ether_addr_64bits(const u8 ad=
dr[6+2])
> > |       |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >=20
> > | arm-linux-gnueabihf-gcc -v
> > | Using built-in specs.
> > | COLLECT_GCC=3D/usr/bin/arm-linux-gnueabihf-gcc
> > | COLLECT_LTO_WRAPPER=3D/usr/lib/gcc-cross/arm-linux-gnueabihf/12/lto-w=
rapper
> > | Target: arm-linux-gnueabihf
> > | Configured with: ../src/configure -v --with-pkgversion=3D'Debian 12-2=
0220126-1' --with-bugurl=3Dfile:///usr/share/doc/gcc-12/README.Bugs --enabl=
e-languages=3Dc,ada,c++,go,d,fortran,objc,obj-c++,m2 --prefix=3D/usr --with=
-gcc-major-version-only --program-suffix=3D-12 --enable-shared --enable-lin=
ker-build-id --libexecdir=3D/usr/lib --without-included-gettext --enable-th=
reads=3Dposix --libdir=3D/usr/lib --enable-nls --with-sysroot=3D/ --enable-=
clocale=3Dgnu --enable-libstdcxx-debug --enable-libstdcxx-time=3Dyes --with=
-default-libstdcxx-abi=3Dnew --enable-gnu-unique-object --disable-libitm --=
disable-libquadmath --disable-libquadmath-support --enable-plugin --enable-=
default-pie --with-system-zlib --enable-libphobos-checking=3Drelease --with=
out-target-system-zlib --enable-multiarch --disable-sjlj-exceptions --with-=
arch=3Darmv7-a+fp --with-float=3Dhard --with-mode=3Dthumb --disable-werror =
--enable-checking=3Drelease --build=3Dx86_64-linux-gnu --host=3Dx86_64-linu=
x-gnu --target=3Darm-linux-gnueabihf --program-prefix=3Darm-linux-gnueabihf=
- --includedir=3D/usr/arm-linux-gnueabihf/include
> > | Thread model: posix
> > | Supported LTO compression algorithms: zlib zstd
> > | gcc version 12.0.1 20220126 (experimental) [master r12-6872-gf3e6ef7d=
873] (Debian 12-20220126-1)
>=20
> Maybe Kees will have as suggestion - Kees, are there any best practices
> for dealing with such issues? For the reference we do a oversized load
> from a structure (read 8B of a 6B array):

Wheee.

So, the short theoretical "don't do that" scenario would be "what
happens if":

        struct page *page;
        void *ptr;
	unsigned char *eth_addr;

        page =3D alloc_pages(GFP_KERNEL, 0);
	...
        ptr =3D page_address(page);
	...
	/* "eth_addr" at end of allocated memory */
	eth_addr =3D ptr + PAGE_SIZE - 6;
	/* access fault... */
	ether_addr_equal_64bits(eth_addr, ...);

But, yes, pragmatically, this is likely extremely rare.

Regardless, with the other cases like this that got fixed like this, it
was a matter of finding a way to represent the "actual" available memory
(best), or telling the compiler what real contract is (less good).

It looks like alignment isn't a concern, so I'd say adjust the prototype
to reflect the reality, and go with:


diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 2ad71cc90b37..92b10e67d5f8 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -134,7 +134,7 @@ static inline bool is_multicast_ether_addr(const u8 *ad=
dr)
 #endif
 }
=20
-static inline bool is_multicast_ether_addr_64bits(const u8 addr[6+2])
+static inline bool is_multicast_ether_addr_64bits(const u8 *addr)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG =3D=
=3D 64
 #ifdef __BIG_ENDIAN
@@ -372,8 +372,7 @@ static inline bool ether_addr_equal(const u8 *addr1, co=
nst u8 *addr2)
  * Please note that alignment of addr1 & addr2 are only guaranteed to be 1=
6 bits.
  */
=20
-static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
-					   const u8 addr2[6+2])
+static inline bool ether_addr_equal_64bits(const u8 *addr1, const u8 *addr=
2)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG =3D=
=3D 64
 	u64 fold =3D (*(const u64 *)addr1) ^ (*(const u64 *)addr2);


--=20
Kees Cook
