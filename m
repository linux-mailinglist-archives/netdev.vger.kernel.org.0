Return-Path: <netdev+bounces-2251-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1F8D700E09
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:41:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1689A281CFE
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BC6D200D9;
	Fri, 12 May 2023 17:41:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C786A200A5
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21471C433EF;
	Fri, 12 May 2023 17:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683913266;
	bh=9UJQnXE0tyrUoUqCgaqU+MmLWPRIMUxN2KnUW/rtGD8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=B4sF4zBzm9kztfU5Yfg10eFOVEUoVAUVN6ge3+yWD26FDsy6Ur4xWklLTT7ka+4BD
	 LLyaPp22q3YC2eEtc4gebcH/j4VQzq3Y8QynbwuMLt0GpCEmwuaFuZi7KsLAusquR7
	 rBKRyZ6THyE35svPYBMAKLfhrkSOxdGgcOhCKpH3PBn3hJ26j2DyNHMwKjgMfU/hEW
	 7g7BT74n2KVYgwMKtlioJxKmcl8PP7FMfu3i4i+eq2qbzwKUKpCMMfvdYxxnqD/iCO
	 X9TcQgnmlidgjUEkk3AxLe4Dnn9kV7GVIE+ubbxGulM1p+Cd6nC0tyDmT4u6ifXxWo
	 vLuubAY/5XULQ==
Date: Fri, 12 May 2023 10:41:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Max Georgiev <glipus@gmail.com>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>, kory.maincent@bootlin.com,
 netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
 vadim.fedorenko@linux.dev, richardcochran@gmail.com,
 gerhard@engleder-embedded.com, liuhangbin@gmail.com
Subject: Re: [RFC PATCH net-next v6 1/5] net: Add NDOs for hardware
 timestamp get/set
Message-ID: <20230512104105.6bc78950@kernel.org>
In-Reply-To: <CAP5jrPEL-RAPr4NADfGtqw1UJq+uKAVyRiz3wmAjMXhXAgit4w@mail.gmail.com>
References: <20230502043150.17097-1-glipus@gmail.com>
	<20230502043150.17097-2-glipus@gmail.com>
	<20230511123245.rs5gskwukood3ger@skbuf>
	<CAP5jrPEL-RAPr4NADfGtqw1UJq+uKAVyRiz3wmAjMXhXAgit4w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 May 2023 21:22:23 -0600 Max Georgiev wrote:
> > > +     int                     (*ndo_hwtstamp_get)(struct net_device *dev,
> > > +                                                 struct kernel_hwtstamp_config *kernel_config,
> > > +                                                 struct netlink_ext_ack *extack);  
> >
> > I'm not sure it is necessary to pass an extack to "get". That should
> > only give a more detailed reason if the driver refuses something.  
> 
> I have to admit I just followed Jakub's guidance adding "extack" to the
> list of parametres. I'll let Jakub to comment on that.

We can drop it from get, I can't think of any strong use case.

