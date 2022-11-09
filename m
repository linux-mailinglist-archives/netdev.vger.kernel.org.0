Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675856221FB
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiKICgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKICgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:36:42 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7051C131
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 18:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sb3jdt2LqKaRIy3rClVSuCsZMuW6iE+LpMeknXdHMWQ=; b=EYN8S0A/hIrYLga995JGsaOhXX
        6GVH2qv6Brmdn1D+tSBY8bc0HejiYIo2pFou2HxHlQPzLRDienBjKQXtf3Hn8TV+wOra6Xunre8jU
        ox2j2t2jH26gpPlOwaloW3uic9O9PsmjLuVvjaeX8TW9rOOToH0P8COaOPWMntMRrem4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osawp-001scn-AW; Wed, 09 Nov 2022 03:36:15 +0100
Date:   Wed, 9 Nov 2022 03:36:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     'Jakub Kicinski' <kuba@kernel.org>,
        'Mengyuan Lou' <mengyuanlou@net-swift.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/5] net: txgbe: Initialize service task
Message-ID: <Y2sSH/WAwivllMtI@lunn.ch>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com>
 <20221108111907.48599-3-mengyuanlou@net-swift.com>
 <20221108155545.79373df2@kernel.org>
 <028801d8f3e1$492f08c0$db8d1a40$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <028801d8f3e1$492f08c0$db8d1a40$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 10:16:32AM +0800, Jiawen Wu wrote:
> On Wednesday, November 9, 2022 7:56 AM, Jakub wrote:
> > On Tue,  8 Nov 2022 19:19:04 +0800 Mengyuan Lou wrote:
> > > +	__TXGBE_TESTING,
> > > +	__TXGBE_RESETTING,
> > > +	__TXGBE_DOWN,
> > > +	__TXGBE_HANGING,
> > > +	__TXGBE_DISABLED,
> > > +	__TXGBE_REMOVING,
> > > +	__TXGBE_SERVICE_SCHED,
> > > +	__TXGBE_SERVICE_INITED,
> > 
> > Please don't try to implement a state machine in the driver.
> > Protect data structures with locks, like a normal piece of SW.
> > 
> 
> The state machine will be used in interrupt events, locks don't seem to fit it.

spinlock can be used with interrupts.

Also, once you make use of phylink, you might not need any of this.

	 Andrew
