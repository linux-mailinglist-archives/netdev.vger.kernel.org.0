Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92D2613242
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiJaJJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiJaJJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:09:42 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EEADE91;
        Mon, 31 Oct 2022 02:09:39 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id l14so15030607wrw.2;
        Mon, 31 Oct 2022 02:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RJFX5ysJMUU9WDAws0OEPd7bjori/MpLo9tT2/810cY=;
        b=BBUCHw6WDJ3qmgLw8SfYuCJNVs7j3ozexM7IOpQsNF8WquJg0ftYqJVSkDXQsV44SQ
         LwKPbG3FJ0CyK0OJPYr9scW7DCDyB6qfSljDwWPORC+I+oeDcY6IcjMa6B2RFvkVKqME
         zRd91Isy8HJIEqgmf6nV6wW4VDbRm/OtsGARZh5IXOeOQC3L2gH+UbXPMMK46IXxHfgz
         Corjf/wLlgu5MEbpqzqFiw/88n+jjBGa+kXqxpucaABV4gVH+yP6eesKa/SDnF6w50Tb
         UydEhhFnarby8y9MdS+gDSgJaNbqObqQGiktXOwP32kVCtQth3tlIacs8JLhq/6c6Yyv
         HNBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RJFX5ysJMUU9WDAws0OEPd7bjori/MpLo9tT2/810cY=;
        b=bAT/coWyOYDvQpN6XadsKOR/6TNTUjR7cJ7xzDtPTtmGQ8rOh/oIK1RRF2+/uaBqi/
         o5aibf2ys/f65xGqyiU2GivVN9wXhHL8NfONSWMyjiE5j3ip1mC4EGtN7y3hCrTGpv3C
         LUXP+jDkqlQcdR+I1ZZK1KteWFCtyD6ohbUwpLyXrJa4lX1gI4Gt1cY2eo7Fe9+v0Fd6
         aWl6IrjfwKEY3d7ajGRCY9e/FsJrILre9wGxyK6qUsO5pDFWm5jOSk+EY4Wr6T7wqNoO
         ru51Qem9lRdIS0cPmr792Utk5krO8L5KlMWUeY4/13c4gjbsyupz696STfly4V0bOLzi
         rf1A==
X-Gm-Message-State: ACrzQf1hUPTKHH7xmVffzngEpic6QaqYtcAvgxcSflhE+C5zJZzb4VXU
        w84QGwlluzMORLc6KHbHZIo=
X-Google-Smtp-Source: AMsMyM4D67PYlZYq5V8+eJ9dmWB9GwW8V3Hb969IBAbts5yOY+OBe/UIJiHy2i22hVOi5VZUXtS5pA==
X-Received: by 2002:adf:dd88:0:b0:236:57e3:fc86 with SMTP id x8-20020adfdd88000000b0023657e3fc86mr7165773wrl.493.1667207378460;
        Mon, 31 Oct 2022 02:09:38 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id g13-20020a05600c310d00b003b4cba4ef71sm7610145wmo.41.2022.10.31.02.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 02:09:37 -0700 (PDT)
Date:   Mon, 31 Oct 2022 09:09:35 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Cooper <jonathan.s.cooper@amd.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] sfc: Fix an error handling path in efx_pci_probe()
Message-ID: <Y1+Qz9z+qy/kkW9B@gmail.com>
Mail-Followup-To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jonathan Cooper <jonathan.s.cooper@amd.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
References: <dc114193121c52c8fa3779e49bdd99d4b41344a9.1667077009.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc114193121c52c8fa3779e49bdd99d4b41344a9.1667077009.git.christophe.jaillet@wanadoo.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please specify a branch in the subject.
This patch should go to net.

On Sat, Oct 29, 2022 at 10:57:11PM +0200, Christophe JAILLET wrote:
> If an error occurs after the first kzalloc() the corresponding memory
> allocation is never freed.
> 
> Add the missing kfree() in the error handling path, as already done in the
> remove() function.
> 
> Fixes: 7e773594dada ("sfc: Separate efx_nic memory from net_device memory")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
> When 7e773594dada was merged, sfc/ef100.c had the same issue.
> But it seems to have been fixed in 98ff4c7c8ac7.

I agree.

> ---
>  drivers/net/ethernet/sfc/efx.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
> index 054d5ce6029e..0556542d7a6b 100644
> --- a/drivers/net/ethernet/sfc/efx.c
> +++ b/drivers/net/ethernet/sfc/efx.c
> @@ -1059,8 +1059,10 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
>  
>  	/* Allocate and initialise a struct net_device */
>  	net_dev = alloc_etherdev_mq(sizeof(probe_data), EFX_MAX_CORE_TX_QUEUES);
> -	if (!net_dev)
> -		return -ENOMEM;
> +	if (!net_dev) {
> +		rc = -ENOMEM;
> +		goto fail0;
> +	}
>  	probe_ptr = netdev_priv(net_dev);
>  	*probe_ptr = probe_data;
>  	efx->net_dev = net_dev;
> @@ -1132,6 +1134,8 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
>  	WARN_ON(rc > 0);
>  	netif_dbg(efx, drv, efx->net_dev, "initialisation failed. rc=%d\n", rc);
>  	free_netdev(net_dev);
> + fail0:
> +	kfree(probe_data);
>  	return rc;
>  }
>  
> -- 
> 2.34.1
