Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16966BE2DE
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjCQIQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjCQIQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:16:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A045D589D;
        Fri, 17 Mar 2023 01:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679040965; x=1710576965;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MR+zLVYqEPfrh4L6Pcplh28QfUyeDUxyPOPQ6xA0fPc=;
  b=mewEzZ6QrkP2WR564l4cf4w0Xfhw3c+Ad++xsAKDOJxma2RTqUzknald
   Y4fiH2/+t/oQ2udEuMuaKPZu7ljStuVq9lNtFa6Bn6XWSOxHvmZuakVsT
   GjOA6S55V2n0yMJUhXr6Oqk9CDwB/bj75B4RRSjmM2oK5Zrg2asukQXc2
   jQnT/Iba+wv4tizKAnoixNVwQBVHgwvDyrk2rle/8KnlUe1BglG50nKt3
   eQ7Yfe5CA10QKmOFaJAj14uiXgiy0p6zK9/tXDQYog97wDjwCAu14qciV
   ZoCmSTN5j6wN/FdSuyij21Y0cTydLltAYU1RRVUenzQVI0BRYV7r4yUiD
   A==;
X-IronPort-AV: E=Sophos;i="5.98,268,1673938800"; 
   d="scan'208";a="216751985"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2023 01:15:14 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 01:15:13 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 17 Mar 2023 01:15:13 -0700
Date:   Fri, 17 Mar 2023 09:15:13 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Kang Chen <void0red@gmail.com>
CC:     <borisp@nvidia.com>, <john.fastabend@gmail.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <dirk.vandermerwe@netronome.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/tls: refine the branch condition in tls_dev_event
Message-ID: <20230317081513.ktllct3rqaisummm@soft-dev3-1>
References: <20230317071636.1028488-1-void0red@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230317071636.1028488-1-void0red@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/17/2023 15:16, Kang Chen wrote:

Hi,

> 
> dev->tlsdev_ops may be null and cause null pointer dereference later.

In the subject of your patch, you should specify which tree is this
patch targeting. When you create the patch you can use:
git format-patch ... --subject-prefix "PATCH net" ...

> 
> Fixes: eeb2efaf36c7 ("net/tls: generalize the resync callback")
> Signed-off-by: Kang Chen <void0red@gmail.com>
> ---
>  net/tls/tls_device.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index a7cc4f9faac2..f30a8fe373c2 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -1449,7 +1449,8 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
>                 if (netif_is_bond_master(dev))
>                         return NOTIFY_DONE;
>                 if ((dev->features & NETIF_F_HW_TLS_RX) &&
> -                   !dev->tlsdev_ops->tls_dev_resync)
> +                  (!dev->tlsdev_ops || (dev->tlsdev_ops &&
> +                   !dev->tlsdev_ops->tls_dev_resync)))

This can be simply written like:
(!dev->tlvdev_ops || !dev->tlvdev_ops->tls_dev_resync)

On the second condition you know already that dev->tlvdev_ops is not
NULL.

>                         return NOTIFY_BAD;
> 
>                 if  (dev->tlsdev_ops &&
> --
> 2.34.1
> 

-- 
/Horatiu
