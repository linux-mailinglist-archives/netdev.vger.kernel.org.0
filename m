Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C154D270901
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 00:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgIRWpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 18:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgIRWpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 18:45:10 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2141CC0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 15:45:10 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u6so8730397iow.9
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 15:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wit7M5dIzA6NJeTaiSQtHghVhA8ZZAuimwa/Ev5juqU=;
        b=eoK9M1gbHhh3yVDbHXGfQx6yvyu5xTqEW8Qr20K1SLUO0zgN3VpiiU0fsOkJaVZnQh
         ccmPljDKAEGmgcWUIu1DXs0fHwYpUdKoju25xjfrvA4ls28ze21GlB9h08vcUOHNPMZy
         KvBuFs8F4eELrnooICR949kmzxqDydww6K2TpPPNUBNb3UYNiMx9EKEaQY2oC2HrFron
         LEGCgdbbJqix8+MlNg+qlugxXkc6aSt0zZuqx4MUEOYUH4bMBNsvOX65urKpEFAxihuq
         1yr1RIPlTWCKV9vqgOBNSF49GcGmatxAZh752i7bUILYWbYuvf7mLHJKHtGD1TYRpWq4
         UtmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wit7M5dIzA6NJeTaiSQtHghVhA8ZZAuimwa/Ev5juqU=;
        b=KdAPGA5vzw6KYZ+SNdWCX929PteD90Bnh8uHQ2sfjVX4hmGCSl65VFrCkWTQhn3rTN
         nxUPZJCgj3KtUmJGUUfEBp8RDgMgmTM13bxM4Tu5ExUArNeLMivy1TPYrD/eIz22SzJ1
         lUM4yvmkI4LbAEZ59y3Fo+ouzxSk4Mq/hF4yFN6IYYimRa0rVsxBZ38wfs0lYfPtxt9H
         2vkDBNG6MD1ve89UlEIOixxDnG8In6oohoLQ0uIaunG3ASmjjLGStsEMBv5a2SUb9Lxm
         yj9L1FfmJ1PM8GsaheoeMhZg1FS64a86sO6yvkFx/4XjZ0MA7Mb7amOIHZnoPrnvpfLO
         Ah7Q==
X-Gm-Message-State: AOAM5334McoOfpzOkyksiMor8NEqb4i4+29BJTr6qunANKLNFEEaECFs
        zWRVLzkE7WM1iAyaCFEdq/6QDBXqc2ohFniDsNqk0Q==
X-Google-Smtp-Source: ABdhPJzq7/obY88rtXJCZ0LuhDqhjfIXVaS7TGVUvmlwexMEEfxPp3pGzRohuCBhA/nwDzxUzuXvKeln6C5pcZZR+fg=
X-Received: by 2002:a5d:9842:: with SMTP id p2mr19975314ios.113.1600469108384;
 Fri, 18 Sep 2020 15:45:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com> <20200914172453.1833883-6-weiwan@google.com>
In-Reply-To: <20200914172453.1833883-6-weiwan@google.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 18 Sep 2020 15:44:57 -0700
Message-ID: <CAEA6p_BszGQafCo3NQG71dRNMTkh-fL2U9OMon2EALvFz=tSnw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 5/6] net: process RPS/RFS work in kthread context
To:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 10:26 AM Wei Wang <weiwan@google.com> wrote:
>
> From: Paolo Abeni <pabeni@redhat.com>
>
> This patch adds the missing part to handle RFS/RPS in the napi thread
> handler and makes sure RPS/RFS works properly when using kthread to do
> napi poll.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> ---

With some more thoughts, I think this patch is not needed. RPS/RFS
uses its own napi (sd->backlog) which currently does not have
NAPI_STATE_THREADED set. So it is still being handled in softirq
context by net_rx_action().
I will remove this patch in the next version if no one objects.


>  net/core/dev.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index be676c21bdc4..ab8af727058b 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6820,6 +6820,7 @@ static int napi_thread_wait(struct napi_struct *napi)
>  static int napi_threaded_poll(void *data)
>  {
>         struct napi_struct *napi = data;
> +       struct softnet_data *sd;
>         void *have;
>
>         while (!napi_thread_wait(napi)) {
> @@ -6835,6 +6836,12 @@ static int napi_threaded_poll(void *data)
>                         __kfree_skb_flush();
>                         local_bh_enable();
>
> +                       sd = this_cpu_ptr(&softnet_data);
> +                       if (sd_has_rps_ipi_waiting(sd)) {
> +                               local_irq_disable();
> +                               net_rps_action_and_irq_enable(sd);
> +                       }
> +
>                         if (!repoll)
>                                 break;
>
> --
> 2.28.0.618.gf4bc123cb7-goog
>
