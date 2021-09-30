Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5AD41DFD4
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 19:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349568AbhI3ROi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 13:14:38 -0400
Received: from bmailout3.hostsharing.net ([176.9.242.62]:45939 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346857AbhI3ROi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 13:14:38 -0400
X-Greylist: delayed 37216 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Sep 2021 13:14:37 EDT
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id DFCF2100B09E0;
        Thu, 30 Sep 2021 19:12:53 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id BE73C182995; Thu, 30 Sep 2021 19:12:53 +0200 (CEST)
Date:   Thu, 30 Sep 2021 19:12:53 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        ast@kernel.org, edumazet@google.com, tgraf@suug.ch,
        nevola@gmail.com, john.fastabend@gmail.com, willemb@google.com
Subject: Re: [PATCH nf-next v5 0/6] Netfilter egress hook
Message-ID: <20210930171253.GA13673@wunner.de>
References: <20210928095538.114207-1-pablo@netfilter.org>
 <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
 <YVVk/C6mb8O3QMPJ@salvia>
 <3973254b-9afb-72d5-7bf1-59edfcf39a58@iogearbox.net>
 <YVWBpsC4kvMuMQsc@salvia>
 <20210930072835.791085f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930072835.791085f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 07:28:35AM -0700, Jakub Kicinski wrote:
> On Thu, 30 Sep 2021 11:21:42 +0200 Pablo Neira Ayuso wrote:
> > this is stuffing one more bit into the skbuff
> 
> The lifetime of this information is constrained, can't it be a percpu
> flag, like xmit_more?

Hm, can't an skb be queued and processed later on a different cpu?
E.g. what about fragments?

That would rule out a percpu flag, leaving a flag in struct sk_buff
as the only option.

Thanks,

Lukas
