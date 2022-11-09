Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954D56220ED
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 01:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiKIAmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 19:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKIAms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 19:42:48 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C21212743
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 16:42:47 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1322d768ba7so18124002fac.5
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 16:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EpBhVhsKSsYBozYDBfOX8/c2UzQg46SgM46qi724w4I=;
        b=myBkAdnz0Y5aHxk6nI7Hc7FILqZ+ZlzXKq1q38IA1MrgsyOSYRSq/y4POrCYD4D1hs
         34s3zLFBJaa73NH8NX4L5CuYToz1HfYzxBAAmj4gIA0cm1xMw5dDRDPE2y7oc+AHwaac
         bsHrsv7C/ZLGZ9h236qz9t+k59tVpo/lcdp3b6D74eFgiZMzkZ09p9BnlgYdH/Sx0HqJ
         uhygTRc8KP7Z86f0c4XAaUKfhFlPuo7YqKFr7wkDmYXdG3PT4uQJzAl+SPAsIqpEwrYw
         HBVKGGTOZrsTjBvHah3H7z/n12ynNDOzIVLDu5XILxxB87XRFJO5bIqHtpfjEsDFAhrR
         Mhyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EpBhVhsKSsYBozYDBfOX8/c2UzQg46SgM46qi724w4I=;
        b=SkOQn5QRdcBiofS0VcewEjn5PwU6XSN7Gi0grd8WCIASvCDIDQnUXId6GispySXCY+
         Bp3ThLAnYPYerMFDI2AMflRPo3HmOO9OvQtnaSDTdxOGhej4JhK75Cps3Fgcj9CBmWRR
         8AhVi4+L6xvbf9ayGarAN7qihW4MkCS/tEzeOYifPjVDY2Yiokldd2Mj52vp+fYFmc0g
         RzZiRPt2ZvM/o7ahxqVcVfFO24xuVJedL+8jEfBYnEgJO7HLDrJqUOwbWEXae7OS5LJo
         NdORIYr3QB8d5UnaC6SxGL0F1K2KghjBGy1CqchiglG1k+GX1duMF2RMaLJuv32k/28M
         NFeA==
X-Gm-Message-State: ACrzQf1guQrS2hNhHq7W/T/PKPm5sFLvJoN2+el8tUzsS/YrFhnMgT47
        DvTgPuOKEkmHCGvc0VybFWyvWSn38rh/O22Qc9r4aw==
X-Google-Smtp-Source: AMsMyM5ywdL8iO4onHPbHZlXTVtPpIF2Ti8VnPpl5UkXfxmPxFwYcXklMSvhAXw7kBx3QO4Sl+H5m4m4NKtGvpbCT9o=
X-Received: by 2002:a05:6870:b6a3:b0:13b:f4f1:7dec with SMTP id
 cy35-20020a056870b6a300b0013bf4f17decmr34704934oab.282.1667954566210; Tue, 08
 Nov 2022 16:42:46 -0800 (PST)
MIME-Version: 1.0
References: <20221104170422.979558-1-dvyukov@google.com> <20221107024604epcms2p174f8813f4e18607b93813021f5b048b0@epcms2p1>
 <CACT4Y+aVXi5hWNMrYavfhmhr3+FVyJoq8KhzrLp1gJFiSCxpxg@mail.gmail.com>
 <20221108004316epcms2p63ff537496ef759cb0c734068bd58855c@epcms2p6>
 <CGME20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d@epcms2p5>
 <CACT4Y+ZdkFV0--A2i3Q9H9_OnTzgfWVHJUJT13x0O3xNz3kiyQ@mail.gmail.com> <20221109003457epcms2p558755edeebc687dba23195ce5b1935c7@epcms2p5>
In-Reply-To: <20221109003457epcms2p558755edeebc687dba23195ce5b1935c7@epcms2p5>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 8 Nov 2022 16:42:34 -0800
Message-ID: <CACT4Y+YQB_HU-fwwUHd=NBX5PM2ADhcfgO7QBwRXD7gZVGg=vA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] nfc: Allow to create multiple virtual nci devices
To:     bongsu.jeon@samsung.com
Cc:     "leon@kernel.org" <leon@kernel.org>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
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

