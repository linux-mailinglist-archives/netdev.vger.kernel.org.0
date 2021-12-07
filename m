Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4022646B518
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 09:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhLGIJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 03:09:16 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45568 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhLGIJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 03:09:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 53F3CCE19ED
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 08:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3F9C341C1;
        Tue,  7 Dec 2021 08:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638864343;
        bh=0Xygzf5bwST8z1Lf2MHea0dwpYTH6KNJoU3pdVPfN48=;
        h=In-Reply-To:References:Cc:Subject:To:From:Date:From;
        b=Y2BNg8taHjkT8B7AzQ4QNdd/lUe9164A3r98xNMUCta/nFtpAxA3KIrgOaZGaeFUW
         75ylMmpjDH0HLrzutnva71ssvvV9rAemYYaTnLu93eotElKJuf0sGDMI3AnKdmMPpp
         70pMzbLvqbkhqdjXGDne166etx05g6n1MLOIprKDBIwqGAj3tU1mXOe45R4nfnV34z
         05xBRTJAvw325CatibD+sUlOoaw+/RlmeX/V3ltDfdyr/Q7ftojxMZLCSVkUYlE/fz
         4rbaBbmARt0h2vI/5HADKPB5fO5tug6BTWDu2n7Zch5Oqfz0lNTDuQr/W1MbaUYfk7
         8IPMJOWGHrhyg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211206071520.1fe7e18b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211203101318.435618-1-atenart@kernel.org> <07f2df6c-d7e5-9781-dae4-b0c2411c946c@linux.ibm.com> <20211206071520.1fe7e18b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Cc:     davem@davemloft.net, alexander.duyck@gmail.com, mkubecek@suse.cz,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] ethtool: do not perform operations on net devices being unregistered
To:     Jakub Kicinski <kuba@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <163886433967.108321.10984889226841148462@kwain>
Date:   Tue, 07 Dec 2021 09:05:39 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Jakub Kicinski (2021-12-06 16:15:20)
> On Mon, 6 Dec 2021 11:46:35 +0200 Julian Wiedmann wrote:
> >=20
> > Wondering if other places would also benefit from a netif_device_detach=
()
> > in the unregistration sequence ...
>=20
> Sounds like a good idea but maybe as a follow up to net-next?=20
> The likelihood of that breaking things is low, but non-zero.

Might be good to have a look at this yes. I'm wondering, there are
multiple mechanisms to avoid using a net device after unregistration,
including netif_device_detach and unlinking it from the device chain
(unlist_netdevice). Currently it's possible to have a device unlinked
but not detached. Haven't looked at it, but there might be something to
do here.

(One the other way, detaching a device without unlinking it is valid for
PM).

Antoine
