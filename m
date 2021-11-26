Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6F345F05B
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 16:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353998AbhKZPNr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Nov 2021 10:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354220AbhKZPLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 10:11:46 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FF0C0613F9;
        Fri, 26 Nov 2021 06:53:53 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mqcbd-00034R-44; Fri, 26 Nov 2021 15:53:41 +0100
Date:   Fri, 26 Nov 2021 15:53:41 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     fw@strlen.de, pablo@netfilter.org, lschlesinger@drivenets.com,
        dsahern@kernel.org, crosser@average.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] vrf: don't run conntrack on vrf with !dflt qdisc
Message-ID: <20211126145341.GP6326@breakpoint.cc>
References: <20211126143612.11262-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20211126143612.11262-1-nicolas.dichtel@6wind.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> After the below patch, the conntrack attached to skb is set to "notrack" in
> the context of vrf device, for locally generated packets.
> But this is true only when the default qdisc is set to the vrf device. When
> changing the qdisc, notrack is not set anymore.
> In fact, there is a shortcut in the vrf driver, when the default qdisc is
> set, see commit dcdd43c41e60 ("net: vrf: performance improvements for
> IPv4") for more details.
> 
> This patch ensures that the behavior is always the same, whatever the qdisc
> is.
> 
> To demonstrate the difference, a new test is added in conntrack_vrf.sh.

Thanks Nicolas for the explanation & test case.

Acked-by: Florian Westphal <fw@strlen.de>
