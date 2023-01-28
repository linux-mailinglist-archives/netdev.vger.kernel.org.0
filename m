Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B335F67F7BE
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbjA1MGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbjA1MGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:06:12 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7927923F
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:06:11 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zN5ACxGzxVT0gXv1YWAJWbLHUewjSS9jN5BkIBygOnI=;
        b=LSJL037W0w4hUUaWnQPQtgKqIqbd4OQPus+KVq0M3klGl7QX/mGSWyMzRzYET0tdS0mWDD
        KqQikJmHjCEnjmVU4VtqJyKjse2R0E4+yET5j7uZD6RMWgBJ8ElPeAJYPvTlO2ZRSAom1S
        t+3pWpz5AiPiezo+rguy7EfNeWjLKQWfLbQS1FxJho3vX6QOqQ2tEMmkIaPB2Dry1T83W/
        T/aSpnzOohuaGz8Q0K7xhhkW5guLUysaOxK3roj18IdKwABYfcCI/FJ6PB+nxysCPBgNZF
        ENHOVP3/vb17OGOwF+lakCkA0kl387CQu4QOs7KsfznxZJ8BRgVK4fZhhdsbcQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zN5ACxGzxVT0gXv1YWAJWbLHUewjSS9jN5BkIBygOnI=;
        b=NMX/v063qNkEEoqjphwDSOhAnLkSq2M8buw1+0U4eQaj5cl827YEdeQ94WfHYDqM5BF3J1
        cCafTn1+wWiiCfAw==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 10/15] net/sched: make stab available
 before ops->init() call
In-Reply-To: <20230128010719.2182346-11-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-11-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 13:06:09 +0100
Message-ID: <875ycqvp72.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sat Jan 28 2023, Vladimir Oltean wrote:
> Some qdiscs like taprio turn out to be actually pretty reliant on a well
> configured stab, to not underestimate the skb transmission time (by
> properly accounting for L1 overhead).
>
> In a future change, taprio will need the stab, if configured by the
> user, to be available at ops->init() time.
>
> However, rcu_assign_pointer(sch->stab, stab) is called right after
> ops->init(), making it unavailable, and I don't really see a good reason
> for that.
>
> Move it earlier, which nicely seems to simplify the error handling path
> as well.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVD7ETHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgrwMD/9jyHiFBA6wtpiCIxKlhtA6SDLOEJNy
rogZj2B4cS+Ns1XBEfQ16r/DEM96ijSJPm9fHYo96SGUtGmfoigfva27jdgQoAZp
vQ74XoelnugZWJGZN+yc6CC1jw9rSvoK+yhFoorPvPKR7mn/h5fNdMaLP2CB3Da4
EBOxgrM1XIRJxp4rtwQ2gL1cbOvvrs4pHorVRQ0KhswJMN71XJNOKbT3EI4oCwIW
GhKTrLpSdJYFoaZI90cmMYpGcNItxi9H79LTiLTJ7AktPt3yo8UGMncLSPXEp4+6
76ReAaLJilPxkYBKo70O8/+7EqnrgQvaCo+uAWRKxk8Pf2x7lFA4eXThW+GqbyJE
6TzDDCtLKFmIpIA/JqtjQ2Se4KAJHg9IJxVTnkBeaZGKJI5pY78XWwB6zvoQI9c7
QycGKWkKBVF50kgXS4rS6a1GDLnwI0of+JTEvBL92s9chyfbptusB6JrM7QPMLjm
w+nLENsHO3B8PGQfPx+LuJzexqS9o3EPZo57UXOCzGDzytnHjM15sJtYtEZE30be
OSYTqmiz3HM9DayUSA0YUpy3YhQImAAf+RsKyB4P10PzGMXz2u9KwaGdTcQc3DsW
afXwZxfsj5hsIAPcPBaTBLeNdzuAvTz1yjhw/6+k/kJ7fDnIfQvq7goN9cAp6cJz
YkuoPqygPQq87Q==
=62DJ
-----END PGP SIGNATURE-----
--=-=-=--
