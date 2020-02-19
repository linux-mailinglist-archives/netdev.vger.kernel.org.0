Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C77163B4F
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgBSDbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:31:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:42020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgBSDbO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:31:14 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12BF024658;
        Wed, 19 Feb 2020 03:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582083073;
        bh=X4/RKCS1sVnNw4Z8r1AfKIDyTAUh1uAp+I/zVjk2I6U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n1RO+JGRMuytP7GHr5sjv/RX7Y7BV/+rqkm6x5Cxipm8V5Pl51EW/VAONik7bAWrI
         evLnBKbLel1xQhU6aAiRza+myTLz8CA37YbqvMh9q+kJpL2WiI5r+Kca7hgP4W/5nk
         AMKhAYm6Pr5g18+oM31EW5FQ1VtnXuG4V/QP5Emc=
Date:   Tue, 18 Feb 2020 19:31:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     toke@redhat.com, lorenzo@kernel.org, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        andrew@lunn.ch, brouer@redhat.com, dsahern@kernel.org,
        bpf@vger.kernel.org
Subject: Re: [RFC net-next] net: mvneta: align xdp stats naming scheme to
 mlx5 driver
Message-ID: <20200218193111.3b6d6e47@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200218.154713.1411536344737312845.davem@davemloft.net>
References: <526238d9bcc60500ed61da1a4af8b65af1af9583.1581984697.git.lorenzo@kernel.org>
        <20200218132921.46df7f8b@kicinski-fedora-PC1C0HJN>
        <87eeury1ph.fsf@toke.dk>
        <20200218.154713.1411536344737312845.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Feb 2020 15:47:13 -0800 (PST) David Miller wrote:
> Really, mistakes happen and a poorly implemented or inserted fexit
> module should not be a reason to not have access to accurate and
> working statistics for fundamental events.
> 
> I am therefore totally against requiring fexit for this functionality.
> If you want more sophisticated events or custome ones, sure, but not
> for this baseline stuff.
> 
> I do, however, think we need a way to turn off these counter bumps if
> the user wishes to do so for maximum performance.

Yes, this point plus the precedence you mentioned elsewhere are quite
hard to contend with.

In an ideal world I was wondering if we could have the kernel install
the fexit hook, a'la what we do with drop monitor using tracepoints
from within the kernel.

Then have a proper netlink stats group for them, instead of the ethtool
free-form endlessly bikesheddable strings.

But I guess it could be hard to easily recover the source interface
pointer without digging through NAPI instances or such :S

