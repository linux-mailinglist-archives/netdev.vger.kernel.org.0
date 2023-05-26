Return-Path: <netdev+bounces-5803-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADB95712C71
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 20:28:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64D361C210F9
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF712910F;
	Fri, 26 May 2023 18:28:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A8415BD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 18:28:42 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49BC198;
	Fri, 26 May 2023 11:28:39 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.west.internal (Postfix) with ESMTP id 406B63200904;
	Fri, 26 May 2023 14:28:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 26 May 2023 14:28:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1685125717; x=1685212117; bh=Ox
	B0qF2i6GRzOcs6mRtIeyUAm04uQMTTrpiV/6ndKjc=; b=co3TFgan6boWQvf7NI
	zuANSijSDQfbAAc7aC8U1wvayCxcxurn4GcXqOuCzf0poIretjUnVJaL1ILxnlLY
	tzPOJjpKQkYywrZ6ny7+PPnIskbOIEppfwOCxPpQWIDj4L/tyNjuuprjKC5+Ft7h
	MBMfiA/eeOEfJTbjv72CG+IN1mqx1faSroRJgAQrtBeUflbo4QHcwxuVL9nYV/Ij
	gIU+vPG8W9DV5RIVu/FB0hJeWjMZ+zVBPG11fx9gBZNWpNq0DzXrCDPCqbOQZiZg
	ZhC/HhYtAp3O/Qb8hXfUZPLs4123/7aOdLBMGK3U173q/X1lAg7EfAUWbDCk6Fvk
	V06Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685125717; x=1685212117; bh=OxB0qF2i6GRzO
	cs6mRtIeyUAm04uQMTTrpiV/6ndKjc=; b=T99X/UwhyM7mKIqGx8saAbGWGyAeC
	WKcmUnQcykNrpG6s//WzdUntHPOLa6xkyy5iL17r5cSiv0GHjNwEWKc4knw4ydMm
	Ozu8FBwXUH77Mek+xdOSMtmmkEBxeHVSB5ot79u5kW+9giUAUCpjnrw4uiaD2H82
	nd+V+yDMqpeuDVU8l/M6zVUhDv4m1XDIBeOim+MeJzqVx5hX/xT/IW5oPe+gGP4x
	IzKKU24ruTx/GdV+oIDkAGCuoMaKRl9d+9OQkjssXOiDg4HwYkZfuz5OoW8Afj5Z
	JWO2Z/nVAlqFuLdaBUquIdbhUqKqGrm1Aza78OiSyyOM4SCHJrNsZofwA==
X-ME-Sender: <xms:VfpwZBZwBcSdXS_Cs0BtnU72KcZEY1Kg-spoJBoKLwKICPYmskyrMQ>
    <xme:VfpwZIaZQglLNzfhYJlt3H48mrq9xtuHcJ1CH_v7P35yyCVfl3H11_y3ydAa7Hme9
    0L-QIyZXyWnWw>
X-ME-Received: <xmr:VfpwZD8aMnpd-uMtrcxjyUtpiuk_mZpY39GMZOssZ1b4rfdSl-JPAAwOHdrwDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeejledguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehge
    dvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:VfpwZPoy4SNHbsGHymmd1GVR8YRpyPBM1-v5p4zf1RyBDmgdFjZVpA>
    <xmx:VfpwZMoUa6Gzw9n9gpeiVA7OFl9kplPH8IE-i90RDni0L8mA7PuHJA>
    <xmx:VfpwZFTyY8bsfherRZ4Cp7BxDfVJycndwnkzGN84rR-3GWGdEIuEgw>
    <xmx:VfpwZCiewyO-z0u7WjX1vouGiGKPV6f2_YuYqxCMe7f6iudL2x55Zg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 26 May 2023 14:28:37 -0400 (EDT)
Date: Fri, 26 May 2023 19:28:36 +0100
From: Greg KH <greg@kroah.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: stable <stable@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
	Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	Steffen =?iso-8859-1?Q?B=E4tz?= <steffen@innosonix.de>
Subject: Re: net: dsa: mv88e6xxx: Request for stable inclusion
Message-ID: <2023052629-chill-progress-449a@gregkh>
References: <CAOMZO5Dd7z+k0X1aOug1K61FMC56u2qG-0s4vPpaMjT-gGVqaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5Dd7z+k0X1aOug1K61FMC56u2qG-0s4vPpaMjT-gGVqaA@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:38:22PM -0300, Fabio Estevam wrote:
> Hi,
> 
> I would like to request the commit below to be applied to the 6.1-stable tree:
> 
> 91e87045a5ef ("net: dsa: mv88e6xxx: Add RGMII delay to 88E6320")
> 
> Without this commit, there is a failure to retrieve an IP address via DHCP.

Now queued up, thanks.

greg k-h

