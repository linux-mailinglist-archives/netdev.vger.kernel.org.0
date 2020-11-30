Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7912C7FA0
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 09:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgK3ITH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 03:19:07 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44369 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgK3ITH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 03:19:07 -0500
Received: by mail-ed1-f65.google.com with SMTP id l5so14759688edq.11;
        Mon, 30 Nov 2020 00:18:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7ELIpAjsOedkt2ELejoC5Co8Q70hkmkcxFY/x4He7k4=;
        b=f5thnTvTqH61cwmpo7jzvneuFmrAzhdsAPq9BWwvmStopwTnIvhYti02pOpYZ2Csrh
         vFLe1u4jTZDvTIrAekCOgqAM5E1C87MiLPMJznyExF8FHXoRSsFk060l4clYjR+8Uozf
         G/WzSeRFGX0rP08bdbAz7lmZYTkUnokue5tm2crZ9tsmMUUmIXroDLnNinyfhnNIvH/C
         XhMnOG6OOoMkt5jNRU0D5bUqBtqpXbJSZ3uvazqeZpdNDK/a7OkzUIAo4VzB3oXApVQq
         9cvO5cosjuB2bxWg7yPpd8EsQhfoUyfKFMfjhliiqZeGGaWs7Jrk8cjdJdJYz/Ry3oZF
         rAiQ==
X-Gm-Message-State: AOAM531agDKT4EZI6j9EloshGKyyZbl0ZPzlHJWQ3tXy430ZqlO9IEmb
        VligIDOKEdkbuxGaLrfynxvm3/Sfuw8=
X-Google-Smtp-Source: ABdhPJxkakE/e8tWvMgsScFixqp8CwlAiPKafk4vtYKrdHAF0U7uyWHtATPPOUpv0Yjmi76I+z0RIQ==
X-Received: by 2002:a50:9f8f:: with SMTP id c15mr5280252edf.261.1606724303471;
        Mon, 30 Nov 2020 00:18:23 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id z29sm8652636edi.1.2020.11.30.00.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 00:18:22 -0800 (PST)
Date:   Mon, 30 Nov 2020 09:18:20 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v2 net-next 3/3] nfc: s3fwrn5: extract the common phy
 blocks
Message-ID: <20201130081820.GA4790@kozik-lap>
References: <1606476138-31992-1-git-send-email-bongsu.jeon2@gmail.com>
 <20201128124920.GB6313@kozik-lap>
 <CACwDmQC_QrWz=vJN0u0eQAX0fGV__W8cLBF5q7goCxB7Wc2y7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACwDmQC_QrWz=vJN0u0eQAX0fGV__W8cLBF5q7goCxB7Wc2y7A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 29, 2020 at 06:55:10PM +0900, Bongsu Jeon wrote:
> On Sat, Nov 28, 2020 at 9:49 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > This is not a proper wrapping. Wrapping happens on function arguments.
> >
> > > +             if (!gpio_is_valid(phy->common.gpio_en))
> > >                       return -ENODEV;
> > >       }
> > >
> > > -     phy->gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
> > > -     if (!gpio_is_valid(phy->gpio_fw_wake)) {
> > > +     phy->common.gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
> > > +     if (!gpio_is_valid(phy->common.gpio_fw_wake)) {
> > >               /* Support also deprecated property */
> > > -             phy->gpio_fw_wake = of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);
> > > -             if (!gpio_is_valid(phy->gpio_fw_wake))
> > > +             phy->common.gpio_fw_wake =
> > > +                             of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);
> > > +             if (!gpio_is_valid(phy->common.gpio_fw_wake))
> >
> > The same.
> >
> 
> Even though I wrapped this as below, Second line("s3fwrn5,fw-gpios" )
> was over 80 columns.
> Is it okay as below?
> phy->gpio_fw_wake =of_get_named_gpio(np,
> 
> "s3fwrn5,fw-gpios",
>                                                                      0);

Your email client breaks indentation so I cannot answer. The wrapping - as
explained in CodingStyle - would look like:

		phy->common.gpio_fw_wake = of_get_named_gpio(np,
							     "s3fwrn5,fw-gpios",
							     0);

It's not a problem if single argument exceeds 80 character.

