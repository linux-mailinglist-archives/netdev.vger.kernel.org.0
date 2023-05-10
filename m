Return-Path: <netdev+bounces-1489-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 224616FDFA3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:07:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E9192814F9
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25A114A87;
	Wed, 10 May 2023 14:07:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B6312B9D
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:07:00 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D9AD87C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:06:27 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-50bc3088b7aso13857660a12.3
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683727581; x=1686319581;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ARBQUsaVQponMA5mnWdXy/zQ7OiCE9Ro+edRw3MjYqs=;
        b=u6Qu+20hbBbQYyeSG9XMkauzHXzGpCJ7O4gX3g2BYukjU3CP9Edeu3z3/wpPAG+aSr
         ug8QpC15kWF04CYERv3/WL5c1lSvhRILYk2Y1JEmGQ/Dd2a/j3GbWh8mm9ZD0Q/j+PR2
         JLvgpW3v4mYpZummO79cBw/NlhOPCh81NNF/KJJRDvuXNsJvxl+hARwFE/Y63pwHY7gV
         CIAukCJeRQbEdVpc5f9SrU91telOZbc2UlWhNrtCh6Orne8f3B5qvQq4fFzCWEqTIZ4q
         +QkjkBKbwH8MLExki8uSTLDOILf/GfHs1RnBe2v0tHdioyojO8O8yKEtGM3dGNoNf4Ag
         GAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683727581; x=1686319581;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ARBQUsaVQponMA5mnWdXy/zQ7OiCE9Ro+edRw3MjYqs=;
        b=KTjvVraWv5jwWrXOhbBabnH+FXGbQyuat6eYpvSapuBlm1XLvcZRMLGWBIsCFwOe0n
         MWYlToyGi4deEnkeOL1hAfPteflFbQp8NOrGZQpyZIAg0tN+u00KZfPRQ6QVwpxtzKnP
         L3r56cWh8ASrSH3/bqOMfZSFYNtdPOgZM7u1ZemCmI/NTWwGx8pfeXRT4t8GZLZwaW1k
         URRZZWYPynER22g8Rz2uPtaBu0VsnWUDqKEqzCVKdnSK39mD7yvfDk3lzY1z2zmT911i
         6gHFvSlyxs6E+5OlvrxLv9+BmXbWHeIHkrWS8Pao3HNAn/DZcbub3p8CiWFZMjsLvkzS
         FDQg==
X-Gm-Message-State: AC+VfDyz3unbBw0ayNWC9xfZa/6YLll904phPoa2CQUzqxI36i5GdYl7
	jV/y1DmcY/cITIq2wG+IW8cIcg==
X-Google-Smtp-Source: ACHHUZ5ojUiRYeqPo+ilqYZrRAEcLsRSAiliDxvXI8npNXnU/onMW9LAHs2l1ORWNz9bcV3sezT6cA==
X-Received: by 2002:a05:6402:181:b0:4fb:953d:c3d0 with SMTP id r1-20020a056402018100b004fb953dc3d0mr14166101edv.20.1683727580240;
        Wed, 10 May 2023 07:06:20 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:c175:a0f9:6928:8c9d? ([2a02:810d:15c0:828:c175:a0f9:6928:8c9d])
        by smtp.gmail.com with ESMTPSA id n8-20020a056402514800b0050d8aac0a1esm1935347edd.19.2023.05.10.07.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 07:06:14 -0700 (PDT)
Message-ID: <9ed645c0-bae0-eb73-ab96-72fd69f9b463@linaro.org>
Date: Wed, 10 May 2023 16:05:49 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v6 0/4] Add pinctrl support for SDX75
Content-Language: en-US
To: Andy Shevchenko <andy.shevchenko@gmail.com>,
 Rohit Agarwal <quic_rohiagar@quicinc.com>
Cc: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
 linus.walleij@linaro.org, robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
 manivannan.sadhasivam@linaro.org, Mukesh Ojha <quic_mojha@quicinc.com>,
 linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
References: <1683718725-14869-1-git-send-email-quic_rohiagar@quicinc.com>
 <c0c3db1d-e83c-3610-ed61-db84cd88b569@quicinc.com>
 <CAHp75Ved53idRgpCDb2c=Bq9HXaE+sOWpY256rSRz-6bfRYnqA@mail.gmail.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAHp75Ved53idRgpCDb2c=Bq9HXaE+sOWpY256rSRz-6bfRYnqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 10/05/2023 16:02, Andy Shevchenko wrote:
> On Wed, May 10, 2023 at 3:16 PM Rohit Agarwal <quic_rohiagar@quicinc.com> wrote:
>> On 5/10/2023 5:08 PM, Rohit Agarwal wrote:
> 
>> Patch 2/4 didnt go through in the mailing list linux-arm-msm because of
>> char length.
>> BOUNCE linux-arm-msm@vger.kernel.org: Message too long (>100000 chars)
>>
>> Here is the link for it.
>> https://lore.kernel.org/all/1683718725-14869-3-git-send-email-quic_rohiagar@quicinc.com/
>> Please suggest if this patch needs to be broken down.
> 
> Since lore.kernel.org has it, I think nothing additional needs to be done.
> `b4` tool will take it from the archive.

Patchwork does not take from b4, but msm list, so this won't be applied
by Bjorn. I would suggest either pinging him to notice it or splitting
the patch a bit.

Best regards,
Krzysztof


