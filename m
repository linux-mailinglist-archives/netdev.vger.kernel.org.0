Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08DCF54DD9
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbfFYLk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:40:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728703AbfFYLk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 07:40:57 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 113BB3082AF2;
        Tue, 25 Jun 2019 11:40:57 +0000 (UTC)
Received: from localhost (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 511D25C234;
        Tue, 25 Jun 2019 11:40:51 +0000 (UTC)
Date:   Tue, 25 Jun 2019 13:40:47 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] iproute: Pass RTM_F_CLONED on dump to fetch
 cached routes to be flushed
Message-ID: <20190625134047.48acabee@redhat.com>
In-Reply-To: <209bcb66-2d57-eecf-d1a0-cc86af034e95@gmail.com>
References: <7ae318a8b632c216df95362524cd4bb5f4f1f537.1560561439.git.sbrivio@redhat.com>
        <209bcb66-2d57-eecf-d1a0-cc86af034e95@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 25 Jun 2019 11:40:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jun 2019 15:55:49 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/14/19 7:33 PM, Stefano Brivio wrote:
> > diff --git a/ip/iproute.c b/ip/iproute.c
> > index 2b3dcc5dbd53..192442b42062 100644
> > --- a/ip/iproute.c
> > +++ b/ip/iproute.c
> > @@ -1602,6 +1602,16 @@ static int save_route_prep(void)
> >  	return 0;
> >  }
> >  
> > +static int iproute_flush_flags(struct nlmsghdr *nlh, int reqlen)  
> 
> rename that to iproute_flush_filter to be consistent with
> iproute_dump_filter.

I originally wanted to make it obvious that it's not an actual filter,
but:

> Actually, why can't the flush code use iproute_dump_filter?

...come on. That would be too simple.

No, my original understanding was that strict checking didn't imply
filtering. It does, and the current kernel implementation matches,
now also for RTM_F_CACHED. So yes, we can use it, and it doesn't cause
any unexpected behaviours with older kernels either. Sending v2. Thanks
for pointing this out.

-- 
Stefano
