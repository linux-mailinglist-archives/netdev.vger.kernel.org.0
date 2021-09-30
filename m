Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A366341E006
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 19:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352588AbhI3RVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 13:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352525AbhI3RVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 13:21:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FD256137A;
        Thu, 30 Sep 2021 17:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633022361;
        bh=Pn1a6ocfxX8WeGiir9S5RcVPZ2nwOG3p9ACg788p8GA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HP2lAo9/f+O50pE5ZNfIlC4IXlj82OxZ2VTh9WUfo2chWxBmFbYZzX7+ymG+GKstG
         xIDzf0w4WNDqiq80Ap1H7fU9VeHCjHKIlV3bom8Z0wPmZN0pym1p0zzWvWp/0u/KVP
         i63EZdFo1n65UPDX3YGJM0ZQzI1k65uScaiXhuWyjAtQmVJjQtCO+CRcKd0Xv6c4Om
         +4Zugl8h77hQsuk04xsHctT52dmggNE378vnyZsffevNSZyxzcq597N0JR7YnUYtT8
         UPf78Bwo/SVmvmXtStH2ltVkofr4wTlmRsSC3jxO6lvxqtPKD0l3QTKU/X33gbrpE4
         AIUVAXr2obImg==
Date:   Thu, 30 Sep 2021 10:19:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        ast@kernel.org, edumazet@google.com, tgraf@suug.ch,
        nevola@gmail.com, john.fastabend@gmail.com, willemb@google.com
Subject: Re: [PATCH nf-next v5 0/6] Netfilter egress hook
Message-ID: <20210930101920.06bb40b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210930171253.GA13673@wunner.de>
References: <20210928095538.114207-1-pablo@netfilter.org>
        <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
        <YVVk/C6mb8O3QMPJ@salvia>
        <3973254b-9afb-72d5-7bf1-59edfcf39a58@iogearbox.net>
        <YVWBpsC4kvMuMQsc@salvia>
        <20210930072835.791085f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210930171253.GA13673@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Sep 2021 19:12:53 +0200 Lukas Wunner wrote:
> On Thu, Sep 30, 2021 at 07:28:35AM -0700, Jakub Kicinski wrote:
> > On Thu, 30 Sep 2021 11:21:42 +0200 Pablo Neira Ayuso wrote:  
> > > this is stuffing one more bit into the skbuff  
> > 
> > The lifetime of this information is constrained, can't it be a percpu
> > flag, like xmit_more?  
> 
> Hm, can't an skb be queued and processed later on a different cpu?
> E.g. what about fragments?
> 
> That would rule out a percpu flag, leaving a flag in struct sk_buff
> as the only option.

What queuing do you have in mind? Qdisc is after the egress hook.
