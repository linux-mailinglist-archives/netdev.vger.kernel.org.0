Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461694CB87D
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 09:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiCCINY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 03:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiCCINV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 03:13:21 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3361913F13
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 00:12:36 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r10so6502920wrp.3
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 00:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4i7PLQ1EKqIYmxsrfE2b/ObB0CExZmbuvYsK31J6spo=;
        b=FKegCt6aSbb9vVQcxhE4IuEBwFHJVa5zepHQmMcSf5nItPF8yJKNuc2prnJpwxmWqO
         KEn9kG3OBZ90Ci3vWtT4G6MXNhXc4UmrYhcJpIqZnP1WrzoQSAXTtEKAbkykqfoHhriO
         QXhQwTZFsuw9Q+vjPGBnnE7zX9sxOEtB/C5IIX3JKWiQPZOqoVwz04gY5btTo+s70SYh
         Dau7YkbHsZ9JxaNsmVF+VgymlZKvY0c5d5vFmEy6Sl6Y3n9zK39QLe/ft/laNxqWZG3U
         MmsUGT4JO0goVb1irXXDGWQGKchc5kFLV/6+A5IBFEyknpiUb69i1Wf+4AiLFoSTr6OM
         uTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=4i7PLQ1EKqIYmxsrfE2b/ObB0CExZmbuvYsK31J6spo=;
        b=YAYB4mG1HxInnwZMXjDV4gQHZNMy/HI0UAlNk8mvj2dQvrH1XvIkluLjGcpGe3lfj/
         okm7CJyVFH+LUdruBacvfLQgAbc3S6Yrdc9i3QnKBAAM2kCrmJ09q7cP3CNWVZnywb3f
         qbpLqWpSeZDcHyVTrs71lfC21yt68jUBC7vqqHF3mLywjkY3FXmjS3L1CUxRqGHMq+s8
         Jz8+xea75+JeAWondonP1hdcGqS9mpnqVuBsm4jNldMaY/RLTWJmMwRGicEKCsernHat
         O2OadurkXRlEgGOeCPR8WfCgEQrF31cnLnvK80wD/HRhmANGyArFxWgK0hunoG6xN+R7
         1/rA==
X-Gm-Message-State: AOAM531uwUbwbZo2laCTgz4iXNECaJoDqQUOGF8/5Gj7qLRNdfRnhPVz
        +ZyDjI/XFcr94LDxeipD0tk=
X-Google-Smtp-Source: ABdhPJzeldJiQeo09DnrsnxLbAQOgj/u6b+f4oyB2Z5hhHKB00j/98wrim0piL7mAdac5enjBfo93g==
X-Received: by 2002:a5d:50c5:0:b0:1f0:2111:8f74 with SMTP id f5-20020a5d50c5000000b001f021118f74mr7339423wrt.211.1646295154700;
        Thu, 03 Mar 2022 00:12:34 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id i15-20020a5d522f000000b001e85b14dadcsm1298261wra.5.2022.03.03.00.12.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 03 Mar 2022 00:12:34 -0800 (PST)
Date:   Thu, 3 Mar 2022 08:12:32 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Niels Dossche <dossche.niels@gmail.com>
Cc:     netdev@vger.kernel.org, Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] sfc: extend the locking on mcdi->seqno
Message-ID: <20220303081232.rjxjdnj4k2p33p7m@gmail.com>
Mail-Followup-To: Niels Dossche <dossche.niels@gmail.com>,
        netdev@vger.kernel.org, Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220301222822.19241-1-dossche.niels@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301222822.19241-1-dossche.niels@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 11:28:22PM +0100, Niels Dossche wrote:
> seqno could be read as a stale value outside of the lock. The lock is
> already acquired to protect the modification of seqno against a possible
> race condition. Place the reading of this value also inside this locking
> to protect it against a possible race condition.
> 
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/mcdi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
> index be6bfd6b7ec7..50baf62b2cbc 100644
> --- a/drivers/net/ethernet/sfc/mcdi.c
> +++ b/drivers/net/ethernet/sfc/mcdi.c
> @@ -163,9 +163,9 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
>  	/* Serialise with efx_mcdi_ev_cpl() and efx_mcdi_ev_death() */
>  	spin_lock_bh(&mcdi->iface_lock);
>  	++mcdi->seqno;
> +	seqno = mcdi->seqno & SEQ_MASK;
>  	spin_unlock_bh(&mcdi->iface_lock);
>  
> -	seqno = mcdi->seqno & SEQ_MASK;
>  	xflags = 0;
>  	if (mcdi->mode == MCDI_MODE_EVENTS)
>  		xflags |= MCDI_HEADER_XFLAGS_EVREQ;
> -- 
> 2.35.1
