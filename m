Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A4A62799A
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 10:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbiKNJyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 04:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236420AbiKNJyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 04:54:22 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62CF1E701
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:54:18 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-13be3ef361dso11866971fac.12
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M/jeHbtz7q/iudzSg3mZUKmISqWrx5O+uvUelUoHF5A=;
        b=JB62frqzYQ6Ld4kPY6fFaXo55nQZ9BZBvYXmHI4LQoqytHHHgWWoCwD6ACHRMjIlJF
         WsH3WWFKuo71fBZVxatESrVwQcncLQJb94EU9qXPHprMIWR0n7vGQdKl/xfRTnspJikA
         UCrpBxHzblEp3qs3aefAMp2mPUyROoDLY8u5MXpR1SdtTJBfFAyO+t00S5GbC2fJj0zZ
         JJMZoE3J3bhrioNpizxnaIt81ZaVOf882h2NHUEL/4JP1xrcOqGhsKKOcey1eo/uBmxa
         lT7uu1YqTOv2edek7Y6xdVYOuMATJx6nTLZImU4GX36m78+Wuw16l5JumPRr889w1WoY
         qOYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M/jeHbtz7q/iudzSg3mZUKmISqWrx5O+uvUelUoHF5A=;
        b=YRAaSwDqFSz0h7s0LlzLEUb6ry61ylFxY5S6xU62eRP1h5l5LO0LFWkjUR27pkwCim
         TRO+NbGko8ppE5g0wD3aKp07LK2JF5Y2URVkVPlCsE/+i0RIWKDrjpcRTuGi9TRsdS9D
         4NtzdXcgy/QEP7G7GixQJqVareAcTV+I2K/385zTdOxnxfdS6I1qP7TifbNIR+qAwRJ2
         guUHMHELHHlyhdGDANlpjhNYhmw8zbvew2zbAYBui5lXlNmWk07AElkOAt6kQlarSaZo
         7Rneg6vCK7Shz25AflgLXeDryQIjTCAXQaKZHN1fUd0CFwKyjp/biCRYodOUj6oaEa5C
         PjVg==
X-Gm-Message-State: ANoB5pldvQ3glMEUQSHAQpJVoC3I65EMMGyjjyCA2LJeIhHJsbnPCxNB
        3Vt89vgXX14rK+TnwEoouB667zPmjqobZMERbvYxIaYJmts7tdKh
X-Google-Smtp-Source: AA0mqf5k9PdUBFWvDu+3V4/UT+c7SNNjJmH236NWGurQjYsyuR4mxvvTKWLHphuJ+/mOMRMPXn/wLJSNKeoqHN85kR8=
X-Received: by 2002:a05:6870:bf0b:b0:13c:7d1c:5108 with SMTP id
 qh11-20020a056870bf0b00b0013c7d1c5108mr6319317oab.282.1668419657764; Mon, 14
 Nov 2022 01:54:17 -0800 (PST)
MIME-Version: 1.0
References: <20221104170422.979558-1-dvyukov@google.com> <20221107024604epcms2p174f8813f4e18607b93813021f5b048b0@epcms2p1>
 <CACT4Y+aVXi5hWNMrYavfhmhr3+FVyJoq8KhzrLp1gJFiSCxpxg@mail.gmail.com>
 <20221108004316epcms2p63ff537496ef759cb0c734068bd58855c@epcms2p6>
 <CACT4Y+ZdkFV0--A2i3Q9H9_OnTzgfWVHJUJT13x0O3xNz3kiyQ@mail.gmail.com>
 <20221109003457epcms2p558755edeebc687dba23195ce5b1935c7@epcms2p5>
 <CGME20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d@epcms2p4>
 <CACT4Y+YQB_HU-fwwUHd=NBX5PM2ADhcfgO7QBwRXD7gZVGg=vA@mail.gmail.com> <20221113233254epcms2p4a55e241336fd6f5d8868f00f9a8ed3ec@epcms2p4>
In-Reply-To: <20221113233254epcms2p4a55e241336fd6f5d8868f00f9a8ed3ec@epcms2p4>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 14 Nov 2022 10:54:06 +0100
Message-ID: <CACT4Y+ZuBJbooj6OLj9drHY6cB7pix1Osk0AUXdtG3G+SdqVFA@mail.gmail.com>
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

