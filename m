Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76A855339E
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 15:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350870AbiFUNeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 09:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351535AbiFUNeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 09:34:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61652E56
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 06:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655818447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=97r4nb+6YDmj9qEHE13vmcMBxY84qaiGZ9+orHa4Vtc=;
        b=UlJGzyDv/A+ELcFlgSY9wlWBQPNEajfBBq+zuSKNb4nmEKpMeDPhLA+mkFCnzjgSjjMHk9
        ho56xnA3tq2IWUD+YfRvcO1CHckOSfwW16pnICCMgNPiRcB2Ajr3Y2JZXJn66PW7g5b6EX
        s9OibISygX7w9wHIK6KCbDy4Hd8GRhY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-n66VUmDlMWCDu8nH0TpHoA-1; Tue, 21 Jun 2022 09:34:06 -0400
X-MC-Unique: n66VUmDlMWCDu8nH0TpHoA-1
Received: by mail-qv1-f72.google.com with SMTP id s11-20020a0cb30b000000b004703e52d881so6750276qve.7
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 06:34:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=97r4nb+6YDmj9qEHE13vmcMBxY84qaiGZ9+orHa4Vtc=;
        b=TLE9/LYQtp2rKwm0QO/ByUGxSpHMZj25K33qtUIFHL1mn3UGdzP/u3JMs13+48apsO
         7ftqKPfnNNeSzSbKujHptUvVDjDs3kaDonqPBpWR3MiwsxPwi6XXfzjsgV/3vaUHOKYh
         TadaccnRRbOYIl2HBxIYjdk/hZwb+AX3GBJiNf653HHtP2khyDUgJ8WaoB25Ko3hc/KD
         hEupIsGVl74blJEvL9pk66MEboc4mM/7ONZT6csvGP/z25PqZfGEwJwt4uK8BnbriH0l
         87kgZao8hmvmH1V3Bss9BlKQwO6mJrld+e/Pv4SQ7e+l6if9EkYIprzkrjhMU9vhImGp
         LXfA==
X-Gm-Message-State: AJIora+x8t/YIO4E733iwoxuyrSxZH5GcGasJscIYlYqZ37a4HznqltP
        ztM20N9IE8jE94Ib8Rq3dfBklq50fHgn4yLEO7Uo8JpKgx3mQJGBYyNP4FmYr+XDNNNiRA21Y5U
        TytQe0YMVVyryGh+W
X-Received: by 2002:a05:622a:4c7:b0:306:69bf:d1f8 with SMTP id q7-20020a05622a04c700b0030669bfd1f8mr23975803qtx.68.1655818445801;
        Tue, 21 Jun 2022 06:34:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vN9l87oObdmFwig7dlyIvhe7i9Qpoa8feNQP5vgBbzmJSwwtTTmYXVRLZYn7OG2pk+1YLUAg==
X-Received: by 2002:a05:622a:4c7:b0:306:69bf:d1f8 with SMTP id q7-20020a05622a04c700b0030669bfd1f8mr23975763qtx.68.1655818445388;
        Tue, 21 Jun 2022 06:34:05 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id x9-20020a05620a448900b006a6a904c0a5sm14347236qkp.107.2022.06.21.06.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 06:34:05 -0700 (PDT)
Message-ID: <30a683ae5375ca67d10563fe8475074baeb3d7d3.camel@redhat.com>
Subject: Re: [PATCH -next] net: pcs: pcs-xpcs: Fix build error when
 CONFIG_PCS_XPCS=y && CONFIG_PHYLINK=m
From:   Paolo Abeni <pabeni@redhat.com>
To:     Zheng Bin <zhengbin13@huawei.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, boon.leong.ong@intel.com,
        rmk+kernel@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     gaochao49@huawei.com
Date:   Tue, 21 Jun 2022 15:34:01 +0200
In-Reply-To: <20220621131251.3357104-1-zhengbin13@huawei.com>
References: <20220621131251.3357104-1-zhengbin13@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-06-21 at 21:12 +0800, Zheng Bin wrote:
> If CONFIG_PCS_XPCS=y, CONFIG_PHYLINK=m, bulding fails:
> 
> drivers/net/pcs/pcs-xpcs.o: in function `xpcs_do_config':
> pcs-xpcs.c:(.text+0x64f): undefined reference to `phylink_mii_c22_pcs_encode_advertisement'
> drivers/net/pcs/pcs-xpcs.o: in function `xpcs_get_state':
> pcs-xpcs.c:(.text+0x10f8): undefined reference to `phylink_mii_c22_pcs_decode_state
> 
> Make PCS_XPCS depends on PHYLINK to fix this.
> 
> Fixes: b47aec885bcd ("net: pcs: xpcs: add CL37 1000BASE-X AN support")
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
>  drivers/net/pcs/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
> index 22ba7b0b476d..faec931b1e65 100644
> --- a/drivers/net/pcs/Kconfig
> +++ b/drivers/net/pcs/Kconfig
> @@ -8,6 +8,7 @@ menu "PCS device drivers"
>  config PCS_XPCS
>  	tristate "Synopsys DesignWare XPCS controller"
>  	depends on MDIO_DEVICE && MDIO_BUS
> +	depends on PHYLINK
>  	help
>  	  This module provides helper functions for Synopsys DesignWare XPCS
>  	  controllers.
> --
> 2.31.1

Thank you for the patch. There is already a similar fix pending:

https://patchwork.kernel.org/project/netdevbpf/patch/6959a6a51582e8bc2343824d0cee56f1db246e23.1655797997.git.pabeni@redhat.com/

Cheers,

Paolo

