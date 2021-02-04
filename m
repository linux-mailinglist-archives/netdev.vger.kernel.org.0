Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3198C30FFFD
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 23:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBDWRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 17:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhBDWRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 17:17:48 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57DFC0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 14:17:08 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id q9so4125003ilo.1
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 14:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X5fbf/l8UluUUBZ0i3YAUKZBSfKOcfopnYCUrXiSLPY=;
        b=WvA23By2ulVM8wqHv/SV2iVxj2Cfd63WotsN/BI0Hq3fc1UrYl8jEP5rjGOO1QNz4E
         /UqQEw/cG6/FN45gvodyPeZIjOvcpePE1QDDZqE1CxB4Mxbexau5GJz10cLVH5HLviJ4
         wb5pKtSVjPmHhPls8JPQuc/Adk99ceWHuK6PKkjULCdRbBK5g+rNspqjy1tzKSUSAb++
         ZaiS7zMU0ZlTtQlC7u0SCW0f1J3Yq5KbqAjE+vq1gS0xKK8fJa8DHBk4K8KCOrfb8gBf
         jGvagdkTeKGvOWgNPXwM2qdKKMMXqZJcorOPeVVD89Ock5LCSQFtSz/a1PJ7YiZXp7bv
         KyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X5fbf/l8UluUUBZ0i3YAUKZBSfKOcfopnYCUrXiSLPY=;
        b=ffWYBBEV5V8RFZ0GYzl9gwfczsHA+Ko1ucWDyB8aLnPLvFUpes+QoSjYKC7lA0WBti
         WFJtUm7xIQ+rgzHjsq2ZnwZb9RmjykV+Is844UThekbfDJk0ztiibsesHU6lUfSK9125
         OF2q7//uenCsRkH7d337zp6FUABSUVAHKYdrsXVz2PxmrSliRirapVQVubuoqdqt5Yqk
         T6Gt/sfpt66eOfqFYgpypHLhqrJ+I6bm3KeedblFCXOjvFrbCG68o92QnGGJabdqIOl2
         hdIVKHBGBkAtDK8DCmbF7gon60ZB7Pqos7dn1hpAJsLO+zvPbpcoi4XbuxNFy5GQ3WOS
         Y9aA==
X-Gm-Message-State: AOAM532pm+61ZVntyN5w8eZzI7qF2eivROPJhn44wm6pvGwpWIgKdrIQ
        4SkawDi4oS2sk8GtpUG8sTalVptpQnG0NYbzFXs=
X-Google-Smtp-Source: ABdhPJzGZ7kr345bmlcIGX+rUCPduHT4SI2PpO5BOBu5/0qyXHzFr3BGoFrP2do5XutgaeG42fYEYY8KQkbpZkmq5ro=
X-Received: by 2002:a05:6e02:c6:: with SMTP id r6mr1066357ilq.95.1612477027898;
 Thu, 04 Feb 2021 14:17:07 -0800 (PST)
MIME-Version: 1.0
References: <20210204213117.1736289-1-weiwan@google.com> <20210204213117.1736289-4-weiwan@google.com>
In-Reply-To: <20210204213117.1736289-4-weiwan@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 4 Feb 2021 14:16:56 -0800
Message-ID: <CAKgT0Uf1BrxWOp1LVs3Se-dLS0bJ5mYuoHiGon6TdRFCaGLs3w@mail.gmail.com>
Subject: Re: [PATCH net-next v10 3/3] net: add sysfs attribute to control napi
 threaded mode
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 1:35 PM Wei Wang <weiwan@google.com> wrote:
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
>  Documentation/ABI/testing/sysfs-class-net | 15 +++++
>  include/linux/netdevice.h                 |  2 +
>  net/core/dev.c                            | 67 ++++++++++++++++++++++-
>  net/core/net-sysfs.c                      | 45 +++++++++++++++
>  4 files changed, 127 insertions(+), 2 deletions(-)
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
> index a8c5eca17074..9cc9b245419e 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4290,8 +4290,9 @@ static inline void ____napi_schedule(struct softnet_data *sd,
>
>         if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
>                 /* Paired with smp_mb__before_atomic() in
> -                * napi_enable(). Use READ_ONCE() to guarantee
> -                * a complete read on napi->thread. Only call
> +                * napi_enable()/napi_set_threaded().
> +                * Use READ_ONCE() to guarantee a complete
> +                * read on napi->thread. Only call
>                  * wake_up_process() when it's not NULL.
>                  */
>                 thread = READ_ONCE(napi->thread);
> @@ -6743,6 +6744,68 @@ static void init_gro_hash(struct napi_struct *napi)
>         napi->gro_bitmask = 0;
>  }
>
> +/* Setting/unsetting threaded mode on a napi might not immediately
> + * take effect, if the current napi instance is actively being
> + * polled. In this case, the switch between threaded mode and
> + * softirq mode will happen in the next round of napi_schedule().
> + * This should not cause hiccups/stalls to the live traffic.
> + */
> +static int napi_set_threaded(struct napi_struct *n, bool threaded)
> +{
> +       int err = 0;
> +
> +       if (threaded == !!test_bit(NAPI_STATE_THREADED, &n->state))
> +               return 0;
> +
> +       if (!threaded) {
> +               clear_bit(NAPI_STATE_THREADED, &n->state);
> +               return 0;
> +       }


> +
> +       if (!n->thread) {
> +               err = napi_kthread_create(n);
> +               if (err)
> +                       return err;
> +       }

This piece needs to be broken out similar to what we did for the
napi_add and napi enable. In the case where we are enabling the
threaded NAPI you should first go through and allocate all the
threads. Then once all the threads are allocated you then enable them
by setting the NAPI_STATE_THREADED bit.

I would pull this section out and place it in a loop in
dev_set_threaded to handle creating the threads before you set
dev->threaded and then set the threaded flags in the napi instances.

> +
> +       /* Make sure kthread is created before THREADED bit
> +        * is set.
> +        */
> +       smp_mb__before_atomic();

If we split off the allocation like I mentioned earlier we can
probably pull out the barrier and place it after the allocation of the
kthreads.

> +       set_bit(NAPI_STATE_THREADED, &n->state);
> +
> +       return 0;
> +}
> +

