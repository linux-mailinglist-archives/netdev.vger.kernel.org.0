Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B72538CBA
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 10:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241296AbiEaIVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 04:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244846AbiEaIVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 04:21:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EFC7986EA
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 01:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653985288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I2fPIOlCOM3E2ayUp2iBt+EP7fcwTmAstFfusjqDQsU=;
        b=HIzsttLL1cqIPRTOYpfyEj7Tair5lPfy2WDn2+PpWZ9GfPDNsgJOp2mhpQJXSab5UNi3kG
        K/jDbNLhp29hJ3V3JSEh9xjrJgtWJQddhzcfYBlbZS+yS6seLSlD0TVQqnYcFDqqdnd2cL
        E1cT2giCdviURuPxpohz5nvLRmQy8G8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-v7-kOnqcMiCAClJRQ-HQsQ-1; Tue, 31 May 2022 04:21:26 -0400
X-MC-Unique: v7-kOnqcMiCAClJRQ-HQsQ-1
Received: by mail-qt1-f200.google.com with SMTP id m6-20020ac866c6000000b002f52f9fb4edso11629948qtp.19
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 01:21:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=I2fPIOlCOM3E2ayUp2iBt+EP7fcwTmAstFfusjqDQsU=;
        b=JQY/2BJNBA52PPKiIwxsanXFF33Y+TAKDRZ0FtVXnbguM2zoNFFzcMDpMfx0gFFdxl
         slAN8sNbA3fgDrPDCUoXog8cStz+X9ZOceDgTZuR/nybsGq6yQn7PZJ8AU98v6uyXJGM
         6Nf/+Ibj8PjAPs6NhjV1l9bb6vgy3xvLXBrQ/h3Xqp5cJGoDAo561i74NmD2uDs1wpH+
         0lTxiilW1tlA3YJchNZFCY4OeA2HJwlfaqNQxYTlIinMOVECW+VQztcjZQyQ9qmkZ/q3
         i1tGOnX0/gkZ42rXwBs3e5CZ4B1KSyu8daeLS/HLXhE8z6JaayoZTv5EvGRXpsL/+jTO
         RvPw==
X-Gm-Message-State: AOAM53392nFcpW8f6qmZ/emkvijR5EuuSzZuFSJrhygOZMe3iAsKUQcD
        vB2kxBClOOE3yPVS+B+tqeX7/ujsVjrV/AFQdVgzzlOXnlEAqd3RcK+cjnOKKBPeZvfOBWdAl1h
        CCI+a/P260RTu0cjd
X-Received: by 2002:a05:620a:48:b0:6a3:5595:9d1c with SMTP id t8-20020a05620a004800b006a355959d1cmr34608316qkt.246.1653985286349;
        Tue, 31 May 2022 01:21:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5Elviq8wkR7QEM12lazPriRbiYCkorY6f8q5VZxEiIzIY4yeGkiflwejzp+2iiEkHKHnqCQ==
X-Received: by 2002:a05:620a:48:b0:6a3:5595:9d1c with SMTP id t8-20020a05620a004800b006a355959d1cmr34608311qkt.246.1653985286083;
        Tue, 31 May 2022 01:21:26 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id p20-20020ac84614000000b00301729af618sm4758636qtn.97.2022.05.31.01.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 01:21:25 -0700 (PDT)
Message-ID: <48cb78ebd38dfe4ac05e337d5fb38623b7ee0e8f.camel@redhat.com>
Subject: Re: [PATCH 1/2] net/ncsi: use proper "mellanox" DT vendor prefix
From:   Paolo Abeni <pabeni@redhat.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Tue, 31 May 2022 10:21:19 +0200
In-Reply-To: <20220529111017.181766-1-krzysztof.kozlowski@linaro.org>
References: <20220529111017.181766-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, 2022-05-29 at 13:10 +0200, Krzysztof Kozlowski wrote:
> "mlx" Devicetree vendor prefix is not documented and instead "mellanox"
> should be used.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  net/ncsi/ncsi-manage.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
> index 78814417d753..80713febfac6 100644
> --- a/net/ncsi/ncsi-manage.c
> +++ b/net/ncsi/ncsi-manage.c
> @@ -1803,7 +1803,8 @@ struct ncsi_dev *ncsi_register_dev(struct net_device *dev,
>  	pdev = to_platform_device(dev->dev.parent);
>  	if (pdev) {
>  		np = pdev->dev.of_node;
> -		if (np && of_get_property(np, "mlx,multi-host", NULL))
> +		if (np && (of_get_property(np, "mellanox,multi-host", NULL) ||
> +			   of_get_property(np, "mlx,multi-host", NULL)))
>  			ndp->mlx_multi_host = true;
>  	}
> 

I can't guess which tree are you targeting, devicetree? net-next? could
you please specify?

thanks!

Paolo

