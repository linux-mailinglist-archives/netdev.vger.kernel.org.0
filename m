Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCCA3DDE71
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 19:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhHBRYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 13:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231410AbhHBRX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 13:23:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EFA660FC2;
        Mon,  2 Aug 2021 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627925029;
        bh=08CK0O9jDcGZbEJKjbVu46c2LdAjn8sY3h2yyecrMeM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SIjeAMJJnVgWp9m3GEnW+1q+Fjj/OrCIjx3WjxEd10Bchn9gUoDa50Sk7tRRmElKs
         LisaJOVqS+VwK6LHYT3THOsy+AlEK0UDFC5g7nd4qfHK62TLStF8+XpR7S693qRY5U
         Rd+jghlO3wmkOLCxT+TXaomFsuAu8CssXVLRtIEbhXkbvLC4Wf/+f8N0UnTubjavz3
         5923BcpL8sidn49rPd8IGcfErQAK6vs+1Ix5aWfuV8y+1BVx/Qub6+EiWP1oTLYTh8
         LUBkS7+FbpixGpifuKrrp5LG8w5lQKH9+MZ2g/RqhvKosaNlugJt/TCVLSp7SG1zeA
         IPAlLSQiAhIuQ==
Received: by pali.im (Postfix)
        id C0F75B98; Mon,  2 Aug 2021 19:23:46 +0200 (CEST)
Date:   Mon, 2 Aug 2021 19:23:46 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to find out name or id of newly created interface
Message-ID: <20210802172346.yj3ia7czg6o7kgn7@pali>
References: <20210731203054.72mw3rbgcjuqbf4j@pali>
 <20210802100238.GA3756@pc-32.home>
 <20210802105825.td57b5rd3d6xfxfo@pali>
 <20210802134320.GB3756@pc-32.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210802134320.GB3756@pc-32.home>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 02 August 2021 15:43:20 Guillaume Nault wrote:
> On Mon, Aug 02, 2021 at 12:58:25PM +0200, Pali Rohár wrote:
> > On Monday 02 August 2021 12:02:38 Guillaume Nault wrote:
> > > 
> > > So the proper solution is to implement NLM_F_ECHO support for
> > > RTM_NEWLINK messages (RTM_NEWROUTE is an example of netlink handler
> > > that supports NLM_F_ECHO, see rtmsg_fib()).
> > 
> > Do you know if there is some workaround / other solution which can be
> > used by userspace applications now? And also with stable kernels (which
> > obviously do not receive this new NLM_F_ECHO support for RTM_NEWLINK)?
> 
> I unfortunately can't think of any clean solution. It might be possible
> to create the new interface with attributes very unlikely to be used by
> external programs and retrieve the interface name and id by monitoring
> link creation messages (like 'ip monitor' does). But at this point it's
> probably easier to just set the interface name and retry with a
> different name every time it conflicted with an existing device.

"set interface name and retry" is what I'm using now... And looks like
it is the only stable solution for now.

I was already thinking about monitoring link creation messages... if
there is not some stable message ordering (e.g. order of response and
monitor message) but I have not deduced anything from the code.

> Maybe someone else could propose less hacky solutions, but I really
> can't think of anything else apart from implementing NLM_F_ECHO.
