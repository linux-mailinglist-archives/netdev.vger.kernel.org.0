Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133CD20D4F7
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731306AbgF2TNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731274AbgF2TNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:09 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E436C00864F
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 03:13:53 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id d16so5687388edz.12
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 03:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=z0NkPGMoBJQ+6NlD1c9KosUZc+wIaMIfZN3Jyo/W/Rk=;
        b=sXtm8+xzGqdh2QBD2G9UHRDQFTGQ2vdsQrR4FNOIkzJFYWKUSFcikKR0t2Mg48Aua6
         KimZFerrRr8iZCzwZbe6Ydx6MMI2JedZy1duQPv+vRt4y+MwwmYjkopzNXYUEWMICKsI
         ErbvO3f0uI0CdOeEUJfWlFhuzfmr/FDDHlJFdQK9m1Zmk0ICdkySriMzk2eoXila7JAp
         B92Sujgndx6d0coIPlBENmHsLj5vadUl4fnZv+Qjd7iE46Ge9xJy5AC4/k4yffy08aaL
         l6tDeWOLyqUZhxi/ziNw5UFl0gCotCYcL5RyazlDpFy0N7Se9PDuKnpqyQDpUuz/3RzP
         XHBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=z0NkPGMoBJQ+6NlD1c9KosUZc+wIaMIfZN3Jyo/W/Rk=;
        b=naj5nAkrBUvEhg/Hq0roe03780h9yHoaF9W0jE0ED2E9uH2nLD8o3X4KT4ZQptdavW
         d57dRz3iF6zotJ68mZgCXUFZpiHuAJaJDyLIm/swhf1HSm+DXkOkfY6rborXdhj4TfIQ
         K8Hz2H2d1qwNNvVgS4ElBnkylghw+autC/I+pUoVErgKM6JLpYZR3xVpxSEdsL8wiU2M
         KO6Wg/X1ceIFz8ReYKxY95rjBWu21Vi0atOwBLr9fwEFXJFOVGVOOsw8aqitpMSMjlEQ
         LTiE0p0aDrQ34Aucld0X+wkbeS+TgjrScN6nSR6YBENCbSowt0djiWzyIRaXrxkJxrvs
         ObCg==
X-Gm-Message-State: AOAM533/z++OIT4Xi0J8kmAZsT4haH2K0nL0yjsOo2kWkbKUYbRL+41P
        O5yQ2YoZ8qnJbu7wWAy9z1BxjkGtKsV2PJu4nOgyfQ==
X-Google-Smtp-Source: ABdhPJzkjCSWrfx8f/v16jSHMPMXZQtXTlptZKUPJ6/i1bU/kzNhM03QMzEwdUyJryY8/b9tI/YohS7ghxOkvIbB2fE=
X-Received: by 2002:a50:9a82:: with SMTP id p2mr16392338edb.130.1593425631691;
 Mon, 29 Jun 2020 03:13:51 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:3a1b:0:0:0:0:0 with HTTP; Mon, 29 Jun 2020 03:13:51
 -0700 (PDT)
X-Originating-IP: [5.35.13.201]
In-Reply-To: <20200626140931.2daea960@carbon>
References: <1593171639-8136-1-git-send-email-kda@linux-powerpc.org>
 <1593171639-8136-3-git-send-email-kda@linux-powerpc.org> <20200626140931.2daea960@carbon>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 29 Jun 2020 13:13:51 +0300
Message-ID: <CAOJe8K0bi3oMwTp8VN4OPdaDtp6PvU1w6fZ4EkXFdbcc-zciZA@mail.gmail.com>
Subject: Re: [PATCH net-next v13 2/3] xen networking: add basic XDP support
 for xen-netfront
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/26/20, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> On Fri, 26 Jun 2020 14:40:38 +0300
> Denis Kirjanov <kda@linux-powerpc.org> wrote:
>
>> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
>> index 482c6c8..91a3b53 100644
>> --- a/drivers/net/xen-netfront.c
>> +++ b/drivers/net/xen-netfront.c
> [...]
>> @@ -560,6 +572,67 @@ static u16 xennet_select_queue(struct net_device
>> *dev, struct sk_buff *skb,
>>  	return queue_idx;
>>  }
>>
>> +static int xennet_xdp_xmit_one(struct net_device *dev,
>> +			       struct netfront_queue *queue,
>> +			       struct xdp_frame *xdpf)
>> +{
>> +	struct netfront_info *np = netdev_priv(dev);
>> +	struct netfront_stats *tx_stats = this_cpu_ptr(np->tx_stats);
>> +	struct xen_netif_tx_request *tx;
>> +	int notify;
>> +
>> +	tx = xennet_make_first_txreq(queue, NULL,
>> +				     virt_to_page(xdpf->data),
>> +				     offset_in_page(xdpf->data),
>> +				     xdpf->len);
>> +
>> +	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&queue->tx, notify);
>> +	if (notify)
>> +		notify_remote_via_irq(queue->tx_irq);
>
> Is this an expensive operation?

Hi Jesper,

actually not.

>
> Do you think this can be moved outside the loop?
> So that it is called once per bulk.

I've tested both variants and it turned out that there is no
difference between both:
with xdp_redirect I see the similar picture:
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 1074 root      20   0       0      0      0 R 100.0  0.0   1:17.60 cpumap/3/m+
    9 root      20   0       0      0      0 R  93.7  0.0   1:37.03 ksoftirqd/0

with the similar pps rate reported by xdp_redirect.

So I'll keep the code as is in the next submission.

Thanks!

>
>
>> +	u64_stats_update_begin(&tx_stats->syncp);
>> +	tx_stats->bytes += xdpf->len;
>> +	tx_stats->packets++;
>> +	u64_stats_update_end(&tx_stats->syncp);
>> +
>> +	xennet_tx_buf_gc(queue);
>> +
>> +	return 0;
>> +}
>> +
>> +static int xennet_xdp_xmit(struct net_device *dev, int n,
>> +			   struct xdp_frame **frames, u32 flags)
>> +{
>> +	unsigned int num_queues = dev->real_num_tx_queues;
>> +	struct netfront_info *np = netdev_priv(dev);
>> +	struct netfront_queue *queue = NULL;
>> +	unsigned long irq_flags;
>> +	int drops = 0;
>> +	int i, err;
>> +
>> +	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
>> +		return -EINVAL;
>> +
>> +	queue = &np->queues[smp_processor_id() % num_queues];
>> +
>> +	spin_lock_irqsave(&queue->tx_lock, irq_flags);
>> +	for (i = 0; i < n; i++) {
>> +		struct xdp_frame *xdpf = frames[i];
>> +
>> +		if (!xdpf)
>> +			continue;
>> +		err = xennet_xdp_xmit_one(dev, queue, xdpf);
>> +		if (err) {
>> +			xdp_return_frame_rx_napi(xdpf);
>> +			drops++;
>> +		}
>> +	}
>> +	spin_unlock_irqrestore(&queue->tx_lock, irq_flags);
>> +
>> +	return n - drops;
>> +}
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
>
