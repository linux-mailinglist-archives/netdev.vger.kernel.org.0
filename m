Return-Path: <netdev+bounces-4673-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB43870DCE4
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:48:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BACD281393
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 551BA1DDFD;
	Tue, 23 May 2023 12:47:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D491DDFB
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 12:47:51 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AA6DB;
	Tue, 23 May 2023 05:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=6/VrPyQQQacl91J2hYd6SMf8Ci8TKTyXgXBTBksvLyk=; b=wMYqtRxN92vQUJeMN6YMn/VWR4
	WaXSKKD+cw/qVfR62SPqLBiIILMbH23nR9zX4TMHuBnemambq56hUHToLCbNitV1PlvOg5J4M7a7L
	x68Ma58jh5bmO2KMIcHq6eQiqip/k0kHT6HTvnhELUW+OtUU6NvI66hueCuemO0XucE4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1R8j-00DgVb-98; Tue, 23 May 2023 14:29:21 +0200
Date: Tue, 23 May 2023 14:29:21 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Parthiban.Veerasooran@microchip.com
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ramon.nordin.rodriguez@ferroamp.se, Horatiu.Vultur@microchip.com,
	Woojung.Huh@microchip.com, Nicolas.Ferre@microchip.com,
	Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v2 6/6] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Message-ID: <819531cd-ebd7-4734-b35b-8f8c3d138004@lunn.ch>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
 <20230522113331.36872-7-Parthiban.Veerasooran@microchip.com>
 <349e1c57-24c6-46fa-b0ab-c6225ae1ece4@lunn.ch>
 <f366d388-420a-082d-ed26-25e93d143671@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f366d388-420a-082d-ed26-25e93d143671@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > Is this doing a read from fuses? Is anything documented about this?
> > What the values mean? Would a board designer ever need to use
> > different values? Or is this just a case of 'trust us', you don't need
> > to understand this magic.
> Yes, it is a read from fuses and those values are specific/unique for 
> each PHY chip. Those values are calculated based on some characteristics 
> of the PHY chip behavior for optimal performance and they are fused in 
> the PHY chip for the driver to configure it during the initialization. 
> This is done in the production/testing stage of the PHY chip. As it is 
> specific to PHY chip, a board designer doesn't have any influence on 
> this and need not to worry about it. Unfortunately they can't be 
> documented anywhere as they are design specific. So simply 'trust us'.

O.K. Please consider for future generations that you move all this
magic into the PHY firmware. There does not seem to be any reason the
OS needs to know about this.

     Andrew

