Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5761D6F0A80
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 19:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244235AbjD0RGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 13:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243767AbjD0RGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 13:06:05 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B5D19B4;
        Thu, 27 Apr 2023 10:06:04 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-63b5465fb99so7244188b3a.1;
        Thu, 27 Apr 2023 10:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682615164; x=1685207164;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k4ophyycar0aN5e81E3kbl+YpoXereyDprZ51sERIL8=;
        b=i6/aY2NfYGxoC+7GgURKzVC56OJa2jvZNZjfNwibceLVJhzOOTtbUM4nfx6gLxx15S
         RziVhq7c2xc5YgOV642ohAS/HCHxv3mo4jF0rf2pssX6WyaJTyjOOU91sy16SWS5uNUZ
         ypOE3B30h4V6mp1paI0blkrj9pBTM1yDZjCoY04QOHrGZ+xUMgOn8va/PKoBIds2hOo/
         CWwbOQl31D0XH9cbPc2mAW08+xKpqNlzC0CqkBi8R624h/CRmqzpW0n0vXLw6fFXPnpa
         YW26CyGEF/Ar/zwq/JFfTZu30pcrndHVLXDtLrUr5L8GSyWBxmQDqml/6vuTvxlymv70
         0Nmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682615164; x=1685207164;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k4ophyycar0aN5e81E3kbl+YpoXereyDprZ51sERIL8=;
        b=hxJxnP/qJ00Ax1FsZ1Z0H02H9koQYrUuQ1AZ+m9z2YwKtsATk1yJdtJNyjJXBGrcRi
         V/QQhTR3o9l2UZP68A3qTWWYWbKjp8L5KGWWvTLQV2aULxOC0Eu+KFsCYJs6JjSDNxSM
         cZtnaU/BT6P4/iftu/1/JM9kEfAVM+w1rP+yk5UZ5SRhf6aSbSAT1GwjNWO+GPGxpyZ8
         IfFukUH3oVVfDu0/PIG2IK6nw8twCxctfGKkv4mZNOnAh09vLibeusq3Bcz/K/Mh/8Xv
         55NV0NQNC9kdkZ5VO9RR5qQPBFY5Sxr0d4F0FWEM2SdzsYpP27w0lFNyIJ8HXUGal2m6
         5cDA==
X-Gm-Message-State: AC+VfDyj9N4hSVTATQvjxx9WSIP8rUYoY+c1lE682WD/kEqkf7g2DOsS
        mGm+dCffC5+y4MZ218KfIPY=
X-Google-Smtp-Source: ACHHUZ4mt7vAeiKnllxZX7gigR+rhFGQGjOgpputfITtx3lb+CeixxmjixTTJbcZp/ZQAPdkDYgwkA==
X-Received: by 2002:a05:6a00:1746:b0:63d:6825:d843 with SMTP id j6-20020a056a00174600b0063d6825d843mr3814843pfc.23.1682615164048;
        Thu, 27 Apr 2023 10:06:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k27-20020aa79d1b000000b0063b6451cd01sm13443138pfp.121.2023.04.27.10.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 10:06:03 -0700 (PDT)
Message-ID: <61bc7bc0-4e1d-247f-14ab-2a677af5aace@gmail.com>
Date:   Thu, 27 Apr 2023 10:05:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 net-next 1/6] dt-bindings: net: brcm,unimac-mdio: Add
 asp-v2.0
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>, Justin Chen <justinpopo6@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        bcm-kernel-feedback-list@broadcom.com, justin.chen@broadcom.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
References: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
 <1682535272-32249-2-git-send-email-justinpopo6@gmail.com>
 <20230427170354.GA3163369-robh@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230427170354.GA3163369-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/23 10:03, Rob Herring wrote:
> On Wed, Apr 26, 2023 at 11:54:27AM -0700, Justin Chen wrote:
>> The ASP 2.0 Ethernet controller uses a brcm unimac.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Justin Chen <justinpopo6@gmail.com>
>> ---
>>   Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
>> index 0be426ee1e44..6684810fcbf0 100644
>> --- a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
>> +++ b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
>> @@ -22,6 +22,8 @@ properties:
>>         - brcm,genet-mdio-v3
>>         - brcm,genet-mdio-v4
>>         - brcm,genet-mdio-v5
>> +      - brcm,asp-v2.0-mdio
>> +      - brcm,asp-v2.1-mdio
> 
> How many SoCs does each of these correspond to? SoC specific compatibles
> are preferred to version numbers (because few vendors are disciplined
> at versioning and also not changing versions with every Soc).

So far there is a 1:1 mapping between the number of versions and the 
number of SoCs, and the older SoC uses v2.0, while the newer one uses v2.1.
-- 
Florian

