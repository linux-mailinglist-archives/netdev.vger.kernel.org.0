Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85172A3FBD
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgKCJLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCJLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:11:22 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A68C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 01:11:22 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id l24so17451371edj.8
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 01:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FqTLOFBoYdUww8fDPOh9hmMYjpJHH4Tnms+Fpn1TEqo=;
        b=KsBqxI3QQ7bfrSUMKND5d/I1Yge2jwaTcxvhVqMUrX1SyOzJiVdmZgfKTCoMjGkd1W
         O6O5BvH34uXVQc8xuzrCuq5QhZGdeUkTaUYUQ9uh/Gi4AAM3MHFB6e0VfT5BQk14zLuc
         GXVu7pamn2ozQGReFlLmB+1ozK90YOZR7sWEANMLJ6RyhuDAY+9xglMbQxdUCQyoVO1j
         bQXAHy+zsmKvYDyUrcLVI1BmADHpUSgNks9Ac9sHdnuABSvYTF3cwjyYMF2N2ewT2P5S
         CctIuKFKz5BSL7HrweqBUb2q+raPd2AMpr+rc1CWsNT7xa9WxchtYMsEoy7oUp1dD7TM
         JLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FqTLOFBoYdUww8fDPOh9hmMYjpJHH4Tnms+Fpn1TEqo=;
        b=qmwoGPMeJENcWuMlhz3UuGgunLmdYAMMo8WrqBJfp7OnmiGMRyLrfT5auqe1MJKfdb
         +SheMCTJ4ZuFWUGm5bJ5oD82xLs90NsT0e/Wse/CTezpp/WqX4az7szEYOSYwdUHwFAm
         e2jq04iQfQ81VoKbAahZaMNOYa3Z/0pQpojV7gXzRejD6OgAsHoiaRFzsfIkO+VMHWb0
         2w9+/u1R/jVY2fMI1l7pJtofJOW5B3KxBoopaKvx1b0hZxRDX4UEjkCfI4GE4D7/5M8C
         pCMsk1S5Eqvoun3U6s3rqbMqLjq7FwEWiJkHNrIR1bNQ847NRKDsUZXiQhax4W7Jd/5w
         6K8g==
X-Gm-Message-State: AOAM533KEmls9tV2gsAlBjIPAyyhd6MCHkQo8s/Akt4n7LuXVE49gxum
        LgCJvxH/Bw6BdlF51h81ai2gn0uzEh5eJJ6rLXxEWQ==
X-Google-Smtp-Source: ABdhPJxkcU0lt2yBymZuKpGG35sFdm8ogMJa6fi6a6ZAyyx6aO9/2mlacNfZnu1X51WTr8TaU0FVzh2w12BoptxGsp0=
X-Received: by 2002:a05:6402:8cc:: with SMTP id d12mr20789699edz.134.1604394680601;
 Tue, 03 Nov 2020 01:11:20 -0800 (PST)
