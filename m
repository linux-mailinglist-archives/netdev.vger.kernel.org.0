Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68EE7133D70
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 09:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgAHInR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jan 2020 03:43:17 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40726 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgAHInQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 03:43:16 -0500
Received: by mail-ot1-f65.google.com with SMTP id w21so2828269otj.7;
        Wed, 08 Jan 2020 00:43:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7cWBGOss6IZmXIImkX09JkN+lqirutcjNONiaHMIXk4=;
        b=BUZNvBP6HUEzjF14WcEA8/f1NgJEx+rvIhju7kJhaRzdXsdM2BqykKFLcexUFcuSwc
         3Zd5HqsLEjGA4Dmp74XXYheyBlTN1Draz4VZtOytrnqtMidtF1bdYJJlOzbe18KLuBv6
         xqp6Suf4TGYMKVEQj8rK7zDX5CNqHCSo3USUFj+yhGgUkrSoHvqybDjeyJ5kO3qxxJxF
         chDoDrkACkggurqW0rIzhutuKOpRtAn7g+xyXu1pcIx6EjVRuUlekFQbDe5zcoAJr/Su
         DGqrrnHic1E4zp2x+786IQ3/hoYGGnFwN6CPb9wXBNxv+RYozHpuFlxYYRmFFE7oayHU
         wTUQ==
X-Gm-Message-State: APjAAAUS4u9An3bnhgc77tAWe5sfclqYZ6JVMacIGosQccRxXkknwjcT
        4xRXp5qtdBaL2ZrDZucmOIbNmhwQd7NuBWsWYuM=
X-Google-Smtp-Source: APXvYqyLwchytFfBRcGzmYLq5q4p5hvwH1AjnwV9nNk5cX7+q/Njb59ahRoMRaX1Y0RAyipVtDWx7V8ZzLixl6z6dho=
X-Received: by 2002:a9d:6a84:: with SMTP id l4mr3302303otq.145.1578472995351;
 Wed, 08 Jan 2020 00:43:15 -0800 (PST)
MIME-Version: 1.0
References: <1578415992-24054-1-git-send-email-krzk@kernel.org>
 <CAMuHMdW4ek0OYQDrrbcpZjNUTTP04nSbwkmiZvBmKcU=PQM9qA@mail.gmail.com>
 <CAMuHMdUBmYtJKtSYzS_5u67hVZOqcKSgFY1rDGme6gLNRBJ_gA@mail.gmail.com>
 <CAJKOXPfq9vS4kSyx1jOPHBvi9_HjviRv0LU2A8ZwdmqgUuebHQ@mail.gmail.com> <2355489c-a207-1927-54cf-85c04b62f18f@c-s.fr>
In-Reply-To: <2355489c-a207-1927-54cf-85c04b62f18f@c-s.fr>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 8 Jan 2020 09:43:04 +0100
Message-ID: <CAMuHMdV=-m-eN4rOa=XQhk2oBDZZwgXXMU6RMVQRVsc6ALyeoA@mail.gmail.com>
Subject: Re: [RFT 00/13] iomap: Constify ioreadX() iomem argument
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
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
        Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        Dave Airlie <airlied@redhat.com>,
        Matt Turner <mattst88@gmail.com>,
        arcml <linux-snps-arc@lists.infradead.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Allen Hubbe <allenbh@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

On Wed, Jan 8, 2020 at 9:35 AM Christophe Leroy <christophe.leroy@c-s.fr> wrote:
> Le 08/01/2020 à 09:18, Krzysztof Kozlowski a écrit :
> > On Wed, 8 Jan 2020 at 09:13, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >> On Wed, Jan 8, 2020 at 9:07 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >>> On Tue, Jan 7, 2020 at 5:53 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> >>>> The ioread8/16/32() and others have inconsistent interface among the
> >>>> architectures: some taking address as const, some not.
> >>>>
> >>>> It seems there is nothing really stopping all of them to take
> >>>> pointer to const.
> >>>
> >>> Shouldn't all of them take const volatile __iomem pointers?
> >>> It seems the "volatile" is missing from all but the implementations in
> >>> include/asm-generic/io.h.
> >>
> >> As my "volatile" comment applies to iowrite*(), too, probably that should be
> >> done in a separate patch.
> >>
> >> Hence with patches 1-5 squashed, and for patches 11-13:
> >> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >
> > I'll add to this one also changes to ioreadX_rep() and add another
> > patch for volatile for reads and writes. I guess your review will be
> > appreciated once more because of ioreadX_rep()
>
> volatile should really only be used where deemed necessary:
>
> https://www.kernel.org/doc/html/latest/process/volatile-considered-harmful.html
>
> It is said: " ...  accessor functions might use volatile on
> architectures where direct I/O memory access does work. Essentially,
> each accessor call becomes a little critical section on its own and
> ensures that the access happens as expected by the programmer."

That is exactly the use case here: all above are accessor functions.

Why would ioreadX() not need volatile, while readY() does?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
