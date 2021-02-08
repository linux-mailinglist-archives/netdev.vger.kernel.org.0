Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D63314108
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbhBHUzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235288AbhBHUxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:53:42 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A538C061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 12:53:02 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id j5so16440148iog.11
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 12:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cZlObvy/wAs3PyPLWI8dkVqjALBZfuLMkznZ5sFy7G4=;
        b=uaitq7ubLkI+qvtnyH/KGLlWVT9CNaWnvKuHb0hopJpYgnVTndVqaVXyfj+NP2a1Sv
         4tfPXMu+6bHJZEdNfHxQw82EHKKsqfVPgbTq8g3LjrgoDCWEEBbN7opP0+lhO4azdpz8
         2WFxJpmWNhKbsjxijvifHY7mrprMLu6KOnNeehqw0vJtwl7MWnoAYwVuusBtb5fD0yet
         P0M4uEjKXm6YgTWxWToDLcbZweQG4Tvanxu4ntRzLmGKfaDeiRYEWU28z9XGyc8T5Udh
         KILlwDYVB181qYoYaUZBjTA1uD7x+w3FMa5bZumj56bTZgWgDgw3gbhCyJrCJQlwzg8W
         sUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cZlObvy/wAs3PyPLWI8dkVqjALBZfuLMkznZ5sFy7G4=;
        b=iG0YETi89alSAdmVxPWfVZMqfHZCWT5LT7eVxnNO/hGlcLPcKPYsZE5dH7S+Hn39M8
         TapFANhXbJ8arc/is8gh5XxyZ7Z5OGsVfyS8IRJsuiShnJ+Y3Y7nE6HL9Aq3tdlMnvbl
         pBFE6L19fN+oIH2mHfeQOTV0ozX7hqM++S3Vk+ivX4vW1n6Zwx4tJPUrLApPJ8s/jPnS
         0DexRoPPvKPssq0hHEpDVU6B79V32qAu8UwfZyY6cneNcVZj67Af5TUntg1Ikw9j8QQA
         tBb6E9PoJp1PFUy0JOfxJ9An2mq671MYgoBgAn5Wlxf6XFnLuK6Pci2QBFKzGq5zyUHu
         VEhg==
X-Gm-Message-State: AOAM532f7AYg71Qa3ST88mA+LoZ0xzWe03CV35rbc7sp/l2Zd5uXfJoj
        Wz/6D84EwN4l2pQiyeEOT8MHD7R8sPCSnb65gbX+b5+kcfJT3Q==
X-Google-Smtp-Source: ABdhPJzXTGuEIfOWvwMuVWIOcT+myZXZ8dYGYMXWLjutSZeexEAipxKgRj/qc246s3oRXBy26k8cTsHxv/9om1w1B5s=
X-Received: by 2002:a6b:f904:: with SMTP id j4mr17059115iog.138.1612817580768;
 Mon, 08 Feb 2021 12:53:00 -0800 (PST)
MIME-Version: 1.0
References: <20210208193410.3859094-1-weiwan@google.com> <20210208193410.3859094-4-weiwan@google.com>
In-Reply-To: <20210208193410.3859094-4-weiwan@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 8 Feb 2021 12:52:49 -0800
Message-ID: <CAKgT0Uch5SzBZrqnyADQegFM5EAUzcidAuA_WTTZbcAmKn1X1w@mail.gmail.com>
Subject: Re: [PATCH net-next v11 3/3] net: add sysfs attribute to control napi
 threaded mode
