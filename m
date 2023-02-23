Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A0A6A11CF
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 22:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjBWVRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 16:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBWVRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 16:17:41 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADADD227B7
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 13:17:40 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5406B20BBE;
        Thu, 23 Feb 2023 21:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1677187059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1BrMJiktlM41NGZIyCSlXr+BlunmWEARe6FC2E44Xmk=;
        b=gFSAfZnxv6Wc1ExNF6pwyVneJJP+DNxOtwMeMgqWdtDMyqdWDrCExvrWmSHT0cput4qJmp
        oY8Wtygy5x9mrSis5mu9aVaaqv91KrHmC2hSWH9lyYYlvnWfbaPGtXLBZu/LVmhJY60Xx/
        HWzkNhdvZvEpFfGwzqT6YOWkR9HwcQs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1677187059;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1BrMJiktlM41NGZIyCSlXr+BlunmWEARe6FC2E44Xmk=;
        b=HHo4suMOPOSMQ1+5q+efyHbJt/O+I109uAaq/DetWvYEhd5YrjKZNwgEsasY9hBluCw6ZZ
        sZB3koP8KiWthqDg==
Received: from lion.mk-sys.cz (mkubecek.udp.ovpn2.prg.suse.de [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3F1882C142;
        Thu, 23 Feb 2023 21:17:39 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 991DD60412; Thu, 23 Feb 2023 22:17:35 +0100 (CET)
Date:   Thu, 23 Feb 2023 22:17:35 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Thomas Devoogdt <thomas@devoogdt.com>
Cc:     netdev@vger.kernel.org, Thomas Devoogdt <thomas.devoogdt@barco.com>
Subject: Re: [PATCH ethtool] uapi: if.h: fix linux/libc-compat.h include on
 Linux < 3.12
Message-ID: <20230223211735.v62yutmzmwx3awb2@lion.mk-sys.cz>
References: <CACXRmJiuDeBW4in51_TUG5guLHLc7HZqfCTxCwMr6y_xGdUR5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="d4hszn7rvhino5c5"
Content-Disposition: inline
In-Reply-To: <CACXRmJiuDeBW4in51_TUG5guLHLc7HZqfCTxCwMr6y_xGdUR5g@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--d4hszn7rvhino5c5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023 at 09:38:41PM +0100, Thomas Devoogdt wrote:
> Hi,
>=20
> I now see that these headers are simply synced with (and even
> committed to) the upstream kernel. So having a kernel version check
> there is probably not something we want to do. Better would be to
> incorporate the "libc-compat.h" header as well to fix compilation on
> Linux < 3.12. This is similar to the added "if.h" header itself in
> commit https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/=
uapi/linux/if.h?id=3D0b09751eb84178d19e4f92543b7fb1e4f162c236,
> which added support for Linux < 4.11.
>=20
> Let me know what you think, and if further action is needed from my

Yes, adding libc-compat.h would be a cleaner solution than having
a modified version of one header file. The easiest way should be
creating a bogus header file (e.g. "touch uapi/linux/libc-compat.h") and
running the ethtool-import-uapi script.

Seeing that this is not the first problem of this type - and likely not the
last either - I'm considering if we shouldn't go all the way and prevent
mixing potentially incompatible kernel header versions by pulling every
kernel header included in the source (and every kernel header included
by those etc.). That's something that could be scripted easily so I'm
going to try it and see how big the full set would be.

Michal

--d4hszn7rvhino5c5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmP31+oACgkQ538sG/LR
dpXVxQf/XLWiJDeNeIZn5rfYjCsnADF0GgVBn4s5dS5XA/GkM/cILTBAF2AciJzg
MlwCC7gJ3Es6DfWpQRYkbuwt+4rUMTUgifeyt2Flk40eiUfTtxD+3TYok94K11fd
IKOtiRcRXUmOXCoHnTriiKzU89yEz4S44KtfwJPNtFDyXGJx4NcwpT3uwsQcJFuU
6mjDfx5/0V8h0Xpgx0wn6xJfWpQJpOdo1NPn4Ft08OSvXyqAcSHKMHwdDIhX2hjx
yshDLWAk6Qv1R9uRkTRzmIJsrvMFENZ5BuWs/4XqSfneBrTHRyFSa2+eFduIVLgN
Adc3qchfySniBEttiZI14JpPrqAR0w==
=YT56
-----END PGP SIGNATURE-----

--d4hszn7rvhino5c5--
