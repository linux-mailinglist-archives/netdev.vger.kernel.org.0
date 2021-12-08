Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CAF46D161
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 11:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhLHKyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 05:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhLHKyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 05:54:53 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA5EC061746;
        Wed,  8 Dec 2021 02:51:22 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1muuXZ-0006mK-LV; Wed, 08 Dec 2021 11:51:13 +0100
Date:   Wed, 8 Dec 2021 11:51:13 +0100
From:   Florian Westphal <fw@strlen.de>
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        Andrea Righi <andrea.righi@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Stefano Salsano <stefano.salsano@uniroma2.it>
Subject: Re: [PATCH] ipv6: fix NULL pointer dereference in ip6_output()
Message-ID: <20211208105113.GE30918@breakpoint.cc>
References: <20211206163447.991402-1-andrea.righi@canonical.com>
 <cfedb3e3-746a-d052-b3f1-09e4b20ad061@gmail.com>
 <20211208012102.844ec898c10339e99a69db5f@uniroma2.it>
 <a20d6c2f-f64f-b432-f214-c1f2b64fdf81@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a20d6c2f-f64f-b432-f214-c1f2b64fdf81@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> wrote:
> On 12/7/21 5:21 PM, Andrea Mayer wrote:
> > +        IP6CB(skb)->iif = skb->skb_iif;
> >          [...]
> > 
> > What do you think?
> > 
> 
> I like that approach over the need for a fall back in core ipv6 code.

What if the device is removed after ->iif assignment and before dev lookup?
