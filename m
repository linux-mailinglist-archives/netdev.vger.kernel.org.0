Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA337D847B
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 01:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390264AbfJOX3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 19:29:32 -0400
Received: from ozlabs.org ([203.11.71.1]:49465 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbfJOX3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 19:29:32 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46tBTj1cHJz9sPF;
        Wed, 16 Oct 2019 10:29:29 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1571182169;
        bh=iAIPlHwxJX/D9oEfAEtu0S3Y/AKwJHu8EcJFEaO24c0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rrij5D8zOGJIMlHrmk1YKTOk1IraXn0UmwhgSNjQVhNMXPBEHglZIxfMMeHK7bjZ7
         9oUpOIev9FYX5r8UuUhqM0HqJDjaMQFWKUelIBFx73mGaYWz5cSJ3AQM1QvYNRVKQy
         Tt4/8Qn6WlFALiRJVGI1XTT5vQAD8UjcGmuh27zjTEZmZBwKVo4aj29a8QdNK6J+Ox
         DcUn9LTa94jNORQIuuPtnrYOABCuR/80QGCKU6P/b6NqbsMaM/u/6LYLWBiJrgZum1
         r7zv0SvPpZkumhKzarjYBX6+7dcMP/PaatQvb5TWdN2wqN9iLCnoozWAG96tQLzxDK
         V07fAAtTA5P6g==
Date:   Wed, 16 Oct 2019 10:29:28 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20191016102928.5a14ffb0@canb.auug.org.au>
In-Reply-To: <20191009094725.71c2b1fa@canb.auug.org.au>
References: <20191009094725.71c2b1fa@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4hiamAYigVaiJDgaqWNGcx/";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/4hiamAYigVaiJDgaqWNGcx/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

This is now a conflict between the net and net-next trees.

On Wed, 9 Oct 2019 09:47:25 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the bpf-next tree got a conflict in:
>=20
>   tools/lib/bpf/Makefile
>=20
> between commit:
>=20
>   1bd63524593b ("libbpf: handle symbol versioning properly for libbpf.a")
>=20
> from the bpf tree and commit:
>=20
>   e01a75c15969 ("libbpf: Move bpf_{helpers, helper_defs, endian, tracing}=
.h into libbpf")
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
> index 56ce6292071b,1270955e4845..000000000000
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
> @@@ -165,7 -157,7 +167,7 @@@ all: fixde
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
> @@@ -181,14 -173,15 +183,18 @@@
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
>   	$(QUIET_LINK)$(CC) --shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSI=
ON) \
>   				    -Wl,--version-script=3D$(VERSION_SCRIPT) $^ -lelf -o $@
>   	@ln -sf $(@F) $(OUTPUT)libbpf.so
> @@@ -268,9 -266,9 +279,10 @@@ config-clean
>   	$(Q)$(MAKE) -C $(srctree)/tools/build/feature/ clean >/dev/null
>  =20
>   clean:
>  -	$(call QUIET_CLEAN, libbpf) $(RM) $(TARGETS) $(CXX_TEST_TARGET) \
>  +	$(call QUIET_CLEAN, libbpf) $(RM) -rf $(TARGETS) $(CXX_TEST_TARGET) \
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

--Sig_/4hiamAYigVaiJDgaqWNGcx/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2mVlgACgkQAVBC80lX
0Gz6zQf/e+mWNivC2O6fkfqHcaeA2sm/RJAKzIRZcMNCxaDIGWkvIjb6mKZBNv+J
LpK4nDGAcNzVH+3ioSzEHDcrvJUbMzJSBuDmWIDPDHPrRuMt50YVnnQNJHaM8dAR
MMjaQs3z8SmDKxzV1kp3r+jUuJNpV8+WSVZHEAEzLAZjIsKwQVvmghvPT/mZ9z/x
2kq4k/BoGl3a4V6wnezu5BwGO0h7I8DTT+veCG+wnjE3yTqk5H6PwSQPxvSCP+Kz
6jogZX6lOKTY/QUjaOVggDwjkx5ZP85faNE6GFcLhYlMbHGCg1kuGCGws0rk1QC+
uj6qXUTgevsXfsgWdg1C2nYO7HQUvg==
=aihn
-----END PGP SIGNATURE-----

--Sig_/4hiamAYigVaiJDgaqWNGcx/--
