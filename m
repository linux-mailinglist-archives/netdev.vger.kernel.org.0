Return-Path: <netdev+bounces-696-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36EBF6F9110
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 12:02:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7F24281187
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 10:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA8258467;
	Sat,  6 May 2023 10:02:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF62B7C
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 10:02:15 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C099B5
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 03:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GyY7wdlzrfhOimHu5UiiVrjzhWVpz/uzEmzEA8sqiHc=; b=flULOEUK77RcU1vyTCQzDqGws8
	DKocxiNzm/JOCa1HjRc+iHMe+iLJUvKJ/VrSc2w1JYkARZDcQFyDJr5kYIKoU84meyRY8BVNCVhry
	/gvoq1/qAskiKj9Op1h7IqOObBKenlO9MveAQVQ9hDQ/J3OS9mOL0+31Tlok55fGZYUyTXIv09UOp
	a9K//edd8jkz3ygC9ziL+7/A5G3G3uAgBiOVp/aFRWn02ux5rsUndv76SHIzJlLnDk6bdE2sH8vl8
	tjYCJk8KPz0BxVw1BhvT2LXtv2oT8dKQ6kZ6oqIhe5VUNAkeOaGavFpkctX5wOacyYiDBIKmd9hHE
	nkC/JR9A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41200)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pvEk0-0007fe-RT; Sat, 06 May 2023 11:02:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pvEk0-0004wz-8O; Sat, 06 May 2023 11:02:12 +0100
Date: Sat, 6 May 2023 11:02:12 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Lorenz Brun <lorenz@brun.one>, netdev@vger.kernel.org
Subject: Re: Quirks for exotic SFP module
Message-ID: <ZFYlpIf6rfjgFR4M@shell.armlinux.org.uk>
References: <C157UR.RELZCR5M9XI83@brun.one>
 <7ed07d2e-ef0e-4e27-9ac6-96d60ae0e630@lunn.ch>
 <CQF7UR.5191D6UPT6U8@brun.one>
 <d75c2138-76c6-49fe-96c3-39401f18b831@lunn.ch>
 <DVN7UR.QEVJPHB8FG6I1@brun.one>
 <8adbd20c-6de0-49ab-aabe-faf845d9a5d9@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8adbd20c-6de0-49ab-aabe-faf845d9a5d9@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 06, 2023 at 03:05:10AM +0200, Andrew Lunn wrote:
> > OT but my messages to Russell King cannot be delivered
> > mx0.armlinux.org.uk: <lorenz@brun.one> is locally blocked. If this is
> > incorrect, please contact the postmaster.
> > 
> > I haven't knowingly sent any messages to him before so I have no idea why
> > I'd be blocked. My sender IP isn't on any public blacklist MultiRBL knows
> > about. My DKIM/DMARC setup is also working.
> 
> Russell, what do your mail logs say?

Explained in my first reply. *.one was blocked because it was a source
of spam when first "announced".

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

