Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDAEE5F5E5
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 11:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfGDJqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 05:46:03 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41946 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfGDJqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 05:46:03 -0400
Received: by mail-lj1-f196.google.com with SMTP id 205so5520806ljj.8
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 02:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YYSoaxyHn+OM7aLthyxFHVYuodYLIoIqvvJaHptzBW4=;
        b=eovQFprJeSZaE++AS9nDZt1iR2MzTyS585nK95TbQmehKLXEuvtOqtVr8Gh/jAnGh+
         Z8HcHBiStRqfcni3OuuH9Vj6n2tUiy8jFYBzEDlDEopmoG+5QBuzkLmivT4bed+L/Rqo
         Q6eJ4eKK/30EzpbroLrQSAGHZ4A0GFYYXaHk6QJAwsZ8oGhCUG93dnnQgzNKk02L9OLl
         CyLu462lyW3o/ht1IhvrZ3n3RF/hvUqQrAjvL/YQrvPrjeFUUJ3uM4Ot4UrMI656yrV/
         0x1qkUd3PX/ek1NQsi5krsJzTIShRVu7zoqaQeW6inFZ795ypOBVdCYXD2zLzIjsfFbg
         jh4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=YYSoaxyHn+OM7aLthyxFHVYuodYLIoIqvvJaHptzBW4=;
        b=FnK7leqQUlZhLw6b9cF2bRoJ9pclqHOKaMBOs4k76x3dKncUldks4E+rk8A0ND3wIA
         XQSf/wDLM7uh3ywIBN/uZnWgEEytYRPyELv8tyESB5YztMoV9YoeuJObIb4YCOerIk44
         9xnYRUeduSwd9OVBRHFgUZbA7gaWTBgj43JrUJzNlpJsbw+k0Syvf5ifZT+dmhbzsbv7
         8AoV2E20pMw3Pa1mmXs1OErWqNR0PwvOoXAZ4ChYUZkzfl5ybNu3AJ8hLi47CC8+3/R2
         1yF32kl8sWuGOykdvZFlvP9iRyK1ltknkLi/7HlqgNnStMUtIMFFPyHKivqx1AkzpvY3
         TFOA==
X-Gm-Message-State: APjAAAXifd/sPmqFuh3Dmo4wSW5FKgYUNCTmQPLHuPYkOAOTbWR+fgj7
        jAd3gwL+xFwvD3XTHs5JdPWF+g==
X-Google-Smtp-Source: APXvYqyyYuPxgewfoieiOqZgkRU8UL4Ww37bWQBHmCbGGhDFNJ0CvJI6TpKMajeRuajxKk9qXCe48g==
X-Received: by 2002:a2e:9a13:: with SMTP id o19mr24559296lji.102.1562233560531;
        Thu, 04 Jul 2019 02:46:00 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id s1sm1004610ljd.83.2019.07.04.02.45.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Jul 2019 02:46:00 -0700 (PDT)
Date:   Thu, 4 Jul 2019 12:45:57 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH v6 net-next 5/5] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190704094556.GB19839@khorivan>
Mail-Followup-To: Jesper Dangaard Brouer <brouer@redhat.com>,
        grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
References: <20190703101903.8411-1-ivan.khoronzhuk@linaro.org>
 <20190703101903.8411-6-ivan.khoronzhuk@linaro.org>
 <20190704111939.5d845071@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190704111939.5d845071@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 11:19:39AM +0200, Jesper Dangaard Brouer wrote:
