Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFF43438B6
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 06:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhCVFjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 01:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbhCVFjP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 01:39:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69882601FE;
        Mon, 22 Mar 2021 05:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616391555;
        bh=wtAYmmg5bTmlX11026gT4vxnsv9pHiDO0GoAP4cPjN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xp3IMm9BgBDPBrOU1gWtYBz1KmnBjDWnIdISWcsoy2IrleEvHTAPJbAheSq5/Vx/R
         p7+dSW+ZKB82D5dxUnKt64B+vMhMxTKWfnRzpqMwuxvxVpZ4DupgF2GjPAflm5tDxU
         njaKmhxIc0qnlPFFGKPCqHwdJ2EHy9f9D/R4OYYrm3Y1m0C0H8I9ngJKXSB5DvU7sF
         pAEsY6pNUJFrwksSP7ZWcfa6E/pSIFskPZ9I7AhtB1XpDr7+q+IxrfWNKvKFTgtyFY
         I/9dYM98IvxgM7zcDu5L6PARQcTCOjXj/s0xsVBfBIpQSoc5WV/hOG9gz054d0YytQ
         22szeX2q8CKUA==
Date:   Mon, 22 Mar 2021 07:39:11 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Hsu, Chiahao" <andyhsu@amazon.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        kuba@kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable
 ctrl-ring
Message-ID: <YFgtf6NBPMjD/U89@unreal>
References: <20210311225944.24198-1-andyhsu@amazon.com>
 <YEuAKNyU6Hma39dN@lunn.ch>
 <ec5baac1-1410-86e4-a0d1-7c7f982a0810@amazon.com>
 <YEvQ6z5WFf+F4mdc@lunn.ch>
 <YE3foiFJ4sfiFex2@unreal>
 <64f5c7a8-cc09-3a7f-b33b-a64d373aed60@amazon.com>
 <YFI676dumSDJvTlV@unreal>
 <f3b76d9b-7c82-d3bd-7858-9e831198e33c@amazon.com>
 <YFeAzfJsHAqPvPuY@unreal>
 <12f643b5-7a35-d960-9b1f-22853aea4b4c@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12f643b5-7a35-d960-9b1f-22853aea4b4c@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 06:54:52PM +0100, Hsu, Chiahao wrote:
> 

<...>

> > > Typically there should be one VM running netback on each host,
> > > and having control over what interfaces or features it exposes is also
> > > important for stability.
> > > How about we create a 'feature flags' modparam, each bits is specified for
> > > different new features?
> > At the end, it will be more granular module parameter that user still
> > will need to guess.
> I believe users always need to know any parameter or any tool's flag before
> they use it.
> For example, before user try to set/clear this ctrl_ring_enabled, they
> should already have basic knowledge about this feature,
> or else they shouldn't use it (the default value is same as before), and
> that's also why we use the 'ctrl_ring_enabled' as parameter name.

It solves only forward migration flow. Move from machine A with no
option X to machine B with option X. It doesn't work for backward
flow. Move from machine B to A back will probably break.

In your flow, you want that users will set all module parameters for
every upgrade and keep those parameters differently per-version.

Thanks

> 
> Thanks
> > Thanks
> > 
> 
