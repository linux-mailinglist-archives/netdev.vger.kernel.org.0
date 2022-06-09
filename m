Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5807C5454F4
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 21:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239914AbiFIT3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 15:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236347AbiFIT3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 15:29:50 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEA4232D81
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 12:29:48 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-30ec2aa3b6cso251418347b3.11
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 12:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HbcNyn+HuFJHLYrnJ6EuEvt+66n5lvubcLNAe9RjZOU=;
        b=AFugph41ubSXHoryjcn9zN9/Y2cQG8LpkjnjP7KA/6gxAEo6tx7yw+owOJLQJ7GRdj
         AKgvhnyfINe6Fm+FiL9XL4L81yzjkr7NGdTeY4zz7GQp6mZQ6gytLnvPlH7WtcUin1GU
         yx1uwAh7bMyGuUJDZbETE6j2RxETbqyAMcxTWH1EfgrXJ06AbU8ZHlLM8itKzwxtatsY
         n3bCV01x/wF5UQbMprXgWXgMUnaYlBapVZbq25diSf9SnVGY8Pea0V2ZRfioG7ONZO2r
         VBRjo4a+bwVjXI+yKamT9typkG7zIM8JryiY8d8QmOmviHIjZI3x52miRKJ9ZEzfG5XI
         483A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HbcNyn+HuFJHLYrnJ6EuEvt+66n5lvubcLNAe9RjZOU=;
        b=6JFjV7yYLIkFUw4ojKCIUZHIfL7fTRABUqJwPhilhtch/Pam28nHYTk9IzyLn8zC8P
         gZAONcXj08gxFrNLfuiqXWjtiwoIFJDO/HIH8AK9FocDHAEHjX2jKSuPNKY0gFxM/fAH
         tHD2KL3dYZEy4dcTA5ltNFl67+w4GxYi8MAjOSE0ngbhwOjU0nS0yczMFYnvjZWtmhwQ
         s9SBEUzG3Uwfa93H9ZnqZI8P468Ua+EokxIohC9Wd281gcyx+xzy8ed6uQ36KR1UPI61
         4PAtYjjVzBiXs54kkTkvwXLtBjqZNFWYfcksgP25jPDgPIsTGZcQrZFQqdc01wEVHhmI
         d1yw==
X-Gm-Message-State: AOAM530HKRNmn0CGncOkW+t3CRZ11kzy6CaIZaQs4RhRZjy6HK1XHpR/
        s3p0ULrEmw7iHxPikHNj3Gpo2WwgjjWJ7aT6HBT+Dw==
X-Google-Smtp-Source: ABdhPJyTAoRSU+Qa4z02/PWmP9RT6ooOnsyoWThxzzVkk4VpdwuVCgxr8qWarGWvAQ0mS4kZlsB0Jx5s9qGrxlCEhf0=
X-Received: by 2002:a81:830f:0:b0:313:3918:5cf with SMTP id
 t15-20020a81830f000000b00313391805cfmr16723753ywf.126.1654802987678; Thu, 09
 Jun 2022 12:29:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-2-saravanak@google.com> <CAPDyKFpZTmt71LgQ9vNE4_iRff-OBkDWkHrc7y9zQ7o_Z_UYFA@mail.gmail.com>
In-Reply-To: <CAPDyKFpZTmt71LgQ9vNE4_iRff-OBkDWkHrc7y9zQ7o_Z_UYFA@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 9 Jun 2022 12:29:11 -0700
Message-ID: <CAGETcx95P3iPOJs+qm9tNXHschbhf3LP0T0gwm_v6m2AOhzhDQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of driver_deferred_probe_check_state()
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 4:45 AM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> On Wed, 1 Jun 2022 at 09:07, Saravana Kannan <saravanak@google.com> wrote:
> >
> > Now that fw_devlink=on by default and fw_devlink supports
> > "power-domains" property, the execution will never get to the point
> > where driver_deferred_probe_check_state() is called before the supplier
> > has probed successfully or before deferred probe timeout has expired.
> >
> > So, delete the call and replace it with -ENODEV.
>
> With fw_devlink=on by default - does that mean that the parameter
> can't be changed?
>
> Or perhaps the point is that we don't want to go back, but rather drop
> the fw_devlink parameter altogether when moving forward?

Good question. For now, keeping fw_devlink=off and
fw_devlink=permissive as debugging options that I can ask people to
try if some probe is getting blocked.

Or maybe if some ultra low memory use case wants to avoid create
device links, fwnode links, etc and can build everything in and have
init/probe happen in the right order.

But in the long run, I see a strong possibility for
fw_devlink=off/permissive being removed. I'd still want to keep it for
implementing =rpm where it'd also automatically enable PM runtime
tracking, but I don't understand that well enough yet to do it by
default.

> >
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
>
> Just a minor nitpick below. Nevertheless, feel free to add:
>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Thanks!

>
> > ---
> >  drivers/base/power/domain.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> > index 739e52cd4aba..3e86772d5fac 100644
> > --- a/drivers/base/power/domain.c
> > +++ b/drivers/base/power/domain.c
> > @@ -2730,7 +2730,7 @@ static int __genpd_dev_pm_attach(struct device *dev, struct device *base_dev,
> >                 mutex_unlock(&gpd_list_lock);
> >                 dev_dbg(dev, "%s() failed to find PM domain: %ld\n",
> >                         __func__, PTR_ERR(pd));
> > -               return driver_deferred_probe_check_state(base_dev);
>
> Adding a brief comment about why -EPROBE_DEFER doesn't make sense
> here, would be nice.

Will do once all the reviews comeout/when I send v3.

I'm thinking something like:
/* fw_devlink will take care of retrying for missing suppliers */

-Saravana

>
> > +               return -ENODEV;
> >         }
> >
> >         dev_dbg(dev, "adding to PM domain %s\n", pd->name);
> > --
> > 2.36.1.255.ge46751e96f-goog
> >
>
> Kind regards
> Uffe
