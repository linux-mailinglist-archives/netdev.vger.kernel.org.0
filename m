Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E7351251A
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbiD0WPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiD0WPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:15:24 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD020DF40;
        Wed, 27 Apr 2022 15:12:12 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n8so2746375plh.1;
        Wed, 27 Apr 2022 15:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yY8Jm3mnGXvzVkGe0wxNhWU0mg9/dRgUWt4SGuk+Cp4=;
        b=dzV/aIharJHjDYmpuVXUE3jjfd9jIG15hJ1SDRtu5N4Gb0ataX/pdLGzOwRl9MpB8z
         kC0ccaiIzVDgNQxBBlm9UvqU5rb+VpJtPb+VWrPxXHvtJ47GgEHAQKWJ95SacMNm+bIp
         FiroaESQBD9Hrz3Uzwr7Lrjnxs6YdFcXSldkr61XJ5SP7r+dm93Tp0LJgcJbdgq04sR0
         mFMy5pjt17pAjJMSthFmOhStMw7UUOfY70S56mpx1t69r5hYdvU8fKtd/4KnwHPNs3tL
         DdZTqR9+B1UYljDdxJ7HCkfOj1o4zd6VQj7q+yY2lQinSIoDbSSxxzyr/8yoIFZnmSeo
         iSjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yY8Jm3mnGXvzVkGe0wxNhWU0mg9/dRgUWt4SGuk+Cp4=;
        b=cKsE23Bg1pKL6toUflrsxBgMMbO1NXOlayd2kS9B2ZxBddvSq/p0bNvH+cJBjcQpg5
         PSMK51XedQ3NBj3QWX4zVmS/FVT0aOqo+Gcf6m7Kn0ZYgCQgi4nDB46v6KAJEM67Lxhb
         fMLIaQpzO3iRIuaqH7MmRDHt+qupXiO9X3GqDUm8QPvRjBuEjUFJZAvCNpA67Mej4QRi
         xzvvtwwY4XlAvhrqC/zO90sPBxc6Rdn1RgR6M185HqUdwuQlgv4Ukt4T/xJ5xRvHVMs+
         WFMi88rkJHV/aw50nlH2guNcnhcRreUQAEVPe9j3uRg8Bjmc77Ytgb0OHVNsqcLXMT6w
         7lMQ==
X-Gm-Message-State: AOAM532GU352mPnklm+lkHLUy76YKeDR5bbztsc6JDwIOuKavmReYobz
        AjRcp8bJlE3PhfHfASoDo+w=
X-Google-Smtp-Source: ABdhPJxSZEED2LpDtARX7a47vcvQZUAG/CuLxziUvNSn92cKgGfCUKMDR6kj3I8uV4A5eq2EotCOeg==
X-Received: by 2002:a17:902:f552:b0:15d:5abb:af5a with SMTP id h18-20020a170902f55200b0015d5abbaf5amr3877197plf.36.1651097532171;
        Wed, 27 Apr 2022 15:12:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l3-20020a17090a72c300b001d2edf4b513sm3897725pjk.56.2022.04.27.15.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 15:12:11 -0700 (PDT)
Message-ID: <cef1c3f7-06e3-f0dd-10ce-513f35fef3d0@gmail.com>
Date:   Wed, 27 Apr 2022 15:12:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v1 3/3] net: phy: micrel: add coma mode GPIO
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220427214406.1348872-1-michael@walle.cc>
 <20220427214406.1348872-4-michael@walle.cc>
 <652a5d64-4f06-7ac8-a792-df0a4b43686f@gmail.com>
 <635fd80542e089722e506bba0ff390ff@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <635fd80542e089722e506bba0ff390ff@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/22 15:08, Michael Walle wrote:
> Am 2022-04-28 00:06, schrieb Florian Fainelli:
>> On 4/27/2022 2:44 PM, Michael Walle wrote:
>>> The LAN8814 has a coma mode pin which puts the PHY into isolate and
>>> power-dowm mode. Unfortunately, the mode cannot be disabled by a
> s/dowm/down/
> 
>>> register. Usually, the input pin has a pull-up and connected to a GPIO
>>> which can then be used to disable the mode. Try to get the GPIO and
>>> deassert it.
>>
>> Poor choice of word, how about deep sleep, dormant, super isolate?
> 
> Which one do you mean? Super isolate sounded like broadcom wording ;)

Coma is not a great term to use IMHO. Yes Super isolate (tm) is a 
Broadcom thing, and you can come out of super isolate mode with register 
writes, so maybe not the best suggestion.
-- 
Florian
