Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43F458D88E
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbfHNQ6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:58:03 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38570 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfHNQ6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:58:02 -0400
Received: by mail-wm1-f66.google.com with SMTP id m125so5059890wmm.3;
        Wed, 14 Aug 2019 09:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MTEkYKL8BVYhxHYUGvIBzu9AUXRPM4JLAqesOWugBI4=;
        b=XW6JU+744xiPyvNGXbdLzF9iT8xBjUrwuGqjiEzePGIE10acGza/QX9wb4sifiJBAM
         s+Vyy/HYTvljbdR154FO5gtmYoW1+UlIcJRZC9sXJuXt1rDFpF/OQwU0XchQtQblKFbc
         IkklEWAlaDopBwgale8LaS9oJ0BfMiMIf2P5Nf2A2xJh3tCNntxuMYi6K/sZSEDYpkBY
         BNknRECBO3vUKy9XXwwvOCy0UiOp5wehR1znL40YUof9CC48bZXbB8MA0F/O+O5wI/ll
         bhPZL/2ucJSM9SDYCOe08SqxFuKEREop4O6V9kG+Jmm0KY45RiDm46Dt3cDJD2ouV5lm
         UXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MTEkYKL8BVYhxHYUGvIBzu9AUXRPM4JLAqesOWugBI4=;
        b=IMRRaITUThNW8X0GDlfDRHchVTbSGB0Zl/OTkJCFXVKTdngbvuryXTwJfgKPiOnT93
         pLOXSvnxdb1eViQbRKtyOd/fw9FSco5o1lIzGGdbmcfjjclP955RMWfXPs/I1LYppgVD
         69/PxO4a//G79FrXaXo2FVNvlKJbFQuGrEm4HQFPGOvhJOBt71wSHmv23EXrvdQmjr/C
         7eQqQI7osRyWWPRcQ6bIYLHQC+tmtRxZEugC3MfFo5P25NkmCQV8sYo1OpUnETWRPbSP
         OugScLkieW77mKuSRTjF5LXrSpgCpMv4rTzMfj+qbbWwZ4u6mVLWLZJ6XHsA0iZwQLth
         AkVA==
X-Gm-Message-State: APjAAAVvkFqjpexBZzmVj+wi6Xf+Ckv/pHUkuhfakmhbhcVy24SncZVa
        6714H2EACqXkmB7sC+Axnd1wMJeepmSuSWVvd4c=
X-Google-Smtp-Source: APXvYqwkB83yqS+8NjQ83QcF+PEzdvw0fVo5cYYg9YRmO2gZttUCgzRF+qn91dqYvwhB3wvP6frRE/cX8xn120tcF9I=
X-Received: by 2002:a05:600c:54c:: with SMTP id k12mr79276wmc.117.1565801879761;
 Wed, 14 Aug 2019 09:57:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190809103235.16338-1-tbogendoerfer@suse.de> <20190809103235.16338-10-tbogendoerfer@suse.de>
 <CAOiHx=kuQtOuNfsJ+fDrps+hbrbp5cPujmQpi8Vfy+0qeP8dtA@mail.gmail.com> <20190814163733.82f624e342d061866ba8ff87@suse.de>
In-Reply-To: <20190814163733.82f624e342d061866ba8ff87@suse.de>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Wed, 14 Aug 2019 18:57:55 +0200
Message-ID: <CAOiHx=mjLpLg9r=mE25T7RQFNRT8wEPkRcy2ZkfT7H=Y5RT-vw@mail.gmail.com>
Subject: Re: [PATCH v4 9/9] Input: add IOC3 serio driver
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Aug 2019 at 16:37, Thomas Bogendoerfer <tbogendoerfer@suse.de> wrote:
>
> On Wed, 14 Aug 2019 15:20:14 +0200
> Jonas Gorski <jonas.gorski@gmail.com> wrote:
>
> > > +       d = devm_kzalloc(&pdev->dev, sizeof(*d), GFP_KERNEL);
> >
> > &pdev->dev => dev
>
> will change.
>
> >
> > > +       if (!d)
> > > +               return -ENOMEM;
> > > +
> > > +       sk = kzalloc(sizeof(*sk), GFP_KERNEL);
> >
> > any reason not to devm_kzalloc this as well? Then you won't need to
> > manually free it in the error cases.
>
> it has different life time than the device, so it may not allocated
> via devm_kzalloc
>
> > > +static int ioc3kbd_remove(struct platform_device *pdev)
> > > +{
> > > +       struct ioc3kbd_data *d = platform_get_drvdata(pdev);
> > > +
> > > +       devm_free_irq(&pdev->dev, d->irq, d);
> > > +       serio_unregister_port(d->kbd);
> > > +       serio_unregister_port(d->aux);
> > > +       return 0;
> > > +}
> >
> > and on that topic, won't you need to kfree d->kbd and d->aux here?
>
> that's done in serio_release_port() by the serio core.

i see. But in that case, don't the kfree's after the
serio_unregister_port's in the error path of the .probe function cause
a double free?


Regards
Jonas
