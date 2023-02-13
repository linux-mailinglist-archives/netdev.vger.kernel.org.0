Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A4E6951CC
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 21:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjBMUY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 15:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjBMUYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 15:24:53 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A411D4498;
        Mon, 13 Feb 2023 12:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676319892; x=1707855892;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rDoR4cTmxM2ImixZ81SBb+rLo3ARhuoSenaK1zUAFUA=;
  b=xT11d6CL55hUEvjLTGlTUGvvZt0LwnspS+t7OqrMz0Pa0BJaz0MIhH1j
   414Nvf6jaMAtK2awfBjUK+tqp6ZAUwT6zdGGWnqox4QIfYOnNO+FKqUxy
   EqjJuXKAc6CdTiXn8+XxvYui3vdS2hPTLUIHthvXEM+UFys6tO7DYGQyI
   s2AudEe4BhuueOafzfxf0Ks45Mts0BWeBLJuADc4ZzkLYy6/72Ai37LgP
   KVOIywW4dVLRnJuAnuNfYa9KqLNuNYI+8+Z7g++jOTv+iw5LUS7DzkZge
   K65+QTGAmOdRjynfCdsroOVT1mMtHcH9Lb5cPy8uNSpsYfqoL853uQ0sa
   g==;
X-IronPort-AV: E=Sophos;i="5.97,294,1669100400"; 
   d="scan'208";a="200777623"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Feb 2023 13:24:52 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 13:24:51 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Mon, 13 Feb 2023 13:24:51 -0700
Date:   Mon, 13 Feb 2023 21:24:50 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <lorenzo.bianconi@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH bpf-next] net: lan966x: set xdp_features flag
Message-ID: <20230213202450.6rzohccxngpdtk7r@soft-dev3-1>
References: <01f4412f28899d97b0054c9c1a63694201301b42.1676055718.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <01f4412f28899d97b0054c9c1a63694201301b42.1676055718.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/10/2023 20:06, Lorenzo Bianconi wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Set xdp_features netdevice flag if lan966x nic supports xdp mode.

It looks OK. In case you will need to do another version can you
move this change just a little bit more up next to the other
dev->features assignments which are found in the same function.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> index 580c91d24a52..b24e55e61dc5 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -823,6 +823,11 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
> 
>         port->phylink = phylink;
> 
> +       if (lan966x->fdma)
> +               dev->xdp_features = NETDEV_XDP_ACT_BASIC |
> +                                   NETDEV_XDP_ACT_REDIRECT |
> +                                   NETDEV_XDP_ACT_NDO_XMIT;
> +
>         err = register_netdev(dev);
>         if (err) {
>                 dev_err(lan966x->dev, "register_netdev failed\n");
> --
> 2.39.1
> 

-- 
/Horatiu
