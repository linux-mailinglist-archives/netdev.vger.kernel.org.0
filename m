Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58571648831
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiLISJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLISJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:09:36 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF43E140AC
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 10:09:35 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6F5A722677;
        Fri,  9 Dec 2022 18:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670609374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eSwjXkvn27L6bNzZwFWFuZVCUzCF3kXg/1zC0+doiLM=;
        b=M1BSD5ZiXRTGdBF70qj1hibAw2vwQMuUpHGijmIlronzXc9meXqb/Mm3BHRbVBlNWX3TwU
        rJT0tMEpePD2U38WVvHfvtNaAdZxDFgA353UieUWIIvADwGKuLc/lGhDo8mdiTwfI8lJDa
        8QLLbjLfxzOPptlCQooGKMPSqKpHRcE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670609374;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eSwjXkvn27L6bNzZwFWFuZVCUzCF3kXg/1zC0+doiLM=;
        b=FfxknQQJOiQgZlur95+ZqPTUyuBcKLbadLgVMPPvyCiVHPzfshJFZlssSR71V0lTjLS1vY
        hIUbbzsejcAdF8AA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 65B482C141;
        Fri,  9 Dec 2022 18:09:34 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 3B4F66045E; Fri,  9 Dec 2022 19:09:34 +0100 (CET)
Date:   Fri, 9 Dec 2022 19:09:34 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 08/13] ethtool: fix runtime errors found by
 sanitizers
Message-ID: <20221209180934.cknkbvdr7gkphenf@lion.mk-sys.cz>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-9-jesse.brandeburg@intel.com>
 <20221208063432.rt3iunzactq6bxcp@lion.mk-sys.cz>
 <52408830-e05b-03bd-3c3c-4195af1efbf2@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="flunrzz73u6j7s5u"
Content-Disposition: inline
In-Reply-To: <52408830-e05b-03bd-3c3c-4195af1efbf2@intel.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--flunrzz73u6j7s5u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 09, 2022 at 09:42:59AM -0800, Jesse Brandeburg wrote:
> On 12/7/2022 10:34 PM, Michal Kubecek wrote:
> > On Wed, Dec 07, 2022 at 05:11:17PM -0800, Jesse Brandeburg wrote:
>=20
> > > -	INTR			=3D (1 << 31),
> > > +	INTR			=3D (1UL << 31),
> > >   	PCSINT			=3D (1 << 28),
> > >   	LCINT			=3D (1 << 27),
> > >   	APINT5			=3D (1 << 26),
> >=20
> > While the signedness issue only directly affects only INTR value,
> > I would rather prefer to keep the code consistent and fix the whole enu=
m.
> > Also, as you intend to introduce the BIT() macro in the series anyway,
> > wouldn't it be cleaner to move this patch after the UAPI update and use
> > BIT() instead?
>=20
> I had done it this way to separate the "most minimal fix" from the
> "refactor", as I figure that is a clearer way to delineate changes. Also,
> this specifically addresses the issues found by the undefined behavior
> sanitizer.
>=20
> I'll do it whichever way you like, but you're correct, later in this seri=
es
> I fix up all the BIT() usages. Maybe we can just leave this patch as is,
> knowing the full fix comes during the refactor in 10/13 ?

As we end up with BIT() everywhere anyway, I'm OK with either option,
leaving this patch as it is or dropping it. When I was writing that
comment, I had seen 09/13 (introduction of BIT()) but not 10/13
(refactoring everything to use it).

Michal

--flunrzz73u6j7s5u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmOTedoACgkQ538sG/LR
dpVlPQgAhMjjHMjrl8qaixJJf4RtYX0Y7bSCN7JTJ7lM3ix/J0+0qzRTTzvJa5CE
pHM2U+b4iqITzBJ39gYk86wRgrvnrQt0Mi0cyupofgyxq0MqmSYKziSy5A4ULoJR
6ixtTGt4o3maLW/9eW9i2RhQg/oOQrk4RAXz83/Ci462IOSVOE1A0ariLh9QjqSB
H1OpZ1fmwq41fFDpsgK9REKL42Fcdj7AAnVEZ3dcMew65vtLo/m0CmYUAPYC/U51
FZH+qoP6QrQuBnT+rh6G0RN0FJuDoprLX4tI8tRdwRJ5fLdjk0avsjxEuFU4nOMM
//DDSkcujsXPwPBUfSO73mlPERo8gw==
=WGj/
-----END PGP SIGNATURE-----

--flunrzz73u6j7s5u--
