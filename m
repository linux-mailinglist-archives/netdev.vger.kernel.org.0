Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D921C420A63
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 13:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhJDLy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 07:54:27 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:39738 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhJDLy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 07:54:27 -0400
Received: by mail-wr1-f53.google.com with SMTP id r18so2997144wrg.6
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 04:52:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=19fkFAttoUSFu+yKIiAt4SRf+RddrZAJU4ffvkF68e8=;
        b=r3RCfeJ+KPZZDoHrrKBlNlmBLnXIL/69POoYe+n6WQifPBWhbA4UQY0k1T1Ptz5KGH
         4nHisGImCU7i5WFo0gv/tKP7uuMTx15ck+BNSrxJaLWj86zPvQpJQK0Vst/heXtdAb5r
         GwrVvkdQK0sZlgEzIam7g3DQIfQ2jmH+3SpZeWf/ZEV6T7t2rPASPzwrDDNWZvgAEoYN
         6j3zd9CErVcvNj+bSHjTPK4DidPOHfHZfQE/3ktMZBvSwrnYdyVSnhiJtHcUZZJa6MVo
         0X4KV77gJth3QJHn9mVaJILdHm23zsYwkMNYcVLlheRdSzK3CeC7/j4pXzpZ/K9RfqQ1
         Bg9w==
X-Gm-Message-State: AOAM530gtMvB5CXjgMoTgG+pGBX8ABPcQtlECmVAdM1bfkJPE97OAbhh
        JwaAlacjwxDfg3nWqXiXWz0=
X-Google-Smtp-Source: ABdhPJxQ+E3zzs7q3yUdjWgcAfQiX1WlW5SC85/sLFl4pSvkMpr93ntHBA261LakzsDCaZS0xA5wRg==
X-Received: by 2002:a5d:47a4:: with SMTP id 4mr14000922wrb.374.1633348357425;
        Mon, 04 Oct 2021 04:52:37 -0700 (PDT)
Received: from localhost ([137.220.125.106])
        by smtp.gmail.com with ESMTPSA id x21sm16917220wmc.14.2021.10.04.04.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 04:52:36 -0700 (PDT)
Message-ID: <6363502d3ce806acdbc7ba194ddc98d3fac064de.camel@debian.org>
Subject: Re: [PATCH 2/2 iproute2] configure: add the --libdir param
From:   Luca Boccassi <bluca@debian.org>
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Date:   Mon, 04 Oct 2021 12:52:35 +0100
In-Reply-To: <1047327c1350db0fe3df84d7eb96bf45955fa795.1633191885.git.aclaudi@redhat.com>
References: <cover.1633191885.git.aclaudi@redhat.com>
         <1047327c1350db0fe3df84d7eb96bf45955fa795.1633191885.git.aclaudi@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-f6kqLmVJ8BvyRQpgN5gD"
