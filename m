Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65324FAED6
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 18:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238514AbiDJQVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 12:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236321AbiDJQVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 12:21:50 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCAD4754D;
        Sun, 10 Apr 2022 09:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=iXhxaxOJ7zcu/qjQPnyjomESbF8vvrLASyS5P7s+x3k=; b=jmLugh90t2msM6S5E0h/SNUMBJ
        Jv6yqUTaFeAFbb7FYRdELoxxH0oWEHMbSwRjaKIKvQEbkPw5MwI9O0y+IkWMx2ARzMaeyKxVXiuoo
        behJgtO3xLf5mVDLclw4bFjFQwNqfAV/c7pgYWnHfZqUyPEWKcVZDUC46t0tvBeCMtHHhQ1gyq5um
        Sr7GOfuEE0OCvaYgG5dMli7kIWd0HlTlTKxJY6JD35a/hSo1DCHcZTGv5P8VGVH6p5k20m8mJZp71
        pyxKDXTc0Vdd/67XGATa1+IexLIkZO8eKvreUVShnE2JVRsG4XcQN6spPPsR003BDdMsBIfqxwWyC
        keHSHbGbYtWdH0Hv7tFc5WMwvNtG7XRY0Fwx+7MQ6ML2L2Unf7xZSGMYeoSv/bhxChyYRbmxUCKTq
        FQplaaFeifWf7JXk1Mdy3kXJl1sArYGawiaD5CrvL8huHA9Yro+WYkU0yKNwgyIUoE+bh2dnRIJu2
        SwqhS8oN/OWhKx9mMBMa9Kp1H/4x8uopsih9WyO+KIRKV7KCiNyFRhMhU2LD1fgi+f/W2HOMBzEiw
        6PZ/1tcH2+ksytYHCNrG9E0XvrM5UWOvuNHu8PNhuMyOEhlMzcFGz9Eh5p5Wvyf8Qppb3U51NfJ+P
        jnSF4gbokxB+HPZfHa8OjOg+xXy2OB33SqY5nyBDg=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        David Howells <dhowells@redhat.com>, Greg Kurz <groug@kaod.org>
Subject: Re: 9p fs-cache tests/benchmark (was: 9p fscache Duplicate cookie detected)
Date:   Sun, 10 Apr 2022 18:18:38 +0200
Message-ID: <1966295.VQPMLLWD4E@silver>
In-Reply-To: <9591612.lsmsJCMaJN@silver>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <3791738.ukkqOL8KQD@silver> <9591612.lsmsJCMaJN@silver>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Samstag, 9. April 2022 13:16:11 CEST Christian Schoenebeck wrote:
> On Mittwoch, 30. M=E4rz 2022 14:21:16 CEST Christian Schoenebeck wrote:
> > I made some tests & benchmarks regarding the fs-cache issue of 9p, runn=
ing
> > different kernel versions and kernel configurations in comparison.
> [...]
> > Case  Linux kernel version           .config  msize    cache  duration =
 host cpu  errors/warnings
> >
> > A)    5.17.0+[2] + msize patches[1]  debug    4186112  mmap   20m 40s  =
 ~80%      none
> > B)    5.17.0+[2] + msize patches[1]  debug    4186112  loose  31m 28s  =
 ~35%      several errors (compilation completed)
> > C)    5.17.0+[2] + msize patches[1]  debug    507904   mmap   20m 25s  =
 ~84%      none
> > D)    5.17.0+[2] + msize patches[1]  debug    507904   loose  31m 2s   =
 ~33%      several errors (compilation completed)
> > E)    5.17.0+[2]                     debug    512000   mmap   23m 45s  =
 ~75%      none
> > F)    5.17.0+[2]                     debug    512000   loose  32m 6s   =
 ~31%      several errors (compilation completed)
> > G)    5.17.0+[2]                     release  512000   mmap   23m 18s  =
 ~76%      none
> > H)    5.17.0+[2]                     release  512000   loose  32m 33s  =
 ~31%      several errors (compilation completed)
> > I)    5.17.0+[2] + msize patches[1]  release  4186112  mmap   20m 30s  =
 ~83%      none
> > J)    5.17.0+[2] + msize patches[1]  release  4186112  loose  31m 21s  =
 ~31%      several errors (compilation completed)
> > K)    5.10.84                        release  512000   mmap   39m 20s  =
 ~80%      none
> > L)    5.10.84                        release  512000   loose  13m 40s  =
 ~55%      none
> [...]
> > About the errors: I actually already see errors with cache=3Dloose and =
recent
> > kernel version just when booting the guest OS. For these tests I chose =
some
> > sources which allowed me to complete the build to capture some benchmar=
k as
> > well, I got some "soft" errors with those, but the build completed at l=
east.
> > I had other sources OTOH which did not complete though and aborted with
> > certain invalid file descriptor errors, which I obviously could not use=
 for
> > those benchmarks here.
>=20
> I used git-bisect to identify the commit that broke 9p behaviour, and it =
is
> indeed this one:
>=20
> commit eb497943fa215897f2f60fd28aa6fe52da27ca6c (HEAD, refs/bisect/bad)
> Author: David Howells <dhowells@redhat.com>
> Date:   Tue Nov 2 08:29:55 2021 +0000
>=20
>     9p: Convert to using the netfs helper lib to do reads and caching
>    =20
>     Convert the 9p filesystem to use the netfs helper lib to handle readp=
age,
>     readahead and write_begin, converting those into a common issue_op fo=
r the
>     filesystem itself to handle.  The netfs helper lib also handles readi=
ng
>     from fscache if a cache is available, and interleaving reads from both
>     sources.

I looked into the errors I get, and as far as I can see it, all misbehaviou=
rs
that I see, boil down to "Bad file descriptor" (EBADF) errors being the
originating cause.

The easiest misbehaviours on the guest system I can look into, are errors
with the git client. For instance 'git fetch origin' fails this way:

=2E..
write(3, "d16782889ee07005d1f57eb884f4a06b"..., 40) =3D 40
write(3, "\n", 1)                       =3D 1
close(3)                                =3D 0
access(".git/hooks/reference-transaction", X_OK) =3D -1 ENOENT (No such fil=
e or directory)
openat(AT_FDCWD, ".git/logs/refs/remotes/origin/master", O_WRONLY|O_CREAT|O=
_APPEND, 0666) =3D 3
openat(AT_FDCWD, "/etc/localtime", O_RDONLY|O_CLOEXEC) =3D 7
fstat(7, {st_mode=3DS_IFREG|0644, st_size=3D2326, ...}) =3D 0
fstat(7, {st_mode=3DS_IFREG|0644, st_size=3D2326, ...}) =3D 0
read(7, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\0\0\0"..., 8=
192) =3D 2326
lseek(7, -1467, SEEK_CUR)               =3D 859
read(7, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\t\0\0\0\t\0\0\0\0"..., 8=
192) =3D 1467
close(7)                                =3D 0
write(3, "d8a68c5027ef629d93b9d9519ff4da95"..., 168) =3D -1 EBADF (Bad file=
 descriptor)
=2E..
error: cannot update the ref 'refs/remotes/origin/master': unable to append=
 to '.git/logs/refs/remotes/origin/master': Bad file descriptor

I tried to manually replicate those file access operations on that
=2Egit/logs/refs/remotes/origin/master file in question, and it worked. But=
 when
I look at the strace output above, I see there is a close(3) call just befo=
re
the subsequent openat(".git/logs/refs/remotes/origin/master") call returnin=
g 3,
which makes me wonder, is this maybe a concurrency issue on file descriptor
management?

Ideas anyone?

Best regards,
Christian Schoenebeck




