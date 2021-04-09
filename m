Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEF2359234
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 04:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhDICtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 22:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbhDICta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 22:49:30 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85854C061760;
        Thu,  8 Apr 2021 19:49:18 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t22so1700689ply.1;
        Thu, 08 Apr 2021 19:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dR80kyoECcnOrPvoj5x4devJIhpkiy288PkyOxO5h5k=;
        b=AgwtRJau4jh/pRKYrdNuVTH5hr9Td73qOgEvqonERVLoAYuKQdb+2joVQiHn1OGI+n
         oM/GJmYtykWSjMRmt7jCyC3yqTrOugmM5xOp70cUpzTC1Le7W3cd6SnpoXEj1RYLjX4q
         Kk6RJcv6U2adjWHZAfDkbTDwWfSrJWJuEHGuAde7ZRTgsIF0vf0xsOoIL8MrsmAJVTet
         Wb/M7aDcIxLF19ylQjjnqqeqz5UvnyOoIiorZHlh10O1QhErtSTNLzJiIXmKwcTBYjWZ
         smlkA/jG5SLe8gSFX+dSV2mIFnmUEiB/Yb28C49SWTue3D8uuwkl4VMplPqsGMM6ffju
         fqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dR80kyoECcnOrPvoj5x4devJIhpkiy288PkyOxO5h5k=;
        b=KVcThJL5xH8DGeMXaZ42hs/+0y4OZa0tvxZwyJc8mqipsdaU/eL4srp9f89RasmyGZ
         PcYQUETdADhnC75DhlVLOzyvfAEQfkOV/qsYMa0I7IWknEqInyLwaW73KoSmS4+i7JVq
         xji/4lwJBjE++6z3gZnr9SLFaFddoz3Jdvz/HEOVBLJg7ZjHYn6EhjLT97zeoTuUpfOI
         akH/6GUtkDDfg5HZ7iPwSAfboRaXUKgAVM2QLizsZuZFP8b0Ps9zBlO4oUNsANYYad1m
         9/5nVVL/oj3W0BamyStX3wqnTv3vzZ7GtoCRuo8AXyTGjrn4rMQ857s5h9piH4FPYrxx
         DRhg==
X-Gm-Message-State: AOAM532MkmWbuH9LaFsNMLxEVU0tg0icvWj69NJTd27OZXAuomwyzk/w
        RcL2cBNeb/65UkftfBk/TRA=
X-Google-Smtp-Source: ABdhPJyjUso2B6BdwWk9dCEbwt7ZxZdLw+UIukBFasvwj8F6KCCo+SWt8BYrjf9wB4xD0YHhPrp0Ww==
X-Received: by 2002:a17:90a:5889:: with SMTP id j9mr12051916pji.69.1617936558120;
        Thu, 08 Apr 2021 19:49:18 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c193sm656029pfc.180.2021.04.08.19.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 19:49:17 -0700 (PDT)
Date:   Fri, 9 Apr 2021 10:49:07 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Simo Sorce <simo@redhat.com>, Netdev <netdev@vger.kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
Message-ID: <20210409024907.GN2900@Leo-laptop-t470s>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com>
 <c47d99b9d0efeea4e6cd238c2affc0fbe296b53c.camel@redhat.com>
 <CAHmME9pRSOANrdvegLm9x8VTNWKcMtoymYrgStuSx+nsu=jpwA@mail.gmail.com>
 <20210409024143.GL2900@Leo-laptop-t470s>
 <CAHmME9oqK9iXRn3wxAB-MZvX3k_hMbtjHF_V9UY96u6NLcczAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9oqK9iXRn3wxAB-MZvX3k_hMbtjHF_V9UY96u6NLcczAw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 08:44:35PM -0600, Jason A. Donenfeld wrote:
> Since it's just a normal module library, you can simply do this in the
> module_init function, rather than deep within registration
> abstractions.

I did a try but looks it's not that simple. Not sure if it's because wireguard
calls the library directly. Need to check more...

Hangbin
