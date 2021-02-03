Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D94930D0DB
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 02:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhBCBdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 20:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbhBCBdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 20:33:05 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F8AC06174A
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 17:32:25 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id y4so2851424ybk.12
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 17:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U+DdWH0eU42lBMveUmnn7dXLs4/+9NHbONm59pozBWA=;
        b=nvZ6jHUrTB/89pKPcWAEOzAC5Z6iE2UmOZV6Sf3mUtZj5DkWo7n94C18v9+WYDGDH/
         x9yrlAHoGKMXQwRm6g1Z26xpC7DpXv/qJlI4moKM55pPN5UAzpCxhFYk2g6dMKuFU24w
         HM7bjHf4o23ns1tE/q+OaJtffOPKs4Sq7EacDG/5YtU65CESbBT7viBBwXkfO/LH0EJd
         sVrg+OH1DKDwiEpSDbRwintdVd3EgiOzKgfQnjhpWlDhuF0fzwQDyImNGQThONbCqnpd
         635jajMy4w7HoDgpGzrBqdZZbebcv78hNhwm4wN4l78aNtrP06gAchrV/G5P8Gc1a0Gi
         9wPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U+DdWH0eU42lBMveUmnn7dXLs4/+9NHbONm59pozBWA=;
        b=C86/vVjz8kFEmCB0DXDvBcyAE2Ya98efxkRhr+ksTGBJGEtyfbOBZCAlA2uUFoU6BL
         K6JM1aeBB7ndFkDPUBwva3KLIC7PsLniQ7znYJmMe8MhxTw06CjaXQgu5/weKfxiH21N
         0FsYEl2tZGqPRpNJgPX+ePTGM/eN0EaHmkGlWv1c0GugwoiYJl+8MNFunc4TIFzQjAUn
         35jWThHwxxhh4+FhMroAJJDm6Lw6nl/JyaP6PRGHCZrmQMd4vHDRqq0ednatWEOcXDSk
         TINujAtsgN27u5JeyClJpZJNi5UZGxT3gNY1gaiNA1E+6v+GM7XhUilJumnpPm2QYocY
         GUrQ==
X-Gm-Message-State: AOAM531M9m7ltayFyb6+t+gQXVxXob6cHUJ0UVHFD41lQSiE1mLDp8xf
        s5ZSXge6FLZW9cTGgMvuu7GJGPEchA93++u/5YukgA==
X-Google-Smtp-Source: ABdhPJwm86IOx+POTOrWq/LHHrxZFhQ7AEXaKxXX1VSoJVIkGgnhqZLvJhdUX4opUnosJdhR8yrQHS+yaDIyFWL94S8=
X-Received: by 2002:a25:bb8f:: with SMTP id y15mr953240ybg.139.1612315944253;
 Tue, 02 Feb 2021 17:32:24 -0800 (PST)
MIME-Version: 1.0
References: <20210129181812.256216-1-weiwan@google.com> <20210129181812.256216-4-weiwan@google.com>
 <20210202162851.1ba89f80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202162851.1ba89f80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 2 Feb 2021 17:32:12 -0800
Message-ID: <CAEA6p_Da9PkQUZaQmh21C5b-O3zZ1jjaJJ-c=r75E3KiBzJoVw@mail.gmail.com>
Subject: Re: [PATCH net-next v9 3/3] net: add sysfs attribute to control napi
 threaded mode
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 4:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
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
Yes. The main reason is the napi might be polled at the moment when
clearing this bit. We have to wait for the thread to finish this round
of polling.
Will add a comment on this.

>
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
>
Ack.

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
Ack.
> > +}
