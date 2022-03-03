Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D374CB859
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 09:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiCCIJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 03:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbiCCIJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 03:09:24 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED6F1704E2
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 00:08:39 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646294917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7kZm4RzztniyBe6J5rSOVatAsPH+DCqpMSlyLLNtEbc=;
        b=KO0U/fPCotkgTNQF5bcP8JG2lh/24aE04U5F/NSyqiHL/WRCM3Z+Ld8U6SjC4RGWcVtnF8
        ipRaxtPCfDRjGxysmZUPdUT5dN02M/O16rSg1QLGr9Aoh5InOBP5K+InS6ujr3XFaHGhal
        29Doz3g6zKKeNnpiFMz98mXZKBANMRNTedOsN+6upaVker28vxAFTKo6jC0sCxpebT98t5
        swzZw5mo9zf/OifcDnRoa5neuKmAwlfBnDelhAQ2S32htzq2ZUdV3YCbF4y6U8uRAWfuju
        4oahdA3n90jguW1krB+L/OKMOV9O7P97sAWsETMV3JlJIpSdgJVGE+rkItFKyw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646294917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7kZm4RzztniyBe6J5rSOVatAsPH+DCqpMSlyLLNtEbc=;
        b=9v1lJ3SCn33uV8ylqGFq3MUPSIwDt0VoUCBGUQhLcIJInGYclIA+XQ2ppCpsGQrqRe1Mn7
        m/Cj8pZWr1CY/GAg==
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@nvidia.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        zhang kai <zhangkaiheb@126.com>,
        Juhee Kang <claudiajkang@gmail.com>,
        Andreas Oetken <ennoerlangen@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org,
        Anthony Harivel <anthony.harivel@linutronix.de>
Subject: Re: [PATCH net-next v1] flow_dissector: Add support for HSR
In-Reply-To: <20220302224425.410e1f15@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220228195856.88187-1-kurt@linutronix.de>
 <20220302224425.410e1f15@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Date:   Thu, 03 Mar 2022 09:08:35 +0100
Message-ID: <87ilsva264.fsf@kurt>
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

Hi Jakub,

On Wed Mar 02 2022, Jakub Kicinski wrote:
> On Mon, 28 Feb 2022 20:58:56 +0100 Kurt Kanzenbach wrote:
>> Network drivers such as igb or igc call eth_get_headlen() to determine t=
he
>> header length for their to be constructed skbs in receive path.
>>=20
>> When running HSR on top of these drivers, it results in triggering BUG_O=
N() in
>> skb_pull(). The reason is the skb headlen is not sufficient for HSR to w=
ork
>> correctly. skb_pull() notices that.
>
> Should that also be fixed? BUG_ON() seems pretty drastic.

It's this statement here:

 https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/i=
nclude/linux/skbuff.h#n2483

I tried to look up, why is this a BUG_ON() in Thomas' history tree
[1]. Couldn't find an explanation. It's been introduced by this commit:

|commit 1a0153507ffae9cf3350e76c12d441788c0191e1 (HEAD)
|Author: Linus Torvalds <torvalds@athlon.transmeta.com>
|Date:   Mon Feb 4 18:11:38 2002 -0800
|
|    v2.4.3.2 -> v2.4.3.3
|=20=20=20=20
|      - Hui-Fen Hsu: sis900 driver update
|      - NIIBE Yutaka: Super-H update
|      - Alan Cox: more resyncs (ARM down, but more to go)
|      - David Miller: network zerocopy, Sparc sync, qlogic,FC fix, etc.
|      - David Miller/me: get rid of various drivers hacks to do mmap
|      alignment behind the back of the VM layer. Create a real
|      protocol for it.

It seems like BUG/BUG_ON() is the error handling practice in case of
unavailable memory. Even though most functions such as skb_push() or
skb_put() use asserts or skb_over_panic() which also result in BUG() at
the end.

Thanks,
Kurt

[1] - https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmIgd4MTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgmVkD/94qNtcxDDtKAkczV2o4Xo6aJYTFeLR
BgHp7pga1yWQ3WtxY5zi+GKvHGjBlFoxkI2ZUBfn09r3TAGlFpzgPICmPvgYPLOj
EMtbkMrZJtW/orK/hq3cbfIgzheeApB1oWjqhpMCa11vImbG3MV/r4A1Dhg4eeow
LZQocLjx11OP63Nr5map6/hcdA70d7GdfdyhnyGJb9Y1dnCf5UeXY8s13c1J2gQg
9zdjf+SuuoMXY8VIXEr3kiyuUhx7FH8s66+06ii8V9ZNz/shYHB6dwSZY/qo9+bq
RpJ/d2I1NP0uQx4nlg1++WT5BaJ5mVQsGtOXnkzb0NFZ9B6jfJkSN6AfI5NA49BL
aIjAs6NoVB68MYvKZc7WztVppfbMKHmhDyvZmWk3EtZEepc+GL1BUmnf0He9gtXV
uqYCdKe5EBgDccgyq1mNhSixM1MY8B4XM0ZbuqcxZguWUDoXTFA7QVUP/FULbk+F
DZlFC6Oba/KrXiWe6owdTa2UdghkQit0fi5JO0FX+o/S8dIGHgP/qKE4OPqUEuN9
9kG+yBiAxyuaaCRj8dg5vS8tTXJCjRikJxzZysJIvoTzz/+NM56k8VqSVQX9psTG
fEYOByyr4+b+mVsAP3T80SZMIYYR5kS8Ac2jvTsG1tJywP5unx8giGu+YoR1Gyt4
tgv70MbhGhDidA==
=7yO0
-----END PGP SIGNATURE-----
--=-=-=--
