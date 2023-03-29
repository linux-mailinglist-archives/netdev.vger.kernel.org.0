Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251EF6CCF0C
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 02:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjC2Ai2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 20:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjC2Ai0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 20:38:26 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18ACA1FD3
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 17:38:24 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id j11so18031572lfg.13
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 17:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680050302;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dvzs0kpo0/PAizdops3QccpQcKA0hqjc3QEnrtXa61o=;
        b=d8cCB8tXKIOHo4KQObZdLZJ+57ilMp8eG6c96ursn1OHz5tfmDZcbncqlKfSQyI23F
         UQO7ijEef9D/LhjOlsh58NCKVVRQrWzk1OoCkrtQboZ1YI0ityHDImIIlnXvmDSy7jk3
         OEnWJ/xvNS5iFgLCZs0gdgssMGF4pjXb9CcFI9n9fOZZPusODnzo3VKZakJrvfyCyha+
         kgQgx8CzbRQB4qgr3F+LPGsoZJiEXAW+dNOgs6ezZ6FCtMzeKUK8PxkB703P92wHUqJl
         XsDEqSxER10z45YpG5aLqkplsQi7PQ+xbQ0D2sICQ35PTwKgoDAMd4s08Ms7KtLkyt2Q
         RoIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680050302;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dvzs0kpo0/PAizdops3QccpQcKA0hqjc3QEnrtXa61o=;
        b=hjpFdX6OWyvxgjuHF0E4cYKo6vP/NdaajtIeaf0LlIQv5D+l+0IwcLfnLZR7RJC2wT
         d2G8+CzNkV26/y+A7ZrYKQT5kB/HWPDMaTcV8rIglc9Jvee+1Szc+zAfeHPOk42eS1MI
         in6l1SDKu7n9jeHfLfmbA06mRFM7LrUZzIs8EdJ0dKgNbBNZxyVThVL2mM9Z1MHdvi5b
         A625jIpVg+nHhFT22hHxuBQF++3sSRuaJAAq8JyB7PnlcnljfNarU+py52j8OFA8dVyJ
         bfBUGDjGpAVP1N/q4EOyZKKH9FBfB4GuosnPslygp8jDBaoJg/oyQCn4ofOIn6BEb67a
         I/vQ==
X-Gm-Message-State: AAQBX9fFiBW6SGaKPvxpcOV1V8t2njQ2IKN2qIBzz+Ecjiick1mloAyU
        hP7h8aq97jlroDz82Yddg5YFeg==
X-Google-Smtp-Source: AKy350ZZ6F0C87mmgmaDWhAn3/3AksFtTn60Kkv2AXombH9SF9GZimwQLrCm/8iiArekJXWhpF3W7w==
X-Received: by 2002:ac2:52bb:0:b0:4b5:9b8f:cc82 with SMTP id r27-20020ac252bb000000b004b59b8fcc82mr5163830lfm.0.1680050302347;
        Tue, 28 Mar 2023 17:38:22 -0700 (PDT)
Received: from [192.168.1.101] (abxj225.neoplus.adsl.tpnet.pl. [83.9.3.225])
        by smtp.gmail.com with ESMTPSA id c18-20020ac25312000000b004eaec70c68esm3407759lfh.294.2023.03.28.17.38.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 17:38:21 -0700 (PDT)
Message-ID: <38784d53-3198-3f27-06c3-6a9772cdc998@linaro.org>
Date:   Wed, 29 Mar 2023 02:38:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v8 4/4] arm64: dts: qcom: sc8280xp-x13s: Add bluetooth
Content-Language: en-US
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Johan Hovold <johan@kernel.org>
References: <20230326233812.28058-1-steev@kali.org>
 <20230326233812.28058-5-steev@kali.org>
 <CABBYNZLh2_dKm1ePH3jMY8=EzsbG1TWkTLsgqY1KyFopLNHN6A@mail.gmail.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <CABBYNZLh2_dKm1ePH3jMY8=EzsbG1TWkTLsgqY1KyFopLNHN6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29.03.2023 00:24, Luiz Augusto von Dentz wrote:
