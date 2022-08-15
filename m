Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AC1592A15
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 09:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241329AbiHOHHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 03:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241320AbiHOHHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 03:07:37 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC0ADE84;
        Mon, 15 Aug 2022 00:07:36 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id BF2F05C009F;
        Mon, 15 Aug 2022 03:07:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 15 Aug 2022 03:07:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1660547255; x=1660633655; bh=QOJHrH0uXA
        69J5MR/ybSjlxMSWLzeU2JWyjoSEik7TY=; b=dQ+1FWmu54IKs+6Y0e/QHsyGhR
        obwFq6FRsRrZ8vVbPJQoM4wYAT1l6q4bbTLCx6aPlMkJZQDjSj48FvzDXcsoqguA
        BKcjd684SnAuV3uvKisN+vveF8RhXBeYeCijE35C/Fl4H4H24WFNTARPuru5j/YK
        URb+kFnW+mAu4WaWeIwoXgh0S92mPudUFRJz6TflcbGyPvL91MNqNeRn16zb4k4O
        i5klyC211uj46ns0tMQ6luZ/rY0YUjKZbcwUkuElvELMQumAcnME1jGBs3a2WpjN
        yyYMLLGJ7BVjtAMFASHzCFOecOcoPRi0vp3X6sg8Db2Nzgg9fwNRgAXUnHFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660547255; x=1660633655; bh=QOJHrH0uXA69J5MR/ybSjlxMSWLz
        eU2JWyjoSEik7TY=; b=nycSb430vEun5d+9EJ5N/7DkApVv1GGswO8eHqh8lH5J
        NXVcRWJamFBlkrpx1+aYy4avb031aGO8R5X78RfhpZJQrJt12bCBdBfV9P/jYcWQ
        QC3SluiqJLGjPhqkAcUYKqz05MtzU0qpHBRbSeuyOq0Qto1EJrds4bpE9FxhE14O
        7hfnvkhXnD2S9aC2ZZdm4Wrmkv2EEKh7ZJobHFJNrjCN0tPz8DJnLLxzPE1jCoZ6
        Pm8fVdd2jXENROk6ldm5Td6l9Q8lNvUmuewJNnAoszx/4QAwz5MbC2tEiACfYrO8
        EEGbwP0ZsXCq/JUM5rtNQR1MU5X06+BgCWTH9+cW9g==
X-ME-Sender: <xms:t_D5YmZXwQ0eMwDKWiBhpBv-cT3ua4PQkQ7yiDmQxs47slKVXC_DXQ>
    <xme:t_D5Ypb21d0NOjiGIWpehYMKJUDHgggJ99B-YnSbn-MqVsYCAo4bzc06a0Ou4LNtt
    OxDADu7a1cyQpaDzVY>
X-ME-Received: <xmr:t_D5Yg8aTQ0VY_sStkgLXD7PKgC7dWq1KP6CibEFI6IRxyCjPTxEspN3tpv5>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehuddguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgig
    ihhmvgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrf
    grthhtvghrnhepteefffefgfektdefgfeludfgtdejfeejvddttdekteeiffejvdfgheeh
    fffhvedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:t_D5Yor-9DsedxoB2F22UHVzUbetD0lpie0RIgk-oSbyOwtKoloyUQ>
    <xmx:t_D5YhohfDPJq1lTXmQef4d1JsFfJINvggfvb6gOHBICT0yDLDPk5g>
    <xmx:t_D5YmQQdgJJfNT6-5lC9CiLk_MQUlRP7B5NSKGWi_-Pu5S0lpf0tQ>
    <xmx:t_D5YimcOAQXvo3W0al3tXNC308-hbt1K8mIl39UuWbvWHrJZVT7pA>
Feedback-ID: i8771445c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 03:07:34 -0400 (EDT)
Date:   Mon, 15 Aug 2022 09:07:32 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     nicolas saenz julienne <nsaenz@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Kernel Panic in skb_release_data using genet
Message-ID: <20220815070732.kqfuxihjwkm2aqnj@houat>
References: <20210528163219.x6yn44aimvdxlp6j@gilmour>
 <77d412b4-cdd6-ea86-d7fd-adb3af8970d9@gmail.com>
 <9e99ade5-ebfc-133e-ac61-1aba07ca80a2@gmail.com>
 <483c73edf02fa0139aae2b81e797534817655ea0.camel@kernel.org>
 <20210602132822.5hw4yynjgoomcfbg@gilmour>
 <681f7369-90c7-0d2a-18a3-9a10917ce5f3@gmail.com>
 <20220513145653.rb7tah6dbjxc2fab@houat>
 <bdce6694-f5f9-37c3-915b-90a6524af919@gmail.com>
 <20220517075254.5sctk4hgomjvnuxg@houat>
 <a6035600-56f6-1760-ae5c-5e8131a2e8e4@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4egmokoi4tu3jnrs"
