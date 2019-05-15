Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EDD1F954
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 19:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfEOR20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 13:28:26 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41219 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfEOR20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 13:28:26 -0400
Received: by mail-io1-f67.google.com with SMTP id a17so216113iot.8
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 10:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WlIMyRG4YJqP0vk9O0W1JQ8KLqSQ0azls/+XSHD3NWU=;
        b=pw02QbVO0AaALIODt1zoqqiL/ErqCUG2ekfTPSQQaPfRG3HzTkhFBTKTEEyV+g22ZL
         6LmzewEhv4UV7SlQ8mQW+NJ8z558Zow6F3HDCUlcjs37tbJab4vg36TWkhSNMqf/o5w9
         +qwyrUKvTAzZN4J9hys11sXYH8jhgH8D/IQ79Y3K7Lw11KelNW4cyKcpCYjBuZIYOB7P
         dNfMxmFw4FN8Hj5HKmbxnoTYhffRtU3kuWdoun5H3mp6tA3O26FWo6DlrnboLyfKaCQv
         OMrifkNdcxg0ckEoUox2o8c9b7deKE7+BcfkUCTgWMn2XlhurggvH895KK9xln8eX4Bo
         VwXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WlIMyRG4YJqP0vk9O0W1JQ8KLqSQ0azls/+XSHD3NWU=;
        b=F9Z+iTHuWC0+2IOoMANAVRmRGfzVtTPcA1iViGAcU6sfSNlG6/jz/WZnILtMTphPSF
         E8E1OdPnz0FE7If5+5sKyeLoeb/EVb/GKqZymbwuU6qGCsg8VFkQCfuNBkPSx6xLh8qo
         +fWbN8Z3G2aBRXEDbXOmhUC94GzYMWILCxDXnRHvqtQnuD7bdeXI+l8suzBVksHkk2dv
         KwsVmRdznl/yfsK1XcuSDa9D0yPtmJDsu50sJyVU6DWB4mwSaimumRXuwsQ/nkXjjC3f
         lRQ+Rzp+vdC9HTnYXGd0ZqV1aZlq7m25wCn9RpJGYzbZ8RlyjuriwWAow7SHZ8Nlc8yR
         B0uQ==
X-Gm-Message-State: APjAAAV0bh0XaOwGSTDRcywrB7buOARIX4VfrNa2U/sT2cxL35smgnt+
        LJkaDrxYt008vfpc2DVxr9V2AOWe3VsyUwMCFizCZA==
X-Google-Smtp-Source: APXvYqwIMTTrFh3FzTtAqQoXY/lX4L7mlpJ5JnIsPIHB1/vlY0o17fCpY+I+XT9ZboKXSYYtGXnMoalKDUduS2NEN3I=
X-Received: by 2002:a5d:9cc9:: with SMTP id w9mr24347345iow.287.1557941305355;
 Wed, 15 May 2019 10:28:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190515004610.102519-1-tracywwnj@gmail.com> <fdded637-fd19-bcab-87aa-b71ca8158735@gmail.com>
 <95d844f2-1be2-83b9-1910-e90ad3d2b28d@gmail.com> <CAEA6p_B8-zBPxzcNSdpK+2U2eOU0efQBSu1dMx3sEV7r1+c8oA@mail.gmail.com>
In-Reply-To: <CAEA6p_B8-zBPxzcNSdpK+2U2eOU0efQBSu1dMx3sEV7r1+c8oA@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 15 May 2019 10:28:14 -0700
Message-ID: <CAEA6p_D0-dT4a-wqz7DMq8dSNbESRkj40ESTTxdnbPar-0N90g@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: fix src addr routing with the exception table
To:     David Ahern <dsahern@gmail.com>
Cc:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>
Date: Wed, May 15, 2019 at 10:25 AM
To: David Ahern
Cc: Wei Wang, David Miller, Linux Kernel Network Developers, Martin
KaFai Lau, Mikael Magnusson, Eric Dumazet

> >
> > What about rt6_remove_exception_rt?
> >
> > You can add a 'cache' hook to ip/iproute.c to delete the cached routes
> > and verify that it works. I seem to have misplaced my patch to do it.
> I don't think rt6_remove_exception_rt() needs any change.
> It is because it gets the route cache rt6_info as the input parameter,
> not specific saddr or daddr from a flow or a packet.
> It is guaranteed that the hash used in the exception table is
> generated from rt6_info->rt6i_dst and rt6_info->rt6i_src.
>
> For the case where user tries to delete a cache route, ip6_route_del()
> calls rt6_find_cached_rt() to find the cached route first. And
> rt6_find_cached_rt() is taken care of to find the cached route
> according to both passed in src addr and f6i->fib6_src.
> So I think we are good here.
>
> From: David Ahern <dsahern@gmail.com>
> Date: Wed, May 15, 2019 at 9:38 AM
> To: Wei Wang, David Miller, <netdev@vger.kernel.org>
> Cc: Martin KaFai Lau, Wei Wang, Mikael Magnusson, Eric Dumazet
>
> > On 5/15/19 9:56 AM, David Ahern wrote:
> > > You can add a 'cache' hook to ip/iproute.c to delete the cached routes
> > > and verify that it works. I seem to have misplaced my patch to do it.
> >
> > found it.

Thanks. I patched it to iproute2 and tried it.
The route cache is removed by doing:
ip netns exec a ./ip -6 route del fd01::c from fd00::a cache
