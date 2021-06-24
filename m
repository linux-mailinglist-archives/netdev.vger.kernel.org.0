Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7A23B32BD
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 17:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbhFXPjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 11:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbhFXPjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 11:39:10 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F158C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 08:36:51 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id g24so3698149pji.4
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 08:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RQJ8FHtzyLgxeNXFzTkwIo63+hzGJGnJ0fEynVwH1Y4=;
        b=r6UNTF+UWJPUojo0J1zqjJPqZcYaWdeDcDkHeHwiDu4sBlTztm/Zw5HOA3v7gxd4ef
         MJiiXC2ZCAHtDLxTP4HTDSeXzQbf2tz1uoU8dkPEVXksqQTDBnHqeq22gh25EgT6AwTr
         sLprFvHR7exNmmqZPkFcgGaVaSgvhkKNjCD9gmR6RhqR5BxFnG3HLlE1V4okyGBxwQSW
         lkuS1y6OOwqq+CdC+JMKjSc5u+K2QFxOgiSbXz0cNKgm8l7QsIpb0aAS/h7Akh8WJyNb
         r0s4wdEKVyz8bghYOTDtEFLqhOuxqr2tdebVAWQnN1iLQaQ8z+J6MZ86JwWKVkDoxG3a
         6aMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RQJ8FHtzyLgxeNXFzTkwIo63+hzGJGnJ0fEynVwH1Y4=;
        b=r8jZETtesHzYKdIxd7u8p8wWaGOryiEqjkeDlp5K/xmfLG4kWYFm2pm34xCq2jks85
         QPG9VxZ3mZsIwV8XszFz4SISZR6KzCnvFiltCVr8gcix6+BqANcSD9psgUV7S57Pxa/M
         CABweJg+OElGcxHcl7Au1JETIGVrc7Gktq97UbE0srmg3+6D/5gutEbdYP/K601ZbQXz
         xnnt+82QZwl4yvAgA/55YrcH/yyFFfwaRkSVX7uSRQm4MhKSuWjVmlif8LheiJhoUv8r
         LQCzfga4r2AiWvnxfC+eyvxPCwXV4X0ekiBTfrTWdDI9iBO3SXCNmDD2OLRWYviIPDdv
         iElw==
X-Gm-Message-State: AOAM531ld73oll6haESdU1umsN43aXSXd4GRT1W433QPFEYhY5dmxNyI
        MuZ9RsdWec29TJK6r9ABlAbTxw==
X-Google-Smtp-Source: ABdhPJwP/znDmzeUx/TjDrIc5DBuyfKOcdPfz4St/ITfPElYxL6NUsdQZ7E/CXZbldO4ALUpbaDZeg==
X-Received: by 2002:a17:902:c941:b029:122:7351:54a0 with SMTP id i1-20020a170902c941b0290122735154a0mr4591949pla.81.1624549011083;
        Thu, 24 Jun 2021 08:36:51 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id 10sm2637331pgl.42.2021.06.24.08.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 08:36:50 -0700 (PDT)
Date:   Thu, 24 Jun 2021 08:36:47 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCHv2 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-ID: <20210624083647.0f173c4b@hermes.local>
In-Reply-To: <20210624152812.29031-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20210622150330.28014-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210624152812.29031-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Jun 2021 18:28:12 +0300
Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:

> We started to use in-kernel filtering feature which allows to get only needed
> tables (see iproute_dump_filter()). From the kernel side it's implemented in
> net/ipv4/fib_frontend.c (inet_dump_fib), net/ipv6/ip6_fib.c (inet6_dump_fib).
> The problem here is that behaviour of "ip route save" was changed after
> c7e6371bc ("ip route: Add protocol, table id and device to dump request").
> If filters are used, then kernel returns ENOENT error if requested table is absent,
> but in newly created net namespace even RT_TABLE_MAIN table doesn't exist.
> It is really allocated, for instance, after issuing "ip l set lo up".
> 
> Reproducer is fairly simple:
> $ unshare -n ip route save > dump
> Error: ipv4: FIB table does not exist.
> Dump terminated
> 
> Expected result here is to get empty dump file (as it was before this change).
> 
> v2: reworked, so, now it takes into account NLMSGERR_ATTR_MSG
> (see nl_dump_ext_ack_done() function). We want to suppress error messages
> in stderr about absent FIB table from kernel too.
> 
> Fixes: c7e6371bc ("ip route: Add protocol, table id and device to dump request")
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: Andrei Vagin <avagin@gmail.com>
> Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> ---
>  include/libnetlink.h |  5 +++++
>  ip/iproute.c         |  8 +++++++-
>  lib/libnetlink.c     | 31 ++++++++++++++++++++++++++-----
>  3 files changed, 38 insertions(+), 6 deletions(-)
> 
> diff --git a/include/libnetlink.h b/include/libnetlink.h
> index b9073a6a..93c22a09 100644
> --- a/include/libnetlink.h
> +++ b/include/libnetlink.h
> @@ -121,6 +121,11 @@ int rtnl_dump_filter_nc(struct rtnl_handle *rth,
>  			void *arg, __u16 nc_flags);
>  #define rtnl_dump_filter(rth, filter, arg) \
>  	rtnl_dump_filter_nc(rth, filter, arg, 0)
> +int rtnl_dump_filter_suppress_rtnl_errmsg_nc(struct rtnl_handle *rth,
> +		     rtnl_filter_t filter,
> +		     void *arg1, __u16 nc_flags, const int *errnos);
> +#define rtnl_dump_filter_suppress_rtnl_errmsg(rth, filter, arg, errnos) \
> +	rtnl_dump_filter_suppress_rtnl_errmsg_nc(rth, filter, arg, 0, errnos)
>  int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
>  	      struct nlmsghdr **answer)
>  	__attribute__((warn_unused_result));
> diff --git a/ip/iproute.c b/ip/iproute.c
> index 5853f026..796d6d17 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -1734,6 +1734,8 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
>  	char *od = NULL;
>  	unsigned int mark = 0;
>  	rtnl_filter_t filter_fn;
> +	/* last 0 is array trailing */
> +	int suppress_rtnl_errnos[2] = { 0, 0 };
>  

The design would be clearer if there were two arguments rather than magic array of size 2.
Also these are being used as boolean.
