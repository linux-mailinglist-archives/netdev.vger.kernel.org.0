Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BC12B2447
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgKMTJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgKMTJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 14:09:37 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD73BC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 11:09:37 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id e17so9423009ili.5
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 11:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d0NavSiOy++Znad9kyuzkk4+fep/og/SqkjxI+C4r7w=;
        b=CYKQiLcbEAD4vUvaAG5RGkg3Z8aqVvaCTV1KLgkZrnEVgmCjSShXOm5X22yuKglPjP
         lfIxUFPUBFbIL1Ok5DHJVz5oVCSUTQCD4/JkN++dVeP8YhItfBJDm78IANmkq1eJIdv+
         wc0957gm6VgCa5CumAeBr3EoTPCa7JQNOiL5Y7ON8B3IBZgbbNrgx/4ZYD1VFT/No4B7
         IGti2EZLB64YuK+Gg66vmBhEDJwNZkLREsQwkMsh8+fHj27toC3VzSykIUycA4YrOwkw
         m4Nqjf4iBEPLcL55ofurw2CY5NkC6YIV5uuuxskJCp46gB7RhjTErzgCunn/WrcnmrE4
         JShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d0NavSiOy++Znad9kyuzkk4+fep/og/SqkjxI+C4r7w=;
        b=a3KvR5ZdiLHRtNKnCioZqpRqAfj3GSNG9sul8ZwS7TuFgmjE7r4k6BjvMo1gTJjycV
         Gnu6XaJvDbsu4vkHT8OkC26NkMsCPDCo+UlchmwWnkGdXmuaWMEnMq0o/pSSfJ6a2Uj4
         S1+9inRszsabZCxL9pDeLGWkkXLnznVoZzH8fJgxIiIwaCfpf4m7bEKZy1wzS2LNzCVf
         /IujJy3m+DcnG8L2hTcil8gzK4+H5/ZPuPifmbc4blUHXlZfw8BMR96Lug46pahTPyRw
         mCOsf763dh3f0VoWvmrOqgq5wXcjGXdtdvQfVdK/NjHgTmM76HyumgoCGmwYXBMYmD33
         bXDA==
X-Gm-Message-State: AOAM531vNb23QXdLaqexQn5WOowDAc41YoMvVNNB5eNZgVEBxQ/Ab/d8
        4ZFIomuwGtTZBlsI00l+CR/nKcckvkRH0zvWtgB5WfoZDAw=
X-Google-Smtp-Source: ABdhPJzAzVIO8C6xY2Gv4rFhVyhycW/CSdVZZoQdibMqgjD+71M1Wd+LAZc1gqhmOZ5wlMCL/4pKAeeQyTacYaaQ484=
X-Received: by 2002:a92:ca86:: with SMTP id t6mr941244ilo.95.1605294577114;
 Fri, 13 Nov 2020 11:09:37 -0800 (PST)
MIME-Version: 1.0
References: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com>
In-Reply-To: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 13 Nov 2020 11:09:26 -0800
Message-ID: <CAKgT0UfrqzSv7DSsQby1jRZGNLYDHURLpK7qt8PFRpCEM=8+Dg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] sfc: further EF100 encap TSO features
To:     Edward Cree <ecree@solarflare.com>
Cc:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 7:19 AM Edward Cree <ecree@solarflare.com> wrote:
>
> This series adds support for GRE and GRE_CSUM TSO on EF100 NICs, as
>  well as improving the handling of UDP tunnel TSO.
>
> Edward Cree (3):
>   sfc: extend bitfield macros to 19 fields
>   sfc: correctly support non-partial GSO_UDP_TUNNEL_CSUM on EF100
>   sfc: support GRE TSO on EF100
>
>  drivers/net/ethernet/sfc/bitfield.h  | 26 +++++++++++++++++++++-----
>  drivers/net/ethernet/sfc/ef100_nic.c |  8 ++++++--
>  drivers/net/ethernet/sfc/ef100_tx.c  | 12 ++++++++++--
>  3 files changed, 37 insertions(+), 9 deletions(-)
>

The code itself is mostly solid. The only issue I see is a question I
have about if we really need to be defining so many of the
"EFX_POPULATE_..." macros in patch 1 as it seems a bit gratuitous and
could likely be replaced by just adding multiple dummy fields to a
single macro instead of defining multiple macros to get to the end
goal.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