With the change I suggested above you could also drop the return type
from this because it should always succeed.

> +static void dev_disable_threaded_all(struct net_device *dev)
> +{
> +       struct napi_struct *napi;
> +
> +       list_for_each_entry(napi, &dev->napi_list, dev_list)
> +               napi_set_threaded(napi, false);
> +       dev->threaded = 0;
> +}
> +

You might consider renaming this to dev_set_threaded_all and passing a
boolean "threaded" argument. Then you could reuse this code for both
enabling and disabling of the threaded setup. Another thing I might
change would be how we go about toggling the value. Maybe something
more like:

dev->threaded = 0;
list_for_each_entry(napi, &dev->napi_list, dev_list)
    napi_set_threaded(napi, threaded);
dev->threaded = threaded;

The advantage of doing it this way is that we will be
enabling/disabling all instances at the same time since we are
overwriting the dev->threaded first and then taking care of the
individual flags. If you are enabling then after we have set the bits
we set dev->threaded which will switch them all on, and when we clear
dev->threaded it will switch them all off so they should stop checking
the threaded flags in the napi structs.

> +int dev_set_threaded(struct net_device *dev, bool threaded)
> +{
> +       struct napi_struct *napi;
> +       int ret;
> +

There are probably a couple changes that need to be made. First I
would initialize ret to 0 here. More on that below.

Second we need to add a check for if we are actually changing
anything. If not then we shouldn't be bothering. So something like the
following at the start should take care of that:

if (!dev->threaded == !threaded)
    return 0;

I would add a list_for_each_entry loop that does the thread allocation
I called out above and will break if an error is encountered. That way
you aren't toggling dev->threaded unless you know all of the instances
can succeed. Something like:

if (!dev->threaded) {
    list_for_each_entry(napi, &dev->napi_list, dev_list) {
        ret =  napi_kthread_create(napi);
        if (ret)
            break;
    }
}

/* Make sure kthread is created before THREADED bit is set. */
smp_mb__before_atomic();

> +       dev->threaded = threaded;
> +       list_for_each_entry(napi, &dev->napi_list, dev_list) {
> +               ret = napi_set_threaded(napi, threaded);
> +               if (ret) {
> +                       /* Error occurred on one of the napi,
> +                        * reset threaded mode on all napi.
> +                        */
> +                       dev_disable_threaded_all(dev);
> +                       break;
> +               }
> +       }

With my suggestion above you could look at just making the
dev_disable_threaded_all accept a boolean argument for enable/disable
and then you could just do something like:

dev_set_threaded_all(struct net_device *dev, !ret && threaded);

> +
> +       return ret;
> +}
> +
>  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>                     int (*poll)(struct napi_struct *, int), int weight)
>  {
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index daf502c13d6d..969743567257 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -538,6 +538,50 @@ static ssize_t phys_switch_id_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(phys_switch_id);
>
> +static ssize_t threaded_show(struct device *dev,
> +                            struct device_attribute *attr, char *buf)
> +{
> +       struct net_device *netdev = to_net_dev(dev);
> +       int ret;
> +
> +       if (!rtnl_trylock())
> +               return restart_syscall();
> +
> +       if (!dev_isalive(netdev)) {
> +               ret = -EINVAL;
> +               goto unlock;
> +       }
> +
> +       ret = sprintf(buf, fmt_dec, netdev->threaded);
> +

It seems like the more standard pattern is to initialize ret to
-EVINAL and just call the sprintf if dev_isalive is true. That would
allow you to drop the unlock jump label you had to add below.

> +unlock:
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
> @@ -570,6 +614,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
>         &dev_attr_proto_down.attr,
>         &dev_attr_carrier_up_count.attr,
>         &dev_attr_carrier_down_count.attr,
> +       &dev_attr_threaded.attr,
>         NULL,
>  };
>  ATTRIBUTE_GROUPS(net_class);
> --
> 2.30.0.365.g02bc693789-goog
>
