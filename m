Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA6668DCA9
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 20:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbfHNSEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 14:04:20 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:32993 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbfHNSET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 14:04:19 -0400
Received: by mail-pl1-f196.google.com with SMTP id c14so50923457plo.0;
        Wed, 14 Aug 2019 11:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i65TMBvSXi6h25YTw/qjPwCNbGJI3tR/idiaX47L8Ck=;
        b=oDgz7DWIxwNG9Rs8Av0aGQCb4Y4zM1LQ1tAIMtpGam4wL/8Gxup4y2oPyAmIxWlcIU
         kFLQtS/AH/pC6D3MgtHWR9wg4hJ8t7xgrFUhclrPwzaVA5FyFlC0I/QalhEl2xy39Ffo
         eSuQi/eiDx0fZE+0aJqR9uDc+19OfkJ3osRSnctH5h8O/aOk9KsZZRg/A1/+0Tw2jl1a
         +CwRtB5bOqJvNipwLJ31AP3rI2NRvqwMQvjjVBoOhKueYR/6UdtBYuQgyj/AkrOQao2w
         gkwPUGt/gn4vewJtfXhQp0BRvUYwhtL3OjR11guj+ZKxR5BlILFL/gYphITtDECXwsJV
         4zQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i65TMBvSXi6h25YTw/qjPwCNbGJI3tR/idiaX47L8Ck=;
        b=JQJdFqrg73K4bOsDiRvK/+npZVbRPJe+3vK6v4sO7goRjG8JPG9ALLItbJjG/XNCZR
         /hXeTJcd2knfhMQCftdI2mWsRAYqUIe1YfJQCPQJrvFuOS8tZXH4GgHM/uQfJ2P4V5fA
         AFzsVqECfgCTsGS3cKe2auXkNo9MAaB5avOBz2lRNvLVmkAT6Orh2UiQXRoeUoeb7FJr
         +lpeNXK3l0F3oOlr/Cko05/NIpUzWCoyX7tckl9GhP8YTdr9fh5wR0YJiyQXR2QZnFXY
         1VpDxW1UuH71OAgUfTKVz7Optpg7fB+NgQVsZhCDaLlDmC54gRSFkVGH7hvzAKVIae25
         nUKw==
X-Gm-Message-State: APjAAAX33uVnppEVISY4+XWuJUTkFsd4A+34vTUf8dLgN0Ns0GWzowa+
        D9KMcFLTwA7coN4cSWFYtBk=
X-Google-Smtp-Source: APXvYqzbRZiUS7F/Q9f8KdCAGzOCl81uvnwp5gpKSitriEyE233/ryC3fENXJCdawVK1SUb1JeKNVA==
X-Received: by 2002:a17:902:b105:: with SMTP id q5mr596304plr.81.1565805858657;
        Wed, 14 Aug 2019 11:04:18 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id i126sm540372pfb.32.2019.08.14.11.04.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 11:04:17 -0700 (PDT)
Date:   Wed, 14 Aug 2019 11:04:15 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Jonas Gorski <jonas.gorski@gmail.com>
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v4 9/9] Input: add IOC3 serio driver
Message-ID: <20190814180415.GC121898@dtor-ws>
References: <20190809103235.16338-1-tbogendoerfer@suse.de>
 <20190809103235.16338-10-tbogendoerfer@suse.de>
 <CAOiHx=kuQtOuNfsJ+fDrps+hbrbp5cPujmQpi8Vfy+0qeP8dtA@mail.gmail.com>
 <20190814163733.82f624e342d061866ba8ff87@suse.de>
 <CAOiHx=mjLpLg9r=mE25T7RQFNRT8wEPkRcy2ZkfT7H=Y5RT-vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOiHx=mjLpLg9r=mE25T7RQFNRT8wEPkRcy2ZkfT7H=Y5RT-vw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 06:57:55PM +0200, Jonas Gorski wrote:
> On Wed, 14 Aug 2019 at 16:37, Thomas Bogendoerfer <tbogendoerfer@suse.de> wrote:
> >
> > On Wed, 14 Aug 2019 15:20:14 +0200
> > Jonas Gorski <jonas.gorski@gmail.com> wrote:
> >
> > > > +       d = devm_kzalloc(&pdev->dev, sizeof(*d), GFP_KERNEL);
> > >
> > > &pdev->dev => dev
> >
> > will change.
> >
> > >
> > > > +       if (!d)
> > > > +               return -ENOMEM;
> > > > +
> > > > +       sk = kzalloc(sizeof(*sk), GFP_KERNEL);
> > >
> > > any reason not to devm_kzalloc this as well? Then you won't need to
> > > manually free it in the error cases.
> >
> > it has different life time than the device, so it may not allocated
> > via devm_kzalloc
> >
> > > > +static int ioc3kbd_remove(struct platform_device *pdev)
> > > > +{
> > > > +       struct ioc3kbd_data *d = platform_get_drvdata(pdev);
> > > > +
> > > > +       devm_free_irq(&pdev->dev, d->irq, d);
> > > > +       serio_unregister_port(d->kbd);
> > > > +       serio_unregister_port(d->aux);
> > > > +       return 0;
> > > > +}
> > >
> > > and on that topic, won't you need to kfree d->kbd and d->aux here?
> >
> > that's done in serio_release_port() by the serio core.
> 
> i see. But in that case, don't the kfree's after the
> serio_unregister_port's in the error path of the .probe function cause
> a double free?

Yes they do, we need to drop kfree()s from there. Nicely spotted.

Thanks.

-- 
Dmitry
