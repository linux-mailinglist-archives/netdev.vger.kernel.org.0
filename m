Return-Path: <netdev+bounces-2361-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 220E770178C
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 15:56:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D2641C20DC4
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 13:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02E7E4C80;
	Sat, 13 May 2023 13:56:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E662A185C
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 13:55:59 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A20C2721
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 06:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=o/yqUmtF7d5IhoaOuxI65YJ9jhlW1zPW/xV7pjoqPYk=; b=T0hcVCNfUTOr0xhlRQGqS7+OW3
	toU7tlRaPUZWBOtdI8KA011ZocZltQqQQZ4vHekr+5wS3lnTRViDBbpCXqTDUrjCdbPZdOEbA1A5u
	EXKNiZk9UhiFVrm8qzkfg4ZLv4FBKamd/AU2k4p9FgLGl8ZyDB6Emm4FnbSjwfBtZBYE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pxpix-00Ckx1-MZ; Sat, 13 May 2023 15:55:51 +0200
Date: Sat, 13 May 2023 15:55:51 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC net-next 3/9] net: phylink: add function to resolve
 clause 73 negotiation
Message-ID: <d6b07fbe-3566-42a2-9c7c-057b6cf63f09@lunn.ch>
References: <ZF52z7PqH2HLrWEU@shell.armlinux.org.uk>
 <E1pxWXz-002Qs5-0N@rmk-PC.armlinux.org.uk>
 <7cec3e9f-e614-43b4-abe9-c423d5f63563@lunn.ch>
 <ZF9XNhXthYfALp44@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZF9XNhXthYfALp44@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > Hi Russell
> > 
> > This looks asymmetric in that state->link is not set true if a
> > resolution is found.
> > 
> > Can that set be moved here? Or are there other conditions which also
> > need to be fulfilled before it is set?
> 
> It's intentionally so because it's a failure case. In theory, the
> PHY shouldn't report link-up if the C73 priority resolution doesn't
> give a valid result, but given that there are C73 advertisements
> that we don't support, and that the future may add further
> advertisements, if our software resolution fails to find a speed,
> we need to stop the link coming up. Also... PHYs... hardware
> bugs...

Thanks for the explanation.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
       

