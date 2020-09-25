Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488AC27873A
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgIYM2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:28:52 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:41409 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgIYM2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 08:28:48 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MCsDe-1kCx8Y3XqS-008ope; Fri, 25 Sep 2020 14:28:47 +0200
Received: by mail-qt1-f170.google.com with SMTP id e7so1625489qtj.11;
        Fri, 25 Sep 2020 05:28:46 -0700 (PDT)
X-Gm-Message-State: AOAM530gM8HYzmYEuMZUsYq0GmTMi7NC1nxSASiji2smc9H1QGRmTmzI
        MW6ch4eJdIDhXA9lb2vTl1PuXMvzLWLjLuYWokY=
X-Google-Smtp-Source: ABdhPJyhD0NHMLV8yKYh2vlTiTUV4rU7dm8LqKfHAudHseIZeMw2xvbVjO9RW6csEV4K16hpQD+e2hL4qg9TFnJkit8=
X-Received: by 2002:aed:2ce5:: with SMTP id g92mr3983121qtd.204.1601036925572;
 Fri, 25 Sep 2020 05:28:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200918120536.1464804-1-arnd@arndb.de> <20200918120536.1464804-2-arnd@arndb.de>
 <20200919054831.GN30063@infradead.org>
In-Reply-To: <20200919054831.GN30063@infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 25 Sep 2020 14:28:29 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0ht1c34K+4k3XxGvWA9cxWJSMNzQR2iYMcm98guMsj1A@mail.gmail.com>
Message-ID: <CAK8P3a0ht1c34K+4k3XxGvWA9cxWJSMNzQR2iYMcm98guMsj1A@mail.gmail.com>
Subject: Re: [PATCH 2/2] dev_ioctl: split out SIOC?IFMAP ioctls
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jens Axboe <axboe@kernel.dk>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:R08dgFt9wuG6QS0kztSfaBaUeu/upNlYZpY1Lqx7eibcDlGE+5b
 HAScrJ5Mf0uW8SX6WKwQOT/8t5Br737JXkJlec5S1UEubsnT0X2cnyjO8b/ZzI/MHf5fMET
 T3EBPF90vkoobHLyore4nxIMPjMLSGCyx9nrpWc1+LWtYqPO1GVWm0YI/o5r4c089jsdTZG
 Q4JieP9vZuRfMQeBedBzg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9Qp5MwxHtRw=:ZZ4jsdiDZzveCEgmS4ZCpH
 en/a1qDQRAprc55JCXaruGejcWP2G5fPnXRweN+rribk7KoZeT3ubGWJGuqJjPnRDBzc9QHSz
 4OmJMOc4Q8nqcL7KDj1A2aYquqG1qrVUlEBG+/LOAo/2Me4ZcD4ER5iSAU1KV+z0bA+SJ84Tu
 egtljzdJ1vVdb+eXt/L/PH/KG3BtrO6/qrOkUWQryaO7ocVbcoMYQ07y/4MPrXwyaU5jSm3Yr
 5rAfyGviuRX+DBU7ZoUIZJKkry+S3firZK+Q1X/rO27FPyC5GCOikkelqHPXDVyng0y5jBqyl
 EKeYoG5fXevp8EsLhluJWHzQi6jffkkzUp6LYLUWIO0NekyVc0xXGbkPIc0nsfTXiZQMdGSqo
 4OtDA6VVeSyqzejqjI9z2KOn97Ci51sqEnOtf09adhpoA1Wi+8aNUB+tjg9aQN7t8x2HpjLTl
 0rtLbKlF4XGM0HwKuiHE0A4qkr0KtJQnqWFj3cWr+3xnModpGXmqhLuDL7iR84UZiHvXEaL41
 GbW74Tw7KOyx+P9TnX9gqAnTSN4AbKpWI9z+EsVolYXtxhV8pEY4pUInywxo+qpsNThgqaCSy
 P6FcZ02H0106QC9pgZ1RDjCLZE5KOycqM4nJAyf5cRNiQRFNTJA5CaNnFKRwZKvffpd9iPpW6
 U6sjZbEHzBQK+MfWz8ndm7QJLAOJluJqicHmRZ0CIGdepip5o5M3rVRyxgwObX5k61KF2peRS
 FPE8tI0OTmFDMMn80AYXqtusPo5Y1uTIhZztt6CjBKf7y4b3ysyQef4SYOZYxG0TAZB18LuP2
 mnIaXFOeoIquuMEJV6I+du6dN/eurqfPuPh1mcLVFYSK0L2xBkuVIkrhCjE0IH38uGq54RRGB
 43w279ipVWYcAlEM4cKZKJNGLPMdCO3lKdJUo3OMc9u3SlIZbwW+RroQV5us6TXrQDn4F4U2X
 YS2GKsWGAYjHzilWfAH4iiQmjG+bLBWecUirkH1mlyOynVtgiBqMW
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 7:48 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> > diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
> > index 797ba2c1562a..a332d6ae4dc6 100644
> > --- a/include/uapi/linux/if.h
> > +++ b/include/uapi/linux/if.h
> > @@ -247,7 +247,13 @@ struct ifreq {
> >               short   ifru_flags;
> >               int     ifru_ivalue;
> >               int     ifru_mtu;
> > +#ifndef __KERNEL__
> > +             /*
> > +              * ifru_map is rarely used but causes the incompatibility
> > +              * between native and compat mode.
> > +              */
> >               struct  ifmap ifru_map;
> > +#endif
>
> Do we need a way to verify that this never changes the struct size?

Not sure which way you would want to check. The point of the patch
is that it does change the struct size inside of the kernel but not
in user space.

Do you mean we should check that the (larger) user space size
remains what it is for future changes, or that the (smaller)
kernel size remains the same on all kernels, or maybe both?

> > +int dev_ifmap(struct net *net, struct ifreq __user *ifr, unsigned int cmd)
> > +{
> > +     struct net_device *dev;
> > +     char ifname[IFNAMSIZ];
> > +     char *colon;
> > +     struct compat_ifmap cifmap;
> > +     struct ifmap ifmap;
> > +     int ret;
> > +
> > +     if (copy_from_user(ifname, ifr->ifr_name, sizeof(ifname)))
> > +             return -EFAULT;
> > +     ifname[IFNAMSIZ-1] = 0;
> > +     colon = strchr(ifname, ':');
> > +     if (colon)
> > +             *colon = 0;
> > +     dev_load(net, ifname);
> > +
> > +     switch (cmd) {
> > +     case SIOCGIFMAP:
> > +             rcu_read_lock();
...
> > +             break;
> > +
> > +     case SIOCSIFMAP:
> > +             if (!capable(CAP_NET_ADMIN) ||
...
> > +             break;
> > +     }
> > +     return ret;
>
> I'd rather split this into a separate hepers for each ioctl command
> instead of having anothr multiplexer here, maybe with another helper
> for the common code.

Yes, good idea.

> I also find the rcu unlock inside the branches rather strange, but
> I can't think of a good alternative.

I could assign to the local 'struct ifmap' first under the lock, and
then only copy from there to 'struct compat_ifmap' without the lock
in the compat path. It's probably not better, but I'll give it a try.

The kernel test robot found a build regression with CONFIG_COMPAT
is disabled, I'm fixing that by moving the struct definition of the
global #ifdef in linux/compat.h, which seems nicer than adding
another #ifdef in dev_ifmap.

     Arnd
