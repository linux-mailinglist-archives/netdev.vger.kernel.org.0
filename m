Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB213BDA6A
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 17:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhGFPrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 11:47:00 -0400
Received: from relay.sw.ru ([185.231.240.75]:50264 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231689AbhGFPq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 11:46:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=eufNlsgVDeF1QiogE9FqoCT8BtOHfePU9jT21zZOqao=; b=nZ6h3TkyoQvx+6lpyku
        dVT6Kt/JtSiSBDuyzK1mZGHl2prJ55Peo2l7v4Mon3m4RFcfWvDb4j5BGJbvA8Arv6xSznPpEI+kx
        ayQKzVMTadXUiSZ00FzVFaCBQPp8VJOFUd7N+pUVeQf+kWq52TTpjkDwqmMjHHUnLI6vNjfh8Vs=;
Received: from [192.168.15.247] (helo=mikhalitsyn-laptop)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1m0nF9-0035dD-U2; Tue, 06 Jul 2021 18:44:15 +0300
Date:   Tue, 6 Jul 2021 18:44:15 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCHv4 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-Id: <20210706184415.baf59983a9cb5de56050389c@virtuozzo.com>
In-Reply-To: <20210706083407.76deb4c0@hermes.local>
References: <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210629155116.23464-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210706083407.76deb4c0@hermes.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Jul 2021 08:34:07 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Tue, 29 Jun 2021 18:51:15 +0300
> Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> 
> > +	const struct rtnl_dump_filter_arg a[2] = {
> > +		{ .filter = filter, .arg1 = arg1,
> > +		  .errhndlr = errhndlr, .arg2 = arg2, .nc_flags = nc_flags, },
> > +		{ .filter = NULL,   .arg1 = NULL,
> > +		  .errhndlr = NULL, .arg2 = NULL, .nc_flags = 0, },
> >  	};
> 
> I am OK with this as is. But you don't need to add initializers for fields
> that are 0/NULL (at least in C).

Sure, I've made such explicit initializations just because in original
rtnl_dump_filter_nc() we already have them.

Do I need to resend with fixed initializations? ;)

> 
> So could be:
> 	const struct rtnl_dump_filter_arg a[] = {
> 		{ .filter = filter, .arg1 = arg1,
> 		  .errhndlr = errhndlr, .arg2 = arg2, .nc_flags = nc_flags, },
> 		{  },
>  	};

Thanks,
Alex
