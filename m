Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77184A01CA
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 14:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfH1McE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 08:32:04 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44432 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726300AbfH1McE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 08:32:04 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i2x7K-0002Zv-3Y; Wed, 28 Aug 2019 14:32:02 +0200
Date:   Wed, 28 Aug 2019 14:32:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: Re: multipath tcp MIB counter placement - share with tcp or extra?
Message-ID: <20190828123202.GI20113@breakpoint.cc>
References: <20190828114321.GG20113@breakpoint.cc>
 <deb00e41-0188-0ca9-ccb3-b74b34a4cc5d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <deb00e41-0188-0ca9-ccb3-b74b34a4cc5d@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Let me know -- I can go with a separate MIB, its no problem, I just want
> > to avoid going down the wrong path.
> 
> There are about 40 counters.
> 
> Space for that will be per netns : num_possible_cpus * 40 * 8  bytes
> 
> The cost of folding all the values will make nstat slower even if MPTCP is not used.

Ok, so 'same proc file' would be fine but 'increase pcpu mem cost
unconditionally' isn't.

> Maybe find a way to not having to fold the MPTCP percpu counters if MPTCP is not loaded ?

MPTCP is builtin (bool).

However, we might be able to delay allocation until first mptcp socket
is requested, I will see if this can be done somehow.

Thanks Eric!
