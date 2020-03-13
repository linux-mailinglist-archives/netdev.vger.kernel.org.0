Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82EAB183F3A
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 04:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgCMC7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 22:59:03 -0400
Received: from ozlabs.org ([203.11.71.1]:32957 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgCMC7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 22:59:02 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48dr4c1vXSz9sSR;
        Fri, 13 Mar 2020 13:58:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1584068337;
        bh=eyHYl/VZi/bI52f96BJJT+97pkAhEV0KuT6cgDFwNWs=;
        h=Date:From:To:Cc:Subject:From;
        b=ZE10qfSzR0apBp+6rSIIUHZpJx/iCbCamBFNkCfqorFtN1u2uUG7e+iIO/P5H5Xnt
         WTlTAz7rFqp9418bWfdnS76r3P426GD4uFK37N6mnUengR36XaR5BcOCxZRSplN/H5
         8V4WIJAeYAJ8g3ZTE2DKm2sbS5zxhcKkRkN7VaqTsz/+z7X5QmIImr+dAADKxqZ/sb
         VibZvGDTnGHywRMHBSaLoBsCRpM8CpigHi9CPgU8BELGWsvU6VDt0WbUNYTv4v2R5I
         OOsIzodQvwthSnBWobftkj4Ii9af1MV4Pfz15HdcqiTgaePfsDs+0qgWPll8C28PfO
         Zxc+VXeTb9myA==
Date:   Fri, 13 Mar 2020 13:58:50 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Kitt <steve@sk2.org>
Subject: linux-next: manual merge of the bpf-next tree with the jc_docs tree
Message-ID: <20200313135850.2329f480@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/B866d5KWyCwkbn6zFqU24Jy";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/B866d5KWyCwkbn6zFqU24Jy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  Documentation/admin-guide/sysctl/kernel.rst

between commit:

  a3cb66a50852 ("docs: pretty up sysctl/kernel.rst")

from the jc_docs tree and commit:

  c480a3b79cbc ("docs: sysctl/kernel: Document BPF entries")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc Documentation/admin-guide/sysctl/kernel.rst
index 335696d3360d,9e1417628572..000000000000
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@@ -98,53 -170,64 +98,67 @@@ bootloader_version (x86 only
  The complete bootloader version number.  In the example above, this
  file will contain the value 564 =3D 0x234.
 =20
 -See the type_of_loader and ext_loader_ver fields in
 -Documentation/x86/boot.rst for additional information.
 +See the ``type_of_loader`` and ``ext_loader_ver`` fields in
 +:doc:`/x86/boot` for additional information.
 =20
 =20
+ bpf_stats_enabled
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+=20
+ Controls whether the kernel should collect statistics on BPF programs
+ (total time spent running, number of times run...). Enabling
+ statistics causes a slight reduction in performance on each program
+ run. The statistics can be seen using ``bpftool``.
+=20
+ =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ 0 Don't collect statistics (default).
+ 1 Collect statistics.
+ =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+=20
+=20
 -cap_last_cap:
 -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 +cap_last_cap
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 =20
  Highest valid capability of the running kernel.  Exports
 -CAP_LAST_CAP from the kernel.
 +``CAP_LAST_CAP`` from the kernel.
 =20
 =20
 -core_pattern:
 -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 +core_pattern
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 =20
 -core_pattern is used to specify a core dumpfile pattern name.
 +``core_pattern`` is used to specify a core dumpfile pattern name.
 =20
  * max length 127 characters; default value is "core"
 -* core_pattern is used as a pattern template for the output filename;
 -  certain string patterns (beginning with '%') are substituted with
 -  their actual values.
 -* backward compatibility with core_uses_pid:
 +* ``core_pattern`` is used as a pattern template for the output
 +  filename; certain string patterns (beginning with '%') are
 +  substituted with their actual values.
 +* backward compatibility with ``core_uses_pid``:
 =20
 -	If core_pattern does not include "%p" (default does not)
 -	and core_uses_pid is set, then .PID will be appended to
 +	If ``core_pattern`` does not include "%p" (default does not)
 +	and ``core_uses_pid`` is set, then .PID will be appended to
  	the filename.
 =20
 -* corename format specifiers::
 -
 -	%<NUL>	'%' is dropped
 -	%%	output one '%'
 -	%p	pid
 -	%P	global pid (init PID namespace)
 -	%i	tid
 -	%I	global tid (init PID namespace)
 -	%u	uid (in initial user namespace)
 -	%g	gid (in initial user namespace)
 -	%d	dump mode, matches PR_SET_DUMPABLE and
 -		/proc/sys/fs/suid_dumpable
 -	%s	signal number
 -	%t	UNIX time of dump
 -	%h	hostname
 -	%e	executable filename (may be shortened)
 -	%E	executable path
 -	%<OTHER> both are dropped
 +* corename format specifiers
 +
 +	=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
 +	%<NUL>		'%' is dropped
 +	%%		output one '%'
 +	%p		pid
 +	%P		global pid (init PID namespace)
 +	%i		tid
 +	%I		global tid (init PID namespace)
 +	%u		uid (in initial user namespace)
 +	%g		gid (in initial user namespace)
 +	%d		dump mode, matches ``PR_SET_DUMPABLE`` and
 +			``/proc/sys/fs/suid_dumpable``
 +	%s		signal number
 +	%t		UNIX time of dump
 +	%h		hostname
 +	%e		executable filename (may be shortened)
 +	%E		executable path
 +	%c		maximum size of core file by resource limit RLIMIT_CORE
 +	%<OTHER>	both are dropped
 +	=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
 =20
  * If the first character of the pattern is a '|', the kernel will treat
    the rest of the pattern as a command to run.  The core dump will be
@@@ -1166,21 -1137,29 +1180,31 @@@ NMI switch that most IA32 servers have=20
  example.  If a system hangs up, try pressing the NMI switch.
 =20
 =20
+ unprivileged_bpf_disabled
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
+=20
+ Writing 1 to this entry will disable unprivileged calls to ``bpf()``;
+ once disabled, calling ``bpf()`` without ``CAP_SYS_ADMIN`` will return
+ ``-EPERM``.
+=20
+ Once set, this can't be cleared.
+=20
+=20
 -watchdog:
 -=3D=3D=3D=3D=3D=3D=3D=3D=3D
 +watchdog
 +=3D=3D=3D=3D=3D=3D=3D=3D
 =20
  This parameter can be used to disable or enable the soft lockup detector
 -_and_ the NMI watchdog (i.e. the hard lockup detector) at the same time.
 -
 -   0 - disable both lockup detectors
 +*and* the NMI watchdog (i.e. the hard lockup detector) at the same time.
 =20
 -   1 - enable both lockup detectors
 +=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
 +0 Disable both lockup detectors.
 +1 Enable both lockup detectors.
 +=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
 =20
  The soft lockup detector and the NMI watchdog can also be disabled or
 -enabled individually, using the soft_watchdog and nmi_watchdog parameters.
 -If the watchdog parameter is read, for example by executing::
 +enabled individually, using the ``soft_watchdog`` and ``nmi_watchdog``
 +parameters.
 +If the ``watchdog`` parameter is read, for example by executing::
 =20
     cat /proc/sys/kernel/watchdog
 =20

--Sig_/B866d5KWyCwkbn6zFqU24Jy
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5q9uoACgkQAVBC80lX
0GwgOQf/WtQIrcYqrnk0tzqAPxe/2IidkpjJGB+dKLr/wlRb309xZxuuYVb/g23T
X+XY6d357H73qCnF7hSSLhlM8xcrzeb+vc3UipLYGCL/2zWSfj8tumuoru1OoY6A
ArzlzrOFf57NxJCVzK37MQZYOYMZuqAJG8FwX3JrsZ3BC24l/2V8ptzjqkvIBIPR
XmZxXVk6sTcUVbzN9+vvEtQmIH/bTz0jd7wK+NL0124H1PR1lX0JXXvcJ8SkOF8G
1Ft2cj6Iay39o5XE2v5iDni2IdBxvXgxYcrs5rGbhX+/Do3o/AR4GwUHphq7UZ1h
vB3jjLJYw7drT2U2Q9B9rIqFccXOSg==
=laua
-----END PGP SIGNATURE-----

--Sig_/B866d5KWyCwkbn6zFqU24Jy--
