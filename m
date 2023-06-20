Return-Path: <netdev+bounces-12198-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA2EC736A56
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:07:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 747EE280EF9
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8731910959;
	Tue, 20 Jun 2023 11:07:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7126FC2EE
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 11:07:10 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D7419B1
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:06:42 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-311275efaf8so3132628f8f.3
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687259192; x=1689851192;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KT1ofLh67QbHzizNPx+KKb1VFMOfDe7sYVySqlC78CE=;
        b=vvm0o8KzU8OoT0ntmU/pUfSjvvC49nx3S7FTzzzPJlvAsWtAy6C6brLF7Fj8PxM9Vm
         iGC8sMJ6tPeDfy0IDEWUsiphrnvQA8IhuYzbZX1MbbiyWQ1n/sZ+wlaH+H3tmnb/c7WG
         pJIMNsJt3IGpTFv66jR2x9SerfmU5dZ3LUWwZf2Msd0woFy6XDpNLwqU/LsrJFUcx5S8
         iyBUv0b7tRkFhw4IUxKEAly8O1hMCTXgp6CFW4hgfNYjDpcSvVlqL+KPeqm+xBPkXQlJ
         NkBOYSx9XUg48T5aVY2n3+TPRbIrwYE61DNNYSt5HeoqTIlQuBVHsLNYBqUSaUfdQYEk
         BTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687259192; x=1689851192;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KT1ofLh67QbHzizNPx+KKb1VFMOfDe7sYVySqlC78CE=;
        b=gYuN8oGCp/04Q7ugY0ZZf5EPN4Py8BWPVLBS79R4aVLjH0Pp+dK3ZV0mFYWIBM2LFf
         tGJ1iKw8UzRJNZNtQ9dwu8lVEfRLBXP5QG783WAKIf2/oaw1Eu0iEbw489nFatKyP8Vn
         bw6/zSCWn4PlH6vuysEK15309HGMN5dET5soSvbr6y6/1+aKUJdymjKlhDvi9MH8zJ06
         23YBH88hsr1EAqjGV+ZrQcOdntuJ0DjsvWTLJyr1ILde8YbaHcovSj9qeeO/akYLuEDi
         yDqBccSy1F6t/CKyh/3LrbaWq8JGtOkS9h8xT6k8HmviYlrMwOvMepvLluK7RciUrLnP
         rlnA==
X-Gm-Message-State: AC+VfDwUrBNggLaoO0T25aCYyPIhujXm6PpblzkeKBunZq+BHj5gtZ0R
	eyt+o8ar+79/w379ydzPIS0cFoKm47OGVI4Q09Y=
X-Google-Smtp-Source: ACHHUZ4duUXd2dKsPPFa5YwcAu5daqLG6JvhFde9VZTF4QDI938552Au7e9Zc7cCpSzLkMqrSxXzUg==
X-Received: by 2002:a5d:4fc1:0:b0:30f:c1ab:a039 with SMTP id h1-20020a5d4fc1000000b0030fc1aba039mr7735138wrw.40.1687259192356;
        Tue, 20 Jun 2023 04:06:32 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id o16-20020a5d6850000000b003047ae72b14sm1736958wrw.82.2023.06.20.04.06.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 04:06:31 -0700 (PDT)
Message-ID: <ed6f9ab8-9c4e-ec9f-efb7-81974d75f074@linaro.org>
Date: Tue, 20 Jun 2023 13:06:29 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 2/4] dt-bindings: clock: Add Intel Agilex5 clocks and
 resets
Content-Language: en-US
To: wen.ping.teh@intel.com
Cc: adrian.ho.yin.ng@intel.com, andrew@lunn.ch, conor+dt@kernel.org,
 devicetree@vger.kernel.org, dinguyen@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, linux-clk@vger.kernel.org,
 linux-kernel@vger.kernel.org, mturquette@baylibre.com,
 netdev@vger.kernel.org, niravkumar.l.rabara@intel.com,
 p.zabel@pengutronix.de, richardcochran@gmail.com, robh+dt@kernel.org,
 sboyd@kernel.org
References: <8d5f38e6-2ca6-2c61-da29-1d4d2a3df569@linaro.org>
 <20230620103930.2451721-1-wen.ping.teh@intel.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230620103930.2451721-1-wen.ping.teh@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 20/06/2023 12:39, wen.ping.teh@intel.com wrote:
>>
>>> +
>>> +properties:
>>> +  compatible:
>>> +    const: intel,agilex5-clkmgr
>>
>>
>> Why "clkmgr", not "clk"? You did not call it Clock manager anywhere in
>> the description or title.
>>
> 
> The register in Agilex5 handling the clock is named clock_mgr.
> Previous IntelSocFPGA, Agilex and Stratix10, are also named clkmgr.

So use it in description.

> 
>>> +
>>> +  '#clock-cells':
>>> +    const: 1
>>> +
>>> +  reg:
>>> +    maxItems: 1
>>> +
>>> +required:
>>> +  - compatible
>>> +  - reg
>>> +  - '#clock-cells'
>>
>> Keep the same order as in properties:
>>
> 
> Will update in V2 patch.
> 
>>> +
>>> +additionalProperties: false
>>> +
>>> +examples:
>>> +  # Clock controller node:
>>> +  - |
>>> +    clkmgr: clock-controller@10d10000 {
>>> +      compatible = "intel,agilex5-clkmgr";
>>> +      reg = <0x10d10000 0x1000>;
>>> +      #clock-cells = <1>;
>>> +    };
>>> +...
>>> diff --git a/include/dt-bindings/clock/agilex5-clock.h b/include/dt-bindings/clock/agilex5-clock.h
>>> new file mode 100644
>>> index 000000000000..4505b352cd83
>>> --- /dev/null
>>> +++ b/include/dt-bindings/clock/agilex5-clock.h
>>
>> Filename the same as binding. Missing vendor prefix, entirely different
>> device name.
>>
> 
> Will change filename to intel,agilex5-clock.h in V2.

Read the comment - same as binding. You did not call binding that way...
unless you rename the binding.

>>
>>> +
>>> +#endif	/* __AGILEX5_CLOCK_H */
>>> diff --git a/include/dt-bindings/reset/altr,rst-mgr-agilex5.h b/include/dt-bindings/reset/altr,rst-mgr-agilex5.h
>>> new file mode 100644
>>> index 000000000000..81e5e8c89893
>>> --- /dev/null
>>> +++ b/include/dt-bindings/reset/altr,rst-mgr-agilex5.h
>>
>> Same filename as binding.
>>
>> But why do you need this file? Your device is not a reset controller.
> 
> Because Agilex5 device tree uses the reset definition from this file.

That's not the correct reason. The binding header has nothing to do with
this device. You miss another patch adding support for your device
(compatible) with this header.

Best regards,
Krzysztof


