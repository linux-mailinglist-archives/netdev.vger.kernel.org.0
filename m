Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F71B112D5E
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 15:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfLDOWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 09:22:09 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46037 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbfLDOWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 09:22:09 -0500
Received: by mail-lj1-f195.google.com with SMTP id d20so8264136ljc.12
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 06:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=d3Nxmw+vn1VuxFttdDZKUOezpfDYOtV4NA2f/g2zscU=;
        b=BkGkfmJGCsb6xciaWWy7sVyFHJwt4WpU8VDZdzMhwsbnF7SARshxSVLNkUg6qF13iG
         6VIgaTdFkiDXoCyBKrSWEX4/zUM/HkVsuf8Jt0SyIicaIewiQz/6lUrx5ksaQ1R+oXje
         h0RLZTQhdGO3ClBu0N+XxE4afiHSsLHWkgtM0BBGapEzoTA++Rw0Sf5VAjnAh9rGa/pT
         ZiqbqmyTWr74/bxfAC6+fzq2YYwT7B+BmgfkrNg5WsXEJjuZzcNwiYPKTNWWXEg1lqlM
         wS6KEyH5jYT4WDVSwk5Gky3WtllKQrcSHWbixcOBOE3GRLaEJKMEI+StmcwifgFxFWwO
         qSEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=d3Nxmw+vn1VuxFttdDZKUOezpfDYOtV4NA2f/g2zscU=;
        b=uHT2XheMHGthnAYoX1T04E9wFBBk5mm0ZUuETbAcsomxE6C2aTRWquFGzms5kox8Ml
         CLUydrZYKQLoSFzLB6m8B0oseOtYXNLUidcfoSNMXqGp3mvQ6wC/kdp0kwyWkNhS6w+4
         YYtC4QbARJNX+sj77MTNUHYI2fPBnTBXnQK4RWXfBNUYaTSdC8dIWSGKK0Ez5WkXEqGU
         g2mtproQdzC8weY58PfeUDGwYRg4Dtp7k+riz0W0jEKhdGfv4Z4K8ZwWyDpN+2FIJl42
         rfZ1MgOxLsoTHxRuur3SCIF/Y8i8VyrX6CFb6qupoMh0pFZHQfD1lK00ZA4NYHVwAq6g
         S/+g==
X-Gm-Message-State: APjAAAX6DegRlCBer9/bdzVYiM1ZofUnBVmSTjlFXiWE+zgNtebyHNIY
        p06hreKUTJ/06pB6GGJ+LD4bMDEgWJE=
X-Google-Smtp-Source: APXvYqxKlhMVgujp40CoS5qS4seav7v1+DL+/gCEnZ04ynl9ZbvxpIksSl5LG6/iJdMBH145iXP5RA==
X-Received: by 2002:a2e:9194:: with SMTP id f20mr2209513ljg.154.1575469326401;
        Wed, 04 Dec 2019 06:22:06 -0800 (PST)
