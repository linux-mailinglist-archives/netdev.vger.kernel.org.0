Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA4A5128D4
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 03:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbiD1Bct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 21:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240595AbiD1Bcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 21:32:43 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B3691551;
        Wed, 27 Apr 2022 18:29:30 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KpdMF1M1xz4xXW;
        Thu, 28 Apr 2022 11:29:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1651109369;
        bh=J3PC8BT4O7Zh9cqygjqB/WcdmNV3sTiaqycF+54L+wc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oD2vZ48S4gqcJcEvO/g3NtrStH+HqvEFHcn5Mi113H+Cdl2jxspB/xIut127gpcIU
         9EGu35hrR11Fbyc0mhsoPDd/OA8NPDnlz81JAEK1TedKBktxxsgjE51WNiVFkxwZR5
         ZYRgEqyA+RRdlWy//ff+EYeGldRvm3EuIlLqvw49pbss5EgPfd2lL7V2VM84wP1sp6
         zM9m/4F7q0S3OlQIUhSw1AycyVDDBsLa7gSa0xPecykbwLEAwHkT0GzsFSXZ+BCAa8
         RLk45BH2diVb5M8q43voNDzDX+KjLSBwuaupo3R431V08puR92/qVdSd3j2wrDeNTW
         zQDMSYsd9E3Cw==
Date:   Thu, 28 Apr 2022 11:29:28 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jeffrey Ji <jeffreyji@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220428112928.0f87bfb6@canb.auug.org.au>
In-Reply-To: <20220428111903.5f4304e0@canb.auug.org.au>
References: <20220428111903.5f4304e0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RVzIgeIA+N7n79uxaHsHx+v";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/RVzIgeIA+N7n79uxaHsHx+v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 28 Apr 2022 11:19:03 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> diff --cc net/core/dev.c
> index 1461c2d9dec8,611bd7197064..000000000000
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@@ -10352,9 -10409,10 +10405,10 @@@ struct rtnl_link_stats64 *dev_get_st=
ats
>  =20
>   		for_each_possible_cpu(i) {
>   			core_stats =3D per_cpu_ptr(p, i);
>  -			storage->rx_dropped +=3D local_read(&core_stats->rx_dropped);
>  -			storage->tx_dropped +=3D local_read(&core_stats->tx_dropped);
>  -			storage->rx_nohandler +=3D local_read(&core_stats->rx_nohandler);
>  -			storage->rx_otherhost_dropped +=3D local_read(&core_stats->rx_otherh=
ost_dropped);
>  +			storage->rx_dropped +=3D READ_ONCE(core_stats->rx_dropped);
>  +			storage->tx_dropped +=3D READ_ONCE(core_stats->tx_dropped);
>  +			storage->rx_nohandler +=3D READ_ONCE(core_stats->rx_nohandler);
> ++			storage->rx_otherhost_dropped +=3D READ_ONCE(&core_stats->rx_otherho=
st_dropped);
                                                                   ^
I failed to remove the '&'.  I have done that now to fix up my merge
resolution.

--=20
Cheers,
Stephen Rothwell

--Sig_/RVzIgeIA+N7n79uxaHsHx+v
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJp7fgACgkQAVBC80lX
0GweiQf/aGwimwaF55gLormyNKzFWDyHh9Usz3bGwQ6PLHQtS9DnLHRdepP3kXbW
2rCcCUK1/ylij0trSnepct7yJgrINTNJ6Gjia0Aw11m9Y4GK69De8vX1I9xSEUV8
FX96e69vgt3qkQLHB6qUa5wnj5n567NA5V2ISwcRQmakAK2gVGxIVHUEOHuzMZPR
63Sqk/p03/X4DhF4uc2tLZYzUEQRvhOp8RhEhbw1wmxgpXuVNjMWJ8+f7UWoDq6V
43oOB9caZQXfAJQ4QVC3XcYhFWdDc1v22RV+2qwj49uIWB7bOYrcsRURGox03MlG
RG5x0NjeaSQaaR8zPWj1bGrNlc4gyg==
=0HVP
-----END PGP SIGNATURE-----

--Sig_/RVzIgeIA+N7n79uxaHsHx+v--
