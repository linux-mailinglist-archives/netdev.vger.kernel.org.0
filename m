Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697095FE5E7
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 01:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJMXil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 19:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiJMXij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 19:38:39 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E639B18F247
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 16:38:37 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id l19so2290808qvu.4
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 16:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C8FfdZqDKu7Ldi8kglzUkI6fWUDELAEdTYLSHbtzm40=;
        b=cG9L2R/hwNS79DCzMNQKkX5Fmdm6qUucezQg2RbyEF5SLmq7efrZNFNvbDaE6EQizL
         GcejhopSHQnPif71L0OyzGG98r2wR7aIZmNvwIgyqnmF9nOehMqebn5wFTWo+GGodpLy
         YzJ4qXE5X8HYFzJ8XICLiNc82gXKTn6aLxkkBGV9cWJAanb0O5fxeM45zbvhPr9YwlKf
         oR/mcyG15Gf23t5w//hyqbHN/pCUnKNFMDdsNzVM7/rl6iQ28+5mfKK7aXicJ9kiDWz1
         Xpd30XiIMUFZBmkr5OLt/Rfjcn122VlkjICFUxFCVjMTlbKsKm/USDytqs0MwcjzCKRj
         Zl8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C8FfdZqDKu7Ldi8kglzUkI6fWUDELAEdTYLSHbtzm40=;
        b=WnH6p+IfA9CfB/y+P1oTAsbbVYga5M1s4nFFWE9Iix2bOE4ezDrZ9a9bEocK0m6A4H
         /9NSAW+DPjiOoWvdH2VZ2Kdmc+TJCDrRSogJcFnAqrJgSX3PlXvsD5mgb/8bCuYzf20c
         pV5YMRyeW7vTLjZ32MFQDxQnl1QyUg9XRgsihu1R2gECd6WWI4d6gxJVePo2wVCsJYQC
         VRGa9Ul9ZignbPGDq9OKeUrKS8qKYDR7JOu3W4XhWHR8za5oe87sJTfgi7Ag/9YEhEC6
         +tp9hUZJrqBPrdsjRvMsc3VXgKIB0DYFH5nq179NW9g8rnhc7JMRVOcF4J4IvnAWHx+S
         LhgQ==
X-Gm-Message-State: ACrzQf1r16PLNrjSeTuSfGKaM5PFBg+OpUafJ/jgOHsWcj5bzYTSzUVn
        SxsPXvAJT/b53tek7IVZD4X6atpj4GSFtQ==
X-Google-Smtp-Source: AMsMyM5PkaWEs6JslcDlmka0L/m9xqY/p4Xt0EubY3SJAbDzUlRaq9Zq08KwdZmnFzERmu2xXd4FVQ==
X-Received: by 2002:a05:6214:2121:b0:4b3:d854:56a3 with SMTP id r1-20020a056214212100b004b3d85456a3mr1969862qvc.98.1665704317100;
        Thu, 13 Oct 2022 16:38:37 -0700 (PDT)
Received: from [192.168.1.57] (cpe-72-225-192-120.nyc.res.rr.com. [72.225.192.120])
        by smtp.gmail.com with ESMTPSA id k6-20020a378806000000b006ea5a9984d1sm863755qkd.94.2022.10.13.16.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 16:38:36 -0700 (PDT)
Message-ID: <f0df9fa3-d543-b307-1a70-a00024042585@linaro.org>
Date:   Thu, 13 Oct 2022 19:36:24 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH] drivers/nfc: use simple i2c probe
Content-Language: en-US
To:     Stephen Kitt <steve@sk2.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221012175700.3940062-1-steve@sk2.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221012175700.3940062-1-steve@sk2.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/2022 13:56, Stephen Kitt wrote:
> All these drivers have an i2c probe function which doesn't use the
> "struct i2c_device_id *id" parameter, so they can trivially be
> converted to the "probe_new" style of probe with a single argument.
> 
> This is part of an ongoing transition to single-argument i2c probe
> functions. Old-style probe functions involve a call to i2c_match_id:
> in drivers/i2c/i2c-core-base.c,
> 

Looks ok, but subject needs to follow regular prefix style, so just "nfc:".


Best regards,
Krzysztof