Received: from khorivan (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id w1sm3303259lfe.96.2019.12.04.06.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 06:22:05 -0800 (PST)
Date:   Wed, 4 Dec 2019 16:22:03 +0200
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: davinci_cpdma: fix warning "device
 driver frees DMA memory with different size"
Message-ID: <20191204142202.GG2680@khorivan>
Mail-Followup-To: Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org
References: <20191204124618.18774-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191204124618.18774-1-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Grygorii,

On Wed, Dec 04, 2019 at 02:46:18PM +0200, Grygorii Strashko wrote:
>The TI CPSW(s) driver produces warning with DMA API debug options enabled:
>
>WARNING: CPU: 0 PID: 1033 at kernel/dma/debug.c:1025 check_unmap+0x4a8/0x968
>DMA-API: cpsw 48484000.ethernet: device driver frees DMA memory with different size
> [device address=0x00000000abc6aa02] [map size=64 bytes] [unmap size=42 bytes]
>CPU: 0 PID: 1033 Comm: ping Not tainted 5.3.0-dirty #41
>Hardware name: Generic DRA72X (Flattened Device Tree)
>[<c0112c60>] (unwind_backtrace) from [<c010d270>] (show_stack+0x10/0x14)
>[<c010d270>] (show_stack) from [<c09bc564>] (dump_stack+0xd8/0x110)
>[<c09bc564>] (dump_stack) from [<c013b93c>] (__warn+0xe0/0x10c)
>[<c013b93c>] (__warn) from [<c013b9ac>] (warn_slowpath_fmt+0x44/0x6c)
>[<c013b9ac>] (warn_slowpath_fmt) from [<c01e0368>] (check_unmap+0x4a8/0x968)
>[<c01e0368>] (check_unmap) from [<c01e08a8>] (debug_dma_unmap_page+0x80/0x90)
>[<c01e08a8>] (debug_dma_unmap_page) from [<c0752414>] (__cpdma_chan_free+0x114/0x16c)
>[<c0752414>] (__cpdma_chan_free) from [<c07525c4>] (__cpdma_chan_process+0x158/0x17c)
>[<c07525c4>] (__cpdma_chan_process) from [<c0753690>] (cpdma_chan_process+0x3c/0x5c)
>[<c0753690>] (cpdma_chan_process) from [<c0758660>] (cpsw_tx_mq_poll+0x48/0x94)
>[<c0758660>] (cpsw_tx_mq_poll) from [<c0803018>] (net_rx_action+0x108/0x4e4)
>[<c0803018>] (net_rx_action) from [<c010230c>] (__do_softirq+0xec/0x598)
>[<c010230c>] (__do_softirq) from [<c0143914>] (do_softirq.part.4+0x68/0x74)
>[<c0143914>] (do_softirq.part.4) from [<c0143a44>] (__local_bh_enable_ip+0x124/0x17c)
>[<c0143a44>] (__local_bh_enable_ip) from [<c0871590>] (ip_finish_output2+0x294/0xb7c)
>[<c0871590>] (ip_finish_output2) from [<c0875440>] (ip_output+0x210/0x364)
>[<c0875440>] (ip_output) from [<c0875e2c>] (ip_send_skb+0x1c/0xf8)
>[<c0875e2c>] (ip_send_skb) from [<c08a7fd4>] (raw_sendmsg+0x9a8/0xc74)
>[<c08a7fd4>] (raw_sendmsg) from [<c07d6b90>] (sock_sendmsg+0x14/0x24)
>[<c07d6b90>] (sock_sendmsg) from [<c07d8260>] (__sys_sendto+0xbc/0x100)
>[<c07d8260>] (__sys_sendto) from [<c01011ac>] (__sys_trace_return+0x0/0x14)
>Exception stack(0xea9a7fa8 to 0xea9a7ff0)
>...
>
>The reason is that cpdma_chan_submit_si() now stores original buffer length
>(sw_len) in CPDMA descriptor instead of adjusted buffer length (hw_len)
>used to map the buffer.

It's kind not complete fix.
Seems like debug just shows it only fo dma_map, but for sync it doesn't.
The issue is not in swlen, it contains smilar size and inited to len equally as
hw_len. Problem that hw_len is inited later then swlen after below:

	if (len < ctlr->params.min_packet_size) {
		len = ctlr->params.min_packet_size;
		chan->stats.runt_transmit_buff++;
	}

Thus it potentially can have different size for lens less min_pakcet_size, that
could never happen but tracked with dma debug.

	mode = CPDMA_DESC_OWNER | CPDMA_DESC_SOP | CPDMA_DESC_EOP;
	cpdma_desc_to_port(chan, mode, si->directed);

	if (si->data_dma) {
		buffer = si->data_dma;
		dma_sync_single_for_device(ctlr->dev, buffer, len, chan->dir);
		swlen |= CPDMA_DMA_EXT_MAP;
	} else {
		buffer = dma_map_single(ctlr->dev, si->data_virt, len, chan->dir);
		ret = dma_mapping_error(ctlr->dev, buffer);
		if (ret) {
			cpdma_desc_free(ctlr->pool, desc, 1);
			return -EINVAL;
		}
	}

So, the fix you propose do it only for dma_map_single. But, even it should never
happen, it should be fixed for dma_sync() also for consistency.
Proposition is to move the following initialization:

	int				swlen = len;

after

	if (len < ctlr->params.min_packet_size) {
		len = ctlr->params.min_packet_size;
		chan->stats.runt_transmit_buff++;
	}

->     swlen = len;

And that should work for both cases, even if dma_sync uses len:

dma_sync_single_for_device(ctlr->dev, buffer, len, chan->dir);

....


>
>Hence, fix an issue by using adjusted buffer length (hw_len) to unmap
>packet buffer.
>
>Cc: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>Fixes: 6670acacd59e ("net: ethernet: ti: davinci_cpdma: add dma mapped submit")
>Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>---
> drivers/net/ethernet/ti/davinci_cpdma.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
>index 37ba708ac781..6be5a514d5b1 100644
>--- a/drivers/net/ethernet/ti/davinci_cpdma.c
>+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
>@@ -1197,12 +1197,13 @@ static void __cpdma_chan_free(struct cpdma_chan *chan,
> {
> 	struct cpdma_ctlr		*ctlr = chan->ctlr;
> 	struct cpdma_desc_pool		*pool = ctlr->pool;
>+	int				origlen, hw_len;
> 	dma_addr_t			buff_dma;
>-	int				origlen;
> 	uintptr_t			token;
>
> 	token      = desc_read(desc, sw_token);
> 	origlen    = desc_read(desc, sw_len);
>+	hw_len = desc_read(desc, hw_len);
>
> 	buff_dma   = desc_read(desc, sw_buffer);
> 	if (origlen & CPDMA_DMA_EXT_MAP) {
>@@ -1210,7 +1211,7 @@ static void __cpdma_chan_free(struct cpdma_chan *chan,
> 		dma_sync_single_for_cpu(ctlr->dev, buff_dma, origlen,
> 					chan->dir);
> 	} else {
>-		dma_unmap_single(ctlr->dev, buff_dma, origlen, chan->dir);
>+		dma_unmap_single(ctlr->dev, buff_dma, hw_len, chan->dir);
> 	}

I've tried to avod two register reads on data path. So read only one sw_len
that actually supposed to contain same size. So proposition is to fix it like
in above comment would be more correct, and leave this func unchanged I mean in:

static int cpdma_chan_submit_si(struct submit_info *si) {}

>
> 	cpdma_desc_free(pool, desc, 1);
>-- 
>2.17.1
>

-- 
Regards,
Ivan Khoronzhuk
