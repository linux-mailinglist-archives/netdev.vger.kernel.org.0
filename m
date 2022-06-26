Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78CA55B3DE
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 21:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiFZTvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 15:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiFZTvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 15:51:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760F5384
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 12:51:11 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z19so10290858edb.11
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 12:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=K0lQdmcK0/9nFRSw74vjTtekH+ms1WPGE7ZqayvvKrw=;
        b=gOAuwtj5y3iNhfNmc4kq2lxsDNQizfMwaOcLup7QDRcXKe2yJTygk5AwLcFNEaL1LQ
         AXFi+2eV1wc5qW6hahCf43BG92NKkPFJgUJGKcEHz0+s1+lTOlDjWIgxDjaD7Rlsr5Jh
         /O0yr221KZRAxv9td3SsO2rn5Uk0i3rdIvkvHoLImH91zfJ/vOuC7c2loyAwvhZCxbRX
         vGQKgfTkIf0AQg3YSyS2Bnpfpi+IxEi3HPdqAUNHxBYBY/z1oXCEn8Z9YWINVUSLTUi8
         JKb+bmO1V9yxP67adKC398pjjN2ZQXt6x+Gg6c04Nk+1HfO5I2NTD4E1i2gQ/0+mSXp2
         aM8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K0lQdmcK0/9nFRSw74vjTtekH+ms1WPGE7ZqayvvKrw=;
        b=g/DX94nx7dIeHAJpmny+T25YfFULUkFxIiiMWYvXEU8ALNFvsnoi/mcEER0DYBESpk
         v4JFzTDuROCHkTwZTlFboRQG7cbGUwewdldX/lgTzOJyXe3WJLb5X0sOFg2hTRT+2f7E
         MXHMR2RAGkQ8DzH5Hgtb3L1ejMIfruO8/VTYGm29VdH13jwGrBegWjy5x6LUhNuhGI98
         EGYVFq2gb0aMWTrU1e/QzC23T+EQtbwf/TMzwIN8ClZEnh383LXwpVhaLzEvPJFnwmyK
         TxQ12nyLoazqCjsiKhyAg3fIuob7OwEVfj+9fXh0CuDl6kyb9ktyKR8ssLeGL6FhTY0p
         v3hg==
X-Gm-Message-State: AJIora+0y/+Rt/x/K0beMCslxiqUpG3odAD2BKDsqKIsCAKSL7jjG6lg
        /gC05HhmcvRwCGL7uYewnMKfTg==
X-Google-Smtp-Source: AGRyM1tEx41yN++6Cu+uoOjmxRjJkWJg8uh3EG/OzjcE5cdPH/2X/1yA2bgVX/lCqTiHYMUETGMkIA==
X-Received: by 2002:a05:6402:2812:b0:437:6235:adbe with SMTP id h18-20020a056402281200b004376235adbemr12573023ede.416.1656273070059;
        Sun, 26 Jun 2022 12:51:10 -0700 (PDT)
Received: from [192.168.0.244] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id k10-20020a170906970a00b006fea59ef3a5sm4151835ejx.32.2022.06.26.12.51.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jun 2022 12:51:08 -0700 (PDT)
Message-ID: <3c28bc43-4994-8e12-25f4-32b723e6e7ac@linaro.org>
Date:   Sun, 26 Jun 2022 21:51:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/2] NFC: nxp-nci: Don't issue a zero length
 i2c_master_read()
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        Charles Gorand <charles.gorand@effinnov.com>
Cc:     =?UTF-8?Q?Cl=c3=a9ment_Perrochaud?= <clement.perrochaud@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220626194243.4059870-1-michael@walle.cc>
 <20220626194243.4059870-2-michael@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220626194243.4059870-2-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/06/2022 21:42, Michael Walle wrote:
> There are packets which doesn't have a payload. In that case, the second
> i2c_master_read() will have a zero length. But because the NFC
> controller doesn't have any data left, it will NACK the I2C read and
> -ENXIO will be returned. In case there is no payload, just skip the
> second i2c master read.
> 
> Fixes: 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver")
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
