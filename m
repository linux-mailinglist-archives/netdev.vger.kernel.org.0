Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B61359F78
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 15:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhDINDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 09:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbhDINDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 09:03:10 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7F9C061761
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 06:02:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lUqmX-0006d7-TK; Fri, 09 Apr 2021 15:02:41 +0200
Date:   Fri, 9 Apr 2021 15:02:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Michal Soltys <msoltyspl@yandex.pl>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [BUG / question] in routing rules, some options (e.g. ipproto,
 sport) cause rules to be ignored in presence of packet marks
Message-ID: <20210409130241.GB22648@breakpoint.cc>
References: <babb2ebf-862a-d05f-305a-e894e88f601e@yandex.pl>
 <YGI99fyA6MYKixuB@shredder.lan>
 <24ebb842-cb3a-e1a2-c83d-44b4a5757200@yandex.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24ebb842-cb3a-e1a2-c83d-44b4a5757200@yandex.pl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michal Soltys <msoltyspl@yandex.pl> wrote:
> On 3/29/21 10:52 PM, Ido Schimmel wrote:
> > 
> > ip_route_me_harder() does not set source / destination port in the
> > flow key, so it explains why fib rules that use them are not hit after
> > mangling the packet. These keys were added in 4.17, but I
> > don't think this use case every worked. You have a different experience?
> > 
> 
> So all the more recent additions to routing rules - src port, dst port, uid
> range and ipproto - are not functioning correctly with the second routing
> check.
>
> Are there plans to eventually fix that ?
> 
> While I just adjusted/rearranged my stuff to not rely on those, it should
> probably be at least documented otherwise (presumably in ip-rule manpage and
> perhaps in `ip rule help` as well).

Fixing this would be better. As Ido implies it should be enough to fully
populate the flow keys in ip(6)_route_me_harder.
