Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11E3713193
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbfECPzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:55:31 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52034 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726495AbfECPzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:55:31 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hMaX2-0004Z5-SY; Fri, 03 May 2019 17:55:29 +0200
Date:   Fri, 3 May 2019 17:55:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Florian Westphal <fw@strlen.de>, vakul.garg@nxp.com,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC HACK] xfrm: make state refcounting percpu
Message-ID: <20190503155528.6of5wl3dq7hdryt7@breakpoint.cc>
References: <20190423162521.sn4lfd5iia566f44@breakpoint.cc>
 <20190424104023.10366-1-fw@strlen.de>
 <20190503060748.GK17989@gauss3.secunet.de>
 <0b998948-d89f-21bf-f76a-9c2b96dffd1d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b998948-d89f-21bf-f76a-9c2b96dffd1d@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
 On 5/3/19 2:07 AM, Steffen Klassert wrote:
> > On Wed, Apr 24, 2019 at 12:40:23PM +0200, Florian Westphal wrote:
> >> I'm not sure this is a good idea to begin with, refcount
> >> is right next to state spinlock which is taken for both tx and rx ops,
> >> plus this complicates debugging quite a bit.
> > 
> > 
> 
> 
> For some reason I have not received Florian response.
> 
> Florian, when the percpu counters are in nominal mode,
> the updates are only in percpu memory, so the cache line containing struct percpu_ref in the
> main object is not dirtied.

Yes, I understand this.  We'll still still serialize anyway due to
spinlock.

Given Vakul says the state refcount isn't the main problem and Steffen
suggest to insert multiple states instead I don't think working on this
more makes any sense.

Thanks for the pcpu counter infra pointer though, I had not seen it before.
