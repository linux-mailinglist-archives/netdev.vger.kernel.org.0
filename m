Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965D3125D36
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 10:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfLSJEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 04:04:44 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:36909 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726692AbfLSJEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 04:04:42 -0500
Received: from sapphire.tkos.co.il (unknown [192.168.100.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id C015A440044;
        Thu, 19 Dec 2019 11:04:39 +0200 (IST)
Date:   Thu, 19 Dec 2019 11:04:38 +0200
From:   Baruch Siach <baruch@tkos.co.il>
To:     Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191219090438.4jnfd3fqjc2pmivw@sapphire.tkos.co.il>
References: <20191212131448.GA9959@lunn.ch>
 <20191212150810.zx6o26jnk5croh4r@sapphire.tkos.co.il>
 <20191212151355.GE30053@lunn.ch>
 <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il>
 <20191212193611.63111051@nic.cz>
 <20191212190640.6vki2pjfacdnxihh@sapphire.tkos.co.il>
 <20191212193129.GF30053@lunn.ch>
 <20191212204141.16a406cd@nic.cz>
 <8736dlucai.fsf@tarshish>
 <20191218153035.11c3486d@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191218153035.11c3486d@dellmb>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Wed, Dec 18, 2019 at 03:30:35PM +0100, Marek Behún wrote:
> On Sun, 15 Dec 2019 12:13:25 +0200
> Baruch Siach <baruch@tkos.co.il> wrote:
> 
> > Thanks. That is enough to fix the phylink issue triggered by commit
> > 7fb5a711545 ("net: dsa: mv88e6xxx: drop adjust_link to enabled
> > phylink").
> > 
> > The Clearfog GT-8K DT has also this on the cpu side:
> > 
> > &cp1_eth2 {
> >         status = "okay";
> >         phy-mode = "2500base-x";
> >         phys = <&cp1_comphy5 2>;
> >         fixed-link {
> >                 speed = <2500>;
> >                 full-duplex;
> >         };
> > };
> > 
> > Should I drop fixed-link here as well?
> 
> I would think yes. phy-mode = 2500base-x should already force 2500mbps,
> the fixed-link should be irrelevant. Whether this is truly the case I
> do not know, but on Turris Mox I do not use fixed-link with these.

It doesn't work here without fixed-link. The link state remains down.

baruch

> > The call to mv88e6341_port_set_cmode() introduced in commit
> > 7a3007d22e8 ("net: dsa: mv88e6xxx: fully support SERDES on Topaz
> > family") still breaks port 5 (cpu) configuration. When called, its
> > mode parameter is set to PHY_INTERFACE_MODE_2500BASEX (19).
> > 
> > Any idea?
> 
> I shall look into this. On Turris Mox this works, so I will have to do
> some experiments.

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
