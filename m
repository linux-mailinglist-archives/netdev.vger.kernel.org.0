Return-Path: <netdev+bounces-5802-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8733E712C6B
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 20:28:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D63C1C210FC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB522910C;
	Fri, 26 May 2023 18:28:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7266915BD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 18:28:14 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EE8D3;
	Fri, 26 May 2023 11:28:13 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.west.internal (Postfix) with ESMTP id C59863200904;
	Fri, 26 May 2023 14:28:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 26 May 2023 14:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1685125688; x=1685212088; bh=Yv
	6AsOZdmdnEhL3PsIQSFKo0I4jn9YXMwueF68NypGQ=; b=d8HwivzYE6V5ocIVyo
	mQZcIG/8VXOnaJB6BvbDbCjLi13IoX3gTHAbjf+AOOQQpCYybNhghfZW9HK6ndxn
	4Lut0lcSqkNKSN6PP4f8HDD9C3KmKAEgyU+12tFuJinytP9CyuxKMLxlnigHUh7z
	XYWccPZGDa7OjHxtcbpaOmdLY+cwXfJsl+nbqkUvOMusn0U2b3NkFNvQQJfpeOUv
	n/XriZWneH5H+g1DfVb4Ds/VuqbnVxAybS9Wj2kqgwSD9P77dA+PJwqoun89dgMz
	6GRwgJr1qSsjTJCbmaLVJ9IbDC06SnUVhgSpLN3Cv+F77FRjd1q+Pr1zKPtmDHSx
	on2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685125688; x=1685212088; bh=Yv6AsOZdmdnEh
	L3PsIQSFKo0I4jn9YXMwueF68NypGQ=; b=idC37BDNPp0gbkLO/u9ew4A5IPt6H
	VtI5+kZwb62sN7y2yfP9t2pfFvubcg21ofutLI5BPCguHhIwF1nLHbNrJWXRXzVj
	dAtN444UXtqNp/a+x+vHod3rAPB5N78yJu7ZZYjEvwbIsYCzt8WBA3a45piXubo1
	a77Qnl20Y4aSVbNPizsFVsob3sYNeenu3iU4sV+SLzwhTt5+wLJSKt/EULBw9PmB
	liZEzn+kSpxpODbGoh9pL3oU77lINRScjLlVI2Q1yiV4f7c0SSx6L/oIKbF3H4Hv
	EP9FWY3gkT+Ob1JMTQpvaB01LA2QCSAevTwEVkTZ5gav7coj5VpWzkOHw==
X-ME-Sender: <xms:N_pwZHylDoUnDJhGX17ys24TGRJ2VmNfDiYi8_PQ9Z-WO3MbY_qg9g>
    <xme:N_pwZPT5Ly586hzs0EcKBdBrSE54yK4s1v5REzUXXX_SbWPa4Elwb-JI9_SECQbMQ
    d48H6m2Jh9Mbg>
X-ME-Received: <xmr:N_pwZBX9TsGxAHDFvy8ObjdO095OvdtE1uzHWE7GycPH5raL8-bBcQ5MhvNK8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeejledguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehge
    dvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:N_pwZBgMQhBvYOq1wzTkKeieCVAlwOo6uWGY5ax0uQ7mXJWdcaKDyw>
    <xmx:N_pwZJB6YHVJLiomdlxTxY-WXnayjsVR9SzXNXK4k5IHbE7KOiGFvg>
    <xmx:N_pwZKIr2AWOcXvSz4WWWRpvWS41w5g4_X-c8Ny3OxQ_Bb2rizSMXA>
    <xmx:OPpwZN4RL2XRMdLcpRBDJco9LOY8hWiBuj-FIWVnaD_BJWLwCWT_Fg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 26 May 2023 14:28:07 -0400 (EDT)
Date: Fri, 26 May 2023 19:28:06 +0100
From: Greg KH <greg@kroah.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Fabio Estevam <festevam@gmail.com>, stable <stable@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	Steffen =?iso-8859-1?Q?B=E4tz?= <steffen@innosonix.de>
Subject: Re: net: dsa: mv88e6xxx: Request for stable inclusion
Message-ID: <2023052656-plunder-outrank-91d9@gregkh>
References: <CAOMZO5Dd7z+k0X1aOug1K61FMC56u2qG-0s4vPpaMjT-gGVqaA@mail.gmail.com>
 <eec26f5c-1ad7-48ff-94a9-708a0a9f3b02@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eec26f5c-1ad7-48ff-94a9-708a0a9f3b02@lunn.ch>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 07:45:50PM +0200, Andrew Lunn wrote:
> On Wed, May 24, 2023 at 02:38:22PM -0300, Fabio Estevam wrote:
> > Hi,
> > 
> > I would like to request the commit below to be applied to the 6.1-stable tree:
> > 
> > 91e87045a5ef ("net: dsa: mv88e6xxx: Add RGMII delay to 88E6320")
> > 
> > Without this commit, there is a failure to retrieve an IP address via DHCP.
> 
> Please could your provide a Fixes: tag.

I do not understand what this means.

