Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7147820371E
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 14:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgFVMps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 08:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbgFVMps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 08:45:48 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78E8C061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 05:45:47 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id h28so1309048edz.0
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 05:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=MDFcDHAaWYXCJJ6Mf2xG8in2+2CBYbLhFH01Qn/Miq0=;
        b=EjNwtmBcVV+0fCIoAjq/rMNImdOLzh3AWjaM6W77iQD2nfjN7vyUgIlXriaIl4wpAa
         9NwQwfbjua/ptE1CE8Xg/u9ndWoRBuf2OtHByD3zw/w9ESlMek1b6Yk25vpweyalFu3k
         zsAVz8fOHk6U0oPoKZII6X+LIonFY9c/f0K5Bz84jkbO5BvUjvJeUQ2t+t0s72IsDBca
         oSMQJCJWx9p+ciONMSWbKk0DmIWy023T27ObIqxzgrNts+DH7hOnADDCp3WTEqnWjoVf
         Dxs1lr4iCIBRYJUQEl8YdWwDB3EKwS7nhtDohFhp9sUnDWigJo1q+ZGuQ452ovkfCiM+
         QFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=MDFcDHAaWYXCJJ6Mf2xG8in2+2CBYbLhFH01Qn/Miq0=;
        b=noSE6m/bv2avHTOpguPaJ5aZcEslcTu+GVpZOb/otXDBd+zo9FUd17njpxpk8Gg0no
         DsZcZ+6n5y+6s46nB3CvMhAXL+ed9fB5//RPTEr3gqMpfYe56WFyFy0BlrACbazBiVm3
         5psXL1GKHdV7FBlR/kfTUi1tmh9XB0O4by7JGe9I+wcZ1gvxBexwZ+W2g6Zrp17I/2Mu
         S/vVNT4Dbcy51Y+Dc8ozYH2sMXrU2QBe8anzFanzTfGAS+o1H4XhcLHJiZsvnYwptkCU
         I/lH+Jdmfmw73btOyXIf3j35ird3jo28Ylh6xALYDUFckV678eox5GRcCP5xGkwrfFpK
         zQLw==
X-Gm-Message-State: AOAM533f+BsZz9ut6EbYEkgs9VUERVGxPurJm5Z/bul+0mjavPH09N0j
        h3jaKsSa/bgWGFVTAWvNoKcUK9wZsngsEprXhEFmvA==
X-Google-Smtp-Source: ABdhPJwuaM1t2+OOmHbblkILw4oYKdu0Su+OHSbNpTHzP1ok5AtKEI0Q9BSmP2H+7l0E1gUqbYk5U9vULDLm0DpRqLY=
X-Received: by 2002:a05:6402:17f6:: with SMTP id t22mr3809753edy.141.1592829946650;
 Mon, 22 Jun 2020 05:45:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:3a1b:0:0:0:0:0 with HTTP; Mon, 22 Jun 2020 05:45:46
 -0700 (PDT)
X-Originating-IP: [5.35.13.201]
In-Reply-To: <20200622115804.3c63aba9@carbon>
References: <1592817672-2053-1-git-send-email-kda@linux-powerpc.org>
 <1592817672-2053-3-git-send-email-kda@linux-powerpc.org> <20200622115804.3c63aba9@carbon>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 22 Jun 2020 15:45:46 +0300
Message-ID: <CAOJe8K28RQuiAKADY2pgad8qAzVXYxYcZnb8m0AJGSZTnAfJqA@mail.gmail.com>
Subject: Re: [PATCH net-next v10 2/3] xen networking: add basic XDP support
 for xen-netfront
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/20, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> On Mon, 22 Jun 2020 12:21:11 +0300 Denis Kirjanov <kda@linux-powerpc.org>
> wrote:
>
>> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
>> index 482c6c8..1b9f49e 100644
>> --- a/drivers/net/xen-netfront.c
>> +++ b/drivers/net/xen-netfront.c
> [...]
>> @@ -560,6 +572,65 @@ static u16 xennet_select_queue(struct net_device
>> *dev, struct sk_buff *skb,
>>  	return queue_idx;
>>  }
>>
>> +static int xennet_xdp_xmit_one(struct net_device *dev, struct xdp_frame
>> *xdpf)
>> +{
>> +	struct netfront_info *np = netdev_priv(dev);
>> +	struct netfront_stats *tx_stats = this_cpu_ptr(np->tx_stats);
>> +	unsigned int num_queues = dev->real_num_tx_queues;
>> +	struct netfront_queue *queue = NULL;
>> +	struct xen_netif_tx_request *tx;
>> +	unsigned long flags;
>> +	int notify;
>> +
>> +	queue = &np->queues[smp_processor_id() % num_queues];
>> +
>> +	spin_lock_irqsave(&queue->tx_lock, flags);
>
> Why are you taking a lock per packet (xdp_frame)?
Hi Jesper,

We have to protect shared ring indices.

>
>> +
>> +	tx = xennet_make_first_txreq(queue, NULL,
>> +				     virt_to_page(xdpf->data),
>> +				     offset_in_page(xdpf->data),
>> +				     xdpf->len);
>> +
>> +	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&queue->tx, notify);
>> +	if (notify)
>> +		notify_remote_via_irq(queue->tx_irq);
>> +
>> +	u64_stats_update_begin(&tx_stats->syncp);
>> +	tx_stats->bytes += xdpf->len;
>> +	tx_stats->packets++;
>> +	u64_stats_update_end(&tx_stats->syncp);
>> +
>> +	xennet_tx_buf_gc(queue);
>> +
>> +	spin_unlock_irqrestore(&queue->tx_lock, flags);
>
> Is the irqsave/irqrestore variant really needed here?

netpoll also invokes the tx completion handler.

>
>> +	return 0;
>> +}
>> +
>> +static int xennet_xdp_xmit(struct net_device *dev, int n,
>> +			   struct xdp_frame **frames, u32 flags)
>> +{
>> +	int drops = 0;
>> +	int i, err;
>> +
>> +	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
>> +		return -EINVAL;
>> +
>> +	for (i = 0; i < n; i++) {
>> +		struct xdp_frame *xdpf = frames[i];
>> +
>> +		if (!xdpf)
>> +			continue;
>> +		err = xennet_xdp_xmit_one(dev, xdpf);
>> +		if (err) {
>> +			xdp_return_frame_rx_napi(xdpf);
>> +			drops++;
>> +		}
>> +	}
>> +
>> +	return n - drops;
>> +}
>
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
>
