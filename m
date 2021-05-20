Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C99938BA54
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 01:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbhETXPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 19:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbhETXPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 19:15:33 -0400
X-Greylist: delayed 366 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 May 2021 16:14:09 PDT
Received: from gimli.rothwell.id.au (gimli.rothwell.id.au [IPv6:2404:9400:2:0:216:3eff:fee1:997a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBE2C061574;
        Thu, 20 May 2021 16:14:09 -0700 (PDT)
Received: from authenticated.rothwell.id.au (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.rothwell.id.au (Postfix) with ESMTPSA id 4FmQPj2vLxzyNq;
        Fri, 21 May 2021 09:07:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rothwell.id.au;
        s=201702; t=1621552075;
        bh=Unlt47Kkfklu/HTssSugfEykbEe17Uyd/D0Lfbbb2+k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rte9g4vDv1SIhAY2TXQqiAjvNCXngdEjTSX/iqRQM8GKscZUv5oB6kK0BpJddFLXj
         YnVuBZT2gpViUYToYFFRsTyAiYlTy0fsCkho7MBa4fN10ZbTLMIGKfeV58IiQOkTGJ
         LE+lgByzbIzCjFa0DLaRLCTiOA/Lz2POWzYc/UC9IIRZwnWY9kk07vk3+R9hMDWm+w
         4q3DooAxbEDLUboyx/whjOq1qFpZIFU4autj221iQ4a8pypd5WqczDTfshJsvg19Tk
         qYkEpBjAcSlXC8ZQlMqDLMXk38CkvGXxJPT0HsyyzEqBZjTRdsNUupAASizK/4RUxm
         MUHmCAoLgLbAg==
Date:   Fri, 21 May 2021 09:07:51 +1000
From:   Stephen Rothwell <sfr@rothwell.id.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     akpm@linux-foundation.org, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: mmotm 2021-05-19-23-58 uploaded
 (net/netfilter/nft_set_pipapo_avx2.c)
Message-ID: <20210521090751.51afa10f@elm.ozlabs.ibm.com>
In-Reply-To: <3d718861-28bd-dd51-82d4-96b040aa1ab4@infradead.org>
References: <20210520065918.KsmugQp47%akpm@linux-foundation.org>
        <3d718861-28bd-dd51-82d4-96b040aa1ab4@infradead.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/54qkpJW_btyh87AxEnT6H5P";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/54qkpJW_btyh87AxEnT6H5P
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Thu, 20 May 2021 15:40:54 -0700 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> on x86_64:
> (from linux-next, not mmotm)

Yeah, this is caused by a bad merge resolution by me.

> ../net/netfilter/nft_set_pipapo_avx2.c: In function =E2=80=98nft_pipapo_a=
vx2_lookup=E2=80=99:
> ../net/netfilter/nft_set_pipapo_avx2.c:1135:10: error: implicit declarati=
on of function =E2=80=98nft_pipapo_lookup=E2=80=99; did you mean =E2=80=98n=
ft_pipapo_avx2_lookup=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>    return nft_pipapo_lookup(net, set, key, ext);
>           ^~~~~~~~~~~~~~~~~

I have added this to the merge resolution today:

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter=
/nf_tables_core.h
index 789e9eadd76d..8652b2514e57 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -89,6 +89,8 @@ extern const struct nft_set_type nft_set_bitmap_type;
 extern const struct nft_set_type nft_set_pipapo_type;
 extern const struct nft_set_type nft_set_pipapo_avx2_type;
=20
+bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
+			    const u32 *key, const struct nft_set_ext **ext);
 #ifdef CONFIG_RETPOLINE
 bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
 		      const u32 *key, const struct nft_set_ext **ext);
@@ -101,8 +103,6 @@ bool nft_hash_lookup_fast(const struct net *net,
 			  const u32 *key, const struct nft_set_ext **ext);
 bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
 		     const u32 *key, const struct nft_set_ext **ext);
-bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
-			    const u32 *key, const struct nft_set_ext **ext);
 bool nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 		       const u32 *key, const struct nft_set_ext **ext);
 #else
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 9addc0b447f7..dce866d93fee 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -408,7 +408,6 @@ int pipapo_refill(unsigned long *map, int len, int rule=
s, unsigned long *dst,
  *
  * Return: true on match, false otherwise.
  */
-INDIRECT_CALLABLE_SCOPE
 bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 		       const u32 *key, const struct nft_set_ext **ext)
 {

It should apply on top of next-20210520 if you want to test it (I
haven't tested it yet, but will later today).
--=20
Cheers,
Stephen Rothwell

--Sig_/54qkpJW_btyh87AxEnT6H5P
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCm68cACgkQAVBC80lX
0GwTEQf+I/lcXs8xFLj2V8fskUhUh0ml6V76sP1fAmL1MKzIL6W60YTCmIAFNLsj
Ix6HLfIQTuEZz7JTqmJ3SCkrng4MBad0ml6zka+ZLs7VSvLgb1h2kK2WSjbMY/8k
G9v3TG67ZZ30tV3IrItwQ13Z94TQnY7s4P1ZMqhGIuWjDah5XVXT3DOFCqwALGjq
JhljLSOAyoynEfZyEzfaBVEN0Ktwao2ltV7o5igFHtGVsOPy8SiB1E5HV52gSLtk
2HQjHKqjseNCtPW6ys56iSxAJFODxf8L+/zyxqFzLC7fGqZzZa5AvRqEDo5ppvSg
PmRNA60ZvTkE4+D3sbyafNO4TgvzMg==
=B2VX
-----END PGP SIGNATURE-----

--Sig_/54qkpJW_btyh87AxEnT6H5P--
