Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6800241E07D
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 20:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352975AbhI3SCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 14:02:45 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38246 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352957AbhI3SCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 14:02:44 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id D58CD63ED1;
        Thu, 30 Sep 2021 19:59:33 +0200 (CEST)
Date:   Thu, 30 Sep 2021 20:00:56 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, lukas@wunner.de, kadlec@netfilter.org,
        fw@strlen.de, ast@kernel.org, edumazet@google.com, tgraf@suug.ch,
        nevola@gmail.com, john.fastabend@gmail.com, willemb@google.com
Subject: Re: [PATCH nf-next v5 0/6] Netfilter egress hook
Message-ID: <YVX7WATmhsJUATSB@salvia>
References: <20210928095538.114207-1-pablo@netfilter.org>
 <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
 <YVVk/C6mb8O3QMPJ@salvia>
 <3973254b-9afb-72d5-7bf1-59edfcf39a58@iogearbox.net>
 <YVWBpsC4kvMuMQsc@salvia>
 <20210930072835.791085f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YVXUIUMk0m3L+My+@salvia>
 <20210930090652.4f91be57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210930090652.4f91be57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 09:06:52AM -0700, Jakub Kicinski wrote:
> On Thu, 30 Sep 2021 17:13:37 +0200 Pablo Neira Ayuso wrote:
> > On Thu, Sep 30, 2021 at 07:28:35AM -0700, Jakub Kicinski wrote:
> > > The lifetime of this information is constrained, can't it be a percpu
> > > flag, like xmit_more?  
> > 
> > It's just one single bit in this case after all.
> 
> ??

There are "escape" points such ifb from ingress, where the packets gets
enqueued and then percpu might not help, it might be fragile to use
percpu in this case.

> > > > Probably the sysctl for this new egress hook is the way to go as you
> > > > suggest.  
> > > 
> > > Knobs is making users pay, let's do our best to avoid that.  
> > 
> > Could you elaborate?
> 
> My reading of Daniel's objections was that the layering is incorrect
> because tc is not exclusively "under" nf. That problem is not solved 
> by adding a knob. The only thing the knob achieves is let someone
> deploying tc/bpf based solution protect themselves from accidental
> nf deployment.
> 
> That's just background / level set. IDK what requires explanation 
> in my statement itself. I thought "admin knobs are bad" is as
> universally agreed on as, say, "testing is good".

Yes, knobs are not ideal but Daniel mentioned it as a posibility, the
skbuff bit might not ideal either because it might be not easy to
debug the behaviour that it turns on to the user, but it could only be
set on from act_mirred, Daniel mentioned to cover only the
skb->redirect case.

Thanks
