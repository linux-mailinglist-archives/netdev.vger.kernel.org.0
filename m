Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1194CBF27
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 14:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiCCNwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 08:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiCCNwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 08:52:02 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44D61795DC
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 05:51:17 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id t28so4574365qtc.7
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 05:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ed/fJ9BtGGjVQRKHb9Y3nYI3u4W69M4qgJTD2Jx7kMI=;
        b=HJiaRPv8U5Z1KsM5KVcfVTJRV4K55lgwfMklAUhWIjd9RENhA2F6B3llzXNI2/QMQi
         fdQNIELw2uBRKtJYd0hwoCvVr+HehwoRo1OCOOXFXKvkdSZZt/Zf7YK8s92OyGxFPDUd
         MHf5jDsojEHumbF8JBeszPn6AwD1CZwLWkOpriRYzyk9PofgRevhRnAhng9Ih8Ftmgz2
         +kmIqB9s7ctYeSSPKCEmhkth18AWCxadeeabqhCzZVtUvi41t/XzU/5JiNuGS9SxmECo
         3miyA4S2kWjKNPzupqKSARMog2CioI8NEBsPv9WVxAQjtO/FsnoUg038/MzatZQEW6TU
         akSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ed/fJ9BtGGjVQRKHb9Y3nYI3u4W69M4qgJTD2Jx7kMI=;
        b=k2+OxW5EO0BVxmolXp32t2MIiETTSKfcBFZhYMy0Rg2ZI6YAi17LZadDdeQ3KGjt1w
         ZWqagmGhVZ/18x4vtfUEHgzlgAKfcLwb49SIG4DBptWfF7DBcdKEhVrU7sbZwcZv/fPy
         FEV2yRdbJ6LSkFnWP8lhHkMWBQR8DC2Jzk0KPHE5QllFKa8YeTPiWGJMYNj5EjcHKc8m
         Mti4Ye4L7MeGZSztC8hS47X+JcQJtSSJjkMoFKaFMQsnR8ZLW8jKsHT4pAkmMTw0ZS54
         VyKXmFwAWcm3yL3wBeacVrlpkJ2RctmaBs6zGKjDwLSEhcf0wcz2b8C48zH8uggbHQh3
         c8dg==
X-Gm-Message-State: AOAM5308lZP8IwAZB1ut1OiNjiyQGptVUT35Jiehk3jfPtX4IQGurGJ0
        z+igp2udNXYTCvakh4pPjP9rSqtmugmDzQXW/xvUlw==
X-Google-Smtp-Source: ABdhPJxMIYzDU9MchH4PSm1SS4F8hjgoJzQc9CAamWy1q4qx4pS6B3h+9QAQSO5RHs7A3uQ/4/L4vY9985Vtuh+kH58=
X-Received: by 2002:a05:622a:1e07:b0:2dd:d6fe:a40a with SMTP id
 br7-20020a05622a1e0700b002ddd6fea40amr27518011qtb.261.1646315476648; Thu, 03
 Mar 2022 05:51:16 -0800 (PST)
MIME-Version: 1.0
References: <55dcdba34b9d9fbd2a95257de7916560e1a6b7b1.1646308584.git.dcaratti@redhat.com>
In-Reply-To: <55dcdba34b9d9fbd2a95257de7916560e1a6b7b1.1646308584.git.dcaratti@redhat.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 3 Mar 2022 08:51:00 -0500
Message-ID: <CADVnQynp-N4HCsNDzCde6YK5iqK4xivQYxrec3HNyoxX5DNTaQ@mail.gmail.com>
Subject: Re: [PATCH iproute2-next] ss: display advertised TCP receive window
 and out-of-order counter
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Thomas Higdon <tph@fb.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 3, 2022 at 6:58 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> these members of TCP_INFO have been included in v5.4.
>
> tested with:
>  # ss -nti
>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  misc/ss.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/misc/ss.c b/misc/ss.c
> index f7d369142d93..d77b7f10dc43 100644
> --- a/misc/ss.c
> +++ b/misc/ss.c
> @@ -854,6 +854,8 @@ struct tcpstat {
>         unsigned int        reord_seen;
>         double              rcv_rtt;
>         double              min_rtt;
> +       unsigned int        rcv_ooopack;
> +       unsigned int        snd_wnd;
>         int                 rcv_space;
>         unsigned int        rcv_ssthresh;
>         unsigned long long  busy_time;
> @@ -2654,6 +2656,10 @@ static void tcp_stats_print(struct tcpstat *s)
>                 out(" notsent:%u", s->not_sent);
>         if (s->min_rtt)
>                 out(" minrtt:%g", s->min_rtt);
> +       if (s->rcv_ooopack)
> +               out(" rcv_oopack:%u", s->rcv_ooopack);

It seems there may be a typo where there is a missing 'o' in the
'rcv_oopack' field name that is printed?; probably this should be:

 +               out(" rcv_ooopack:%u", s->rcv_ooopack);

best,
neal
