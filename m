Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630AA29CB21
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 22:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373762AbgJ0VWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 17:22:34 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:35396 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373757AbgJ0VWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 17:22:34 -0400
Received: by mail-vk1-f194.google.com with SMTP id a8so712506vkm.2
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 14:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=61SQDQfppS9Qc+OygRSU43zO8VZ0Ckc876OXS708Obc=;
        b=p1LdYtqI3GyeoSOeF2F5yC7s5f7en2gwLjNsxKtJ8c0buF3uJiJiBgJeVOqM1QO6s9
         Q8hNmUipj4yM0mlNmlup/44YPWSOUTCP9DPbrNUJpBiWa5/28maB8t9jCRSWAC++810b
         Z42Q2IXkTGtFH2ZypuEFltGH/iwrbTwAGtawJy2Il378EjYwC0cQhwcvL6yXJeX8GncS
         lTetpjK/e0l2e+IUzyQhgkZbgDX97gAhkafTqddo+y2XORo0puMov3bmxNFmT6js2Si5
         frFk7RjsDTMRLTpjQmU9endd+qIxEohRFNOpTfB0xdXefsNZwLeAq/bXmVp2H1kUqHv2
         2g/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=61SQDQfppS9Qc+OygRSU43zO8VZ0Ckc876OXS708Obc=;
        b=GHkmokO2ZvdoPlPeDvn8PXCLXlCmKWrhDfTIOi/bSFl6JJcaaX1s1Z5V91zdWVa/03
         6V4ZTdCgWkuq+lsIhmpFfXIuHoHG6wmQXTodXgkQkRvxTOnXgH2et6VtH/f8aaSxIBun
         Se/+WiOMvpxt4WyJ9r9kGJdFDzAYhpg4Ym1hjoC3ctC4TnPP0Pfku6D/kurRerdtBLKI
         P5mr0flBjXftIKQfwn/JoFYqTLku6KvEFfRFIZO0IsSF/wr7ufYPcEbJjVBbANuAwxd5
         JGoVKPmaAqcttu5ETluKmlKh7QL3wKbAuPCS2wdL+o1XxrJxwmHbQgNGwTCynKgoRLfd
         PNTQ==
X-Gm-Message-State: AOAM530QGIvNvi6e34rz5HyTFJacZdNg5L00e4lu0PFfyHnDYqo3Km+m
        8HFroBZWDVI9JbogVgbYcka9VtGkQyM=
X-Google-Smtp-Source: ABdhPJwi/M6ABZMwSqLnOcwPLq1VirZvfof6C2arJpLz7ml5uy4LM8H6/EXE1/XRrcM9XW1ZT+HcLA==
X-Received: by 2002:a1f:310d:: with SMTP id x13mr3277098vkx.17.1603833751263;
        Tue, 27 Oct 2020 14:22:31 -0700 (PDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id l28sm318487vkm.0.2020.10.27.14.22.29
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 14:22:30 -0700 (PDT)
Received: by mail-vs1-f54.google.com with SMTP id s6so1695085vss.13
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 14:22:29 -0700 (PDT)
X-Received: by 2002:a67:c981:: with SMTP id y1mr3135711vsk.14.1603833749252;
 Tue, 27 Oct 2020 14:22:29 -0700 (PDT)
MIME-Version: 1.0
References: <1603787977-6975-1-git-send-email-loic.poulain@linaro.org> <1603787977-6975-2-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1603787977-6975-2-git-send-email-loic.poulain@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 27 Oct 2020 17:21:52 -0400
X-Gmail-Original-Message-ID: <CA+FuTSddjtB0sbUjE59CLqC1vXXnvsV9od5xD7sQkyE5cG7WFA@mail.gmail.com>
Message-ID: <CA+FuTSddjtB0sbUjE59CLqC1vXXnvsV9od5xD7sQkyE5cG7WFA@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] net: Add mhi-net driver
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, jhugo@codeaurora.org,
        bbhatt@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 4:33 AM Loic Poulain <loic.poulain@linaro.org> wrote:
