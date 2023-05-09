Return-Path: <netdev+bounces-1172-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D416FC7D1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:26:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F00DF281310
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A917182CB;
	Tue,  9 May 2023 13:26:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8B9182AD
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:26:25 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C6F3C32
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 06:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=mT/gdrCa61Z6YSETcX7wlQRPV+54rioyuJFbuaYOG1w=; b=Nx+xbNXWG306QBEw36gNYhCvyg
	SCWynqlDoLvAZBJnu5VLoxu46KdsNyfflMzXCxNAw4MJgOeQsadFCF7ToF3xZdvL8yEWIR+cTTq3k
	VX94DsBoQ5AucZ5AiAb3CkqqvGtDUGD0/MZt6Ul1Cg6Vrexf1V4UXLPNX1K+CSIvEovg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pwNLy-00CIog-DH; Tue, 09 May 2023 15:26:06 +0200
Date: Tue, 9 May 2023 15:26:06 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Sokolowski, Jan" <jan.sokolowski@intel.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: As usage of ethtool private flags is deprecated, what should we
 use from now on?
Message-ID: <ca6833e7-2d04-4dcd-9f8b-cab2c2f16183@lunn.ch>
References: <20230310145100.1984-1-jan.sokolowski@intel.com>
 <20230310145100.1984-2-jan.sokolowski@intel.com>
 <99823d11-4c46-d105-aaa5-2d5da113627d@intel.com>
 <PH7PR11MB58196E41B57C8FFD30108B9399769@PH7PR11MB5819.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB58196E41B57C8FFD30108B9399769@PH7PR11MB5819.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 11:15:57AM +0000, Sokolowski, Jan wrote:
> Hello netdev!
> 
> So, as recently I've been trying to upstream a patch that would introduce a new private flag to i40e driver,
> I've received a note that, according to this reply from Jakub Kicinski (https://lore.kernel.org/netdev/20230207215643.43f76bdd@kernel.org/),
> the use of private flags is deprecated and is something that will not be accepted by upstream anymore. 
> As such flags are an easy way to flip driver-specific behavior switches,
> and in the future there would be more patches written to allow end-users to change how the driver works,
> it appears that a new way forward is required.

Hi Jan

Is your device 'special'. Does it do things which no other device
does? Why is it doing something which no other device does? Surely if
it is useful, others will copy it. If nobody is going to copy it, then
you have to wonder if it has any value, and why should we care about
it.

We much prefer generic solutions to problem which can be used for a
number of devices. So please consider if this a generic configuration
knob which multiple drivers could make use of? If it is, add a well
defined, documented API for it, using netlink, as part of ethtool or
iproute2, etc. And then watch others coping the idea into their
driver, making use of the API you just added. Everybody benefits.

	Andrew

