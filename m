Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F8D58F8BF
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbiHKIEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbiHKIED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:04:03 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93BE6051C
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:04:02 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a7so32189165ejp.2
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=xDa5LDC2OZSh8eP2hQRQmGnezW0BSLHEBttI1qvVfns=;
        b=XAQaIZ/lYM+J2Xmgb4OV59DbJa22/EL4euqT9xkG48SWklz/0K0yy22BGxpNihcFpw
         jZs+dnl0itp10y89pJENSspuIwl1xUHcp0080DnyYFMDKZmki/68Byu8xvz0uff56cG4
         jpXAGMkNfUTuCtMosL9QmMQtqorASt5Om50s6/ENkxgCEJeaW8SXuHHVf8O6A/SwwogN
         p9lF0H7LC35z4s7NGVYJn+/lvh0pCvwHetLIjJR1DwDjNyjYde1j9cbJZDOR2DF9Jb52
         Foofxhk9EwVaLjDqH2LYjRjn54cPwiOXPg3a1rEvu+jydul79vaEwKFn4agKRshRSDB+
         ET8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=xDa5LDC2OZSh8eP2hQRQmGnezW0BSLHEBttI1qvVfns=;
        b=HXsAJUj3AMJs5itHQ4CLLmUv3JZutfwo5ekpNpLJBNpUP6h81Oe+s1mtuId2iveQOP
         KoCaPCQGoTP/bB8KBC0oHmU5SfQlt/aBLlJse3Hdfxm6JUFI+XtVtyJ2lDakVVoUg/G8
         dLhTTOnbERyxf/aUgG3bnTs70+TSwHTAI9lkm9xsvwGRK6sJLgmSY6XaHQkgBV8vG1Lg
         ZVQcvZoIiGOnctn0qAmLIEN8R9fkhoq+SSjoyG3XQBuZo0Gxr+lYL1KWvUoWaQGIpyT7
         7OtnmY5eKjwUjVDfMZrtEn6iz16IIYmzYItDQPHGNRyPngbrNYPNB7SZskjaFuAb070g
         FAwQ==
X-Gm-Message-State: ACgBeo1Ux1kHlaFz+6VbdhvYdPdvLQ04ZNP7hNwCRtzt578E8Iw/C9uh
        FVBJ7A+fviIzny0q7IEgLKHU2G20T/IvogSdyf4=
X-Google-Smtp-Source: AA6agR7dHGU+mmMS1/rSvLggSO020w6y6GiU/+K5dKvH8Oofe5Pr9WaXRuyjNYDY+B4RCGOhj5KHIg==
X-Received: by 2002:a17:907:6288:b0:72f:90ba:f0b2 with SMTP id nd8-20020a170907628800b0072f90baf0b2mr21961452ejc.696.1660205041165;
        Thu, 11 Aug 2022 01:04:01 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id la19-20020a170907781300b0072f0a9a8e6dsm3172157ejc.194.2022.08.11.01.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 01:04:00 -0700 (PDT)
Message-ID: <251c1455-f30c-0130-2bb7-036d412a0516@blackwall.org>
Date:   Thu, 11 Aug 2022 11:03:59 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net] bonding: fix reference count leak in balance-alb mode
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>, netdev@vger.kernel.org,
        sunshouxin@chinatelecom.cn
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
References: <26758.1660194413@famine>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <26758.1660194413@famine>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/08/2022 08:06, Jay Vosburgh wrote:
> 	Commit d5410ac7b0ba ("net:bonding:support balance-alb interface
> with vlan to bridge") introduced a reference count leak by not releasing
> the reference acquired by ip_dev_find().  Remedy this by insuring the
> reference is released.
> 
> Fixes: d5410ac7b0ba ("net:bonding:support balance-alb interface with vlan to bridge")
> Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> 
> ---
>  drivers/net/bonding/bond_alb.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
> index 60cb9a0225aa..b9dbad3a8af8 100644
> --- a/drivers/net/bonding/bond_alb.c
> +++ b/drivers/net/bonding/bond_alb.c
> @@ -668,8 +668,11 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
>  
>  	dev = ip_dev_find(dev_net(bond->dev), arp->ip_src);
>  	if (dev) {
> -		if (netif_is_bridge_master(dev))
> +		if (netif_is_bridge_master(dev)) {
> +			dev_put(dev);
>  			return NULL;
> +		}
> +		dev_put(dev);
>  	}
>  
>  	if (arp->op_code == htons(ARPOP_REPLY)) {

Nice catch,
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

