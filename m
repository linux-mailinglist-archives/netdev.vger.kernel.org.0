Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E548C3DEE0C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbhHCMmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235805AbhHCMmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 08:42:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 270B060F58;
        Tue,  3 Aug 2021 12:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627994524;
        bh=/YmirlCTIhPtprJXOvqz8B7MGjooX1KKSv8hYxHOghM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hk9z3JZICKM+/Vx48pAqV0XXsNJ5kZcFlm2Dp3HMOIplfqpCavjEBfz2F+dabjMni
         GUdJpRll32pJQ3MFIBh8kr+nTt0RMCRF2XI+moP58+vrhd/Sx5Quz7XM4ZXwT/BJZR
         JAJw1IkctepZmohF315IV+vYW9iFbG+0YZo3r0yxMQaRtd3soq+BeSJhpbyGUsnV4m
         RsvUOnYHqAFun/vf5gqwbnPwNAseN79jFQcJxGpCng8aBjhRf4RIuR4eWEv8jllVGs
         5Kul5AEol8uKKsUD8h6dPCwVHnQv66LkkwYvbHJ08aFnMQ7dpZOuroKrJ5iEK2v2eg
         72LbyUWJnj39A==
Date:   Tue, 3 Aug 2021 05:42:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v2] sock: allow reading and changing sk_userlocks with
 setsockopt
Message-ID: <20210803054203.4f1eb9a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ffcf4fe5-814e-b232-c749-01511eb1ceb7@virtuozzo.com>
References: <20210730160708.6544-1-ptikhomirov@virtuozzo.com>
        <20210730094631.106b8bec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9ead0d04-f243-b637-355c-af11af45fb5a@virtuozzo.com>
        <20210802091102.314fa0f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ffcf4fe5-814e-b232-c749-01511eb1ceb7@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Aug 2021 14:04:39 +0300 Pavel Tikhomirov wrote:
> > Just to double check - is the expectation that the value returned is
> > completely opaque to the user space? The defines in question are not
> > part of uAPI.  
> 
> Sorry, didn't though about it initially. For criu we don't care about 
> the actual bits we restore same what we've dumped. Buf if some real 
> users would like to use this interface to restore default autoadjustment 
> on their sockets we should probably export SOCK_SNDBUF_LOCK and 
> SOCK_RCVBUF_LOCK to uAPI.

Just to be sure - please mention this in the commit message.
