Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC50D8481
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 01:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388033AbfJOXah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 19:30:37 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35519 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbfJOXag (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 19:30:36 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46tBVw6Jwqz9sPF;
        Wed, 16 Oct 2019 10:30:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1571182232;
        bh=KkhAF13+AU1fmW3v4q5f9RoPULwNlE60/lnEgDT63X4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vhw8+rTtIwU9NMw43InhsVvSK1fR39q3kQvMzx0NNVkMKrJZ+bSpB9VWwyB/MssXu
         Twu7hzjybPt1gF/7sadnqX0wvzwp7tsquNrRhLCmI2ZHv4XnxZdsRfqw0WrJRiqYMk
         9vf6oJPf1qr8sNE2RL4zz5yDZrbD2gIWWFTezsBkM5aQ5cvvnt3tG0co9/Mj4qrxfr
         wuUbhsxxZo0ojsJ69R2H440X3gOqF7X/H+edHWUgGiC58vDdd8pLnKImctH38BXtv9
         FIgXw+VSZqyXuhanI6Pku+pI0YU5ZiM6DM2TPI6zYg+UbHrm38uPDnjGJEdlGTypRc
         K/4Vx62VnDq1w==
Date:   Wed, 16 Oct 2019 10:30:32 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Yonghong Song <yhs@fb.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the net tree
Message-ID: <20191016103032.6738e119@canb.auug.org.au>
In-Reply-To: <20191014103232.09c09e53@canb.auug.org.au>
References: <20191014103232.09c09e53@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/QUci5Y88T80jDPgh3CjbJOP";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/QUci5Y88T80jDPgh3CjbJOP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

This is now a conflict between the net and net-next trees.

On Mon, 14 Oct 2019 10:32:32 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the bpf-next tree got a conflict in:
>=20
>   tools/lib/bpf/Makefile
>=20
> between commit:
>=20
>   1bd63524593b ("libbpf: handle symbol versioning properly for libbpf.a")
>=20
> from the net tree and commits:
>=20
>   5c26f9a78358 ("libbpf: Don't use cxx to test_libpf target")
>   793a349cd819 ("libbpf: Add C/LDFLAGS to libbpf.so and test_libpf target=
s")
>=20
> from the bpf-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc tools/lib/bpf/Makefile
> index 56ce6292071b,75b538577c17..000000000000
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@@ -143,7 -133,9 +143,9 @@@ LIB_TARGET	:=3D $(addprefix $(OUTPUT),$(L
>   LIB_FILE	:=3D $(addprefix $(OUTPUT),$(LIB_FILE))
>   PC_FILE		:=3D $(addprefix $(OUTPUT),$(PC_FILE))
>  =20
> + TAGS_PROG :=3D $(if $(shell which etags 2>/dev/null),etags,ctags)
> +=20
>  -GLOBAL_SYM_COUNT =3D $(shell readelf -s --wide $(BPF_IN) | \
>  +GLOBAL_SYM_COUNT =3D $(shell readelf -s --wide $(BPF_IN_SHARED) | \
>   			   cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | \
>   			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}' | \
>   			   sort -u | wc -l)
> @@@ -165,7 -149,7 +159,7 @@@ all: fixde
>  =20
>   all_cmd: $(CMD_TARGETS) check
>  =20
> - $(BPF_IN_SHARED): force elfdep bpfdep
>  -$(BPF_IN): force elfdep bpfdep bpf_helper_defs.h
> ++$(BPF_IN_SHARED): force elfdep bpfdep bpf_helper_defs.h
>   	@(test -f ../../include/uapi/linux/bpf.h -a -f ../../../include/uapi/l=
inux/bpf.h && ( \
>   	(diff -B ../../include/uapi/linux/bpf.h ../../../include/uapi/linux/bp=
f.h >/dev/null) || \
>   	echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' d=
iffers from latest version at 'include/uapi/linux/bpf.h'" >&2 )) || true
> @@@ -181,24 -165,26 +175,29 @@@
>   	@(test -f ../../include/uapi/linux/if_xdp.h -a -f ../../../include/uap=
i/linux/if_xdp.h && ( \
>   	(diff -B ../../include/uapi/linux/if_xdp.h ../../../include/uapi/linux=
/if_xdp.h >/dev/null) || \
>   	echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/if_xdp.h=
' differs from latest version at 'include/uapi/linux/if_xdp.h'" >&2 )) || t=
rue
>  -	$(Q)$(MAKE) $(build)=3Dlibbpf
>  +	$(Q)$(MAKE) $(build)=3Dlibbpf OUTPUT=3D$(SHARED_OBJDIR) CFLAGS=3D"$(CF=
LAGS) $(SHLIB_FLAGS)"
>  +
>  +$(BPF_IN_STATIC): force elfdep bpfdep
>  +	$(Q)$(MAKE) $(build)=3Dlibbpf OUTPUT=3D$(STATIC_OBJDIR)
>  =20
> + bpf_helper_defs.h: $(srctree)/include/uapi/linux/bpf.h
> + 	$(Q)$(srctree)/scripts/bpf_helpers_doc.py --header 		\
> + 		--file $(srctree)/include/uapi/linux/bpf.h > bpf_helper_defs.h
> +=20
>   $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
>  =20
>  -$(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN)
>  +$(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN_SHARED)
> - 	$(QUIET_LINK)$(CC) --shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSI=
ON) \
> - 				    -Wl,--version-script=3D$(VERSION_SCRIPT) $^ -lelf -o $@
> + 	$(QUIET_LINK)$(CC) $(LDFLAGS) \
> + 		--shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
> + 		-Wl,--version-script=3D$(VERSION_SCRIPT) $^ -lelf -o $@
>   	@ln -sf $(@F) $(OUTPUT)libbpf.so
>   	@ln -sf $(@F) $(OUTPUT)libbpf.so.$(LIBBPF_MAJOR_VERSION)
>  =20
>  -$(OUTPUT)libbpf.a: $(BPF_IN)
>  +$(OUTPUT)libbpf.a: $(BPF_IN_STATIC)
>   	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
>  =20
> - $(OUTPUT)test_libbpf: test_libbpf.cpp $(OUTPUT)libbpf.a
> - 	$(QUIET_LINK)$(CXX) $(INCLUDES) $^ -lelf -o $@
> + $(OUTPUT)test_libbpf: test_libbpf.c $(OUTPUT)libbpf.a
> + 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(INCLUDES) $^ -lelf -o $@
>  =20
>   $(OUTPUT)libbpf.pc:
>   	$(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
> @@@ -268,9 -259,9 +272,10 @@@ config-clean
>   	$(Q)$(MAKE) -C $(srctree)/tools/build/feature/ clean >/dev/null
>  =20
>   clean:
> - 	$(call QUIET_CLEAN, libbpf) $(RM) -rf $(TARGETS) $(CXX_TEST_TARGET) \
>  -	$(call QUIET_CLEAN, libbpf) $(RM) $(CMD_TARGETS) \
> ++	$(call QUIET_CLEAN, libbpf) $(RM) -rf $(CMD_TARGETS) \
>   		*.o *~ *.a *.so *.so.$(LIBBPF_MAJOR_VERSION) .*.d .*.cmd \
> - 		*.pc LIBBPF-CFLAGS $(SHARED_OBJDIR) $(STATIC_OBJDIR)
>  -		*.pc LIBBPF-CFLAGS bpf_helper_defs.h
> ++		*.pc LIBBPF-CFLAGS $(SHARED_OBJDIR) $(STATIC_OBJDIR) \
> ++		bpf_helper_defs.h
>   	$(call QUIET_CLEAN, core-gen) $(RM) $(OUTPUT)FEATURE-DUMP.libbpf
>  =20
>  =20

--=20
Cheers,
Stephen Rothwell

--Sig_/QUci5Y88T80jDPgh3CjbJOP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2mVpgACgkQAVBC80lX
0GxZaQf/ZU/l10xc7ENxetlqkfegPbdVp1ArZuRPD4fnSoPFIqZJLrapBGneTNLo
h1IQR8SHYq7zquAt6yDGqTfXc0Q/261L0lble53y9aY2j67MpCC0tKE5wuNgp05O
PS8bUgznhNMh31DTF18zuwRzgG9epf0TBpuEp6X8Wj+zzhYnCeBRlSx9fViqsO6P
4jnpdHRvBja2l1mRsmt12YUx305wOl0eGqClvbwgviLfj4UA8KlEXbNyZJ48AzPe
83mw4Ibp24BdR2uqda9HwTPW4nhNrKARkJq74Z+7A1ZzCqbeIu/zeJ+HVl0ABALr
St9iTbERVH92rjUdZSeNXrpow8C/gg==
=Qv3S
-----END PGP SIGNATURE-----

--Sig_/QUci5Y88T80jDPgh3CjbJOP--
