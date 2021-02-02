Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DF230CF4F
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 23:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235663AbhBBWqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 17:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235790AbhBBWq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 17:46:28 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9836AC061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 14:45:47 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id t5so3692630eds.12
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 14:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=23HVMcRnuKR5F6OX1H2U8fMrHJE+SEXtuZKUFdzCCGo=;
        b=M9ZmKBikkMsbSYCn2Tx06VXGI6E7Qdta8u9e/VSeWzXBRkTa2nskywY9c0orJUrRaV
         CJjSGmUE7Zec4pNz2Gfdb/YZWLA3S3QWoTFpYVhQDcP9EmKfL8Y68Otl5C2hXgZDzr+X
         s3gTNnVpdcibTPMnMzH/vskXxEAW8UP0HmH78EzB4qGBa3RCNpsrtJsh8X2bb1RdhDIF
         IWkJHupsWBDIOu0SAmSr5zrsoAVlZdnxhAIeqjHickkcN1Up7oCBIyFrIwd2YkfQZj4R
         A5Svs2FdwhUcsy1SswfEMibovAhAED1ZhujI7UN0/F85rMcRBQKKd38emnZLEDF4xJ//
         E81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=23HVMcRnuKR5F6OX1H2U8fMrHJE+SEXtuZKUFdzCCGo=;
        b=pBK/zfSFiR6JF846qyIjA//LYco91i+YX4QQbOUYGiqht9qDTwXWLtUxkrEjSw5Tup
         MRHQSq+YJ8NWbSzAFS/YSuJCFMefam+U+y283XaL/6XR+1GgOdKr5YzO5JWUDVW1sbEe
         zmCB0XkknXbNtXp4R1UubHslhdyJpc7IFSgCaqpygvwPl5lubBTWFqwax52uy9E3g0DL
         8QiJqY9n9z/ZJ1tUymzB16a41jPDru0DMCtlqyueEBLGIEp3g8wRnhto5e4nykPY3tV1
         rrtcOvxbnA22Yk1qs2hXYnbppRmSgb/S1Rm6m/JvZRhn9vye6zxLRNdW24dlkSbcm9my
         RHlg==
X-Gm-Message-State: AOAM531ciVqlXx+IoyUdcCHF5o3PH2fe7CJzeRXdwFJGnMjC3aq7RRcU
        js9SNsz3RSZYxMBgpx3fOxb9TK9GyVLdDLviYS4=
X-Google-Smtp-Source: ABdhPJx6nLbXSM30fnx+b/rwVjTzIIi/VL708FdM2bRQ5T/+EyZfsXZVUo8tqN9LHRAjRI2wQTnKWPdpA7cp+dEWWgs=
X-Received: by 2002:aa7:c9cf:: with SMTP id i15mr310892edt.296.1612305946246;
 Tue, 02 Feb 2021 14:45:46 -0800 (PST)
MIME-Version: 1.0
References: <1612282568-14094-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1612282568-14094-1-git-send-email-loic.poulain@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Feb 2021 17:45:09 -0500
Message-ID: <CAF=yD-JWw9TsXrOT_83bDECrX1J9NvkesoG37pXq8zOkQpiUqg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] net: mhi-net: Add de-aggeration support
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 11:08 AM Loic Poulain <loic.poulain@linaro.org> wrote:
>
> When device side MTU is larger than host side MTU, the packets
> (typically rmnet packets) are split over multiple MHI transfers.
> In that case, fragments must be re-aggregated to recover the packet
> before forwarding to upper layer.
>
> A fragmented packet result in -EOVERFLOW MHI transaction status for
> each of its fragments, except the final one. Such transfer was
> previoulsy considered as error and fragments were simply dropped.

nit: previously

>
> This change adds re-aggregation mechanism using skb chaining, via
> skb frag_list.
>
> A warning (once) is printed since this behavior usually comes from
> a misconfiguration of the device (e.g. modem MTU).
>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Only one real question wrt stats. Otherwise looks good to me, thanks.

