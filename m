Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39674133D82
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 09:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgAHIo7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jan 2020 03:44:59 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:52877 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgAHIo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 03:44:58 -0500
Received: from mail-qk1-f182.google.com ([209.85.222.182]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MfHMj-1jMEiy0Wjr-00gm0v; Wed, 08 Jan 2020 09:44:55 +0100
Received: by mail-qk1-f182.google.com with SMTP id a203so1957447qkc.3;
        Wed, 08 Jan 2020 00:44:54 -0800 (PST)
X-Gm-Message-State: APjAAAX/HqfzxlmtV4x1U/fKGxAmv9rT/vfSvMM8DmSA2x3G6g5atz9c
        FEdHLPGupeYZbVYLaoyimUSYpqqYMug0lHm0vUo=
X-Google-Smtp-Source: APXvYqwBkJ8QmnIL+nEzdyW4cVb2dCgT1+bxTVHrv/QXRUdjO9mWLnIecKxCrEVE9XkgL278ZPmA2bqFRRwBDXNH4F8=
X-Received: by 2002:a05:620a:a5b:: with SMTP id j27mr3333439qka.286.1578473093254;
 Wed, 08 Jan 2020 00:44:53 -0800 (PST)
MIME-Version: 1.0
References: <1578415992-24054-1-git-send-email-krzk@kernel.org>
 <CAMuHMdW4ek0OYQDrrbcpZjNUTTP04nSbwkmiZvBmKcU=PQM9qA@mail.gmail.com>
 <CAMuHMdUBmYtJKtSYzS_5u67hVZOqcKSgFY1rDGme6gLNRBJ_gA@mail.gmail.com>
 <CAJKOXPfq9vS4kSyx1jOPHBvi9_HjviRv0LU2A8ZwdmqgUuebHQ@mail.gmail.com> <2355489c-a207-1927-54cf-85c04b62f18f@c-s.fr>
In-Reply-To: <2355489c-a207-1927-54cf-85c04b62f18f@c-s.fr>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 8 Jan 2020 09:44:36 +0100
X-Gmail-Original-Message-ID: <CAK8P3a21yPrmp4ik3Ei1BZfeqZNf0wL5NZNF3uXqb4FLRDyUPw@mail.gmail.com>
Message-ID: <CAK8P3a21yPrmp4ik3Ei1BZfeqZNf0wL5NZNF3uXqb4FLRDyUPw@mail.gmail.com>
Subject: Re: [RFT 00/13] iomap: Constify ioreadX() iomem argument
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rich Felker <dalias@libc.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jason Wang <jasowang@redhat.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        virtualization@lists.linux-foundation.org,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        netdev <netdev@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Helge Deller <deller@gmx.de>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        ML nouveau <nouveau@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>,
        Matt Turner <mattst88@gmail.com>,
        arcml <linux-snps-arc@lists.infradead.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Allen Hubbe <allenbh@gmail.com>,
        alpha <linux-alpha@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Richard Henderson <rth@twiddle.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>, Jon Mason <jdmason@kudzu.us>,
        linux-ntb@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:QwaGXiRich5wImpYp8FQnHgp5kz2EKPSRExzga2LIzGLBfSa0WJ
 YnmgjVSYdk7STyuVgrutKdQc7aoKqByAaVnwi68AgQg3IFWh04Gh6pqjpKwH3m7wy2iRCA1
 PvzHznSMskO2L/HVIAkGLVZhQ2nbXsMe5JX3qhXYDTaGmuCa8roKlNaJ8gtk4H96Hm0BIPI
 zBw/C+qVbQbtL0MIhk1oQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UcFnSV1veRY=:yAYfQVlOazrC0OSa/xZ2Nn
 yp42v9FkRaF2KA4UJ3hjLCp/g9EzGQLUUTq//7jvX8/1CNRrXY8VT91084KTIyxk5Vs+EPryg
 aj2xlfhVVGolkKoUV/BYXQ1UzgTF+jRGGxmvzbPbwcRznWjbl/0+uRFH3IKIgZ3tHYMvGImty
 NSMXcL9iShsH5E6VqRg6pjGR2qpkRHXy7xlxlS++W6GEH/tAkTdr0W8n7scB8zJDHoFww+gm1
 mtNLiJQNf7AvKEuJc1lc/zQM7FFsH7pzEpFfLHipJsUdUZez7aWC5PjeoaCPO0CYMAgP6aqIK
 t3ZuhjdM2x3mdYDPc4ytUKByu0kMK6SzuEgpSNsE1h1OBPNZIN/0iVEzl5a+CGrKarZpXA9NA
 fxBdYShqIjl5+TtpR1po0zbDoSVf+6imCQsw5j4oJxHcsgl1hiJ5mif+Sw+p+65ElTSANGZfz
 3isHRrC0FZg7bZTy6rZsBC9Fh81yzVhvb8ut8Epv5wp+AyiNKbL+Dtsv8mrPCQ6CFVXCDQIIV
 K2m8Y4gxk0BomOAq4MJywrsw25fODcLK1jVRlwZuWuyNZ/SNtdEko4BaJb5ECWS3OM3qB9j06
 RwjrEWLGO9an6mnuQqyFg8XcOq32zG5kYZphVInaxus9CsKlR2cxv7i8A9nB3LXmVBZXYxyHs
 Rx1ltzngDZdduOi0jQG/AVGiV6D/+uNwvPGg2VBVnufTIpjgMlYQhVohLhEZ4Ed+OAg6nB8uu
 LY2MUEZJYDPxl1zj4vm9pEQ9ulHV5pF3leUwNDwFRt+SLKh7CShdNt/xa4q8afWm/NAtMzk0F
 s9mraeWNkFoevqmtlU9H/+y6nNpPiZ6YfrT6GLSmJZVC1QU8R+9ystFFly9223I8kpFenpElw
 yHqdix5nJ7UFSyxlyduw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 9:36 AM Christophe Leroy <christophe.leroy@c-s.fr> wrote:
> Le 08/01/2020 à 09:18, Krzysztof Kozlowski a écrit :
> > On Wed, 8 Jan 2020 at 09:13, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > I'll add to this one also changes to ioreadX_rep() and add another
> > patch for volatile for reads and writes. I guess your review will be
> > appreciated once more because of ioreadX_rep()
> >
>
> volatile should really only be used where deemed necessary:
>
> https://www.kernel.org/doc/html/latest/process/volatile-considered-harmful.html
>
> It is said: " ...  accessor functions might use volatile on
> architectures where direct I/O memory access does work. Essentially,
> each accessor call becomes a little critical section on its own and
> ensures that the access happens as expected by the programmer."

The I/O accessors are one of the few places in which 'volatile' generally
makes sense, at least for the implementations that do a plain pointer
dereference (probably none of the ones in question here).

In case of readl/writel, this is what we do in asm-generic:

static inline u32 __raw_readl(const volatile void __iomem *addr)
{
        return *(const volatile u32 __force *)addr;
}

The __force-cast that removes the __iomem here also means that
the 'volatile' keyword could be dropped from the argument list,
as it has no real effect any more, but then there are a few drivers
that mark their iomem pointers as either 'volatile void __iomem*' or
(worse) 'volatile void *', so we keep it in the argument list to not
add warnings for those drivers.

It may be time to change these drivers to not use volatile for __iomem
pointers, but that seems out of scope for what Krzysztof is trying
to do. Ideally we would be consistent here though, either using volatile
all the time or never.

        Arnd
