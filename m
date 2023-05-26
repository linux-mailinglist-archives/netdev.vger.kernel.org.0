Return-Path: <netdev+bounces-5671-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F8E712646
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:08:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EEC5281827
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7515C168DF;
	Fri, 26 May 2023 12:08:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADF4168A3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 12:08:11 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E1195
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=/Xnudso/RHzSe54PXcD4mz3d70ezqZEJnHo1B6uI8X8=; b=TN4QBPjmrM78nxK2sYsxUqs69F
	51h3O2m8UtLZHlih/9Iil1iPnNSc0nU0ie7xfQcNHQB7JiF5oIkhjFGPRqqrRFupCy9c8B7UQQyX/
	Y/MMN9CHYDl8rqmfT6rcvLr3cYN7rfUXQuIhL7nKvEgTufEt+pg//vhYSi9k0sTCFl2I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q2WEk-00Dzcu-JA; Fri, 26 May 2023 14:08:02 +0200
Date: Fri, 26 May 2023 14:08:02 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: netdev <netdev@vger.kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [RFC/RFTv3 00/24] net: ethernet: Rework EEE
Message-ID: <95412f7c-1f91-4939-bc7e-f0625d477f7d@lunn.ch>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <20230526085604.GA21891@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526085604.GA21891@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 10:56:04AM +0200, Oleksij Rempel wrote:
> Hi Andrew,
> 
> On Fri, Mar 31, 2023 at 02:54:54AM +0200, Andrew Lunn wrote:
> > Most MAC drivers get EEE wrong. The API to the PHY is not very
> > obvious, which is probably why. Rework the API, pushing most of the
> > EEE handling into phylib core, leaving the MAC drivers to just
> > enable/disable support for EEE in there change_link call back, or
> > phylink mac_link_up callback.
> > 
> > MAC drivers are now expect to indicate to phylib/phylink if they
> > support EEE. If not, no EEE link modes are advertised. If the MAC does
> > support EEE, on phy_start()/phylink_start() EEE advertisement is
> > configured.
> > 
> > v3
> > --
>  
> I was able to test some drivers and things seems to work ok so far. Do you
> need more tests for a non RFC version?

No, i just need time to rebase and post them. Plus check if there are
more drivers which added support for EEE and fix them up. There is a
new Broadcom driver which i think will need work.

Hopefully next week i can do this.

	  Andrew

