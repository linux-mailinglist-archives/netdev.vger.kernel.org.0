Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38FE21C501
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 18:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbgGKQFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 12:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgGKQFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 12:05:35 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24602C08C5DD;
        Sat, 11 Jul 2020 09:05:35 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id a12so9104818ion.13;
        Sat, 11 Jul 2020 09:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=65YCyA1YI+Gr1+43CKTnJEu+JZyhp13VqZJsMg2nBuI=;
        b=fhDW5kdD9pXOPD/B+USvK2+wWnVVf+obMu2wQnppXJ/5ywwxbh1+5XNrVT6v9FgxFW
         5EFEXDeuQORS5gdvKDtIr0owma5m999N5H5jL6WUmESxIB8QrSxyHOnlSPrbTYVDuwQG
         fwkSHjFPo2NZMDsdtk/+bDl7tOjpBr6NkT6wZcpYSu0fr/I0toSokF3JLWXM7whmPZC1
         tXu3FtQariw76vLZMS/bR7AYhPBMaRHOnAEzWNR4swEKMC/bIZPygQD+iJCy1vvrGazN
         A7QICmdz2J8gC4POofh/ySWMBXrSmXYFRe1nKsKiZC9KQHMP0ZtSXydtfqTn2owHzE3r
         4jGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=65YCyA1YI+Gr1+43CKTnJEu+JZyhp13VqZJsMg2nBuI=;
        b=ZS5p0YeulLAE9WSL6UHRKdMGp6+YYyqCABO8FfTyE+aYGVgizqgqw1XRRgJ9H1DPfw
         md5BTwsrjYLf6rYhdaD0doxdkNLGTDWSaYRpUo7Nq2oZF6dOvhNTGcOctGZCGP3LYf/Y
         ziXI8EGdoD1u3zol51P+AR4OZgRYaxvWood+0JP16kmv4pBXZoJ9awCu6XmQ7qamAqpJ
         NxkeRDOiSb8DyoARqkpPYRNjOSmVbP/64EA/czOmsToSOPI7GUWkm6HPNEFlX3xiKGxn
         IlFPw8kHMviL17S52crN/a/AuOznchLS8M2pbg40jFCrcdn1r2RSvJIHfu9+Za/J7fAr
         s3CA==
X-Gm-Message-State: AOAM5326rQxuebn7vSiwvejqf8+o20bUOswAoNISxts8JPMKK1OsP33f
        tpNbro9w3fG4+Hsj/Rh42cWHpdJ6qun+aQUa6PjbWE78
X-Google-Smtp-Source: ABdhPJyvDTGQjLFK/cSztSww7EeYhIKaum0hC9kH/THjcHn0501tkZ8c/safIES34hF8UYGpJJjchN2gvff3+7KPWk4=
X-Received: by 2002:a02:4083:: with SMTP id n125mr82623520jaa.83.1594483534388;
 Sat, 11 Jul 2020 09:05:34 -0700 (PDT)
MIME-Version: 1.0
References: <1594447781-27115-1-git-send-email-sridhar.samudrala@intel.com>
In-Reply-To: <1594447781-27115-1-git-send-email-sridhar.samudrala@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 11 Jul 2020 09:05:23 -0700
Message-ID: <CAKgT0Uf_5v-CEHx24ryawu2UCpFUTLeXkcvNnqnETbhzpoO42Q@mail.gmail.com>
Subject: Re: [PATCH v4] fs/epoll: Enable non-blocking busypoll when epoll
 timeout is 0
To:     Sridhar Samudrala <sridhar.samudrala@intel.com>
Cc:     linux-fsdevel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        andy.lavr@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 11:13 PM Sridhar Samudrala
<sridhar.samudrala@intel.com> wrote:
>
> This patch triggers non-blocking busy poll when busy_poll is enabled,
> epoll is called with a timeout of 0 and is associated with a napi_id.
> This enables an app thread to go through napi poll routine once by
> calling epoll with a 0 timeout.
>
> poll/select with a 0 timeout behave in a similar manner.
>
> Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
>
> v4:
> - Fix a typo (Andy)
> v3:
> - reset napi_id if no event available after busy poll (Alex)
> v2:
> - Added net_busy_loop_on() check (Eric)
> ---
>  fs/eventpoll.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 12eebcdea9c8..10da7a8e1c2b 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1847,6 +1847,22 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>                 eavail = ep_events_available(ep);
>                 write_unlock_irq(&ep->lock);
>
> +               /*
> +                * Trigger non-blocking busy poll if timeout is 0 and there are
> +                * no events available. Passing timed_out(1) to ep_busy_loop
> +                * will make sure that busy polling is triggered only once.
> +                */
> +               if (!eavail && net_busy_loop_on()) {
> +                       ep_busy_loop(ep, timed_out);
> +
> +                       write_lock_irq(&ep->lock);
> +                       eavail = ep_events_available(ep);
> +                       write_unlock_irq(&ep->lock);
> +
> +                       if (!eavail)
> +                               ep_reset_busy_poll_napi_id(ep);
> +               }
> +
>                 goto send_events;
>         }
>

This addresses the concern that I had.

Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
