Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC11A43B2CA
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbhJZNB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 09:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236100AbhJZNB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 09:01:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C59C061767;
        Tue, 26 Oct 2021 05:59:02 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mfM2c-0006pX-Hg; Tue, 26 Oct 2021 14:58:58 +0200
Date:   Tue, 26 Oct 2021 14:58:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, lschlesinger@drivenets.com,
        dsahern@kernel.org, crosser@average.org
Subject: Re: [PATCH v2 net-next 2/2] vrf: run conntrack only in context of
 lower/physdev for locally generated packets
Message-ID: <20211026125858.GA18032@breakpoint.cc>
References: <20211025141400.13698-1-fw@strlen.de>
 <20211025141400.13698-3-fw@strlen.de>
 <YXf2TJivC1Tp3Tfj@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXf2TJivC1Tp3Tfj@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> If the motion for these hooks in the driver is to match for 'oif vrf',
> now that there is an egress hook, it might make more sense to filter
> from there based on the interface rather than adding these hook calls
> from the vrf driver?
> 
> I wonder if, in the future, it makes sense to entirely disable these
> hooks in the vrf driver and rely on egress hook?

Agree, it would be better to support ingress+egress hhoks from vrf
so vrf specific filtering can be done per-device.

I don't think we can just remove the existing NF_HOOK()s in vrf though.

We could add toggles to disable them, but I'm not sure how to best
expose that (ip link attribute, ethtool, sysctl ...)...?
