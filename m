Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164333D2BFA
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 20:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhGVRyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 13:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhGVRyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 13:54:36 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA985C061575;
        Thu, 22 Jul 2021 11:35:10 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 42-20020a9d012d0000b02904b98d90c82cso1403447otu.5;
        Thu, 22 Jul 2021 11:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/tXF0NstaY8AFZjhBvsERHkczc1GcinsV1wOmHpAfuc=;
        b=O1GRZu44CxtoPUcCeaJnb7IDJ4ltv7mPDBrnKKbVYj3jZXczhohbYNIeskBkJStL8u
         cO7DAjIlL9BxJWmkPN7tNOxl3343ClOD3Ou1Klhn/anvJeKxAOsce5RptZTVF8DIgIi8
         oPHyWCjZI2iS60lrhXKRA6UOqsZufppwO6OeRp8L6vsP14U0ql1DSVun+MZdIGA2orBp
         aXI/VLWuBM3FCWNRJI2OXFa57ELgYP1MEvKrpuSM6lzLg5CQcUEi1Kzr6wZ8Zt83VU7m
         +oHBm/UeDsX1OyKjGDV+Yh8MUd3jqrd5DF5V+3Q/Ev1907u1WbtZVfeLHxsSdUr7EHN+
         UhDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/tXF0NstaY8AFZjhBvsERHkczc1GcinsV1wOmHpAfuc=;
        b=GsdSiZAta6o8HKDnqrPpvRRjkpRYN4ROsNcA134bwC9kJSvFmSHeQxcIQhCwWV9bvj
         Ez6lwGu7Sjpzx4Bok5AfsAJ2nDm+XhOdjeZv3RKEAcCDQ1N8Oy9BKmoACbif41WniZDY
         QGdeNfi4E2I3UousdZl1M7X06DjMqTGk0K6pFQwZBcFUeWpse5kKWlcft6e3f5WbURNB
         95TtKlbnHaIYy1JnrST7c0ox3vKETUWZF+XE7fMARVBuMKEZH4lfwVrrQ6e7Nxsgz9Oh
         ndOGrb1DdTGNn5lTg941hkSzIYyIFHqchMknceMmjMahefhICDQwXqmPL8vPXQbDX+RY
         pTiQ==
X-Gm-Message-State: AOAM533oWmkws2z709M9CyxHGHQQ7geftvpkSSEbNNdIol/ACc4R5hCA
        mGSqvT/fAeUZsjvF4DRJytJEpvDe02uAl58VJ4I=
X-Google-Smtp-Source: ABdhPJxyLr5GLGM6mRAD/VRoPPUQ7PAHwsiJR0lnCGJNi2yDvtrNpOMslre7CSho7jLO3shXda1nVat4SsBAzfQsr2Y=
X-Received: by 2002:a9d:7c8d:: with SMTP id q13mr757918otn.181.1626978910223;
 Thu, 22 Jul 2021 11:35:10 -0700 (PDT)
MIME-Version: 1.0
References: <1626978065-5239-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1626978065-5239-1-git-send-email-loic.poulain@linaro.org>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 22 Jul 2021 21:35:19 +0300
Message-ID: <CAHNKnsQTqy5qUcjxfC6jKMjduX9AfYq75Ni=8jtNmNvvPob7qQ@mail.gmail.com>
Subject: Re: [PATCH] wwan: core: Fix missing RTM_NEWLINK event for default link
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 9:10 PM Loic Poulain <loic.poulain@linaro.org> wrote:
> A wwan link created via the wwan_create_default_link procedure is
> never notified to the user (RTM_NEWLINK), causing issues with user
> tools relying on such event to track network links (NetworkManager).
>
> This is because the procedure misses a call to rtnl_configure_link(),
> which sets the link as initialized and notifies the new link (cf
> proper usage in __rtnl_newlink()).
>
> Cc: stable@vger.kernel.org
> Fixes: ca374290aaad ("wwan: core: support default netdev creation")
> Suggested-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
