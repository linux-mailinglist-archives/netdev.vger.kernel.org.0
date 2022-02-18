Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25F44BB290
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 07:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbiBRGhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 01:37:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbiBRGgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 01:36:48 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CAAB2B
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 22:36:25 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id e140so17615568ybh.9
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 22:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C9nxOjDYOcUUlRYYb+h/I1LAGqPW8cY7vTOl/wE2E24=;
        b=TT/KfuyvimxGdD1zCVPeB0c6dXHcw24t2yTR49Vt80rtBQpJZg0Mk0xctzsorroz0w
         7BaRre49kOLTAgiGR9B1oa8P3qOQ36U9QAiaJEKg5D7X9MHRQIxbX+SVbNtQIVWxRPh+
         53ogWhqR+OEX0O47BdvkgDumm7pwkrZ7QNMCXV5UW3a/41VseAlM0HMbR7Py1HBzq/XC
         2u71uu/r1M1MAHt83E3o8c3Uhz9LwRTBnHrGfAavu+G8fgWlifKfDGljHm6exzrD7zb2
         eD0MErXFS7AJFm5YVOuzlrehEp6VEAERaVemVwJ1SvfZ1N5NBviL1K0gGqLwskqiextZ
         4iyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C9nxOjDYOcUUlRYYb+h/I1LAGqPW8cY7vTOl/wE2E24=;
        b=3Ly0UuXHo10SSIqNPExCFP/aGNcmhpwWtUyV56+xI13hI63D37MVHNJcIomemWzwSY
         gnl4HUmD4o41SRgZfHwgksDfJgaiF7U5o3Uep6XZhNwsU+Rt/fggpOzW0ZDS/HqiE1ko
         htVVkpmgDbRW5BUP8YtcNZnwUTdvurAXmjo+bHN9gVoE5jF7u6yE2XpGeMnr19+CPGvp
         MwQVHWT0FH/7Tz70Op3QNh9faVm1b8VvyOQC9UxkkQLLXwbkk8oNURbCyVa+eJkYoUq7
         JOfMD89aEnPf4/vAVY4mZnGnRPDNaIicxOLW3OxVrG/91PvKCHYdGnwg01JXjFZsnghA
         m6Lg==
X-Gm-Message-State: AOAM533F+1pgw3sWz2ykL968y5aTZRWLICS/bPh/esgZWjZBbQ7/IyLI
        HKvXVzIgq/T0hsCg9M4ppC87uYFmy2RzsnG1QY66wqX/EQwDavUDhdo=
X-Google-Smtp-Source: ABdhPJyoi7mSskdB+ou9qjMiFd8qNRS4ev0XsqEl6YCnt+ao3q6xYA8TYV7g93IegGwP4cjvGa63lETnUJSQbdPxIog=
X-Received: by 2002:a25:f441:0:b0:611:4f60:aab1 with SMTP id
 p1-20020a25f441000000b006114f60aab1mr6115467ybe.598.1645166183925; Thu, 17
 Feb 2022 22:36:23 -0800 (PST)
MIME-Version: 1.0
References: <20220215225310.3679266-1-kuba@kernel.org> <20220215225310.3679266-2-kuba@kernel.org>
In-Reply-To: <20220215225310.3679266-2-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Feb 2022 22:36:12 -0800
Message-ID: <CANn89iLzQbsWh-pruEv2HO=+axpVR4KuGeo0GogzOTJL4ok7sg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: allow out-of-order netdev unregistration
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Xin Long <lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 2:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Sprinkle for each loops to allow netdevices to be unregistered
> out of order, as their refs are released.
>
> This prevents problems caused by dependencies between netdevs
> which want to release references in their ->priv_destructor.
> See commit d6ff94afd90b ("vlan: move dev_put into vlan_dev_uninit")
> for example.
>
> Eric has removed the only known ordering requirement in
> commit c002496babfd ("Merge branch 'ipv6-loopback'")
> so let's try this and see if anything explodes...
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/core/dev.c | 64 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 37 insertions(+), 27 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 2749776e2dd2..05fa867f1878 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9811,8 +9811,8 @@ int netdev_unregister_timeout_secs __read_mostly = 10;
>  #define WAIT_REFS_MIN_MSECS 1
>  #define WAIT_REFS_MAX_MSECS 250
>  /**
> - * netdev_wait_allrefs - wait until all references are gone.
> - * @dev: target net_device
> + * netdev_wait_allrefs_any - wait until all references are gone.
> + * @list: list of net_devices to wait on
>   *
>   * This is called when unregistering network devices.
>   *
> @@ -9822,37 +9822,45 @@ int netdev_unregister_timeout_secs __read_mostly = 10;
>   * We can get stuck here if buggy protocols don't correctly
>   * call dev_put.
>   */
> -static void netdev_wait_allrefs(struct net_device *dev)
> +static struct net_device *netdev_wait_allrefs_any(struct list_head *list)
>  {
>         unsigned long rebroadcast_time, warning_time;
> -       int wait = 0, refcnt;
> +       struct net_device *dev;
> +       int wait = 0;
>
> -       linkwatch_forget_dev(dev);


> +       list_for_each_entry(dev, list, todo_list)
> +               linkwatch_forget_dev(dev);

Jakub, this part of the code added quadratic behavior (and soft lockups)
when a large list of devices is dismantled at once,
because we call netdev_wait_allrefs_any() N times.

I will test this fix, unless I have missed something ?

diff --git a/net/core/dev.c b/net/core/dev.c
index 05fa867f18787e709dcaccfea1df350c424eff80..74e77f861e2c99127b0349aa0f8a4be412cc187e
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9828,9 +9828,6 @@ static struct net_device
*netdev_wait_allrefs_any(struct list_head *list)
        struct net_device *dev;
        int wait = 0;

-       list_for_each_entry(dev, list, todo_list)
-               linkwatch_forget_dev(dev);
-
        rebroadcast_time = warning_time = jiffies;

        list_for_each_entry(dev, list, todo_list)
@@ -9953,6 +9950,9 @@ void netdev_run_todo(void)
                dev->reg_state = NETREG_UNREGISTERED;
        }

+       list_for_each_entry(dev, &list, todo_list)
+               linkwatch_forget_dev(dev);
+
        while (!list_empty(&list)) {
                dev = netdev_wait_allrefs_any(&list);
                list_del(&dev->todo_list);
