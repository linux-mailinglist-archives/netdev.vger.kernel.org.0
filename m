Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9961C689598
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 11:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbjBCKXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 05:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbjBCKXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 05:23:35 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A57023668
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 02:23:13 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id j25so662631wrc.4
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 02:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QQd7CbH4H743nTW9DhKy+wRFxxQrT0fQR+gCFf4zST8=;
        b=42OnDUyvlvOfKwL3GSUAKbEq4GSYYdj/RFPj2Dx5db+tJ7b/8+GN7oGjUEW7Nm0LgF
         EOcCAr+Hl8IcGf42Ob+9OB1afZ/bGZx6Agb4HZhHi1Bll3XZGSKge/ATpM5eE5alMgoJ
         QXPQjiESsa+BbkMlHiYwwSLTFuWE66H/DD8NrP4mFQdUoHmViuqqfMIFlYGJTj27eISt
         JKQKMCsY5lvvj2pffR5exSuzyQvVhClHD3jadMocJiHji5yitqoKDesupnajA//ze9L+
         l/OB4EaeHcLIcjZZWHUEAZwhNRUoDtKAEjpkdGYWVinCb0rm5wRI1YlmvPq2mBVw9xPh
         jV9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QQd7CbH4H743nTW9DhKy+wRFxxQrT0fQR+gCFf4zST8=;
        b=xaNJCg2EQNNLjdlesWSJiHM+Frs0hUtXRnKWRw1NOHBaSroT4QjMKmkEaJYdL0BhOh
         ynlFwGhY4bm+kedaD//sG8XhQtpOGpbpuictMkE66xUkSVFkzAnm+jSylqfs0yT/x4K8
         ibtIIf+AB3EmjNzy3VUdhtsU3MYTWDDC5g3bO7CAqb5zfWkt9Y/PWBC7Gdg4FRvyjRCT
         H5yUFqq2vTAg7phcpoeFVMg3+sJA7p9BOeltrXbLgCal3iwWVWIdvnFyL7WHcxbsexwD
         N0SCmRprp7xnKUijNYm2ujM1bebMF8bTtLv1Gceg8BAKtHvJ0aKeu+mQTVljM6tCvfa+
         6z+w==
X-Gm-Message-State: AO0yUKXDTPAqfslS06my3H3nG1sIL0bFEeu8skXiHkEcHUmGndeewIUs
        ZL2OCj5/QDMXzHZ+C6uVKi4hAQ==
X-Google-Smtp-Source: AK7set8Xp1wCsHhRr9D6MMbAX20Uj1pxumUfe3oABhruVYcBdfPfGqNza5+drgDusIc1n+U8ttoYew==
X-Received: by 2002:a5d:4d84:0:b0:2bf:b872:cf21 with SMTP id b4-20020a5d4d84000000b002bfb872cf21mr8565006wru.0.1675419792287;
        Fri, 03 Feb 2023 02:23:12 -0800 (PST)
Received: from ?IPV6:2a01:cb05:945b:7e00:9bdc:6887:23a2:4f31? (2a01cb05945b7e009bdc688723a24f31.ipv6.abo.wanadoo.fr. [2a01:cb05:945b:7e00:9bdc:6887:23a2:4f31])
        by smtp.gmail.com with ESMTPSA id l11-20020a05600002ab00b002bfb5ebf8cfsm1756844wry.21.2023.02.03.02.23.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 02:23:11 -0800 (PST)
Message-ID: <d9ef2aeb-85b6-b5c9-da92-b6396d1557c5@smile.fr>
Date:   Fri, 3 Feb 2023 11:23:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] net: ethernet: ti: cpsw: Set max and min MTU sizes
Content-Language: en-US
To:     Alexandre Bard <alexandre.bard@netmodule.com>,
        grygorii.strashko@ti.com
Cc:     linux-omap@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        shaozhengchao@huawei.com, mw@semihalf.com,
        wsa+renesas@sang-engineering.com, yangyingliang@huawei.com,
        chi.minghao@zte.com.cn,
        Alexandre Bard <alexandre.bard@netmodule.com>,
        netdev@vger.kernel.org
References: <20220906113212.8680-1-alexandre.bard@netmodule.com>
From:   Romain Naour <romain.naour@smile.fr>
In-Reply-To: <20220906113212.8680-1-alexandre.bard@netmodule.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Adding missing ML and maintainers in Cc.

Le 06/09/2022 à 13:32, Alexandre Bard a écrit :
> These fields need to be set in order for the userspace or DSA drivers to
> change the MTU to bigger or smaller values. They default to 68 and 1500
> respectively. Since the hardware supports wider limits, it is all
> benefit to set them.
> 
> Specially when connecting a DSA switch, the DSA code wants to set the
> MTU of the cpsw port to 1500 + tag size. This was failing without this
> change.

I had a similar issue with the cpsw_new driver (TI CPSW Switch Support with
switchdev):

eth0: mtu greater than device maximum
cpsw-switch 48484000.switch eth0: error -22 setting MTU to 1502 to include DSA
overhead

I did the same changes to allow setting the MTU on cpsw_new driver when used
with DSA switch.

Also I noticed that the am65-cpsw-nuss already initialize min_mtu and max_mtu [1].

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/net/ethernet/ti/am65-cpsw-nuss.c?h=linux-6.1.y#n1981

Best regards,
Romain

> 
> Signed-off-by: Alexandre Bard <alexandre.bard@netmodule.com>
> ---
>  drivers/net/ethernet/ti/cpsw.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index ed66c4d4d830..83d8c6a8a527 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -1631,6 +1631,9 @@ static int cpsw_probe(struct platform_device *pdev)
>  
>  	eth_hw_addr_set(ndev, priv->mac_addr);
>  
> +	ndev->min_mtu = CPSW_MIN_PACKET_SIZE;
> +	ndev->max_mtu = CPSW_MAX_PACKET_SIZE;
> +
>  	cpsw->slaves[0].ndev = ndev;
>  
>  	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX;

