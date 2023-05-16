Return-Path: <netdev+bounces-3049-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A30197053C6
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:29:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F19F281325
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D9573111B;
	Tue, 16 May 2023 16:29:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB8634CF9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:29:38 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3FE9009
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=FbpPVuXZke6P97laVv0WeZGbSRN+7b0IxXaTLu5X5sk=; b=ea1haATmRjl8q934l9T/+JvF+I
	iR4IQ9pYNTe+UyQ8xEmDri/SGlw6beWF2SPGBt0LkGfBKfSIqtBFL9G687ufpRIX1bg2fbtov1HFu
	5MlIMbMqk8+ugBbFHujojgi1mYo5+iGx+Cc1yAm5Ffc3zGDtE+w8PSiwRaMwd6B0GBhw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pyxY2-00D2fH-01; Tue, 16 May 2023 18:29:14 +0200
Date: Tue, 16 May 2023 18:29:13 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Fabio Estevam <festevam@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>, tobias@waldekranz.com,
	Florian Fainelli <f.fainelli@gmail.com>,
	Steffen =?iso-8859-1?Q?B=E4tz?= <steffen@innosonix.de>,
	netdev <netdev@vger.kernel.org>
Subject: Re: mv88e6320: Failed to forward PTP multicast
Message-ID: <b2a5d9d6-5ae5-405f-b050-caa95807dd7c@lunn.ch>
References: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
 <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch>
 <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
 <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com>
 <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch>
 <CAOMZO5DSSQY5fa5vTmDbCxu1x2ZRdyB2kTqrkw5bRg94_-34zg@mail.gmail.com>
 <20230510182826.pxwiauia334vwvlh@skbuf>
 <CAOMZO5Ad4_J4Jfyk8jaht07HMs7XU6puXtAw+wuQ70Szy3qa2A@mail.gmail.com>
 <20230511114629.uphhfwlbufte6oup@skbuf>
 <CAOMZO5BcwgujANLguNXCCZvJh8jwqUAcuu63D8dhwGhZ6oHffA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5BcwgujANLguNXCCZvJh8jwqUAcuu63D8dhwGhZ6oHffA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> When I get into this "blocked" situation if I restart the bridge manually:
> ip link set br0 down
> ip link set br0 up
> 
> Then tcpdump starts showing the PTP traffic again, but only for a
> short duration of time, and stops again.
> 
> Now that I have a more reliable way to reproduce the issue, I can run
> more tests/debugging.
> Please let me know if you have any suggestions.

This behaviour sounds like IGMP snooping, or something like that. The
bridge is adding in an entry to say don't send the traffic to the CPU,
nobody is interested in it.

I would add some debug prints into mv88e6xxx_port_fdb_add(),
mv88e6xxx_port_fdb_del() mv88e6xxx_port_mdb_add() and
mv88e6xxx_port_mdb_del() and see what entries are getting. You can
then backtrack and see why the bridge is adding them.

Also, Tobias asked about the type of frame being passed from the
switch to the host for PTP frames. Is it TO_CPU or FORWARD?  tcpdump
-e on the FEC interface will show you additional information in the
DSA header.

   Andrew

