Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6091CEA1E
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 03:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgELB3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 21:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgELB3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 21:29:00 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D75C061A0C;
        Mon, 11 May 2020 18:28:59 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49LgDz1Fklz9sRY;
        Tue, 12 May 2020 11:28:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1589246936;
        bh=cZ7uSDuRC7yPzQjiGIww2uB225Uwi2FbuHaPahXVHeU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KmA2zkfKhjqH9/hEezz+QaVI4yA2tLU3clV7tn3wcz6jYmh79gg5Ur0IJTFFyZw9u
         +Z7kjHeRdBUfI2xvzDo93pCi2Cqn1WSQjnoheSW2Puk2u3sJhhbR8ZvXSWdAG04eH2
         mR2hWLAGRWnplgNU0GaQoIxeG7bLAITaLpwtm9BoaTPs0sL13KdAijVWyd7HndHLJv
         Lt7ClofWgPkK0fPUYxXc+yN6TDEAhuFIT/FTGNI/oSEvdy2hsRTY1zgAopsXnGibr7
         fu45Tz6QU9Xzipv4gTWDfcjgiHVprX7VOqnBYRnEllGXMnl8GjGMh7FjKmxnznws0n
         V/g7CbMlszMkA==
Date:   Tue, 12 May 2020 11:28:47 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc:     Qian Cai <cai@lca.pw>, Amol Grover <frextrite@gmail.com>,
        syzbot <syzbot+761cff389b454aa387d2@syzkaller.appspotmail.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: linux-next boot error: WARNING: suspicious RCU usage in
 ip6mr_get_table
Message-ID: <20200512112847.3b15d182@canb.auug.org.au>
In-Reply-To: <20200507232402.GB2103@madhuparna-HP-Notebook>
References: <00000000000003dc8f05a50b798e@google.com>
        <CACT4Y+bzRtZdLSzHTp-kJZo4Qg7QctXNVEY9=kbAzfMck9XxAA@mail.gmail.com>
        <DB6FF2E0-4605-40D1-B368-7D813518F6F7@lca.pw>
        <20200507232402.GB2103@madhuparna-HP-Notebook>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aSUw77_wXehJb9dNGjnult=";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/aSUw77_wXehJb9dNGjnult=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 8 May 2020 04:54:02 +0530 Madhuparna Bhowmik <madhuparnabhowmik10@g=
mail.com> wrote:
>
> On Thu, May 07, 2020 at 08:50:55AM -0400, Qian Cai wrote:
> >=20
> >  =20
> > > On May 7, 2020, at 5:32 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> > >=20
> > > On Thu, May 7, 2020 at 11:26 AM syzbot
> > > <syzbot+761cff389b454aa387d2@syzkaller.appspotmail.com> wrote: =20
> > >>=20
> > >> Hello,
> > >>=20
> > >> syzbot found the following crash on:
> > >>=20
> > >> HEAD commit:    6b43f715 Add linux-next specific files for 20200507
> > >> git tree:       linux-next
> > >> console output: https://syzkaller.appspot.com/x/log.txt?x=3D16f64370=
100000
> > >> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Def9b7a80=
b923f328
> > >> dashboard link: https://syzkaller.appspot.com/bug?extid=3D761cff389b=
454aa387d2
> > >> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > >>=20
> > >> Unfortunately, I don't have any reproducer for this crash yet.
> > >>=20
> > >> IMPORTANT: if you fix the bug, please add the following tag to the c=
ommit:
> > >> Reported-by: syzbot+761cff389b454aa387d2@syzkaller.appspotmail.com =
=20
> > >=20
> > >=20
> > > +linux-next for linux-next boot breakage =20
> >=20
> > Amol, Madhuparna, Is either of you still working on this?
> >  =20
> > >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > >> WARNING: suspicious RCU usage
> > >> 5.7.0-rc4-next-20200507-syzkaller #0 Not tainted
> > >> -----------------------------
> > >> net/ipv6/ip6mr.c:124 RCU-list traversed in non-reader section!!
> > >> =20
> I had some doubt in this one, I have already mailed the maintainers,
> waiting for their reply.

This is blocking syzbot testing of linux-next ... are we getting
anywhere?  Will a patch similar to the ipmr.c one help here?

--=20
Cheers,
Stephen Rothwell

--Sig_/aSUw77_wXehJb9dNGjnult=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl65+88ACgkQAVBC80lX
0GzHWQf/XnheV9DMxwtwerW6eEwTsz/9mpHt4siZpPWZN1yI7yUKCiEraZyCHOXy
lBcSA7ZJtejRjaaEj6HWjiYnt+dUQps+6vZsIhGiuIYDe6Y/XQurotRezy4llSCX
ONc0lG13YeGkwZv87wlZFcKK7Jc215GIYWJy2E+nJMt+DncreP+SHkN5SqFVV4PX
lvavvZgNG48sULJ+MDE+q8hhwuiZDCUSzAq5vTzyIgRFRyzkKBGIqS+m/FaLvces
S3dY6YicHMRI52VC7FvtnSE1/VonKwtcUrsp3CHTSPqe5eCwLcz+O+YNW+ZRDln5
NUEtEcseEAD60GYuUjDr14D196zQ9A==
=zSAJ
-----END PGP SIGNATURE-----

--Sig_/aSUw77_wXehJb9dNGjnult=--