Content-Disposition: inline
In-Reply-To: <a6035600-56f6-1760-ae5c-5e8131a2e8e4@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4egmokoi4tu3jnrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Florian,

On Thu, Aug 11, 2022 at 08:33:58PM -0700, Florian Fainelli wrote:
>=20
>=20
> On 5/17/2022 12:52 AM, Maxime Ripard wrote:
> > It's not really 100% reliable, but happens 30%-50% of the time at boot
> > when KASAN is enabled. It seems like enabling KASAN increases that
> > likelihood though, it went unnoticed for some time before I started
> > having those issues again when I enabled it for something unrelated.
> >=20
> > It looks like it happens in bursts though, so I would get 10-15 boots
> > fine, and then 4-5 boots with that crash.
> >=20
> > Cold boot vs reboot doesn't seem to affect it in one way or the other.
> >=20
> > > What version of GCC did you build your kernel with?
> >=20
> > The arm64 cross-compiler packaged by Fedora, which is GCC 11.2
> > at the moment.
> >=20
> > > How often does that happen? What config.txt file are you using
> > > for your Pi4 B?
> >=20
> > You'll find my config.txt and kernel .config attached
>=20
> OK, so this is what I have been able to reproduce so far but this does not
> appear to be very reliable to reproduce, I will try my best to hold on to
> that lead though, thanks for your patience.
>=20
> # udhcpc -i eth0
> udhcpc: started, v1.35.0
> [   34.355086] bcmgenet fd580000.ethernet: configuring instance for exter=
nal
> RGMII (RX delay)
> [   34.363758]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   34.371106] BUG: KASAN: user-memory-access in put_page+0x10/0x64
> [   34.377227] Read of size 4 at addr 01000085 by task ifconfig/165
> [   34.383338]
> [   34.384857] CPU: 0 PID: 165 Comm: ifconfig Tainted: G        W   5.19.0
> #43
> [   34.392560] Hardware name: BCM2711
> [   34.396020]  unwind_backtrace from show_stack+0x18/0x1c
> [   34.401354]  show_stack from dump_stack_lvl+0x40/0x4c
> [   34.406502]  dump_stack_lvl from kasan_report+0x8c/0xa4
> [   34.411825]  kasan_report from put_page+0x10/0x64
> [   34.416615]  put_page from skb_release_data+0x84/0x13c
> [   34.421847]  skb_release_data from __kfree_skb+0x14/0x20
> [   34.427256]  __kfree_skb from bcmgenet_rx_poll+0x504/0x6f8
> [   34.432846]  bcmgenet_rx_poll from __napi_poll.constprop.0+0x50/0x1c0
> [   34.439407]  __napi_poll.constprop.0 from net_rx_action+0x278/0x488
> [   34.445787]  net_rx_action from __do_softirq+0x268/0x390
> [   34.451197]  __do_softirq from __irq_exit_rcu+0x88/0xf8
> [   34.456521]  __irq_exit_rcu from irq_exit+0x10/0x18
> [   34.461492]  irq_exit from call_with_stack+0x18/0x20
> [   34.466553]  call_with_stack from __irq_svc+0x84/0x94
> [   34.471696] Exception stack(0xf0d337f8 to 0xf0d33840)

It looks fairly close indeed.

There's a bunch of notable differences though (user-memory-access vs
wild-memory-access, the read size) but the type of memory access error
can just be due to the randomness of the memory address we try to
access, and the read 4 vs 8 could be because you're running on ARM and
I'm running on arm64?

Thanks again for looking into it

Maxime

--4egmokoi4tu3jnrs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYvnwtAAKCRDj7w1vZxhR
xZDVAP0UOK9wFid1KzfggZei3G1WUFMNJsRkjnbtNFoQwaAQlQD8DwecwYULxU1L
aC9aR4evJD/dSgswQS0/ePJdvWLL+AM=
=d6q2
-----END PGP SIGNATURE-----

--4egmokoi4tu3jnrs--