> 
> 
> > >                       return -ENODEV;
> > >       }
> > >
> > > @@ -226,8 +184,8 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
> > >       if (!phy)
> > >               return -ENOMEM;
> > >
> > > -     mutex_init(&phy->mutex);
> > > -     phy->mode = S3FWRN5_MODE_COLD;
> > > +     mutex_init(&phy->common.mutex);
> > > +     phy->common.mode = S3FWRN5_MODE_COLD;
> > >       phy->irq_skip = true;
> > >
> > >       phy->i2c_dev = client;
> > > @@ -237,17 +195,19 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
> > >       if (ret < 0)
> > >               return ret;
> > >
> > > -     ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->gpio_en,
> > > -             GPIOF_OUT_INIT_HIGH, "s3fwrn5_en");
> > > +     ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->common.gpio_en,
> > > +                                 GPIOF_OUT_INIT_HIGH, "s3fwrn5_en");
> > >       if (ret < 0)
> > >               return ret;
> > >
> > > -     ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->gpio_fw_wake,
> > > -             GPIOF_OUT_INIT_LOW, "s3fwrn5_fw_wake");
> > > +     ret = devm_gpio_request_one(&phy->i2c_dev->dev,
> > > +                                 phy->common.gpio_fw_wake,
> > > +                                 GPIOF_OUT_INIT_LOW, "s3fwrn5_fw_wake");
> > >       if (ret < 0)
> > >               return ret;
> > >
> > > -     ret = s3fwrn5_probe(&phy->ndev, phy, &phy->i2c_dev->dev, &i2c_phy_ops);
> > > +     ret = s3fwrn5_probe(&phy->common.ndev, phy, &phy->i2c_dev->dev,
> > > +                         &i2c_phy_ops);
> > >       if (ret < 0)
> > >               return ret;
> > >
> > > @@ -255,7 +215,7 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
> > >               s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
> > >               S3FWRN5_I2C_DRIVER_NAME, phy);
> > >       if (ret)
> > > -             s3fwrn5_remove(phy->ndev);
> > > +             s3fwrn5_remove(phy->common.ndev);
> > >
> > >       return ret;
> > >  }
> > > @@ -264,7 +224,7 @@ static int s3fwrn5_i2c_remove(struct i2c_client *client)
> > >  {
> > >       struct s3fwrn5_i2c_phy *phy = i2c_get_clientdata(client);
> > >
> > > -     s3fwrn5_remove(phy->ndev);
> > > +     s3fwrn5_remove(phy->common.ndev);
> > >
> > >       return 0;
> > >  }
> > > diff --git a/drivers/nfc/s3fwrn5/phy_common.c b/drivers/nfc/s3fwrn5/phy_common.c
> > > new file mode 100644
> > > index 0000000..e333764
> > > --- /dev/null
> > > +++ b/drivers/nfc/s3fwrn5/phy_common.c
> > > @@ -0,0 +1,60 @@
> > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > +/*
> > > + * Link Layer for Samsung S3FWRN5 NCI based Driver
> > > + *
> > > + * Copyright (C) 2015 Samsung Electrnoics
> > > + * Robert Baldyga <r.baldyga@samsung.com>
> > > + * Copyright (C) 2020 Samsung Electrnoics
> > > + * Bongsu Jeon <bongsu.jeon@samsung.com>
> > > + */
> > > +
> > > +#include <linux/gpio.h>
> > > +#include <linux/delay.h>
> >
> > You need also mutex.h (it seems original code did not have it but since
> > you move things around it's a new code basically).
> >
> > > +
> > > +#include "s3fwrn5.h"
> > > +#include "phy_common.h"
> > > +
> > > +void s3fwrn5_phy_set_wake(void *phy_id, bool wake)
> > > +{
> > > +     struct phy_common *phy = phy_id;
> > > +
> > > +     mutex_lock(&phy->mutex);
> > > +     gpio_set_value(phy->gpio_fw_wake, wake);
> > > +     msleep(S3FWRN5_EN_WAIT_TIME);
> > > +     mutex_unlock(&phy->mutex);
> > > +}
> > > +
> > > +bool s3fwrn5_phy_power_ctrl(struct phy_common *phy, enum s3fwrn5_mode mode)
> > > +{
> > > +     if (phy->mode == mode)
> > > +             return false;
> > > +
> > > +     phy->mode = mode;
> > > +
> > > +     gpio_set_value(phy->gpio_en, 1);
> > > +     gpio_set_value(phy->gpio_fw_wake, 0);
> > > +     if (mode == S3FWRN5_MODE_FW)
> > > +             gpio_set_value(phy->gpio_fw_wake, 1);
> > > +
> > > +     if (mode != S3FWRN5_MODE_COLD) {
> > > +             msleep(S3FWRN5_EN_WAIT_TIME);
> > > +             gpio_set_value(phy->gpio_en, 0);
> > > +             msleep(S3FWRN5_EN_WAIT_TIME);
> > > +     }
> > > +
> > > +     return true;
> > > +}
> > > +
> > > +enum s3fwrn5_mode s3fwrn5_phy_get_mode(void *phy_id)
> > > +{
> > > +     struct phy_common *phy = phy_id;
> > > +     enum s3fwrn5_mode mode;
> > > +
> > > +     mutex_lock(&phy->mutex);
> > > +
> > > +     mode = phy->mode;
> > > +
> > > +     mutex_unlock(&phy->mutex);
> > > +
> > > +     return mode;
> > > +}
> > > diff --git a/drivers/nfc/s3fwrn5/phy_common.h b/drivers/nfc/s3fwrn5/phy_common.h
> > > new file mode 100644
> > > index 0000000..b920f7f
> > > --- /dev/null
> > > +++ b/drivers/nfc/s3fwrn5/phy_common.h
> > > @@ -0,0 +1,31 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-or-later
> > > + *
> > > + * Link Layer for Samsung S3FWRN5 NCI based Driver
> > > + *
> > > + * Copyright (C) 2015 Samsung Electrnoics
> > > + * Robert Baldyga <r.baldyga@samsung.com>
> > > + * Copyright (C) 2020 Samsung Electrnoics
> > > + * Bongsu Jeon <bongsu.jeon@samsung.com>
> > > + */
> > > +
> > > +#ifndef __NFC_S3FWRN5_PHY_COMMON_H
> > > +#define __NFC_S3FWRN5_PHY_COMMON_H
> > > +
> > > +#define S3FWRN5_EN_WAIT_TIME 20
> > > +
> > > +struct phy_common {
> > > +     struct nci_dev *ndev;
> >
> > You need a header for nci_dev type.
> >
> > > +
> > > +     int gpio_en;
> > > +     int gpio_fw_wake;
> > > +
> > > +     struct mutex mutex;
> >
> > You need a header include for mutex.
> >
> > > +
> > > +     enum s3fwrn5_mode mode;
> >
> > Indeed now it won't work - you use an enum without its declaration. The
> > s3fwrn5_mode enum looks more like a property of the phy and after this
> > patch would be used only once in i2c.c and once in core.c.
> >
> 
> Yes.  phy_common.h doesn't include nci_dev and mutex and s3fwrn5_mode
> declaration.
> So,  i2c.c and phy_common.c include "s3fwrn5.h" first and then "
> ( mutex and nci_dev would be included from nci_core.h and 3fwrn5_mode
> would be included  from s3fwrn5.h).

The header usually should include everything which is used inside, so
mutex.

> 
> > How is it going to be used in your new driver - I cannot check because
> > you did not post it. You should post this refactoring with new users of
> > the API, so we could see bigger picture.
> >
> 
> Okay. Then, I will add the UART driver.
> So, I will resend the patches as below.
> 1. [PATCH net-next 1/4] dt-bindings: net: nfc: s3fwrn5: Support a UART interface
> 2. [PATCH net-next 2/4] nfc: s3fwrn5: reduce the EN_WAIT_TIME (*
> because of Jakub's request )
> 3. [PATCH net-next 3/4] nfc: s3fwrn5: extract the common phy blocks
> 4. [PATCH net-next 4/4] net: nfc: s3fwrn5: Support a UART interface
> 
> > Your original idea - with the s3fwrn5.h include here - looks more
> > logical than moving the enum s3fwrn5_mode here.
> >
> 
> Do you mean that it would be better to include the s3fwrn5.h in phy_common.h?

Yes.

Best regards,
Krzysztof
