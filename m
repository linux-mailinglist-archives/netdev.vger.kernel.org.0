Return-Path: <netdev+bounces-5387-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F494710FFA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:51:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A90B281589
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97EFE1D2AA;
	Thu, 25 May 2023 15:50:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D65F1C752
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:50:43 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD32D10B;
	Thu, 25 May 2023 08:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=9zPZPSkgvuyotoAA/KTUJbfPBjL1vH6aa8V0io941jQ=; b=LDOqAV1ryRWXbT+F5bkBsxp4rW
	3yuiEn6uzp08iegx29y+n2fARDgg7gwGNPWdd5NKemk6BLw59COhjne3TSxgQlzX8uz9p/vA8cEjm
	JGrUHYHa6cHUxZRLnwxO++Y2ZYT+dgCF1qHQlpdBarooN9iOFtu6cV1W1kNjvBA7ydYA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q2DEL-00DuN4-UJ; Thu, 25 May 2023 17:50:21 +0200
Date: Thu, 25 May 2023 17:50:21 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
Cc: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>,
	hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	horatiu.vultur@microchip.com, Woojung.Huh@microchip.com,
	Nicolas.Ferre@microchip.com, Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v3 2/6] net: phy: microchip_t1s: replace
 read-modify-write code with phy_modify_mmd
Message-ID: <99ccdedb-c2c7-4187-9fb4-b2047480e097@lunn.ch>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
 <20230524144539.62618-3-Parthiban.Veerasooran@microchip.com>
 <ZG9/E8Am2ICEHIbr@debian>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZG9/E8Am2ICEHIbr@debian>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> This change also invalidates most of the comment. I think this should be
> reduced to something along the lines of:
> 	/* HW quirk: Microchip states in the application note (AN1699) for the phy
> 	 * that a set of read-modify-write (rmw) operations has to be performed
> 	 * on a set of seemingly magic registers.
> 	 * The result of these operations is just described as 'optimal performance'
> 	 * Microchip gives no explanation as to what these mmd regs do,
> 	 * in fact they are marked as reserved in the datasheet.*/

I agree the comments should be reviewed in light of these changes.

> 
> Additionally I don't mind it if you change the tone of the comment. This was brought
> up in the sitdown we had, where it was explained from Microchip that
> documenting what the reg operations actually does would expose to much
> of the internal workings of the chip.

They cannot care too much, or the firmware in the PHY would do this
where it is all hidden away.

      Andrew

