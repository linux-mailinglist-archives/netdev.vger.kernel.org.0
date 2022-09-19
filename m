Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D0E5BCD5C
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 15:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiISNgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 09:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiISNgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 09:36:05 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214CA11455;
        Mon, 19 Sep 2022 06:36:05 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1663594563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AsQVsvTF/HOpeN38ebD/PN6GbT91o7JcgHzzjww8Q64=;
        b=iCs8dt2nxzdxfd+BMaLN0I2NfejhA/p8DKUzFS/qfdLXoGBurYOZOa23r6T6Xva08FxEjN
        gbhJBh1NF0csnmt27rHhFRwhTQexHZcL/3zcw/y5YBe2LyA+Ypwb6Dc+cE9q5NJSt+axFb
        AUcndXEWL/JBhXtjRRqv02D7PinW7Ltwb3IWgoMRNm1VndOSRuNrAXoagIFTDpt4OE8uVu
        v/BPCYgNEdidmHuTIc05q0sb3dllb7Z/SUIK9ru9Ypjry2iLinjpxMxVomTjZrbydM10WU
        FTjdEIZy9OB6zvVmBR35nnNUes+PVCSU1TsQ/GXP0Fs3J6/ncNw2K6torCA0qg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1663594563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AsQVsvTF/HOpeN38ebD/PN6GbT91o7JcgHzzjww8Q64=;
        b=FM1sJpHnraUmCrIiIOUI/AyC8mXrjNk7sPunFwHAN2lriWY5pOpKHtdjDtfpQ9ZXhnsLFG
        4J4SSOYdcBn3/GBg==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 08/13] net: dsa: hellcreek: deny tc-taprio
 changes to per-tc max SDU
In-Reply-To: <20220915115925.zujsneox4jqzod2g@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-9-vladimir.oltean@nxp.com> <87a671bz8e.fsf@kurt>
 <20220914184051.2awuutgr4vm4tfgf@skbuf> <87r10dxiw5.fsf@kurt>
 <20220915115925.zujsneox4jqzod2g@skbuf>
Date:   Mon, 19 Sep 2022 15:36:01 +0200
Message-ID: <87bkrbzdtq.fsf@kurt>
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
Content-Transfer-Encoding: quoted-printable

On Thu Sep 15 2022, Vladimir Oltean wrote:
> On Thu, Sep 15, 2022 at 08:15:54AM +0200, Kurt Kanzenbach wrote:
>> > So the maxSDU hardware register tracks exactly the L2 payload size, li=
ke
>> > the software variable does, or does it include the Ethernet header size
>> > and/or FCS?
>>=20
>> This is something I'm not sure about. I'll ask the HW engineer when he's
>> back from vacation.
>
> You can also probably figure this out by limiting the max-sdu to a value
> like 200 and seeing what frame sizes pass through.

Oh, yes. I'll try that.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmMocEETHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgu+cEACHTcvU7q9lPx5uB5lstpykvqf3SJ//
LHEb0vAGLP6y2etVFztxDEbuaaQKkhYsl6ZxNZhfAoKFKb9HnZ4XWEv/b4x68dOw
mRR1hZBcZDt7ecNqxCKfwI+qB/Aza1V3h7j0g+kcHY7pfj0Hrj1hrKqmBHlBrBRG
Mv2luJN+/4pvJ79ZfKuTkLDrAYShDGCxxWiw2RXHGGuZbDLeyb3eZsBUnCmEi7Pc
+l265kLHuQ/ve1CVTlZlMSksAZcQeeJH6gHwdc3ZdVbamEQFaxBmf495JX6Q628N
pkaRRp60MXpxUifVksTZKQsVYKMnvp+y8hEVUnh++1MMUWHlUVM2LqO+vQlb1BSZ
AxKFsHhgokXipRFXnc5YMQ/DPhiF650CDakmLd73FPAaSVII2a0CEITPBdHF9Qjl
OSeDvAstcfD2Pmz6Oq1AfUEcpyqyiegLVT0dQvUM/fmtYoADywbEAEH1uUTLE7qb
je7pkUykjfeQ/UPJgScSr69rQIOTLYOxbX27ThpWmuP8sbd8SqJvExnaexy/H1mD
TtLpaRJm0kXO1bfoRdxn/RUabQItsTm5zZnatL/OiHIcyDcb8wAT9WVA5r7Ndj8T
aUjkIRclGQUDbGiiBGdpeEeFwGCl/Dd7JnukSxbJyd+PjWXbj5KZloteXXpZZig0
SPoChYb8zYia9g==
=36wz
-----END PGP SIGNATURE-----
--=-=-=--
