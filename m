Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E439B03A
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 15:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393397AbfHWM7I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Aug 2019 08:59:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58798 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732003AbfHWM7I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 08:59:08 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 71FCC10A1B
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 12:59:07 +0000 (UTC)
Received: by mail-ed1-f72.google.com with SMTP id m30so5270798eda.11
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=4j8XqRZLG1Cih7GKV7OnBm40odMQxeFeYKHizmugilI=;
        b=Hi6koxJw3rO4MSR8B6vhQfRerNaoFeN4cUJ2pmE+qPz4/cnZnEXDCLrVfxzVvMfCcf
         gYXl69ijFmNy4kyvTnWbOKk86DdN3v3cJrE6Lyq4eGEBykcrPigzaII+SEJ61OLSpyFY
         prc1SYpmirDllgsXPtDpyw65VDKSycC39o34rg693fj5c9ZbeHQUfgOj3wH91yKeVGeH
         dFGoMVluCvCeonjaRh6oWmHN4Ot5C65LMicsZb1jfc7Uil4GxctMgorzl4rhlOFkIBIZ
         ymA4mEbKvF+9VQ5HxYWXLh07CyPjXlZ2fW/I85JDGVs8iJ7SBmYjp8NKw74MOc30q8lR
         /YWQ==
X-Gm-Message-State: APjAAAVINvzmq4DOoQT+qB7EoTgiHYO1+iwkllEOhTQrD0MIuTbPPxxX
        J6HtIVoss+yEe94fLTiSU1+YAsrh3f3RACmqAwmNrZ+lqZKBmkgzmLnU/UGB8Gj7r2vvtO8YlzX
        KmK6UZbD0ey9rY1EO
X-Received: by 2002:a17:906:131a:: with SMTP id w26mr4057634ejb.131.1566565146152;
        Fri, 23 Aug 2019 05:59:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyqIgXKluUFf55vXsBwritATlzpOOa3moKxoukRozTEiIt+PoXK3JokDGWded/SwXgxZco59Q==
X-Received: by 2002:a17:906:131a:: with SMTP id w26mr4057631ejb.131.1566565145987;
        Fri, 23 Aug 2019 05:59:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id g13sm518079eds.39.2019.08.23.05.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 05:59:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C5371181CEF; Fri, 23 Aug 2019 14:59:04 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, bird-users@network.cz,
        Tom Bird <tom@portfast.co.uk>,
        Maria Jan Matejka <jan.matejka@nic.cz>,
        Ondrej Zajicek <santiago@crfreenet.org>
Subject: Re: IPv6 routes inserted into the kernel with 'route' end up with invalid type
In-Reply-To: <423380ec-b999-d620-9bd6-78c2dabfde99@gmail.com>
References: <87mug0m4rp.fsf@toke.dk> <423380ec-b999-d620-9bd6-78c2dabfde99@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 23 Aug 2019 14:59:04 +0200
Message-ID: <87ef1cm413.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 8/23/19 8:43 AM, Toke Høiland-Jørgensen wrote:
>> Hi David
>> 
>> Tom noticed[0] that on newer kernels, the Bird routing daemon rejects IPv6
>> routes received from the kernel if those routes were inserted with the
>> old 'route' utility (i.e., when they're inserted through the ioctl
>> interface).
>> 
>> We tracked it down to the routes having an rtm_type of RTN_UNKNOWN, and
>> a bit of git archaeology points suggestively at this commit:
>> 
>> e8478e80e5a ("net/ipv6: Save route type in rt6_info")
>> 
>> The same setup works with older kernels, so this seems like it's a
>> regression, the age of 'route' notwithstanding. Any good ideas for the
>> proper way to fix this?
>> 
>
> Should be fixed by:
>
> commit c7036d97acd2527cef145b5ef9ad1a37ed21bbe6
> Author: David Ahern <dsahern@gmail.com>
> Date:   Wed Jun 19 10:50:24 2019 -0700
>
>     ipv6: Default fib6_type to RTN_UNICAST when not set
>
>     A user reported that routes are getting installed with type 0
> (RTN_UNSPEC)
>     where before the routes were RTN_UNICAST. One example is from accel-ppp
>     which apparently still uses the ioctl interface and does not set
>     rtmsg_type. Another is the netlink interface where ipv6 does not require
>     rtm_type to be set (v4 does). Prior to the commit in the Fixes tag the
>     ipv6 stack converted type 0 to RTN_UNICAST, so restore that behavior.
>
>     Fixes: e8478e80e5a7 ("net/ipv6: Save route type in rt6_info")
>     Signed-off-by: David Ahern <dsahern@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>


Ah, great! Guess that hasn't made its way to the stable and distribution
kernels yet. Thanks for the pointer! :)

-Toke