To:     Wei Wang <weiwan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 11:38 AM Wei Wang <weiwan@google.com> wrote:
>
> This patch adds a new sysfs attribute to the network device class.
> Said attribute provides a per-device control to enable/disable the
> threaded mode for all the napi instances of the given network device,
> without the need for a device up/down.
> User sets it to 1 or 0 to enable or disable threaded mode.
> Note: when switching between threaded and the current softirq based mode
> for a napi instance, it will not immediately take effect if the napi is
> currently being polled. The mode switch will happen for the next time
> napi_schedule() is called.
>
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Co-developed-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Wei Wang <weiwan@google.com>
> ---
>  Documentation/ABI/testing/sysfs-class-net | 15 +++++++
>  include/linux/netdevice.h                 |  2 +
>  net/core/dev.c                            | 48 ++++++++++++++++++++++-
>  net/core/net-sysfs.c                      | 40 +++++++++++++++++++
>  4 files changed, 103 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/ABI/testing/sysfs-class-net
> index 1f2002df5ba2..1419103d11f9 100644
> --- a/Documentation/ABI/testing/sysfs-class-net
> +++ b/Documentation/ABI/testing/sysfs-class-net
> @@ -337,3 +337,18 @@ Contact:   netdev@vger.kernel.org
>  Description:
>                 32-bit unsigned integer counting the number of times the link has
>                 been down
> +
> +What:          /sys/class/net/<iface>/threaded
> +Date:          Jan 2021
> +KernelVersion: 5.12
> +Contact:       netdev@vger.kernel.org
> +Description:
> +               Boolean value to control the threaded mode per device. User could
> +               set this value to enable/disable threaded mode for all napi
> +               belonging to this device, without the need to do device up/down.
> +
> +               Possible values:
> +               == ==================================
> +               0  threaded mode disabled for this dev
> +               1  threaded mode enabled for this dev
> +               == ==================================
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 99fb4ec9573e..1340327f7abf 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -497,6 +497,8 @@ static inline bool napi_complete(struct napi_struct *n)
>         return napi_complete_done(n, 0);
>  }
>
> +int dev_set_threaded(struct net_device *dev, bool threaded);
> +
>  /**
>   *     napi_disable - prevent NAPI from scheduling
>   *     @n: NAPI context
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1e35f4f44f3b..7647278e46f0 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4291,8 +4291,9 @@ static inline void ____napi_schedule(struct softnet_data *sd,
>
>         if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
>                 /* Paired with smp_mb__before_atomic() in
> -                * napi_enable(). Use READ_ONCE() to guarantee
> -                * a complete read on napi->thread. Only call
> +                * napi_enable()/dev_set_threaded().
> +                * Use READ_ONCE() to guarantee a complete
> +                * read on napi->thread. Only call
>                  * wake_up_process() when it's not NULL.
>                  */
>                 thread = READ_ONCE(napi->thread);
> @@ -6738,6 +6739,49 @@ static void init_gro_hash(struct napi_struct *napi)
>         napi->gro_bitmask = 0;
>  }
>
> +int dev_set_threaded(struct net_device *dev, bool threaded)
> +{
> +       struct napi_struct *napi;
> +       int err = 0;
> +
> +       if (dev->threaded == threaded)
> +               return 0;
> +
> +       if (threaded) {
> +               list_for_each_entry(napi, &dev->napi_list, dev_list) {
> +                       if (!napi->thread) {
> +                               err = napi_kthread_create(napi);
> +                               if (err) {
> +                                       threaded = false;
> +                                       break;
> +                               }
> +                       }
> +               }
> +       }
> +

So one idea on how to reduce the number of indents and braces would be
to look at pulling the threaded check into the loop. So something
like:

    list_for_each_entry(napi, &dev->napi_list, dev_list) {
        if (!threaded || napi->thread)
            continue;

        err = napi_kthread_create(napi);
        if (err)
            threaded = false;
    }

Anyway it is just a suggestion for improvement since it is
functionally the same as the code above but greatly reduces the
indentation. I am okay with the code as is as well, it just seemed
like a lot of braces on the end there.

> +       dev->threaded = threaded;
> +
> +       /* Make sure kthread is created before THREADED bit
> +        * is set.
> +        */
> +       smp_mb__before_atomic();
> +
> +       /* Setting/unsetting threaded mode on a napi might not immediately
> +        * take effect, if the current napi instance is actively being
> +        * polled. In this case, the switch between threaded mode and
> +        * softirq mode will happen in the next round of napi_schedule().
> +        * This should not cause hiccups/stalls to the live traffic.
> +        */
> +       list_for_each_entry(napi, &dev->napi_list, dev_list) {
> +               if (threaded)
> +                       set_bit(NAPI_STATE_THREADED, &napi->state);
> +               else
> +                       clear_bit(NAPI_STATE_THREADED, &napi->state);
> +       }
> +
> +       return err;
> +}
> +
>  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>                     int (*poll)(struct napi_struct *, int), int weight)
>  {
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index daf502c13d6d..e72d474c2623 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -538,6 +538,45 @@ static ssize_t phys_switch_id_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(phys_switch_id);
>
> +static ssize_t threaded_show(struct device *dev,
> +                            struct device_attribute *attr, char *buf)
> +{
> +       struct net_device *netdev = to_net_dev(dev);
> +       ssize_t ret = -EINVAL;
> +
> +       if (!rtnl_trylock())
> +               return restart_syscall();
> +
> +       if (dev_isalive(netdev))
> +               ret = sprintf(buf, fmt_dec, netdev->threaded);
> +
> +       rtnl_unlock();
> +       return ret;
> +}
> +
> +static int modify_napi_threaded(struct net_device *dev, unsigned long val)
> +{
> +       int ret;
> +
> +       if (list_empty(&dev->napi_list))
> +               return -EOPNOTSUPP;
> +
> +       if (val != 0 && val != 1)
> +               return -EOPNOTSUPP;
> +
> +       ret = dev_set_threaded(dev, val);
> +
> +       return ret;
> +}
> +
> +static ssize_t threaded_store(struct device *dev,
> +                             struct device_attribute *attr,
> +                             const char *buf, size_t len)
> +{
> +       return netdev_store(dev, attr, buf, len, modify_napi_threaded);
> +}
> +static DEVICE_ATTR_RW(threaded);
> +
>  static struct attribute *net_class_attrs[] __ro_after_init = {
>         &dev_attr_netdev_group.attr,
>         &dev_attr_type.attr,
> @@ -570,6 +609,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
>         &dev_attr_proto_down.attr,
>         &dev_attr_carrier_up_count.attr,
>         &dev_attr_carrier_down_count.attr,
> +       &dev_attr_threaded.attr,
>         NULL,
>  };
>  ATTRIBUTE_GROUPS(net_class);

Other than the style nit I mentioned above the code looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
