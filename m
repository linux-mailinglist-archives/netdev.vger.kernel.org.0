Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E441C9ED0
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 00:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgEGW4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 18:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgEGW4w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 18:56:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B888A2083B;
        Thu,  7 May 2020 22:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588892212;
        bh=DFVZVtjOy5Zq82K7JozE2r2KIIrkXMdk+V1nGag44c4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cfWvMsu2a/TSPk7q/+Zmfy29Q+AC9QWezN1eQf99G/LyIFEochDHBbNGHvRrHDHwd
         SZglIFhyk6ytKrqx4WYehFbADUTk/TTe7OKAqe6BCfjM+R6c6vfSj6H2Ogxrf/0GT4
         qWEFvrGtflMZ2XaXUvIx5uz56muVQ9+ZoWAD9EJ0=
Date:   Thu, 7 May 2020 15:56:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 05/11] net: core: provide devm_register_netdev()
Message-ID: <20200507155650.0c19229e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMpxmJUEk3itZs4HujJOXUiL80kmEvGBvLF0NFc2UQoVDVTWRg@mail.gmail.com>
References: <20200505140231.16600-1-brgl@bgdev.pl>
        <20200505140231.16600-6-brgl@bgdev.pl>
        <20200505103105.1c8b0ce3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMRc=Mf0ipaeLKhHCZaq2YeZKzi=QBAse7bEz2hHxXN5OL=ptg@mail.gmail.com>
        <20200506101236.25a13609@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMpxmJWckQdKvUGFDAJ1WMtD9WoGWmGe3kyKYhcfRT2nOB93xw@mail.gmail.com>
        <20200507095315.1154a1a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMpxmJUEk3itZs4HujJOXUiL80kmEvGBvLF0NFc2UQoVDVTWRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 May 2020 19:03:44 +0200 Bartosz Golaszewski wrote:
>> To implement Edwin's suggestion? Makes sense, but I'm no expert, let's
>> also CC Heiner since he was asking about it last time. =20
>=20
> Yes, because taking the last bit of priv_flags from net_device seems
> to be more controversial but if net maintainers are fine with that I
> can simply go with the current approach.

=46rom my perspective what Edwin suggests makes sense. Apart from
little use for the bit after probe, it also seems cleaner for devres=20
to be able to recognize managed objects based on its own state.
