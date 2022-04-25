Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21FE50E474
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 17:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242861AbiDYPel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 11:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiDYPej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 11:34:39 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF3121E10
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 08:31:35 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2f7b815ac06so76291477b3.3
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 08:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vy+FB21WXrBXjQ7F21tozMnmRPeb2Mm/IpFcaIVxQSw=;
        b=GUbwhbPNG/ldAA8IoCHi7UFAoND3RQKCpofkGvoh8U2QqpirtbKYJKVVt521kADxZh
         KopAssBml+OO+pGIL+UbHCpWBr5tLjnz5we4F/iWJkRGG6RAMqXU8JldJ/c3coB9zJoi
         IyKvaMBek64xjb1i4q5yujH/ZVxCnUDviCMOQTRcZt4CVh5WyQoHIPxYEHt58u1pFgTt
         yogAsTA89/oTgZJDYym8X17EzpqJDfYhhoQNSqOgztAHSWstA6nPAdH0s4UMZjTBC1zQ
         buMlo0zDwHTk+aRPTEJPBdcZzFHQy5jJ/a/YtKxWANF+c5uH2BaDm3ruxyqdVPCiDgpm
         NoPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vy+FB21WXrBXjQ7F21tozMnmRPeb2Mm/IpFcaIVxQSw=;
        b=zncmssY+YAPIwd/lOUOWIwHBUvM0BMAwwlshvymyc+pxa6MHY0AEw4Pda9yxIybMFH
         KrxKdXZRClFWbGFCLMcsaXhIo//Lu0upBN92NY/QqZiZUOQWMq0gbdAALyUylOpFh6AD
         7Q6No+QeGQRhsusbludOq3TD/y5Pt6VAmnmwc/ES1idGFuyjv8fqXozmgVXCZaclicsg
         AYl0ARJzE2qMi82BfDIUZvwHrOLnBbvuTjNIq12ccC4/6lMm0w5zvjukuE2WYNOMc4rZ
         CpeTwfRhO//zKoc/TP6Z4HzuRtelegFLKB4gWRisQkn7SCauhXqqWn5s4PsrdMuyAfXu
         vCRg==
X-Gm-Message-State: AOAM532SfBRTdOVeYCpCPD0/OaWSBQd9PH0Q7yUo3h0ASzCsyiLxNIMf
        7w/4ik+561vsMA3f/RHY7sIq7lWOrYOfbgGo6k219w==
X-Google-Smtp-Source: ABdhPJzwiVMiukfqAVkXa10l+bUV9EmJAU94RikfESe36Px23CtYTAW/0ubzxUOIF1dONV+BbHZA7ZkjcMzMIZ4okw4=
X-Received: by 2002:a81:1d4e:0:b0:2f7:be8b:502e with SMTP id
 d75-20020a811d4e000000b002f7be8b502emr12689770ywd.278.1650900694807; Mon, 25
 Apr 2022 08:31:34 -0700 (PDT)
MIME-Version: 1.0
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
 <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
 <20220423160723.GA20330@wunner.de> <20220425074146.1fa27d5f@kernel.org>
 <CAG48ez3ibQjhs9Qxb0AAKE4-UZiZ5UdXG1JWcPWHAWBoO-1fVw@mail.gmail.com>
 <20220425080057.0fc4ef66@kernel.org> <CANn89iLwvqUJHBNifLESJyBQ85qjK42sK85Fs=QV4M7HqUXmxQ@mail.gmail.com>
 <20220425082804.209e3676@kernel.org>
In-Reply-To: <20220425082804.209e3676@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 25 Apr 2022 08:31:23 -0700
Message-ID: <CANn89iJPs13ndN3PCs6KDAetMUg7N5RzG9_ixvQCmswmcN28mw@mail.gmail.com>
Subject: Re: [PATCH] net: linkwatch: ignore events for unregistered netdevs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jann Horn <jannh@google.com>, Lukas Wunner <lukas@wunner.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 8:28 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 25 Apr 2022 08:13:40 -0700 Eric Dumazet wrote:
> > dev_hold() has been an increment of a refcount, and dev_put() a decrement.
> >
> > Not sure why it is fundamentally broken.
>
> Jann described a case where someone does
>
>     CPU 0      CPU 1     CPU 2
>
>   dev_hold()
>    ------  #unregister -------
>              dev_hold()
>                          dev_put()
>
> Our check for refcount == 0 goes over the CPUs one by one,
> so if it sums up CPUs 0 and 1 at the "unregister" point above
> and CPU2 after the CPU1 hold and CPU2 release it will "miss"
> one refcount.
>
> That's a problem unless doing a dev_hold() on a netdev we only have
> a reference on is illegal.

What is 'illegal' is trying to keep using the device after #unregister.

We have barriers to prevent that.

Somehow a layer does not care about the barriers and pretends the
device is still good to use.

It is of course perfectly fine to stack multiple dev_hold() from one
path (if these do not leak, but this is a different issue)

>
> > There are specific steps at device dismantles making sure no more
> > users can dev_hold()
> >
> > It is a contract. Any buggy layer can overwrite any piece of memory,
> > including a refcount_t.
> >
> > Traditionally we could not add a test in dev_hold() to prevent an
> > increment if the device is in dismantle phase.
> > Maybe the situation is better nowadays.


>
