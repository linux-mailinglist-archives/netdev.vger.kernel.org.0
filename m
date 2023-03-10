Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB4B6B34AC
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 04:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjCJDTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 22:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjCJDS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 22:18:59 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F846FAF97;
        Thu,  9 Mar 2023 19:18:57 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id ce7so2808885pfb.9;
        Thu, 09 Mar 2023 19:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678418336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rsCnFJ8PSGUzFdCzTiLh7Z1kzISQTZaHfvqBt6EF9ZU=;
        b=F0mg0KC7a0wv8F1WT5DmHtrb7pJvxGTZsLveZUhw3z6Eb+PB4Zb02c+MckQ2BJ2fZS
         WKviogH/Zf0ss0WMs5bedNJiXGu+9FJJ4tJgQoEpAiZKihS7Mb2bp8MObEmwzTpESzqX
         eYCMe0S7DH/xDdCGTTRG9M1n6z0jQl6KvvpksmhRbkqDUYsGLhee2pKD6wG+taS4G/zl
         imcgeenfAhIza6djkXz3a812+cyyhSYSibDyiYfPyfbmRVwRVQLKOmarFTYe9vZdTg3Q
         crbp624fKUcF6MmlF6+yjMNs4xK31rero24nfp/ASX4TcUbC0tMOhDpHcmP8WDMz8GTL
         9UvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678418336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rsCnFJ8PSGUzFdCzTiLh7Z1kzISQTZaHfvqBt6EF9ZU=;
        b=bUIl7NWddCt3/rLe0wMXLb8uuy2p6+MdVnYmqXdW6oY9H7XANN2Dc0vP9DiTOImGC9
         zgNMn0xaCEWau3yD6aFLJjZf+7zaTU60vBuQdLB3ES95V1tNIrKnacliqxoyEwxKhA9Q
         xbAnzcvPKSn5RmLk7zLIFjNQ5v76avsl8OS6k/GitphGhGOgeAG+OGulqoJVwAabXfTM
         D30kvMRE4UU+AmfYEKUemjheNHBeXJNKE1iuMVwrJVj6r/gPzqu/GgJBn3Re0EQ5WvO/
         j9secGGpd9DrMdFtHO0F+Bug1ZENmDXIK9KQSi2K6dAl0+wUrAEV/YIVU6+koj07+q4e
         D/cw==
X-Gm-Message-State: AO0yUKXQfQYemaYNTSVLNmVsWUP7HB9smYCajaiq6qPYabCcwuIK1CT8
        I9PuHGXSP+NYZYcuyVCTv7g=
X-Google-Smtp-Source: AK7set+iVUu6nuuCPTwGgCWPTBA4O6HZ276dcLjAxz9AFOIAnvFUofT57czHJWT/E37dXu5MrFKE2w==
X-Received: by 2002:a05:6a00:ce:b0:5dc:fa22:1bd9 with SMTP id e14-20020a056a0000ce00b005dcfa221bd9mr18878923pfj.23.1678418336504;
        Thu, 09 Mar 2023 19:18:56 -0800 (PST)
Received: from debian.me (subs03-180-214-233-23.three.co.id. [180.214.233.23])
        by smtp.gmail.com with ESMTPSA id e11-20020aa78c4b000000b005a87d636c70sm285961pfd.130.2023.03.09.19.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 19:18:55 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 1620A106628; Fri, 10 Mar 2023 10:18:51 +0700 (WIB)
