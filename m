Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 377E0605A4
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 14:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfGEMBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 08:01:21 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43407 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfGEMBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 08:01:21 -0400
Received: by mail-lj1-f194.google.com with SMTP id 16so8992286ljv.10
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 05:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Bwcx4Wrt/iXqyeT5/Qi9DpMy8WMhSBFAEuk3MBcreWs=;
        b=PDLasy29nXLVksqy7cLdFBOQ9g2BdW8VmAJB2XAM3FVzzudxYV1GYTh4MxhCTAhdRY
         I2eU7LywN45QJfSknrIMQcUhoFzKrFlbBXQDiWO6sbH9bRermdHBGkNFBwbt3Dey734R
         MLg9SOSXh8SW1giZ1GMV975NOYl7iUiaPi6QMePfFqIhiC2aHaE7zyV3pFtm3ncn2AqN
         GzHLIRxgQtIoaBvYzUNMsHlhw7MtFqXZhGDAnNf38XhdqKak8Af/TBkCAeaEEwI22phG
         Cdi8EBwpTxIl071uBoKLN5i/SLqStnx6Qba+01fW4FVWgH5SiFipPCRQ2pD5Zxr73ip0
         IjCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=Bwcx4Wrt/iXqyeT5/Qi9DpMy8WMhSBFAEuk3MBcreWs=;
        b=HP/vvQ/wr/5BBrig3bgTh3l9cHYM+PwpkSiQB3h43pIniKunmTm9w0sS4Cjiv5NjQS
         VbU8XgDe0yxkbozqeurlxkX/K0SSZbZ3pHZMKvGVEoYi/aKStHer4fEYg97cKK8wm/sE
         MNfIa0rWG9bz3dBivYfn5XMLIduwzTxS8fuvuTZ08x3fBaFrjAQwkAy/+o/KDaMIOWdI
         3HsfnJbQtUHZnjPRlIbb6zW2GmF0jWsfr0D80IHXoFshzBv8K9ELSuM5CB7EAd21gz7T
         E0y3MIr4jK7Hr2wOepSTKj3QOY5A6nKpu3Jb5aD8O2HcrN/ZqmlEIZ3OVpovTuODBEZQ
         kmCA==
X-Gm-Message-State: APjAAAWpk+jVmNsEfZgq3xohLuBzAg36W6KBlbVa735i4JRzTdLb6rBR
        bcHJYs3rcaR642HXhJxEXXVq/A==
X-Google-Smtp-Source: APXvYqymqamwctlOmGse9fcGqqLcn0TvUuXCUQ+EQ0I3fubLivDV0hSv0DHD5tkqr5to/nt2Tz02tg==
X-Received: by 2002:a2e:3a13:: with SMTP id h19mr1946573lja.220.1562328079191;
        Fri, 05 Jul 2019 05:01:19 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id h18sm1351494lfc.40.2019.07.05.05.01.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Jul 2019 05:01:18 -0700 (PDT)
Date:   Fri, 5 Jul 2019 15:01:16 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH v7 net-next 5/5] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190705120114.GA3587@khorivan>
Mail-Followup-To: Jesper Dangaard Brouer <brouer@redhat.com>,
        grygorii.strashko@ti.com, davem@davemloft.net, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
References: <20190704231406.27083-1-ivan.khoronzhuk@linaro.org>
 <20190704231406.27083-6-ivan.khoronzhuk@linaro.org>
 <20190705131354.15a9313c@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190705131354.15a9313c@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 05, 2019 at 01:13:54PM +0200, Jesper Dangaard Brouer wrote:
>On Fri,  5 Jul 2019 02:14:06 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> +static int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
>> +			     struct page *page)
>> +{
>> +	struct cpsw_common *cpsw = priv->cpsw;
>> +	struct cpsw_meta_xdp *xmeta;
>> +	struct cpdma_chan *txch;
>> +	dma_addr_t dma;
>> +	int ret, port;
>> +
>> +	xmeta = (void *)xdpf + CPSW_XMETA_OFFSET;
>> +	xmeta->ndev = priv->ndev;
>> +	xmeta->ch = 0;
>> +	txch = cpsw->txv[0].ch;
>> +
>> +	port = priv->emac_port + cpsw->data.dual_emac;
>> +	if (page) {
>> +		dma = page_pool_get_dma_addr(page);
>> +		dma += xdpf->data - (void *)xdpf;
>
>This code is only okay because this only happens for XDP_TX, where you
>know this head-room calculation will be true.  The "correct"
>calculation of the head-room would be:
>
>  dma += xdpf->headroom + sizeof(struct xdp_frame);
>
>The reason behind not using xdpf pointer itself as "data_hard_start",
>is to allow struct xdp_frame to be located in another memory area.

My assumption was based on:

struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
{
	...
	xdp_frame = xdp->data_hard_start;
	...

	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
	...
}

But agree, it doesn't contradict the reason in question.
So, better use proposed variant. Will check and do this in v8 a little later:

dma += xdpf->headroom + sizeof(struct xdp_frame);

>This will be useful for e.g. AF_XDP transmit, or other zero-copy
>transmit to go through ndo_xdp_xmit() (as we don't want userspace to
>be-able to e.g. "race" change xdpf->len during transmit/DMA-completion).
>
>
>> +		ret = cpdma_chan_submit_mapped(txch, cpsw_xdpf_to_handle(xdpf),
>> +					       dma, xdpf->len, port);
>> +	} else {
>> +		if (sizeof(*xmeta) > xdpf->headroom) {
>> +			xdp_return_frame_rx_napi(xdpf);
>> +			return -EINVAL;
>> +		}
>> +
>> +		ret = cpdma_chan_submit(txch, cpsw_xdpf_to_handle(xdpf),
>> +					xdpf->data, xdpf->len, port);
>> +	}
>
>
>
>-- 
>Best regards,
>  Jesper Dangaard Brouer
>  MSc.CS, Principal Kernel Engineer at Red Hat
>  LinkedIn: http://www.linkedin.com/in/brouer

-- 
Regards,
Ivan Khoronzhuk
