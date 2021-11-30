Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581004628F1
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 01:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhK3AQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 19:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbhK3AQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 19:16:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C59C061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 16:13:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BEA5FCE1689
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 00:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBF6C53FC7;
        Tue, 30 Nov 2021 00:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638231213;
        bh=P6FOaZX0DShGbf4Oh3/QUxvHregQgjK1RY9v0eRycQo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K2D1J44QDSGXbV7u8Nr886oseCw1hUzOrXZjtfZOCTW52cMLvshX2oRQY2FC8HqOO
         dthwyaDHD8xWs/T0zTEvARNaZpm8nKVuK0bckblTiLa+ks5WVK0DizOpEzGXmvbmhc
         HBeCfV2Ce7xUwG/mlhMDoHKCIXzKnee0fzu4ONxK1DWHxQet3vq6HVW9Hf2JUEFwce
         gFCJ6x2CC5ck4zDNZqK/617sJuaHhedST7zxhkJ257Ib7n5/m/UGrv0nfg6tvHWkld
         6ADHYQ89no1OaOXRPYK2jIDNYhCyol0vqIjH0TWR8CL8nBcJiVGzhGRMhgCmu/6ilH
         UNxCWxh0BVJBA==
Date:   Tue, 30 Nov 2021 01:13:28 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net 3/6] net: dsa: mv88e6xxx: Save power by disabling
 SerDes trasmitter and receiver
Message-ID: <20211130011328.42328281@thinkpad>
In-Reply-To: <YaVc/nEDztt5kch9@shell.armlinux.org.uk>
References: <20211129195823.11766-1-kabel@kernel.org>
        <20211129195823.11766-4-kabel@kernel.org>
        <YaVc/nEDztt5kch9@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 23:06:38 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Mon, Nov 29, 2021 at 08:58:20PM +0100, Marek Beh=C3=BAn wrote:
> > +static int mv88e6393x_serdes_power_lane(struct mv88e6xxx_chip *chip, i=
nt lane,
> > +					bool on)
> > +{
> > +	u16 reg;
> > +	int err;
> > +
> > +	err =3D mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> > +				    MV88E6393X_SERDES_CTRL1, &reg);
> > +	if (err)
> > +		return err;
> > +
> > +	if (on)
> > +		reg &=3D !(MV88E6393X_SERDES_CTRL1_TX_PDOWN |
> > +			 MV88E6393X_SERDES_CTRL1_RX_PDOWN); =20
>=20
> Are you sure this is correct? Don't you want that to be ~(...) ?
>=20

/o\ How did I not notice this? Thanks.
