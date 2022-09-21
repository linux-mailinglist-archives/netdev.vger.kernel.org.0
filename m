Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1B15BFD2C
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 13:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiIULqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 07:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiIULq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 07:46:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385998709D;
        Wed, 21 Sep 2022 04:46:27 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1663760785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+h5OB886Dzz/hwPi6y3bnH4tBaZnTz6gSDGhoyX42fM=;
        b=EKqm+o89UidMbgUhAt1wAmGnHDv5RQ2OoSdOS6hA9VZWTWvQFLRPfXeHzxEpGIwAbZBIu3
        UnTdgA5cyyWt0y3rLbDCVWY3GXQmgGtDKBlmawzYzDus9UHXYQQA4uc2MfKxqO/bBbcjCp
        P609VGxyP/EBJqKokiON4shumesBkVFHh+/uTo96yHg7pO+eMZSvdEqwQDkxZIu0ID1ems
        9KhdFvpTDK7B9FwnS+qx+1XDhNPIvGhG+0btFIOOFmJCXqKbSVbdcCoXrM1GzLKJ8UTyOo
        +73x9Z5sO/X/mZSxPU1TxF+8frBnuoeAr1imqodzHBAxgWuOAxlwTFZPyxH2EQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1663760785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+h5OB886Dzz/hwPi6y3bnH4tBaZnTz6gSDGhoyX42fM=;
        b=281BLSmmIT4ZtfMUGMyANtLWIeS0k+Bg/wnoPYtsL4nsgBRSaXkknrVm0/YyEPy99a9JbN
        Ai5EVTGkRku4MsAA==
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
In-Reply-To: <20220921112916.umvtccuuygacbqbb@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-9-vladimir.oltean@nxp.com> <87a671bz8e.fsf@kurt>
 <20220914184051.2awuutgr4vm4tfgf@skbuf> <87r10dxiw5.fsf@kurt>
 <20220915115925.zujsneox4jqzod2g@skbuf> <87bkr9m0nn.fsf@kurt>
 <20220921112916.umvtccuuygacbqbb@skbuf>
Date:   Wed, 21 Sep 2022 13:46:22 +0200
Message-ID: <878rmdlzld.fsf@kurt>
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

On Wed Sep 21 2022, Vladimir Oltean wrote:
> On Wed, Sep 21, 2022 at 01:23:24PM +0200, Kurt Kanzenbach wrote:
>> On Thu Sep 15 2022, Vladimir Oltean wrote:
>> > On Thu, Sep 15, 2022 at 08:15:54AM +0200, Kurt Kanzenbach wrote:
>> >> > So the maxSDU hardware register tracks exactly the L2 payload size,=
 like
>> >> > the software variable does, or does it include the Ethernet header =
size
>> >> > and/or FCS?
>> >>=20
>> >> This is something I'm not sure about. I'll ask the HW engineer when h=
e's
>> >> back from vacation.
>> >
>> > You can also probably figure this out by limiting the max-sdu to a val=
ue
>> > like 200 and seeing what frame sizes pass through.
>>=20
>> So, configured to 128 and 132 bytes (including VLAN Ethernet header) is
>> the maximum frame size which passes through.
>
> Frame size means MAC DA + MAC SA + VLAN header + Ethertype + L2 payload,
> and without FCS, right?

Yes.

>
> Because max_sdu 128 only counts the L2 payload, so the maximum frame
> size that passes should be 142 octets, or 146 octets with VLAN.

Ok, i see. So, for 128 max-sdu we should end up with something like this
in the prio config register:

 schedule->max_sdu[tc] + VLAN_ETH_HLEN - 4

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmMq+Y4THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgsQMD/9WRNdSk5bgkVm3cV5TvCmIaW9J5DID
qcw8at7AMpg33GRleT0ovLrCYdP/jpuG1bL9ODgs6hB9WG/sxTae0ElfWpiwQdpx
7F/5pImKfg3EXARHVULww3L63xFYgdeoYHyqjNYscWtxCtTS+uO6paksZBpga6Gf
zYM0p/W0fIPAjBsvzdI3+BCy42ut6K2iwMGvD9YZ7zbHr8RdGtnW1+gsfzzuu/Iz
15erg05SpFZGTNYpSGJ4KZAU09IvtjUqVA9m7DAunQaRvq7def7OSrtb+Plvbym2
wz6rU16pULDvm1i9e7lAwXAmaGu34H/Pb7xp0q9k14mxrztmrouRc22XGvI328b0
eAPHDSZcRyNgSG6GEvjR8jDMwg+Zrp+/dgtnNjIj+lOvSKrBAsUAfyN2UWfvCU5Y
YfV1r5sa/0rfUE3CvxgTwnFiCk36F5DO+n9kWiCdNqST6bsibLBuzdZvoBRcuAu/
/fA8VCfX+xeRTNkHyWzuoHHwgfmU74vbmL4P4poQZeY5Sallr7LXzIh9OYR+3NFh
iqd7xEgSVdT1OZsgaXI4trWzvr1dlWlsx22FANwMPL8/ar80HdPsU5eRKm1+i/mJ
3iVcakxcj4GbQBHuSaerIAJexJ02luKwrlxJn+i0Xll+N/+FkqzQzuD5NNhjJTDk
Pj9SEV4COxIFEw==
=ywiY
-----END PGP SIGNATURE-----
--=-=-=--
