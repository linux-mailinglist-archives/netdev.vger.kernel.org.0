Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B12424544
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 19:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239041AbhJFRxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 13:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239083AbhJFRvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 13:51:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D727E610EA;
        Wed,  6 Oct 2021 17:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633542553;
        bh=ahrpyHmXRPgTG9zNxA8W1t46rsM6cBBIxY3X78GvJGw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Olfr36OjbaKCahkR5Nu52zGW1nNpf/47wt7FP7OZo1CI026kfX0F25Km+lEPOKw8C
         X1QCKietxzlXw/hjMJkpWSFyqcYYOMsJC8yCflL4YhfN/04LfGkEatSXWPedXGlk5O
         WRuMqFU9tDYbR/1Q7ts2hhr8+XdAZOc0CdZcqSIJiuulDbmZHGB8BoTxmfdE5xec+s
         NWyKhKy/2zSQk5wuYrkIittHs9D0T0pCznUNgcOpEV2JANTzNm7wj2GqMhzvDDZnwg
         2mRMwEhgxEpovL2ojcZWYnk+OjuE6ffjznwvfjqfLzLgAkUSUdKYuEzFS+KREl1NoG
         3ze3e0E0O2B9A==
Date:   Wed, 6 Oct 2021 10:49:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        saravanak@google.com, mw@semihalf.com, jeremy.linton@arm.com
Subject: Re: [RFC] fwnode: change the return type of mac address helpers
Message-ID: <20211006104911.17779805@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7d33d634-a6ba-e189-b2a0-77cfcd3a8643@pensando.io>
References: <20211006022444.3155482-1-kuba@kernel.org>
        <YV23gINkk3b9m6tb@lunn.ch>
        <20211006084916.2d924104@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7d33d634-a6ba-e189-b2a0-77cfcd3a8643@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 09:55:59 -0700 Shannon Nelson wrote:
> >>> -	if (!device_get_ethdev_addr(dev, ndev))
> >>> +	if (device_get_ethdev_addr(dev, ndev))
> >>>   		eth_hw_addr_random(ndev); =20
> >> That is going to be interesting for out of tree drivers. =20
> > Indeed :(  But I think it's worth it - I thought it's only device tree
> > that has the usual errno return code but inside eth.c there are also
> > helpers for platform and nvmem mac retrieval which also return errno. =
=20
>=20
> As the maintainer of an out-of-tree driver, this kind of change with=20
> little warning really can ruin my day.
>=20
> I understand that as Linux kernel developers we really can't spend much=20
> time coddling the outer fringe, but we can at least give them hints.=C2=
=A0=20
> Changing the sense of the non-zero return from good to bad in several=20
> functions without something else that the compiler can warn on=20
> needlessly sets up time bombs for the unsuspecting.=C2=A0 Can we find a w=
ay=20
> to break their compile rather than surprise them with a broken runtime?

I also changed the arguments in v2, so OOT will no longer silently
break (not that it was the main motivation ;))
