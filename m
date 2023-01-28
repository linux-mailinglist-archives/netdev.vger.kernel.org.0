Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6239267F7C1
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbjA1MHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbjA1MHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:07:02 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E1879604
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:07:01 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ew47kVxKqM6FwWvR58a7SRrFfJ+KifPWcx17XtrGqxY=;
        b=HuGAAjP15oOTYK99WgdtuORnvBO5OgAeQaWOaycWAE7tkdAqun8VHYdvX0k1Mo6IBnOc2c
        S+4qZxJvGGFrur7szAvc3niYXB7DUW3N8lNsuTq/P7KD1ADB0sespXCj8tJPuBgqhDa99P
        xKoF/hL+VTbzNrX1ElDR6/mgbO3j2VU0S79YIUcmkCGPTiHdoFaOvk87TaIF5l9Gxa3F53
        97x42NUYY399uICLG8/5b5F+Lxopgs0LbxHtx5GzMo6ShTpJ9XiKJNyOytIRpN2m5QDP+T
        vYzp0Mh4ZsfYykEn9z3ub1KOGj7PGGs5IckAI+DxZZDR1ArV9HDvnxoj/LJBJQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ew47kVxKqM6FwWvR58a7SRrFfJ+KifPWcx17XtrGqxY=;
        b=t4HO/h9Jw4dokyinXdWIaKBz5CEtWqkT463SnjWi28CdBrzBKZKjSOznC3Kswowmk9gMCS
        svYrvoSNbwIUIXAQ==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 13/15] net/sched: taprio: automatically
 calculate queueMaxSDU based on TC gate durations
In-Reply-To: <20230128010719.2182346-14-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-14-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 13:06:58 +0100
Message-ID: <87wn56ual9.fsf@kurt>
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
> taprio today has a huge problem with small TC gate durations, because it
> might accept packets in taprio_enqueue() which will never be sent by
> taprio_dequeue().
>
> Since not much infrastructure was available, a kludge was added in
> commit 497cc00224cf ("taprio: Handle short intervals and large
> packets"), which segmented large TCP segments, but the fact of the
> matter is that the issue isn't specific to large TCP segments (and even
> worse, the performance penalty in segmenting those is absolutely huge).
>
> In commit a54fc09e4cba ("net/sched: taprio: allow user input of per-tc
> max SDU"), taprio gained support for queueMaxSDU, which is precisely the
> mechanism through which packets should be dropped at qdisc_enqueue() if
> they cannot be sent.
>
> After that patch, it was necessary for the user to manually limit the
> maximum MTU per TC. This change adds the necessary logic for taprio to
> further limit the values specified (or not specified) by the user to
> some minimum values which never allow oversized packets to be sent.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVD+MTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgu+ZEACYX4yinrSPzpRynQQ6AleKYB8UqfKy
Fo+iEhRM28rmKmIrzY3SJlWUVAGmpWPhK7iqNf2S17ZuI5WOI4Uq9qc+fS7XDPrc
ehc0WlkbLm7TVFaS/lzpYsEijIfusE+pAQG1l8r4x+cs8w/k1vqWa6iUrOaphvZe
hxOo2rMvtvY8k9qQklml2D5RYVyYcdRrK3D8PNOau1RSxsrkKCXB9bgSNVupdeqg
rXZwcBRetk5ZQS6Se3Xc/Nhpz7zs/Vr8il35YjgUlyMStWyTMlAacziJAiprm0vz
t9ouF4CL73AUxoDuYy4HVDQI6eZiMwMECqW687ld6ui3qQH8PjxuC+uvDOl86nNL
D1ueVOhI6blQj8MOjsT3e4h0JOPXJWAWrvreEHHCYcDc7ZDALs+bPu4N03ETddCU
xWWK8en4PDpJUBlY7eI0WuvcqDF3lE5eLoSh9Dz7Lo42SbQW/6CfxFrPCqlZe96c
9W2zDLEIpCg0vtNnhLxGnkid/M1Y7Tc0eo/2ghgTLYfX6MMnblGR3lKKF10VYpf9
3z3PdkONTjAM+bbHz+WgN9QPZqyFR5PLLBRddkcVl06JLAzl+/tqlx6YJwRPsgUw
PZ4pzjr2shg//m8YU5sSgoNHFIZi9XDr0nnoktuixfKVt6Q/EC04FyS6PKMP9JH2
+rohcK+W3c9DSQ==
=qAQ0
-----END PGP SIGNATURE-----
--=-=-=--
