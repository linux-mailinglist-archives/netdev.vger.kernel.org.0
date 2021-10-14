Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701B142D063
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 04:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhJNCaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 22:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJNCaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 22:30:06 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9935BC061570;
        Wed, 13 Oct 2021 19:28:02 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so6293573ote.8;
        Wed, 13 Oct 2021 19:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SdQZv5bEnEI48twijwR7O340qVLNFYgejTRMSJOO360=;
        b=pQXImiD+ZXm5SHr8PuSZ7IkWwV18+r678yGGUv5Xx4O28Dhl5OADaMjIhC1O6xAaRD
         A/5h9jp2Dj3Nmn1sYA5iuuE+vURhxA5uLOcsabkWknGphcn07mArmQ9e3ItzKgbKFzW1
         wJvuHuw2NfjQscWeMigfYiBdC8ryiFmzyi0YQVQtYmYBqNMPAkv9szSklKdsHCBOKtlF
         z8cTlOj2O+5+2wRZaD3yIgmpieKbZNMyqoMAFkB0sKQP5UlTm97cys4vCOF3CXU3sG45
         c5cPflI6AuLNcDWuoGARVG4zFK00pjKi39GxMyGFcjfjyZn+6nNmPh7T62gjp22EUqva
         Q+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SdQZv5bEnEI48twijwR7O340qVLNFYgejTRMSJOO360=;
        b=bjU+Z25Haz120ZzMWwFLbANMPCamVEF0sv++3oLEMcTPG42YbTwqpZYaMG7X82+qK5
         Zy/sRpr79oNWWzXEBhOOAMndvcR23zsW9uc/rGEX7o+lWfNbm2qPVTfbriO6wQwlyKAE
         n8DWtSmG6bW3nPoVvNlVKus+J9fJ7AG7xK6y9I5k6nUqGJ3mJIef2nWAYru7k8LQjg/4
         K5KVR36eFL/O3s0pm8uO9hQPmcbuS15zYolYBQ4Ia7gtVX60Zu/h0qG2janr9D98Mmgc
         OlMPHJxbRm6c7MYKFxEO10qSNU2f4Ea7bLzysc1KfgMaTbpn0nqSilvdbWdIt45uHEfo
         H+rw==
X-Gm-Message-State: AOAM531YyFM00mFsIPU6FT9KeLmePynb/V8CaCXvpmYPHt98LWTXWExI
        40wSyXOUEZfcL1EFzs3bDe4=
X-Google-Smtp-Source: ABdhPJxR9RRUOqxtGe1Q3/Jv7hcdmd+fSkQgHYNEdnYrYBHm0kEFWtEbMs8QhO4HDjwWSnJwp52AXg==
X-Received: by 2002:a9d:7257:: with SMTP id a23mr168692otk.311.1634178481989;
        Wed, 13 Oct 2021 19:28:01 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:c875:f7ef:73a9:7098? ([2600:1700:dfe0:49f0:c875:f7ef:73a9:7098])
        by smtp.gmail.com with ESMTPSA id bf3sm203868oib.34.2021.10.13.19.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 19:28:01 -0700 (PDT)
Message-ID: <8cd71dd4-5889-ed8c-1ef2-5baf63645f6c@gmail.com>
Date:   Wed, 13 Oct 2021 19:27:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net-next 4/7] ethernet: manually convert
 memcpy(dev_addr,..., sizeof(addr))
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, petkan@nucleusys.com,
        christophe.jaillet@wanadoo.fr, zhangchangzhong@huawei.com,
        linux-usb@vger.kernel.org
References: <20211013204435.322561-1-kuba@kernel.org>
 <20211013204435.322561-5-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211013204435.322561-5-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/2021 1:44 PM, Jakub Kicinski wrote:
> A handful of drivers use sizeof(addr) for the size of
> the address, after manually confirming the size is
> indeed 6 convert them to eth_hw_addr_set().
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: nicolas.ferre@microchip.com
> CC: claudiu.beznea@microchip.com
> CC: f.fainelli@gmail.com
> CC: petkan@nucleusys.com
> CC: christophe.jaillet@wanadoo.fr
> CC: zhangchangzhong@huawei.com
> CC: linux-usb@vger.kernel.org
> ---


>   drivers/net/ethernet/ti/cpmac.c          | 2 +-

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
