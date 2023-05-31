Return-Path: <netdev+bounces-6884-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 734E7718905
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DCF1281571
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0244A1950D;
	Wed, 31 May 2023 18:05:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AFE182D9
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 18:05:35 +0000 (UTC)
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78088126;
	Wed, 31 May 2023 11:05:34 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-75b3645fb1fso68037285a.1;
        Wed, 31 May 2023 11:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685556333; x=1688148333;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yyTYC2NqLN4iSmSkNR3NaMMKKFdpdBQRppP8MlagS3o=;
        b=PF4p4oN383Um2kXzdlvG4hGpYtN43CHFrTJNrYiQaYpbucQJK0H3ersVy1ssS/pqGz
         SAN+QhszS9n46ida6NH9utEuMcCjtf4EgvuTxOEaHqI9+zolQcSmgNnRljaV+5oGlyMe
         8q3qWbK5r3giNLyThPJaXQFK8ERbATDnfARvA7v+vGi8K3uzVr/ffXuXRNxU65nKTJ1U
         9zg1mgAi+RieXN0HhQYIhSZR4G0VS3D8fhzkMc7sI9pi2FYLWLEA5ysab2e9CSCYHF20
         RXapMR4S4T4d4FsJKAwvwMzz55JFEVBIbTJEoHMDaLwmRtXeBICwIhaw9xI46YP5hsSQ
         C2oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685556333; x=1688148333;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yyTYC2NqLN4iSmSkNR3NaMMKKFdpdBQRppP8MlagS3o=;
        b=AS1W85PtDnVU7A13NkgPGdctXKKVwmZEM7Hq09dyJ80swKS5tvn5cVuxEWmcaZD11k
         XncCw1WxKwBT69g11+r8du8BgFR3yTQevXuuQ1tepDNrmz6ByyWtyX0hH85+lIy23aJD
         +GypukFhPPXW3oDi5oIO7PC1Q1s5EJwabRuAiURhZWBILdNjPaN27vJUyl56oD9/rIZR
         Mg3t2p6+Z4sJ63lfbFbLRUktgupXN3B90miF81WTzE8B4GfNke7o7JK3u9EpeUJk9iQR
         FYqkRr/4TNsJPq2ITGoGE+ZiwujtvYzutKkTwKrpYDmUo0iNda8NH8YZmVG2mk14K6Da
         4H4A==
X-Gm-Message-State: AC+VfDyw8dsvyQICGZxWyYE9v1+aiaseEESz0e+Np0QAMrdxGgIkcX9M
	Zx5FlzbqU5pbBANIn3MJCp0=
X-Google-Smtp-Source: ACHHUZ6A3Plo1GaR85RqsX3LiH/Clx19EM8etVFJyB1C3AHlPPADW6NS5j7DVv3yGHlMwxcSSv69wQ==
X-Received: by 2002:a05:620a:600a:b0:75b:23a1:d844 with SMTP id dw10-20020a05620a600a00b0075b23a1d844mr15256513qkb.6.1685556333569;
        Wed, 31 May 2023 11:05:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z5-20020ad44145000000b005e37909a7fcsm4384085qvp.13.2023.05.31.11.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 11:05:32 -0700 (PDT)
Message-ID: <e2108f4c-3d0d-ca64-5ad4-ec0de6ea4bf5@gmail.com>
Date: Wed, 31 May 2023 11:05:20 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 1/2] dt-bindings: net: phy: Support external PHY xtal
Content-Language: en-US
To: Detlev Casanova <detlev.casanova@collabora.com>,
 Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <linux@armlinux.org.uk>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20230531150340.522994-1-detlev.casanova@collabora.com>
 <ade45bcf-c174-429a-96ca-d0ffb41748d4@lunn.ch> <6646604.lOV4Wx5bFT@arisu>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <6646604.lOV4Wx5bFT@arisu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/31/23 11:00, Detlev Casanova wrote:
> On Wednesday, May 31, 2023 11:16:46 A.M. EDT Andrew Lunn wrote:
>> On Wed, May 31, 2023 at 11:03:39AM -0400, Detlev Casanova wrote:
>>> Ethernet PHYs can have external an clock that needs to be activated before
>>> probing the PHY.
>>>
>>> Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
>>> ---
>>>
>>>   .../devicetree/bindings/net/ethernet-phy.yaml          | 10 ++++++++++
>>>   1 file changed, 10 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
>>> b/Documentation/devicetree/bindings/net/ethernet-phy.yaml index
>>> 4f574532ee13..e83a33c2aa59 100644
>>> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
>>> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
>>>
>>> @@ -93,6 +93,16 @@ properties:
>>>         the turn around line low at end of the control phase of the
>>>         MDIO transaction.
>>>
>>> +  clock-names:
>>> +    items:
>>> +      - const: xtal
>>
>> I don't think xtal is the best of names here. It generally is used as
>> an abbreviation for crystal. And the commit message is about there not
>> being a crystal, but an actual clock.
>>
>> How is this clock named on the datasheet?
> 
> In the case of the PHY I used (RTL8211F), it is EXT_CLK. But this must be
> generic to any (ethernet) PHY, so using ext_clk to match it would not be
> good either.
> 
> Now this is about having an external clock, so the ext_clk name makes sense in
> this case.
> 
> I'm not pushing one name or another, let's use what you feel is more natural.

You can look up clocks by positional index, maybe this is a case where 
there are just too many names that PHY vendors will use that we should 
not be using one specific name in particular, but just define the order 
in which clocks should be specified.
-- 
Florian