On Mon, 14 Nov 2022 at 00:32, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
> > > > > > > On Sat, Nov 5, 2022 at 2:04 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> > > > > > > > The current virtual nci driver is great for testing and fuzzing.
> > > > > > > > But it allows to create at most one "global" device which does not allow
> > > > > > > > to run parallel tests and harms fuzzing isolation and reproducibility.
> > > > > > > > Restructure the driver to allow creation of multiple independent devices.
> > > > > > > > This should be backwards compatible for existing tests.
> > > > > > >
> > > > > > > I totally agree with you for parallel tests and good design.
> > > > > > > Thanks for good idea.
> > > > > > > But please check the abnormal situation.
> > > > > > > for example virtual device app is closed(virtual_ncidev_close) first and then
> > > > > > > virtual nci driver from nci app tries to call virtual_nci_send or virtual_nci_close.
> > > > > > > (there would be problem in virtual_nci_send because of already destroyed mutex)
> > > > > > > Before this patch, this driver used virtual_ncidev_mode state and nci_mutex that isn't destroyed.
> > > > > >
> > > > > > I assumed nci core must stop calling into a driver at some point
> > > > > > during the driver destruction. And I assumed that point is return from
> > > > > > nci_unregister_device(). Basically when nci_unregister_device()
> > > > > > returns, no new calls into the driver must be made. Calling into a
> > > > > > driver after nci_unregister_device() looks like a bug in nci core.
> > > > > >
> > > > > > If this is not true, how do real drivers handle this? They don't use
> > > > > > global vars. So they should either have the same use-after-free bugs
> > > > > > you described, or they handle shutdown differently. We just need to do
> > > > > > the same thing that real drivers do.
> > > > > >
> > > > > > As far as I see they are doing the same what I did in this patch:
> > > > > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/fdp/i2c.c#L343
> > > > > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/usb.c#L354
> > > > > >
> > > > > > They call nci_unregister_device() and then free all resources:
> > > > > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/main.c#L186
> > > > > >
> > > > > > What am I missing here?
> > > > >
> > > > > I'm not sure but I think they are little different.
> > > > > nfcmrvl uses usb_driver's disconnect callback function and fdp's i2c uses i2c_driver's remove callback function for unregister_device.
> > > > > But virtual_ncidev just uses file operation(close function) not related to driver.
> > > > > so Nci simulation App can call close function at any time.
> > > > > If Scheduler interrupts the nci core code right after calling virtual_nci_send and then
> > > > > other process or thread calls virtual_nci_dev's close function,
> > > > > we need to handle this problem in virtual nci driver.
> > > >
> > > > Won't the same issue happen if nci send callback is concurrent with
> > > > USB/I2C driver disconnect?
> > > >
> > > > I mean something internal to the USB subsystem cannot affect what nci
> > > > subsystem is doing, unless the USB driver calls into nci and somehow
> > > > notifies it that it's about to destroy the driver.
> > > >
> > > > Is there anything USB/I2C drivers are doing besides calling
> > > > nci_unregister_device() to ensure that there are no pending nci send
> > > > calls? If yes, then we should do the same in the virtual driver. If
> > > > not, then all other drivers are the subject to the same use-after-free
> > > > bug.
> > > >
> > > > But I assumed that nci_unregister_device() ensures that there are no
> > > > in-flight send calls and no future send calls will be issued after the
> > > > function returns.
> > >
> > > Ok, I understand your mention. you mean that nci_unregister_device should prevent
> > > the issue using dev lock or other way. right?
> >
> > Yes.
> >
> > > It would be better to handle the issue in nci core if there is.
> >
> > And yes.
> >
> > Krzysztof, can you confirm this is the case (nci core won't call
> > ops->send callback after nci_unregister_device() returns)?
>
> I think we can add this to selftest to verify nci core.

I am not sure how the test for that particular scenario should look
like. It's only possible with concurrent syscalls, right? After
nci_unregister_device() returns and the virtual device fd is closed,
it's not possible to trigger the send callback, right?


> > > > > > > > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > > > > > > > Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> > > > > > > > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > > > > > > > Cc: netdev@vger.kernel.org
> > > > > > > >
> > > > > > > > ---
> > > > > > > > Changes in v3:
> > > > > > > >  - free vdev in virtual_ncidev_close()
> > > > > > > >
> > > > > > > > Changes in v2:
> > > > > > > >  - check return value of skb_clone()
> > > > > > > >  - rebase onto currnet net-next
> > > > > > > > ---
> > > > > > > >  drivers/nfc/virtual_ncidev.c | 147 +++++++++++++++++------------------
> > > > > > > >  1 file changed, 71 insertions(+), 76 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
> > > > > > > > index 85c06dbb2c449..bb76c7c7cc822 100644
> > > > > > > > --- a/drivers/nfc/virtual_ncidev.c
> > > > > > > > +++ b/drivers/nfc/virtual_ncidev.c
> > > > > > > > @@ -13,12 +13,6 @@
> > > > > > > >
> > > > > > > >  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> > > > > > > >  {
> > > > > > > > -     mutex_lock(&nci_mutex);
> > > > > > > > -     if (state != virtual_ncidev_enabled) {
> > > > > > > > -             mutex_unlock(&nci_mutex);
> > > > > > > > +     struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> > > > > > > > +
> > > > > > > > +     mutex_lock(&vdev->mtx);
> > > > > > >
> > > > > > >   I think this vdev and vdev->mtx are already destroyed so that it would be problem.
> > > > > > >
> > > > > > > > +     if (vdev->send_buff) {
> > > > > > > > +             mutex_unlock(&vdev->mtx);
> > > > > > > >               kfree_skb(skb);
> > > > > > > > -             return 0;
> > > > > > > > +             return -1;
> > > > > > > >       }
> > > > > > > >
> > > > > > > >
> > > > > > > >  static int virtual_ncidev_close(struct inode *inode, struct file *file)
> > > > > > > >  {
> > > > > > > > -     mutex_lock(&nci_mutex);
> > > > > > > > -
> > > > > > > > -     if (state == virtual_ncidev_enabled) {
> > > > > > > > -             state = virtual_ncidev_disabling;
> > > > > > > > -             mutex_unlock(&nci_mutex);
> > > > > > > > +     struct virtual_nci_dev *vdev = file->private_data;
> > > > > > > >
> > > > > > > > -             nci_unregister_device(ndev);
> > > > > > > > -             nci_free_device(ndev);
> > > > > > > > -
> > > > > > > > -             mutex_lock(&nci_mutex);
> > > > > > > > -     }
> > > > > > > > -
> > > > > > > > -     state = virtual_ncidev_disabled;
> > > > > > > > -     mutex_unlock(&nci_mutex);
> > > > > > > > +     nci_unregister_device(vdev->ndev);
> > > > > > > > +     nci_free_device(vdev->ndev);
> > > > > > > > +     mutex_destroy(&vdev->mtx);
> > > > > > > > +     kfree(vdev);
> > > > > > > >
> > > > > > > >       return 0;
> > > > > > > >  }
> > > >
