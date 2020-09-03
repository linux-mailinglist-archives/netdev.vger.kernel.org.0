Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8354025B965
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 05:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgICDt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 23:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgICDtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 23:49:24 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6991BC061244;
        Wed,  2 Sep 2020 20:49:24 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 7so972445pgm.11;
        Wed, 02 Sep 2020 20:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=npE+6kgY3BgkJuk1F6OrPRsD1LD4neOO0rtoAG0vrnQ=;
        b=Dfw35si2hpu8HSbt7vYSTT6bRfqooFfqvtuJOMRu31s1zHcazuBWb8iZSDlBuUDlJw
         WdvvXEzbxkDfv/3wMT9hwIa3vgI16BabY30lQJYLF9R0iavh1iFZ5mGk1p3eyYnbcnIt
         7n2iSOZwTocINzPyIwz3u4Q/OGjQEoQvlrkLRUo0IkDPHlmCNhJHHwtwiR1DVIWNH7BX
         Hic3wV6nKXzoAdqR6H42axB1idyI/qVKfN6zGYYz7PURerRBohxXjPLRKp84ckr6cF2x
         ynCINIfUNQ62j+R1DyQOwOdQdSEOjplBiy9BCntJl4IUlAL1jViGD+G9JAmkHs++SGmY
         O9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=npE+6kgY3BgkJuk1F6OrPRsD1LD4neOO0rtoAG0vrnQ=;
        b=tcMF8sV4hyNiTt6R4MRPXqKW2jSfY5fgexwg+CoG8JuwRp7nnW42MQPvz5gooaC+ji
         jPspvrrfSHNr6rcDjeL71+/gNHQrPunZpUZgQ18gRnS2Q8LHqaXYK1V9m77Sy94l5CR/
         nd2SYutv2X94JmaJbThLizSqT2A+BM1jRxgb3J+CRqbPvDBIAnToGlgIjpzbzKEnzI5o
         bonuycLjzHhkvF7nxecnO3IYdSKesO5nQXsrcy/dyd/FgqWBbSsIp9+PUre0crz/IdfE
         L1UfqIB+HHUTqEdm+pYaCp03JSAbtkBghnWm8PCygaDDmk/miIrS1j3vdpteyCp/bPoZ
         CtQQ==
X-Gm-Message-State: AOAM530jcGlWPSlFQQBz4lr5PYyocQIvYUcfCL6UFVFu/TldFx6L14U6
        X8Ef9WPUl6SfSRSEDM/ZmJg=
X-Google-Smtp-Source: ABdhPJwYE+xArS4TItybo5Qh7QcbVZSCVtOJJVLj7/To/yDMWI7tvLCl/hdb8f1wk/MrtLh49SCsAA==
X-Received: by 2002:a65:5c4c:: with SMTP id v12mr1078295pgr.95.1599104963899;
        Wed, 02 Sep 2020 20:49:23 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id k4sm804155pjl.10.2020.09.02.20.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 20:49:22 -0700 (PDT)
Date:   Thu, 3 Sep 2020 12:49:18 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] staging: qlge: fix build breakage with dumping enabled
Message-ID: <20200903034918.GA227281@f3>
References: <20200902140031.203374-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200902140031.203374-1-coiby.xu@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-02 22:00 +0800, Coiby Xu wrote:
> This fixes commit 0107635e15ac
> ("staging: qlge: replace pr_err with netdev_err") which introduced an
> build breakage of missing `struct ql_adapter *qdev` for some functions
> and a warning of type mismatch with dumping enabled, i.e.,
> 
> $ make CFLAGS_MODULE="QL_ALL_DUMP=1 QL_OB_DUMP=1 QL_CB_DUMP=1 \
>   QL_IB_DUMP=1 QL_REG_DUMP=1 QL_DEV_DUMP=1" M=drivers/staging/qlge
> 
> qlge_dbg.c: In function ‘ql_dump_ob_mac_rsp’:
> qlge_dbg.c:2051:13: error: ‘qdev’ undeclared (first use in this function); did you mean ‘cdev’?
>  2051 |  netdev_err(qdev->ndev, "%s\n", __func__);
>       |             ^~~~
> qlge_dbg.c: In function ‘ql_dump_routing_entries’:
> qlge_dbg.c:1435:10: warning: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Wformat=]
>  1435 |        "%s: Routing Mask %d = 0x%.08x\n",
>       |         ~^
>       |          |
>       |          char *
>       |         %d
>  1436 |        i, value);
>       |        ~
>       |        |
>       |        int
> qlge_dbg.c:1435:37: warning: format ‘%x’ expects a matching ‘unsigned int’ argument [-Wformat=]
>  1435 |        "%s: Routing Mask %d = 0x%.08x\n",
>       |                                 ~~~~^
>       |                                     |
>       |                                     unsigned int
> 
> Fixes: 0107635e15ac ("staging: qlge: replace pr_err with netdev_err")
> Reported-by: Benjamin Poirier <benjamin.poirier@gmail.com>
> Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---

Thanks for following up on this issue.

[...]
> @@ -1632,8 +1635,8 @@ void ql_dump_wqicb(struct wqicb *wqicb)
> 
>  void ql_dump_tx_ring(struct tx_ring *tx_ring)
>  {
> -	if (!tx_ring)
> -		return;
> +	struct ql_adapter *qdev = tx_ring->qdev;
> +
>  	netdev_err(qdev->ndev, "===================== Dumping tx_ring %d ===============\n",
>  		   tx_ring->wq_id);
>  	netdev_err(qdev->ndev, "tx_ring->base = %p\n", tx_ring->wq_base);

Did you actually check to confirm that the test can be removed?

This is something that you should mention in the changelog at the very
least since that change is not directly about fixing the build breakage
and if it's wrong, it can lead to null pointer deref.
