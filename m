Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7C135C579
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 13:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240471AbhDLLnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 07:43:11 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47974 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239624AbhDLLnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 07:43:10 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 71F6563E49;
        Mon, 12 Apr 2021 13:42:27 +0200 (CEST)
Date:   Mon, 12 Apr 2021 13:42:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next 1/1] netfilter: flowtable: Make sure dst_cache
 is valid before using it
Message-ID: <20210412114249.GA1423@salvia>
References: <20210411081334.1994938-1-roid@nvidia.com>
 <20210411105826.GB21185@salvia>
 <3c0b0f60-b7e1-eea3-383b-aba64df8e68e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3c0b0f60-b7e1-eea3-383b-aba64df8e68e@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 11:26:35AM +0300, Roi Dayan wrote:
> 
> 
> On 2021-04-11 1:58 PM, Pablo Neira Ayuso wrote:
> > Hi Roi,
> > 
> > On Sun, Apr 11, 2021 at 11:13:34AM +0300, Roi Dayan wrote:
> > > It could be dst_cache was not set so check it's not null before using
> > > it.
> > 
> > Could you give a try to this fix?
> > 
> > net/sched/act_ct.c leaves the xmit_type as FLOW_OFFLOAD_XMIT_UNSPEC
> > since it does not cache a route.
> > 
> > Thanks.
> > 
> 
> what do you mean? FLOW_OFFLOAD_XMIT_UNSPEC doesn't exists so default 0
> is set.
> 
> do you suggest adding that enum option as 0?

Yes. This could be FLOW_OFFLOAD_XMIT_TC instead if you prefer.

enum flow_offload_xmit_type {
        FLOW_OFFLOAD_XMIT_TC        = 0,
        FLOW_OFFLOAD_XMIT_NEIGH,
        FLOW_OFFLOAD_XMIT_XFRM,
        FLOW_OFFLOAD_XMIT_DIRECT,
};

so there is no need to check for no route in the
FLOW_OFFLOAD_XMIT_NEIGH case (it's assumed this type always has a
route).
