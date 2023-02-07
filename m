Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32DCD68D33D
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 10:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjBGJuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 04:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjBGJuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 04:50:15 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2DE3019E
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 01:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1675763411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0+RV4XYFLyO7dcuOSeOHYrkVg5qZ6ECDyVby5qmjwco=;
        b=2TcFs7t2E5qp1ZP8wxlCkFGcVi1Mzk5xsdhYKODHaZhGdlF79d+p6Wf3X8J09+REVnb3Pp
        NiZ0Z0WvI4v7ONX9eGxeevOTo6qQTMGVLJeubkLrDmVU/8D+RL+TZTbv8+sXyl/FzARNTh
        S7dL+4PhCI3Km3YAg4Vn+zdbQnn+Nc8=
From:   Sven Eckelmann <sven@narfation.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     b.a.t.m.a.n@lists.open-mesh.org, Jiri Pirko <jiri@resnulli.us>,
        Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] batman-adv: Start new development cycle
Date:   Tue, 07 Feb 2023 10:50:08 +0100
Message-ID: <4503106.V25eIC5XRa@ripper>
In-Reply-To: <Y+ITwsu5Lg5DxgRt@unreal>
References: <20230127102133.700173-1-sw@simonwunderlich.de> <8520325.EvYhyI6sBW@ripper>
 <Y+ITwsu5Lg5DxgRt@unreal>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4561296.LM0AJKV5NW";
 micalg="pgp-sha512"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart4561296.LM0AJKV5NW
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 1/5] batman-adv: Start new development cycle
Date: Tue, 07 Feb 2023 10:50:08 +0100
Message-ID: <4503106.V25eIC5XRa@ripper>
In-Reply-To: <Y+ITwsu5Lg5DxgRt@unreal>
MIME-Version: 1.0

On Tuesday, 7 February 2023 10:02:58 CET Leon Romanovsky wrote:
> In cases where you can prove real userspace breakage, we simply stop to
> update module versions.

That would be the worst option. Then the kernel shows bogus values and no one 
is helped.


And how should I prove it to you? Is that enough?

    $ lsmod|grep '^batman_adv'
    batman_adv            266240  0
    $ sudo batctl -v
    batctl debian-2022.3-2 [batman-adv: module not loaded]
    $ sudo batctl if add enp70s0
    Error - batman-adv module has not been loaded
    $ sudo ip link show dev bat0       
    8: bat0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
        link/ether 7a:8b:21:b7:13:b8 brd ff:ff:ff:ff:ff:ff
    $ sudo ip link set master bat0 dev enp70s0
    $ sudo ip link set up dev bat0
    $ sudo batctl n                         
    Missing attributes from kernel
    $ sudo batctl o
    Missing attributes from kernel


Expected was following output:

    $ sudo batctl -v
    batctl debian-2022.3-2 [batman-adv: 2022.3]
    $ sudo batctl if add enp70s0
    $ sudo ip link show dev bat0
    $ sudo ip link set up dev bat0
    $ sudo batctl n
    [B.A.T.M.A.N. adv 2022.3, MainIF/MAC: enp70s0/2c:f0:5d:04:70:39 (bat0/7a:8b:21:b7:13:b8 BATMAN_IV)]
    IF             Neighbor              last-seen
          enp70s0     50:7b:9d:ce:26:83    0.708s
    $ sudo batctl o
    [B.A.T.M.A.N. adv 2022.3, MainIF/MAC: enp70s0/2c:f0:5d:04:70:39 (bat0/7a:8b:21:b7:13:b8 BATMAN_IV)]
       Originator        last-seen (#/255) Nexthop           [outgoingIF]
     * 50:7b:9d:ce:26:83    0.684s   (255) 50:7b:9d:ce:26:83 [   enp70s0]

Kind regards,
	Sven
--nextPart4561296.LM0AJKV5NW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmPiHtEACgkQXYcKB8Em
e0ZizhAAgr1dcBRgU3o30VgcFrIx7VcmSLU0y9KP2tpRJECfvS5pj89II02klmRn
dHtj1rU1tiJfTRWMyefDLTvgYKN5gQjBW7AYO1qpY4kYmY6dcMK1rNJkmnU/leXJ
BTKEEl1fQKUoTXzKNC/81QUm3abYXOG21XP2c06wntKOlvKkdjwAHisVjmYK1cnK
mZMeiK7/zdKW89of0As4Z+Cli9VrsAgV1FwIlIfqweWG5SUcTyP9/Bhg8y9yPsxt
jas9Vo+9atRRyKvWYzH5NKMZ449bQAvMsaAu2rvTdvQl0S+tr6AsqqDrpLMRsjif
3PJTx7qkbwUzrCdk9Kbraq9v7JtsypZWJ8BW3ydkqcBkCr+Uv4q9/dM3mJ1W1MKk
NXhsmxlbRecidCMXUiScRDRISJ/ngrKGrUv5b8xn1qxvJRMUKYX3Br+NBy3AVxwc
Xc+v9Uy4RFbC1k/k+ZKB8lXCddznopvjKPeMIU5Ig3UhIDw+NVWXZ3vQg5eGpxPt
NjWajsE59001CJlnjIBekIcn+uYiBxEDKecfD2A/aoEllM7tuy2DAWugKLUZyvCO
iT1JRa+7tcyfHdjPgyeQjWOsJhJ7nlmqOgJFz4OsF2IGyxvO9DV1dSr/OZJDaR28
raEnHU8ZRJBYSLcg2L7JZ7tBrMGpliCTbYq556HopbuR8M3eAZo=
=ku9t
-----END PGP SIGNATURE-----

--nextPart4561296.LM0AJKV5NW--



