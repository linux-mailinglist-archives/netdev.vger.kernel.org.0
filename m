Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5F86B1157
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 19:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjCHStl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 13:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjCHStc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 13:49:32 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC56BF39B
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 10:49:30 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id da10so69712926edb.3
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 10:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678301368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=45PyBpg4cgEyf/MX2yYwknP8xso5JZQyHb1Ea24n/SM=;
        b=GUsrD8kmEoyHpT+XzkjqnEi8F6LUSevbMawimRHX98R3VxxrNOIatu9O5eMeRPRmgn
         Ic5jITwdRqJEFG9d5wns1kYEHPNZxidIa3v4lDnP4NYWEK/oLle6WBp4rzMoEYCpn6/R
         UQzLmBG9Hrursy2xj01drRTuesVtSTpMuPK+PPBGjpPeLHWRtyuLoYXa8/3NvNlH+CwN
         RR2fS9nleDJKsXrhF+SyL7/uTk0v8YYOzl9DrSJZJPuUvoqNldzG9bcvKrFz3wNhNBpz
         ChD8MnYR2zoS11xtsxVMTkVIZtsIsc/wAlcyD0i2KsgQLKpjr/Apx1hiA0ggKrAeO7rw
         iXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678301368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=45PyBpg4cgEyf/MX2yYwknP8xso5JZQyHb1Ea24n/SM=;
        b=qEzwoWu+2BQFeSMHGt6OTynW2Y86ceYI7lCGOuLt67wU1DT84WfTBAnkmKt97VS0Ni
         bNH70bXZGVzeX6O/AxDMOKAnLxH0ZHTJLzY35r/vUAtQRn/iorsp/OCUtQlOKYWZVgbt
         94bWHfVWoYtMu9kFauO//ReikMASw82PUGQumvXfeD6aO6ErpCfFrStSweHcwkahEv3Z
         ZyKG2SKHYDgarTVphEC1ZAcsGFUXOChgH57FEbjYSS0DUZx318gab9VjDSXF1aCs3j3f
         4QbAtuRL8jaZzs1Vnv4K49JLw5yKEXEz4dtzPTbkyT2twNHTLt4uyQAOpwP2ErI4dli3
         aYhA==
X-Gm-Message-State: AO0yUKW3NevJRDRN/U0+P7sFqedwv5G33nObx4lt5d1hn/oXZey2yMQJ
        yqnUqTt1X7fsbx7I+5FOn5AGvg==
X-Google-Smtp-Source: AK7set8NTawZYI1kntQ056oja2n5V6VWQ9wLhrcmliI9bJyRdIUZgPo2/LZx19zW/3BefeCesKBhqQ==
X-Received: by 2002:a17:906:6d53:b0:8b1:2614:edfe with SMTP id a19-20020a1709066d5300b008b12614edfemr20769244ejt.9.1678301368660;
        Wed, 08 Mar 2023 10:49:28 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:ff33:9b14:bdd2:a3da? ([2a02:810d:15c0:828:ff33:9b14:bdd2:a3da])
        by smtp.gmail.com with ESMTPSA id i6-20020a17090671c600b008b26f3d45fbsm7910217ejk.143.2023.03.08.10.49.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 10:49:28 -0800 (PST)
Message-ID: <5992cb0a-50a0-a19c-3ad1-03dd347a630b@linaro.org>
Date:   Wed, 8 Mar 2023 19:49:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [net-next PATCH 09/11] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-10-ansuelsmth@gmail.com>
 <ad43a809-b9fd-bd24-ee1a-9e509939023b@linaro.org>
 <df6264de-36c5-41f2-a2a0-08b61d692c75@lunn.ch>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <df6264de-36c5-41f2-a2a0-08b61d692c75@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/03/2023 14:57, Andrew Lunn wrote:
> On Wed, Mar 08, 2023 at 11:58:33AM +0100, Krzysztof Kozlowski wrote:
>> On 07/03/2023 18:00, Christian Marangi wrote:
>>> Add LEDs definition example for qca8k Switch Family to describe how they
>>> should be defined for a correct usage.
>>>
>>> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
>>
>> Where is the changelog? This was v8 already! What happened with all
>> review, changes?
> 
> Did you read patch 0?
> 
> We have decided to start again, starting small and working up. This
> patchset just adds plain, boring LEDs. No acceleration, on hardware
> offload. Just on/off, and fixed blink.

Sure, but the patch is carried over. So what happened with all its
feedback? Was there or was not? How can we know?

> 
> What do you think makes the patchset is not bisectable? We are happy
> to address such issues, but i did not notice anything.

I didn't write anything like that here...

Best regards,
Krzysztof

