Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8693359667
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 09:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhDIHbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 03:31:02 -0400
Received: from outbound-smtp27.blacknight.com ([81.17.249.195]:42982 "EHLO
        outbound-smtp27.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231676AbhDIHbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 03:31:01 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp27.blacknight.com (Postfix) with ESMTPS id 8FB49CAAC5
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 08:30:48 +0100 (IST)
Received: (qmail 1573 invoked from network); 9 Apr 2021 07:30:48 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 9 Apr 2021 07:30:48 -0000
Date:   Fri, 9 Apr 2021 08:30:46 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Mel Gorman <mgorman@suse.de>, jslaby@suse.cz,
        Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem in pfmemalloc skb handling in net/core/dev.c
Message-ID: <20210409073046.GI3697@techsingularity.net>
References: <CAJht_ENNvG=VrD_Z4w+G=4_TCD0Rv--CQAkFUrHWTh4Cz_NT2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJht_ENNvG=VrD_Z4w+G=4_TCD0Rv--CQAkFUrHWTh4Cz_NT2Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 11:52:01AM -0700, Xie He wrote:
> Hi Mel Gorman,
> 
> I may have found a problem in pfmemalloc skb handling in
> net/core/dev.c. I see there are "if" conditions checking for
> "sk_memalloc_socks() && skb_pfmemalloc(skb)", and when the condition
> is true, the skb is handled specially as a pfmemalloc skb, otherwise
> it is handled as a normal skb.
> 
> However, if "sk_memalloc_socks()" is false and "skb_pfmemalloc(skb)"
> is true, the skb is still handled as a normal skb. Is this correct?

Under what circumstances do you expect sk_memalloc_socks() to be false
and skb_pfmemalloc() to be true that would cause a problem?

-- 
Mel Gorman
SUSE Labs
