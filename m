Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3EC06357CA
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 10:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238179AbiKWJpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 04:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238181AbiKWJpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 04:45:10 -0500
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877A476148;
        Wed, 23 Nov 2022 01:42:53 -0800 (PST)
Received: by mail-pl1-f176.google.com with SMTP id b21so16140518plc.9;
        Wed, 23 Nov 2022 01:42:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ctXaX1wsxi0J0COBH0p0jnAXJORMAFKcZCzCg0u1tEY=;
        b=M4JP5ePbWvzpfXGTnnNCOcaAfLUeqzsd1SEI1L2fhT5zNFqWodRbIETjnL1SzKv95V
         CUv4CM2puppXvgIrqGW20vAZx44PmShW8hWQuMDsYCfVlELMZQvhiqjbvkSOgH4R/MfE
         mbnAKS2VB1mm3NCgYYx9t1TvlA7fWGkW8Fc3d0zVCyQ/+UsP4zrtTpdZAYZsHRnATaaG
         8buPOnW7YAy4UvfWHH0Mpa3eK8vYivUfXmUv797/hifIIynbN7SMORblAgiYrmiArfdQ
         kV5Uy9AzTgnF9BnH25qNuJBakXkFGxmanCCPN128ZGcFxaWHyXcDj8Hhx1DwHHgzMYYC
         xSEg==
X-Gm-Message-State: ANoB5pnQwtVluGhZCgkoPZW3gCRQWHzkYRb4loWbXqqD/A8Ik3dwzqOP
        BeeypttvIqw1xTFCfMjsPpN/Be6fl7NcyTkJwM2PYOB1iRfb2Q==
X-Google-Smtp-Source: AA0mqf7VbP3uJ29EQwXTBUB5z286ZI7glbGcqHNZLqyhYA0bummhEdDtjjN/a5p4qRyu6dlszJaCzKjNZh08QPiwQAI=
X-Received: by 2002:a17:90a:8a07:b0:20a:c032:da66 with SMTP id
 w7-20020a17090a8a0700b0020ac032da66mr34830700pjn.19.1669196572798; Wed, 23
 Nov 2022 01:42:52 -0800 (PST)
MIME-Version: 1.0
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr> <20221122201246.0276680f@kernel.org>
In-Reply-To: <20221122201246.0276680f@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 23 Nov 2022 18:42:41 +0900
Message-ID: <CAMZ6RqJ8_=h1SS7WmBeEB=75wsvVUZrb-8ELCDtpZb0gSs=2+A@mail.gmail.com>
Subject: Re: [RFC PATCH] net: devlink: devlink_nl_info_fill: populate default information
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 23 Nov. 2022 at 13:12, Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 23 Nov 2022 00:49:34 +0900 Vincent Mailhol wrote:
> >  static int
> >  devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
> >                    enum devlink_command cmd, u32 portid,
> >                    u32 seq, int flags, struct netlink_ext_ack *extack)
> >  {
> >       struct devlink_info_req req = {};
> > +     struct device *dev = devlink_to_dev(devlink);
>
> nit: longest to shortest lines

I was not aware of this convention. Thanks for the hint.

> >       void *hdr;
> >       int err;
> >
> > @@ -6707,6 +6733,16 @@ devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
> >       if (err)
> >               goto err_cancel_msg;
> >
> > +     err = devlink_nl_driver_info_get(dev->driver, &req);
> > +     if (err)
> > +             goto err_cancel_msg;
>
> won't this result in repeated attributes, potentially?

You are right. It will because nla_put() doesn't check if an attribute
already exists and unconditionally reserves new space:
https://elixir.bootlin.com/linux/v6.0/source/lib/nlattr.c#L993

> Unlike ethtool which copies data into a struct devlink
> adds an attribute each time you request. It does not override.
> So we need to extend req with some tracking of whether driver
> already put in the info in question

I see three solutions:

1/ Do it in the core, clean up all drivers using
devlink_info_driver_name_put() and make the function static (i.e.
forbid the drivers to set the driver name themselves).
N.B. This first solution does not work for
devlink_info_serial_number_put() because the core will not always be
able to provide a default value (e.g. my code only covers USB
devices).

2/ Keep track of which attribute is already set (as you suggested).

3/ Do a function devlink_nl_info_fill_default() and let the drivers
choose to either call that function or set the attributes themselves.

I would tend to go with a mix of 1/ and 2/.

What do you think?

> > +     if (!strcmp(dev->parent->type->name, "usb_device")) {
> > +             err = devlink_nl_usb_info_get(to_usb_device(dev->parent), &req);
> > +             if (err)
> > +                     goto err_cancel_msg;
> > +     }
