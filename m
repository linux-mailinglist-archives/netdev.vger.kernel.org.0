Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4693FFE11F
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 16:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfKOPYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 10:24:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727531AbfKOPYp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 10:24:45 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C06F20732;
        Fri, 15 Nov 2019 15:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573831485;
        bh=uEw1J9kLQaohlaIjTPg0I28GjDCDKrb75EIwAlcaGBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kBh/Vsprm1m939Zybs912ne3Q8LKuoYDUzrBQm5IGjzcQxBr5nR84AYBCo8HF3R2C
         2KstXCWwWis4wTzi67ZRVfaWEmm8sSPYNbI3Y7+KBPJ8q2g66FmNoETGV/vfR1sXS/
         43PSQ2UQoD9jWQxyvYhJihOIn8fcqLjYrraR8gJ0=
Date:   Fri, 15 Nov 2019 17:24:42 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next] ip link: Add support to get SR-IOV VF node
 GUID and port GUID
Message-ID: <20191115152442.GE6763@unreal>
References: <20191114133126.238128-1-leon@kernel.org>
 <20191114133126.238128-2-leon@kernel.org>
 <3cf565ce-6170-e632-a004-7ef03c40c6ea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cf565ce-6170-e632-a004-7ef03c40c6ea@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 01:35:11PM -0700, David Ahern wrote:
> On 11/14/19 6:31 AM, Leon Romanovsky wrote:
> > diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> > index b72eb7a1..ed72d0bd 100644
> > --- a/ip/ipaddress.c
> > +++ b/ip/ipaddress.c
> > @@ -484,6 +484,29 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *ifi, struct rtattr *vfinfo)
> >  				   vf_spoofchk->setting);
> >  	}
> >
> > +#define GUID_STR_LEN 24
> > +	if (vf[IFLA_VF_IB_NODE_GUID]) {
> > +		char buf[GUID_STR_LEN];
>
> buf should be declared with SPRINT_BUF; see other users of ll_addr_n2a.
> And, print_vfinfo already has b1 declared so you do not need a new one;
> just change buf to b1.

Thanks, I posted v1.
https://lore.kernel.org/linux-rdma/20191115152155.246821-1-leon@kernel.org
