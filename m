Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C44A4A468
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbfFROtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:49:10 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43146 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfFROtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:49:10 -0400
Received: by mail-io1-f68.google.com with SMTP id k20so30376752ios.10
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 07:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fgE4ONaYesm7QSeXE1HvrjKkzOYecRiD/BjcrXOEZnU=;
        b=e6iCDQpSAxhtNdgvvdbbLzXqdH9m11R3DO0hk6fHmmyygu9tyqo+Ws2XB+Yw3HAvzt
         egYXbx8uDS+ykSdEcUxY00UKMerJLThuxWo5xIoobwBNHIngTYyY5P9DQ7E+2/VvkDJ1
         ABEsmNOho9wHutCKWu6oa284KCra053g1LvMXJswr/L68ArsAH6eIfcVI6AoaCrWEM/V
         oaZxdBsj9xN11wV9tf6XRYM6zZtfiowAQkx4Rpk/2viXzSan82rHEqLUw6inNmY5I2CZ
         oC5jJ1SGW463Nf/YbkYaplNso0VLBXF4JJtHIMEC8DnQL5dQccpLKBay76Ajd92SyieS
         GxzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fgE4ONaYesm7QSeXE1HvrjKkzOYecRiD/BjcrXOEZnU=;
        b=IQ3ccobw7yTQl1gi5NyhTOGKjDVhuNeNoUeGoR1Gu+pZ/EfM9vi8SGXhtgsWpGCF+V
         endKCMprnQfC4eWGOQGWggOFZNw1cDVXCBPeFHd5WvHB0RdC7dn7SXgvOL9H5cP8R/yI
         CBFXYd5Ako3T540H7AOwnPOeWWGLAejdIaFGRoHLKUre/pfC5N6IwIvQv8VDEiDwq1cS
         95Jgg39Jm+rqLtO3g2MRlvbFlDAzMJ9AsnWM0mzpKBk5ObpIa/ZgM4JqnVMwh9s3zsSi
         nAHToGEUU6T4grEgOuYRFBeEULX18Wwd3ylwWYqq420wCkS46he1/y4PiiftsAW9u+0X
         ZFgQ==
X-Gm-Message-State: APjAAAVXX+avqL0IMMz0yPnw7vEOGnzfR805dsnrVGV6BW+NWtRKVI67
        HrSi/2z5PeOOgjws4TUv3M1PV+vL
X-Google-Smtp-Source: APXvYqx96Y/TP+E9znll7RjemUdzo5DAgan8qxsPPR1yNhqzeRq2s5hxe7jM3hngZoUkDY5uNB8ZGg==
X-Received: by 2002:a6b:e61a:: with SMTP id g26mr1442923ioh.300.1560869349430;
        Tue, 18 Jun 2019 07:49:09 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:fd97:2a7b:2975:7041? ([2601:282:800:fd80:fd97:2a7b:2975:7041])
        by smtp.googlemail.com with ESMTPSA id o7sm13452867ioo.81.2019.06.18.07.49.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 07:49:08 -0700 (PDT)
Subject: Re: [PATCH net v5 1/6] fib_frontend, ip6_fib: Select routes or
 exceptions dump from RTM_F_CLONED
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560827176.git.sbrivio@redhat.com>
 <91775eb67dfb3ab39576b421c98c84f74fe11594.1560827176.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f7b44750-374c-4500-18a5-b0494330df52@gmail.com>
Date:   Tue, 18 Jun 2019 08:49:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <91775eb67dfb3ab39576b421c98c84f74fe11594.1560827176.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/19 7:20 AM, Stefano Brivio wrote:
> The following patches add back the ability to dump IPv4 and IPv6 exception
> routes, and we need to allow selection of regular routes or exceptions.
> 
> Use RTM_F_CLONED as filter to decide whether to dump routes or exceptions:
> iproute2 passes it in dump requests (except for IPv6 cache flush requests,
> this will be fixed in iproute2) and this used to work as long as
> exceptions were stored directly in the FIB, for both IPv4 and IPv6.
> 
> Caveat: if strict checking is not requested (that is, if the dump request
> doesn't go through ip_valid_fib_dump_req()), we can't filter on protocol,
> tables or route types.
> 
> In this case, filtering on RTM_F_CLONED would be inconsistent: we would
> fix 'ip route list cache' by returning exception routes and at the same
> time introduce another bug in case another selector is present, e.g. on
> 'ip route list cache table main' we would return all exception routes,
> without filtering on tables.
> 
> Keep this consistent by applying no filters at all, and dumping both
> routes and exceptions, if strict checking is not requested. iproute2
> currently filters results anyway, and no unwanted results will be
> presented to the user. The kernel will just dump more data than needed.
> 
> v5: New patch: add dump_routes and dump_exceptions flags in filter and
>     simply clear the unwanted one if strict checking is enabled, don't
>     ignore NLM_F_MATCH and don't set filter_set if NLM_F_MATCH is set.
>     Skip filtering altogether if no strict checking is requested:
>     selecting routes or exceptions only would be inconsistent with the
>     fact we can't filter on tables.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  include/net/ip_fib.h    | 2 ++
>  net/ipv4/fib_frontend.c | 8 +++++++-
>  net/ipv6/ip6_fib.c      | 3 ++-
>  3 files changed, 11 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


