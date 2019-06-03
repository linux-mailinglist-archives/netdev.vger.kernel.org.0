Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6E7328AC
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 08:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfFCGmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 02:42:11 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46317 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfFCGmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 02:42:10 -0400
Received: by mail-qt1-f193.google.com with SMTP id z19so8078825qtz.13;
        Sun, 02 Jun 2019 23:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=p+Kshot6ZvEqnQX0598USKcuPnqfyWvBlKgNYjy2F6c=;
        b=fPG8oNuEYzRdQfY8V5DfWF4lRu/aqJKsSOUA7cj07Vw04rbhgSTa4T0ktuNOU+GTHW
         8JrJXdfJr+oFs9Y0Vc33ZKWV3vPZhrZKIhDXcBkul8nKe4mavXeSFmz8xtY8zpWnihMv
         dgJWTLWVC0zNSpDyHoRV0tzPYRCkuk0hImB8QrtUcljafz0YiZuctqIk7+2uD69Zkv69
         VFDS5Mml4MMfdQcCeDHrod9QmJeb88p/+2y4WiLhN8tdrTR/K2+bikgMOGrG30fyh4aM
         stvzp4x7K36cVfae1SB1Asq67O5nLJRctO/kedUudfUP0ntTmVVgGh2lwkNy3f3EGVWi
         7/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=p+Kshot6ZvEqnQX0598USKcuPnqfyWvBlKgNYjy2F6c=;
        b=SfIyLmAKfYjKzLOScnOsF6jciQsKFKy5Ig5CgtrI9/a/UhWGzPkvksft+4Ca6gqgrW
         MRfJFUtPMSqkLzwYRrq8klqvyXSmvcz5kgiwgcCwhHmrRSNSWdgbuxjW3GBNtgCpB0Yd
         wYfcXrFjIS9yeO7G9FUmLAqKbLRRBOJ0OUTXf9fvz5qwUtvubUfhX9N5v9n6snLhk2V9
         eGorKQrtComNVmoCe9IdZe2nWIMOlTYANyg/4dca5cS3tKvTDsog+L4eI+YhMwhUOsBs
         ob+g2zTLIvKE48Gyv6wS9q2SZOzZavZ2qavYDR25KyUuHQgDhBnqNfXUmYJTEqqTYFy+
         GILQ==
X-Gm-Message-State: APjAAAU4wQWYrMUj3D25JXu8eAFpDUHkL5xj3vHyfWHrFBxVVaShBTLd
        M0T2erjnQ08HX3KJlIxz6S0=
X-Google-Smtp-Source: APXvYqz5VY7Ndan3SHTiu76gJvvpet1Ni6WsPB+yqSEEDJpmZAtGsNkDudP0WRSK/v+qNlbeinBt2A==
X-Received: by 2002:a0c:b057:: with SMTP id l23mr20777095qvc.55.1559544128662;
        Sun, 02 Jun 2019 23:42:08 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id m5sm8626258qke.25.2019.06.02.23.42.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 23:42:07 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 87BF322007;
        Mon,  3 Jun 2019 02:42:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 03 Jun 2019 02:42:06 -0400
X-ME-Sender: <xms:PcH0XNgVOCr_bZ8txxiGq9mReVBYGjgMUwaK5vBOCv94gXIYT4uaJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefiedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehgtderredtredvnecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuffhomh
    grihhnpegrphgrnhgrrdhorhhgrdgruhenucfkphepgeehrdefvddruddvkedruddtleen
    ucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgvrh
    hsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunhdrfhgv
    nhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgvnecuvehluhhsthgvrhfuih
    iivgeptd
X-ME-Proxy: <xmx:PcH0XDevkILOTEC05QtwElpQjFTmdsI3m-sPfFBcFoiIkPHM5WQ8IA>
    <xmx:PcH0XIc8cPKGbW-E64DouRqAuXSfI6X06xiX6Q_viFPRTklI5AIjVQ>
    <xmx:PcH0XPUD_gioWcLUHvtKb_jnZEvDqQISA9K_79f8PEb-HRc8ohioog>
    <xmx:PsH0XIfMedy0kKwFzyuxJRs8HZu6ryGuprO6UOLhEc1b8TpOA5yxUg>
Received: from localhost (unknown [45.32.128.109])
        by mail.messagingengine.com (Postfix) with ESMTPA id B9D9B38008B;
        Mon,  3 Jun 2019 02:42:04 -0400 (EDT)
Date:   Mon, 3 Jun 2019 14:42:00 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: rcu_read_lock lost its compiler barrier
Message-ID: <20190603064200.GA11024@tardis>
References: <20150910102513.GA1677@fixme-laptop.cn.ibm.com>
 <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
 <20190603024640.2soysu4rpkwjuash@gondor.apana.org.au>
 <20190603034707.GG28207@linux.ibm.com>
 <20190603052626.nz2qktwmkswxfnsd@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <20190603052626.nz2qktwmkswxfnsd@gondor.apana.org.au>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 03, 2019 at 01:26:26PM +0800, Herbert Xu wrote:
