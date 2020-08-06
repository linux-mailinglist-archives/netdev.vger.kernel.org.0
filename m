Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F1F23D806
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 10:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgHFIdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 04:33:41 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:59870 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgHFIdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 04:33:40 -0400
Date:   Thu, 06 Aug 2020 08:33:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1596702817; bh=QJNWfmufjOSaXqsM+ef3zoc4KvS4z+GKTDBcibh5Yoc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Q8iC+Hy4vi226TsReA96tD3u19MGnEPa3qxlajgjBzCoOgcOlXjAlObPy7Dz3dVSj
         AROSqnd00cdosNCfxiDPehJenB1tJWQPrb4qT/EMXUD+ieszVSN0KXkFgdlBinpeE9
         7o8+PY2k+M6SPnJI4+pbwECMw6HV482sx+7liqga02+DDgpVmb+mlqc0LvIHuv1Q4O
         e/eAq2MlxTJMmxTAogNGfQUtqfnsifCmAsZqSZanpmV7ZWtBttLcFKXnTkbG9Cmjpe
         aI4rqi76+rrTSuGuD2qkRnJ3DfGXqOPZsVuO6/V4atVHSHPWSxHue+zxnsrrbY/ASt
         t887q10XdQReg==
To:     Ido Schimmel <idosch@idosch.org>
From:   Swarm NameRedacted <thesw4rm@pm.me>
Cc:     netdev@vger.kernel.org
Reply-To: Swarm NameRedacted <thesw4rm@pm.me>
Subject: Re: Packet not rerouting via different bridge interface after modifying destination IP in TC ingress hook
Message-ID: <20200806083330.zwnawy5d6b54lwh6@chillin-at-nou.localdomain>
In-Reply-To: <20200806074909.GA2624653@shredder>
References: <20200805081951.4iznjdgudulitamc@chillin-at-nou.localdomain> <20200805133922.GB1960434@lunn.ch> <20200805201204.vsnav57fmgqkkpxf@chillin-at-nou.localdomain> <20200806063336.GA2621096@shredder> <20200806070011.fmqvd4hekpehx425@chillin-at-nou.localdomain> <20200806074909.GA2624653@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok that makes sense. I'll try it. However, doesn't hairpin imply that
the packet will be routed back into the same machine via some public
address and separate router? I'm just trying to redirect it to
10.10.4.1, not loop it back to 10.10.3.1. Or is this an
unorthodox/modified usage of hairpinning?

On Thu, Aug 06, 2020 at 10:49:09AM +0300, Ido Schimmel wrote:
>=20
> On Thu, Aug 06, 2020 at 07:00:15AM +0000, Swarm NameRedacted wrote:
> > Not sure this applies. There's no NAT since everything is on the same
> > subnet.
>=20
> IIUC, packet is received on eth0, you then change the DMAC to SMAC on
> ingress (among other things) and then packet continues to the bridge.
> The bridge checks the DMAC and sees that the packet is supposed to be
> forwarded out of eth0. Since it's also the ingress interface the packet
> is dropped. To overcome this you need to enable hairpin.

