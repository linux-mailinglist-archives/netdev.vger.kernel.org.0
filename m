Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15475100F4
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 16:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344498AbiDZOyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 10:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243963AbiDZOyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 10:54:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BC944755
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 07:51:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E56E261899
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 14:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCE5C385A0;
        Tue, 26 Apr 2022 14:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650984695;
        bh=F8javr8Mied5dRV60ZCGWY3cQV41StthERn7962M3jc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u5Xk8Lh313Scw/SLeobdzb9fuT8KP7PAcOexZfPJOlkMQH2r6xhSbgVajpMRHcQJO
         j8uoGWo5qiyOs1086IGKODLNwF7+5Sz1dO28hNBWVSyTVeBuOm1Q3HihgR/p/MBMk/
         2XDDeKwvrFrCLWXNuWZDpjsvn7fS6thTNshr/cNblU7EBcIVp8Yn0IIa2d2fP/gy9s
         sXexF/ATUKn1HZuZACjoSmTldqbYilJPPNaemdjaMU/qEdFrllizcVcbTaX+zzuOW/
         /V+vyHboM90MXqqE3Nw8kHWfOMGmrSRMwMcrFYvKBQ8W1VgDV1piJN4oDKqZk71lMU
         FEixBUGpT3/mw==
Date:   Tue, 26 Apr 2022 07:51:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220426075133.53562a2e@kernel.org>
In-Reply-To: <Ymf66h5dMNOLun8k@nanopsycho>
References: <20220425034431.3161260-1-idosch@nvidia.com>
        <20220425090021.32e9a98f@kernel.org>
        <Ymb5DQonnrnIBG3c@shredder>
        <20220425125218.7caa473f@kernel.org>
        <YmeXyzumj1oTSX+x@nanopsycho>
        <20220426054130.7d997821@kernel.org>
        <Ymf66h5dMNOLun8k@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Apr 2022 16:00:10 +0200 Jiri Pirko wrote:
> >> But you have to somehow link the component to the particular gearbox on
> >> particular line card. Say, you need to flash GB on line card 8. This is
> >> basically providing a way to expose this relationship to user.
> >>=20
> >> Also, the "lc info" shows the FW version for gearboxes. As Ido
> >> mentioned, the GB versions could be listed in "devlink dev info" in
> >> theory. But then, you need to somehow expose the relationship with
> >> line card as well. =20
> >
> >Why would the automation which comes to update the firmware care=20
> >at all where the component is? Humans can see what the component=20
> >is by looking at the name. =20
>=20
> The relationship-by-name sounds a bit fragile to me. The names of
> components are up to the individual drivers.

I asked you how the automation will operate. You must answer questions
if you want to have a discussion. Automation is the relevant part.
You're not designing an interface for SDK users but for end users.

> >If we do need to know (*if*!) you can list FW components as a lc
> >attribute, no need for new commands and objects. =20
>=20
> There is no new command for that, only one nested attribute which
> carries the device list added to the existing command. They are no new
> objects, they are just few nested values.

DEVLINK_CMD_LINECARD_INFO_GET

> >IMHO we should either keep lc objects simple and self contained or=20
> >give them a devlink instance. Creating sub-objects from them is very =20
>=20
> Give them a devlink instance? I don't understand how. LC is not a
> separate device, far from that. That does not make any sense to me.

You can put a name of another devlink instance as an attribute of a lc.
See below.

> >worrying. If there is _any_ chance we'll need per-lc health reporters=20
> >or sbs or params(=F0=9F=A4=A2) etc. etc. - let's bite the bullet _now_ a=
nd create
> >full devlink sub-instances! =20
>=20
> Does not make sense to me at all. Line cards are detachable PHY sets in
> essence, very basic functionality. They does not have buffers, health
> and params, I don't think so.=20

I guess the definition of a "line card" has become somewhat murky over
the years, since the olden days of serial lines.

Perhaps David and others can enlighten us but what I'm used to hearing
about as a line card these days in a chassis system is a full-on switch.
Chassis being effectively a Clos network in a box, the main difference
being the line cards talk cells to the backplane, not full packets.

Back in my Netronome days we called those detachable front panel gear
boxes "phy mods". Those had nowhere near the complexity of a real line
card. Sounds like that's more aligned with what you have.

To summarize, since your definition of a line card is a bit special,
the less uAPI we add to fit your definition we add the better.

> >> I don't see any simpler iface than this. =20
> >
> >Based on the assumptions you've made, maybe, but the uAPI should
> >abstract away the irrelevant details. I'm questioning the assumptions. =
=20
>=20
> Is the FW version of gearbox on a line card irrelevand detail?

Not what I said.

> If so, how does the user know if/when to flash it?
> If not, where would you list it if devices nest is not the correct place?

Let me mock up what I had in mind for you since it did not come thru=20
in the explanation:

$ devlink dev info show pci/0000:01:00.0
    versions:
        fixed:
          hw.revision 0
          lc2.hw.revision a
          lc8.hw.revision b
        running:
          ini.version 4
          lc2.gearbox 1.1.3
          lc8.gearbox 1.2.3

$ devlink lc show pci/0000:01:00.0 lc 8
pci/0000:01:00.0:
  lc 8 state active type 16x100G
    supported_types:
      16x100G
    versions:=20
      lc8.hw.revision (a)=20
      lc8.gearbox (1.2.3)

Where the data in the brackets is optionally fetched thru the existing
"dev info" API, but rendered together by the user space.

> >> There are 4 gearboxes on the line card. They share the same flash. So
> >> if you flash gearbox 0, the rest will use the same FW. =20
> >
> >o_0 so the FW component is called lcX_dev0 and yet it applies to _all_
> >devices, not just dev0?! Looking at the output above I thought other
> >devices simply don't have FW ("flashable false"). =20
>=20
> Yes, device 0 is "flash master" (RW). 1-3 are RO. I know it is a bit
> confusing. Maybe Andy's suggestion of "shared" flag of some sort might
> help.
>=20
> >> I'm exposing them for the sake of completeness. Also, the interface
> >> needs to be designed as a list anyway, as different line cards may
> >> have separate flash per gearbox.
> >>=20
> >> What's is the harm in exposing devices 1-3? If you insist, we can hide
> >> them. =20
> >
> >Well, they are unnecessary (this is uAPI), and coming from the outside
> >I misinterpreted what the information reported means, so yeah, I'd
> >classify it as harmful :( =20
>=20
> UAPI is the "devices nest". It has to be list one way or another
> (we may need to expose more gearboxes anyway). So what is differently
> harmful with having list [0] or list [0,1,2,3] ?
