Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F5F4543ED
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 10:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235487AbhKQJmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 04:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235497AbhKQJl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 04:41:59 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5181FC061746
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 01:38:41 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id d5so3424789wrc.1
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 01:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q2rKwboKgAw3nRRaCfD7SefQvnMKY/KTAzFoQdfeqaU=;
        b=OO+6saCBlkO2KPQ5TxJjjigN9pHFCb8KDGZLaabpCFOYooTI+01Q2Im1MhLUXoBdFf
         bf7Xriu1UCJR+ymitnwQ8BtJGDrCh5vctFZNgeZft0mEQWSEvd1ChSg9RSRKt6gcf4E/
         IUL26Mn07+nVzUa3WLIgKVGk46tzsogB5zCVtFOidR7Tve7jLK40HYN5Ty7TpPxhhvUk
         4FK55sgUkzOs02YZRMVUcRAEmoxqp5tQLPjTVRZacct8DEVC3BO/+e2i6qD1W/nK1AOy
         ztaZq/NmhNGtmIzkae4XkVqufVUaQRRd2TlVuaV6mqUZX7TGOrkYBSZNfFimRAQyWIGo
         /Uog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q2rKwboKgAw3nRRaCfD7SefQvnMKY/KTAzFoQdfeqaU=;
        b=XA/MqOGtdT6S8FurhjwR5KWKdppprethtPcdBtBkVYc0e2Z8YIsNkD44AGl1cbhNYL
         s8qcT89OtBHekXPOgomPnq07SrKLwiKOeZCtgkOlOmB5ugG9INAJZNF8+KNOwxiOu/PO
         cfv9Mwf+sWdsK0I45RjpabgTi6BxNWa1UmAo5uOI1EuzENTvUwmpPmgSbiOYqUPQv9YD
         6tt0OtR/RFbSHcDAyJaxCMqPxxvawTzKKJP5ZmbIjNaHWg56omeaprn8RD086vqi2RbE
         luejcXJ4Oj/iwYbLZ8ZsgT4pLtF5kKR/ot0mughxoNjSqmcqDRtLWWHctleK1iy9DxKI
         emog==
X-Gm-Message-State: AOAM5324f0I16P8ZFvWZEWXgkq0/SLiWWQQLCmyNGQEBhyImMRdCMj4t
        apT+QU6dZnzCHwchBXqt4FF54fb+R7qaFYSHJ1wAxQ==
X-Google-Smtp-Source: ABdhPJygAy0isU1aGl66wBzprRc9u7qmQ4gQiO3MTlAlwKzYcPAZgC5J2vn32NzEw2fj+ggFTr8dkuvXrxV5nCddxBE=
X-Received: by 2002:adf:e387:: with SMTP id e7mr18490666wrm.412.1637141919407;
 Wed, 17 Nov 2021 01:38:39 -0800 (PST)
MIME-Version: 1.0
References: <20211117135800.0b7072cd@canb.auug.org.au> <268ae204-efae-3081-a5dd-44fc07d048ba@infradead.org>
 <CAMuHMdUdA6cJkWWKypvn7nGQw+u=gW_oRNWB-=G8g2T3VixJFQ@mail.gmail.com>
In-Reply-To: <CAMuHMdUdA6cJkWWKypvn7nGQw+u=gW_oRNWB-=G8g2T3VixJFQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 17 Nov 2021 01:38:27 -0800
Message-ID: <CANn89iLXQWR_F6v39guPftY=jhs4XHsERifhZPOTjR3zDNkJyg@mail.gmail.com>
Subject: Re: linux-next: Tree for Nov 17 (uml, no IPV6)
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 12:44 AM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> Hi Randy,
>
> On Wed, Nov 17, 2021 at 6:49 AM Randy Dunlap <rdunlap@infradead.org> wrot=
e:
> > On 11/16/21 6:58 PM, Stephen Rothwell wrote:
> > > Changes since 20211116:
> >
> > ARCH=3Dum SUBARCH=3Dx86_64:
> > # CONFIG_IPV6 is not set
>
> It doesn't always happen with CONFIG_IPV6=3Dn, so I guess that's why
> it wasn't detected before.

