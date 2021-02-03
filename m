Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8010C30E11A
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 18:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhBCRbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 12:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhBCRbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 12:31:06 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7E7C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 09:30:26 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id n201so70991iod.12
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 09:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m86SjeDkVNjBDVltBtuKLKneElyhJYm6hq3cr0IE+Mk=;
        b=VZTf66jpveoKbAkJyUgLhLDao1wGQnoUD5Cu2NlNII8GxWWiCE2Q9rJKnF5/IGeNYx
         sVj/TijhTfjfaQ/ohFANRChSh4fAXPw05R50Wn3BzmgRyF7oV8iJt7uo9E/xZmg40X0u
         ASc1awabQ+q9ip0lfe691hg5HXCErQ1c80lVX5iSMNzcvbkoF3vQvci57dxCO501letB
         FVah5soOz4ZR2/ECBE3W2rbCNsFQVJGKCYWvw4ymSlD9lNdzRfRigvUpKNexZqOTdhfQ
         6WH17I+2hsqh5zk9QT5oe/hO1mdHm1GflE/ZLHcO7j1Ii0RGbgbwHunzRDULbNY6dwM/
         9RqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m86SjeDkVNjBDVltBtuKLKneElyhJYm6hq3cr0IE+Mk=;
        b=NjPUsvlA7y9TuDE3GeRT6SZa4dwSO0e2pTuloKZXz9SzfIWX5Wleb/ifYAB8IaLCZc
         oAAcJh75Cond7B8PDUmR/2WKHnYalx0/U8L5SlVhOJHH7hcTyP3Thi2+NZQ3wVpM6t4R
         X3VieXw5AfWt3/sdg55XaKN0X5zz81PctcI+wqAXDpl1ImdHTTATkkCJq6SdMDZgpXHC
         qpC0xRP+jKfmJIHGOG5KJzuU2IB+Czaf6LPbB3Dm3HmzD15INqUWinJ1k6YEUJfDVdo+
         XCBp+GqcpXfzY3yr/VAL3DciMzq0CmxGdbK2+LXuVfg0YNDwQD4U2RAKhAU1wl0njVii
         SDgQ==
X-Gm-Message-State: AOAM5334rk711MlBK9E9F4KqzFplYcLCPgwlX8cLGHhFH8zT+WxCQkFI
        OAJNCWsi0TPc/dx44f6zodBMv7EZUhH39YNF42U=
X-Google-Smtp-Source: ABdhPJxUNsQqY3HArRUVLX1CER+XJ+o0RiJSgf7s8PmZUG3EtGaJpD3RxeNKaq2GPS/2rB9yDYcyk984P89zU/uXBwM=
X-Received: by 2002:a02:7710:: with SMTP id g16mr3984705jac.83.1612373425822;
 Wed, 03 Feb 2021 09:30:25 -0800 (PST)
MIME-Version: 1.0
References: <20210129181812.256216-1-weiwan@google.com> <20210129181812.256216-4-weiwan@google.com>
 <20210202162851.1ba89f80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202162851.1ba89f80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 3 Feb 2021 09:30:14 -0800
