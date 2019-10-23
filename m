Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F77E1881
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 13:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404647AbfJWLH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 07:07:58 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:56032 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390540AbfJWLH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 07:07:58 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iNEUe-0002Ht-Cv; Wed, 23 Oct 2019 13:07:56 +0200
Date:   Wed, 23 Oct 2019 13:07:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] netfilter: nf_conntrack: introduce conntrack
 limit per-zone
Message-ID: <20191023110756.GM25052@breakpoint.cc>
References: <1571288584-46449-1-git-send-email-xiangxia.m.yue@gmail.com>
 <20191023103117.GL25052@breakpoint.cc>
 <CAMDZJNXqJk=gDSCRv98EuCyvmCHNarC7Tcu-BuBwo8b+sTOiBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMDZJNXqJk=gDSCRv98EuCyvmCHNarC7Tcu-BuBwo8b+sTOiBQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > openvswitch supports per zone limits already, using nf_conncount
> > infrastructure.
> This path limits the UNREPLIED conntrack entries. If we SYN flood one
> zone, the zone will consume all entries in table, which state
> SYN_SENT.
> The openvswitch limits only the +est conntrack.

Why?  Can't it be fixed to work properly?

> > iptables -t mangle -A PREROUTING -m conntrack --ctstate NEW -m connlimit \
> >    --connlimit-above 1000 --connlimit-mask 0 -j REJECT

This should work for the synflood case, too.