User-Agent: Evolution 3.38.3-1+plugin 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-f6kqLmVJ8BvyRQpgN5gD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2021-10-02 at 18:41 +0200, Andrea Claudi wrote:
> This commit allows users/packagers to choose a lib directory to store
> iproute2 lib files.
>=20
> At the moment iproute2 ship lib files in /usr/lib and offers no way to
> modify this setting. However, according to the FHS, distros may choose
> "one or more variants of the /lib directory on systems which support
> more than one binary format" (e.g. /usr/lib64 on Fedora).
>=20
> As Luca states in commit a3272b93725a ("configure: restore backward
> compatibility"), packaging systems may assume that 'configure' is from
> autotools, and try to pass it some parameters.
>=20
> Allowing the '--libdir=3D/path/to/libdir' syntax, we can use this to our
> advantage, and let the lib directory to be chosen by the distro
> packaging system.
>=20
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
> =C2=A0Makefile  |  7 ++++---
> =C2=A0configure | 21 +++++++++++++++++++++
> =C2=A02 files changed, 25 insertions(+), 3 deletions(-)
>=20
> diff --git a/Makefile b/Makefile
> index 5bc11477..45655ca4 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,6 +1,8 @@
> =C2=A0# SPDX-License-Identifier: GPL-2.0
> =C2=A0# Top level Makefile for iproute2
> =C2=A0
>=20
> +-include config.mk
> +
> =C2=A0ifeq ("$(origin V)", "command line")
> =C2=A0VERBOSE =3D $(V)
> =C2=A0endif
> @@ -13,7 +15,6 @@ MAKEFLAGS +=3D --no-print-directory
> =C2=A0endif
> =C2=A0
>=20
> =C2=A0PREFIX?=3D/usr
> -LIBDIR?=3D$(PREFIX)/lib
> =C2=A0SBINDIR?=3D/sbin
> =C2=A0CONFDIR?=3D/etc/iproute2
> =C2=A0NETNS_RUN_DIR?=3D/var/run/netns
> @@ -60,7 +61,7 @@ SUBDIRS=3Dlib ip tc bridge misc netem genl tipc devlink=
 rdma dcb man vdpa
> =C2=A0LIBNETLINK=3D../lib/libutil.a ../lib/libnetlink.a
> =C2=A0LDLIBS +=3D $(LIBNETLINK)
> =C2=A0
>=20
> -all: config
> +all: config.mk
> =C2=A0	@set -e; \
> =C2=A0	for i in $(SUBDIRS); \
> =C2=A0	do echo; echo $$i; $(MAKE) -C $$i; done
> @@ -80,7 +81,7 @@ help:
> =C2=A0	@echo "Make Arguments:"
> =C2=A0	@echo " V=3D[0|1]             - set build verbosity level"
> =C2=A0
>=20
> -config:
> +config.mk:
> =C2=A0	@if [ ! -f config.mk -o configure -nt config.mk ]; then \
> =C2=A0		sh configure $(KERNEL_INCLUDE); \
> =C2=A0	fi
> diff --git a/configure b/configure
> index f0c81ee1..a1b0261a 100755
> --- a/configure
> +++ b/configure
> @@ -148,6 +148,19 @@ EOF
> =C2=A0	rm -f $TMPDIR/ipttest.c $TMPDIR/ipttest
> =C2=A0}
> =C2=A0
>=20
> +check_lib_dir()
> +{
> +	echo -n "lib directory: "
> +	if [ -n "$LIB_DIR" ]; then
> +		echo "$LIB_DIR"
> +		echo "LIBDIR:=3D$LIB_DIR" >> $CONFIG
> +		return
> +	fi
> +
> +	echo "/usr/lib"
> +	echo "LIBDIR:=3D/usr/lib" >> $CONFIG
> +}
> +
> =C2=A0check_ipt()
> =C2=A0{
> =C2=A0	if ! grep TC_CONFIG_XT $CONFIG > /dev/null; then
> @@ -486,6 +499,7 @@ usage()
> =C2=A0	cat <<EOF
> =C2=A0Usage: $0 [OPTIONS]
> =C2=A0	--include_dir		Path to iproute2 include dir
> +	--libdir		Path to iproute2 lib dir
> =C2=A0	--libbpf_dir		Path to libbpf DESTDIR
> =C2=A0	--libbpf_force		Enable/disable libbpf by force. Available options:
> =C2=A0				  on: require link against libbpf, quit config if no libbpf sup=
port
> @@ -507,6 +521,12 @@ else
> =C2=A0			--include_dir=3D*)
> =C2=A0				INCLUDE=3D"${1#*=3D}"
> =C2=A0				shift ;;
> +			--libdir)
> +				LIB_DIR=3D"$2"
> +				shift 2 ;;
> +			--libdir=3D*)
> +				LIB_DIR=3D"${1#*=3D}"
> +				shift ;;
> =C2=A0			--libbpf_dir)
> =C2=A0				LIBBPF_DIR=3D"$2"
> =C2=A0				shift 2 ;;
> @@ -559,6 +579,7 @@ if ! grep -q TC_CONFIG_NO_XT $CONFIG; then
> =C2=A0fi
> =C2=A0
>=20
> =C2=A0echo
> +check_lib_dir
> =C2=A0if ! grep -q TC_CONFIG_NO_XT $CONFIG; then
> =C2=A0	echo -n "iptables modules directory: "
> =C2=A0	check_ipt_lib_dir

	./configure --build=3Dx86_64-linux-gnu --prefix=3D/usr --
includedir=3D\${prefix}/include --mandir=3D\${prefix}/share/man --
infodir=3D\${prefix}/share/info --sysconfdir=3D/etc --localstatedir=3D/var =
--
disable-option-checking --disable-silent-rules --
libdir=3D\${prefix}/lib/x86_64-linux-gnu --runstatedir=3D/run --disable-
maintainer-mode --disable-dependency-tracking
TC schedulers
 ATM	yes
 IPT	using xtables
 IPSET  yes

lib directory: ${prefix}/lib/x86_64-linux-gnu


But you end up with:

/lib/x86_64-linux-gnu/tc

/usr disappears somewhere?

--=20
Kind regards,
Luca Boccassi

--=-f6kqLmVJ8BvyRQpgN5gD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCSqx93EIPGOymuRKGv37813JB4FAmFa6wMACgkQKGv37813
JB6iAw/9H+tsAXQzVVOS3R/KS7WJeZA9LgnJWeqqaL2HjwgsZdvzL8oKMEmhppOQ
1avbvuDlstcWpSezNNqNbQLFGPMnz4TLydq9yQXQccHvxlBBu/9pUGQ1J06OTBNI
tDKIGKNwhrZQmZ8wC9siAAoTZFkzUzD7+RRZFcy0gsl7E/W1sRCiyVECfvsfqEYg
Odk8QKVmWADFS1BkpEAkM4JdGKMuYZAkT/5HL1w0TOs60VAVlsWwBM1klYMnAQmw
CAsXx5mD9EXW0x2BQVzrMyUttC0CFwYk7/Aw/GvoCbKD2W5md/gw6DOYB4m9jkJD
L860yMZvHe87KuLgTW3zMKqCNY9SsTcTUEE6scbL5pdMzeXmdMOxxqPj4iSGJWwO
3BbibOjmn4w/cYHh0EyWYtxi54Lz6PEQcqsupitcJXltA8oR6NqHqV3nSHnUjUag
eCNeVzfOGqCyKJdAj3Zn5MmEVQ0aWUBm4CQgRqMxhiD2pD7hQNgIblS+5iaKvqwC
sOn8R4SYeCukuFh6Z9k2icSCryyteSuFDuX3K42XjfeIP60Rt9irW7CvUuDTvxKl
gKPNiYz0U24uZdw3l+sPFy1dWmwl31tQOH7gSL7L9OaeUzw8hklDUV39qoBJchJn
rIlRGmi4mbmhAWL2nuq3/BboXXqbQkYiV4xLrxZhOvKTMqqxG3Q=
=2kb/
-----END PGP SIGNATURE-----

--=-f6kqLmVJ8BvyRQpgN5gD--
