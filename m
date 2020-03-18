Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 712CD189C02
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgCRMbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:31:53 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:33207 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgCRMbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 08:31:53 -0400
Received: by mail-vk1-f195.google.com with SMTP id d11so5275199vko.0
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 05:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=cDjTe+MVF30QuNK489yhPYaNAWDbolms4oENPYPNcWw=;
        b=FL9dv1hBEwZmAbfLP61Tn9o3JK517rsI30j70G454ddCgoamx8/PuhDdZQqQLgoSZi
         gfpAcS84awkkDHBUFzqaYmiDiAFcFZizzOikd319d1js4A5wrdG7Sy4EV5efrL1SDb8g
         nk8NcK45JaVuT0oBMruLtyOMW7+//LJp0Ex1sRC6g5wE6mbYyRkfJXv4mfmr10vykTLL
         L4eL5y3duR1p3o3uzwnlTyyD25TcviHqiwOI6/wLpydvfFKX6LbYewXcBvvE32t8BOv3
         tpovMcSNDrV8WrTm2h6KjiRVlYSMNAK2l4K6UKm3LFLH4znmy+LvRPZWKEvlzd6ZByea
         s0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=cDjTe+MVF30QuNK489yhPYaNAWDbolms4oENPYPNcWw=;
        b=CCANMrvz2UPu4Fa76M/z3Yx/aw5m4k2phqZ/hoWKqcf6DSiJjNt22KNfn9Lmge9ReU
         U/4Pt9uNLQ5wZg7pwOqiG7rKYh4dKLgRqnLiFQIffc76FfedqLf1iupyZ2pFhI05QW/P
         4gYs4PsHnAb5rlhEjHdxGARlTajfb6QcvugTj6adKtIX4t1jg49K+zSNpdv+N8uHcpWN
         arKzk9iJdzE81+BW/z06EMTf+eoBu6KmlY7ssae7PY9Y7BRskaTN5y8MmF0asltQwy+S
         tZmxN/C4u1E9Q8B0Q6qVaWx+TJoQVBtngTHuiO8u8UF+UV4ft3dAxQri1MLad7ODrmmM
         zH+A==
X-Gm-Message-State: ANhLgQ1PZNnINlhEN0XlpnYhSsOzhopHQkElykr+OlRyxBN9hXe9LLE2
        p/7XRKt4o2o2LyyhpMOX+Y5mJIHFho7r+XPeHsLurA==
X-Google-Smtp-Source: ADFU+vtD4HnTq3UfmlCzUqM+RhFFntaj90e/y+AJA0C4jv4DV6Pj58IGCjBufo2EGUOJdHk0PjrN/KRjW99ctKZKveI=
X-Received: by 2002:a1f:b695:: with SMTP id g143mr2990774vkf.59.1584534710631;
 Wed, 18 Mar 2020 05:31:50 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9f:3b21:0:0:0:0:0 with HTTP; Wed, 18 Mar 2020 05:31:50
 -0700 (PDT)
X-Originating-IP: [5.35.35.59]
In-Reply-To: <20200316164435.27751dbf@carbon>
References: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org> <20200316164435.27751dbf@carbon>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 18 Mar 2020 15:31:50 +0300
Message-ID: <CAOJe8K3RA7_kAN=KjCp7FN6=qY-nf1uqmAcOicDzqVnm4REsMA@mail.gmail.com>
Subject: Re: [PATCH net-next v4] xen networking: add basic XDP support for xen-netfront
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, jgross@suse.com,
        ilias.apalodimas@linaro.org, wei.liu@kernel.org, paul@xen.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/20, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> On Mon, 16 Mar 2020 16:09:36 +0300
> Denis Kirjanov <kda@linux-powerpc.org> wrote:
>
>> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
>> index 482c6c8..c06ae57 100644
>> --- a/drivers/net/xen-netfront.c
>> +++ b/drivers/net/xen-netfront.c
> [...]
>> @@ -778,6 +790,52 @@ static int xennet_get_extras(struct netfront_queue
>> *queue,
>>  	return err;
>>  }
>>
>> +u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
>> +		   struct xen_netif_rx_response *rx, struct bpf_prog *prog,
>> +		   struct xdp_buff *xdp)
>> +{
>> +	struct xdp_frame *xdpf;
>> +	u32 len = rx->status;
>> +	u32 act = XDP_PASS;
>> +	int err;
>> +
>> +	xdp->data_hard_start = page_address(pdata);
>> +	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
>> +	xdp_set_data_meta_invalid(xdp);
>> +	xdp->data_end = xdp->data + len;
>> +	xdp->rxq = &queue->xdp_rxq;
>> +	xdp->handle = 0;
>> +
>> +	act = bpf_prog_run_xdp(prog, xdp);
>> +	switch (act) {
>> +	case XDP_TX:
>> +		xdpf = convert_to_xdp_frame(xdp);
>> +		err = xennet_xdp_xmit(queue->info->netdev, 1,
>> +				&xdpf, 0);
>
> Strange line wrap, I don't think this is needed, please fix.
>
>
>> +		if (unlikely(err < 0))
>> +			trace_xdp_exception(queue->info->netdev, prog, act);
>> +		break;
>> +	case XDP_REDIRECT:
>> +		err = xdp_do_redirect(queue->info->netdev, xdp, prog);
>
> What is the frame size of the packet memory?

It's XEN_PAGE_SIZE (4k)

>
>
>> +		if (unlikely(err))
>> +			trace_xdp_exception(queue->info->netdev, prog, act);
>> +		xdp_do_flush();
>> +		break;
>> +	case XDP_PASS:
>> +	case XDP_DROP:
>> +		break;
>> +
>> +	case XDP_ABORTED:
>> +		trace_xdp_exception(queue->info->netdev, prog, act);
>> +		break;
>> +
>> +	default:
>> +		bpf_warn_invalid_xdp_action(act);
>> +	}
>> +
>> +	return act;
>> +}
>> +
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
>
