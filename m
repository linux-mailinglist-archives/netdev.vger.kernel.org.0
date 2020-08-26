Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961752524C9
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 02:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgHZAmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 20:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgHZAmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 20:42:07 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6EBC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 17:42:06 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t4so371693iln.1
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 17:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y1N0nmqXEJNhpI/gKS8mGW1qw8K7Er8pw8p2A7bvfLE=;
        b=khmUCnqZ3C7IZnuIS+iLmIyLt4hG63NivLFk4bqMIYwyQlsQ/V3MnKe8oqbIAwXZwA
         iEVpFARRtANNsCjwPc0IqNPpZ6kwnZ4Df5Rv/G4xjpqAJVkh1QegxbBdMX9BMC8cS3mx
         LaRmFjiLfGNWjwyPdqdntF2m/sj/ntJDrOJet3J5EsXtvNzGIXLMFwKzV3qKKIQpMyPg
         Tzt0pbN/icEm+ADu07PKP/Oo+j/l51+lSsbui144lw8PrugxKUmhNQXYHBA9Ektf4tXP
         /YlanlpmMsNBzPr20OilNTEn/mXXJAR52xtjCfdA6vgRXyf50jbkD0mxPeFSXcqG5A3H
         XfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y1N0nmqXEJNhpI/gKS8mGW1qw8K7Er8pw8p2A7bvfLE=;
        b=p/B0xgVZJQyR09BXAr/G+rjbuDIQMgVvN+u/+VlE7cl1wYEugMenLIk53tPVel2fW+
         sd6jsCQlhGRcOSXwWyLfFTBR9RlK0zIm4h7B4HrbgJ03eCHT2S9HOvFn69V2F8N9p0l5
         JQI+3kYCXkfvEFuazOOQ0FRtSmGMvPKjObSb1cDV92H8cM5ej9JXUwCNZVEnyDCpG8lU
         pDXlz6xy89paRv6PRFPbPPEp2woKSVvmwMmJWE2aI9k11sJjb9wbQco8UYN6CZ5WIAg2
         Rl9tnf141oFU0k87jA8jtPkhuYGW3ztkvWp+Qp5KENdCgIJp5ncr1vb73ZTvArsE5nkj
         IICg==
X-Gm-Message-State: AOAM5321wiVjD6aZIqimSthA7NeMicPX/0whQVzgOpTLEau6bi1Vzm3k
        T8MNbuULh8FhQsUwZOdvR/GbaKGDhelZjZlrKiNUkw==
X-Google-Smtp-Source: ABdhPJyxfWmJmM34qTIEAYOu0pOUEk7A08Ht/ZXagwlvM+k4U62I2n4EMghJz31NEPc/Jtd2fSFTK8sEuvrle2QorJs=
X-Received: by 2002:a92:d7c1:: with SMTP id g1mr11535679ilq.145.1598402525781;
 Tue, 25 Aug 2020 17:42:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200825224208.1268641-1-maheshb@google.com> <9fce7d7e-aa33-a451-ab4a-a297b1317310@infradead.org>
 <CAF2d9jiwH=GO3zd1sK-mURRV_W-_bfihbmc+ud=ZdV_SvYAuvg@mail.gmail.com>
In-Reply-To: <CAF2d9jiwH=GO3zd1sK-mURRV_W-_bfihbmc+ud=ZdV_SvYAuvg@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 25 Aug 2020 17:41:53 -0700
Message-ID: <CANP3RGdkSsjyM0vwY=f19rzsuLUCwAqDRHZT54i2BksgN58LKQ@mail.gmail.com>
Subject: Re: [PATCHv2 next] net: add option to not create fall-back tunnels in
 root-ns as well
To:     =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Jian Yang <jianyang@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 4:00 PM Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=
=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=
=B0)
<maheshb@google.com> wrote:
>
> On Tue, Aug 25, 2020 at 3:47 PM Randy Dunlap <rdunlap@infradead.org> wrot=
e:
> >
> > On 8/25/20 3:42 PM, Mahesh Bandewar wrote:
> > > The sysctl that was added  earlier by commit 79134e6ce2c ("net: do
> > > not create fallback tunnels for non-default namespaces") to create
> > > fall-back only in root-ns. This patch enhances that behavior to provi=
de
> > > option not to create fallback tunnels in root-ns as well. Since modul=
es
> > > that create fallback tunnels could be built-in and setting the sysctl
> > > value after booting is pointless, so added a kernel cmdline options t=
o
> > > change this default. The default setting is preseved for backward
> > > compatibility. The kernel command line option of fb_tunnels=3Dinitns =
will
> > > set the sysctl value to 1 and will create fallback tunnels only in in=
itns
> > > while kernel cmdline fb_tunnels=3Dnone will set the sysctl value to 2=
 and
> > > fallback tunnels are skipped in every netns.
> > >
> > > Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Maciej Zenczykowski <maze@google.com>
> > > Cc: Jian Yang <jianyang@google.com>
> > > ---
> > > v1->v2
> > >   Removed the Kconfig option which would force rebuild and replaced w=
ith
> > >   kcmd-line option
> > >
> > >  .../admin-guide/kernel-parameters.txt         |  5 +++++
> > >  Documentation/admin-guide/sysctl/net.rst      | 20 +++++++++++++----=
--
> > >  include/linux/netdevice.h                     |  7 ++++++-
> > >  net/core/sysctl_net_core.c                    | 17 ++++++++++++++--
> > >  4 files changed, 40 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Docume=
ntation/admin-guide/kernel-parameters.txt
> > > index a1068742a6df..09a51598c792 100644
> > > --- a/Documentation/admin-guide/kernel-parameters.txt
> > > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > > @@ -801,6 +801,11 @@
> > >
> > >       debug_objects   [KNL] Enable object debugging
> > >
> > > +     fb_tunnels=3D     [NET]
> > > +                     Format: { initns | none }
> > > +                     See Documentation/admin-guide/sysctl/net.rst fo=
r
> > > +                     fb_tunnels_only_for_init_ns
> > > +
> >
> > Not at this location in this file.
> > Entries in this file are meant to be in alphabetical order (mostly).
> >
> > So leave debug_objects and no_debug_objects together, and insert fb_tun=
nels
> > between fail_make_request=3D and floppy=3D.
> >
> I see. I'll fix it in the next revision.
> thanks for the suggestion.
> --mahesh..
>
> > Thanks.
> >
> > >       no_debug_objects
> > >                       [KNL] Disable object debugging
> > >
> >
> > --
> > ~Randy

Setting it to 1 via kcmdline doesn't seem all that useful, since
instead of that you can just use initrc/sysctl.conf/etc.

Would it be simpler if it was just 'no_fb_tunnels' or
'no_fallback_tunnels' and the function just set the sysctl to 2
unconditionally?
(ie. no =3D.... parsing at all) that would also be less code...

btw. I also don't understand the '!IS_ENABLED(CONFIG_SYSCTL) ||'
piece.  Why not just delete that?
This seems to force fallback tunnels if you disable CONFIG_SYSCTL...
but (a) then the kcmdline option doesn't work,
and (b) that should already just happen by virtue of the sysctl defaulting =
to 0.