> ---
>  v2: use zero-copy skb chaining instead of skb_copy_expand.
>
>  drivers/net/mhi_net.c | 79 ++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 69 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> index 4f512531..be39779 100644
> --- a/drivers/net/mhi_net.c
> +++ b/drivers/net/mhi_net.c
> @@ -32,6 +32,8 @@ struct mhi_net_stats {
>  struct mhi_net_dev {
>         struct mhi_device *mdev;
>         struct net_device *ndev;
> +       struct sk_buff *skbagg_head;
> +       struct sk_buff *skbagg_tail;
>         struct delayed_work rx_refill;
>         struct mhi_net_stats stats;
>         u32 rx_queue_sz;
> @@ -132,6 +134,37 @@ static void mhi_net_setup(struct net_device *ndev)
>         ndev->tx_queue_len = 1000;
>  }
>
> +static struct sk_buff *mhi_net_skb_agg(struct mhi_net_dev *mhi_netdev,
> +                                      struct sk_buff *skb)
> +{
> +       struct sk_buff *head = mhi_netdev->skbagg_head;
> +       struct sk_buff *tail = mhi_netdev->skbagg_tail;
> +
> +       /* This is non-paged skb chaining using frag_list */
> +

no need for empty line?

> +       if (!head) {
> +               mhi_netdev->skbagg_head = skb;
> +               return skb;
> +       }
> +
> +       if (!skb_shinfo(head)->frag_list)
> +               skb_shinfo(head)->frag_list = skb;
> +       else
> +               tail->next = skb;
> +
> +       /* data_len is normally the size of paged data, in our case there is no

data_len is defined as the data excluding the linear len (ref:
skb_headlen). That is not just paged data, but includes frag_list.

> +        * paged data (nr_frags = 0), so it represents the size of chained skbs,
> +        * This way, net core will consider skb->frag_list.
> +        */
> +       head->len += skb->len;
> +       head->data_len += skb->len;
> +       head->truesize += skb->truesize;
> +
> +       mhi_netdev->skbagg_tail = skb;
> +
> +       return mhi_netdev->skbagg_head;
> +}
> +
>  static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
>                                 struct mhi_result *mhi_res)
>  {
> @@ -142,19 +175,42 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
>         free_desc_count = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
>
>         if (unlikely(mhi_res->transaction_status)) {
> -               dev_kfree_skb_any(skb);
> -
> -               /* MHI layer stopping/resetting the DL channel */
> -               if (mhi_res->transaction_status == -ENOTCONN)
> +               switch (mhi_res->transaction_status) {
> +               case -EOVERFLOW:
> +                       /* Packet can not fit in one MHI buffer and has been
> +                        * split over multiple MHI transfers, do re-aggregation.
> +                        * That usually means the device side MTU is larger than
> +                        * the host side MTU/MRU. Since this is not optimal,
> +                        * print a warning (once).
> +                        */
> +                       netdev_warn_once(mhi_netdev->ndev,
> +                                        "Fragmented packets received, fix MTU?\n");
> +                       skb_put(skb, mhi_res->bytes_xferd);
> +                       mhi_net_skb_agg(mhi_netdev, skb);
> +                       break;
> +               case -ENOTCONN:
> +                       /* MHI layer stopping/resetting the DL channel */
> +                       dev_kfree_skb_any(skb);
>                         return;
> -
> -               u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> -               u64_stats_inc(&mhi_netdev->stats.rx_errors);
> -               u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> +               default:
> +                       /* Unknown error, simply drop */
> +                       dev_kfree_skb_any(skb);
> +                       u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> +                       u64_stats_inc(&mhi_netdev->stats.rx_errors);
> +                       u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> +               }
>         } else {
> +               skb_put(skb, mhi_res->bytes_xferd);
> +
> +               if (mhi_netdev->skbagg_head) {
> +                       /* Aggregate the final fragment */
> +                       skb = mhi_net_skb_agg(mhi_netdev, skb);
> +                       mhi_netdev->skbagg_head = NULL;
> +               }
> +
>                 u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
>                 u64_stats_inc(&mhi_netdev->stats.rx_packets);
> -               u64_stats_add(&mhi_netdev->stats.rx_bytes, mhi_res->bytes_xferd);
> +               u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);

might this change stats? it will if skb->len != 0 before skb_put. Even
if so, perhaps it doesn't matter.
