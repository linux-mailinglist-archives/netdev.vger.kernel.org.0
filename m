Return-Path: <netdev+bounces-6298-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1B73715985
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15D531C20B03
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712DA12B9F;
	Tue, 30 May 2023 09:09:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6688646B2
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:09:24 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178BB102;
	Tue, 30 May 2023 02:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=dxUn5KDWYkYQw9MPObtNBvrB7O+lUDFALieX9mllW+I=; b=qg/Sx5J1U60MysRKrmckHBjkuR
	sK9hYS24noQwvhnT1SvNc7+5b/YMfx9n7IrOUAjxorybIuGRiFmxhi9mr2UB5UQLJYQavelHS7N0g
	kyc3OrfYLOdIzzuS8rfpaePs4GUkR7oiuB1AiZlzuR4ye/+Pb7JlDR95JWSfWq4B2Gs68je2gyBVw
	sSaZ8rITwp/Ha1bWrVqC5wbfRyPkYC2yGg7U1kvTmkRNn+jiacIyapz+75nw3eOfP5dFz3oMh+L3q
	rzs8x4AHlD/FQg5Xbs/JdH/2opGXZ+oNRS7YdfFon28j0SXxDIUUl0FNdKLm1dtEUIrLTHi9AT0UX
	8Cxp22nw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46202)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q3vLd-0002HQ-3A; Tue, 30 May 2023 10:08:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q3vLb-0007t9-KY; Tue, 30 May 2023 10:08:55 +0100
Date: Tue, 30 May 2023 10:08:55 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Lu Hongfei <luhongfei@vivo.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"open list:ETHERNET PHY LIBRARY" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	opensource.kernel@vivo.com
Subject: Re: [PATCH] net: Replace the ternary conditional operator with min()
Message-ID: <ZHW9J/MkJs2svYsG@shell.armlinux.org.uk>
References: <20230530084531.7354-1-luhongfei@vivo.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530084531.7354-1-luhongfei@vivo.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 04:45:30PM +0800, Lu Hongfei wrote:
> It would be better to replace the traditional ternary conditional
> operator with min()

I don't think this is any "better". It's not really a "let's return the
minimum of two values" even though that is what it ends up functionally
being.

Semantically, it's "Is there an error? Yes, then return the error.
Otherwise return success" where an error in the kernel is defined as a
negative integer and success as generally zero, or sometimes a small
positive integer.

Replacing these with "min()" makes the code _less_ readable.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

