Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D8B621F8C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiKHWwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiKHWwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:52:11 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBAD6035C
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:52:10 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id k12-20020a4ab08c000000b0049e2ab19e04so2244077oon.6
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 14:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wLdAzU49SZq9M459aaz8CUUT1910+9mTguJHs0nfUT8=;
        b=EzWZKK2P/akaLlvBoaNeqRfZeHsjyqB9xVrxlmWUvHdyzdAA+QJ5YW6MSZVwAK+/TC
         QjW0a8gQui3YJ9VJ+AxjBm0fCjYn5aG9Rdwi6boSmrBJ6gzNNdJu4T5ObTDUQsckI1t2
         wDhzMu4Fprx2f7AjJ/4AF+08zrfZjAWQ9MjlqWuboMFmQE8tDlr6Dh4uabKzB7CvskSd
         wu0XyHPKnftCSo00zHFSBeBHF6duuL771OYjXUPm4+Qb+Q+CG22DpHt57qeqw4FB2bxY
         9YMAMdQCvI5WU7kQ2B9Xmn+53OHl4TGHEZ+5fJHTlx2+ZCFDELLnaAuzQpj9dzg+X9DP
         6lSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wLdAzU49SZq9M459aaz8CUUT1910+9mTguJHs0nfUT8=;
        b=z0CqijPQXfA5DUljhWraWv77z8rgwuBzUvRWnu5Z+xGm+z1gMk0t2GfOPWJceqtaQ1
         AceZs3P9WpY3J4BoKJYZPZJg6Np4bEqJknHoHGUGJ/Md8AOtF7B5BHEudLnqVl3EZ1Kr
         hRUq+DY4vU3ri3f4vzJUfHv7X8xGwATSWuJORcGg7ufrhvpFHjP4+4MlZTedu5gZzCHs
         FVLJRhbi6x5ZY0Zr3Exq80V/uVRopArI013ghdPgVADdJX0F6UDnktbLR0tpKqZbPVma
         3063mqMYf/Xl8sYXAfaUMXE2zeuazRH0JXX00ixjDHBpj61I0tIvLNj7RNXF5mUGVRk9
         OqhA==
X-Gm-Message-State: ACrzQf3BISgn/P5QL1fDKqNCSlz2MXmd/6PaIwZd/BtClol6zuAmxr7h
        LSAcvWN4vaxSx5jCPkqf+oNWZxG+boDhv9M5IbTCug==
X-Google-Smtp-Source: AMsMyM67uL9Vwb0LXkBs3Mk4QRfmDK1Hi5RL2Pq4JAnwXirDpZ9DdtQZGo5o5tRZ0mAPScsTN7a98BL7NBiQF1PzVYM=
X-Received: by 2002:a4a:9586:0:b0:448:5e55:a122 with SMTP id
 o6-20020a4a9586000000b004485e55a122mr24678402ooi.61.1667947928913; Tue, 08
 Nov 2022 14:52:08 -0800 (PST)
MIME-Version: 1.0
References: <20221104170422.979558-1-dvyukov@google.com> <20221107024604epcms2p174f8813f4e18607b93813021f5b048b0@epcms2p1>
 <CGME20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d@epcms2p6>
 <CACT4Y+aVXi5hWNMrYavfhmhr3+FVyJoq8KhzrLp1gJFiSCxpxg@mail.gmail.com> <20221108004316epcms2p63ff537496ef759cb0c734068bd58855c@epcms2p6>
In-Reply-To: <20221108004316epcms2p63ff537496ef759cb0c734068bd58855c@epcms2p6>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 8 Nov 2022 14:51:58 -0800
Message-ID: <CACT4Y+ZdkFV0--A2i3Q9H9_OnTzgfWVHJUJT13x0O3xNz3kiyQ@mail.gmail.com>
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

