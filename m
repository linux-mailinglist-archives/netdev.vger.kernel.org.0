Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569646E8EEB
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 12:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbjDTKF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 06:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234445AbjDTKFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 06:05:32 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E421C358A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 03:05:13 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2a8db10a5d4so4005821fa.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 03:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681985112; x=1684577112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4RJXgo9mbZocth7W+W/DHGi5VI0a91D1/aaXffY9umQ=;
        b=lqclOq7xlrh4i4oA0IR5rQP1xWRPVMmSK35utJZQag/nwUvQGNv6FiEPXi+2jROtAt
         7lPtJwxfypHnbq18+ge0VMtkmmMjBfOJ710f6BF2zNhq9xMB5kZc04aShJyf/ZU92qgF
         bWaxly6/XjxNzqmxDrlb1vcFfBZZKLblurYJ2BglxXkP20VGGOVs9vcZ+SzfJOUSuDUr
         maRUNdq2FBC5lJxWzZyRNPBlNUa/qaK6vsnz7QG4TGTD2b+y58v8n0ZDILRjbVc/Ms0r
         /8p5nNrcEeSaXQya0jGVsIyfdizF1Sto3MEohQp5IgPON2PIypCcUNryED+QDBpZZB6F
         7v+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681985112; x=1684577112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4RJXgo9mbZocth7W+W/DHGi5VI0a91D1/aaXffY9umQ=;
        b=e+MF2VZLw87X2mLYQUUoRL3c0z6fcM8+kEs30Xwf8tTcTqpK6y9CALxvCKLK7xgMCZ
         S8boqHSyZ0eslQ8LjMUPA7PMJ1YhSzS+K2pkKHFsKDp5nzeMFzNOFwnlxtrti1nwSql1
         pPX8aK479gNkjFwTaDFEJEu7/b+3OeAxgMo8KkGWVGrzZUgyplhpT1p05jugzqW1/4Ct
         T/kC/9ou8kfaMBr6AOWgsREYgOwVQeV72TvE0K+7ha/9aXU7gM50xj8jgSstbg4xiu9L
         TmHoxtOe+we6pUecVy1O1vFojzD8KqBi/ftuKMCqypwCroyL82Drq/AdEyIrbG8iTH6o
         b/8Q==
X-Gm-Message-State: AAQBX9drpBEv2cFG0SW6DqvdDAFITHoLfL/6XSHQb7n1kwor8M3MGTLk
        G8kZ15LQff0hxJnmSi/b1qGPTQ==
X-Google-Smtp-Source: AKy350a39HBh7R9jgbfr/UIn1pZgwf56M1oanLrDl7HkbyiiLwbA6+p08jkzA66//nGGXiIVdLaZhg==
X-Received: by 2002:a19:c508:0:b0:4db:4530:2b2d with SMTP id w8-20020a19c508000000b004db45302b2dmr273139lfe.49.1681985112150;
        Thu, 20 Apr 2023 03:05:12 -0700 (PDT)
Received: from ?IPV6:2001:14ba:a085:4d00::8a5? (dzccz6yyyyyyyyyyybcwt-3.rev.dnainternet.fi. [2001:14ba:a085:4d00::8a5])
        by smtp.gmail.com with ESMTPSA id r24-20020a2e9958000000b002a7af83ca1csm182840ljj.21.2023.04.20.03.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 03:05:11 -0700 (PDT)
Message-ID: <aa547a69-e1d8-1349-bd8c-9265275bb7f1@linaro.org>
Date:   Thu, 20 Apr 2023 13:05:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 3/4] clk: qcom: rpmh: Add RPMH clocks support for SDX75
Content-Language: en-GB
To:     Taniya Das <quic_tdas@quicinc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Michael Turquette <mturquette@baylibre.com>
Cc:     quic_skakitap@quicinc.com, Imran Shaik <quic_imrashai@quicinc.com>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        quic_rohiagar@quicinc.com, netdev@vger.kernel.org
References: <20230419133013.2563-1-quic_tdas@quicinc.com>
 <20230419133013.2563-4-quic_tdas@quicinc.com>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230419133013.2563-4-quic_tdas@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/2023 16:30, Taniya Das wrote:
> From: Imran Shaik <quic_imrashai@quicinc.com>
> 
> Add support for RPMH clocks for SDX75 platform.
> 
> Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
> Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
> ---
>   drivers/clk/qcom/clk-rpmh.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry

