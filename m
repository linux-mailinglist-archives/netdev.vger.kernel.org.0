Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7680E61874D
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 19:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiKCSTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 14:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiKCSTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 14:19:12 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE2013D6C
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 11:19:11 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id n83so2830640oif.11
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 11:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IYTEDzwZ6ZxeDG7kXb9xT0E9nyE1i3qbECKdhWF/8SU=;
        b=HAEBMiZY2+7Jbw8Z4H5v9V/k37spv5fML8gx2F7Q6O9JYXaLhUg3CktFf5nxG1qMB/
         4HQXd0l5Rom92Nsr69oUvfxxh4tpa07agAoPQOHRpt0K6OGwWh6BOPxEJ1FNtu4kImAZ
         sYzVEm5L+dtvv0B5GtS/mTtvipwH4j3M+wWwAAxHD0NBOf0KlGV17U8Izjx4qzctIDcZ
         jlShdlMPY+mLmppigr67jWmeJSTCJlg1o2xaM5QTBPH881ckUbJOcoWlxcwbNGWJPTGY
         LziGCPToFXLCeGB742S1DNrD+xEKTG6ka9IDkICkSkdJH8GUJgxt+EvoMQ8cX0lD477B
         0hSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IYTEDzwZ6ZxeDG7kXb9xT0E9nyE1i3qbECKdhWF/8SU=;
        b=p7+QAe4AkIiCTA+/nc7cSZ1qAHLIe9rmFWyTxbg00fDEvqv0/4i5cGOXaBVNbg5GCl
         Qhj0yI5DX8AaF7muKaqcVkzhKpH42/7SH4IoCiV2vNEsSkexn5gYA4NYc3dfIRq+FANx
         IcK8YM7tP1YPCsVFDxdqK4NT/4DqvkLLWNvH2w1ECtHHXZsdXrBfrSzpESZwqCZRCrFh
         R0WsI6b8RKDLh+0sgXcXmQfngFH5judOwJ1Q0x1o9fccTwaayvM7+pmBP0MjnTEb/jSB
         jz3p+3EC0g8s8nC4AWDOEzmJOHEaQ/eFIRJ4hTL3CNKPCAYNh1q//PcewQb+bApRb4sg
         uhJQ==
X-Gm-Message-State: ACrzQf3RIj/2TDaHCKenHb0/q3jCiNXQ8H6DMT4wou0yMY9zmm24ixY5
        Xl/u1zXd2mHngXiKjtizUKg3/vl7CqBlFvP2ipxTfg==
X-Google-Smtp-Source: AMsMyM6xWDneg1geFpJvVDGkhn4Yqct5/CnEfY+Gc3CuXlBZncNTTTxROSOC+f9JNgQHvOdjfoBc9otVUbdLQBYRPlY=
X-Received: by 2002:a05:6808:1184:b0:350:f681:8c9a with SMTP id
 j4-20020a056808118400b00350f6818c9amr17210542oil.282.1667499550583; Thu, 03
 Nov 2022 11:19:10 -0700 (PDT)
MIME-Version: 1.0
References: <20221030142919.3196780-1-dvyukov@google.com> <Y1+UHKsFbg46UEvM@unreal>
 <CACT4Y+Y=W2xazqDmrSFDS5ocbsc+H-ZAiHTD1era=dFR4V0gOA@mail.gmail.com> <Y2C3dAk2B5B681Wq@unreal>
In-Reply-To: <Y2C3dAk2B5B681Wq@unreal>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 3 Nov 2022 11:18:58 -0700
Message-ID: <CACT4Y+boD3gJUj=b0be7xY6MOuF797POYNHQDP+jpFmbdvzaaw@mail.gmail.com>
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