> On Sun, Jun 02, 2019 at 08:47:07PM -0700, Paul E. McKenney wrote:
> >=20
> > 1.	These guarantees are of full memory barriers, -not- compiler
> > 	barriers.
>=20
> What I'm saying is that wherever they are, they must come with
> compiler barriers.  I'm not aware of any synchronisation mechanism
> in the kernel that gives a memory barrier without a compiler barrier.
>=20
> > 2.	These rules don't say exactly where these full memory barriers
> > 	go.  SRCU is at one extreme, placing those full barriers in
> > 	srcu_read_lock() and srcu_read_unlock(), and !PREEMPT Tree RCU
> > 	at the other, placing these barriers entirely within the callback
> > 	queueing/invocation, grace-period computation, and the scheduler.
> > 	Preemptible Tree RCU is in the middle, with rcu_read_unlock()
> > 	sometimes including a full memory barrier, but other times with
> > 	the full memory barrier being confined as it is with !PREEMPT
> > 	Tree RCU.
>=20
> The rules do say that the (full) memory barrier must precede any
> RCU read-side that occur after the synchronize_rcu and after the
> end of any RCU read-side that occur before the synchronize_rcu.
>=20
> All I'm arguing is that wherever that full mb is, as long as it
> also carries with it a barrier() (which it must do if it's done
> using an existing kernel mb/locking primitive), then we're fine.
>=20
> > Interleaving and inserting full memory barriers as per the rules above:
> >=20
> > 	CPU1: WRITE_ONCE(a, 1)
> > 	CPU1: synchronize_rcu=09
> > 	/* Could put a full memory barrier here, but it wouldn't help. */
>=20
> 	CPU1: smp_mb();
> 	CPU2: smp_mb();
>=20
> Let's put them in because I think they are critical.  smp_mb() also
> carries with it a barrier().
>=20
> > 	CPU2: rcu_read_lock();
> > 	CPU1: b =3D 2;=09
> > 	CPU2: if (READ_ONCE(a) =3D=3D 0)
> > 	CPU2:         if (b !=3D 1)  /* Weakly ordered CPU moved this up! */
> > 	CPU2:                 b =3D 1;
> > 	CPU2: rcu_read_unlock
> >=20
> > In fact, CPU2's load from b might be moved up to race with CPU1's store,
> > which (I believe) is why the model complains in this case.
>=20
> Let's put aside my doubt over how we're even allowing a compiler
> to turn
>=20
> 	b =3D 1
>=20
> into
>=20
> 	if (b !=3D 1)
> 		b =3D 1
>=20
> Since you seem to be assuming that (a =3D=3D 0) is true in this case

I think Paul's example assuming (a =3D=3D 0) is false, and maybe
speculative writes (by compilers) needs to added into consideration?
Please consider the following case (I add a few smp_mb()s), the case may
be a little bit crasy, you have been warned ;-)

 	CPU1: WRITE_ONCE(a, 1)
 	CPU1: synchronize_rcu called

 	CPU1: smp_mb(); /* let assume there is one here */

 	CPU2: rcu_read_lock();
 	CPU2: smp_mb(); /* let assume there is one here */

	/* "if (b !=3D 1) b =3D 1" reordered  */
 	CPU2: r0 =3D b;       /* if (b !=3D 1) reordered here, r0 =3D=3D 0 */
 	CPU2: if (r0 !=3D 1)  /* true */
	CPU2:     b =3D 1;    /* b =3D=3D 1 now, this is a speculative write
	                       by compiler
			     */

	CPU1: b =3D 2;        /* b =3D=3D 2 */

 	CPU2: if (READ_ONCE(a) =3D=3D 0) /* false */
	CPU2: ...
	CPU2  else                   /* undo the speculative write */
	CPU2:	  b =3D r0;   /* b =3D=3D 0 */

 	CPU2: smp_mb();
	CPU2: read_read_unlock();

I know this is too crasy for us to think a compiler like this, but this
might be the reason why the model complain about this.

Paul, did I get this right? Or you mean something else?

Regards,
Boqun



> (as the assignment b =3D 1 is carried out), then because of the
> presence of the full memory barrier, the RCU read-side section
> must have started prior to the synchronize_rcu.  This means that
> synchronize_rcu is not allowed to return until at least the end
> of the grace period, or at least until the end of rcu_read_unlock.
>=20
> So it actually should be:
>=20
> 	CPU1: WRITE_ONCE(a, 1)
> 	CPU1: synchronize_rcu called
> 	/* Could put a full memory barrier here, but it wouldn't help. */
>=20
> 	CPU1: smp_mb();
> 	CPU2: smp_mb();
>=20
> 	CPU2: grace period starts
> 	...time passes...
> 	CPU2: rcu_read_lock();
> 	CPU2: if (READ_ONCE(a) =3D=3D 0)
> 	CPU2:         if (b !=3D 1)  /* Weakly ordered CPU moved this up! */
> 	CPU2:                 b =3D 1;
> 	CPU2: rcu_read_unlock
> 	...time passes...
> 	CPU2: grace period ends
>=20
> 	/* This full memory barrier is also guaranteed by RCU. */
> 	CPU2: smp_mb();
>=20
> 	CPU1 synchronize_rcu returns
> 	CPU1: b =3D 2;=09
>=20
> Cheers,
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEj5IosQTPz8XU1wRHSXnow7UH+rgFAlz0wTUACgkQSXnow7UH
+rhlUQf/fOWYt2sawXloMg9SKEFA08dot6GWx7MXYzpYQIX1Zp8RxcALCVVWP0CD
rBexn6JFN99VDhMYU48f2ZRs6dk0YAHAVJpqnAXBJDBARdxwbViB8GdD/seu+3hC
HBFeOXZVtqw303lZtF2Gia8+1M01XwuR3YV/BB8TSsD7FYZPMQx1NIBtQJ2IrHIF
G58qsbB7+4H7LLCJCjSb+mUyekt5HGZguhZL+ib3kbPsEY0yoZ9S3hqqQ14OTPFG
yyerP0RXMKbhqNEJxNnkusIYiiaybwMbLYI+r/mzZkEcTEzGfeRqeoNHzsJKJr82
vTSY45HAtRjhjasbi3g9HcKbWhoF5g==
=l2S9
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
