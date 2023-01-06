Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242A76601D7
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjAFOOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjAFOO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:14:29 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8CA77D2D;
        Fri,  6 Jan 2023 06:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673014468; x=1704550468;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=aEBfaaVuZETiOkWi+RcMNlVF6gTwODTi4CN2pCpZCms=;
  b=iQOYsQzTsZt9YLuT+8KtiCJuilgLcDKRp1IKq/Dh7OUI2iFu2ILNYE98
   ROTY/LSPt0aWAwG5aKlnGta0IlHYv2HiO43IK5/IKCi9jLU0GfiwsxSAo
   znWUYKFkFhqhxEdqVidDA4IpLahwKzL84Uq06vMYgWNIP0S9pEeJEXRDF
   vxTsVSoJQqeGV+pdUn782p4MrfSqaXFfqK4KmPxrG2t9WMRjcmwwIUH0d
   drVj+kSwWGr2MDkFOen5c5sFysfUOLWQnc1tuThwA5Ng7B1O8EOjb03F+
   Qyrv5ZMCr/A5efFAac8TRvtN6bM5bIwuJa1+4HC5yZINRR6pSEUTLu8eD
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="191090095"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jan 2023 07:14:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 07:14:26 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 07:14:22 -0700
Message-ID: <dc4c4fbf0cb1892dbe45c0ee80d5fafbd5fc36ff.camel@microchip.com>
Subject: Re: [PATCH net-next v2 0/8] Add support for two classes of VCAP
 rules
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        "Russell King" <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>
Date:   Fri, 6 Jan 2023 15:14:22 +0100
In-Reply-To: <40eea59265ce70a80ca61164608f4739@walle.cc>
References: <20230106085317.1720282-1-steen.hegelund@microchip.com>
         <35a9ff9fa0980e1e8542d338c6bf1e0c@walle.cc>
         <b6b2db49dfdd2c3809c8b2c99077ca5110d84d97.camel@microchip.com>
         <40eea59265ce70a80ca61164608f4739@walle.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Fri, 2023-01-06 at 11:46 +0100, Michael Walle wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> Hi,
>=20
> > > Wouldn't it make more sense, to fix the regression via net (and
> > > a Fixes: tag) and then make that stuff work without tc? Maybe
> > > the fix is just reverting the commits.
> >=20
> > I have discussed this again with Horatiu and I have the following
> > suggestion of
> > how to proceed:
> >=20
> > 1) Create a small LAN966x specific patch for net (see below for the two
> > possible
> > =C2=A0=C2=A0 variants).
> >=20
> > 2) Continue with a net-next V3 without any 'Fixes' tags on top of the
> > patch in
> > =C2=A0=C2=A0 (1) when it becomes available in net-next.
>=20
> Sounds good.
>=20
> [coming back to this after writing the response below, so see there
> for more context]
> When do the patches from net become available in net-next? Only after a
> merge window? If so, depending on the solution for (1) you'd have two
> "in-between" kernel versions (v6.2 and v6.3).

According to our own experience the changes in net are usually merged into =
net-
next the following Thursday: so not too much delay, before we can continue.

>=20
> > The LAN966x patch for net (with a Fixes tag) could contain either:
> >=20
> > a) No check on enabled lookup
> >=20
> > =C2=A0=C2=A0 Removal of the check for enabled lookups:
> >=20
> > =C2=A0=C2=A0 -=C2=A0 if (!ANA_VCAP_S2_CFG_ENA_GET(val))
> > =C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -ENOENT;
> >=20
> > =C2=A0=C2=A0 This will remove the error that you have seen, but=C2=A0 w=
ill still
> > require a
> > =C2=A0=C2=A0 matchall rule to enable the PTP rules.=C2=A0 This is compa=
tible with the
> > TC
> > =C2=A0=C2=A0 framework.
> >=20
> > b) Always enable lookups
> >=20
> > =C2=A0=C2=A0 Enable the lookups at startup.
> > =C2=A0=C2=A0 Remove the lookup enable check as above.
> >=20
> > =C2=A0=C2=A0 This will make the PTP rules (and any other rules) work ev=
en without
> > the
> > =C2=A0=C2=A0 matchall rule to enable them.=C2=A0 It its not ideal, but =
solves the
> > problem that
> > =C2=A0=C2=A0 you have been experiencing without the 'TC magic'
> >=20
> > =C2=A0=C2=A0 The V3 in net-next will provide the full solution.
> >=20
> > I expect that you might prefer the b) version.
>=20
> I *assume* linuxptp would have worked in my case (no bridge interface)
> before Horatiu patches. As mentioned before, I haven't really tested it.
> Does that mean with a) the error is gone and linuxptp is working as
> before? If so, I'm also fine with a).

Yes this is the result: So I also suggest to go for solution a).

This will still allow LinuxPTP to work (without the error that you have see=
n),
but the bridged interface PTP support must be enabled with a TC matchall ru=
le.

>=20
> Honestly, now that there is a good solution in future kernels, I
> don't care toooo much about that one particular kernel. Other
> users might disagree though ;)
>=20
> I just want to point out that right now you have some kind of
> in-between kernel with 6.2:
>=20
> =C2=A0 <=3D6.1 linuxptp working (but not on bridged ports)
> =C2=A0 6.2=C2=A0=C2=A0 linuxptp working only with tc magic
> =C2=A0 6.3=C2=A0=C2=A0 linuxptp working

So with the LAN966x patch the second line would change to:

6.2   linuxptp working. PTP on bridged interfaces: needs TC matchall rule

>=20
> Therefore, I've raised the question if it's also viable to just
> revert the former changes for 6.2. The you'd have a clean
> transition.
>=20
> -michael

TLDR Summary:

1) LAN966x patch for net to ensure PTP is working without errors
2) A V3 net-next VCAP series with the improvements for enabled/disable/perm=
anent
rules (both LAN966x and Sparx5)

I will move forward with this.

BR
Steen

