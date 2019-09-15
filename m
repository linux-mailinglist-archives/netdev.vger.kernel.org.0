Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9670FB2E8D
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 08:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfIOGF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 02:05:29 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45045 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfIOGF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 02:05:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id k1so15092327pls.11;
        Sat, 14 Sep 2019 23:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OJ6q0tq8p00CvC/WL6ngIjiVDkJbPFjkP/CpoIw0kT8=;
        b=qs5ea2mYlu6e60ZcbpGc0IPc28QvGarsfgphl8OX5wpevQ3Vt3UsLJRYAQKaq+Hm0Z
         BobdSvY5see2jK8+6KjwLNQueni73vm6orBb0zbqmgiZ5p/6gWF6xUG7JIdBOR+4vu6N
         adzt3UVkcmD5TqzOsHWmpZ9S7nFbCx0eUAQQxkqe/5PhpublRWAu3WbPr/Un/ra2EWUb
         WD8/1KdaM9fr4LhREg+RU7FKxgbWidNO5HJSpCXfuO4EJ330V9ZDxbDGbhchmVhwBhr7
         fRwykRp9AZBendjdSYJ7sQIazpD65jBNjJj5uw05ed99w15K1qv/yjop5Xgjtya/rXIE
         Nteg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OJ6q0tq8p00CvC/WL6ngIjiVDkJbPFjkP/CpoIw0kT8=;
        b=I95EzKGCnDgG7odEYTIbkW6duEyI6ySzKJ2Eym27DhIOffc0Lq+81Ol8WmPAjaL2x5
         Rsa3JbMeFU/7pL9mGeueODEXhWUb6I7g73YTR5s/C6TkBz6xZ+5qi70xUcf6/QmNqkeC
         W5OM2szF+SIfjyTTVnvtRxnIjg8X/sAZTRUdmhhe/ovbbzT8uqye0yPYP/6pQunZ00Mp
         jRohTc0ml/l/joy7xFq2rhoy7LvJ3LU7VYLNpaTgFvVB2QLjL/lfsC2KCSe5HBNzb06A
         /LYgYShvxS/D75jsD2tCJtzQRRN9yys0bKi2QCfdpZGQlJOvX4490zfTbGNcz5nAzOpO
         Z6NQ==
X-Gm-Message-State: APjAAAX5ulSkr8YenIC2p1WMW8VKC61S/s9op0OxtRZu7Y8BrHA0sRLZ
        dmYdKhL/HJ14z0XXu4TcdsM=
X-Google-Smtp-Source: APXvYqyGwUo79ROqsKFNRwJySkK2wLiNei2cfNNevV8YbrMfbdfqZXPruglZWuyvLd5wrs60JbEWhg==
X-Received: by 2002:a17:902:7c88:: with SMTP id y8mr57612161pll.306.1568527528225;
        Sat, 14 Sep 2019 23:05:28 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id j4sm547133pfn.29.2019.09.14.23.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 23:05:26 -0700 (PDT)
Date:   Sat, 14 Sep 2019 23:05:24 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mdio: switch to using gpiod_get_optional()
Message-ID: <20190915060524.GC237523@dtor-ws>
References: <20190913225547.GA106494@dtor-ws>
 <20190914170933.GV2680@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190914170933.GV2680@smile.fi.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 14, 2019 at 08:09:33PM +0300, Andy Shevchenko wrote:
> On Fri, Sep 13, 2019 at 03:55:47PM -0700, Dmitry Torokhov wrote:
> > The MDIO device reset line is optional and now that gpiod_get_optional()
> > returns proper value when GPIO support is compiled out, there is no
> > reason to use fwnode_get_named_gpiod() that I plan to hide away.
> > 
> > Let's switch to using more standard gpiod_get_optional() and
> > gpiod_set_consumer_name() to keep the nice "PHY reset" label.
> > 
> > Also there is no reason to only try to fetch the reset GPIO when we have
> > OF node, gpiolib can fetch GPIO data from firmwares as well.
> > 
> 
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Thanks Andy.

> 
> But see comment below.
> 

> > +	mdiodev->reset_gpio = gpiod_get_optional(&mdiodev->dev,
> > +						 "reset", GPIOD_OUT_LOW);
> > +	error = PTR_ERR_OR_ZERO(mdiodev->reset_gpio);
> > +	if (error)
> > +		return error;
> > +
> 
> > +	if (mdiodev->reset_gpio)
> 
> This is redundant check.

I see that gpiod_* API handle NULL desc and usually return immediately,
but frankly I am not that comfortable with it. I'm OK with functions
that free/destroy objects that recognize NULL resources, but it is
unusual for other types of APIs.

Thanks.

-- 
Dmitry