>On Wed,  3 Jul 2019 13:19:03 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> Add XDP support based on rx page_pool allocator, one frame per page.
>> Page pool allocator is used with assumption that only one rx_handler
>> is running simultaneously. DMA map/unmap is reused from page pool
>> despite there is no need to map whole page.
>>
>> Due to specific of cpsw, the same TX/RX handler can be used by 2
>> network devices, so special fields in buffer are added to identify
>> an interface the frame is destined to. Thus XDP works for both
>> interfaces, that allows to test xdp redirect between two interfaces
>> easily. Aslo, each rx queue have own page pools, but common for both
>> netdevs.
>>
>> XDP prog is common for all channels till appropriate changes are added
>> in XDP infrastructure. Also, once page_pool recycling becomes part of
>> skb netstack some simplifications can be added, like removing
>> page_pool_release_page() before skb receive.
>>
>> In order to keep rx_dev while redirect, that can be somehow used in
>> future, do flush in rx_handler, that allows to keep rx dev the same
>> while reidrect. It allows to conform with tracing rx_dev pointed
>> by Jesper.
>
>So, you simply call xdp_do_flush_map() after each xdp_do_redirect().
>It will kill RX-bulk and performance, but I guess it will work.
>
>I guess, we can optimized it later, by e.g. in function calling
>cpsw_run_xdp() have a variable that detect if net_device changed
>(priv->ndev) and then call xdp_do_flush_map() when needed.

It's problem of cpsw already and can be optimized locally by own
bulk queues for instance, if it will be simple if really needed ofc.

>
>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>  drivers/net/ethernet/ti/Kconfig        |   1 +
>>  drivers/net/ethernet/ti/cpsw.c         | 485 ++++++++++++++++++++++---
>>  drivers/net/ethernet/ti/cpsw_ethtool.c |  66 +++-
>>  drivers/net/ethernet/ti/cpsw_priv.h    |   7 +
>>  4 files changed, 502 insertions(+), 57 deletions(-)
>>
>[...]
>> +static int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
>> +			struct page *page)
>> +{
>> +	struct cpsw_common *cpsw = priv->cpsw;
>> +	struct net_device *ndev = priv->ndev;
>> +	int ret = CPSW_XDP_CONSUMED;
>> +	struct xdp_frame *xdpf;
>> +	struct bpf_prog *prog;
>> +	u32 act;
>> +
>> +	rcu_read_lock();
>> +
>> +	prog = READ_ONCE(priv->xdp_prog);
>> +	if (!prog) {
>> +		ret = CPSW_XDP_PASS;
>> +		goto out;
>> +	}
>> +
>> +	act = bpf_prog_run_xdp(prog, xdp);
>> +	switch (act) {
>> +	case XDP_PASS:
>> +		ret = CPSW_XDP_PASS;
>> +		break;
>> +	case XDP_TX:
>> +		xdpf = convert_to_xdp_frame(xdp);
>> +		if (unlikely(!xdpf))
>> +			goto drop;
>> +
>> +		cpsw_xdp_tx_frame(priv, xdpf, page);
>> +		break;
>> +	case XDP_REDIRECT:
>> +		if (xdp_do_redirect(ndev, xdp, prog))
>> +			goto drop;
>> +
>> +		/* as flush requires rx_dev to be per NAPI handle and there
>> +		 * is can be two devices putting packets on bulk queue,
>> +		 * do flush here avoid this just for sure.
>> +		 */
>> +		xdp_do_flush_map();
>
>> +		break;
>> +	default:
>> +		bpf_warn_invalid_xdp_action(act);
>> +		/* fall through */
>> +	case XDP_ABORTED:
>> +		trace_xdp_exception(ndev, prog, act);
>> +		/* fall through -- handle aborts by dropping packet */
>> +	case XDP_DROP:
>> +		goto drop;
>> +	}
>> +out:
>> +	rcu_read_unlock();
>> +	return ret;
>> +drop:
>> +	rcu_read_unlock();
>> +	page_pool_recycle_direct(cpsw->page_pool[ch], page);
>> +	return ret;
>> +}
>
>-- 
>Best regards,
>  Jesper Dangaard Brouer
>  MSc.CS, Principal Kernel Engineer at Red Hat
>  LinkedIn: http://www.linkedin.com/in/brouer

-- 
Regards,
Ivan Khoronzhuk
