Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C897241D62F
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 11:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349328AbhI3JX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 05:23:29 -0400
Received: from mail.netfilter.org ([217.70.188.207]:36312 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349293AbhI3JX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 05:23:29 -0400
Received: from netfilter.org (barqueta.lsi.us.es [150.214.188.150])
        by mail.netfilter.org (Postfix) with ESMTPSA id CC8EE63EBA;
        Thu, 30 Sep 2021 11:20:20 +0200 (CEST)
Date:   Thu, 30 Sep 2021 11:21:42 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, lukas@wunner.de,
        kadlec@netfilter.org, fw@strlen.de, ast@kernel.org,
        edumazet@google.com, tgraf@suug.ch, nevola@gmail.com,
        john.fastabend@gmail.com, willemb@google.com
Subject: Re: [PATCH nf-next v5 0/6] Netfilter egress hook
Message-ID: <YVWBpsC4kvMuMQsc@salvia>
References: <20210928095538.114207-1-pablo@netfilter.org>
 <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
 <YVVk/C6mb8O3QMPJ@salvia>
 <3973254b-9afb-72d5-7bf1-59edfcf39a58@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3973254b-9afb-72d5-7bf1-59edfcf39a58@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 09:33:23AM +0200, Daniel Borkmann wrote:
> On 9/30/21 9:19 AM, Pablo Neira Ayuso wrote:
[...]
> > Why do you need you need a sysctl knob when my proposal is already
> > addressing your needs?
> 
> Well, it's not addressing anything ... you even mention it yourself "arguably,
> distributors might decide to compile nf_tables_netdev built-in".

I said distributors traditionally select the option that we signal to
them, which is to enable this as module. We can document this in
Kconfig. I think distributors should select whatever is better for
their needs.

Anyway, I'll tell you why module blacklisting is bad: It is a hammer,
it is a band aid to a problem. Blacklisting is just making things
worst because it makes some people believe that something is
unfixable. Yes, it took me a while to figure out.

We already entered the let's bloat the skbuff for many years already,
this is stuffing one more bit into the skbuff just because maybe users
might break an existing setup when they load new rules to the new
netfilter egress hook.

Probably the sysctl for this new egress hook is the way to go as you
suggest.

Thanks.