On Mon, 31 Oct 2022 at 23:06, Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Oct 31, 2022 at 08:36:57AM -0700, Dmitry Vyukov wrote:
> > On Mon, 31 Oct 2022 at 02:23, Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Sun, Oct 30, 2022 at 03:29:19PM +0100, Dmitry Vyukov wrote:
> > > > The current virtual nci driver is great for testing and fuzzing.
> > > > But it allows to create at most one "global" device which does not allow
> > > > to run parallel tests and harms fuzzing isolation and reproducibility.
> > > > Restructure the driver to allow creation of multiple independent devices.
> > > > This should be backwards compatible for existing tests.
> > > >
> > > > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > > > Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> > > > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > > > Cc: netdev@vger.kernel.org
> > > > ---
> > > >  drivers/nfc/virtual_ncidev.c | 143 ++++++++++++++++-------------------
> > > >  1 file changed, 66 insertions(+), 77 deletions(-)
> > >
> > > <...>
> > >
> > > >  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> > > >  {
> > > > -     mutex_lock(&nci_mutex);
> > > > -     if (state != virtual_ncidev_enabled) {
> > > > -             mutex_unlock(&nci_mutex);
> > > > -             kfree_skb(skb);
> > > > -             return 0;
> > > > -     }
> > > > +     struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> > > >
> > > > -     if (send_buff) {
> > > > -             mutex_unlock(&nci_mutex);
> > > > +     mutex_lock(&vdev->mtx);
> > > > +     if (vdev->send_buff) {
> > > > +             mutex_unlock(&vdev->mtx);
> > > >               kfree_skb(skb);
> > >
> > > You probably need to set vdev->send_buff to NULL here.
> >
> > Hi Leon,
> >
> > Thanks for looking at this.
> >
> > Are you sure about setting vdev->send_buff to NULL?
> > We already have a "cached" skb in vdev->send_buff, we received a new
> > one in 'skb' and freed it.
> > I assumed the intention is to keep vdev->send_buff intact.
>
> You are right.
>
> >
> > > >               return -1;
> > > >       }
> > > > -     send_buff = skb_copy(skb, GFP_KERNEL);
> > > > -     mutex_unlock(&nci_mutex);
> > > > -     wake_up_interruptible(&wq);
> > > > +     vdev->send_buff = skb_copy(skb, GFP_KERNEL);
> > >
> > > You don't check return value of skb_copy(), it can fail, but
> > > this function will return 0 (success). Do you do it deliberately?
> > >
> > > If yes, please add a comment to the code, as it is not clear.
> >
> > Good question. I just kept all of this logic as it is now and only
> > removed the global vars.
>
> I know :)
>
> >
> > I guess we need something like this, right?
> >
> > vdev->send_buff = skb_copy(skb, GFP_KERNEL);
> > if (!vdev->send_buff) {
> >     mutex_unlock(&vdev->mtx);
> >     return -1;
> > }
> >
> > Though, it's called only from nci_send_frame() and its return value is
> > never checked :)
>
> I would say that the most important part is do not continue after
> skb_copy() failure.

Mailed v2 with this fix.

> Thanks
>
> >
> > $ git grep nci_send_frame
> > include/net/nfc/nci_core.h:int nci_send_frame(struct nci_dev *ndev,
> > struct sk_buff *skb);
> > net/nfc/nci/core.c:int nci_send_frame(struct nci_dev *ndev, struct sk_buff *skb)
> > net/nfc/nci/core.c:EXPORT_SYMBOL(nci_send_frame);
> > drivers/nfc/nfcmrvl/fw_dnld.c:
> > nci_send_frame(priv->ndev, out_skb);
> > drivers/nfc/nfcmrvl/fw_dnld.c:          nci_send_frame(priv->ndev, out_skb);
> > drivers/nfc/nfcmrvl/fw_dnld.c:
> > nci_send_frame(priv->ndev, out_skb);
> > net/nfc/nci/core.c:             nci_send_frame(ndev, skb);
> > net/nfc/nci/core.c:             nci_send_frame(ndev, skb);
> >
> >
> > > Thanks
> > >
> > > > +     mutex_unlock(&vdev->mtx);
> > > > +     wake_up_interruptible(&vdev->wq);
> > > >       consume_skb(skb);
> > > >
> > > >       return 0;
