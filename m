Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D4F4497F8
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 16:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237357AbhKHPTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 10:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhKHPTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 10:19:04 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4BBC061570;
        Mon,  8 Nov 2021 07:16:19 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id o8so63794735edc.3;
        Mon, 08 Nov 2021 07:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c1o8VuFV0ex5mfdL4xyBALnF6n9F6qHpOK09h+9rf8g=;
        b=H27fZX1z/J39dmx5ZvhB+Zjd/Ahz3nOLNMPA8vLb8Xm2jJ5NNDOIMTtHe090eOtOFU
         DD/UFLFvddxNItBc/qNVrzgLM6s1d5nsbc2ES0evNQ/4s+72n9mcaXT8RZv4BAF1RY7b
         szvrS6jfzexdx1T0N3WH4x2FaM6GOZHKStAmaO5A0sC6qsgJTzq/XVKQsAug0VRcYzII
         pbrCWxDiWV2Z6iJos5t6YZ3i3NRnMBhkA9iIjCLQtZl6xCLBChO26K5O3b/CAydNqhOg
         IHtuS/bODnqA6Ck7F1ffSd98H9bH6xwC4SPb+E4MDBdZBYGszCkHQaKIMFM1Xu9qxZX/
         DhTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c1o8VuFV0ex5mfdL4xyBALnF6n9F6qHpOK09h+9rf8g=;
        b=3bswvzK28r6EXMOtC4iJzId/TQ4tii5U+EAu8MIHH8Im0ghIUxKzEtLxHTWcQh/jPi
         UZO85VgRzH3G+mWxmd59VoMawiJG07RH4cOujp7YwPrKD9A0mJY2XxEibqSexDoaButD
         tJWSX2SiZFAxpLpGz0Arv4XOLz18YG9cefk/PVXhj8hwgvXmgQ5411pVbR3wsxFVkZk4
         +uV8gvAUo+EEE0b58d9NXrnpbeudCq44lB8cXzaxQhPysVHNTkfGL0PngV1dIcxjloaS
         bmeDtk6jhfYsQST/zYz+NVlUMV/Er+f3X2Emh+H8mf9GJlE1WEgOuKyc6ws5YM3ePCl9
         q/9Q==
X-Gm-Message-State: AOAM531xxhCvjChCJR0P82yOyCz3MHmCyK3R7Ppi1TKnDjxci+jV/BKl
        +XS6ZE1nyFdtAYDHLOZkg/M=
X-Google-Smtp-Source: ABdhPJwjEyIFnc/Rjx2b9L48SpZXLmyPNORFLclvTaJrHwA6uQV6fc9x3apU8YExeVxFBkzNqYyUVw==
X-Received: by 2002:a17:906:c156:: with SMTP id dp22mr103436ejc.168.1636384578278;
        Mon, 08 Nov 2021 07:16:18 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id n1sm9216809edf.45.2021.11.08.07.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 07:16:18 -0800 (PST)
Date:   Mon, 8 Nov 2021 16:16:13 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [RFC PATCH v2 1/5] leds: trigger: add API for HW offloading of
 triggers
Message-ID: <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-2-ansuelsmth@gmail.com>
 <YYkuZwQi66slgfTZ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYkuZwQi66slgfTZ@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 03:04:23PM +0100, Andrew Lunn wrote:
> > +static inline int led_trigger_offload(struct led_classdev *led_cdev)
> > +{
> > +	int ret;
> > +
> > +	if (!led_cdev->trigger_offload)
> > +		return -EOPNOTSUPP;
> > +
> > +	ret = led_cdev->trigger_offload(led_cdev, true);
> > +	led_cdev->offloaded = !ret;
> > +
> > +	return ret;
> > +}
> > +
> > +static inline void led_trigger_offload_stop(struct led_classdev *led_cdev)
> > +{
> > +	if (!led_cdev->trigger_offload)
> > +		return;
> > +
> > +	if (led_cdev->offloaded) {
> > +		led_cdev->trigger_offload(led_cdev, false);
> > +		led_cdev->offloaded = false;
> > +	}
> > +}
> > +#endif
> 
> I think there should be two calls into the cdev driver, not this
> true/false parameter. trigger_offload_start() and
> trigger_offload_stop().
> 

To not add too much function to the struct, can we introduce one
function that both enable and disable the hw mode?

> There are also a number of PHYs which don't allow software blinking of
> the LED. So for them, trigger_offload_stop() is going to return
> -EOPNOTSUPP. And you need to handle that correctly.
> 

So we have PHYs that can only work in offload or off. Correct?

> It would be go to also document the expectations of
> trigger_offload_stop(). Should it leave the LED in whatever state it
> was, or force it off? 
>

I think it should be put off. Do you agree? (also the brightness should
be set to 0 in this case)

>      Andrew

-- 
	Ansuel
