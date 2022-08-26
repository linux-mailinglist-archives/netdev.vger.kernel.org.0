Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E63E5A1D7E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243969AbiHZAGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiHZAGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:06:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07ABC7426;
        Thu, 25 Aug 2022 17:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=tALikjhkcfqCYODG9ox+sW7SfdO0PHT586j/Fq8SJ9I=; b=Ah
        U1rwGGp2F+tS9DGCsVIipz/MuoeMwzsp+o3PFwGchwSLMMgwrkBO2O327HSANVmMO1F1FgQipuIHR
        d5pHWhZKhU1VGaBYh549I/Q6fqKmKKW1a8BsAojrXPLJU5AOYEt9K1ga5dEAfzzuKpLZRUWK41Xt4
        GCk0bv/oHX4jiFU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRMr6-00EcXx-5H; Fri, 26 Aug 2022 02:05:48 +0200
Date:   Fri, 26 Aug 2022 02:05:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Marcus Carlberg <marcus.carlberg@axis.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@axis.com,
        Pavana Sharma <pavana.sharma@digi.com>,
        Ashkan Boldaji <ashkan.boldaji@digi.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: dsa: mv88e6xxx: support RGMII cmode
Message-ID: <YwgOXL6mFdt8hk+b@lunn.ch>
References: <20220822144136.16627-1-marcus.carlberg@axis.com>
 <20220825123807.3a7e37b7@kernel.org>
 <20220826000605.5cff0db8@thinkpad>
 <20220825155140.038e4d12@kernel.org>
 <20220826012659.32892fef@thinkpad>
 <20220825164206.200f564e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220825164206.200f564e@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 04:42:06PM -0700, Jakub Kicinski wrote:
> On Fri, 26 Aug 2022 01:26:59 +0200 Marek Behún wrote:
> > > Could you explain why? Is there an upstream-supported platform
> > > already in Linus's tree which doesn't boot or something?  
> > 
> > If you mean whether there is a device-tree of such a device, they I
> > don't think so, because AFAIK there isn't a device-tree with 6393 in
> > upstream Linux other than CN9130-CRB.
> > 
> > But it is possible though that there is such a device which has
> > everything but the switch supported on older kernels, due to this RGMII
> > bug.
> > 
> > I think RGMII should have been supported on this switch when I send the
> > patch adding support for it, and it is a bug that it is not, becuase
> > RGMII is supported for similar switches driven by mv88e6xxx driver
> > (6390, for example). I don't know why I overlooked it then.
> > 
> > Note that I wouldn't consider adding support for USXGMII a fix, because
> > although the switch can do it, it was never done with this driver.
> > 
> > But if you think it doesn't apply anyway, remove the Fixes tag. This is
> > just my opinion that it should stay.
> 
> I see, I can only go by our general guidance of not treating omissions 
> as fixes, but I lack the knowledge to be certain what's right here.
> Anyone willing to cast a tie-break vote? Andrew? net or net-next?

Stable rules say: 

o It must fix a real bug that bothers people (not a, “This could be a problem…” type thing).

We know anything with a Fixes: tag pretty much gets considered as a
candidate for stable by the machine learning bot, even if we don't
mark it so. So i would say drop the Fixes: tag, it does not fulfil the
stable requirements.

    Andrew
