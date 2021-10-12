Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4A742A229
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbhJLKc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:32:27 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40142 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbhJLKc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 06:32:27 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id BDC6363F14;
        Tue, 12 Oct 2021 12:28:48 +0200 (CEST)
Date:   Tue, 12 Oct 2021 12:30:15 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH nf] netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6
Message-ID: <YWVjtzBnhsB83H7R@salvia>
References: <346934f2ad88d64589fa9a942aed844443cf7110.1634028240.git.lucien.xin@gmail.com>
 <20211012100204.GB2942@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211012100204.GB2942@breakpoint.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 12:02:04PM +0200, Florian Westphal wrote:
> Xin Long <lucien.xin@gmail.com> wrote:
> > In rt_mt6(), when it's a nonlinear skb, the 1st skb_header_pointer()
> > only copies sizeof(struct ipv6_rt_hdr) to _route that rh points to.
> > The access by ((const struct rt0_hdr *)rh)->reserved will overflow
> > the buffer. So this access should be moved below the 2nd call to
> > skb_header_pointer().
> > 
> > Besides, after the 2nd skb_header_pointer(), its return value should
> > also be checked, othersize, *rp may cause null-pointer-ref.
> 
> Patch looks good but I think you can just axe these pr_debug statements
> instead of moving them.
> 
> Before pr_debug conversion these statments were #if-0 out, I don't think
> they'll be missed if they are removed.

Agreed.
