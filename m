Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BFF3BE9D5
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhGGOhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbhGGOhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 10:37:50 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E3AC061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 07:35:09 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id p17-20020a17090b0111b02901723ab8d11fso1780827pjz.1
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 07:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9YW1QN+7Pc0wzYKF883bDmVSQoYhNL8d6ABVkOk43yA=;
        b=u3Ub4weNQPbWoUP6JPFkF3t1ciTSyb9AuA2N+acsanI+j9z+UQkWtoyGplShgQKsI8
         Amt3oCIcBnPT455xET8jCiaAnm10UwavkCdUD4clsy/lrPAtbnw6wHuwsbR9HThsN0pF
         f0Tb5OX6qsaYkzduLvHKf5zhmI3r3eyVD/FYQ/dF3IUJ1OpDyY0iGSOf37TKTtACmy7M
         Z8+e1/J94LIILWxTa+DbRkF6agytXs0MFhrdNU7T+9GXC7OrZhpQY6y4qrkuZgg7CRHI
         6C4IwbUyGvs0mJZWiUyBwrAUswObGYDjaDwo3VZ7lKmT93uFfzNiA4+M1P3tuk0jF3pI
         xGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9YW1QN+7Pc0wzYKF883bDmVSQoYhNL8d6ABVkOk43yA=;
        b=VOvlLRwcgOl4OpVLgKta8CGoHPE4Y96gq4O75def0/bpUZEJYUyCvfp2bfyOosUa1p
         N4wOE136Dhd7aiXKloEZgB1YTdJha8Ea0ctn09OyyLFZ0WUrRFj0SMh4yaJv0GW4YBOZ
         VBEjwejoUtxV67s7mK0EVpejqGkK6R8NsiCzwEXoqLFX52stastxCCqE3IpD0es+PRYw
         DnU5KJ2EwBqYArXazRTRvpj82qbIeTo7Ija5vLz0fRDWL7762zWBHhkEa9rP/KSpLVnU
         LcG6UJVBADmaydH1m6hR3CkMlITl7HnBlJia8E80nVPvsmCEKKf6k4QIMyibVDUsUwox
         gQNw==
X-Gm-Message-State: AOAM531DbTgnlOQONrbM+Q0/plInbYcUyRcRzv6GeR00y9c2qm3DtvDL
        b/DBQKfmFUJdgYJPlWkD7yjnXQ==
X-Google-Smtp-Source: ABdhPJwJN2wlR02S3Dqw1Xzz+Bl5dVmM4NhIt4vuJbwY1aB88MQxv/u67ZjIzneq99nVOBuAQUDoUQ==
X-Received: by 2002:a17:90b:3cc:: with SMTP id go12mr26759435pjb.232.1625668508797;
        Wed, 07 Jul 2021 07:35:08 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id l6sm20282057pff.74.2021.07.07.07.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 07:35:08 -0700 (PDT)
Date:   Wed, 7 Jul 2021 07:35:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCHv5 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-ID: <20210707073505.37738a3d@hermes.local>
In-Reply-To: <20210707122201.14618-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210707122201.14618-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Jul 2021 15:22:01 +0300
Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:

> We started to use in-kernel filtering feature which allows to get only
> needed tables (see iproute_dump_filter()). From the kernel side it's
> implemented in net/ipv4/fib_frontend.c (inet_dump_fib), net/ipv6/ip6_fib.c
> (inet6_dump_fib). The problem here is that behaviour of "ip route save"
> was changed after
> c7e6371bc ("ip route: Add protocol, table id and device to dump request").
> If filters are used, then kernel returns ENOENT error if requested table
> is absent, but in newly created net namespace even RT_TABLE_MAIN table
> doesn't exist. It is really allocated, for instance, after issuing
> "ip l set lo up".
> 
> Reproducer is fairly simple:
> $ unshare -n ip route save > dump
> Error: ipv4: FIB table does not exist.
> Dump terminated
> 
> Expected result here is to get empty dump file (as it was before this
> change).
> 
> v2: reworked, so, now it takes into account NLMSGERR_ATTR_MSG
> (see nl_dump_ext_ack_done() function). We want to suppress error messages
> in stderr about absent FIB table from kernel too.
> 
> v3: reworked to make code clearer. Introduced rtnl_suppressed_errors(),
> rtnl_suppress_error() helpers. User may suppress up to 3 errors (may be
> easily extended by changing SUPPRESS_ERRORS_INIT macro).
> 
> v4: reworked, rtnl_dump_filter_errhndlr() was introduced. Thanks
> to Stephen Hemminger for comments and suggestions
> 
> v5: space fixes, commit message reformat, empty initializers
> 
> Fixes: c7e6371bc ("ip route: Add protocol, table id and device to dump request")
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: Andrei Vagin <avagin@gmail.com>
> Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>

Applied this version
