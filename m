Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A0B3427D5
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhCSVbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:31:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38020 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230409AbhCSVar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:30:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lNMhb-00Bx0T-07; Fri, 19 Mar 2021 22:30:39 +0100
Date:   Fri, 19 Mar 2021 22:30:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: ipa: activate some commented assertions
Message-ID: <YFUX/tteEzWcuYkG@lunn.ch>
References: <20210319042923.1584593-1-elder@linaro.org>
 <20210319042923.1584593-5-elder@linaro.org>
 <YFTuP7NbUFPoPoCb@lunn.ch>
 <7068152e-5e1b-94b2-bcb2-c66e622bd127@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7068152e-5e1b-94b2-bcb2-c66e622bd127@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 04:18:32PM -0500, Alex Elder wrote:
> On 3/19/21 1:32 PM, Andrew Lunn wrote:
> > > @@ -212,7 +213,7 @@ static inline u32 ipa_reg_bcr_val(enum ipa_version version)
> > >   			BCR_HOLB_DROP_L2_IRQ_FMASK |
> > >   			BCR_DUAL_TX_FMASK;
> > > -	/* assert(version != IPA_VERSION_4_5); */
> > > +	ipa_assert(NULL, version != IPA_VERSION_4_5);
> > 
> > Hi Alex
> > 
> > It is impossible to see just looking what the NULL means. And given
> > its the first parameter, it should be quite important. I find this API
> > pretty bad.
> 
> I actually don't like the first argument.  I would have
> supplied the main IPA pointer, but that isn't always
> visible or available (the GSI code doesn't have the
> IPA pointer definition).  So I thought instead I could
> at least supply the underlying device if available,
> and use dev_err().
> 
> But I wouldn't mind just getting rid of the first
> argument and having a failed assertion always call
> pr_err() and not dev_err().
> 
> The thing of most value to me the asserted condition.

Hi Alex

What you really want to be looking at is adding a
WARN_ON_DEV(dev, condition) macro.

	 Andrew
