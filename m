Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C80D44D92E
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 16:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbhKKPeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 10:34:09 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:36032
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233809AbhKKPeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 10:34:09 -0500
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 006EC3F4B8
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 15:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1636644679;
        bh=M0C7+Kz82L1iJI4IsUCerrEkcKIRCNBXuupYaoELGn8=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=eIEBgFyrtsFKluoPfdgGrCbGOigcN/W38Z4MIpasMZ4JjG77CAJJfgZ4D1iMyzXtQ
         9gtx5u5dQJWEeTLCQuTzrMpWlUeWg9gu5b39raSXNxjz6xhz2eyygvNPoVCFcC0zCQ
         XdSOmBDHePUTNfwWi0ss53Fm7F0xIcNb/lpSuPc0aYxMmoeuwb2Y2bJH197GgM07+S
         6ZWNc5ZeduQidSWYGr78gObnAQiFkyxB5tpW2KSbHJgZJrviEaeKx7uX+LVqVbIRXO
         JNpq0l4Wmf6RaiVIh8EUP1J1acAOqvxprUTL9fMS9FiN9CYJQekUfNOqKBfbn9j5Ex
         G/nJf6Q8NlsnQ==
Received: by mail-ed1-f71.google.com with SMTP id h13-20020a05640250cd00b003e35ea5357fso5720834edb.2
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 07:31:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M0C7+Kz82L1iJI4IsUCerrEkcKIRCNBXuupYaoELGn8=;
        b=H6TtV7UC/u+EhpEEsxCc8vaH+4nVH23MVL4nnlYj7QFZKyTVA3v5nGGJ5jOlGl0YA+
         kpZI5MthHbGbDklMCPEHyLXSDaOKDsYN0ngr+TYotxXRp/o+kVIJNZ+c4JPp3NaTHdRA
         ItrTvzUvfNRoZFVsugADsUoku4Co3c7QjutL1PNWAbAeW2jVr4X0A32kLpNLm8XM6Khx
         vb/YO4ZsYTO+s1E5MV6QaEmEBd+0CCgI9cSUNUcz8EiZ3PuXULC9/2QC8vONcTuT+9eo
         kpWnOYfMCZRTt7571xcj1P53ssR5WaqnMjFhpebIfJkopxGs5HfBu5a8GcQMEKFiuSs8
         XkMw==
X-Gm-Message-State: AOAM531b+14j4qyuG3sVkBVkXf0QgeorPGGXnahd7vHLoYLEqSUa7XH6
        gj7pZvl905QrjNua5siQgAlObUGRJWqAoXL8KQkRA5NLp9YJqM3ZP65vZ78zxXKmrrXPQI9Crj0
        Yxdv1qhJcGxxGm1tyEO+bcBCbYcRkuQzJ5g==
X-Received: by 2002:a50:8741:: with SMTP id 1mr5562823edv.119.1636644678606;
        Thu, 11 Nov 2021 07:31:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNXq3MmMTketRsMLJKPUzEi/cY9pv/3KWPhTEuC6OXxeVdf1W1fHDuZk7Csd5eUT40sk6ApA==
X-Received: by 2002:a50:8741:: with SMTP id 1mr5562788edv.119.1636644678393;
        Thu, 11 Nov 2021 07:31:18 -0800 (PST)
Received: from localhost ([2001:67c:1560:8007::aac:c1b6])
        by smtp.gmail.com with ESMTPSA id y4sm1745261edq.13.2021.11.11.07.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:31:18 -0800 (PST)
Date:   Thu, 11 Nov 2021 16:31:17 +0100
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: net: properly support IPv6 in GSO GRE test
Message-ID: <YY03RcYshbQFJBRb@arighi-desktop>
References: <20211104104613.17204-1-andrea.righi@canonical.com>
 <20211111072048.00852448@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111072048.00852448@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 07:20:48AM -0800, Jakub Kicinski wrote:
> On Thu,  4 Nov 2021 11:46:13 +0100 Andrea Righi wrote:
> > Explicitly pass -6 to netcat when the test is using IPv6 to prevent
> > failures.
> > 
> > Also make sure to pass "-N" to netcat to close the socket after EOF on
> > the client side, otherwise we would always hit the timeout and the test
> > would fail.
> > 
> > Without this fix applied:
> > 
> >  TEST: GREv6/v4 - copy file w/ TSO                                   [FAIL]
> >  TEST: GREv6/v4 - copy file w/ GSO                                   [FAIL]
> >  TEST: GREv6/v6 - copy file w/ TSO                                   [FAIL]
> >  TEST: GREv6/v6 - copy file w/ GSO                                   [FAIL]
> > 
> > With this fix applied:
> > 
> >  TEST: GREv6/v4 - copy file w/ TSO                                   [ OK ]
> >  TEST: GREv6/v4 - copy file w/ GSO                                   [ OK ]
> >  TEST: GREv6/v6 - copy file w/ TSO                                   [ OK ]
> >  TEST: GREv6/v6 - copy file w/ GSO                                   [ OK ]
> > 
> > Fixes: 025efa0a82df ("selftests: add simple GSO GRE test")
> > Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> 
> This breaks the test for me on Fedora now :(

Oops, sorry about that.

> 
> nc: invalid option -- 'N'
> Ncat: Try `--help' or man(1) ncat for more information, usage options and help. QUITTING.
>     TEST: GREv6/v4 - copy file w/ TSO                                   [FAIL]
> nc: invalid option -- 'N'
> Ncat: Try `--help' or man(1) ncat for more information, usage options and help. QUITTING.
>     TEST: GREv6/v4 - copy file w/ GSO                                   [FAIL]
> nc: invalid option -- 'N'
> Ncat: Try `--help' or man(1) ncat for more information, usage options and help. QUITTING.
>     TEST: GREv6/v6 - copy file w/ TSO                                   [FAIL]
> nc: invalid option -- 'N'
> Ncat: Try `--help' or man(1) ncat for more information, usage options and help. QUITTING.
>     TEST: GREv6/v6 - copy file w/ GSO                                   [FAIL]
> 
> Tests passed:   0
> Tests failed:   4
> 
> 
> Can you please test this on your distro?

Tested, it works fine in Ubuntu as well:

$ sudo ./tools/testing/selftests/net/gre_gso.sh
    TEST: GREv6/v4 - copy file w/ TSO                                   [ OK ]
    TEST: GREv6/v4 - copy file w/ GSO                                   [ OK ]
    TEST: GREv6/v6 - copy file w/ TSO                                   [ OK ]
    TEST: GREv6/v6 - copy file w/ GSO                                   [ OK ]

Tests passed:   4
Tests failed:   0

Tested-by: Andrea Righi <andrea.righi@canonical.com>
