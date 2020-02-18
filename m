Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD03D16225E
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 09:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgBRI2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 03:28:05 -0500
Received: from mail-pj1-f41.google.com ([209.85.216.41]:32961 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgBRI2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 03:28:05 -0500
Received: by mail-pj1-f41.google.com with SMTP id m7so472714pjs.0
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 00:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=VVw9crMvjIEg8nFFmWLIfJc/Z/7Ms8GCU14BI146KWw=;
        b=BoZ5Eke5L2zSRRv/hkK4hxJo0VrK1rdMcAo7N2PRA3LAo6B4UihVCkR3yF8HCLXu6l
         xqu54bsT1YcueBZG8Pr+9savuDhYdb1aKbt1qCTh3Hk3zG2JRbVmPuB32ZoaRZNE9Vu5
         nBAvrYrAhuKYGO2ND8eLZ60EKJgF9XfwXE4xeTBCojPgyT445I1FBgIps1sDpGrvBI0Z
         ZgTbKRMoCqdCFwhsw0fARSKd2uTPVL6cF1+ZqQdFZJ88nFJ0GIEw2j3wRlEwUIcn30Yv
         +VFnt+O54wjXhdHV0IGEKuJKSr3Ijjgpz6RJWZ7fd6/VLedDHaq5fliM3rGXeRM+MXYG
         SDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=VVw9crMvjIEg8nFFmWLIfJc/Z/7Ms8GCU14BI146KWw=;
        b=NW20yHrhUDle1UGb9LOqoqmcI0gl9nnh96HvjteERj+eYmpS8hnc/rknKGfZeTEKPu
         UthtCbM7G/bnPAx3JYucmEdsaUFUHeRA3LglArPq/bLXrpAPMMSwZKjZB/lXzfrtp57o
         dogy/K/7WVogcB7R1ko8SOV8SVZtqRteexZNXUTWFN0kJlAFde5J/nyK90j5mcGQ4EWq
         ki9QhLCaJL+hqY+s9nJNoqadnmoNLx4FgQxZioXYVJYWRZU2y34DO2/6q1sKfpRp1XSQ
         An09pgzfk2ObZxwGBuC5LY0Xe32CHAL0y2DakM/rOI62nh3tPVco1vNJ+P/Afw92eUOS
         i7CQ==
X-Gm-Message-State: APjAAAW8VI7baYvBpScROdaejrxTNrs/OQLMMScR73Sfw29NdSQzN8eR
        v/RsMuuqvw+hbP2zy5lJ/fNqZ+gT5Ng=
X-Google-Smtp-Source: APXvYqzPzaxnJ5x3PMtRuV7f5X1wbvdssuM1wUraLrvvBH2GFQgvUsaIkGuZ71rJzqqIMKzR1gBbXw==
X-Received: by 2002:a17:90a:f013:: with SMTP id bt19mr1284453pjb.47.1582014484610;
        Tue, 18 Feb 2020 00:28:04 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id hg11sm1977516pjb.14.2020.02.18.00.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 00:28:03 -0800 (PST)
Date:   Tue, 18 Feb 2020 16:27:53 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
Message-ID: <20200218082753.GS2159@dhcp-12-139.nay.redhat.com>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <20200212082434.GM2159@dhcp-12-139.nay.redhat.com>
 <2bc4f125-db14-734d-724e-4028b863eca2@gmail.com>
 <20200212100813.GN2159@dhcp-12-139.nay.redhat.com>
 <954a388a-5a9a-1554-ddb3-133e82208a03@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <954a388a-5a9a-1554-ddb3-133e82208a03@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 07:55:36AM +0100, Rafał Miłecki wrote:
> I'm sorry for a late reply, I spent that time for switching my devices
> to some newer kernel. I wanted to make sure we are not chasing a bug
> that's long time fixed now.
> 
> This problem still exists in the 5.4.18.

OK, bad news...

> > 
> > Hmm, I'm surprised that IGMP works for you, as it requires enable IPv6
> > forwarding. Do you have a lot IPv6 multicast groups on your device?
> 
> The thing is I don't really use IPv6. There are some single IPv6 packets
> in my network (e.g. MDNS packets) but nothing significant.
> 
> For my testing purposes I access my access points using ssh and it's the
> only real traffic. There are no wireless devices connected to my testing
> devices. They are just running monitor mode interfaces without any real
> traffic.
> 
> > What dose `ip maddr list` show?
> 
> # ip maddr list
> 1:      lo
>         inet  224.0.0.1
>         inet6 ff02::1
>         inet6 ff01::1
> 7:      br-lan
>         link  33:33:00:00:00:01
>         link  33:33:00:00:00:02
>         link  01:00:5e:00:00:01
>         link  33:33:ff:7a:fc:80
>         link  33:33:ff:00:00:00
>         inet  224.0.0.1
>         inet6 ff02::1:ff00:0
>         inet6 ff02::1:ff7a:fc80
>         inet6 ff02::2
>         inet6 ff02::1
>         inet6 ff01::1

No much ipv6 traffic, no much IPv6 multicast groups. Only occurred with
IPv6 forwarding enabled...Any possibility(although unlikely) that there
is a loop for ipv6 multicast traffic under br-lan?

Maybe we can use perf kmem to trace kernel memory statistics.

Thanks
Hangbin
