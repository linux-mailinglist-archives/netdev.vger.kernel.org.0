Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3A0613A35
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiJaPha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiJaPhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:37:10 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319EB11C05
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:37:09 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-13be3ef361dso13810052fac.12
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N+5dEbbYhiYoc39RID4TPmVvjFK4l48f9CPo5MTbddk=;
        b=KG7rN2mUSxOzd0zjAKn3zKmMyxEHwQKBxChz1lWo45MsfY3ZK2co0OCyF0hMf48XlT
         a5bfDFKVo51hMKK+AAugrsxHF1D9ZKFXtDi8LsgoXxsei4mZrrbWtsYdOwkkzeVoHrQr
         XAkFvr4xyI3bGFFjh9qimYQBpTLdQMKWCvfpdAHtHwYTVxmv8fJLWpVQfYp5ggS6yau8
         6OKfXzLLUFfRmcG3Il6/O64ncC5mlWT845oA1OrYGBz8o3GVITlOrShDe6YYrCF/k2LG
         BXssT55M137psEWyxPgeFhfWF8TnTY4gRsS4cUTYL/eOWkKMD34CxXaGTlGm4anJF1ne
         bnfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N+5dEbbYhiYoc39RID4TPmVvjFK4l48f9CPo5MTbddk=;
        b=DMcQJjeG90K9CA4dDE3nsB/gOqGOCoF84lvdVkWvWy/dbgbAaj7cmN0+3oSJW1c9eq
         1mTVXNCfYOBkTHyj84cxYNtRGsxkeqO4XXZmAIrJG63tNTgNmixSjuSEnPs5VRHaghZs
         +cNasjBuwgi9S+N94EXagLd988fmAUi0zU9/WgV6tBW2PPRWOcMC0jRrREhAQSpVibRs
         xVvIjr6BoazlJ5XuADBLA/vs5SiT5RhNG48ru3PxgqVIzficQSceDzLLg8ckAWVFyiX+
         PRQt5lr0A6RQXnpULDLTmbPinsrCdHLYs9m/h3hDKkqGTHtYiPWGqU9/2Om5rglqw1fK
         zMKw==
X-Gm-Message-State: ACrzQf3S7Y3pZEwnzvlLVR1fB0y3CX0Hu0g2SXm7S67MpZkwejzY21RP
        9vKO/qbknaxB1iAhH3YCoOFeXex/ksYJ8ZGBDyojSQ==
X-Google-Smtp-Source: AMsMyM5W/ycZlCKXHHAYtvGwgfT6Sz/C0PX5aFBHNpwo8oq6mYPINNFwwJhduylsFXIttg/BSn2HNReCtdfoHelmZ3Q=
X-Received: by 2002:a05:6870:ea8f:b0:13b:8dad:5895 with SMTP id
 s15-20020a056870ea8f00b0013b8dad5895mr17647561oap.233.1667230628278; Mon, 31
 Oct 2022 08:37:08 -0700 (PDT)
MIME-Version: 1.0
References: <20221030142919.3196780-1-dvyukov@google.com> <Y1+UHKsFbg46UEvM@unreal>
In-Reply-To: <Y1+UHKsFbg46UEvM@unreal>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 31 Oct 2022 08:36:57 -0700
Message-ID: <CACT4Y+Y=W2xazqDmrSFDS5ocbsc+H-ZAiHTD1era=dFR4V0gOA@mail.gmail.com>
Subject: Re: [PATCH] nfc: Allow to create multiple virtual nci devices
To:     Leon Romanovsky <leon@kernel.org>
Cc:     bongsu.jeon@samsung.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org, syzkaller@googlegroups.com
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

On Mon, 31 Oct 2022 at 02:23, Leon Romanovsky <leon@kernel.org> wrote:
>
> On Sun, Oct 30, 2022 at 03:29:19PM +0100, Dmitry Vyukov wrote:
> > The current virtual nci driver is great for testing and fuzzing.
> > But it allows to create at most one "global" device which does not allow
> > to run parallel tests and harms fuzzing isolation and reproducibility.
> > Restructure the driver to allow creation of multiple independent devices.
> > This should be backwards compatible for existing tests.
> >
> > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > Cc: netdev@vger.kernel.org
> > ---
> >  drivers/nfc/virtual_ncidev.c | 143 ++++++++++++++++-------------------
> >  1 file changed, 66 insertions(+), 77 deletions(-)
>
> <...>
>
> >  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> >  {
> > -     mutex_lock(&nci_mutex);
> > -     if (state != virtual_ncidev_enabled) {
> > -             mutex_unlock(&nci_mutex);
> > -             kfree_skb(skb);
> > -             return 0;
> > -     }
> > +     struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> >
> > -     if (send_buff) {
> > -             mutex_unlock(&nci_mutex);
> > +     mutex_lock(&vdev->mtx);
> > +     if (vdev->send_buff) {
> > +             mutex_unlock(&vdev->mtx);
> >               kfree_skb(skb);
>
> You probably need to set vdev->send_buff to NULL here.

Hi Leon,

Thanks for looking at this.

Are you sure about setting vdev->send_buff to NULL?
We already have a "cached" skb in vdev->send_buff, we received a new
one in 'skb' and freed it.
I assumed the intention is to keep vdev->send_buff intact.

> >               return -1;
> >       }
> > -     send_buff = skb_copy(skb, GFP_KERNEL);
> > -     mutex_unlock(&nci_mutex);
> > -     wake_up_interruptible(&wq);
> > +     vdev->send_buff = skb_copy(skb, GFP_KERNEL);
>
> You don't check return value of skb_copy(), it can fail, but
> this function will return 0 (success). Do you do it deliberately?
>
> If yes, please add a comment to the code, as it is not clear.

Good question. I just kept all of this logic as it is now and only
removed the global vars.

I guess we need something like this, right?

vdev->send_buff = skb_copy(skb, GFP_KERNEL);
if (!vdev->send_buff) {
    mutex_unlock(&vdev->mtx);
    return -1;
}

Though, it's called only from nci_send_frame() and its return value is
never checked :)

$ git grep nci_send_frame
include/net/nfc/nci_core.h:int nci_send_frame(struct nci_dev *ndev,
struct sk_buff *skb);
net/nfc/nci/core.c:int nci_send_frame(struct nci_dev *ndev, struct sk_buff *skb)
net/nfc/nci/core.c:EXPORT_SYMBOL(nci_send_frame);
drivers/nfc/nfcmrvl/fw_dnld.c:
nci_send_frame(priv->ndev, out_skb);
drivers/nfc/nfcmrvl/fw_dnld.c:          nci_send_frame(priv->ndev, out_skb);
drivers/nfc/nfcmrvl/fw_dnld.c:
nci_send_frame(priv->ndev, out_skb);
net/nfc/nci/core.c:             nci_send_frame(ndev, skb);
net/nfc/nci/core.c:             nci_send_frame(ndev, skb);


> Thanks
>
> > +     mutex_unlock(&vdev->mtx);
> > +     wake_up_interruptible(&vdev->wq);
> >       consume_skb(skb);
> >
> >       return 0;
