Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307539B7FF
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436873AbfHWVEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:04:00 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:51266 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731003AbfHWVD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 17:03:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ivYzwFDnFB6dEbOKWm2Jn7GdkzO9PknPkaIHs7XYuW4=; b=Fgximarup8qYnZgGwykU9zYqc
        Mf11VXqJSHaY0XLTYJOcOUhgWuHRfbVBfb2M1cFFxXYn4AHfiLh8rOFvOEu7v32Yc0qUz5x56uM/b
        Mo8HNNqsQK2reR6Yk8Ln+wf+gesP810MCyxv6BPtzkSEt4BbphgKXj037/rZDk+ejgbkk=;
Received: from [92.54.175.117] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i1Giy-0005Ju-Et; Fri, 23 Aug 2019 21:03:56 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 255B4D02CD1; Fri, 23 Aug 2019 22:03:56 +0100 (BST)
Date:   Fri, 23 Aug 2019 22:03:56 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE
 when it's not ours
Message-ID: <20190823210356.GU23391@sirena.co.uk>
References: <20190822211514.19288-1-olteanv@gmail.com>
 <20190822211514.19288-3-olteanv@gmail.com>
 <20190823102816.GN23391@sirena.co.uk>
 <CA+h21hoUfbW8Gpyfa+a-vqVp_qARYoq1_eyFfZFh-5USNGNE2g@mail.gmail.com>
 <20190823105044.GO23391@sirena.co.uk>
 <20190823105949.GQ23391@sirena.co.uk>
 <CA+h21hrj6VjceGJFz7XuS9DFjy=Fb5SHTYUuOWkagtsWf0Egbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="25rOlkxR6a4U87uN"
Content-Disposition: inline
In-Reply-To: <CA+h21hrj6VjceGJFz7XuS9DFjy=Fb5SHTYUuOWkagtsWf0Egbg@mail.gmail.com>
X-Cookie: Don't SANFORIZE me!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--25rOlkxR6a4U87uN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 23, 2019 at 03:06:52PM +0300, Vladimir Oltean wrote:

> - You left change requests in the initial patchset I submitted, but
> you partially applied the series anyway. You didn't give me a chance
> to respin the whole series and put the shared IRQ fix on top, so it
> applies on old trees as well. No problem, I sent two versions of the
> patch.

Right, and this is fine.  A big part of this is that it's just
generally bad practice to not have fixes at the front of the
series, I'd flag this up as a problem even if the code was all
new and there was no question of applying as a bug fix.  It's
something that's noticable just at the level of looking at the
shape of the series without even looking at the contents of the
patches, if the fix is actually a good one or anything like that.
In the context of this it made it look like the reason you'd had
to do two versions.

> So I didn't put any target version in the patch titles this time,
> although arguably it would have been clearer to you that there's a
> patch for-5.4 and another version of it for-4.20 (which i *think* is
> how I should submit a fix, I don't see any branch for inclusion in
> stable trees per se).

Not for 4.20, for v5.3 - we basically only fix Linus' tree
directly, anything else gets backported from there unless it's
super important.  I don't think anyone is updating v4.20 at all
these days, the version number change from v4 to v5 was totally
arbatrary.

> Yes, I did send a cover letter for a single patch. I thought it's
> harder to miss than a note hidden under patch 2/5 of one series, and
> in the note section of the other's. I think you could have also made

If you're sending a multi-patch series it's of course good to
send a cover letter, it's just single patches where it's adding
overhead.

> No problem, you missed the link between the two. I sent you a link to
> the lkml archive. You said "I'm not online enough to readily follow
> that link right now". Please teach me - I really don't know - how can

It's not that I missed the link between them, it's that what I'd
expected to see was the fix being the first patch in the series
for -next and for that fix to look substantially the same with at
most some context difference.  I wasn't expecting to see a
completely different patch that wasn't at the start of the
series, had the fix been at the start of the series it'd have
been fairly clear what was going on but the refactoring patch
looked like the main reason you'd needed different versions (it's
certainly why they don't visually resemble each other).

In other words it looked like you'd sent a different fix because
the fix you'd done for -next was based on the first patch in the
series rather than there also being some context changes.

> I make links between patchsets easier for you to follow, if you don't
> read cover letters and you can't access lkml? I promise I'll use that
> method next time.

Like I said include a plain text description of what you're
linking to (eg, the subject line from a mail).

> > I do frequently catch up on my mail on flights or while otherwise
> > travelling so this is even more pressing for me than just being about
> > making things a bit easier to read.

> Maybe you simply should do something else while traveling, just saying.

I could also add in the coffee shop I sometimes work from which
doesn't have WiFi or mobile coverage.  Besides, like that part of
the text does say it's also a usability thing, having to fire up
a web browser to figure out what's being described is a stumbling
block.

--25rOlkxR6a4U87uN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1gVLsACgkQJNaLcl1U
h9B2pAf+OqEH0c/ir0i5HzOOu3foBEg4ijLDLobzCWquMYtExGnWzATCgFiBeNua
ukOy2G0NaRiaIVws5VQXj5y9+okcAFfjfVVwMIKTjqT6CwmTmGZb9Xlg/mgk1yJs
OzKiKXM2b+vc3QyIFHI1EqmLqdz750Pdh6Lnulsl9TYm6zdsv7ecc2lIlnnRP79d
eWCN2wNbGO8WUXLr/W83nXUfm03qs6KVes765JTaYqDLeYx8QoIV9Lf4UqPFtLDI
iWT2+NUTPUP2oR7wokomqY8Ql7woJYFr5Okbl33288iJL1XLmM1j8BKxWg+207Cj
BgnfvF9wzTpzBVO6dTlqlOZK7s6SQA==
=vtug
-----END PGP SIGNATURE-----

--25rOlkxR6a4U87uN--
