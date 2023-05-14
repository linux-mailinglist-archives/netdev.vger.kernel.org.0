Return-Path: <netdev+bounces-2416-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13EE2701C72
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 11:15:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7646D1C209BC
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 09:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AA141FC4;
	Sun, 14 May 2023 09:15:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9C1ED1
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 09:15:48 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D631FE6
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 02:15:45 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-50bcb00a4c2so17739000a12.1
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 02:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684055743; x=1686647743;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ytSK3zVcteIovJ3O/CiV69EyJ8hozhkY9D5B2vV1EBc=;
        b=wY97dPv/ratrofKZ4zfovMxG7cS+LkfRAbWsUsav+LyEx5LNfrPiH8zE0PnJP+cNLa
         KvhZf68CTSHf8cHVtL9WMVTmYMgr03wlQyxeZngR4I4FtAiaGircBd4ybqsB0AsIcyCi
         KwsUAEZkKqpRoBfQOWV1lpZmx+u6py2RkGLFdaP81ybYcBji1dVx1AdkJxuE3pCZtfSY
         kg7/8IklObQNhYjlrY4kPgM8hYK1b5bJkufFL0mGBwkaukzKjI8aepQeU7qSIHBYtIVG
         yD7xdgy4UAtYK3M4RTKqrwjegyaAXjP965N3jtz3eohBjMlrV0LrK6Em5pDmAindv/Dp
         EyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684055743; x=1686647743;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ytSK3zVcteIovJ3O/CiV69EyJ8hozhkY9D5B2vV1EBc=;
        b=JRXqEvpW4dK6IPOXQeS579akUshshBHaELuuR5dyC66meuCA76LLDgNXzvJCZ8kaws
         P2AwwcMhZEYFgrLgE4T7m6lvPyYb5Zxmruyo44kRM1Zf58ON/lqUsK4XB3Efpsqaawds
         /2GaUJ/FtZj4lohM46Ehv49uvu/A5U9qiGltFoaNZUbPArJ75sbInY64VGqUXV1HNxsb
         OXaRffh3tSxwmQKnND/+YezhBPYRSXzAyRoqPg1M2R1FihC4aJOXzYW/jht9F+SZZ8kW
         ljP7PpFcQSTD0ZzYpHng9w1Q08wcKFDg89/L361ofPYKxpTQu5rhfGxwIWH4BQvUohx8
         7TmQ==
X-Gm-Message-State: AC+VfDxNs0I8FCYidsHfZtB8B6a8jj38JKvcVkVjrpGCWb59BUqSBtRi
	oMQ3L5+EhLRFt/crU9svP0aTyw==
X-Google-Smtp-Source: ACHHUZ7WPFk/MF2mr9DgAHesxK+A06AsFHKZL8Nzl6XuIAfQU/L7rQhNfuQGBCJTnob8VTZkr2bObQ==
X-Received: by 2002:a17:907:3602:b0:947:5acb:920c with SMTP id bk2-20020a170907360200b009475acb920cmr25364488ejc.34.1684055743438;
        Sun, 14 May 2023 02:15:43 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:715f:ddce:f2ba:123b? ([2a02:810d:15c0:828:715f:ddce:f2ba:123b])
        by smtp.gmail.com with ESMTPSA id r16-20020aa7cfd0000000b0050bd245d39esm5788756edy.6.2023.05.14.02.15.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 May 2023 02:15:42 -0700 (PDT)
Message-ID: <4c163376-ce89-786d-3c76-4f10ae818e7a@linaro.org>
Date: Sun, 14 May 2023 11:15:40 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] nfx: llcp: fix possible use of uninitialized variable in
 nfc_llcp_send_connect()
To: Simon Horman <simon.horman@corigine.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Samuel Ortiz <sameo@linux.intel.com>,
 Thierry Escande <thierry.escande@collabora.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20230513114938.179085-1-krzysztof.kozlowski@linaro.org>
 <06bba9db-25ff-a82b-803a-f9ae0519d293@linaro.org>
 <ZGCb2CNcEDtDtPRR@corigine.com>
Content-Language: en-US
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <ZGCb2CNcEDtDtPRR@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 14/05/2023 10:29, Simon Horman wrote:
> On Sat, May 13, 2023 at 01:51:12PM +0200, Krzysztof Kozlowski wrote:
>> On 13/05/2023 13:49, Krzysztof Kozlowski wrote:
>>> If sock->service_name is NULL, the local variable
>>> service_name_tlv_length will not be assigned by nfc_llcp_build_tlv(),
>>> later leading to using value frmo the stack.  Smatch warning:
>>>
>>>   net/nfc/llcp_commands.c:442 nfc_llcp_send_connect() error: uninitialized symbol 'service_name_tlv_length'.
>>
>> Eh, typo in subject prefix. V2 in shortly...
> 
> Also, s/frmo/from/
> 
> And please consider moving local variables towards reverse xmas tree -
> longest line to shortest - order for networking code.

They were not ordered in the first place, so you prefer me to re-shuffle
all of them (a bit independent change)?

Best regards,
Krzysztof


