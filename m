Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE8550061C
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 08:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiDNGbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 02:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiDNGbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 02:31:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3325A4BFFC;
        Wed, 13 Apr 2022 23:29:16 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649917753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cQtOV0RyDDp26xvCB7CLZ7TVyU8W4OGmVs7AgQlPm28=;
        b=p7uo2D4PrVyE/q1szXTUx6g+RBYfQEBOMHeNfnPq0nFvP3sx0TZwD4dByDh+JfX+8ZqvVv
        FhXZHBi7wj0x9W35HeG3MZCQgZ24MZJSgyygETCwAU1ymXzMV3k0uwhHWX688jvmL4tN+H
        O4lw9JZyqW1tXjSq5HZmZRDYTT8WN5ut3meUgdskwUPwkwQhYtXmkMCFPR8MECnYAPc+UO
        LrmXt1CdIvCuyYbVCYLC/bka3ld988ds3wBtQYxw1wofuRVp23VYCFLBjAEYbzRazTktTY
        l/ILBI4hSUwjedLYbhzygBifNeb00OW7ArL+gXF1idkxZrrsypMH1XU72hIXDg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649917753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cQtOV0RyDDp26xvCB7CLZ7TVyU8W4OGmVs7AgQlPm28=;
        b=LhBUz5DMzKWC/l1fKb7WVRW3T0+RWZ/dOvQkdF+S/p4iqWzsPeS4Sai/85wwztYWnOtsd7
        8ZAE4DHiyVyjuNBA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v2] docs: net: dsa: describe issues with
 checksum offload
In-Reply-To: <20220413200841.4nmnv2qgapqhfnx3@skbuf>
References: <20220411230305.28951-1-luizluca@gmail.com>
 <20220413200841.4nmnv2qgapqhfnx3@skbuf>
Date:   Thu, 14 Apr 2022 08:29:12 +0200
Message-ID: <87tuawp493.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Wed Apr 13 2022, Vladimir Oltean wrote:
> I've copied a bunch of new people to this email.
>
> TL;DR: Kurt/George/Andrew, on your systems with hellcreek/xrs700x/mv88e6060,
> does the DSA master declare any of the following features as "on"?
>
> ethtool -k eth0 | grep tx-checksum-ip

It's a Cyclone V with stmmac as master:

|root@tsn:~# ethtool -k eth0 | grep tx-checksum-ip
|        tx-checksum-ipv4: on
|        tx-checksum-ip-generic: off [fixed]
|        tx-checksum-ipv6: on

>
> I would expect not. Otherwise, we've either found a bug, or discovered
> the Sasquatch.

Now, I'm wondering how this actually works. Anyway, I'll send a patch to
add the missing skb_checksum_help().

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmJXvzgTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgm/fEACyKZ3RygUAM+2cTBaW9oUu23NYu9j7
ukvYq/uLG8VUzTg/UD56iAKptTJ+5WUSfqitHXi2PPeCMOD4ev/V+3T7Viq8sTvA
f2BTbPXcNtxZ5WEDur04azFNj6/BpRfzv6z9QZeMwWrWV6BUVa39enWsDygj0eit
RAhaNZqd5/FQlTj8CIT8qVO4yQiiI4UAUZuk0Mdmd7ffU1n3FQSgSqLjV15509zY
dXOwT9wC2Xz0fzGSthrnB0Ervtox47rGf9kxKYKN9QE7tT79jtcIF3WhanF1YwSF
QJfPtsz2MFn3EHV50URRWOdeY8W879ORZ1hTbRP7ygFcsNe1NGy8Ygc59zKyj6u0
+9qeF7wka6r+d10EB3CZt1Id6iMWtlOGXu83/fRPr4YrOyAfgDH8jgAZ3yixlui9
A4u6wnsXobqeOue10a8qeF8mUq8nO9s5nLzQBXw3S5c6kTVhFpsOI525nMGUPk4k
nnFEiHiSqosKLBgvgPi5YcZKS+X+5he0t1Fcvm9WOGQJJ3TqpEqzFGuM1XW+9z7t
d2PxetM3ix7Ygn4RmKcltfgP+ip09XypoMLU1hzcuShPsIwe64xiywbSRF2YvjA7
/iR878+Ua8JDICIkhv1CErfyLcAuDgCk+BMQ66yn6pSfrFLnLelF4hR5HOy+tgD0
Vdt+vds4cWwNRA==
=+jB1
-----END PGP SIGNATURE-----
--=-=-=--