Date:   Fri, 10 Mar 2023 10:18:51 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     David Vernet <void@manifault.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <ZAqhm/VFjju2aOCP@debian.me>
References: <20230307095812.236eb1be@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6PcdzRuw3Y4u/5hI"
Content-Disposition: inline
In-Reply-To: <20230307095812.236eb1be@canb.auug.org.au>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6PcdzRuw3Y4u/5hI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 07, 2023 at 09:58:12AM +1100, Stephen Rothwell wrote:
> Hi all,
>=20
> Today's linux-next merge of the bpf-next tree got a conflict in:
>=20
>   Documentation/bpf/bpf_devel_QA.rst
>=20
> between commit:
>=20
>   b7abcd9c656b ("bpf, doc: Link to submitting-patches.rst for general pat=
ch submission info")
>=20
> from the bpf tree and commit:
>=20
>   d56b0c461d19 ("bpf, docs: Fix link to netdev-FAQ target")
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
> diff --cc Documentation/bpf/bpf_devel_QA.rst
> index b421d94dc9f2,5f5f9ccc3862..000000000000
> --- a/Documentation/bpf/bpf_devel_QA.rst
> +++ b/Documentation/bpf/bpf_devel_QA.rst
> @@@ -684,8 -684,12 +684,8 @@@ when
>  =20
>  =20
>   .. Links
> - .. _netdev-FAQ: Documentation/process/maintainer-netdev.rst
>  -.. _Documentation/process/: https://www.kernel.org/doc/html/latest/proc=
ess/
> + .. _netdev-FAQ: https://www.kernel.org/doc/html/latest/process/maintain=
er-netdev.html
>   .. _selftests:
>      https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/t=
ree/tools/testing/selftests/bpf/
>  -.. _Documentation/dev-tools/kselftest.rst:
>  -   https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html
>  -.. _Documentation/bpf/btf.rst: btf.rst
>  =20
>   Happy BPF hacking!

I think the correct solution is to instead use internal link to netdev FAQ,
to be consistent with my change in bpf tree:

---- >8 ----
diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_dev=
el_QA.rst
index 5f5f9ccc3862b4..e523991da9e0ce 100644
--- a/Documentation/bpf/bpf_devel_QA.rst
+++ b/Documentation/bpf/bpf_devel_QA.rst
@@ -128,7 +128,7 @@ into the bpf-next tree will make their way into net-nex=
t tree. net and
 net-next are both run by David S. Miller. From there, they will go
 into the kernel mainline tree run by Linus Torvalds. To read up on the
 process of net and net-next being merged into the mainline tree, see
-the `netdev-FAQ`_.
+the :doc:`netdev-FAQ </process/maintainer-netdev>`.
=20
=20
=20
@@ -147,7 +147,8 @@ request)::
 Q: How do I indicate which tree (bpf vs. bpf-next) my patch should be appl=
ied to?
 --------------------------------------------------------------------------=
-------
=20
-A: The process is the very same as described in the `netdev-FAQ`_,
+A: The process is the very same as described in the
+:doc:`netdev-FAQ </process/maintainer-netdev>`,
 so please read up on it. The subject line must indicate whether the
 patch is a fix or rather "next-like" content in order to let the
 maintainers know whether it is targeted at bpf or bpf-next.
@@ -206,8 +207,8 @@ ii) run extensive BPF test suite and
 Once the BPF pull request was accepted by David S. Miller, then
 the patches end up in net or net-next tree, respectively, and
 make their way from there further into mainline. Again, see the
-`netdev-FAQ`_ for additional information e.g. on how often they are
-merged to mainline.
+:doc:`netdev-FAQ </process/maintainer-netdev>` for additional
+information e.g. on how often they are merged to mainline.
=20
 Q: How long do I need to wait for feedback on my BPF patches?
 -------------------------------------------------------------
@@ -230,7 +231,8 @@ Q: Are patches applied to bpf-next when the merge windo=
w is open?
 -----------------------------------------------------------------
 A: For the time when the merge window is open, bpf-next will not be
 processed. This is roughly analogous to net-next patch processing,
-so feel free to read up on the `netdev-FAQ`_ about further details.
+so feel free to read up on the
+:doc:`netdev-FAQ </process/maintainer-netdev>` about further details.
=20
 During those two weeks of merge window, we might ask you to resend
 your patch series once bpf-next is open again. Once Linus released
@@ -394,7 +396,7 @@ netdev kernel mailing list in Cc and ask for the fix to=
 be queued up:
   netdev@vger.kernel.org
=20
 The process in general is the same as on netdev itself, see also the
-`netdev-FAQ`_.
+:doc:`netdev-FAQ </process/maintainer-netdev>`.
=20
 Q: Do you also backport to kernels not currently maintained as stable?
 ----------------------------------------------------------------------
@@ -410,7 +412,7 @@ Q: The BPF patch I am about to submit needs to go to st=
able as well
 What should I do?
=20
 A: The same rules apply as with netdev patch submissions in general, see
-the `netdev-FAQ`_.
+the :doc:`netdev-FAQ </process/maintainer-netdev>`.
=20
 Never add "``Cc: stable@vger.kernel.org``" to the patch description, but
 ask the BPF maintainers to queue the patches instead. This can be done
@@ -685,7 +687,6 @@ when:
=20
 .. Links
 .. _Documentation/process/: https://www.kernel.org/doc/html/latest/process/
-.. _netdev-FAQ: https://www.kernel.org/doc/html/latest/process/maintainer-=
netdev.html
 .. _selftests:
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/tools/testing/selftests/bpf/
 .. _Documentation/dev-tools/kselftest.rst:


Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--6PcdzRuw3Y4u/5hI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAqhkgAKCRD2uYlJVVFO
o9tbAP96T3EuJs1K2w/DPLlZOJf3i6hR/yV6W7gd20/+W9d9NwEAtd5Djc5Fc5KQ
OHRb1SbicIIhspeBQbBpSxOIobeSzwI=
=AnfF
-----END PGP SIGNATURE-----

--6PcdzRuw3Y4u/5hI--