On Tue, 8 Nov 2022 at 16:35, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
> > > > > On Sat, Nov 5, 2022 at 2:04 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> > > > > > The current virtual nci driver is great for testing and fuzzing.
> > > > > > But it allows to create at most one "global" device which does not allow
> > > > > > to run parallel tests and harms fuzzing isolation and reproducibility.
> > > > > > Restructure the driver to allow creation of multiple independent devices.
> > > > > > This should be backwards compatible for existing tests.
> > > > >
> > > > > I totally agree with you for parallel tests and good design.
> > > > > Thanks for good idea.
> > > > > But please check the abnormal situation.
> > > > > for example virtual device app is closed(virtual_ncidev_close) first and then
> > > > > virtual nci driver from nci app tries to call virtual_nci_send or virtual_nci_close.
> > > > > (there would be problem in virtual_nci_send because of already destroyed mutex)
> > > > > Before this patch, this driver used virtual_ncidev_mode state and nci_mutex that isn't destroyed.
> > > >
> > > > I assumed nci core must stop calling into a driver at some point
> > > > during the driver destruction. And I assumed that point is return from
> > > > nci_unregister_device(). Basically when nci_unregister_device()
> > > > returns, no new calls into the driver must be made. Calling into a
> > > > driver after nci_unregister_device() looks like a bug in nci core.
> > > >
> > > > If this is not true, how do real drivers handle this? They don't use
> > > > global vars. So they should either have the same use-after-free bugs
> > > > you described, or they handle shutdown differently. We just need to do
> > > > the same thing that real drivers do.
> > > >
> > > > As far as I see they are doing the same what I did in this patch:
> > > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/fdp/i2c.c#L343
> > > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/usb.c#L354
> > > >
> > > > They call nci_unregister_device() and then free all resources:
> > > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/main.c#L186
> > > >
> > > > What am I missing here?
> > >
> > > I'm not sure but I think they are little different.
> > > nfcmrvl uses usb_driver's disconnect callback function and fdp's i2c uses i2c_driver's remove callback function for unregister_device.
> > > But virtual_ncidev just uses file operation(close function) not related to driver.
> > > so Nci simulation App can call close function at any time.
> > > If Scheduler interrupts the nci core code right after calling virtual_nci_send and then
> > > other process or thread calls virtual_nci_dev's close function,
> > > we need to handle this problem in virtual nci driver.
> >
> > Won't the same issue happen if nci send callback is concurrent with
> > USB/I2C driver disconnect?
> >
> > I mean something internal to the USB subsystem cannot affect what nci
> > subsystem is doing, unless the USB driver calls into nci and somehow
> > notifies it that it's about to destroy the driver.
> >
> > Is there anything USB/I2C drivers are doing besides calling
> > nci_unregister_device() to ensure that there are no pending nci send
> > calls? If yes, then we should do the same in the virtual driver. If
> > not, then all other drivers are the subject to the same use-after-free
> > bug.
> >
> > But I assumed that nci_unregister_device() ensures that there are no
> > in-flight send calls and no future send calls will be issued after the
> > function returns.
>
> Ok, I understand your mention. you mean that nci_unregister_device should prevent
> the issue using dev lock or other way. right?

Yes.

> It would be better to handle the issue in nci core if there is.

And yes.

Krzysztof, can you confirm this is the case (nci core won't call
ops->send callback after nci_unregister_device() returns)?



> > > > > > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > > > > > Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> > > > > > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > > > > > Cc: netdev@vger.kernel.org
> > > > > >
> > > > > > ---
> > > > > > Changes in v3:
> > > > > >  - free vdev in virtual_ncidev_close()
> > > > > >
> > > > > > Changes in v2:
> > > > > >  - check return value of skb_clone()
> > > > > >  - rebase onto currnet net-next
> > > > > > ---
> > > > > >  drivers/nfc/virtual_ncidev.c | 147 +++++++++++++++++------------------
> > > > > >  1 file changed, 71 insertions(+), 76 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
> > > > > > index 85c06dbb2c449..bb76c7c7cc822 100644
> > > > > > --- a/drivers/nfc/virtual_ncidev.c
> > > > > > +++ b/drivers/nfc/virtual_ncidev.c
> > > > > > @@ -13,12 +13,6 @@
> > > > > >
> > > > > >  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> > > > > >  {
> > > > > > -     mutex_lock(&nci_mutex);
> > > > > > -     if (state != virtual_ncidev_enabled) {
> > > > > > -             mutex_unlock(&nci_mutex);
> > > > > > +     struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> > > > > > +
> > > > > > +     mutex_lock(&vdev->mtx);
> > > > >
> > > > >   I think this vdev and vdev->mtx are already destroyed so that it would be problem.
> > > > >
> > > > > > +     if (vdev->send_buff) {
> > > > > > +             mutex_unlock(&vdev->mtx);
> > > > > >               kfree_skb(skb);
> > > > > > -             return 0;
> > > > > > +             return -1;
> > > > > >       }
> > > > > >
> > > > > >
> > > > > >  static int virtual_ncidev_close(struct inode *inode, struct file *file)
> > > > > >  {
> > > > > > -     mutex_lock(&nci_mutex);
> > > > > > -
> > > > > > -     if (state == virtual_ncidev_enabled) {
> > > > > > -             state = virtual_ncidev_disabling;
> > > > > > -             mutex_unlock(&nci_mutex);
> > > > > > +     struct virtual_nci_dev *vdev = file->private_data;
> > > > > >
> > > > > > -             nci_unregister_device(ndev);
> > > > > > -             nci_free_device(ndev);
> > > > > > -
> > > > > > -             mutex_lock(&nci_mutex);
> > > > > > -     }
> > > > > > -
> > > > > > -     state = virtual_ncidev_disabled;
> > > > > > -     mutex_unlock(&nci_mutex);
> > > > > > +     nci_unregister_device(vdev->ndev);
> > > > > > +     nci_free_device(vdev->ndev);
> > > > > > +     mutex_destroy(&vdev->mtx);
> > > > > > +     kfree(vdev);
> > > > > >
> > > > > >       return 0;
> > > > > >  }
> >