> Hi Steev,
> 
> On Sun, Mar 26, 2023 at 4:38 PM Steev Klimaszewski <steev@kali.org> wrote:
>>
>> The Lenovo Thinkpad X13s has a WCN6855 Bluetooth controller on uart2,
>> add this.
>>
>> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> 
> I would like to merge this set but this one still doesn't have any
> Signed-off-by other than yours.
> 
>> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>> Changes since v7:
>>  * Drop regulator now in a different patchset from Johan
>>  * Fix alphabetization
>>
>> Changes since v6:
>>  * Remove allowed-modes as they aren't needed
>>  * Remove regulator-allow-set-load
>>  * Set regulator-always-on because the wifi chip also uses the regulator
>>  * cts pin uses bias-bus-hold
>>  * Alphabetize uart2 pins
>>
>> Changes since v5:
>>  * Update patch subject
>>  * Specify initial mode (via guess) for vreg_s1c
>>  * Drop uart17 definition
>>  * Rename bt_en to bt_default because configuring more than one pin
>>  * Correct (maybe) bias configurations
>>  * Correct cts gpio
>>  * Split rts-tx into two nodes
>>  * Drop incorrect link in the commit message
>>
>> Changes since v4:
>>  * Address Konrad's review comments.
>>
>> Changes since v3:
>>  * Add vreg_s1c
>>  * Add regulators and not dead code
>>  * Fix commit message changelog
>>
>> Changes since v2:
>>  * Remove dead code and add TODO comment
>>  * Make dtbs_check happy with the pin definitions
>>
>>  .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 70 +++++++++++++++++++
>>  1 file changed, 70 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
>> index da79b5465a1b..129c5f9a2a61 100644
>> --- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
>> +++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
>> @@ -24,6 +24,7 @@ / {
>>         aliases {
>>                 i2c4 = &i2c4;
>>                 i2c21 = &i2c21;
>> +               serial1 = &uart2;
>>         };
>>
>>         wcd938x: audio-codec {
>> @@ -1102,6 +1103,32 @@ &txmacro {
>>         status = "okay";
>>  };
>>
>> +&uart2 {
>> +       pinctrl-0 = <&uart2_default>;
>> +       pinctrl-names = "default";
>> +
>> +       status = "okay";
>> +
>> +       bluetooth {
>> +               compatible = "qcom,wcn6855-bt";
>> +
>> +               vddio-supply = <&vreg_s10b>;
>> +               vddbtcxmx-supply = <&vreg_s12b>;
>> +               vddrfacmn-supply = <&vreg_s12b>;
>> +               vddrfa0p8-supply = <&vreg_s12b>;
>> +               vddrfa1p2-supply = <&vreg_s11b>;
>> +               vddrfa1p7-supply = <&vreg_s1c>;
>> +
>> +               max-speed = <3200000>;
>> +
>> +               enable-gpios = <&tlmm 133 GPIO_ACTIVE_HIGH>;
>> +               swctrl-gpios = <&tlmm 132 GPIO_ACTIVE_HIGH>;
>> +
>> +               pinctrl-0 = <&bt_default>;
>> +               pinctrl-names = "default";
>> +       };
>> +};
>> +
>>  &usb_0 {
>>         status = "okay";
>>  };
>> @@ -1222,6 +1249,21 @@ hastings_reg_en: hastings-reg-en-state {
>>  &tlmm {
>>         gpio-reserved-ranges = <70 2>, <74 6>, <83 4>, <125 2>, <128 2>, <154 7>;
>>
>> +       bt_default: bt-default-state {
>> +               hstp-bt-en-pins {
>> +                       pins = "gpio133";
>> +                       function = "gpio";
>> +                       drive-strength = <16>;
>> +                       bias-disable;
>> +               };
>> +
>> +               hstp-sw-ctrl-pins {
>> +                       pins = "gpio132";
>> +                       function = "gpio";
>> +                       bias-pull-down;
>> +               };
>> +       };
>> +
>>         edp_reg_en: edp-reg-en-state {
>>                 pins = "gpio25";
>>                 function = "gpio";
>> @@ -1389,6 +1431,34 @@ reset-n-pins {
>>                 };
>>         };
>>
>> +       uart2_default: uart2-default-state {
>> +               cts-pins {
>> +                       pins = "gpio121";
>> +                       function = "qup2";
>> +                       bias-bus-hold;
>> +               };
>> +
>> +               rts-pins {
>> +                       pins = "gpio122";
>> +                       function = "qup2";
>> +                       drive-strength = <2>;
>> +                       bias-disable;
>> +               };
>> +
>> +               rx-pins {
>> +                       pins = "gpio124";
>> +                       function = "qup2";
>> +                       bias-pull-up;
>> +               };
>> +
>> +               tx-pins {
>> +                       pins = "gpio123";
>> +                       function = "qup2";
>> +                       drive-strength = <2>;
>> +                       bias-disable;
>> +               };
>> +       };
>> +
>>         usb0_sbu_default: usb0-sbu-state {
>>                 oe-n-pins {
>>                         pins = "gpio101";
>> --
>> 2.39.2
>>
> 
> 
