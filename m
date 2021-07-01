Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A9F3B949C
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 18:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbhGAQWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 12:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbhGAQWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 12:22:47 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95A0C061764
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 09:20:16 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id x20so9273764ljc.5
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 09:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=brRBtSWPzl3A8EO3IIUcfNsjS22D/ywhnA28QnZfB6M=;
        b=d1+9kxcLWBvJSpk3fPYeulpwABLezPQJEk+Zy5DmBCHiV5k8fys4vw9rA6zQazJKc2
         axsZXI/dx/8bY1setfHEYMO0trSZO9E1jscAwqkUc35Jb6iAXsIo7AKCKK+UvXc4yq3e
         qiMCd+A5iPA4rWbSxd7fv0SiZp5q2XVbT5RkihF/c9RqhFql0Y9/wfOxBCtfxgXbFAMr
         Mx7KUZrtHN63OOzj6Yug9Kv/mnaN8sHZt8YTIbHepTjFUeytb0b2nHtfQ8RV40xMkSSe
         5qtgbQrElgjEnzp0Iq1NHO5GO/OXxxgwKceI1RgUEbvxexDjJYgB8i2ImLpq/VwKKJNu
         X9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=brRBtSWPzl3A8EO3IIUcfNsjS22D/ywhnA28QnZfB6M=;
        b=mDcuieSpHG7LFuzRMQS2i53d6kQoktuOSymGttaG5p6iJbfNsGLCJzFRZgQap4AgCQ
         ihOVUb/U0/smNx+eOLEGmnqqur0mGdLww8qHUlkwX0KXYyMkXjdH+UpeZy1jFvqJFSS4
         D1KB0LHC0AhPJwantedjFEOUB953NPIWiE57R6++uTqOJXroVPvSAeYeZApcJA8WFYnO
         Dta5mSPyNYM7i8rPB4fNETOZQWuAliaL/nbU6PuWsLpycaA6HxtY8mLt6UeI/3SJ4dzi
         LQ+JKyUlWuMSxFPW/0FT9xRAQGizZu1RG/p3X7AzHd7VHc0czbSRAXfCMDYVKCsL33Db
         PcVQ==
X-Gm-Message-State: AOAM530IQ6RAO2Q8QUOJQg2Oj2ZyE69RQQrkKthKCBom6oKQfezbpEAd
        9gPE45kO5B4U0tRFxjSbeYdXDBoSiaSbcqVBtSlFNg==
X-Google-Smtp-Source: ABdhPJzlkFKmKNMzZS30KJjmaWJKGOg+VZfCnW52PNfjtWzIQLq1y7OZwuioLXRe/ssoxTIomnKsV7xS/xJcAu4SAEI=
X-Received: by 2002:a2e:b4ce:: with SMTP id r14mr319557ljm.76.1625156414497;
 Thu, 01 Jul 2021 09:20:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1625118581.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <cover.1625118581.git.christophe.jaillet@wanadoo.fr>
From:   Jeroen de Borst <jeroendb@google.com>
Date:   Thu, 1 Jul 2021 09:20:03 -0700
Message-ID: <CAErkTsQLP9_y-Am3MN-O4vZXe3cTKHfYMwkFk-9YWWPLAQM1cw@mail.gmail.com>
Subject: Re: [PATCH 0/3] gve: Fixes and clean-up
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     csully@google.com, sagis@google.com, jonolson@google.com,
        davem@davemloft.net, kuba@kernel.org, awogbemila@google.com,
        willemb@google.com, yangchun@google.com, bcf@google.com,
        kuozhao@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 10:58 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> This serie is part of the effort to axe the wrappers in
> include/linux/pci-dma-compat.h
>
> While looking at it, I spotted:
>   - a resource leak in an error handling path (patch 1)
>   - an error code that could be propagated. (patch 2)
>     This patch could be ignored. It's only goal is to be more consistent
>     with other drivers.
>
> These 2 paches are not related to the 'pci-dma-compat.h' stuff, which can
> be found in patch 3.
>
> Christophe JAILLET (3):
>   gve: Fix an error handling path in 'gve_probe()'
>   gve: Propagate error codes to caller
>   gve: Simplify code and axe the use of a deprecated API
>
>

Thanks for these patches.

Can split this into 2 patch series; one for net (with the first 2
patches) and one for net-next (with the cleanup one)?
Also the label in the first patch should probably read
'abort_with_gve_init' instead of 'abort_with_vge_init'.

Jeroen