On Mon, 7 Nov 2022 at 16:43, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
>
> On Tue, Nov 8, 2022 at 3:38 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> > On Sun, 6 Nov 2022 at 18:46, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
> > >
> > > On Sat, Nov 5, 2022 at 2:04 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> > > > The current virtual nci driver is great for testing and fuzzing.
> > > > But it allows to create at most one "global" device which does not allow
> > > > to run parallel tests and harms fuzzing isolation and reproducibility.
> > > > Restructure the driver to allow creation of multiple independent devices.
> > > > This should be backwards compatible for existing tests.
> > >
> > > I totally agree with you for parallel tests and good design.
> > > Thanks for good idea.
> > > But please check the abnormal situation.
> > > for example virtual device app is closed(virtual_ncidev_close) first and then
> > > virtual nci driver from nci app tries to call virtual_nci_send or virtual_nci_close.
> > > (there would be problem in virtual_nci_send because of already destroyed mutex)
> > > Before this patch, this driver used virtual_ncidev_mode state and nci_mutex that isn't destroyed.
> >
> > I assumed nci core must stop calling into a driver at some point
> > during the driver destruction. And I assumed that point is return from
> > nci_unregister_device(). Basically when nci_unregister_device()
> > returns, no new calls into the driver must be made. Calling into a
> > driver after nci_unregister_device() looks like a bug in nci core.
> >
> > If this is not true, how do real drivers handle this? They don't use
> > global vars. So they should either have the same use-after-free bugs
> > you described, or they handle shutdown differently. We just need to do
> > the same thing that real drivers do.
> >
> > As far as I see they are doing the same what I did in this patch:
> > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/fdp/i2c.c#L343
> > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/usb.c#L354
> >
> > They call nci_unregister_device() and then free all resources:
> > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/main.c#L186
> >
> > What am I missing here?
>
> I'm not sure but I think they are little different.
> nfcmrvl uses usb_driver's disconnect callback function and fdp's i2c uses i2c_driver's remove callback function for unregister_device.
> But virtual_ncidev just uses file operation(close function) not related to driver.
> so Nci simulation App can call close function at any time.
> If Scheduler interrupts the nci core code right after calling virtual_nci_send and then
> other process or thread calls virtual_nci_dev's close function,
> we need to handle this problem in virtual nci driver.

Won't the same issue happen if nci send callback is concurrent with
USB/I2C driver disconnect?

I mean something internal to the USB subsystem cannot affect what nci
subsystem is doing, unless the USB driver calls into nci and somehow
notifies it that it's about to destroy the driver.

Is there anything USB/I2C drivers are doing besides calling
nci_unregister_device() to ensure that there are no pending nci send
calls? If yes, then we should do the same in the virtual driver. If
not, then all other drivers are the subject to the same use-after-free
bug.

But I assumed that nci_unregister_device() ensures that there are no
in-flight send calls and no future send calls will be issued after the
function returns.

> > > > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > > > Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> > > > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > > > Cc: netdev@vger.kernel.org
> > > >
> > > > ---
> > > > Changes in v3:
> > > >  - free vdev in virtual_ncidev_close()
> > > >
> > > > Changes in v2:
> > > >  - check return value of skb_clone()
> > > >  - rebase onto currnet net-next
> > > > ---
> > > >  drivers/nfc/virtual_ncidev.c | 147 +++++++++++++++++------------------
> > > >  1 file changed, 71 insertions(+), 76 deletions(-)
> > > >
> > > > diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
> > > > index 85c06dbb2c449..bb76c7c7cc822 100644
> > > > --- a/drivers/nfc/virtual_ncidev.c
> > > > +++ b/drivers/nfc/virtual_ncidev.c
> > > > @@ -13,12 +13,6 @@
> > > >
> > > >  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> > > >  {
> > > > -     mutex_lock(&nci_mutex);
> > > > -     if (state != virtual_ncidev_enabled) {
> > > > -             mutex_unlock(&nci_mutex);
> > > > +     struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> > > > +
> > > > +     mutex_lock(&vdev->mtx);
> > >
> > >   I think this vdev and vdev->mtx are already destroyed so that it would be problem.
> > >
> > > > +     if (vdev->send_buff) {
> > > > +             mutex_unlock(&vdev->mtx);
> > > >               kfree_skb(skb);
> > > > -             return 0;
> > > > +             return -1;
> > > >       }
> > > >
> > > >
> > > >  static int virtual_ncidev_close(struct inode *inode, struct file *file)
> > > >  {
> > > > -     mutex_lock(&nci_mutex);
> > > > -
> > > > -     if (state == virtual_ncidev_enabled) {
> > > > -             state = virtual_ncidev_disabling;
> > > > -             mutex_unlock(&nci_mutex);
> > > > +     struct virtual_nci_dev *vdev = file->private_data;
> > > >
> > > > -             nci_unregister_device(ndev);
> > > > -             nci_free_device(ndev);
> > > > -
> > > > -             mutex_lock(&nci_mutex);
> > > > -     }
> > > > -
> > > > -     state = virtual_ncidev_disabled;
> > > > -     mutex_unlock(&nci_mutex);
> > > > +     nci_unregister_device(vdev->ndev);
> > > > +     nci_free_device(vdev->ndev);
> > > > +     mutex_destroy(&vdev->mtx);
> > > > +     kfree(vdev);
> > > >
> > > >       return 0;
> > > >  }
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/20221108004316epcms2p63ff537496ef759cb0c734068bd58855c%40epcms2p6.