Message-ID: <CAKgT0UdjWGBrv9wOUyOxon5Sn7qSBHL5-KfByPS4uB1_TJ3WiQ@mail.gmail.com>
Subject: Re: [PATCH net-next v9 3/3] net: add sysfs attribute to control napi
 threaded mode
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 5:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 29 Jan 2021 10:18:12 -0800 Wei Wang wrote:
> > This patch adds a new sysfs attribute to the network device class.
> > Said attribute provides a per-device control to enable/disable the
> > threaded mode for all the napi instances of the given network device,
> > without the need for a device up/down.
> > User sets it to 1 or 0 to enable or disable threaded mode.
> >
> > Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > Co-developed-by: Felix Fietkau <nbd@nbd.name>
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > Signed-off-by: Wei Wang <weiwan@google.com>
>
> > +static int napi_set_threaded(struct napi_struct *n, bool threaded)
> > +{
> > +     int err = 0;
> > +
> > +     if (threaded == !!test_bit(NAPI_STATE_THREADED, &n->state))
> > +             return 0;
> > +
> > +     if (!threaded) {
> > +             clear_bit(NAPI_STATE_THREADED, &n->state);
>
> Can we put a note in the commit message saying that stopping the
> threads is slightly tricky but we'll do it if someone complains?
>
> Or is there a stronger reason than having to wait for thread to finish
> up with the NAPI not to stop them?

Normally if we are wanting to shut down NAPI we would have to go
through a coordinated process with us setting the NAPI_STATE_DISABLE
bit and then having to sit on NAPI_STATE_SCHED. Doing that would
likely cause a traffic hiccup if somebody toggles this while the NIC
is active so probably best to not interfere.

I suspect this should be more than enough to have us switch in and out
of the threaded setup. I don't think leaving the threads allocated
after someone has enabled it once should be much of an issue. As far
as using just the bit to do the disable, I think the most it would
probably take is a second or so for the queues to switch over from
threaded to normal NAPI again.

> > +             return 0;
> > +     }
> > +
> > +     if (!n->thread) {
> > +             err = napi_kthread_create(n);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     /* Make sure kthread is created before THREADED bit
> > +      * is set.
> > +      */
> > +     smp_mb__before_atomic();
> > +     set_bit(NAPI_STATE_THREADED, &n->state);
> > +
> > +     return 0;
> > +}
> > +
> > +static void dev_disable_threaded_all(struct net_device *dev)
> > +{
> > +     struct napi_struct *napi;
> > +
> > +     list_for_each_entry(napi, &dev->napi_list, dev_list)
> > +             napi_set_threaded(napi, false);
> > +     dev->threaded = 0;
> > +}
> > +
> > +int dev_set_threaded(struct net_device *dev, bool threaded)
> > +{
> > +     struct napi_struct *napi;
> > +     int ret;
> > +
> > +     dev->threaded = threaded;
> > +     list_for_each_entry(napi, &dev->napi_list, dev_list) {
> > +             ret = napi_set_threaded(napi, threaded);
> > +             if (ret) {
> > +                     /* Error occurred on one of the napi,
> > +                      * reset threaded mode on all napi.
> > +                      */
> > +                     dev_disable_threaded_all(dev);
> > +                     break;
> > +             }
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> >  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
> >                   int (*poll)(struct napi_struct *, int), int weight)
> >  {
> > diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> > index daf502c13d6d..884f049ee395 100644
> > --- a/net/core/net-sysfs.c
> > +++ b/net/core/net-sysfs.c
> > @@ -538,6 +538,55 @@ static ssize_t phys_switch_id_show(struct device *dev,
> >  }
> >  static DEVICE_ATTR_RO(phys_switch_id);
> >
> > +static ssize_t threaded_show(struct device *dev,
> > +                          struct device_attribute *attr, char *buf)
> > +{
> > +     struct net_device *netdev = to_net_dev(dev);
> > +     int ret;
> > +
> > +     if (!rtnl_trylock())
> > +             return restart_syscall();
> > +
> > +     if (!dev_isalive(netdev)) {
> > +             ret = -EINVAL;
> > +             goto unlock;
> > +     }
> > +
> > +     if (list_empty(&netdev->napi_list)) {
> > +             ret = -EOPNOTSUPP;
> > +             goto unlock;
> > +     }
>
> Maybe others disagree but I'd take this check out. What's wrong with
> letting users see that threaded napi is disabled for devices without
> NAPI?
>
> This will also help a little devices which remove NAPIs when they are
> down.
>
> I've been caught off guard in the past by the fact that kernel returns
> -ENOENT for XPS map when device has a single queue.

I agree there isn't any point to the check. I think this is a
hold-over from the original code that was querying each napi structure
assigned to the device.

> > +     ret = sprintf(buf, fmt_dec, netdev->threaded);
> > +
> > +unlock:
> > +     rtnl_unlock();
> > +     return ret;
> > +}
> > +
> > +static int modify_napi_threaded(struct net_device *dev, unsigned long val)
> > +{
> > +     int ret;
> > +
> > +     if (list_empty(&dev->napi_list))
> > +             return -EOPNOTSUPP;
> > +
> > +     if (val != 0 && val != 1)
> > +             return -EOPNOTSUPP;
> > +
> > +     ret = dev_set_threaded(dev, val);
> > +
> > +     return ret;
>
> return dev_set_threaded(dev, val);
>
> > +}
