Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBA2587AD4
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 12:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236184AbiHBKkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 06:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbiHBKkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 06:40:39 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A7BBC13;
        Tue,  2 Aug 2022 03:40:37 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id s11so5643976edd.13;
        Tue, 02 Aug 2022 03:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g2eK6wsQiWdBpQk1CFZxDoL5EwK2bpOXHQ6rFxbx4IA=;
        b=UpRAGGzl5bKIOWn5ZxNrjbKytt7JJtp7xGqMjnz/fN+2wOvzui+Gkkeqote3HTdo7Q
         mWDbYd/Wd3XY/KJwkYfuNYmCceKLXYtDyyyLLtHcWUrpSBMMjJPaWFcCIveTDj1Xion0
         iST2I+20dEnBQo1ApO5qUuszGKr6dSGmierabv24DDR2CPg9OAv5RZBYHsgmOg5xDGXo
         uKgLotmYuyAnZ93H133tD8iVK0HY61L1FtziGk0P0itBIE5XJBNp6L8XwNf6u8cs7fjx
         9Hk3yekDzUZh/0FCsutDE0NvcQKB7wxzwTdf/IetLCLXzMKfGPXiO6g8V1vIoY1cQFzF
         aejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g2eK6wsQiWdBpQk1CFZxDoL5EwK2bpOXHQ6rFxbx4IA=;
        b=sFnWInZtymtc8Vcmk0cbqogZzHt/LHVg7oGxuLArofZxEYakf4zKzK6k5F10/d8G6Y
         0q/zImu2MpPZMyE7M5Qv3b1hmXWf47W9wE6sCVT4Pq5Ho/k2LGC7KTBmzqlTPWr/9u0h
         +n9kTYvNPSbqqhr5tU3XuecXddnVEHtEo80Y3tPwaKonmM7c0lhw3ExuVZVZAVFNYViY
         gpKwE7NIsLd/h6+F0AXf8OWH/Up1oV6vvKUz/SPh9BHIi3rus0zo7kenKJNebdesH6V6
         PJrl+rG7l1jBQm5bvpeI3EL7oZp/tgFapxtC/xDPn7QvfQ0qUlgaA4CheMAvAFNCBm8u
         qw7Q==
X-Gm-Message-State: AJIora/nDTy2pnUWifigbYMEz/2EwHpUxn+c1ZaER7ywRHVH2BlrXz+6
        CMF1owpBS+YfN2bqgQhm3ro1fVsY0maTVg==
X-Google-Smtp-Source: AGRyM1u8K+dusJSvdRpXEfKY/DrC9U8IB7GkocCkRwS5yR9Lc21BkJx557+5y8PwLrsxtnEP7t70Jg==
X-Received: by 2002:a05:6402:5c8:b0:433:545f:a811 with SMTP id n8-20020a05640205c800b00433545fa811mr19972852edx.101.1659436835723;
        Tue, 02 Aug 2022 03:40:35 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id q4-20020a17090676c400b0073066d4d7a4sm2981797ejn.80.2022.08.02.03.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 03:40:34 -0700 (PDT)
Date:   Tue, 2 Aug 2022 13:40:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [Patch RFC net-next 2/4] net: dsa: microchip: lan937x: remove
 vlan_filtering_is_global flag
Message-ID: <20220802104032.7g7jgn6t3xq6tcu5@skbuf>
References: <20220729151733.6032-1-arun.ramadoss@microchip.com>
 <20220729151733.6032-1-arun.ramadoss@microchip.com>
 <20220729151733.6032-3-arun.ramadoss@microchip.com>
 <20220729151733.6032-3-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729151733.6032-3-arun.ramadoss@microchip.com>
 <20220729151733.6032-3-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 08:47:31PM +0530, Arun Ramadoss wrote:
> To have the similar implementation among the ksz switches, removed the
> vlan_filtering_is_global flag which is only present in the lan937x.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/dsa/microchip/lan937x_main.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
> index daedd2bf20c1..9c1fe38efd1a 100644
> --- a/drivers/net/dsa/microchip/lan937x_main.c
> +++ b/drivers/net/dsa/microchip/lan937x_main.c
> @@ -401,11 +401,6 @@ int lan937x_setup(struct dsa_switch *ds)
>  		return ret;
>  	}
>  
> -	/* The VLAN aware is a global setting. Mixed vlan
> -	 * filterings are not supported.
> -	 */
> -	ds->vlan_filtering_is_global = true;
> -

You understand what this flag does, right? It ensures that if you have
lan0 and lan1 under VLAN-aware br0, then lan2 which is standalone will
declare NETIF_F_HW_VLAN_CTAG_FILTER. In turn, this makes the network
stack know that lan2 won't accept VLAN-tagged packets unless there is an
8021q interface with the given VID on top of it. This 8021q interface
calls vlan_vid_add() to populate the driver's VLAN RX filter with its
VID, and this gets translated into dsa_slave_vlan_rx_add_vid() which
ultimately reaches the driver's ->port_vlan_add() function.

If VLAN filtering *is* a global setting, and looking at this call from
ksz9477_port_vlan_filtering() which is not per port, I'd say it is:

		ksz_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE, true);

then what would happen is that all VLAN tagged traffic would be dropped
on the standalone lan2.

I'd say that the ksz9477 is buggy for not declaring vlan_filtering_is_global,
rather than encouraging you to delete it from lan937x. In turn, fixing
ksz9477 would make setting this flag from a common location possible,
because ksz8 needs it too.
