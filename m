Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2973AFD34
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhFVGsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhFVGsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:48:30 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EC8C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 23:46:14 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id u190so12427167pgd.8
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 23:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ww3Waou+pC2NMUvYfDsWNc1HcsOU3BxvYmWu+PawfI=;
        b=QGrOC9SS30kE9f7h+EgOhrMNL7L4sw4ioIkYCMKr9VsOwe4NA91ILzMKjV6BpL801/
         gtl7fH+lVE4N74G2V7qgeFC4zzstbomtIvayku5nhkibrJf77CLd5TPa9779dAxtwRU0
         /oytIqECBsSbTs/07xIgmXtnryjFhJOwMpNznf//r/XVux6YlCrYMAajp+bJ51753xE6
         Ldwb5TY/1A1lrUCCyb3xfQIyKwf0zRFxIwlXntBdeLKv75+IJq3AWfnU58wQwi8ZCLO6
         ON7+jJ9RR/qAqR07BLLDC46SydIbaaRYxxp/idIYtK6FRnKG5Cng5U1pGRZS2F/UR5tQ
         kt4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ww3Waou+pC2NMUvYfDsWNc1HcsOU3BxvYmWu+PawfI=;
        b=rELhMbG442EBuLCNq3MvlaogXUfv97wGQewvwuizBcottqEwt65Bw6RcR+Wk3nPBnc
         /vwOr8zMdwrwwj+vsRFbtxwgu4uWwC8ACxxyTNeitrZ7PVPNcJWenq2MuHpBMsC3kNNk
         rXepKTY8/8LSrx6wEagPgLakijHGiDMaD+tv7XMDG/40KkX5BPqF60Bf6qbM5VCeQiiU
         v8Lu+qMG4F7YqjucsrYWppCeK2Uv2MfKbT2cknvtmxWZ/lbKHnYsVkgFglePPCPEUh93
         TW12BeErF00KezsG3SJ/rhUnt1k2ILB08ZxibXowwh5lD5uc+O136tdZKo6j38YBjiWM
         RPsA==
X-Gm-Message-State: AOAM531jqaCl+UrzzKgh4rVd/GRnEIjfo1rua9fpVeY8TayzpdTHcNnI
        8m/p3EV9q/67tEowmma8/h02lEENFZc9KTKvtOeM/A==
X-Google-Smtp-Source: ABdhPJwCJ6sNVy7yBWShdB/qNIg+FfipaO0lJVV8eo3BU5saxX/Wt6UkNT1kbSsw+1D46Cue3GWqTaQjOvp8YbuIcks=
X-Received: by 2002:a63:4a18:: with SMTP id x24mr2289805pga.303.1624344374121;
 Mon, 21 Jun 2021 23:46:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210622003210.22765-1-ryazanov.s.a@gmail.com> <20210622003210.22765-2-ryazanov.s.a@gmail.com>
In-Reply-To: <20210622003210.22765-2-ryazanov.s.a@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 22 Jun 2021 08:55:07 +0200
Message-ID: <CAMZdPi9h+EzmCtn9nKE73cKZMWTP0tLLpawxiyTbVVGacHj_iw@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 1/2] iplink: add support for parent device
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On Tue, 22 Jun 2021 at 02:32, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> Add support for specifying a parent device (struct device) by its name
> during the link creation and printing parent name in the links list.
> This option will be used to create WWAN links and possibly by other
> device classes that do not have a "natural parent netdev".
>
> Add the parent device bus name printing for links list info
> completeness. But do not add a corresponding command line argument, as
> we do not have a use case for this attribute.
>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> ---
>  ip/ipaddress.c | 14 ++++++++++++++
>  ip/iplink.c    |  6 +++++-
>  2 files changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index 06ca7273..7dc38ff1 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -1242,6 +1242,20 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
>                                                    RTA_PAYLOAD(tb[IFLA_PHYS_SWITCH_ID]),
>                                                    b1, sizeof(b1)));
>                 }
> +
> +               if (tb[IFLA_PARENT_DEV_BUS_NAME]) {
> +                       print_string(PRINT_ANY,
> +                                    "parentdevbus",

Parav suggested previously to simply name it 'parentbus'.

> +                                    "parentdevbus %s ",
> +                                    rta_getattr_str(tb[IFLA_PARENT_DEV_BUS_NAME]));
> +               }
> +
> +               if (tb[IFLA_PARENT_DEV_NAME]) {
> +                       print_string(PRINT_ANY,
> +                                    "parentdev",
> +                                    "parentdev %s ",
> +                                    rta_getattr_str(tb[IFLA_PARENT_DEV_NAME]));
> +               }
>         }
>
