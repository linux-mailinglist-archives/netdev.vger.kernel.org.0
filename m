Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E78628A5F
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 21:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237540AbiKNUUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 15:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236152AbiKNUUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 15:20:40 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286B1138
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 12:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=d9Gvr5QXZv8pymMk8Qk4xqgWpoEp8L4rrQP6carMuoU=; b=FW450l9zJr+MqW4iTCiEjGXYSc
        xr3lkqzSzmg2rGrjoph2F13U/eQFeedaf4EUrI0yKw7wx58b7tsvS2p94VNvvmfKtqK3JOBqUAb0s
        TqdfjlDZpt6s7K/CK4iWdyc63tZNEajqu+/mp2hUSXVJUpGrZ7FOC/FUk1GzNDLmXUEk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oufwa-002NW3-6H; Mon, 14 Nov 2022 21:20:36 +0100
Date:   Mon, 14 Nov 2022 21:20:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Mengyuan Lou <mengyuanlou@net-swift.com>, netdev@vger.kernel.org,
        jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next 3/5] net: txgbe: Support to setup link
Message-ID: <Y3KjFLibpFlws1N5@lunn.ch>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com>
 <20221108111907.48599-4-mengyuanlou@net-swift.com>
 <20221114154824.704046-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114154824.704046-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 04:48:24PM +0100, Alexander Lobakin wrote:
> From: Mengyuan Lou <mengyuanlou@net-swift.com>
> Date: Tue,  8 Nov 2022 19:19:05 +0800
> 
> > From: Jiawen Wu <jiawenwu@trustnetic.com>
> > 
> > Get link capabilities, setup MAC and PHY link, and support to enable
> > or disable Tx laser.
> > 
> > Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> > ---
> > 
> > [...]
> > 
> > @@ -46,6 +55,13 @@ struct txgbe_adapter {
> >  	struct timer_list service_timer;
> >  	struct work_struct service_task;
> >  
> > +	u32 flags;
> > +
> > +	bool link_up;
> 
> Use can reuse the previous field flags to store link status.
> 
> Also pls try to avoid placing bools in structures, there are lots of
> discussions around it and how compilers place/declare them, but
> better to know for sure it would work the same way on each setup,
> right?

It is likely a lot of this code goes away one phylink it used.

   Andrew
