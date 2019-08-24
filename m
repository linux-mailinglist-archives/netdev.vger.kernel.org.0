Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEB79C03A
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 22:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfHXUwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 16:52:19 -0400
Received: from mail.nic.cz ([217.31.204.67]:42372 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbfHXUwS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 16:52:18 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id E2C3A140B0B;
        Sat, 24 Aug 2019 22:52:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566679937; bh=UW0mgm/VznWrGW0lGgrlw+qNAr49wgC7XHdO6vYj6Gc=;
        h=Date:From:To;
        b=jWb8i2fbqFnXm/cDIrsqTDKGThM4jcrFsmqInsNpvEh/5uL72ZxQV7nCziK3lS/Cu
         CadsocNwcqex24B0Iyy9XobsTIP0/RR1zt0Tpgy98OBQRkSGDOel+32V7RchadeHoS
         DD6ByxTTLBWp7YzWtlWUuFF7Xt5HGLQQvDyUfA2M=
Date:   Sat, 24 Aug 2019 22:52:16 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v2 8/9] net: dsa: mv88e6xxx: support Block
 Address setting in hidden registers
Message-ID: <20190824225216.264fe7b0@nic.cz>
In-Reply-To: <20190824161328.GI32555@t480s.localdomain>
References: <20190823212603.13456-1-marek.behun@nic.cz>
        <20190823212603.13456-9-marek.behun@nic.cz>
        <20190824161328.GI32555@t480s.localdomain>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Aug 2019 16:13:28 -0400
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> Hi Marek,
>=20
> On Fri, 23 Aug 2019 23:26:02 +0200, Marek Beh=C3=BAn <marek.behun@nic.cz>=
 wrote:
> > -int mv88e6xxx_port_hidden_write(struct mv88e6xxx_chip *chip, int port,=
 int reg,
> > -				u16 val);
> > +int mv88e6xxx_port_hidden_write(struct mv88e6xxx_chip *chip, int block=
, int port,
> > +				int reg, u16 val);
> >  int mv88e6xxx_port_hidden_wait(struct mv88e6xxx_chip *chip);
> > -int mv88e6xxx_port_hidden_read(struct mv88e6xxx_chip *chip, int port, =
int reg,
> > -			       u16 *val);
> > +int mv88e6xxx_port_hidden_read(struct mv88e6xxx_chip *chip, int block,=
 int port,
> > +			       int reg, u16 *val); =20
>=20
>=20
> There's something I'm having trouble to follow here. This series keeps
> adding and modifying its own code. Wouldn't it be simpler for everyone
> if you directly implement the final mv88e6xxx_port_hidden_{read,write}
> functions taking this block argument, and update the code to switch to it?

I wanted the commits to be atomic, in the sense that one commit does
not do three different things at once. Renaming macros is cosmetic
change, and moving functions to another file is a not a semantic
change, while adding additional argument to functions is a semantic
change. I can of course do all in one patch, but I though it would be
better not to.

> While at it, I don't really mind the "hidden" name, but is this the name
> used in the documentation, if any?

Yes, the registers are indeed named Hidden Registers in documentation.
