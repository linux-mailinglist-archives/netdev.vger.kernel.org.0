Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB2E42B777
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 08:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhJMGhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 02:37:37 -0400
Received: from mout.gmx.net ([212.227.15.19]:35393 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhJMGhf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 02:37:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1634106929;
        bh=F5F5g8fZ9nGtz1JhXbQBVDXFrewkkPeVr8OAIavMkBw=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=eY21Y30xjUGMlWj02RFBl4KzTNhYgJu/GAjRK0aQbwxn5CFSsIAIs567jNxRrONqH
         GPMb5UIEQn1n3eoW3q0ZTVXMDL6zi7JbXj6e82zQo4TMHaemAY41OXHUtQ3IuvQcZp
         Cq7spvBgLxkFI8SzboPS2xc8koKqoOQYzHZ6lqd0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.fritz.box ([185.221.148.85]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M9o1v-1me6E82r5R-005mFV; Wed, 13
 Oct 2021 08:35:29 +0200
Message-ID: <0100fc6eb38b745f45cc614cee30f332c1b6456d.camel@gmx.de>
Subject: [bisected] Re: odd NFS v4.2 regression 4.4..5.15
From:   Mike Galbraith <efault@gmx.de>
To:     netdev <netdev@vger.kernel.org>
Cc:     Jeff Layton <jeff.layton@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Date:   Wed, 13 Oct 2021 08:35:29 +0200
In-Reply-To: <0367ae6905b13851d3b8494ea8f2465bcd9c3ded.camel@gmx.de>
References: <0367ae6905b13851d3b8494ea8f2465bcd9c3ded.camel@gmx.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/Ux5nem1AIEupY0+zrf7BHqOrg2zL+OMro3XHGAsrGfDedH2bc6
 30UeBfRoop15IjUL905EN1OXDkThaxArvFKYQK1OAF6uId3bs5RnSJYvJ4RqkCPh+Jepg4X
 o2lgVYHf9mSO5KIzF/g/DY6U0Ia4Fznvxz62KLgS779FvhS2ZN92qKe4XUBn8l6yXqSt0ik
 SBBsW65C5Pp+4X+c0IJxQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:B6nPFQkgWvE=:ozgL+0VsnNr0qA6rz1MQ6P
 t/T25RtfkR2/qeFCED26LmlToRLrmyS0/RnFEhpP+HU0FwyEPbBd9vCt6uI/BtoQ8+6zdIjJP
 J7yYQHaB6H+t27Kbrq27PePBosuQfDgnc4MyUC8DhC+OydMVpXQt2EQDvI1J6riEzlxuwKDNZ
 yfRt4khS5mOse+IdCVTBrdUDnURyFJBw3PwpdE3WHu+w3qmV50JUDGdivKGmbynD/GfUAirBZ
 ehL27munM2+t/OI3neKIiKZu0ZjzwOv/YCXMoUI2FpjxQa6trnK71oRM5U3wFtwPHzdEXTfnu
 9NGoD63fC7d5Y7X8I7G0mmJQXCQqXKtW6Xaa+Gs2NSj1tjnN3lMRlHK8w3Unq9eezfckmSb8I
 pLFRKmIvxEi59msuApBTXUz93GI7iINTCcVBMy/ZWEACtiUweHFF43xMfdy7oyyKG2Zzmlx6A
 rzW063aKifNCQeTL7gi+bv+W1HawOx531bFjsmUD3GHeRbjzy0V1vnv8T5WqRMiHWyXPjRnZ9
 w/xTgHH1wdefGyyQM7rHD6qokltJX2hOMTMs6MdOOwt0FRQ1WRRCkPul8Luyk4YaY61jetMSx
 Pt5ljA1TwEwrJxR0DbhDZ8c3j3Wnh+aYy0AzpDWXO/kBEIujJKNTKjodbJWZSFqrKZVMSaYmM
 RLItEOrLUsc6i7R8eh9g8aMMFx+FVzGsP6EaK1zQ1EPTvxXgd9Lyhq5DCcpKHi7oXxUFuPPHd
 7F4xPejaSGU6Qqua96N/gbujWvhxHMFEOjATEiygwQjhS7PwDXsPNmbbRrzDgGcRmDmW0Pv4i
 AHoRKTCmVzIyqSiI02UbIAjxj7QvdZJa+WDU1LjcnpSsfiLaUCNUkEwFobcXYkNdb8rM8uwmK
 p5nue1m0n5wKjHYiPdyS6QahfrK5UT5zjQJrryhrp6vEmj07I3uyQdFa3IfzaPlfc6IpkqWEt
 jMXs+aJBub++upEZXaWSxuKQpp+VpRx5kh1ucoXUyHsF1kyEBmeMENRlgAUAYGdw25Kva7mXZ
 tHoUhxdGq6SqRnT+K4K1xU+0VMyJ32amuDRaNGqCu+h4cFlvuhJdMp/TId3sil6fPYmOej5zH
 tx3K9yKq59s4ho=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-10-12 at 15:54 +0200, Mike Galbraith wrote:
> Greetings network wizards,
>
> I seem to have stumbled across a kind of odd looking NFS regression
> while looking at something unrelated.
>
> I have a few VMs that are mirrors of my desktop box, including some
> data, but they usually over-mount directories with tons of data via
> NFS, thus hang off the host like a mini-me Siamese twin for testing.
>
> In the data below, I run a script in git-daemon's home to extract RT
> patch sets with git-format-patch, on the host for reference, on the
> host in an NFS mount of itself, and the mini-me VM, where I started.
>
> Note: bonnie throughput looked fine for v4.2.
>
> host
> time su - git -c ./format-rt-patches.sh
> real=C2=A0=C2=A0=C2=A0 1m5.923s
> user=C2=A0=C2=A0=C2=A0 0m54.692s
> sys=C2=A0=C2=A0=C2=A0=C2=A0 0m11.550s
>
> NFS mount my own box, and do the same from the same spot
> time su git -c 'cd /homer/home/git;./format-rt-patches.sh'
>
> 4.4.231=C2=A0=C2=A0=C2=A0=C2=A0 v4.2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 v3
> 1=C2=A0=C2=A0 real=C2=A0=C2=A0=C2=A0 2m27.046s=C2=A0=C2=A0 2m2.059s
> =C2=A0=C2=A0=C2=A0 user=C2=A0=C2=A0=C2=A0 0m59.190s=C2=A0=C2=A0 0m58.701=
s
> =C2=A0=C2=A0=C2=A0 sys=C2=A0=C2=A0=C2=A0=C2=A0 0m41.448s=C2=A0=C2=A0 0m3=
2.541s
>
> 5.15-rc5=C2=A0=C2=A0=C2=A0 v4.2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 v3
> =C2=A0=C2=A0 real=C2=A0=C2=A0=C2=A0=C2=A0 3m14.954s=C2=A0=C2=A0 2m8.366s
> =C2=A0=C2=A0 user=C2=A0=C2=A0=C2=A0=C2=A0 0m59.901s=C2=A0=C2=A0 0m58.317=
s
> =C2=A0=C2=A0 sys=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0m52.708s=C2=A0=C2=A0 0m3=
2.313s
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vs 1=C2=A0=C2=A0 0.754=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.951
>
> repeats=C2=A0=C2=A0=C2=A0=C2=A0 v4.2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 v3
> =C2=A0=C2=A0 real=C2=A0=C2=A0=C2=A0=C2=A0 3m16.313s=C2=A0=C2=A0 2m7.940s
> =C2=A0=C2=A0 real=C2=A0=C2=A0=C2=A0=C2=A0 3m10.905s=C2=A0=C2=A0 2m8.029s

Found the v4.2 regression (for this load anyway) to have landed in 5.4.
It then bisected cleanly to either the build bug or its neighbor.

There are only 'skip'ped commits left to test.
The first bad commit could be any of:
fd4f83fd7dfb1bce2f1af51fcbaf6575f4b9d189
eb82dd393744107ebc365a53e7813c7c67cb203b
We cannot bisect more!

git bisect start
# good: [4d856f72c10ecb060868ed10ff1b1453943fc6c8] Linux 5.3
git bisect good 4d856f72c10ecb060868ed10ff1b1453943fc6c8
# bad: [219d54332a09e8d8741c1e1982f5eae56099de85] Linux 5.4
git bisect bad 219d54332a09e8d8741c1e1982f5eae56099de85
# good: [a9f8b38a071b468276a243ea3ea5a0636e848cf2] Merge tag 'for-linus-5.=
4-1' of git://github.com/cminyard/linux-ipmi
git bisect good a9f8b38a071b468276a243ea3ea5a0636e848cf2
# good: [5825a95fe92566ada2292a65de030850b5cff1da] Merge tag 'selinux-pr-2=
0190917' of git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux
git bisect good 5825a95fe92566ada2292a65de030850b5cff1da
# bad: [48acba989ed5d8707500193048d6c4c5945d5f43] Merge tag 'riscv/for-v5.=
4-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux
git bisect bad 48acba989ed5d8707500193048d6c4c5945d5f43
# good: [7bccb9f10c8f36ee791769b531ed4d28f6379aae] Merge tag 'linux-watchd=
og-5.4-rc1' of git://www.linux-watchdog.org/linux-watchdog
git bisect good 7bccb9f10c8f36ee791769b531ed4d28f6379aae
# bad: [ef129d34149ea23d0d442844fc25ae26a85589fc] selftests/net: add nette=
st to .gitignore
git bisect bad ef129d34149ea23d0d442844fc25ae26a85589fc
# bad: [9c5efe9ae7df78600c0ee7bcce27516eb687fa6e] Merge branch 'sched-urge=
nt-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 9c5efe9ae7df78600c0ee7bcce27516eb687fa6e
# good: [8bbe0dec38e147a50e9dd5f585295f7e68e0f2d0] Merge tag 'for-linus' o=
f git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect good 8bbe0dec38e147a50e9dd5f585295f7e68e0f2d0
# bad: [298fb76a5583900a155d387efaf37a8b39e5dea2] Merge tag 'nfsd-5.4' of =
git://linux-nfs.org/~bfields/linux
git bisect bad 298fb76a5583900a155d387efaf37a8b39e5dea2
# bad: [bbf2f098838aa86cee240a7a11486e0601d56a3f] nfsd: Reset the boot ver=
ifier on all write I/O errors
git bisect bad bbf2f098838aa86cee240a7a11486e0601d56a3f
# skip: [fd4f83fd7dfb1bce2f1af51fcbaf6575f4b9d189] nfsd: convert nfs4_file=
->fi_fds array to use nfsd_files
git bisect skip fd4f83fd7dfb1bce2f1af51fcbaf6575f4b9d189
# bad: [5e113224c17e2fb156b785ddbbc48a0209fddb0c] nfsd: nfsd_file cache en=
tries should be per net namespace
git bisect bad 5e113224c17e2fb156b785ddbbc48a0209fddb0c
# good: [48cd7b51258c1a158293cefb97dda988080f5e13] nfsd: hook up nfsd_read=
 to the nfsd_file cache
git bisect good 48cd7b51258c1a158293cefb97dda988080f5e13
# bad: [501cb1849f865960501d19d54e6a5af306f9b6fd] nfsd: rip out the raparm=
s cache
git bisect bad 501cb1849f865960501d19d54e6a5af306f9b6fd
# bad: [eb82dd393744107ebc365a53e7813c7c67cb203b] nfsd: convert fi_deleg_f=
ile and ls_file fields to nfsd_file
git bisect bad eb82dd393744107ebc365a53e7813c7c67cb203b
# good: [5920afa3c85ff38642f652b6e3880e79392fcc89] nfsd: hook nfsd_commit =
up to the nfsd_file cache
git bisect good 5920afa3c85ff38642f652b6e3880e79392fcc89
# only skipped commits left to test
# possible first bad commit: [eb82dd393744107ebc365a53e7813c7c67cb203b] nf=
sd: convert fi_deleg_file and ls_file fields to nfsd_file
# possible first bad commit: [fd4f83fd7dfb1bce2f1af51fcbaf6575f4b9d189] nf=
sd: convert nfs4_file->fi_fds array to use nfsd_files
# good: [5920afa3c85ff38642f652b6e3880e79392fcc89] nfsd: hook nfsd_commit =
up to the nfsd_file cache
git bisect good 5920afa3c85ff38642f652b6e3880e79392fcc89
# only skipped commits left to test
# possible first bad commit: [eb82dd393744107ebc365a53e7813c7c67cb203b] nf=
sd: convert fi_deleg_file and ls_file fields to nfsd_file
# possible first bad commit: [fd4f83fd7dfb1bce2f1af51fcbaf6575f4b9d189] nf=
sd: convert nfs4_file->fi_fds array to use nfsd_files


