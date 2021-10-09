Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C351427CA0
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhJIS0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhJIS0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:26:15 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CDDC061570;
        Sat,  9 Oct 2021 11:24:18 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id c29so11000905pfp.2;
        Sat, 09 Oct 2021 11:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wthCRwj5FH0koGyinZmaCCCkEb1uAurioH4UJCJCixU=;
        b=beKPGyt0BjgYrdBFh5k6xvgvcHMx6EZdeVoOAzL12s+L+ASt6sOJk5AV4qJiXvVPaN
         4X3RhIEicAa8cJ53Bg4PiRgmM5NTHgpq+XMyoPDpM34bxoyfEJtychNRtj5cmp7I0GmP
         +h/GNk9VfP/tFto8+fQSed7ZK1DsZNJxj8qQSdY5LAYWYwatxJOfT3gutz7CJXw3cHCh
         CxDBCfd6QKLNh4UheIvk0rFsZZYQ3aihkBc1e9Zuho0ptXYKhDrJBZtubKDEytif3B3J
         rxWbGbD68BPbNVnmoKgtO23IXXkqjNaalu9C2shcDRnMeKJeKZZinoRq54e/pKV9cR9X
         +45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wthCRwj5FH0koGyinZmaCCCkEb1uAurioH4UJCJCixU=;
        b=lbITFF4legeWKQIOy+SKVv9UgDkKWJj1Ozgv6MS5ywW9G1t6ZUfZOGmGUmrlrI13Nk
         7lECE6liCteS7K8R2OhB+ijpVFGnr6jxoYNpUhxNkLjYT7e2Qmxm6U2w5aBjiYVsqZMN
         yFuJvqtFCl6p9ajEX759kHYk47bVbatm4QHk9WDzCAAAshKAaT6EL1VppPufTxcStoSO
         BopPNFt0bAN9w0Dc6fdbE/H1KMv77ugd1UnFjIYMDYm7fqoD7gkQGfui26Mo11eXfAy9
         ARGjMmPhsWiZ1jGjRnyrNdwkyqBIRxFDBTRslBhJ0pja4vRUVHu7WNWgrgUHoZsBT9x5
         fAzg==
X-Gm-Message-State: AOAM533ZzhE+ZoWhBn5ZnzKrzgh48O+anszKAd7gGdLYNQdCv0fxf7x5
        Z8TAhZe6/POm8OOpY659iXs=
X-Google-Smtp-Source: ABdhPJw5F9+eyK2he1Qb0U9apf8QXbpO0qOB9KQu8twm22KQk3dB6RXQSFpJ6YZ+72rk0+1jApWQ5A==
X-Received: by 2002:a62:b50d:0:b0:44b:b81f:a956 with SMTP id y13-20020a62b50d000000b0044bb81fa956mr16284052pfe.27.1633803857535;
        Sat, 09 Oct 2021 11:24:17 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id rm6sm2851075pjb.18.2021.10.09.11.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:24:16 -0700 (PDT)
Date:   Sat, 9 Oct 2021 11:24:14 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sebastien Laveze <sebastien.laveze@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
Message-ID: <20211009182414.GB21759@hoboy.vegasvil.org>
References: <20210927145916.GA9549@hoboy.vegasvil.org>
 <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
 <20210927202304.GC11172@hoboy.vegasvil.org>
 <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
 <20210928133100.GB28632@hoboy.vegasvil.org>
 <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
 <20210930143527.GA14158@hoboy.vegasvil.org>
 <fea51ae9423c07e674402047851dd712ff1733bb.camel@oss.nxp.com>
 <20211007201927.GA9326@hoboy.vegasvil.org>
 <768227b1f347cb1573efb1b5f6c642e2654666ba.camel@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <768227b1f347cb1573efb1b5f6c642e2654666ba.camel@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 09:13:58AM +0200, Sebastien Laveze wrote:
> On Thu, 2021-10-07 at 13:19 -0700, Richard Cochran wrote:

> > If two independent processes are both adjusting a clock concurrently,
> > asynchronously, and at different control rates, the result will be
> > chaos.
> 
> This is especially what we want to prove feasible and we think it's
> posssible with the following conditions:
> -limited frequency adjustments
> -offset adjustment in software

Sorry, the kernel still must function correctly, even when user space
does crazy stuff.

> > It does not matter that it *might* work for some random setup of
> > yours.
> > 
> > The kernel has to function correctly in general, not just in some
> > special circumstances.
> 
> Of course, so what tests and measurements can we bring on the table to
> convince you that it doesn't lead to chaos ?

Show that it always works, even with worst case crazy adjustments.

Thanks,
Richard
