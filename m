Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666122B30E2
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 22:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgKNVCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 16:02:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgKNVCk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 16:02:40 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBDFF20A8B;
        Sat, 14 Nov 2020 21:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605387759;
        bh=GYjBU3lgl6LMuKGuY+kJw6Q8TxUHfg1WToTB+Kr+Rq8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t5DfTTzJahp6Ly3gED8ncR/mPQDNCoVHtY+9GTJsv82EHzkmnWN5HeXXAvkCsIlEG
         Y9gQPcIn0K9tR2C6sD0Um2tyhvyLfHBh0vfxzhEjlcPExhDyg3he45oQYE+FYMRSHy
         AWyMq0VSr/fWa/no5bryrAINPJ3JD2Gq5FYrb7o8=
Date:   Sat, 14 Nov 2020 13:02:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 01/13] tcp: factor out tcp_build_frag()
Message-ID: <20201114130239.006cf4c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3a20827d0a695b646579c94b7bbf2a185a3226dc.camel@redhat.com>
References: <cover.1605199807.git.pabeni@redhat.com>
        <8fcb0ad6f324008ccadfd1811d91b3145bbf95fd.1605199807.git.pabeni@redhat.com>
        <20201112150831.1c4bb8b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201112151254.14e3b059@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3a20827d0a695b646579c94b7bbf2a185a3226dc.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 11:38:13 +0100 Paolo Abeni wrote:
> > Is there a chance someone could look into adding annotations to socket
> > locking?  
> 
> Annotating lock_sock_fast()/unlock_sock_fast() as they would
> unconditionally acquire/release the socket spinlock removes the warning
> related to fast lock - at least for me;).
> 
> Hopefully that does not interact with lockdep, but perhpas is a bit too
> extreme/rusty?

I'm not a sparse expert, do we need both __acquire and __acquires?

Would you mind submitting officially and CCing the sparse ML?
