Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84BD04C2833
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 10:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbiBXJfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 04:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbiBXJfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 04:35:44 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A1A27AA31
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 01:35:10 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id q9so1492643vsg.2
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 01:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=06cthm/8HOTevPAsTnymvgqwP2BjObRzPok5tZXuN/Y=;
        b=VZhr56ZzyZlXQYKIsPFYvntst5jFnBtcME+DtWFZa1BIFMTu6P3EvN40YZHvnxRzZ6
         ErAPf11mc3Wx3YIgMsCpSTWSzRtDU57L/dz4BPY6M6x/QZXXxH9xgNGKDeQLBHw/d6ts
         Y2mzILXSvHlBurjv0Klm6s9Q4OC2lwoQz3ZOeQZvvN2IhsK1wVD+MIN7JUrFlLQf0wro
         wClv9QXFnrleRsj/PWZsjRFc6YP07sJntiRm5V6dwN/hG98mcsylIeNTydDCUMDCkptp
         7siGW/IPtCj7/abKAHmYLtxvF/cBNZof4Y2gkagmcGUVFji7JWo+wO8Wd44AQYYwZarm
         dmEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=06cthm/8HOTevPAsTnymvgqwP2BjObRzPok5tZXuN/Y=;
        b=a7+LbUN5UbOIWMuMAXilYSDDXfph+9JlAg3kG2kb4NoLPyMK98HTv5EC36AondzJ1H
         EeMFwcBNr+rjmbGIzSX23BZTM7Pnx2byRYoGg/1rFzS/Lbtbehjv8iy0p9f/9w/+Vs6w
         H3qqzY+Q/WoJVOQ9UrktkTj+NE2+eKzOtgqcO63SETBsE1rjbcZN2fPEho0cFJmR37nO
         lorx4bQSNnjBtKPqAKE5q1oKSXGSy4cBhieDRI1wBNlZvNuAlBkwSLIw+FbTORRsfGRK
         fv+Qaq/xw/r4q0PeCxpcR8i/wARjcxpqiNhYKn2l2vluncg66vpJJOKFIkaMC07/MCwY
         89vA==
X-Gm-Message-State: AOAM531qUVsq4B8p+O08jbN6rijjCtw4fl+Fr1cqntZbGLydfNlbGIyR
        JWg6HcLxj4Tdu4sBdja6ol357dqUl1haPWkE4Ic=
X-Google-Smtp-Source: ABdhPJwoGKVd49gx93XN/yU4JPwLYA54f8+OnxGrVwh98dBadNwFA0CHcbPjjeiwA2JuWQduG/9bf2v3y6VQCXxnKHg=
X-Received: by 2002:a67:c206:0:b0:31b:43f1:c34f with SMTP id
 i6-20020a67c206000000b0031b43f1c34fmr624561vsj.52.1645695309632; Thu, 24 Feb
 2022 01:35:09 -0800 (PST)
MIME-Version: 1.0
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
 <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com> <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
 <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com> <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
 <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com> <CALeDE9PK9JkFkbTc36HOZH8CG8MM3OMhKJ24FKioKF5bspSPkA@mail.gmail.com>
 <6cefe7ca-842b-d3af-0299-588b9307703b@gmail.com>
In-Reply-To: <6cefe7ca-842b-d3af-0299-588b9307703b@gmail.com>
From:   Peter Robinson <pbrobinson@gmail.com>
Date:   Thu, 24 Feb 2022 09:34:58 +0000
Message-ID: <CALeDE9NbcutJ4Hihf2_0rOVxLATs5xq0qFjZpq6Zbzmq6Sgsng@mail.gmail.com>
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 2/23/2022 9:45 AM, Peter Robinson wrote:
> >>> The top two are pre/post plugging an ethernet cable with the patched
> >>> kernel, the last two are the broken kernel. There doesn't seem to be a
> >>> massive difference in interrupts but you likely know more of what
> >>> you're looking for.
> >>
> >> There is not a difference in the hardware interrupt numbers being
> >> claimed by GENET which are both GIC interrupts 189 and 190 (157 + 32 and
> >> 158 + 32). In the broken case we can see that the second interrupt line
> >> (interrupt 190), which is the one that services the non-default TX
> >> queues does not fire up at all whereas it does in the patched case.
> >>
> >> The transmit queue timeout makes sense given that transmit queue 2
> >> (which is not the default one, default is 0) has its interrupt serviced
> >> by the second interrupt line (190). We can see it not firing up, hence
> >> the timeout.
> >>
> >> What I *think* might be happening here is the following:
> >>
> >> - priv->wol_irq = platform_get_irq_optional(pdev, 2) returns a negative
> >> error code we do not install the interrupt handler for the WoL interrupt
> >> since it is not valid
> >>
> >> - bcmgenet_set_wol() is called, we do not check priv->wol_irq, so we
> >> call enable_irq_wake(priv->wol_irq) and somehow irq_set_irq_wake() is
> >> able to resolve that irq number to a valid interrupt descriptor
> >>
> >> - eventually we just mess up the interrupt descriptor for interrupt 49
> >> and it stops working
> >>
> >> Now since this appears to be an ACPI-enabled system, we may be hitting
> >> this part of the code in platform_get_irq_optional():
> >>
> >>             r = platform_get_resource(dev, IORESOURCE_IRQ, num);
> >>             if (has_acpi_companion(&dev->dev)) {
> >>                     if (r && r->flags & IORESOURCE_DISABLED) {
> >>                             ret = acpi_irq_get(ACPI_HANDLE(&dev->dev),
> >> num, r);
> >>                             if (ret)
> >>                                     goto out;
> >>                     }
> >>             }
> >>
> >> and then I am not clear what interrupt this translates into here, or
> >> whether it is possible to get a valid interrupt descriptor here.
> >>
> >> The patch is fine in itself, but I would really prefer that we get to
> >> the bottom of this rather than have a superficial understanding of the
> >> nature of the problem.
> >
> > I have no problems working with you to improve the driver, the problem
> > I have is this is currently a regression in 5.17 so I would like to
> > see something land, whether it's reverting the other patch, landing
> > thing one or another straight forward fix and then maybe revisit as
> > whole in 5.18.
>
> Understood and I won't require you or me to complete this investigating
> before fixing the regression, this is just so we understand where it
> stemmed from and possibly fix the IRQ layer if need be. Given what I
> just wrote, do you think you can sprinkle debug prints throughout the
> kernel to figure out whether enable_irq_wake() somehow messes up the
> interrupt descriptor of interrupt and test that theory? We can do that
> offline if you want.

Yes, I can do that, may be quicker if you send me a rough patch of the
debugs you like as that'll be likely less round trips, happy to deal
offline.

P