>
> This patch adds a new network driver implementing MHI transport for
> network packets. Packets can be in any format, though QMAP (rmnet)
> is the usual protocol (flow control + PDN mux).
>
> It support two MHI devices, IP_HW0 which is, the path to the IPA
> (IP accelerator) on qcom modem, And IP_SW0 which is the software
> driven IP path (to modem CPU).
>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

> +static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
> +{
> +       struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> +       struct mhi_device *mdev = mhi_netdev->mdev;
> +       int err;
> +
> +       /* mhi_queue_skb is not thread-safe, but xmit is serialized by the
> +        * network core. Once MHI core will be thread save, migrate to

nit: thread-safe.

I also wonder whether you'd gain much from converting to
driver-internal locking, perhaps this comment is premature?

> +static void mhi_net_rx_refill_work(struct work_struct *work)
> +{
> +       struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
> +                                                     rx_refill.work);
> +       struct net_device *ndev = mhi_netdev->ndev;
> +       struct mhi_device *mdev = mhi_netdev->mdev;
> +       int size = READ_ONCE(ndev->mtu);
> +       struct sk_buff *skb;
> +       int err;
> +
> +       do {
> +               skb = netdev_alloc_skb(ndev, size);
> +               if (unlikely(!skb))
> +                       break;
> +
> +               err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, size, MHI_EOT);
> +               if (err) {
> +                       if (unlikely(err != -ENOMEM))
> +                               net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
> +                                                   ndev->name, err);
> +                       kfree_skb(skb);
> +                       break;
> +               }
> +
> +               atomic_inc(&mhi_netdev->stats.rx_queued);
> +
> +               /* Do not hog the CPU if rx buffers are completed faster than
> +                * queued (unlikely).
> +                */
> +               cond_resched();
> +       } while (1);

This function has to allocate + kfree_skb one too many skbs to break
out of the loop? Can it not observe the queue full based on rx_queued?

> +
> +       /* If we're still starved of rx buffers, reschedule latter */

nit: later

> +       if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
> +               schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);

what is the rationale for HZ / 2?

> +}
> +
> +static int mhi_net_probe(struct mhi_device *mhi_dev,
> +                        const struct mhi_device_id *id)
> +{
> +       const char *netname = (char *)id->driver_data;
> +       struct mhi_net_dev *mhi_netdev;
> +       struct net_device *ndev;
> +       struct device *dev = &mhi_dev->dev;
> +       int err;
> +
> +       ndev = alloc_netdev(sizeof(*mhi_netdev), netname, NET_NAME_PREDICTABLE,
> +                           mhi_net_setup);
> +       if (!ndev)
> +               return -ENOMEM;
> +
> +       mhi_netdev = netdev_priv(ndev);
> +       dev_set_drvdata(dev, mhi_netdev);
> +       mhi_netdev->ndev = ndev;
> +       mhi_netdev->mdev = mhi_dev;
> +       SET_NETDEV_DEV(ndev, &mhi_dev->dev);
> +
> +       /* All MHI net channels have 128 ring elements (at least for now) */
> +       mhi_netdev->rx_queue_sz = 128;
> +
> +       INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
> +       u64_stats_init(&mhi_netdev->stats.rx_syncp);
> +       u64_stats_init(&mhi_netdev->stats.tx_syncp);
> +
> +       /* Start MHI channels */
> +       err = mhi_prepare_for_transfer(mhi_dev);
> +       if (err)
> +               goto out_err;
> +
> +       err = register_netdev(ndev);
> +       if (err) {
> +               mhi_unprepare_from_transfer(mhi_dev);
> +               goto out_err;

It's a bit odd to combine error branches with jump labels. I'd add
out_register_err: below
> +       }
> +
> +       return 0;
> +
> +out_err:
> +       free_netdev(ndev);
> +       return err;
> +}
