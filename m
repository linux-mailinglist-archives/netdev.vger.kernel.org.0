Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3683152FEDE
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 20:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244158AbiEUSz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 14:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239958AbiEUSzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 14:55:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A65312746;
        Sat, 21 May 2022 11:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0m5otY5wLnd8qF1d6h93ahrmPx+pF7uBjOVxsQJ2omc=; b=6LlEkeuGubfneYezKRZlW95VW1
        YXGM4aRO9RzuUhjToGV1N3ojHj9i3D+YinRTPRLRFgQTid+DGtGShtrSw/B2sUlLtueAGN0ocaXu3
        BHyRs4EDNjr4wYcmsMAD3Pc0mBZQ79KZzhBGPrKINF5gOhVROADXaUWDTHQnOYZo3GfE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nsUGT-003nGs-Sy; Sat, 21 May 2022 20:55:49 +0200
Date:   Sat, 21 May 2022 20:55:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        mcgrof@kernel.org, tytso@mit.edu
Subject: Re: RFC: Ioctl v2
Message-ID: <Yok1tZdl/xmEiQGZ@lunn.ch>
References: <20220520161652.rmhqlvwvfrvskg4w@moria.home.lan>
 <Yof6hsC1hLiYITdh@lunn.ch>
 <20220521164546.h7huckdwvguvmmyy@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521164546.h7huckdwvguvmmyy@moria.home.lan>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 21, 2022 at 12:45:46PM -0400, Kent Overstreet wrote:
> On Fri, May 20, 2022 at 10:31:02PM +0200, Andrew Lunn wrote:
> > > I want to circulate this and get some comments and feedback, and if
> > > no one raises any serious objections - I'd love to get collaborators
> > > to work on this with me. Flame away!
> > 
> > Hi Kent
> > 
> > I doubt you will get much interest from netdev. netdev already
> > considers ioctl as legacy, and mostly uses netlink and a message
> > passing structure, which is easy to extend in a backwards compatible
> > manor.
> 
> The more I look at netlink the more I wonder what on earth it's targeted at or
> was trying to solve. It must exist for a reason, but I've written a few ioctls
> myself and I can't fathom a situation where I'd actually want any of the stuff
> netlink provides.
> 
> Why bother with getting a special socket type? Why asynchronous messages with
> all the marshalling/unmarshalling that entails?

Hi Kent

It has its uses, but my main point was, it is unlikely netdev will buy
into anything else.

> >From what I've seen all we really want is driver private syscalls

netdev is actually very opposed to private syscalls. Given the chance,
each driver will define its own vendor specific APIs, there will be
zero interoperability, you need vendor tools, the documentation will
be missing etc. So netdev tries very hard to have well defined APIs
which are vendor neutral to cover anything a driver, or the network
stack, wants to do.

    Andrew
