Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B93A21224DD
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 07:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfLQGke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 01:40:34 -0500
Received: from mout-p-101.mailbox.org ([80.241.56.151]:53806 "EHLO
        mout-p-101.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfLQGkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 01:40:32 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 47cT6M2DP7zKmbN;
        Tue, 17 Dec 2019 07:40:27 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id AVgNK5XsT0lw; Tue, 17 Dec 2019 07:40:19 +0100 (CET)
Date:   Tue, 17 Dec 2019 17:39:50 +1100
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-ia64@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-api@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>, linux-arch@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        David Drysdale <drysdale@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, linuxppc-dev@lists.ozlabs.org,
        dev@opencontainers.org, Andy Lutomirski <luto@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        libc-alpha@sourceware.org, linux-parisc@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, netdev@vger.kernel.org,
        Chanho Min <chanho.min@lge.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        linux-alpha@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        bpf@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH v18 11/13] open: introduce openat2(2) syscall
Message-ID: <20191217063950.5oqwwqz5p3bu7t2x@yavin.dot.cyphar.com>
References: <20191206141338.23338-1-cyphar@cyphar.com>
 <20191206141338.23338-12-cyphar@cyphar.com>
 <20191216192158.B9F19832924A@oldenburg2.str.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vzwczu2ztdefrrfu"
Content-Disposition: inline
In-Reply-To: <20191216192158.B9F19832924A@oldenburg2.str.redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vzwczu2ztdefrrfu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-12-16, Florian Weimer <fweimer@redhat.com> wrote:
> > diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
> > index 1d338357df8a..58c3a0e543c6 100644
> > --- a/include/uapi/linux/fcntl.h
> > +++ b/include/uapi/linux/fcntl.h
> > @@ -93,5 +93,40 @@
> > =20
> >  #define AT_RECURSIVE		0x8000	/* Apply to the entire subtree */
> > =20
> > +/*
> > + * Arguments for how openat2(2) should open the target path. If @resol=
ve is
> > + * zero, then openat2(2) operates very similarly to openat(2).
> > + *
> > + * However, unlike openat(2), unknown bits in @flags result in -EINVAL=
 rather
> > + * than being silently ignored. @mode must be zero unless one of {O_CR=
EAT,
> > + * O_TMPFILE} are set.
> > + *
> > + * @flags: O_* flags.
> > + * @mode: O_CREAT/O_TMPFILE file mode.
> > + * @resolve: RESOLVE_* flags.
> > + */
> > +struct open_how {
> > +	__aligned_u64 flags;
> > +	__u16 mode;
> > +	__u16 __padding[3]; /* must be zeroed */
> > +	__aligned_u64 resolve;
> > +};
> > +
> > +#define OPEN_HOW_SIZE_VER0	24 /* sizeof first published struct */
> > +#define OPEN_HOW_SIZE_LATEST	OPEN_HOW_SIZE_VER0
> > +
> > +/* how->resolve flags for openat2(2). */
> > +#define RESOLVE_NO_XDEV		0x01 /* Block mount-point crossings
> > +					(includes bind-mounts). */
> > +#define RESOLVE_NO_MAGICLINKS	0x02 /* Block traversal through procfs-s=
tyle
> > +					"magic-links". */
> > +#define RESOLVE_NO_SYMLINKS	0x04 /* Block traversal through all symlin=
ks
> > +					(implies OEXT_NO_MAGICLINKS) */
> > +#define RESOLVE_BENEATH		0x08 /* Block "lexical" trickery like
> > +					"..", symlinks, and absolute
> > +					paths which escape the dirfd. */
> > +#define RESOLVE_IN_ROOT		0x10 /* Make all jumps to "/" and ".."
> > +					be scoped inside the dirfd
> > +					(similar to chroot(2)). */
> > =20
> >  #endif /* _UAPI_LINUX_FCNTL_H */
>=20
> Would it be possible to move these to a new UAPI header?
>=20
> In glibc, we currently do not #include <linux/fcntl.h>.  We need some of
> the AT_* constants in POSIX mode, and the header is not necessarily
> namespace-clean.  If there was a separate header for openat2 support, we
> could use that easily, and we would only have to maintain the baseline
> definitions (which never change).

Sure, (assuming nobody objects) I can move it to "linux/openat2.h".

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--vzwczu2ztdefrrfu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXfh4MQAKCRCdlLljIbnQ
EvJ/AP9e+RbEhnKlfXeue8RftgpgyUu8To5+ZOcmuoKfUFVefgEAmch0tDU0glq6
a0g2iw25N8tzxhAIzQpE/p2HRuzcPgo=
=p/bo
-----END PGP SIGNATURE-----

--vzwczu2ztdefrrfu--
