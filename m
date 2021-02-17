Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD7031E013
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 21:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbhBQUQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 15:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbhBQUQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 15:16:09 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49494C061756;
        Wed, 17 Feb 2021 12:15:29 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id b3so18720392wrj.5;
        Wed, 17 Feb 2021 12:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+zz2YA1Ycz4rjQhBCLT+XtcfJFck2JRWryC3+MkgsTg=;
        b=XRJlSy5yNZfi8Qw1wVhkCKj3GridyliNoTWMWWsuisNdOjOUrU/c0KDrdBNDAk0iDO
         Of3MtwQJTo3hlkADqFYIplXhDaaLmDtL9RPDp0L6gabM+pw5SvMEk9m/FwDz7LnXbQ69
         lqOA+SUmKwPqa09STNWLWik1TRt/Vy9CCDHKIEgr6lCRt35SZ+IUfGfPmz64hi7wlA9T
         dmAPsR0/gfo0yRMTLsh+egipRA7pDaRZ/X09lV/jt9cYxOUb4t3x3WI00RQTYIwlyCnF
         I+KeApiqVQD0WCCoSVPbEW//xIzKrxljmGzdFsdRdK6eR/FRVmJOmidQSJ1S7FlVHzTf
         l4ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+zz2YA1Ycz4rjQhBCLT+XtcfJFck2JRWryC3+MkgsTg=;
        b=Z3W80nvkAAgw/jp/F2gGAoncGRuPVWPp4g2nfvemNOFLGpd5FgK5XZ/viYrl6mMvDg
         kTD2h+age8rE9WZ8Mdv9ezzC731zF1Pq6RY1erWKO+orOeBCBNhB1WNSNSOBRjM0ru+L
         Ibm1BaS9HzJDFq/qi3GeGGYDPN/Q+OQ9A6GuExgxU3DGK4eU3JFhV89j2pd9eALLKQ3L
         /edDuH+R5jDs56Uxbl9EsMJMDhkpQXoXWOUdZ8EanDLYs4SNc3f8W4bT8w1nEWHGAKy/
         M+2qvUzl3wUabJFqfgR2IayFpiHMmi5Xfzj6QV4yv6Ni1BWS4PzGeN2A6/pC6KWhAyec
         QJUw==
X-Gm-Message-State: AOAM532Oe4xmVQ/c4LFMT4vjNz+upw5KdN2h+bqwOOytlJAovR/x4XoZ
        162vqTrnF56u2cqxn5FTU2s=
X-Google-Smtp-Source: ABdhPJyOsqLJlVyB56k6v+GrnLUQCB6Ru/aP/al4I/NmuxEYOkIPdsypkDMuSkzwjRfcnugrX782Nw==
X-Received: by 2002:a5d:4849:: with SMTP id n9mr861120wrs.159.1613592927088;
        Wed, 17 Feb 2021 12:15:27 -0800 (PST)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id v6sm5717215wrx.32.2021.02.17.12.15.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 12:15:26 -0800 (PST)
Subject: Re: [PATCH bpf-next] bpf: devmap: move drop error path to devmap for
 XDP_REDIRECT
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, toke@redhat.com, freysteinn.alfredsson@kau.se
References: <76469732237ce6d6cc6344c9500f9e32a123a56e.1613569803.git.lorenzo@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <1761e829-f6b6-d9eb-2b3a-878c0116171d@gmail.com>
Date:   Wed, 17 Feb 2021 20:15:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <76469732237ce6d6cc6344c9500f9e32a123a56e.1613569803.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/02/2021 13:56, Lorenzo Bianconi wrote:
> We want to change the current ndo_xdp_xmit drop semantics because
> it will allow us to implement better queue overflow handling.
> This is working towards the larger goal of a XDP TX queue-hook.
> Move XDP_REDIRECT error path handling from each XDP ethernet driver to
> devmap code. According to the new APIs, the driver running the
> ndo_xdp_xmit pointer, will break tx loop whenever the hw reports a tx
> error and it will just return to devmap caller the number of successfully
> transmitted frames. It will be devmap responsability to free dropped frames.
> Move each XDP ndo_xdp_xmit capable driver to the new API<snip>> diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
> index 1665529a7271..0c6650d2e239 100644
> --- a/drivers/net/ethernet/sfc/tx.c
> +++ b/drivers/net/ethernet/sfc/tx.c
> @@ -412,14 +412,6 @@ netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb
>  	return NETDEV_TX_OK;
>  }
>  
> -static void efx_xdp_return_frames(int n,  struct xdp_frame **xdpfs)
> -{
> -	int i;
> -
> -	for (i = 0; i < n; i++)
> -		xdp_return_frame_rx_napi(xdpfs[i]);
> -}
> -
>  /* Transmit a packet from an XDP buffer
>   *
>   * Returns number of packets sent on success, error code otherwise.
> @@ -492,12 +484,7 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
>  	if (flush && i > 0)
>  		efx_nic_push_buffers(tx_queue);
>  
> -	if (i == 0)
> -		return -EIO;
> -
> -	efx_xdp_return_frames(n - i, xdpfs + i);
> -
> -	return i;
> +	return i == 0 ? -EIO : i;
>  }

Could this be "return i ?: -EIO;"?  (I'm undecided on whether that would
 actually be better.)

Either way, have an
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
for the sfc part.
