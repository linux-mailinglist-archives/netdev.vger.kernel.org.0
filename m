Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0E85BFCE2
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 13:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiIULXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 07:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIULX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 07:23:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C53671719;
        Wed, 21 Sep 2022 04:23:28 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1663759406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TmAJB9Sb+6RRhGyFle8Ut+1ahV8/Sv3SezEtIHTpxaE=;
        b=dbFwAzhddvZYKBBz4lIT+IsILTjen+y0r9zzQfhpmVQWrlv/4n2w+YnYW5Vn4+jX1R51UX
        Fx0/KlI3rlX8u15QlFV/gl3xEHI6o+JS3The60zRWt8PumXzgMTn4fntb6wBoy5aPYFVSG
        bQrU/w6sHYKeWyPsFux86IGESz77gvRyC80hnzmC0u9CYWr+KGQixpd4ISdeGP+ALXIdaP
        YHjLIAtIn9Zo0MMgHGkvHY235I5cuLdpejJmNMDpOjlFxRloqVdGKWZxd2i+MvCZGr0idB
        T5er29Xnb1bniEV2e8iGBcavOCO2WNRZx7UtBrpX1vrzq44mOuEzjL82Gw0Jeg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1663759406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TmAJB9Sb+6RRhGyFle8Ut+1ahV8/Sv3SezEtIHTpxaE=;
        b=ldXnMiZOMPABz6cUdvleKoePT2TXd7X7GBtcBCU0cMv1EKXb35ixxsRy1vt0w8gl4OiSfZ
        5z3ZfrIcFMoHHNDQ==
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
Date:   Wed, 21 Sep 2022 13:23:24 +0200
Message-ID: <87bkr9m0nn.fsf@kurt>
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

So, configured to 128 and 132 bytes (including VLAN Ethernet header) is
the maximum frame size which passes through.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmMq9CwTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzghw6D/49uWpFKmCVZeyq8h75Bf10J4IZgG/C
rvduMy58koDNL17TfKKcc5aFWOqJ0eTF9U/dYdoa4bpi0XFxxcGfFM5SchSToqn8
TrulDK9Q4/X4mmGDhpBYshbsLVQg/cTu76cYMwWnAlUfR+P/Xk1Qjk5y5S7UYqI8
ADQ8TaLQffOAocZrGHy0dlfl/pmRGzJPDafh126IFDRHBc0cAoZSfqiMqWEfocsv
lmdgH9hElw4L1INXbB37CgM+FGMENf/pEpTxWIGzsKNsy0HkZju3hrFrCAbmEa5C
U6jesfjH5Ufw7ZEaelE5G72eVoHf02rqo+igckBIkbigXcvwdKeG8xJNOR+qfXsK
e3RvB/ZOQSLO9n+1iqHsUo3UydUy8BypWK/TQWCZgEvLikTzu4TosGESOyQDQ3SE
8pHbzNlx0MYuEupyQlTNjUQiDXqPBkOAHRjUcjkoCVTgz9oc4YhrvsQaddJ5h7o6
Sde4uRp773Z/yXlYs5SSkX63iE0vzQ1gG/ne9VY546YDpOaEUS/RgOCxEeqfHrDQ
ZBmVwH1wkAUfF2nMuixgZSJfgq9IaPApLJv4Y+KJpXQE0hibxIC2w4G7e1UfD8r7
8Y1222lPUQojol8kk409+7/ccp7N92hsk4gmgF3+0zK7wGfORpHf1FEmbIOF2jVf
vaizLQvTtGQFJA==
=7Bk7
-----END PGP SIGNATURE-----
--=-=-=--
