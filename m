Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF0D4B7F1F
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 05:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245680AbiBPENw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 23:13:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238867AbiBPENu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 23:13:50 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E02D70F43
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:13:39 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id f11-20020a4abb0b000000b002e9abf6bcbcso1201415oop.0
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b9iSS0HS+JanZnQgwVmWdtx4GwgEL4mj9cCvXNQw/xA=;
        b=kuMh9XD4HFGLU/Tu4PRT1v8cjTihPYHX//Wanj5yXFEdjZNHUR1Sw1jfYZg0rlVWri
         sVE5ACcXSY0IBvO5Dv/zdyx19ZiawbCDuz5u6xBN8dyS6ngylIdkbFL9y/JroIe7Aqmm
         g3L6E+aog3ExeYWeTxz4yf0cT1lany3T74mLcteU7BkVHvQJlMUTDHNxCWVM8ogpc3xd
         eSBft4cz1vAmifffsT7QVE5tcpkXF27uozd18YB9wYL3+Z0vIu/dDFeF6e0ogqX7egVt
         S0DWTjhnto5p6qlCk69ofTF8djr0qnu7WKFaZM13S4DRNsPMSCN5tZtMEw/flKRjamd5
         Od0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b9iSS0HS+JanZnQgwVmWdtx4GwgEL4mj9cCvXNQw/xA=;
        b=ZHhAY9YWoAhXwcGaIQxSn43Ce/vTjCJYryj+xHoPBTudE9VXOpgrZ3rP15Cl/D4D9X
         P/X0jIqLX+QpA+My4tNT113ZdwvhLmFsOQnhGLa31a2aBb/naolX7ObfOYG5Mhe+jFpS
         Yq8ftz0+y98ZIo2xbFal/VXvq97l4CKmfZzeaaLDjPIj0dnFkU2XPuWMr8/NiSpMMkdn
         LmvY2UrV1lFfed3KE9+uM/VfOZ8erL3P5sAk+shLUsX3h4rLDgi4MPBgL1nzhORZ5efr
         ddCxk0P5aOFIuhpFKKYwlTY9U10YiG6bDnYlZiDCfepxFH6yrzFkulURvRrNm4mqJr8i
         m+kw==
X-Gm-Message-State: AOAM530dfQywFRof0IpX1Lg0UK+RonMSsqAwapVKzPjGy2yJtHvP2QmB
        i/buS81ddt/TRCBJpCTvsw9wtky++AEfD+I73LQ=
X-Google-Smtp-Source: ABdhPJzOTe0074bTNyR7ZlLygIbYoq/IjQXRT8su7Y/unG+Fb39qv8viLIVKz8OuWozrb0jmtcLowgE8zESBHdE0Fqg=
X-Received: by 2002:a05:6870:560e:b0:b9:438b:2f13 with SMTP id
 m14-20020a056870560e00b000b9438b2f13mr377609oao.42.1644984818444; Tue, 15 Feb
 2022 20:13:38 -0800 (PST)
MIME-Version: 1.0
References: <20220215225310.3679266-1-kuba@kernel.org> <20220215225310.3679266-2-kuba@kernel.org>
In-Reply-To: <20220215225310.3679266-2-kuba@kernel.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 16 Feb 2022 12:13:27 +0800
Message-ID: <CADvbK_dS5Q9j8YF3inE5BULhcRwwmOTf8E+ahrukWBPEy_VsFw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: allow out-of-order netdev unregistration
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
>
>         rebroadcast_time = warning_time = jiffies;
> -       refcnt = netdev_refcnt_read(dev);
>
> -       while (refcnt != 1) {
> +       list_for_each_entry(dev, list, todo_list)
> +               if (netdev_refcnt_read(dev) == 1)
> +                       return dev;
> +
> +       while (true) {
>                 if (time_after(jiffies, rebroadcast_time + 1 * HZ)) {
>                         rtnl_lock();
>
>                         /* Rebroadcast unregister notification */
> -                       call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
> +                       list_for_each_entry(dev, list, todo_list)
> +                               call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
>
>                         __rtnl_unlock();
>                         rcu_barrier();
>                         rtnl_lock();
>
> -                       if (test_bit(__LINK_STATE_LINKWATCH_PENDING,
> -                                    &dev->state)) {
> -                               /* We must not have linkwatch events
> -                                * pending on unregister. If this
> -                                * happens, we simply run the queue
> -                                * unscheduled, resulting in a noop
> -                                * for this device.
> -                                */
> -                               linkwatch_run_queue();
> -                       }
> +                       list_for_each_entry(dev, list, todo_list)
> +                               if (test_bit(__LINK_STATE_LINKWATCH_PENDING,
> +                                            &dev->state)) {
> +                                       /* We must not have linkwatch events
> +                                        * pending on unregister. If this
> +                                        * happens, we simply run the queue
> +                                        * unscheduled, resulting in a noop
> +                                        * for this device.
> +                                        */
> +                                       linkwatch_run_queue();
> +                                       break;
> +                               }
>
>                         __rtnl_unlock();
>
> @@ -9867,14 +9875,18 @@ static void netdev_wait_allrefs(struct net_device *dev)
>                         wait = min(wait << 1, WAIT_REFS_MAX_MSECS);
>                 }
>
> -               refcnt = netdev_refcnt_read(dev);
> +               list_for_each_entry(dev, list, todo_list)
> +                       if (netdev_refcnt_read(dev) == 1)
> +                               return dev;
>
> -               if (refcnt != 1 &&
> -                   time_after(jiffies, warning_time +
> +               if (time_after(jiffies, warning_time +
>                                netdev_unregister_timeout_secs * HZ)) {
> -                       pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
> -                                dev->name, refcnt);
> -                       ref_tracker_dir_print(&dev->refcnt_tracker, 10);
> +                       list_for_each_entry(dev, list, todo_list) {
> +                               pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
> +                                        dev->name, netdev_refcnt_read(dev));
> +                               ref_tracker_dir_print(&dev->refcnt_tracker, 10);
> +                       }
> +
>                         warning_time = jiffies;
>                 }
>         }
> @@ -9942,11 +9954,9 @@ void netdev_run_todo(void)
>         }
>
>         while (!list_empty(&list)) {
> -               dev = list_first_entry(&list, struct net_device, todo_list);
> +               dev = netdev_wait_allrefs_any(&list);
>                 list_del(&dev->todo_list);
>
> -               netdev_wait_allrefs(dev);
> -
>                 /* paranoia */
>                 BUG_ON(netdev_refcnt_read(dev) != 1);
>                 BUG_ON(!list_empty(&dev->ptype_all));
> --
> 2.34.1
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>

Thanks for the fix, I will revert d6ff94afd90b once this gets applied.
