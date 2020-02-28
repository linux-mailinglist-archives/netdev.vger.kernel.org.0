Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A0E173F9C
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 19:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgB1Sa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 13:30:29 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38820 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725730AbgB1Sa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 13:30:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582914628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9SQXHw9XzSbeXpj41JHDbfEF82zI7AsxsM9UfBTDMG8=;
        b=ZxGDOaonvUnlR2sxu+XPjuJroKIZvKPgdUmplu5HKVowxPfqwihsGPyMYtOgBf7vNabaqQ
        yuoo/K0LcGtmhCvHVx5O5RQA/0Oy9zOz1jy2Y+9ZJfAki5g0UczPmy9kOAIuzRnVyQzAEt
        gyaR5o2aIcTZTivIBcLUqeoBI9259o8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-R3XtDy2tNt-cXtQRKsQMMQ-1; Fri, 28 Feb 2020 13:30:25 -0500
X-MC-Unique: R3XtDy2tNt-cXtQRKsQMMQ-1
Received: by mail-ed1-f72.google.com with SMTP id k6so2904918edq.8
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 10:30:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9SQXHw9XzSbeXpj41JHDbfEF82zI7AsxsM9UfBTDMG8=;
        b=T7wrF9pjj6gCMbu9HIkJFbj8D3rK2DNP0xwM8OIbFuMvmKoRXLu83YJFUztPttd1Nw
         qYCz+ee+G8gsU9YkCK2P3lYlQ4MVwYgxofR4Oygizw7Q5RSxzepwMLfD0t5JM5qA9VDn
         Kn6zTuBpJ2Twv85zJc0OInJdaJPvojLziEf7u2rsawHA0QryHjHiGDQfrt3YHH4qBJ2Q
         p93jz/vfWt0u6V/x2M6kuat6iU42D0Lt2/VTD0P7DMotRlUS94Ru24Umew5fiwnx8H5f
         tDzUsWsoNDojHps6Zpll1d2vkdZQyelkddxuuR92FwXCdeWSGgkzKLEzmY+2GHi0D/sm
         54Cg==
X-Gm-Message-State: APjAAAX/lj3UygbmZP3GXN8bLJJFRk4xvybSJ4gFYSPnC3O/x6ePZyso
        M7J+jUSrk+1adbu/iUFGTajj0GuHXhb9eZhwPcpfS+7m6NRR0qCY3bI0pqxghlfkivuUcoTGSlY
        5acRD0VTh601rJNNSXkaqUlED8DUiJYA6
X-Received: by 2002:a17:906:5210:: with SMTP id g16mr5235507ejm.305.1582914623693;
        Fri, 28 Feb 2020 10:30:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqy2k0kyziTCuXtDsDmQRSPPZDTNCJcyd4zumdXYHZ3UQPHdHXIdNaH5hE2OpUdMwUlMZCM50jFSmW/FScjamn0=
X-Received: by 2002:a17:906:5210:: with SMTP id g16mr5235484ejm.305.1582914623404;
 Fri, 28 Feb 2020 10:30:23 -0800 (PST)
MIME-Version: 1.0
References: <20200225131213.2709230-1-sharpd@cumulusnetworks.com>
In-Reply-To: <20200225131213.2709230-1-sharpd@cumulusnetworks.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Fri, 28 Feb 2020 19:30:12 +0100
Message-ID: <CAPpH65z3GZgdHGiTJt+UZzBS94V0NN17VQFgDanNmoSdF7-_3Q@mail.gmail.com>
Subject: Re: [PATCH] ip route: Do not imply pref and ttl-propagate are per nexthop
To:     Donald Sharp <sharpd@cumulusnetworks.com>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>, roopa@cumulusnetworks.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 2:12 PM Donald Sharp <sharpd@cumulusnetworks.com> wrote:
>
> Currently `ip -6 route show` gives us this output:
>
> sharpd@eva ~/i/ip (master)> ip -6 route show
> ::1 dev lo proto kernel metric 256 pref medium
> 4:5::6:7 nhid 18 proto static metric 20
>         nexthop via fe80::99 dev enp39s0 weight 1
>         nexthop via fe80::44 dev enp39s0 weight 1 pref medium
>
> Displaying `pref medium` as the last bit of output implies
> that the RTA_PREF is a per nexthop value, when it is infact
> a per route piece of data.
>
> Change the output to display RTA_PREF and RTA_TTL_PROPAGATE
> before the RTA_MULTIPATH data is shown:
>
> sharpd@eva ~/i/ip (master)> ./ip -6 route show
> ::1 dev lo proto kernel metric 256 pref medium
> 4:5::6:7 nhid 18 proto static metric 20 pref medium
>         nexthop via fe80::99 dev enp39s0 weight 1
>         nexthop via fe80::44 dev enp39s0 weight 1
>
> Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
> ---
>  ip/iproute.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/ip/iproute.c b/ip/iproute.c
> index 93b805c9..07c45169 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -933,9 +933,6 @@ int print_route(struct nlmsghdr *n, void *arg)
>         if (tb[RTA_IIF] && filter.iifmask != -1)
>                 print_rta_if(fp, tb[RTA_IIF], "iif");
>
> -       if (tb[RTA_MULTIPATH])
> -               print_rta_multipath(fp, r, tb[RTA_MULTIPATH]);
> -
>         if (tb[RTA_PREF])
>                 print_rt_pref(fp, rta_getattr_u8(tb[RTA_PREF]));
>
> @@ -951,6 +948,14 @@ int print_route(struct nlmsghdr *n, void *arg)
>                                      propagate ? "enabled" : "disabled");
>         }
>
> +       if (tb[RTA_MULTIPATH])
> +               print_rta_multipath(fp, r, tb[RTA_MULTIPATH]);
> +
> +       /* If you are adding new route RTA_XXXX then place it above
> +        * the RTA_MULTIPATH else it will appear that the last nexthop
> +        * in the ECMP has new attributes
> +        */
> +
>         print_string(PRINT_FP, NULL, "\n", NULL);
>         close_json_object();
>         fflush(fp);
> --
> 2.25.0
>

LGTM. Can you please add:
Fixes: f48e14880a0e5 ("iproute: refactor multipath print")

Reviewed-by: Andrea Claudi <aclaudi@redhat.com>

