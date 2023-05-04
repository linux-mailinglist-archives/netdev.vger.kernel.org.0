Return-Path: <netdev+bounces-279-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A38436F6B1E
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 14:24:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 389C7280D3C
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 12:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C3EFC12;
	Thu,  4 May 2023 12:24:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD31FBE2
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 12:24:52 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442F85FFF;
	Thu,  4 May 2023 05:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=4SxUKZxHFSkFJqfmw8tU2KWudvukOgiePhinru3T1+c=; b=IZu/7PgtLNCY1MINdiulM9V8DI
	SI9OhK4KZ3O7jTen+Liz3K9KOk+Dy+FZtckKfgpYkOSaYqjWGmr9+V44QZzHdl/rnN20hsCWwbsKJ
	vIXkfeiq28Ag4PakfiFU70+CZGQOJUEHMh7OPN+zBgaUui26L6tjAIPNBI88Z/UKfWRs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1puY0h-00Buct-Ro; Thu, 04 May 2023 14:24:35 +0200
Date: Thu, 4 May 2023 14:24:35 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Vyas, Devang nayanbhai" <Devangnayanbhai.Vyas@amd.com>
Cc: "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
	"linux@armlinux.org.uk" <linux@armlinux.org.uk>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: phy: aquantia: Add 10mbps support
Message-ID: <28a1b515-b5f8-45cf-b1af-1a1826cb45ba@lunn.ch>
References: <20230426081612.4123059-1-devangnayanbhai.vyas@amd.com>
 <7ae81127-a2aa-4f02-8c07-b8f158e0ef83@lunn.ch>
 <20230502194654.093afb13@kernel.org>
 <DM4PR12MB53109312920C5C666507F12B8A6D9@DM4PR12MB5310.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM4PR12MB53109312920C5C666507F12B8A6D9@DM4PR12MB5310.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 06:18:11AM +0000, Vyas, Devang nayanbhai wrote:
> [AMD Official Use Only - General]

Hi Devang

Please don't top post.

Also, wrap your emails at around 75 characters. Network Etiquette
rules apply for linux kernel mailling list.

> We are using AQR113C Marvell PHY which is CL45 based and based on below check in phy_probe() function:
>         if (phydrv->features)
>                 linkmode_copy(phydev->supported, phydrv->features);
>         else if (phydrv->get_features)
>                 err = phydrv->get_features(phydev);
>         else if (phydev->is_c45)
>                 err = genphy_c45_pma_read_abilities(phydev);    -> it reads capability from PMA register where 10M bit is read-only static and value is 0
>         else
>                 err = genphy_read_abilities(phydev);
> 
> Based on PHY datasheet, it supports 10M and we have made the change for the same and verified successfully.
> 
> Below code should set the supported field under genphy_c45_pma_read_abilities(), but as the value is 0, we have to set the 10M mode explicitly.

So the PHY is 'broken' in that one of its registers has the wrong
value. However, it can probably be fixed. aQuantia firmware is not
just code executed by its embedded uC. It also contains
`provisioning`. This blob sets the values of many registers, and i
think can be used to set registers which are read only. Maybe the blob
you have is incorrectly provisioning the MDIO_PMA_EXTABLE_10BT
register.

Please talk to Marvell about the provisioning blob you have.

       Andrew

