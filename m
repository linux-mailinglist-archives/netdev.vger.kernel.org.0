Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8023E18F6AD
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 15:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgCWOSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 10:18:51 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:56188 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728446AbgCWOSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 10:18:51 -0400
Received: by mail-pj1-f68.google.com with SMTP id mj6so6237537pjb.5
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 07:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=greyhouse-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M3Wr65lLh2kuudYsljJta3QzD+9lmM4JGNQEJrj4vfw=;
        b=wdaXZz96KWSJIRQEj84GB/eYRmqlJYown71CEZEmDQdlGKN01lMn+JGqnq+iV/LezL
         pxXbwWT/IKgMnH+IVNI4AzmES4i8AfRtzc+Jv2eCve5wSLZwFGDbgDVpoqX9xMxPI8sG
         ht1k4j1Tx91FGmorzdec5maEt450XPR5pb2qcYA95CAoG5ThkUQEi3DpgJMaMv1bKkWa
         2ciuzEbTDguXQFZN3f08vKC0WoFS+Qak9+3FIfNL7v8tDoOnoxHBHm9q6InuEZfywrZp
         EdDyLnxG/UbpLWmVDk3PNRUb4aF1BGF6rVDfx99LICH1B4DXtTyb/sBhhIlT6gBZMLK6
         vUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M3Wr65lLh2kuudYsljJta3QzD+9lmM4JGNQEJrj4vfw=;
        b=mtwciTLTTxU6ia3khWKc47oKfyfbbxUqtWqz1j3GXasK4qRFG9/dolJxAUeQOE5LEl
         wsXp1CX+oDVDROFFz2m6GimG6ihIhPybDlPuLlS57bsfFe+ix6b1lil6ia47fHDVrw54
         RCjvwXtFbhzU/UIwIdX0kk0ZfmRsxmxUH4nS4fsHRXEzxctidHV07N1NkJIeFEUJRZ6T
         PkZ1y6DuMzygbuw64UAYs7WavzG/LYITkDayJcqlLcxBIPERId3sZjFsc7unpBfm9wbO
         rVqEgkBnaImaaxcdqShiCEDIwS+0EJBu+oqvVFQNjnpJWhnQpZFtiV5clXQfQq3AUeQY
         3jhA==
X-Gm-Message-State: ANhLgQ1CptKSs967l6MO+yvcsLdKMh4bTTdAu3EsjZi+tGmzcN5JR4Cn
        nj5aA4aZA8r3etwIa1tgq8OR7Q==
X-Google-Smtp-Source: ADFU+vvaQlEY2gL2y6UV1On9B7WtP2wMY2UQhM5xItVGcZ4odh9Y1yyKVJUdqeacFDfkLUQW52fsBA==
X-Received: by 2002:a17:90a:8087:: with SMTP id c7mr6755789pjn.148.1584973128533;
        Mon, 23 Mar 2020 07:18:48 -0700 (PDT)
Received: from C02YVCJELVCG.greyhouse.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id h64sm13080739pfg.191.2020.03.23.07.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 07:18:47 -0700 (PDT)
Date:   Mon, 23 Mar 2020 10:18:33 -0400
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
Message-ID: <20200323141833.GB21532@C02YVCJELVCG.greyhouse.net>
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

Talked with Jesper about this some more on IRC and he clarified
something for me that was bugging me.

> Cc: Michael Chan <michael.chan@broadcom.com>
> Cc: Andy Gospodarek <andrew.gospodarek@broadcom.com>

I know this is only an RFC, but feel free to add:

Reviewed-by: Andy Gospodarek <gospo@broadcom.com>

to this patch.  Thanks for your work on this!

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
>  	orig_data = xdp.data;
>  
>  	rcu_read_lock();
> 
> 
