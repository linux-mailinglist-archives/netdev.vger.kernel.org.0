Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1977D445A18
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 19:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhKDTBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 15:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232033AbhKDTBK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 15:01:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACFEC61051;
        Thu,  4 Nov 2021 18:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636052312;
        bh=a4rJk/HuNQaGbJB6e7r2rlX8XKT11ldUKNjQtTW/N7g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mPKNNSYwtiiAoxDBOm1rXxCOdCYIrlgqNc8IiOvGA4i8/i4ISe8kPLIKNEY7xz0+E
         Uo1GMg07W52kWkY0ed/LOLxONhocadwMh1dgoHe0b/AvtQkzhdVd251fv/Qoz2PU4O
         +ly3aoYtHHhIlTQ1yGNV+YeZ8IjP+G6674+R17x9c+HFAhzjk4y6Tf/o31ccL8PP5x
         KbodF6cQMJwdraHc4MYKMyj9fF5UVfbDxOmkX3jFI86SijcGLEv+MuVHqzsgKXyk8p
         B13v1o4fQfdOJ/9JSQp8KnaN3csFK8lU/Je23XqNbkmRZJAPLIpvfccM0KHr2nrgpJ
         3bzJ7s+rEZEcQ==
Date:   Thu, 4 Nov 2021 19:58:28 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Don't support >1G speeds on
 6191X on ports other than 10
Message-ID: <20211104195828.199c58b9@thinkpad>
In-Reply-To: <YYQjXVsLTRsTBBHa@shell.armlinux.org.uk>
References: <20211104171747.10509-1-kabel@kernel.org>
        <YYQjXVsLTRsTBBHa@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Nov 2021 18:15:57 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Thu, Nov 04, 2021 at 06:17:47PM +0100, Marek Beh=C3=BAn wrote:
> > Model 88E6191X only supports >1G speeds on port 10. Port 0 and 9 are
> > only 1G. =20
>=20
> Interesting. The original commit says:
>=20
> SERDESes can do USXGMII, 10GBASER and 5GBASER (on 6191X only one
> SERDES is capable of more than 1g; USXGMII is not yet supported
> with this change)
>=20
> which is ambiguously worded - so I guess we now know that it's only
> port 10 that supports speeds above 1G.

Yes, I just found this info in datasheet.

> Can ports 0 / 1 / 10 be changed at runtime (iow, is the C_Mode field
> writable on these ports?)

Yes, cmode is writable on these ports. serdes.c also provides some
errata fixes when changing cmode.

(BTW Russell I have already updated your patch
   net: dsa: mv88e6xxx: populate supported_interfaces
 from your net-queue branch.
 I am rebasing your work on top of net-next and also adding some other
 stuff. I will send you the patches later.)

Marek
