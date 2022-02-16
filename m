Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A3B4B7F1E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 05:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245639AbiBPEMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 23:12:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238867AbiBPEMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 23:12:32 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1899769CF2
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:12:21 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id x193so1284117oix.0
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UvRpLTGct0NdbaUVtSyyHlO52TBHSPzEujlABlyt2B8=;
        b=Oo2O2m1wHKZWKstBTtkX6hzSuGredBFajyZPIXu1F2XoyGvudRLpzyPKA5CHs3tsgJ
         sCPbsD2lYyddGkWaCQ/TaHLxg2glCvCEjpci8P3VvGAF97lx2RanWjoTD1LYYueDGZCf
         anXpsba0q5F3K5U06uNlFdERZM6CRrhw+zNpS/ewWC2Xf4EpDcCUYpE9iGpfWkqv2Msq
         Vlh0+Qa7meKK+Sju7XhQwgmpjuz+ezvmiEWbmLUSpYfxnm2qtXXhAoq8hJnyKzhl1/BT
         HGXLwzHxoD0R9ZgicdS8WV7ifoMKDcJozrXuyfDw0j7bV4p5zR9dCMNiqGkLx57uBb7Z
         MKrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UvRpLTGct0NdbaUVtSyyHlO52TBHSPzEujlABlyt2B8=;
        b=Y9BY5FTXB9ybj3gYnhsJ5ggSjy62+oDSoVfMlqqIEl60yJOC1qla3O4w9wRBJwL8Pm
         eeqW7DoSWnhBCGcpfb0HrKN5Wd/CjTNQ6XaxmWxmpnFON+vBLSZ1dpF0sb7Z+WJd7IAy
         vKFXX20UK5IXD4hksPk6xPaJf6HR4K8IBbJJ4GabPCZNdC6C0U4YSSyABGStP84m9zk2
         SQQv6beuihkGDngFV7HRV0E08beGEv+CgfzmC9ppL6mlJz3bIjILyAlXphSUDrRpqKiT
         wmTfxZWeCSVH4i9KS8wV44MLk4crU1P42hmSWWImv82H6y1+OQ7bq1JgN0obIjH67gyZ
         /nRg==
X-Gm-Message-State: AOAM533+3pAKoLjUhC3ZtxbmOjqrO0dmMHfXaZlBsnN3dLKDh/9GWFhH
        5IV9AGRkXKd4KurozcjtqlEc4oooctU/XxMu3yo=
X-Google-Smtp-Source: ABdhPJwUOsYaH8ZGtBg9pywEKVKif0S6KphFEoJJjn/t00MAUUI7AapHEwSb+v3d9+QGcuCc/08yI4H0AlK7/RtQMn0=
X-Received: by 2002:aca:5b8a:0:b0:2ce:6ee7:2d0c with SMTP id
 p132-20020aca5b8a000000b002ce6ee72d0cmr3070322oib.314.1644984740411; Tue, 15
 Feb 2022 20:12:20 -0800 (PST)
MIME-Version: 1.0
References: <20220215225310.3679266-1-kuba@kernel.org>
In-Reply-To: <20220215225310.3679266-1-kuba@kernel.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 16 Feb 2022 12:12:09 +0800
Message-ID: <CADvbK_f8SWMxdrGSFo7=9BQMNrbB3nXqGhGv4LKa6v0keiTdsQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: transition netdev reg state earlier in run_todo
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem <davem@davemloft.net>, network dev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 6:53 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> In prep for unregistering netdevs out of order move the netdev
> state validation and change outside of the loop.
>
> While at it modernize this code and use WARN() instead of
> pr_err() + dump_stack().
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/core/dev.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 909fb3815910..2749776e2dd2 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9906,6 +9906,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
>   */
>  void netdev_run_todo(void)
>  {
> +       struct net_device *dev, *tmp;
>         struct list_head list;
>  #ifdef CONFIG_LOCKDEP
>         struct list_head unlink_list;
> @@ -9926,24 +9927,23 @@ void netdev_run_todo(void)
>
>         __rtnl_unlock();
>
> -
>         /* Wait for rcu callbacks to finish before next phase */
>         if (!list_empty(&list))
>                 rcu_barrier();
>
> -       while (!list_empty(&list)) {
> -               struct net_device *dev
> -                       = list_first_entry(&list, struct net_device, todo_list);
> -               list_del(&dev->todo_list);
> -
> +       list_for_each_entry_safe(dev, tmp, &list, todo_list) {
>                 if (unlikely(dev->reg_state != NETREG_UNREGISTERING)) {
> -                       pr_err("network todo '%s' but state %d\n",
> -                              dev->name, dev->reg_state);
> -                       dump_stack();
> +                       netdev_WARN(dev, "run_todo but not unregistering\n");
> +                       list_del(&dev->todo_list);
>                         continue;
>                 }
>
>                 dev->reg_state = NETREG_UNREGISTERED;
> +       }
> +
> +       while (!list_empty(&list)) {
> +               dev = list_first_entry(&list, struct net_device, todo_list);
> +               list_del(&dev->todo_list);
>
>                 netdev_wait_allrefs(dev);
>
> --
> 2.34.1
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