Thanks for letting me know

I guess the following addition would fix the issue ?

diff --git a/arch/x86/um/asm/checksum_64.h b/arch/x86/um/asm/checksum_64.h
index 7b6cd1921573c97361b8d486bbba3e8870d53ad6..4f0c15a61925c46b261f87fa319=
e6aff28f4cfce
100644
--- a/arch/x86/um/asm/checksum_64.h
+++ b/arch/x86/um/asm/checksum_64.h
@@ -14,6 +14,30 @@ static inline unsigned add32_with_carry(unsigned a,
unsigned b)
         return a;
 }

+#define _HAVE_ARCH_IPV6_CSUM
+static inline __sum16
+csum_ipv6_magic(const struct in6_addr *saddr,
+               const struct in6_addr *daddr,
+               __u32 len, __u8 proto, __wsum sum)
+{
+       __u64 rest, sum64;
+
+       rest =3D (__force __u64)htonl(len) + (__force __u64)htons(proto) +
+               (__force __u64)sum;
+
+       asm("   addq (%[saddr]),%[sum]\n"
+           "   adcq 8(%[saddr]),%[sum]\n"
+           "   adcq (%[daddr]),%[sum]\n"
+           "   adcq 8(%[daddr]),%[sum]\n"
+           "   adcq $0,%[sum]\n"
+
+           : [sum] "=3Dr" (sum64)
+           : "[sum]" (rest), [saddr] "r" (saddr), [daddr] "r" (daddr));
+
+       return csum_fold(
+              (__force __wsum)add32_with_carry(sum64 & 0xffffffff, sum64>>=
32));
+}
+
 extern __sum16 ip_compute_csum(const void *buff, int len);

 #endif


>
> > In file included from ../net/ethernet/eth.c:62:0:
> > ../include/net/gro.h: In function =E2=80=98ip6_gro_compute_pseudo=E2=80=
=99:
> > ../include/net/gro.h:413:22: error: implicit declaration of function =
=E2=80=98csum_ipv6_magic=E2=80=99; did you mean =E2=80=98csum_tcpudp_magic=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]
> >    return ~csum_unfold(csum_ipv6_magic(&iph->saddr, &iph->daddr,
> >                        ^~~~~~~~~~~~~~~
> >                        csum_tcpudp_magic
> >
> >
> > After I made ip6_gro_compute_pseudo() conditional on CONFIG_IPV6,
> > I got this build error:
> >
> > In file included from ../net/ipv6/tcpv6_offload.c:10:0:
> > ../net/ipv6/tcpv6_offload.c: In function =E2=80=98tcp6_gro_receive=E2=
=80=99:
> > ../net/ipv6/tcpv6_offload.c:22:11: error: implicit declaration of funct=
ion =E2=80=98ip6_gro_compute_pseudo=E2=80=99; did you mean =E2=80=98inet_gr=
o_compute_pseudo=E2=80=99? [-Werror=3Dimplicit-function-declaration]
> >             ip6_gro_compute_pseudo)) {
> >             ^
> > ../include/net/gro.h:235:5: note: in definition of macro =E2=80=98__skb=
_gro_checksum_validate=E2=80=99
> >       compute_pseudo(skb, proto));  \
> >       ^~~~~~~~~~~~~~
> > ../net/ipv6/tcpv6_offload.c:21:6: note: in expansion of macro =E2=80=98=
skb_gro_checksum_validate=E2=80=99
> >        skb_gro_checksum_validate(skb, IPPROTO_TCP,
> >        ^~~~~~~~~~~~~~~~~~~~~~~~~
> >
> >
> >
> > This is UML x86_64 defconfig:
> >
> > $ make ARCH=3Dum SUBARCH=3Dx86_64 defconfig all
>
> noreply@ellerman.id.au reported the same issue for m5272c3_defconfig,
> and I've bisected the failure to commit 4721031c3559db8e ("net:
> move gro definitions to include/net/gro.h").
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org
>
> In personal conversations with technical people, I call myself a hacker. =
But
> when I'm talking to journalists I just say "programmer" or something like=
 that.
>                                 -- Linus Torvalds
