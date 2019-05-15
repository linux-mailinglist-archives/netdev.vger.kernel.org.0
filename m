Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B11FC1F94F
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 19:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfEORZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 13:25:46 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:37948 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfEORZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 13:25:45 -0400
Received: by mail-it1-f196.google.com with SMTP id i63so1439988ita.3
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 10:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dUqHljIkmoS4uLSIJM7lES1LRDI6mWEO7H0dEFpgbJ0=;
        b=dweZqXlO/nzk30cinM91GKlEW4zAm4r1vf+X6WiDR/HWp9ORaHI5Rtz15Zeni4WR33
         pbaO0K78gOCESPqGePQdYFNfz6Ohh1fNJqHqoor/RQbhuQK+MmjysxbFHmAuEenmY/1l
         CC5QB5D6sXMyC+fHVG1yzsNfbVdl4DmW5feqZiinA+zVQE6ZK4nrGmOX4rURAANYY+6G
         40LE8OOak9fzSFadqSqEC+WSQwAm+zryfat/XwexOy6bcksw6gsU3NyX/MD50x4em9Sy
         DTVGnMOF+/qDsbnLxZJAYNoRs9vbmcFUTrS4IJBsH13AjiKzFPo4AZ9900yXTbTCjQrS
         6Ofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dUqHljIkmoS4uLSIJM7lES1LRDI6mWEO7H0dEFpgbJ0=;
        b=RaQOuJ/b3dyQVm/AoCrVvCKB9i4wsozLDx5E0zI3X+PJCnfOPVb2t19RkLu9ANA+WS
         MWDjByjL/W5bdbcre0Ft4ojP9N5qhkksfVLH1JGW5dzmEnPp7zagv5/AQqqW0DxtuLYC
         TfyguVtiwLStqIqBz50S+IEvS+yHwlfB5qT0EX5E+rBGs5MA78KdyWaB6WTOPc1BDr8h
         KpHgDXz+fspnk4L2ot69kfbnJx9XNN2YrZRo4MrwfRsRD6uTxRpdUMRqeZlJq8sIyiUe
         xQYIp0h96baGSxFDQ+VeR9gBSPu2s1X4yJINhu+KieoZSN/qeWxPNmZgV6YE8tQ+gbgN
         Wceg==
X-Gm-Message-State: APjAAAWEASD78D5APajRYraV4PMnAJ1NCSq1GZ5E9/b++xBE9hjncC3R
        SC3t/j8JFQgAhcAAjAE0aXYd4jZDGiqMV8vNAqbNjA==
X-Google-Smtp-Source: APXvYqzvTGtRFUPO09O+MSP7+7VFZWTSvPWr8qgdEmQIwOfsA95OeJ1WWCRbJ4k+kqXSTSnbT5s51bIx/+D0i4cC620=
X-Received: by 2002:a24:eb09:: with SMTP id h9mr9806562itj.14.1557941144710;
 Wed, 15 May 2019 10:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190515004610.102519-1-tracywwnj@gmail.com> <fdded637-fd19-bcab-87aa-b71ca8158735@gmail.com>
 <95d844f2-1be2-83b9-1910-e90ad3d2b28d@gmail.com>
In-Reply-To: <95d844f2-1be2-83b9-1910-e90ad3d2b28d@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 15 May 2019 10:25:33 -0700
Message-ID: <CAEA6p_B8-zBPxzcNSdpK+2U2eOU0efQBSu1dMx3sEV7r1+c8oA@mail.gmail.com>
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

>
> What about rt6_remove_exception_rt?
>
> You can add a 'cache' hook to ip/iproute.c to delete the cached routes
> and verify that it works. I seem to have misplaced my patch to do it.
I don't think rt6_remove_exception_rt() needs any change.
It is because it gets the route cache rt6_info as the input parameter,
not specific saddr or daddr from a flow or a packet.
It is guaranteed that the hash used in the exception table is
generated from rt6_info->rt6i_dst and rt6_info->rt6i_src.

For the case where user tries to delete a cache route, ip6_route_del()
calls rt6_find_cached_rt() to find the cached route first. And
rt6_find_cached_rt() is taken care of to find the cached route
according to both passed in src addr and f6i->fib6_src.
So I think we are good here.

From: David Ahern <dsahern@gmail.com>
Date: Wed, May 15, 2019 at 9:38 AM
To: Wei Wang, David Miller, <netdev@vger.kernel.org>
Cc: Martin KaFai Lau, Wei Wang, Mikael Magnusson, Eric Dumazet

> On 5/15/19 9:56 AM, David Ahern wrote:
> > You can add a 'cache' hook to ip/iproute.c to delete the cached routes
> > and verify that it works. I seem to have misplaced my patch to do it.
>
> found it.
