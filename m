Return-Path: <netdev+bounces-3414-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE681706F08
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:07:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3D3D1C2082F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08CD31121;
	Wed, 17 May 2023 17:07:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6605442F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 17:07:36 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2D21FDA
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=beNQZIUSag6f97QOCx8qr0u5FKlNXjYlGe0jGTtwTiI=; b=CLH8e1WgYSPg1V4zJOg0GizfEV
	fCbkD9Y/iHgfmXY0M5NO28GMMRyk1Sw4bRRm0ug5HFn9D84M5Stz9HWk6JOPQhVvpmjo2jl7E79Gf
	C2uk6NkfjnoPTnJ/Xsx25bAW+GUtget+0B3WdiByQfQomKZKRmmIjziEItKgKYkt2D88=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pzKca-00D9v5-KF; Wed, 17 May 2023 19:07:28 +0200
Date: Wed, 17 May 2023 19:07:28 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Tobias Waldekranz <tobias@waldekranz.com>,
	Fabio Estevam <festevam@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Steffen =?iso-8859-1?Q?B=E4tz?= <steffen@innosonix.de>,
	netdev <netdev@vger.kernel.org>
Subject: Re: mv88e6320: Failed to forward PTP multicast
Message-ID: <41d7d1e8-19b8-4025-a1eb-0fbb0f54fe15@lunn.ch>
References: <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch>
 <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
 <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com>
 <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch>
 <CAOMZO5DSSQY5fa5vTmDbCxu1x2ZRdyB2kTqrkw5bRg94_-34zg@mail.gmail.com>
 <87pm77dg5i.fsf@waldekranz.com>
 <CAOMZO5CZoy12WrBEQFMupv5sPh2EjSPm+UmGz=-WkS7A97CtqQ@mail.gmail.com>
 <87wn1foze1.fsf@waldekranz.com>
 <CAOMZO5AQtL1BNk2sm2v=c5fLbukkZSi6HSJXexp4QB4JjAyw-g@mail.gmail.com>
 <20230517165335.o2hvnz7ymi3nh7sy@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517165335.o2hvnz7ymi3nh7sy@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Slightly unrelated to the original topic and probably completely
> unrelated to Fabio's actual issue.
> 
> I'm completely inapt when it comes to IP multicast. Tobias, does the
> fact that br0 have mcast_router 1 mean that the CPU port should be a
> recipient of all multicast traffic, registered or unregistered?

It is a long time since i did much with multicast. But my
understanding is that a multicast router should be taking part in
IGMP. If there is a group member on the other side of the gateway, the
router should indicate it has interest in the group so traffic flows
to it. It can then forward the traffic between its multicast
interfaces, based on that interest.

	Andrew

