Return-Path: <netdev+bounces-933-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8B2E6FB6A0
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D534B281076
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:09:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB4751118C;
	Mon,  8 May 2023 19:09:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04244411
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:09:57 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD2835A8;
	Mon,  8 May 2023 12:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=UX+m9kPc21K8WekKV6ssDCuyIE9JYwlqyANuJxhhXj4=; b=xI/tbD+VbXNoyWiGHc9JVHqhej
	mN1Tid39+rXkY91yWqXtC85kXx0QowYm/klVBPcBCT+hrBMcDgKjW5fFV23UZ9mLBYxwq0e3x2b0M
	diS9I8iwPgJAgQ6wgJ7RTpVtQNgQk4TUsnKfpZhpwTqx108Wd6fmSnD/CBV76h2gPmkU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pw6Ez-00CDyC-A2; Mon, 08 May 2023 21:09:45 +0200
Date: Mon, 8 May 2023 21:09:45 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	Peter Geis <pgwipeout@gmail.com>, Frank <Frank.Sae@motor-comm.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: phy: broadcom: Add support for
 Wake-on-LAN
Message-ID: <5711f834-8fc1-4144-bc12-e12388c2808a@lunn.ch>
References: <20230508184309.1628108-1-f.fainelli@gmail.com>
 <20230508184309.1628108-3-f.fainelli@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508184309.1628108-3-f.fainelli@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Because the Wake-on-LAN configuration can be set long before the system
> is actually put to sleep, we cannot have an interrupt service routine to
> clear on read the interrupt status register and ensure that new packet
> matches will be detected.

Hi Florian

I assume the interrupt is active low, not an edge. And it will remain
active until it is cleared? So on resume, don't you need to clear it?
Otherwise it is already active when entering the next suspend/resume
cycle.

	Andrew

