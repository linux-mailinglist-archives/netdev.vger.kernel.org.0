Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA929D88DC
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387777AbfJPHCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:02:11 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36234 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfJPHCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 03:02:11 -0400
Received: by mail-wr1-f68.google.com with SMTP id y19so26645690wrd.3
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 00:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DLuYhB/E4tXEdWC19NhZFYI7GL6YSnszbWNVyO8GF6g=;
        b=C8+LEffjBgyeRrefD1USYMduiL0ddk5PUtbeF67sPXWhRaAYOYq6+LoKdLO+p3ln85
         DAqG39cwLvuhio0rgtdydlFEBJms8fJj5SChfSicWGn6HududCYDgXv0+eMcgYiypO0A
         5lM0DLEJH5Nn/1o41fxdm9Aj99BKLx+68nu4wxaySdOgXPfjP1rz6FspegDanB971yIq
         w3tFEAF6V4ZZnF4aWw8OT54sehJWR2hQiiKHRfz103HYQGBHAnRsnVv8tXp/LsOBiNgG
         ZZWDEvcEh17CSTTyEmbEnp2BKoMlydxbuCWoMTqjVTumhy0MCRNXCkQad8QQOiOXtoT7
         LRMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DLuYhB/E4tXEdWC19NhZFYI7GL6YSnszbWNVyO8GF6g=;
        b=s64PFMEscdw8ymL6Imd8NC2fLCRIlW1ofAt1KjVMZXkEjnwqQFfst/MMSqWYfqDAkk
         J7Ap1mo22PF5b0mScsQfulg4Rl7jo3N7kNUaItQhuN5nZ5z7pEEMF2xTdQGm2ZpxaCs0
         GVkPCXEE3j2EP+aKLzvXIHqdNgLE4bO9/LR9+fkcI0+5wq6/nj7k7vAgkeFiSmWBv0GI
         IMd6kNculLOjlqra6eD2XcmvzqU/jMOjyUGe1+o4ZYe1n/xtp4IgFh9oD8bkdVX0IfbE
         Bvn1OFz1Ub/B6h0fAy89YBYJ1EOk2KMfTQp77s6X8Lz/MP+yq69ZUMKG3NUM14xTs0UU
         /fiQ==
X-Gm-Message-State: APjAAAV5/Ctjfxea51ImxIC3pVoxxMruczyKdJQyv+ZYBu2CmI2+roDt
        T9VbsBnYv6FogyKsiVyOv8JvmVk/mpqAfbehE1FmXEhn5pE=
X-Google-Smtp-Source: APXvYqxdrQi9cYjebENBLNwCUVQfIGenxC+73oov8eZf0zPzMOSViC3iD/tSw07tIxGGNUxxfLQZF0p+1jDVW20SXMA=
X-Received: by 2002:adf:f685:: with SMTP id v5mr1298218wrp.246.1571209327766;
 Wed, 16 Oct 2019 00:02:07 -0700 (PDT)
MIME-Version: 1.0
References: <20191012011455.211242-1-maheshb@google.com> <20191015.103609.86962935874616520.davem@davemloft.net>
In-Reply-To: <20191015.103609.86962935874616520.davem@davemloft.net>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Wed, 16 Oct 2019 00:01:50 -0700
Message-ID: <CAF2d9jiXqpVXmh--RzyJc5L7b3Ee7Sz94RqJZNxDDA0D7j8APA@mail.gmail.com>
Subject: Re: [PATCHv3 next] blackhole_netdev: fix syzkaller reported issue
To:     David Miller <davem@davemloft.net>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>, mahesh@bandewar.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 10:36 AM David Miller <davem@davemloft.net> wrote:
>
> From: Mahesh Bandewar <maheshb@google.com>
> Date: Fri, 11 Oct 2019 18:14:55 -0700
>
> > While invalidating the dst, we assign backhole_netdev instead of
> > loopback device. However, this device does not have idev pointer
> > and hence no ip6_ptr even if IPv6 is enabled. Possibly this has
> > triggered the syzbot reported crash.
> >
> > The syzbot report does not have reproducer, however, this is the
> > only device that doesn't have matching idev created.
> >
> > Crash instruction is :
> >
> > static inline bool ip6_ignore_linkdown(const struct net_device *dev)
> > {
> >         const struct inet6_dev *idev = __in6_dev_get(dev);
> >
> >         return !!idev->cnf.ignore_routes_with_linkdown; <= crash
> > }
> >
> > Also ipv6 always assumes presence of idev and never checks for it
> > being NULL (as does the above referenced code). So adding a idev
> > for the blackhole_netdev to avoid this class of crashes in the future.
> >
> > ---
>  ...
> > Fixes: 8d7017fd621d ("blackhole_netdev: use blackhole_netdev to invalidate dst entries")
> > Signed-off-by: Mahesh Bandewar <maheshb@google.com>
>
> Applied and queued up for -stable, thanks.

Hi David,
I just started seeing pretty weird behavior in IPv6 stack after this
patch being applied to the net/stable branch. I'm suspecting it's my
patch especially after the v2/v3 changes as I didn't see any other
IPv6 changes in net/branch. I propose to revert this and take a closer
look so that it doesn't spill any further. I'll post a revert soon.

thanks,
--mahesh..
