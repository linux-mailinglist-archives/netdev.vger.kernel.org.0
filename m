Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829824F3C47
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 17:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344259AbiDEMHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 08:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382121AbiDEMAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 08:00:44 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9073527C;
        Tue,  5 Apr 2022 04:20:02 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649157600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w4wC13cgxgcXdHBjki817aUc/ec42N1KzUxtBLjVtcc=;
        b=BXekPsXOfwzgvSZEi1DNEsjRtwJF0K2+Ym69LE7AzzCOz6c6EDroh6V53dcfxypNprCC0d
        YBFF2R/ezJFkE9rB7iVyyKZ8SYyHRVBqmuM5QklN/QI7wl4PEJJ0Cb9XyqvB1Dv4oy24or
        MzIIX/3GpyT+caqjrEh4pIYQWLIdEH8/kE4bTIivLQA8XNtANVDV2Bq8gdcYuwS4pQT/Gi
        D/GGmH3tGhmJFJ0Zv9eWT831GVM2ieebbNU7RUrjUORtauVt9kvbkal3GukcA204CeGChT
        rP3fKPX713//p6S0+RTeyWBc5mcKaKQ0eWX6VcH5A+mylWf25pYwVJyDki7arg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649157600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w4wC13cgxgcXdHBjki817aUc/ec42N1KzUxtBLjVtcc=;
        b=oFyO70rtb6aZDlRGxSJ/Boi/0eCighJ6RPnZX8oziT2T0rpTuut40ZLJItQ2sbiszjbdVZ
        5vTHHVc+8eFc27Dg==
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>, richardcochran@gmail.com,
        davem@davemloft.net, grygorii.strashko@ti.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        mlichvar@redhat.com, netdev@vger.kernel.org,
        qiangqing.zhang@nxp.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
In-Reply-To: <ad4a8d3efbeaacf241a19bfbca5976f9@walle.cc>
References: <20220104014215.GA20062@hoboy.vegasvil.org>
 <20220404150508.3945833-1-michael@walle.cc> <YksMvHgXZxA+YZci@lunn.ch>
 <e5a6f6193b86388ed7a081939b8745be@walle.cc> <877d83rjjc.fsf@kurt>
 <ad4a8d3efbeaacf241a19bfbca5976f9@walle.cc>
Date:   Tue, 05 Apr 2022 13:19:58 +0200
Message-ID: <87wng3pyjl.fsf@kurt>
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
Content-Transfer-Encoding: quoted-printable

On Tue Apr 05 2022, Michael Walle wrote:
> Am 2022-04-05 11:01, schrieb Kurt Kanzenbach:
>> On Mon Apr 04 2022, Michael Walle wrote:
>>> That would make sense. I guess what bothers me with the current
>>> mechanism is that a feature addition to the PHY in the *future* (the
>>> timestamping support) might break a board - or at least changes the
>>> behavior by suddenly using PHY timestamping.
>>=20
>> Currently PHY timestamping is hidden behind a configuration option
>> (NETWORK_PHY_TIMESTAMPING). By disabling this option the default
>> behavior should stay at MAC timestamping even if additional features
>> are added on top of the PHY drivers at later stages. Or not?
>
> That is correct. But a Kconfig option has several drawbacks:
> (1) Doesn't work with boards where I might want PHY timestamping
>      on *some* ports, thus I need to enable it and then stumple
>      across the same problem.
> (2) Doesn't work with generic distro support, which is what is
>      ARM pushing right now with their SystemReady stuff (among other
>      things also for embeddem system). Despite that, I have two boards
>      which are already ready for booting debian out of the box for
>      example. While I might convince Debian to enable that option
>      (as I see it, that option is there to disable the additional
>      overhead) it certainly won't be on a per board basis.
>      Actually for keeping the MAC timestamping as is, you'd need to
>      convince a distribution to never enable the PHY timestamping
>      kconfig option.
>
> So yes, I agree it will work when you have control over your
> kconfig options, after all (1) might be more academic. But I'm
> really concerned about (2).

Yes, the limitations described above are exactly one of the reasons to
make the timestamping layer configurable at run time as done by these
patches.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmJMJd4THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgtOtD/9duBdOcHsfImUfY/KkCXEDs8Floeju
+xKhay38ecgGiVhCd3dVKjfmcN7mHjQ5bTDVQdNaVk/pAhWSiT0YLzKlaJ0aqWqy
XAcO67YWR2tv4WS9oXKCZjKhpbcFyX5FWo54U0TDcuyNwU/37lxN68tJnYISbjK8
Fgj0UG0YIG3xEU25hETK2ECwaczPbPfONiil96tN6G1GIfy7zWFmGCTGx3h7qc1X
JSJ5wtbprxvOdzvgV+SI3B3lgJbaG4l0sbrQsl0VZcueBAdtec8nKQg5ktnGRAiG
JV84i4bwpf9D/6xRNNky8G3VLLCm1m5DPr08JZqkow7ikZxum9VhNF3IdnwiyCnN
5wvw5yoDo9mNw4OS8zD7l5iDHPQZT7lLyXU25JERuPj/jRnR0NPpcC9BUbon97ED
ESA/usK4aWFOCvapU9MJvgARbr+OkwzjhUJfK51HpbvG72FCELlMzGVKbaLtP3Ut
GtoEl7WfWzeEKsv/Y8kazK2RNfTF/ew0z9aLfjJg5qvZPb3ZVBe+mXj/vn9R0zO6
N5VQY1XtIlruFC6nPfG29+r8QptX1ovC5C8x/p/BejQ+vf3YnTMNDT80DL+agjp5
zzDvvRuoIOqeyrEf+/I2F/WivLiyNOkheTZYM70MmIGu9f0ITa02d6ooLzkLFwle
RQ2ARFGqWSJ7VA==
=+pav
-----END PGP SIGNATURE-----
--=-=-=--
