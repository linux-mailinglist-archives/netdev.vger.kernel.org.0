Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078B86E2B40
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 22:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjDNUoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 16:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjDNUoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 16:44:04 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C9E5B9E
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 13:44:03 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id c9so9795377ejz.1
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 13:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681505042; x=1684097042;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k/nx/yKVbSsYFF5X0g9blNxbC1WsVq39ejbZ4qWxfM4=;
        b=Ka24PG3jdtgMZW+uR4p/SVUg5cMBUtdd3X/qmhLPC52CEUJbbs59MkyYCFent9DH2d
         E0xG3C6UMAr5vpG+BrO4blJSsiRtGeghEB6SPsyLiSu1llEBoGJFaujchENgVyC5d3H+
         IdVE9Opq0NfJAUYJJ3ZyuR+/evAehUq6h9uncJkKg0wq+IJMnYXCmzyDmfOqi74LI2oT
         eSZps8MaYm54Y/Y5bdKhtMnYf+2U0J7FK0YYRWLqLT3w37gmyeATunCmWsc6m/9VPIwc
         OUB3Dyskhgl532D0H1hWlJnUNIsDjx48wBav2YQUcJMBThdmL/ZVEh20Bm81b5f1numX
         q96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681505042; x=1684097042;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k/nx/yKVbSsYFF5X0g9blNxbC1WsVq39ejbZ4qWxfM4=;
        b=fCZEX6VX1i+uEF3JUdSWJSWN+Dj9rqq1AIA7hRmLd62XhnVRdcitjBgAvhEVrd6m+T
         AruHAMWmGHP6atIDJo1l8StlS7n2n1kwE3A6GDIVClly6yH+isQnmy8nYjqIH+1DcK81
         0pOY21pEIjiKGYpOlANSJpnhGIq+/AglAtlTu5PAyPCXonF/TpGYa5lRfaZSDMz7syM3
         wfecdPH+CgcnYFeiMu7zNFCs9s7bANsCrcolQZQy3SZuP0RZgXKkUccrSeY7VJnTlZus
         eVcn4rcMbyTwhXzw0wtfXo/X/kNZmystMAROYwY8772dDjOKjQ9n+/KN7m7sQHlijRxq
         t4lQ==
X-Gm-Message-State: AAQBX9eNPznetahzD4bXp0kiey4P+DzgyDBBXOPqXRwsA33kdHH3TWMy
        GNw5XcfMHnqXHlYaH9gnyhERCg==
X-Google-Smtp-Source: AKy350ZOjOg5ES3cZwD713h6zSPRrL5WIGdTryxXFTVy1eJJGbtMQ8icDtPg15fL8avEWmLCkrIbUA==
X-Received: by 2002:a17:906:7295:b0:947:3d04:61dc with SMTP id b21-20020a170906729500b009473d0461dcmr324838ejl.77.1681505041758;
        Fri, 14 Apr 2023 13:44:01 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:ffae:8aab:ae5a:4688? ([2a02:810d:15c0:828:ffae:8aab:ae5a:4688])
        by smtp.gmail.com with ESMTPSA id qf29-20020a1709077f1d00b0094a2f92aaeesm2852341ejc.158.2023.04.14.13.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 13:44:01 -0700 (PDT)
Message-ID: <342dd9b0-35cd-1715-ee67-6a6628a3a9a6@linaro.org>
Date:   Fri, 14 Apr 2023 22:44:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [RFC PATCH 4/5] arm64: dts: ti: Enable multiple MCAN for AM62x in
 MCU MCAN overlay
Content-Language: en-US
To:     Nishanth Menon <nm@ti.com>
Cc:     Judith Mendez <jm@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>
References: <20230413223051.24455-1-jm@ti.com>
 <20230413223051.24455-5-jm@ti.com>
 <9ab56180-328e-1416-56cb-bbf71af0c26d@linaro.org>
 <20230414182925.ya3fe2n6mtyuqotb@detached>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230414182925.ya3fe2n6mtyuqotb@detached>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2023 20:29, Nishanth Menon wrote:
>>> +
>>> +&cbass_mcu {
>>> +	mcu_mcan1: can@4e00000 {
>>> +		compatible = "bosch,m_can";
>>> +		reg = <0x00 0x4e00000 0x00 0x8000>,
>>> +			  <0x00 0x4e08000 0x00 0x200>;
>>> +		reg-names = "message_ram", "m_can";
>>> +		power-domains = <&k3_pds 188 TI_SCI_PD_EXCLUSIVE>;
>>> +		clocks = <&k3_clks 188 6>, <&k3_clks 188 1>;
>>> +		clock-names = "hclk", "cclk";
>>> +		bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
>>> +		pinctrl-names = "default";
>>> +		pinctrl-0 = <&mcu_mcan1_pins_default>;
>>> +		phys = <&transceiver2>;
>>> +		status = "okay";
>>
>> okay is by default. Why do you need it?
> 
> mcan is not functional without pinmux, so it has been disabled by
> default in SoC. this overlay is supposed to enable it. But this is done
> entirely wrongly.

Ah, so this is override of existing node? Why not overriding by
label/phandle?

Best regards,
Krzysztof

