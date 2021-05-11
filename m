Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F5337A83B
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 15:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhEKN4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 09:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbhEKN4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 09:56:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D08EC061574;
        Tue, 11 May 2021 06:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=30FSk9frpNYja+khGuUdqflr6Kzy7idJqt7x3auvIr8=; b=eBInv8s8SrUY695R1POYZukZY/
        PnYmLhpFbmX/Nm5sWXs4aamzAgFQauZN47saBYsIHxDB89QlSI44fG6j3eZXqm/vzKq0He/UqxCZ3
        tH/SZKfisxnrg62BE6RZ26hTY21SUwsntPkimJFzYW4whyaKjthVf3GtEoxsSM3pLqHZqG3GJFBBM
        JUQ06k+teOe81KhTSw+CiOfPruxddlh1WqaXsniqmh3hR4AbHem/h97koBSiVRn3DGbUYsbBfYQP5
        P24a+tpt8ajQ38l0N9tVKu2QyJiwpCMH9s0/EkAea1faS418CyI+LV5YyLSLTest2jF8wUJpKMj5l
        5XLYiQng==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lgSqb-007Kj7-T2; Tue, 11 May 2021 13:55:01 +0000
Date:   Tue, 11 May 2021 14:54:53 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] udp: Switch the order of arguments to copy_linear_skb
Message-ID: <YJqMrZBRu/xwmQkR@casper.infradead.org>
References: <20210511113400.1722975-1-willy@infradead.org>
 <ae8f4e176b17439b87420cad69fbabf9@AcuMS.aculab.com>
 <YJqI3Vixcqr+jyZX@casper.infradead.org>
 <73f91574e34f4b92910e2afd012e16f4@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73f91574e34f4b92910e2afd012e16f4@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 01:44:45PM +0000, David Laight wrote:
> From: Matthew Wilcox
> > Sent: 11 May 2021 14:39
> > 
> > On Tue, May 11, 2021 at 01:11:42PM +0000, David Laight wrote:
> > > From: Matthew Wilcox
> > > > Sent: 11 May 2021 12:34
> > > >
> > > > All other skb functions use (off, len); this is the only one which
> > > > uses (len, off).  Make it consistent.
> > >
> > > I wouldn't change the order of the arguments without some other
> > > change that ensures old code fails to compile.
> > > (Like tweaking the function name.)
> > 
> > Yes, some random essentially internal function that has had no new
> > users since it was created in 2017 should get a new name *eyeroll*.
> > 
> > Please find more useful things to critique.  Or, you know, write some
> > damned code yourself instead of just having opinions.
> 
> You could easily completely screw up any code that isn't committed
> to the kernel source tree.
> It isn't the sort of bug I'd want to diagnose.

Simple, get your kernel driver into the main kernel tree (remember we are
talking about drivers released under a GPL-compatible license here, if your
code doesn't fall under this category, good luck, you are on your own here,
you leech). -- GregKH
