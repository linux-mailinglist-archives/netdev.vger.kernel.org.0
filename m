Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321752F87FA
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 22:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbhAOVzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 16:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbhAOVzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 16:55:06 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB79C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 13:54:26 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id d199so277657ybc.0
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 13:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QbTGoitJLdELQ+oilVmrdTS+sooKXT/O9Ek6HLsSCA8=;
        b=QiAZDH8c/iKQ6fRE32skFAs4o6SI96S/k+PovAlEmKnBsFNmSy6y7poaajqRutRJBH
         t3bwffFyJAgX5sPer3iTiNxEQUW2CpzjWXxfGHIaprvvvt13wiftuIBLd0vBGY5epO9N
         JxKqqv9FTKRHAfKHMVvrnvgNh7X5SuX1k9j8XzNQ5wwyW/LpXyVXvwvVuVUUh/09Z9vP
         93R6/2Z0M1goDFCJQlxmX7ZsRFLNcDAMN5+7qMWI66L6lT14fs7RansMHCsJN+5na4Ci
         142glWPmi5CdT85nxbAlx6I9Sss/BhPTa9cM4t1sFeBU4jvp2VVlaGiqJXVwhdNJilsT
         pUPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QbTGoitJLdELQ+oilVmrdTS+sooKXT/O9Ek6HLsSCA8=;
        b=eBJbTulya9z+QIj8Apw4kNfdj9c+RgDujkrrsKRnzFps5dsB+XyIm7exvg4on5bM6V
         5pjbhGPxBG/09uxyLjpqM5TZZ3Wszp7KuTu0fRlMgzuoWeAa+bm192eC6q+5gBqcQxOu
         93LP0UnohwmlUjGbYa/+KAZxjdDF+WPrZQGNL4/UvsfqBF3NToZvEPMotnKnjoOLj8dh
         m2nQ+m8dAu6V4DO3LnIlpYqxKnOLrvxlp3KGU6jwGzEa+RJBMsrFijoFccNVcKzlow4O
         XaAFRwD09jGkzTkiplxexQ0EJlEagWCeLNTxKoKYDCmR0yfe2UOFSjRUz0cCVh2tFbD5
         Bx0A==
X-Gm-Message-State: AOAM532jrgtTbM6RAzAZxtygT+Ln868+G2r744UwHYvTfDy/sO49MjTk
        8zqMMH008LFD7D5EBXuDmG/PNCKj3YNR4AsrAG/SVw==
X-Google-Smtp-Source: ABdhPJyt9/2oVdQyymHkN/qgde8roxoiVIII/kcZaM7GQyYPSmFeal+ln9jNbFNPS9EIfo7UQzEX8jzpWLNvwerDu4w=
X-Received: by 2002:a25:99c6:: with SMTP id q6mr20757793ybo.408.1610747665306;
 Fri, 15 Jan 2021 13:54:25 -0800 (PST)
MIME-Version: 1.0
References: <20210115003123.1254314-1-weiwan@google.com> <20210115003123.1254314-4-weiwan@google.com>
 <CAKgT0UdRK=KXT40nPmHbCeLixDkwdYEEFbwECnAKBFBjUsPOHQ@mail.gmail.com>
In-Reply-To: <CAKgT0UdRK=KXT40nPmHbCeLixDkwdYEEFbwECnAKBFBjUsPOHQ@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 15 Jan 2021 13:54:13 -0800
Message-ID: <CAEA6p_DN+Cgo2bB6zBXC966g2PiSfOEifY0jR6QKU4mNrVmf2Q@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/3] net: add sysfs attribute to control napi
 threaded mode
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 7:34 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, Jan 14, 2021 at 4:34 PM Wei Wang <weiwan@google.com> wrote:
> >
> > This patch adds a new sysfs attribute to the network device class.
> > Said attribute provides a per-device control to enable/disable the
> > threaded mode for all the napi instances of the given network device.
> >
> > Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > Co-developed-by: Felix Fietkau <nbd@nbd.name>
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > Signed-off-by: Wei Wang <weiwan@google.com>
> > ---
> >  include/linux/netdevice.h |  2 ++
> >  net/core/dev.c            | 28 +++++++++++++++++
> >  net/core/net-sysfs.c      | 63 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 93 insertions(+)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index c24ed232c746..11ae0c9b9350 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -497,6 +497,8 @@ static inline bool napi_complete(struct napi_struct *n)
> >         return napi_complete_done(n, 0);
> >  }
> >
> > +int dev_set_threaded(struct net_device *dev, bool threaded);
> > +
> >  /**
> >   *     napi_disable - prevent NAPI from scheduling
> >   *     @n: NAPI context
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index edcfec1361e9..d5fb95316ea8 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6754,6 +6754,34 @@ static int napi_set_threaded(struct napi_struct *n, bool threaded)
> >         return err;
> >  }
> >
> > +static void dev_disable_threaded_all(struct net_device *dev)
> > +{
> > +       struct napi_struct *napi;
> > +
> > +       list_for_each_entry(napi, &dev->napi_list, dev_list)
> > +               napi_set_threaded(napi, false);
> > +}
> > +
> > +int dev_set_threaded(struct net_device *dev, bool threaded)
> > +{
> > +       struct napi_struct *napi;
> > +       int ret;
> > +
> > +       dev->threaded = threaded;
> > +       list_for_each_entry(napi, &dev->napi_list, dev_list) {
> > +               ret = napi_set_threaded(napi, threaded);
> > +               if (ret) {
> > +                       /* Error occurred on one of the napi,
> > +                        * reset threaded mode on all napi.
> > +                        */
> > +                       dev_disable_threaded_all(dev);
> > +                       break;
> > +               }
> > +       }
> > +
> > +       return ret;
>
> This doesn't seem right. The NAPI instances can be active while this
> is occuring can they not? I would think at a minimum you need to go
> through a napi_disable/napi_enable in order to toggle this value for
> each NAPI instance. Otherwise aren't you at risk for racing and having
> a napi_schedule attempt to wake up the thread before it has been
> allocated?


