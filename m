Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1193439F5
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 07:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCVGtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 02:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229995AbhCVGsj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 02:48:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAA10614A5;
        Mon, 22 Mar 2021 06:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616395719;
        bh=aBATp9cF4F75lj0dyqnEuKbgcMuvl6XXRbrTzcy1hz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jxLByM1eDq0pAWzRAwSsBEtuDaWYZqg6zod0MvQTrLNHpY8NTSNjhfdxcHiCxcly0
         DQvAMqQD2ShMoUpfkDwdvPTp96vCTOQyyF5JNn/wSHhGwxZeLsrClVpece2ySaXawI
         9PkHyUmoarBs6z/o6d5PNp531EJr0zEVQXexQChe8sA1IHKUtWghq6em8yj3+fdj38
         zgiMLsTuOooSmiopAu7+/VWDYsgtH5oeVEN0wZFXwmRUVemE/khxfZ35KmlLTwSlW4
         xQS8cccvEqeyLjNm11wnNaA/JB3l3/LOHvJ2RWO1sG9lws3q2FUmQMgtnHgX4oak0F
         zLXRmzzHY7zJA==
Date:   Mon, 22 Mar 2021 08:48:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc:     "Hsu, Chiahao" <andyhsu@amazon.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, wei.liu@kernel.org, paul@xen.org,
        davem@davemloft.net, kuba@kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable
 ctrl-ring
Message-ID: <YFg9w980NkZzEHmb@unreal>
References: <ec5baac1-1410-86e4-a0d1-7c7f982a0810@amazon.com>
 <YEvQ6z5WFf+F4mdc@lunn.ch>
 <YE3foiFJ4sfiFex2@unreal>
 <64f5c7a8-cc09-3a7f-b33b-a64d373aed60@amazon.com>
 <YFI676dumSDJvTlV@unreal>
 <f3b76d9b-7c82-d3bd-7858-9e831198e33c@amazon.com>
 <YFeAzfJsHAqPvPuY@unreal>
 <12f643b5-7a35-d960-9b1f-22853aea4b4c@amazon.com>
 <YFgtf6NBPMjD/U89@unreal>
 <c7b2a12d-bf81-3d5f-40ae-f70e6cfa1637@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <c7b2a12d-bf81-3d5f-40ae-f70e6cfa1637@suse.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 06:58:34AM +0100, J=FCrgen Gro=DF wrote:
> On 22.03.21 06:39, Leon Romanovsky wrote:
> > On Sun, Mar 21, 2021 at 06:54:52PM +0100, Hsu, Chiahao wrote:
> > >=20
> >=20
> > <...>
> >=20
> > > > > Typically there should be one VM running netback on each host,
> > > > > and having control over what interfaces or features it exposes is=
 also
> > > > > important for stability.
> > > > > How about we create a 'feature flags' modparam, each bits is spec=
ified for
> > > > > different new features?
> > > > At the end, it will be more granular module parameter that user sti=
ll
> > > > will need to guess.
> > > I believe users always need to know any parameter or any tool's flag =
before
> > > they use it.
> > > For example, before user try to set/clear this ctrl_ring_enabled, they
> > > should already have basic knowledge about this feature,
> > > or else they shouldn't use it (the default value is same as before), =
and
> > > that's also why we use the 'ctrl_ring_enabled' as parameter name.
> >=20
> > It solves only forward migration flow. Move from machine A with no
> > option X to machine B with option X. It doesn't work for backward
> > flow. Move from machine B to A back will probably break.
> >=20
> > In your flow, you want that users will set all module parameters for
> > every upgrade and keep those parameters differently per-version.
>=20
> I think the flag should be a per guest config item. Adding this item to
> the backend Xenstore nodes for netback to consume it should be rather
> easy.
>=20
> Yes, this would need a change in Xen tools, too, but it is the most
> flexible way to handle it. And in case of migration the information
> would be just migrated to the new host with the guest's config data.

Yes, it will overcome global nature of module parameters, but how does
it solve backward compatibility concern?

Thanks

>=20
>=20
> Juergen





