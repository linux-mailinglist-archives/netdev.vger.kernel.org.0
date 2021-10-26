Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1339443B311
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 15:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbhJZNTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 09:19:08 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45628 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234252AbhJZNTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 09:19:07 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 14A8463F4E;
        Tue, 26 Oct 2021 15:14:55 +0200 (CEST)
Date:   Tue, 26 Oct 2021 15:16:38 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        lschlesinger@drivenets.com, dsahern@kernel.org, crosser@average.org
Subject: Re: [PATCH v2 net-next 2/2] vrf: run conntrack only in context of
 lower/physdev for locally generated packets
Message-ID: <YXf/tlpw0ARmS8j5@salvia>
References: <20211025141400.13698-1-fw@strlen.de>
 <20211025141400.13698-3-fw@strlen.de>
 <YXf2TJivC1Tp3Tfj@salvia>
 <20211026125858.GA18032@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211026125858.GA18032@breakpoint.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 02:58:58PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > If the motion for these hooks in the driver is to match for 'oif vrf',
> > now that there is an egress hook, it might make more sense to filter
> > from there based on the interface rather than adding these hook calls
> > from the vrf driver?
> > 
> > I wonder if, in the future, it makes sense to entirely disable these
> > hooks in the vrf driver and rely on egress hook?
> 
> Agree, it would be better to support ingress+egress hhoks from vrf
> so vrf specific filtering can be done per-device.
> 
> I don't think we can just remove the existing NF_HOOK()s in vrf though.

I understand, there are people relying on this.

> We could add toggles to disable them, but I'm not sure how to best
> expose that (ip link attribute, ethtool, sysctl ...)...?

I would make it global toggle. As you mentioned it might be good to
explore an alternative to this via the ingress+egress hooks now that
the usecases are better known?
