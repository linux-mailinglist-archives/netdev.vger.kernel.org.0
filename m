Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CEC6BE601
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 10:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjCQJ5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 05:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjCQJ47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 05:56:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106FAE1922;
        Fri, 17 Mar 2023 02:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679047017; x=1710583017;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PLi9kWdha58lNkUoxRz58CGX1CJ5vj+vjYqwSe/pcB4=;
  b=0ceiXg5jpndEHJYCfVR3jHGZ4Y+Zse7TIuYWmxF02Hw6CzPtOXyddk8E
   iaSP2x2k0UkfdekJnV/j+FgflKOfbpgHHM/4oJw2JqwulV6Br6XXVG83L
   8O0dvMj2wla4zL2I5z/PRb06TWkuUebsSUyp3Kt8zG9CekymwxBFrk8tp
   XIg6HHlQM6iWE9pYUm7wZ2CdZIQKF3ajVsg6dejYcdKWRcwKy/lLT/TeA
   Kqt2X0SHDgLWNXPBNFiJLyTIlemguEhashdYAlJLd/nPtlVu5fBCFOQRb
   0oNV8NHrGc0qqCEvBDlL/nPTPD9VTKwtMrjyU44ti7LzP6KQLflbtx/qs
   w==;
X-IronPort-AV: E=Sophos;i="5.98,268,1673938800"; 
   d="scan'208";a="205551967"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2023 02:56:56 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 02:56:54 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 17 Mar 2023 02:56:54 -0700
Date:   Fri, 17 Mar 2023 10:56:53 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Kang Chen <void0red@gmail.com>
CC:     <borisp@nvidia.com>, <davem@davemloft.net>,
        <dirk.vandermerwe@netronome.com>, <edumazet@google.com>,
        <john.fastabend@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: Re: [PATCH net v2] net/tls: refine the branch condition in
 tls_dev_event
Message-ID: <20230317095653.x5az7jrhziwctwjg@soft-dev3-1>
References: <20230317081513.ktllct3rqaisummm@soft-dev3-1>
 <20230317083338.1085194-1-void0red@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230317083338.1085194-1-void0red@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/17/2023 16:33, Kang Chen wrote:
> 
> dev->tlsdev_ops may be null and cause null pointer dereference later.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> Fixes: eeb2efaf36c7 ("net/tls: generalize the resync callback")
> Signed-off-by: Kang Chen <void0red@gmail.com>
> ---
> v2 -> v1: simplify the condition
> 
>  net/tls/tls_device.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index a7cc4f9faac2..45b07162d062 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -1449,7 +1449,8 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
>                 if (netif_is_bond_master(dev))
>                         return NOTIFY_DONE;
>                 if ((dev->features & NETIF_F_HW_TLS_RX) &&
> -                   !dev->tlsdev_ops->tls_dev_resync)
> +                  (!dev->tlsdev_ops ||
> +                   !dev->tlsdev_ops->tls_dev_resync))
>                         return NOTIFY_BAD;
> 
>                 if  (dev->tlsdev_ops &&
> --
> 2.34.1
> 

-- 
/Horatiu
