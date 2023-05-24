Return-Path: <netdev+bounces-5005-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B7070F6A2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:37:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF8CA1C20D2E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E208460843;
	Wed, 24 May 2023 12:37:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D629F60840
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:37:47 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BEA1B0;
	Wed, 24 May 2023 05:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Z8lMX3u0iolA/Z40Kqv7W/k+Ppjd7QtSS15518Cnjks=; b=x9N8FnyMMqsU3RvBuYxtrvBzQ0
	OjZft50FwrSLCsV7kGYeal0U4F7t0DsNG0xMBo+3eImkEqzfXuoyiC72a1ppYJR6wcAWOipuqhkAl
	jZ81dDGzP9EmR9qa6/BHmipLTzeqZrANqIMpfCuHHcLGXHFYTIzZUo19neGUHr/h2/pELzjRQsiQ5
	QRfTnchJ7A3uOheBu8ELc8wiWFATOvq5CcWWD3OEFNKlTYC2UKOhNcdJiqH85Ak1VBFYlh1W/hMDG
	2NnJCSED68NmQc7H2sS1++qkYnMuIkjp6RQJ2vQx4M/jA52S2o38sv7jDjrtboc/F3E/e0OSLmPg0
	m9/mf0oQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33900)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q1njx-0002Ia-DX; Wed, 24 May 2023 13:37:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q1njw-0001cb-0s; Wed, 24 May 2023 13:37:16 +0100
Date: Wed, 24 May 2023 13:37:15 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Lukasz Majewski <lukma@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Duyck <alexander.duyck@gmail.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] dsa: marvell: Add support for mv88e6071 and 6020
 switches
Message-ID: <ZG4E+wd03cKipsib@shell.armlinux.org.uk>
References: <20230523142912.2086985-1-lukma@denx.de>
 <89fd3a8d-c262-46d8-98ad-c8dc04fe9d9c@lunn.ch>
 <20230524141743.1322c051@wsk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524141743.1322c051@wsk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:17:43PM +0200, Lukasz Majewski wrote:
> Hi Andrew,
> 
> > On Tue, May 23, 2023 at 04:29:09PM +0200, Lukasz Majewski wrote:
> > > After the commit (SHA1: 7e9517375a14f44ee830ca1c3278076dd65fcc8f);
> > > "net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220,
> > > 6250, 6290" the error when mv88e6020 or mv88e6071 is used is not
> > > present anymore.  
> > 
> > >   dsa: marvell: Define .set_max_frame_size() function for mv88e6250
> > > SoC family  
> > 
> > Hi Lukasz
> > 
> > commit 7e9517375a14f44ee830ca1c3278076dd65fcc8f
> > Author: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Date:   Tue Mar 14 20:24:05 2023 +0200
> > 
> >     net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220,
> > 6250, 6290 
> >     There are 3 classes of switch families that the driver is aware
> > of, as far as mv88e6xxx_change_mtu() is concerned:
> >     
> >     - MTU configuration is available per port. Here, the
> >       chip->info->ops->port_set_jumbo_size() method will be present.
> >     
> >     - MTU configuration is global to the switch. Here, the
> >       chip->info->ops->set_max_frame_size() method will be present.
> >     
> >     - We don't know how to change the MTU. Here, none of the above
> > methods will be present.
> >     
> >     Switch families MV88E6165, MV88E6191, MV88E6220, MV88E6250 and
> > MV88E6290 fall in category 3.
> > 
> > 
> > Vladimir indicates here that it is not known how to change the max MTU
> > for the MV88E6250. Where did you get the information from to implement
> > it?
> 
> Please refer to [1].
> 
> The mv88e6185_g1_set_max_frame_size() function can be reused (as
> registers' offsets and bits are the same for mv88e60{71|20}).
> 
> After using Vladimir's patch there is no need to add max_frame size
> field and related patches from v6 can be dropped.

However, you haven't responded to:

https://lore.kernel.org/all/ZGzP0qEjQkCFnXnr@shell.armlinux.org.uk/

to explain why what you're doing (adding this function) is safe.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

