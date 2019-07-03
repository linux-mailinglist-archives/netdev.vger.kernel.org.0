Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBC75DEFC
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 09:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfGCHjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 03:39:03 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42344 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfGCHjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 03:39:03 -0400
Received: by mail-lf1-f66.google.com with SMTP id s19so290865lfb.9
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 00:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2Wp52PBXKgmN1eJSawD7UHQEQNJnFNq41D1U5ZiE5Bo=;
        b=Xh1pMxs44/cvgbIPdlvqWFnxIJ8en8yjJHAJY6KuWeq1CEy3k59s8hTBuaV/uvBt3m
         ycpPeoODSURlw/yRgrS9/Ix2TTPYntmr15kL0HXjEBAHulbR0XvdXSwImep3KZ0jLT6X
         xTkSmgo0jYD7TQosCD70j71q3pejld6xQVHya/IukRJm4km2mbLSsSnNzkY9CLXVAbZ5
         0YS8qFpA0RjSPWjfTu8/nVmGbQ1PtI8oOMysnJSZb2Vdg3P95jdot7hY+X1M9Hs47pr0
         F2PcCz6fK0JvmGwcEVYXEgRU5iqE+h0xid1o2dDSun7EagnjIf1nf0tmqTHNq8QWjhDP
         3SuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=2Wp52PBXKgmN1eJSawD7UHQEQNJnFNq41D1U5ZiE5Bo=;
        b=VLwGdvGDPdubhqpXm6p+ZhEXtMm1akQFYLQkFe2KGKdA2ADAsnvbMkTSMa76ndjdRS
         fZiY14d4YWC7hS278oxe7XhnViNkVqWMcOotIEtSkQca6HdH2+yTbpgJKiux8u9Hwekf
         w30UzZJVitxkABTmr3TMB+DjvpjJiOzTMDxCEWYiiYj7wOCXbLZqjFCQei3R2bTGarkF
         NRbqb79ymACs3kp1OFB3RXEzoBf0BVURMnOcvGtlc4LLAiVO+Sps1jMtnLFXLjK48RZs
         dnlbe4l1viEp3ApMY969SCdhaE9N0a8CoJhL7fNlyTiwYHlUVa62ngpfC/zttaXAhwta
         AJOg==
X-Gm-Message-State: APjAAAUp9QRg4/PcKLzOo5dbHmScAOPTOEvY0KUQHdY+3II40KlKUbEl
        oDVy1u4W89Z0Kqq6SHkMXjYJxQ==
X-Google-Smtp-Source: APXvYqwM0R72JZGl28dY5apLp/0qpK7E8sI9lybonc8uNIDSvz67trZs+adr4gBSsGpVXl3/NyBo2A==
X-Received: by 2002:ac2:42ca:: with SMTP id n10mr5174666lfl.121.1562139540856;
        Wed, 03 Jul 2019 00:39:00 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id h129sm263683lfd.74.2019.07.03.00.38.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Jul 2019 00:39:00 -0700 (PDT)
Date:   Wed, 3 Jul 2019 10:38:58 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH v5 net-next 6/6] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190703073857.GA2927@khorivan>
Mail-Followup-To: Jesper Dangaard Brouer <brouer@redhat.com>,
        grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
References: <20190630172348.5692-1-ivan.khoronzhuk@linaro.org>
 <20190630172348.5692-7-ivan.khoronzhuk@linaro.org>
 <20190703092603.66f36914@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190703092603.66f36914@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 09:26:03AM +0200, Jesper Dangaard Brouer wrote:
>
>On Sun, 30 Jun 2019 20:23:48 +0300 Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
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
>
>Looking at the details what happen when a single RX-queue can receive
>into multiple net_device'es.  I realize that this driver will
>violate/kill some of the "hidden"/implicit RX-bulking that the
>XDP_REDIRECT code depend on for performance.
>
>Specifically, it violate this assumption:
> https://github.com/torvalds/linux/blob/v5.2-rc7/kernel/bpf/devmap.c#L324-L329
>
>	/* Ingress dev_rx will be the same for all xdp_frame's in
>	 * bulk_queue, because bq stored per-CPU and must be flushed
>	 * from net_device drivers NAPI func end.
>	 */
>	if (!bq->dev_rx)
>		bq->dev_rx = dev_rx;
>
>This drivers "NAPI func end", can have received into multiple
>net_devices, before it's NAPI cycle ends.  Thus, violating this code
>assumption.
). I said, I moved to be per device in rx_handler. It violates nothing.

>
>Knowing all xdp_frame's in the bulk queue is from the same net_device,
>can be used to further optimize XDP.  E.g. the dev->netdev_ops->ndo_xdp_xmit()
>call don't take fully advantage of this, yet.  If we merge this driver,
>it will block optimizations in this area.
>
>NACK

Jesper,

Seems I said that I moved it to flush, that does
dev->netdev_ops->ndo_xdp_xmit(), to rx_handler, so that it's done per device,
so device is knows per each flush.

In the code, I hope everyone can see ..., after each flush dev_rx is cleared
to 0. So no any impact on it.

As for me, it's very not clear and strange decision.

-- 
Regards,
Ivan Khoronzhuk
