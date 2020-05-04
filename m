Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB101C3109
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 03:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgEDBZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 21:25:59 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:60847 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgEDBZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 May 2020 21:25:58 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49FlYH0HjSz9sSr;
        Mon,  4 May 2020 11:25:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1588555556;
        bh=vc2ocq2LVzS7oNXSMpHcVG3xe33e0fBbGhPZyRYagfM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P+yJzoL4bKmQgxZi1HZa5TPP9rwqF/h2NThx+pjTcMdtdBDNff/3h228jqwzsXE2b
         NQJQhDYncXGB0zYQeDkYjscr4OF+6Rqxpr31OS5Obez0CGvi8oBiJ3Y2azikMftqQt
         U+jzCD47pLK/nuTaLkh3aiYDzUWWzf1IbXyuYsgSqVM3RNmpilPBYaN/E+R7RNNqo1
         WT9ab3XNgwxWwK5N/cas1cph5490Z5afc6RVZtTmbZpHUnnVlwPo1486wsKlO+zmPg
         yu1OUHXML1YrIkeJQ8m9spCLWXR6FJr3ec9jOEGd6cjZcxZe1mrlNfBUbSa4Vnfgr4
         ZNwuqxT3rnTxQ==
Date:   Mon, 4 May 2020 11:25:52 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 3/5] sysctl: remove all extern declaration from sysctl.c
Message-ID: <20200504112552.4dbdd2a9@canb.auug.org.au>
In-Reply-To: <20200424064338.538313-4-hch@lst.de>
References: <20200424064338.538313-1-hch@lst.de>
        <20200424064338.538313-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Ze/S33mgpR/AlQdumg8GhV7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Ze/S33mgpR/AlQdumg8GhV7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Fri, 24 Apr 2020 08:43:36 +0200 Christoph Hellwig <hch@lst.de> wrote:
>
> Extern declarations in .c files are a bad style and can lead to
> mismatches.  Use existing definitions in headers where they exist,
> and otherwise move the external declarations to suitable header
> files.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/coredump.h |  4 ++++
>  include/linux/file.h     |  2 ++
>  include/linux/mm.h       |  2 ++
>  include/linux/mmzone.h   |  2 ++
>  include/linux/pid.h      |  3 +++
>  include/linux/sysctl.h   |  8 +++++++
>  kernel/sysctl.c          | 45 +++-------------------------------------
>  7 files changed, 24 insertions(+), 42 deletions(-)

A couple of suggestions for another patch (since this one is in a
shared branch in Al's tree now):

There is an "extern struct ctl_table random_table[];" in
drivers/char/random.c which is redundant now (in fact always was).

There is already an "extern struct ctl_table epoll_table[];" in
include/linux/poll.h, so could have included that in kernel/sysctl.c
instead of adding the new one in include/linux/sysctl.h

--=20
Cheers,
Stephen Rothwell

--Sig_/Ze/S33mgpR/AlQdumg8GhV7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6vbyAACgkQAVBC80lX
0GxFGwf/WH/cv5RMadV9dmdAfJGI/cu7ozy5lgpWNwTKsdi4ITqe5NGRhPUzU4yW
G2MRxjhFk0AMvRQWk9cdWriceLeojws2iI4W6ht10nYedCXG70ee+MJ/TEx7VJ5f
+Cff6GVaFu+4/qF04l/XTgi75XrzhNxQx3EptjGJg89jeJoKB219icmdSfwb8lBE
RzU/qAufZ62wf5ClRmbyMJ0rj0RqdpKI/Jg+gD/rYE9HnveOnyLkFRDY7Zn5s7H8
k+TPkw9I4xlWwDYr6cp43CX4rfGlZNoByoYat5ExYbvsjtPk9ygEYm9liKVKgIqh
riEp/3lZakla9sctllvU4m6A6mIQJQ==
=LZ1e
-----END PGP SIGNATURE-----

--Sig_/Ze/S33mgpR/AlQdumg8GhV7--
