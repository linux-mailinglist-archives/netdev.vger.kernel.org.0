Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF0F50FD4E
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 14:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350119AbiDZMol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 08:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344440AbiDZMol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 08:44:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCAA15F59F
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 05:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7EA86190F
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 12:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16F7C385A0;
        Tue, 26 Apr 2022 12:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650976892;
        bh=MguhDM56GtTRrtXJzxzUC/5JO5j46vczHEOadrwG8c8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f2siHGDYIfMp7d9iTi786PFo3v1uJX7DVFvlGiY/sZ5TRjPlzDOuJiyj1PaYZtBev
         Rd+U/wThhIg/BTSKncKGsSDCeIrl+8u3XNne1w9ARz+nPZLmg1rn6nDg7In1EV2iZq
         uFMR1Yz8eGoLG2kFx26zKtW4Vf7oWvWyACqrzsVzBIBS46WpiwzzT1zUBNNsslPplA
         9GcDG4ZlQD2RHb0IHhVylW9aJErHPaZJN6BL1iUbyo4LHnGDDh9UWLCs6c3kVQHI3M
         oPTV5BjX2cHPICqN9wBmM/upyJrcNg40e4NLe/VytCGVnAYySjWbki4/gD08GsUmxq
         hInXD5knzSc1g==
Date:   Tue, 26 Apr 2022 05:41:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220426054130.7d997821@kernel.org>
In-Reply-To: <YmeXyzumj1oTSX+x@nanopsycho>
References: <20220425034431.3161260-1-idosch@nvidia.com>
        <20220425090021.32e9a98f@kernel.org>
        <Ymb5DQonnrnIBG3c@shredder>
        <20220425125218.7caa473f@kernel.org>
        <YmeXyzumj1oTSX+x@nanopsycho>
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

On Tue, 26 Apr 2022 08:57:15 +0200 Jiri Pirko wrote:
> >> In this particular case, these devices are gearboxes. They are running
> >> their own firmware and we want user space to be able to query and upda=
te
> >> the running firmware version. =20
> >
> >Nothing too special, then, we don't create "devices" for every
> >component of the system which can have a separate FW. That's where
> >"components" are intended to be used.. =20
>=20
> *
> Sure, that is why I re-used components :)

Well, right, I guess you did reuse them a little :)

> But you have to somehow link the component to the particular gearbox on
> particular line card. Say, you need to flash GB on line card 8. This is
> basically providing a way to expose this relationship to user.
>=20
> Also, the "lc info" shows the FW version for gearboxes. As Ido
> mentioned, the GB versions could be listed in "devlink dev info" in
> theory. But then, you need to somehow expose the relationship with
> line card as well.

Why would the automation which comes to update the firmware care=20
at all where the component is? Humans can see what the component=20
is by looking at the name.

If we do need to know (*if*!) you can list FW components as a lc
attribute, no need for new commands and objects.

IMHO we should either keep lc objects simple and self contained or=20
give them a devlink instance. Creating sub-objects from them is very
worrying. If there is _any_ chance we'll need per-lc health reporters=20
or sbs or params(=F0=9F=A4=A2) etc. etc. - let's bite the bullet _now_ and =
create
full devlink sub-instances!

> I don't see any simpler iface than this.

Based on the assumptions you've made, maybe, but the uAPI should
abstract away the irrelevant details. I'm questioning the assumptions.

> >> The idea (implemented in the next patchset) is to let these devices
> >> expose their own "component name", which can then be plugged into
> >> the existing flash command:
> >>=20
> >>     $ devlink lc show pci/0000:01:00.0 lc 8
> >>     pci/0000:01:00.0:
> >>       lc 8 state active type 16x100G
> >>         supported_types:
> >>            16x100G
> >>         devices:
> >>           device 0 flashable true component lc8_dev0
> >>           device 1 flashable false
> >>           device 2 flashable false
> >>           device 3 flashable false
> >>     $ devlink dev flash pci/0000:01:00.0 file some_file.mfa2
> >> component lc8_dev0 =20
> >
> >IDK if it's just me or this assumes deep knowledge of the system.
> >I don't understand why we need to list devices 1-3 at all. And they
> >don't even have names. No information is exposed.  =20
>=20
> There are 4 gearboxes on the line card. They share the same flash. So
> if you flash gearbox 0, the rest will use the same FW.

o_0 so the FW component is called lcX_dev0 and yet it applies to _all_
devices, not just dev0?! Looking at the output above I thought other
devices simply don't have FW ("flashable false").

> I'm exposing them for the sake of completeness. Also, the interface
> needs to be designed as a list anyway, as different line cards may
> have separate flash per gearbox.
>=20
> What's is the harm in exposing devices 1-3? If you insist, we can hide
> them.

Well, they are unnecessary (this is uAPI), and coming from the outside
I misinterpreted what the information reported means, so yeah, I'd
classify it as harmful :(