Yes. The napi instance could be active when this occurs. And I think
it is OK. It is cause napi_set_threaded() only sets
NAPI_STATE_THREADED bit after successfully created the kthread. And
___napi_schedule() only tries to wake up the kthread after testing the
THREADED bit.

>
>
> > +}
> > +
> >  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
> >                     int (*poll)(struct napi_struct *, int), int weight)
> >  {
> > diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> > index daf502c13d6d..2017f8f07b8d 100644
> > --- a/net/core/net-sysfs.c
> > +++ b/net/core/net-sysfs.c
> > @@ -538,6 +538,68 @@ static ssize_t phys_switch_id_show(struct device *dev,
> >  }
> >  static DEVICE_ATTR_RO(phys_switch_id);
> >
> > +static ssize_t threaded_show(struct device *dev,
> > +                            struct device_attribute *attr, char *buf)
> > +{
> > +       struct net_device *netdev = to_net_dev(dev);
> > +       struct napi_struct *n;
> > +       bool enabled;
> > +       int ret;
> > +
> > +       if (!rtnl_trylock())
> > +               return restart_syscall();
> > +
> > +       if (!dev_isalive(netdev)) {
> > +               ret = -EINVAL;
> > +               goto unlock;
> > +       }
> > +
> > +       if (list_empty(&netdev->napi_list)) {
> > +               ret = -EOPNOTSUPP;
> > +               goto unlock;
> > +       }
> > +
> > +       /* Only return true if all napi have threaded mode.
> > +        * The inconsistency could happen when the device driver calls
> > +        * napi_disable()/napi_enable() with dev->threaded set to true,
> > +        * but napi_kthread_create() fails.
> > +        * We return false in this case to remind the user that one or
> > +        * more napi did not have threaded mode enabled properly.
> > +        */
> > +       list_for_each_entry(n, &netdev->napi_list, dev_list) {
> > +               enabled = !!test_bit(NAPI_STATE_THREADED, &n->state);
> > +               if (!enabled)
> > +                       break;
> > +       }
> > +
>
> This logic seems backwards to me. If we have it enabled for any of
> them it seems like we should report it was enabled. Otherwise we are
> going to be leaking out instances of threaded napi and not be able to
> easily find where they are coming from. If nothing else it might make
> sense to have this as a ternary value where it is either enabled,
> disabled, or partial/broken.


Good point. The reason to return true only if all napi have threaded
enabled, is I would like this return value to serve as a signal to the
user to indicate that the threaded mode is not enabled successfully
for all napi instances, when the user tries to enable it, but then got
"disabled".
But maybe using a ternary value is a better idea. I will see how to change that.


>
> Also why bother testing each queue when you already have dev->threaded?


It is cause I use dev-> threaded to store what user wants to set the
threaded mode to. But if it is set partially or it is broken, I'd like
to return "disabled".
Again, I will see how to implement a ternary value.

>
>
> > +       ret = sprintf(buf, fmt_dec, enabled);
> > +
> > +unlock:
> > +       rtnl_unlock();
> > +       return ret;
> > +}
> > +
> > +static int modify_napi_threaded(struct net_device *dev, unsigned long val)
> > +{
> > +       struct napi_struct *napi;
> > +       int ret;
> > +
> > +       if (list_empty(&dev->napi_list))
> > +               return -EOPNOTSUPP;
> > +
> > +       ret = dev_set_threaded(dev, !!val);
> > +
> > +       return ret;
> > +}
> > +
> > +static ssize_t threaded_store(struct device *dev,
> > +                             struct device_attribute *attr,
> > +                             const char *buf, size_t len)
> > +{
> > +       return netdev_store(dev, attr, buf, len, modify_napi_threaded);
> > +}
> > +static DEVICE_ATTR_RW(threaded);
> > +
> >  static struct attribute *net_class_attrs[] __ro_after_init = {
> >         &dev_attr_netdev_group.attr,
> >         &dev_attr_type.attr,
> > @@ -570,6 +632,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
> >         &dev_attr_proto_down.attr,
> >         &dev_attr_carrier_up_count.attr,
> >         &dev_attr_carrier_down_count.attr,
> > +       &dev_attr_threaded.attr,
> >         NULL,
> >  };
> >  ATTRIBUTE_GROUPS(net_class);
> > --
> > 2.30.0.284.gd98b1dd5eaa7-goog
> >
