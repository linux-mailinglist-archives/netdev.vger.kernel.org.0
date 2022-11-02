Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A5361636E
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 14:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiKBNLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 09:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiKBNLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 09:11:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042E02A42B;
        Wed,  2 Nov 2022 06:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667394701; x=1698930701;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=MyZzeDiz5FTyiiKbmj7rYEgdW8PqPC9gOy+Y13MENvg=;
  b=dVuNbbYebDc+z5opb0hehyvEILtgMK+M+2WRAAmQuLU89WhvvKBUSK/0
   NiZitwSU/LYqRilQ6cBWyJRhmPdzHrmJHmh1UG+5+h0fKEqTmERbo3yZK
   +C1tfSpFdmQKqD9Ikuvirn58Ck15e5fQHMJXuPzqke4Tc2xoSi2gb1zPc
   8OXcGwr5UpenBwvH9QxywvXicQu6DFY62+GB0dIFx26oIRLTOuv946b/y
   9dCNhOtGAx55TZF+4Wyb4YJgxrI9TZ78P7U9dTNKKfq5XN1cE4zY4rwh2
   iZlHBJKQBfVU/TAemRFz+j2MiFLriYsWrYlxKM6PXYGMZWumbqrLpinQd
   w==;
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="185020498"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Nov 2022 06:11:40 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 2 Nov 2022 06:11:40 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 2 Nov 2022 06:11:37 -0700
Message-ID: <e9d662682b00a976ad1dedf361a18b5f28aac8fb.camel@microchip.com>
Subject: Re: [PATCH net-next v2 2/5] net: microchip: sparx5: Adding more tc
 flower keys for the IS2 VCAP
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Casper Andersson <casper.casan@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "Wan Jiabing" <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Wed, 2 Nov 2022 14:11:37 +0100
In-Reply-To: <20221101084925.7d8b7641@kernel.org>
References: <20221028144540.3344995-1-steen.hegelund@microchip.com>
         <20221028144540.3344995-3-steen.hegelund@microchip.com>
         <20221031103747.uk76tudphqdo6uto@wse-c0155>
         <51622bfd3fe718139cece38493946c2860ebdf77.camel@microchip.com>
         <20221031184128.1143d51e@kernel.org>
         <741b628857168a6844b6c2e0482beb7df9b56520.camel@microchip.com>
         <20221101084925.7d8b7641@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jacub,

On Tue, 2022-11-01 at 08:49 -0700, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Tue, 1 Nov 2022 08:31:16 +0100 Steen Hegelund wrote:
> > > Previous series in this context means previous revision or something
> > > that was already merged?
> >=20
> > Casper refers to this series (the first of the VCAP related series) tha=
t was
> > merged on Oct 24th:
> >=20
> > https://lore.kernel.org/all/20221020130904.1215072-1-steen.hegelund@mic=
rochip.com/
>=20
> Alright, looks like this is only in net-next so no risk of breaking
> existing users.
>=20
> That said you should reject filters you can't support with an extack
> message set. Also see below.
>=20
> > > > tc filter add dev eth3 ingress chain 8000000 prio 10 handle 10 \
> > >=20
> > > How are you using chains?
> >=20
> > The chain ids are referring to the VCAP instances and their lookups.=C2=
=A0 There
> > are some more details
> > about this in the series I referred to above.
> >=20
> > The short version is that this allows you to select where in the frame
> > processing flow your rule
> > will be inserted (using ingress or egress and the chain id).
> >=20
> > > I thought you need to offload FLOW_ACTION_GOTO to get to a chain,
> > > and I get no hits on this driver.
> >=20
> > I have not yet added the goto action, but one use of that is to chain a
> > filter from one VCAP
> > instance/lookup to another.
> >=20
> > The goto action will be added in a soon-to-come series.=C2=A0 I just wa=
nted to
> > avoid a series getting too
> > large, but on the other hand each of them should provide functionality =
that
> > you can use in practice.
>=20
> The behavior of the offload must be the same as the SW implementation.
> It sounds like in your case it very much isn't, as adding rules to
> a magic chain in SW, without the goto will result in the rules being
> unused.

I have sent a version 4 of the series, but I realized after sending it, tha=
t I
was probably not understanding the implications of what you were saying
entirely.

As far as I understand it now, I need to have a matchall rule that does a g=
oto
from chain 0 (as this is where all traffic processing starts) to my first I=
S2
VCAP chain and this rule activates the IS2 VCAP lookup.

Each of the rules in this VCAP chain need to point to the next chain etc.

If the matchall rule is deleted the IS2 VCAP lookups should be disabled as =
there
is no longer any way to reach the VCAP chains.

Does that sound OK?

BR
Steen