MIME-Version: 1.0
References: <1604054895-29137-1-git-send-email-loic.poulain@linaro.org> <20201102144015.2e060d28@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201102144015.2e060d28@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 3 Nov 2020 10:17:16 +0100
Message-ID: <CAMZdPi-a7W5xYTxKQE7a5wQEh1EfsDrvCjupwc25kK-iaJUPTw@mail.gmail.com>
Subject: Re: [PATCH v9 2/2] net: Add mhi-net driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, 2 Nov 2020 at 23:40, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 30 Oct 2020 11:48:15 +0100 Loic Poulain wrote:
> > This patch adds a new network driver implementing MHI transport for
> > network packets. Packets can be in any format, though QMAP (rmnet)
> > is the usual protocol (flow control + PDN mux).
> >
> > It support two MHI devices, IP_HW0 which is, the path to the IPA
> > (IP accelerator) on qcom modem, And IP_SW0 which is the software
> > driven IP path (to modem CPU).
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>
> > +static int mhi_ndo_stop(struct net_device *ndev)
> > +{
> > +     struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> > +
> > +     netif_stop_queue(ndev);
> > +     netif_carrier_off(ndev);
> > +     cancel_delayed_work_sync(&mhi_netdev->rx_refill);
>
> Where do you free the allocated skbs? Does
> mhi_unprepare_from_transfer() do that?

When a buffer is queued, it is owned by the device until the transfer
callback (ul_cb/dl_cb) is called. mhi_unprepare_from_transfer() causes
the MHI channels to be reset which in turn leads to releasing the
buffers, for each buffer the MHI core will call the mhi-net transfer
callback with -ENOTCONN status, and we free it from here.

>
> The skbs should be freed somehow in .ndo_stop().

The skbs are released in remove() (mhi_unprepare_from_transfer), I do
not do prepare/unprepare in ndo_open/ndo_stop because we need to have
channels started during the whole life of the interface. That's
because it set up kind of internal routing of on the device/modem
side. Indeed, if channels are not started, configuration of the modem
(via out-of-band qmi, at commands, etc) is not possible.

>
> > +     return 0;
> > +}
> > +
> > +static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
> > +{
> > +     struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> > +     struct mhi_device *mdev = mhi_netdev->mdev;
> > +     int err;
> > +
> > +     err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
> > +     if (unlikely(err)) {
> > +             net_err_ratelimited("%s: Failed to queue TX buf (%d)\n",
> > +                                 ndev->name, err);
> > +
> > +             u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
> > +             u64_stats_inc(&mhi_netdev->stats.tx_dropped);
> > +             u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
> > +
> > +             /* drop the packet */
> > +             kfree_skb(skb);
>
> dev_kfree_skb_any()
>
> > +     }
> > +
> > +     if (mhi_queue_is_full(mdev, DMA_TO_DEVICE))
> > +             netif_stop_queue(ndev);
> > +
> > +     return NETDEV_TX_OK;
> > +}
>
> > +static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
> > +                             struct mhi_result *mhi_res)
> > +{
> > +     struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
> > +     struct sk_buff *skb = mhi_res->buf_addr;
> > +     int remaining;
> > +
> > +     remaining = atomic_dec_return(&mhi_netdev->stats.rx_queued);
> > +
> > +     if (unlikely(mhi_res->transaction_status)) {
> > +             u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> > +             u64_stats_inc(&mhi_netdev->stats.rx_errors);
> > +             u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> > +
> > +             kfree_skb(skb);
>
> Are you sure this never runs with irqs disabled or from irq context?
>
> Otherwise dev_kfree_skb_any().

Yes will fix that.

>
> > +
> > +             /* MHI layer resetting the DL channel */
> > +             if (mhi_res->transaction_status == -ENOTCONN)
> > +                     return;
> > +     } else {
> > +             u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> > +             u64_stats_inc(&mhi_netdev->stats.rx_packets);
> > +             u64_stats_add(&mhi_netdev->stats.rx_bytes, mhi_res->bytes_xferd);
> > +             u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> > +
> > +             skb->protocol = htons(ETH_P_MAP);
> > +             skb_put(skb, mhi_res->bytes_xferd);
> > +             netif_rx(skb);
> > +     }
> > +
> > +     /* Refill if RX buffers queue becomes low */
> > +     if (remaining <= mhi_netdev->rx_queue_sz / 2)
> > +             schedule_delayed_work(&mhi_netdev->rx_refill, 0);
> > +}
> > +
> > +static void mhi_net_ul_callback(struct mhi_device *mhi_dev,
> > +                             struct mhi_result *mhi_res)
> > +{
> > +     struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
> > +     struct net_device *ndev = mhi_netdev->ndev;
> > +     struct sk_buff *skb = mhi_res->buf_addr;
> > +
> > +     /* Hardware has consumed the buffer, so free the skb (which is not
> > +      * freed by the MHI stack) and perform accounting.
> > +      */
> > +     consume_skb(skb);
>
> ditto
>
> > +     u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
> > +     if (unlikely(mhi_res->transaction_status)) {
> > +             u64_stats_inc(&mhi_netdev->stats.tx_errors);
> > +
> > +             /* MHI layer resetting the UL channel */
> > +             if (mhi_res->transaction_status == -ENOTCONN)
> > +                     return;
>
> u64_stats_update_end()
>
> > +     } else {
> > +             u64_stats_inc(&mhi_netdev->stats.tx_packets);
> > +             u64_stats_add(&mhi_netdev->stats.tx_bytes, mhi_res->bytes_xferd);
> > +     }
> > +     u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
> > +
> > +     if (netif_queue_stopped(ndev))
> > +             netif_wake_queue(ndev);
> > +}
> > +
> > +static void mhi_net_rx_refill_work(struct work_struct *work)
> > +{
> > +     struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
> > +                                                   rx_refill.work);
> > +     struct net_device *ndev = mhi_netdev->ndev;
> > +     struct mhi_device *mdev = mhi_netdev->mdev;
> > +     int size = READ_ONCE(ndev->mtu);
> > +     struct sk_buff *skb;
> > +     int err;
> > +
> > +     do {
>
> should this be a while(), not a do {} while() loop now?
>
> > +             skb = netdev_alloc_skb(ndev, size);
> > +             if (unlikely(!skb))
> > +                     break;
> > +
> > +             err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, size, MHI_EOT);
> > +             if (unlikely(err)) {
> > +                     net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
> > +                                         ndev->name, err);
> > +                     kfree_skb(skb);
> > +                     break;
> > +             }
> > +
> > +             /* Do not hog the CPU if rx buffers are consumed faster than
> > +              * queued (unlikely).
> > +              */
> > +             cond_resched();
> > +     } while (atomic_inc_return(&mhi_netdev->stats.rx_queued) < mhi_netdev->rx_queue_sz);
> > +
> > +     /* If we're still starved of rx buffers, reschedule later */
> > +     if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
> > +             schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
> > +}
