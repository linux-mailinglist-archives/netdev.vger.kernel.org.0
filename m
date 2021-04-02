Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A461E35315D
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 00:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhDBWvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 18:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbhDBWvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 18:51:07 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592A5C061788
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 15:51:05 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id 2so2434694vsh.4
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 15:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GUO6eNuNOaxH9KjFmDuRE0Nu3fXuEsSQBh73oLOU+dw=;
        b=iaEKmsDp2u04ZP56vPNQAoGm98HAIy5ZLKrsW6xMbzryUO7HCd3JeVjU4+BU+Vdvy1
         atKVARlLmckk76x+fKg2EF+8tB0dqG4gKH0Pnxbr9BCWyKFJMQTsK6ZNdHF9/HyVrCo0
         3yGJOk2qgAnnILFCQXImYc59M9d9AQ0CQEAgv3YBrzhp3hB1uhOAa208c4+3amvOavt9
         ooDW4pwLC1a2gVf9B8h9ECpl/KzjxuUKjPQISIPaJhAJbdGiDjMVGp4B3BqJ/KaKKPfe
         E4XfqyzdV8/QMMWrBlsIfEnvvwSJi99ckzyXL6hCTj2OvGqjGAYF9UZTUdN4BpF+nJLu
         wXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GUO6eNuNOaxH9KjFmDuRE0Nu3fXuEsSQBh73oLOU+dw=;
        b=LJsYs9RyAOoqCvrNxaGdD8DqdV+kZGrJCLxio+NqkVZfRZKA2eEGTslC1n+va3y2iB
         Gj7Zd5wwEiOT2czD/IDLiiCM6WKtenbwYEPaendXqurroDIGrXPmVC5xAJnLM1kNwcnM
         bNRfvfobVj/8FtQ0XCrxddV/m70QW141ajJg6Zu1G4DneJ1EbORrlRSpyZFas9me+5fO
         1525pwYwQ+zrOpBDLcxXXhYo4zQ6eXGSrNxakpxD0YZUVyQ+6w7vrp54uPfd2Wzxl6ZC
         dpRHHYsrpoyd9PLZvw/QoOYw52MG4a+rhHtl652kBL7/qqOZxz7NrQehVvq1ITl3XItf
         ofmQ==
X-Gm-Message-State: AOAM530d6PZG0Y2rVQeNRQ899lvImJOdvxo98R0seLXdxlHYksNaGVud
        UFUP0kJfjy7ndSX9LpF4+eJY2kOFYrzm+jh6ocKpWA==
X-Google-Smtp-Source: ABdhPJwcA/lo/UwwGMwuW3K4Uho/14c6H+v26M+FHUmGqEgVkc/BKAnToW+M+WsAhRBjg+mkIgdTVuau29DgPzA8DeI=
X-Received: by 2002:a67:7282:: with SMTP id n124mr10271737vsc.39.1617403864187;
 Fri, 02 Apr 2021 15:51:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210402201156.2789453-1-zenczykowski@gmail.com> <20210402214049.GL13699@breakpoint.cc>
In-Reply-To: <20210402214049.GL13699@breakpoint.cc>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Fri, 2 Apr 2021 15:50:52 -0700
Message-ID: <CANP3RGcB4SvNFjsHEhH20dP+hNTQ6GE9ZgpWVyPeFv7fgbJHog@mail.gmail.com>
Subject: Re: [PATCH netfilter] netfilter: xt_IDLETIMER: fix
 idletimer_tg_helper non-kosher casts
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The code is relying on the identical layout of the beginning
> > of the v0 and v1 structs, but this can easily lead to code bugs
> > if one were to try to extend this further...
>
> What is the concern?  These structs are part of ABI, they
> cannot be changed.

That is a reasonable point, but there should have at *least* been
a solid comment about why this sort of cast is safe.
