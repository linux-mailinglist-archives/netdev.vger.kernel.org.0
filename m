Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFC361FDB5
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbiKGSkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbiKGSjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:39:47 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4AB1D66E
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:38:35 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-13d9a3bb27aso12893068fac.11
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 10:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WGgA/jbKO4JQAAsJp9RT0dW94NCjKARWPEOvpL95HYE=;
        b=Uua6qgwrRWcza2QRHwHWLa3SZT99hdlAyqZwHc/vThkgGOKvj9V2HAXUKB2Oy8Ps5z
         SN2YM2+SNip4YVYfOQPe8OfXHPmKcPrDESzQmMUa3a6rh2xbplZ1kdASRiYhPvgvSjZN
         4GNPzllyoZ0bXwK+5sTI397llX1LJK0XQK3oM6/Skd4VIge3V3S+fHbv1Jayp//BxQNO
         ZFBNmHggBxfvT0I04WwoDCsYWejuSesjtFKK55HXhM7Xi0Q9LJJw4A1KKz4Ido4rJtl+
         tkUnQDXgQznWtkMBKSxHX0aPPy0SOMoUqDZfTTWnXzDxxYpyggoQaflZw+wWYM+8md17
         xHfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WGgA/jbKO4JQAAsJp9RT0dW94NCjKARWPEOvpL95HYE=;
        b=NhUA/vUolYZsNAveRa9Vxb9cp/sXCLQpV3E53ZbINXp7u5spSTxT7ZnijBY9oQpLa8
         yJfTvz9R7tQcVMQvFtwF9h+qxivfmQd5xEVAeFamdDqANa/jLXQZP1JDFQd3Effe7wHa
         Gcv8T2kfLXi8Y8xIKTvCkGS4tqd5qbobHm5YpbMUbg4lcdli5s0W+9vTcARz1l9s2Y/P
         q7GogHXo5LgQXSmJioQXXiPQPAXdqwTlUjCMuyE8HPiS4iBuv3jJ4Kq8FAPBl0Nciy+w
         6AwoLvMLeBBVCEOSs3TogGfzgyQoXPDTGHeS/p4cnRBRIp6kT3R5F59hDUgBRrmX2o2l
         8jUg==
X-Gm-Message-State: ACrzQf0R1mfXPar/BaglQN5ceWxscOYrKmtfA+i5J0M881nfj/B+tVfi
        EevdbQxUrz/6Q5eDkvKxoPlmexxDpFr4k1r2QrfHRA==
X-Google-Smtp-Source: AMsMyM5fGqHfNwMgVm5Lhwk1H6u/sTi8v26v9PbwH/88UUzkCtKBD3pPWrbafrYdkg3b4+mSHDvWRzKXigTiETl891c=
X-Received: by 2002:a05:6870:b6a3:b0:13b:f4f1:7dec with SMTP id
 cy35-20020a056870b6a300b0013bf4f17decmr30779188oab.282.1667846313926; Mon, 07
 Nov 2022 10:38:33 -0800 (PST)
MIME-Version: 1.0
References: <CGME20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d@epcms2p1>
 <20221104170422.979558-1-dvyukov@google.com> <20221107024604epcms2p174f8813f4e18607b93813021f5b048b0@epcms2p1>
In-Reply-To: <20221107024604epcms2p174f8813f4e18607b93813021f5b048b0@epcms2p1>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 7 Nov 2022 10:38:22 -0800
Message-ID: <CACT4Y+aVXi5hWNMrYavfhmhr3+FVyJoq8KhzrLp1gJFiSCxpxg@mail.gmail.com>
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

On Sun, 6 Nov 2022 at 18:46, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
>
> On Sat, Nov 5, 2022 at 2:04 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> > The current virtual nci driver is great for testing and fuzzing.
> > But it allows to create at most one "global" device which does not allow
> > to run parallel tests and harms fuzzing isolation and reproducibility.
> > Restructure the driver to allow creation of multiple independent devices.
> > This should be backwards compatible for existing tests.
>
> I totally agree with you for parallel tests and good design.
> Thanks for good idea.
> But please check the abnormal situation.
> for example virtual device app is closed(virtual_ncidev_close) first and then
> virtual nci driver from nci app tries to call virtual_nci_send or virtual_nci_close.
> (there would be problem in virtual_nci_send because of already destroyed mutex)
> Before this patch, this driver used virtual_ncidev_mode state and nci_mutex that isn't destroyed.

I assumed nci core must stop calling into a driver at some point
during the driver destruction. And I assumed that point is return from
nci_unregister_device(). Basically when nci_unregister_device()
returns, no new calls into the driver must be made. Calling into a
driver after nci_unregister_device() looks like a bug in nci core.

If this is not true, how do real drivers handle this? They don't use
global vars. So they should either have the same use-after-free bugs
you described, or they handle shutdown differently. We just need to do
the same thing that real drivers do.

As far as I see they are doing the same what I did in this patch:
https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/fdp/i2c.c#L343
https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/usb.c#L354

They call nci_unregister_device() and then free all resources:
https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/main.c#L186

What am I missing here?


> > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > Cc: netdev@vger.kernel.org
> >
> > ---
> > Changes in v3:
> >  - free vdev in virtual_ncidev_close()
> >
> > Changes in v2:
> >  - check return value of skb_clone()
> >  - rebase onto currnet net-next
> > ---
> >  drivers/nfc/virtual_ncidev.c | 147 +++++++++++++++++------------------
> >  1 file changed, 71 insertions(+), 76 deletions(-)
> >
> > diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
> > index 85c06dbb2c449..bb76c7c7cc822 100644
> > --- a/drivers/nfc/virtual_ncidev.c
> > +++ b/drivers/nfc/virtual_ncidev.c
> > @@ -13,12 +13,6 @@
> >
> >  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> >  {
> > -     mutex_lock(&nci_mutex);
> > -     if (state != virtual_ncidev_enabled) {
> > -             mutex_unlock(&nci_mutex);
> > +     struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> > +
> > +     mutex_lock(&vdev->mtx);
>
>   I think this vdev and vdev->mtx are already destroyed so that it would be problem.
>
> > +     if (vdev->send_buff) {
> > +             mutex_unlock(&vdev->mtx);
> >               kfree_skb(skb);
> > -             return 0;
> > +             return -1;
> >       }
> >
> >
> >  static int virtual_ncidev_close(struct inode *inode, struct file *file)
> >  {
> > -     mutex_lock(&nci_mutex);
> > -
> > -     if (state == virtual_ncidev_enabled) {
> > -             state = virtual_ncidev_disabling;
> > -             mutex_unlock(&nci_mutex);
> > +     struct virtual_nci_dev *vdev = file->private_data;
> >
> > -             nci_unregister_device(ndev);
> > -             nci_free_device(ndev);
> > -
> > -             mutex_lock(&nci_mutex);
> > -     }
> > -
> > -     state = virtual_ncidev_disabled;
> > -     mutex_unlock(&nci_mutex);
> > +     nci_unregister_device(vdev->ndev);
> > +     nci_free_device(vdev->ndev);
> > +     mutex_destroy(&vdev->mtx);
> > +     kfree(vdev);
> >
> >       return 0;
> >  }
