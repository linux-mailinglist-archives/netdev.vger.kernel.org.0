Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A778C18D850
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 20:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgCTTWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 15:22:10 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39341 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbgCTTWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 15:22:10 -0400
Received: by mail-wm1-f68.google.com with SMTP id a9so4593150wmj.4
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 12:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=greyhouse-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9P5O0AS7HRh+I8C+OjVtDoYqCuGPvGOwix23GF2wDY4=;
        b=oqX1rnQRW0Gd5NL3xE6UG7u9F9ApZSw5EtnSya7y7Tdzo1Gk1QtKlpzFNyC0pbxmvb
         WevonLNTk4AW0LvBcbOnyKceIazkRN1M00jh7Rqf3KuyfoA/FTqsW5ly7L3DlYDIRogX
         5StexToZMYSlwbhwfRC0YCqKbywsTxhiZX22wE2j/lvWhDMZRliynVEGSAsot9sNp3kK
         G7cvxWnRztwuKwsAtoL8OO3kZNzTYY1N7clKUPRm6gW8MFLXOGFofjxM/5Ca2TaRjh/5
         wHj9i6kfBBNPMt3RWNZ/nagFR4WdNUP/KbBIGy7m4syBGTfocO/7olpTBELfsMbLokHu
         EkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9P5O0AS7HRh+I8C+OjVtDoYqCuGPvGOwix23GF2wDY4=;
        b=eXZvXnV/jUnGnsg5ILqmVpdroB+wubSgNZphKJguLCsxIH/kfN5/zmCZQoLfLJlzWp
         O6hHonnrAsKZO5YTEb0imrHa0+ekVpjBDFqL5jJqHUvwafitrzmG+hnV84/MDZj+QuiX
         TylHm96v6zxZgyKTKTkRmV0ekfX2y/cNlG6zuphbhSQjwymzCyb/izSTjhmbVHbcA/c7
         jVc0t9ed17NevzJROcpHDblbP5KwN0CqIOQTPDvJ6uARXnvtZRqAT+IW3p5P5IomNI2s
         CI88LVYtP0PFE2ZgGt0JATBhYwAx9jJTqTrJ38i8rfUT32Owc467dYUcgFji3KPUeMmh
         0eXQ==
X-Gm-Message-State: ANhLgQ2Q6I5M4qAP1VfO0Zer1tYXKhmXO2r/o3cZ8aNkoctyqk7hpJLa
        LDLrOLzQfiW5WQOq4+gdvcK2/A==
X-Google-Smtp-Source: ADFU+vsh8NvD250OHJRQCYjjKBIB63HCaq9gq2sYZ54AEj+UsTEINfyXqTxTeEl5VrOiqQs2CFoMHA==
X-Received: by 2002:a1c:4642:: with SMTP id t63mr11849276wma.164.1584732128213;
        Fri, 20 Mar 2020 12:22:08 -0700 (PDT)
Received: from C02YVCJELVCG.greyhouse.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id n18sm9407452wrw.34.2020.03.20.12.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 12:22:07 -0700 (PDT)
Date:   Fri, 20 Mar 2020 15:22:01 -0400
From:   Andy Gospodarek <andy@greyhouse.net>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH RFC v1 03/15] bnxt: add XDP frame size to driver
Message-ID: <20200320192201.GA21532@C02YVCJELVCG.greyhouse.net>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
 <158446616289.702578.7889111879119296431.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158446616289.702578.7889111879119296431.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 06:29:22PM +0100, Jesper Dangaard Brouer wrote:
> This driver uses full PAGE_SIZE pages when XDP is enabled.
> 
> Cc: Michael Chan <michael.chan@broadcom.com>
> Cc: Andy Gospodarek <andrew.gospodarek@broadcom.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> index c6f6f2033880..5e3b4a3b69ea 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> @@ -138,6 +138,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
>  	xdp_set_data_meta_invalid(&xdp);
>  	xdp.data_end = *data_ptr + *len;
>  	xdp.rxq = &rxr->xdp_rxq;
> +	xdp.frame_sz = PAGE_SIZE; /* BNXT_RX_PAGE_MODE(bp) when XDP enabled */

So if we want this to be the true size that the packet inside the the DMA
buffer could grow to, I _think_ this would need to be:

	xdp.frame_sz = PAGE_SIZE - XDP_PACKET_HEADROOM;

but I also noted that in patch 8 of the series that there is a check
against data_end - data_hard_start, so functionally your original patch
appears to be correct.

If the intent was just to capture the size of the [DMA] buffer available
for the datagram, maybe calling this new field 'buf_sz' or similar would
be nice as it does not convey anything about the on-wire size like
'frame_sz' does.


>  	orig_data = xdp.data;
>  
>  	rcu_read_lock();
> 
> 
