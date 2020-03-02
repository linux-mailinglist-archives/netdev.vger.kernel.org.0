Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE605176882
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 00:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgCBXxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 18:53:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbgCBXxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 18:53:22 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8010217F4;
        Mon,  2 Mar 2020 23:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583193202;
        bh=hbNqnPBtUpqybgt2vSUd9gxcJQj6Ya7I+Wr2dvxHQMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sr7fIpIwoMSL9fC5yHwuK9O5/DvukD8YVJaEI9R2wQ5wWp7fDaZHq73qGg5syjDU6
         GHp6Ebwu6+6LmECFgdqy8tEBJ+zDrNI+cF631eKBRFS1P2siNADEzijU3kf54SR/U5
         W3SNhBkaaptScM7TPN3bg+eJRmXxp6umHHsjzlkE=
Date:   Mon, 2 Mar 2020 15:53:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Machulsky, Zorik" <zorik@amazon.com>
Cc:     Josh Triplett <josh@joshtriplett.org>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ena: Speed up initialization 90x by reducing poll
 delays
Message-ID: <20200302155319.273ee513@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8B4A52CD-FC5A-4256-B7DE-A659B50654CE@amazon.com>
References: <20200229002813.GA177044@localhost>
        <8B4A52CD-FC5A-4256-B7DE-A659B50654CE@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Mar 2020 23:16:32 +0000 Machulsky, Zorik wrote:
> =EF=BB=BFOn 2/28/20, 4:29 PM, "Josh Triplett" <josh@joshtriplett.org> wro=
te:
>=20
>     Before initializing completion queue interrupts, the ena driver uses
>     polling to wait for responses on the admin command queue. The ena dri=
ver
>     waits 5ms between polls, but the hardware has generally finished long
>     before that. Reduce the poll time to 10us.
>    =20
>     On a c5.12xlarge, this improves ena initialization time from 173.6ms =
to
>     1.920ms, an improvement of more than 90x. This improves server boot t=
ime
>     and time to network bringup.
> =20
> Thanks Josh,
> We agree that polling rate should be increased, but prefer not to do
> it aggressively and blindly. For example linear backoff approach
> might be a better choice. Please let us re-work a little this patch
> and bring it to review. Thanks! =20

Up to Josh if this is fine with him, but in my experience "let us rework
your patch behind the close doors" is not the response open source
contributors are expecting.
