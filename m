Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9E458F5B0
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 04:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiHKCFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 22:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiHKCFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 22:05:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84105C9E5
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 19:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mDIvTx2qAvASK3DTy3T6hYmY5KVdGLU3qkdQr8+u5r8=; b=uwwSVduwm0HtYYGars1req+bgS
        QhwAEoy5sr59ydX4x5Hi4yZTB4kT09Lej0tTtO2qUllnE4NTb+H2cRdDI2TiPi7ie5EKEJePiyBP6
        izsL297YDdvcZLRthbcRccUmjc+drA8DXvJV3ZLgGgphNOHNj7g9wQqb7fsV7TnoZ5ZI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oLxZH-00Cz9k-32; Thu, 11 Aug 2022 04:05:03 +0200
Date:   Thu, 11 Aug 2022 04:05:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH] fec: Restart PPS after link state change
Message-ID: <YvRjzwMsMWv3AG1H@lunn.ch>
References: <20220809124119.29922-1-csokas.bence@prolan.hu>
 <YvKZNcVfYdLw7bkm@lunn.ch>
 <299d74d5-2d56-23f6-affc-78bb3ae3e03c@prolan.hu>
 <YvRH06S/7E6J8RY0@lunn.ch>
 <YvRdTwRM4JBc5RuV@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvRdTwRM4JBc5RuV@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 06:37:19PM -0700, Richard Cochran wrote:
> On Thu, Aug 11, 2022 at 02:05:39AM +0200, Andrew Lunn wrote:
> > > Yes. We use PPS to synchronize devices on a common backplane. We use PTP to
> > > sync this PPS to a master clock. But if PTP sync drops out, we wouldn't want
> > > the backplane-level synchronization to fail. The PPS needs to stay on as
> > > long as userspace *explicitly* disables it, regardless of what happens to
> > > the link.
> > 
> > We need the PTP Maintainers view on that. I don't know if that is
> > normal or not.
> 
> IMO the least surprising behavior is that once enabled, a feature
> stays on until explicitly disabled.

O.K, thanks for the response.

Your answer is a bit surprising to me. To me, an interface which is
administratively down is completely inactive. The action to down it
should disable everything.

So your answer also implies PPS can be used before the interface is
set administratively up?

	Andrew
