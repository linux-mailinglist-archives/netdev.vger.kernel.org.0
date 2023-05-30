Return-Path: <netdev+bounces-6562-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3548B716EE8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:37:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A442D1C20D38
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B029473;
	Tue, 30 May 2023 20:37:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51CD7E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:37:02 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1110196
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wdHfAXVFhPNft1q83C2Le5C8wgEEzlrlEwtjczVCbOE=; b=tAG1kPPF56amc+8ekxLAmKE5ey
	ffhAWQZA4OZ/MiLbt8Yij+Fuovn5QVRDT6XfXZ7jwVemvFcJH9j0VCfWHJnyqaMhG4nk6frfhdz/x
	+tv6ajwJ7/4zVJv1pyMS9M7oIDC1oTEb8SXqE3TUiM7a58KBNd9O3zlVNTE2ySJkbT8pGTr8jRXw+
	u14Yn0TMVh2ty1aCXIgqYYHrVf8X4sPFcOrok6ASZwlth9M2svgez7FFv47n3HbVsW6fNtk9AITne
	WUAz/wDQIh+h7L90brVmQBvHsp4qknAtayVNQyDuOLtDWOOeuw97qTHNSMLnBiIvIsFyeTbKE+VHU
	54W3jDiw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60596)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q464d-0003Rl-Dh; Tue, 30 May 2023 21:36:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q464c-0008Mz-CO; Tue, 30 May 2023 21:36:06 +0100
Date: Tue, 30 May 2023 21:36:06 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [RFC/RFTv3 00/24] net: ethernet: Rework EEE
Message-ID: <ZHZeNnlNC7J50cCs@shell.armlinux.org.uk>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <fa21ef50-7f36-3d01-5ecf-4a2832bcec89@gmail.com>
 <d753d72c-6b7a-4014-b515-121dd6ff957b@lunn.ch>
 <5b49919e-ff70-b17d-0b15-ea87c86bc703@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b49919e-ff70-b17d-0b15-ea87c86bc703@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 01:03:15PM -0700, Florian Fainelli wrote:
> On 5/30/23 12:48, Andrew Lunn wrote:
> > I don't really care much what we decide means 'enabled'. I just want
> > it moved out of MAC drivers and into the core so it is consistent.
> 
> Understood this is slightly out of the scope of what you are doing which is
> to have an unified behavior, but we also have a shot at defining a correct
> behavior.

Yes, having unified behaviour is good only if we don't end up boxing
ourselves into a corner when trying to unify it. That said, I suspect
many are just broken in one way or another.

What always makes me rather nervous is that trying to fix this kind of
thing will inevitably change the user visible behaviour, and then we
hope that that doesn't cause people's setups to regress.

So, IMHO, if we can decide what the correct behaviour and use should
be before we unify it, the better chance we stand at not having
differing behaviours from future kernel versions as we end up revising
the unified behaviour.

I hope that makes sense! :)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

