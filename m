Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F1564696A
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 07:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiLHGon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 01:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHGol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 01:44:41 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DC42CE35
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 22:44:40 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 580E1206CB;
        Thu,  8 Dec 2022 06:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670481879; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Isqsbknh0NKlLYRnqd/KkYIhtkf2Pf5uVRtE5hYgm/c=;
        b=MJtH44SzFQNRoF9Zvx2FhKxkRUFPCxqKFOWJzTBVgxhm7HEHF9XAyMYP49x2vAaj9Z7/u7
        A9xiEidzSIb/NjxwUQQBD1JjElbIbKpsY+EQ+7CKVk6CFymVo6XmARPQwsJYl3ONPs4ij3
        FQOxxsoxp8vKyhGhvs+UHS4YM+p2k74=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670481879;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Isqsbknh0NKlLYRnqd/KkYIhtkf2Pf5uVRtE5hYgm/c=;
        b=E1j/+Q2aN4SZldpB5ajkbqeHSZx4hKsDQpFVaD3qhXORfI7cEiDVYzMqxx05c4kzDMiMAD
        WUouTrMLl2tTc6Bw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4E5A12C141;
        Thu,  8 Dec 2022 06:44:39 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id F1BE86045E; Thu,  8 Dec 2022 07:44:38 +0100 (CET)
Date:   Thu, 8 Dec 2022 07:44:38 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 09/13] ethtool: merge uapi changes to
 implement BIT and friends
Message-ID: <20221208064438.e4e65j5ngfdmowoi@lion.mk-sys.cz>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-10-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7bagjjudn4zybf2o"
Content-Disposition: inline
In-Reply-To: <20221208011122.2343363-10-jesse.brandeburg@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7bagjjudn4zybf2o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2022 at 05:11:18PM -0800, Jesse Brandeburg wrote:
> I was looking into some errors reported by the runtime sanitizers and
> found a couple of places where (1 << 31) was being used. This is a shift
> of a bit into the sign-bit of an integer. This is undefined behavior for
> the C-specification, and can be easily fixed with using (1UL << 31)
> instead. A better way to do this is to use the BIT() macro, which
> already has the 1UL in it (see future patch in series).
>=20
> Convert and sync with the same changes made upstream to the uapi file,
> to implement ethtool use BIT() and friends.

Please follow the guidelines on updating UAPI header copies in
"Submitting patches" section of

  https://www.kernel.org/pub/software/network/ethtool/devel.html

Fixing fsl_enetc.c within the UAPI update is OK (and definitely better
than trying to avoid it) but please update all UAPI header copies to the
state of the same kernel tree commit which will be indicated in the
commit message.

Michal

> This required an unfortunate bit of extra fussing around declaring "same
> definition" versions of the BIT* macros so that the UAPI file will
> compile both under the kernel and in user-space (here).
>=20
> A local declaration of BIT() had to be moved out of fsl_enetc.c when
> the implementation was moved to a header.
>=20
> NOTE:
> This change will be followed by a larger conversion patch, but *this*
> commit only has the UAPI file changes and the initial implementation to
> keep the work separate from the application only changes.
>=20
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

--7bagjjudn4zybf2o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmORh9IACgkQ538sG/LR
dpUPMQgAsjYnM/lmHO6y4dZ8iwey9K86os0vPPYspzghAZB+0QnsiEk9uV9wKh2t
LSjSlqwg1PUuKh7SyH+z6mOinuOmaf7sfWS1/DurGm3B7PDDrQSc4aJ0Z9Z9uxEx
K81ssgPFGPMdQvV99ZJIRpqxH/lHX8H9MqlRE8gIvRRM0+q/GJjjjsIeMxRzJeZl
uoj1CM/Ukx/Qq0rM2dTH/osPzvve0UFdK0OnZJqG8teBLnhC2Sb6EnaU3cH6jwyN
EYLxLM/VbhASRvDYzPUdyrkB2fb9+IeF5tq6bt1iVOiT/cHJ705ny0AtnoeGbdD/
JwRhpvAQqUd7jgQgV8iXUrlSdOsn7w==
=E9Sz
-----END PGP SIGNATURE-----

--7bagjjudn4zybf2o--
