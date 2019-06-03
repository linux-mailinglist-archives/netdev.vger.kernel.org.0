Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E25833BB8
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 01:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfFCXF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 19:05:58 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44762 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfFCXF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 19:05:57 -0400
Received: by mail-io1-f68.google.com with SMTP id s7so8412904iob.11
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 16:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/V4gnxQfa3ZeyRDF8tLure6rZ3RY8m3WKPoPPPxAlgs=;
        b=aE5sylYzwudn3B7+371zZyYDhWt7d2bEXbi8lxWkn3MBv6LeIAsPoJtx+G+e4LG08m
         cRlR4ZwRSAsZvTdrRkEdSX4GJuKRVw7XFkZU2vMZZrYjo9gcm0ZrkkVVmh9D1DROBMgl
         WymqNhfHy7gxRpcfKi1BN36S2aE2HQN0elF9SyyYg/fNfqdDFfOZ52Heb5L63dL6p9si
         wthbMHlQFWQ2QI7WuTxPHJlgP09VWR6Mx4Nakl00be2VnMQZSVnFSvIa7AJ2AxOSfloR
         mw21gHNxLMxwB/La+GtIpR76MlVp5LJbbEn1sMFcq7pajcKn1yflmpYNuA2z9XmZ69F4
         vV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/V4gnxQfa3ZeyRDF8tLure6rZ3RY8m3WKPoPPPxAlgs=;
        b=EwwnPO7KQzS9TuYIBn/AiUDw7dfQuWtjj8/OX35Qpx4y96iiWnLW+H5L5T413C4yVr
         WkOeXW6n5pnEQb7c17aDoZFDO4xzcmT/W94/PLjyLE0PIPogN2nrRpwd6jS3XY9F/QNP
         fCoP8xfh7iuJdRLU4akI6OIlY7FGHyzBnxLBMLGyb2SfSrslMZzB85kCepx9vcVI2NPW
         FIL1us9MUrtOSPpB8pSYQuYofQHuSPepX1EXf9jJB/sN89lOsn9nEuidgDmAY/qw6O/w
         yGDAwTcUFe/teW7/N3l7cxk9fb3TKc7wlwxRRnQAp+p7NRCqYSF2A+SiLT4TwM5aaFQh
         /trw==
X-Gm-Message-State: APjAAAXIM/gIVLJRmEtFiyraOaqQcesAZdvMOng9FbPb2+bQwgdxS5Mf
        hHqEqbbJr4Yq3/5blTXfBI9/4q8yOAPSMstk3skd5w==
X-Google-Smtp-Source: APXvYqzTQj5BLwHAQscRtizlorgdqzxkSmscNw9Tl5JY3CBjWnl5kI4wm6fs6XIbvxJq7tV64gkkStSr538NbxAK4H8=
X-Received: by 2002:a6b:b206:: with SMTP id b6mr5933690iof.286.1559603156832;
 Mon, 03 Jun 2019 16:05:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190603040817.4825-1-dsahern@kernel.org> <20190603040817.4825-5-dsahern@kernel.org>
 <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
 <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com> <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
 <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com>
In-Reply-To: <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 3 Jun 2019 16:05:45 -0700
Message-ID: <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        idosch@mellanox.com, saeedm@mellanox.com,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 3:35 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/3/19 3:58 PM, Wei Wang wrote:
> > Hmm... I am still a bit concerned with the ip6_create_rt_rcu() call.
> > If we have a blackholed nexthop, the lookup code here always tries to
> > create an rt cache entry for every lookup.
> > Maybe we could reuse the pcpu cache logic for this? So we only create
> > new dst cache on the CPU if there is no cache created before.
>
> I'll take a look.
>
> Long term, I would like to see IPv6 separate FIB lookups from dst's -
> like IPv4 does. In that case reject routes would not use a dst_entry;
> rather the fib lookups return an error code.
Yes. Agree. That will be even better.
