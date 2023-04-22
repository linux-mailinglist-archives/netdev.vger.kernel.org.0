Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D426EB900
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 14:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjDVMDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 08:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDVMDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 08:03:39 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70C81BFF
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 05:03:37 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4ecb137af7eso2670423e87.2
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 05:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682165016; x=1684757016;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GTXIba6kgfgnk6XMMPm6IqSpaTy13D9nbXjftZoHK38=;
        b=GPuC2HOTbLafP1qatCOmNgcyDBTReKAPNo5aHGQ4ZHZB2PpLAM7ftc1KrLDydpuJa7
         8LP0KnbHQYk5IdlDEyiGzJS+B9rz6VOWi1CxSu4hb4jkJqKChcWRHMGsPJKNEhRSD2wF
         m2hUQCCKsdDFPDvUMSrYnwcyYXV3wf+hBt8xwtb5aLvC9PbotDn01SViambNGlAW0uIj
         UOK4xbMlwqQSjRycWGDZ6nU4UqgqbR0aSikN3/6eiBeuxo13ELHpXbVakoYTWmCondvm
         AoVz6iJUsbiqiXWjgjhLJpSm+aqZmvhxYjjhgKa5/lSIDqMiJLByibyI1qpl9Gmw7ZSx
         g7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682165016; x=1684757016;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GTXIba6kgfgnk6XMMPm6IqSpaTy13D9nbXjftZoHK38=;
        b=jxi4+jhF6gDE4+1usws6+r+2BuQwJ9xA0A18dyXmQDAvnLz4/FKvq1SyPAyBjx7Tua
         qyrYPWjGg3qJmUp20/U7YLF4S7BSsc8LDXPYDtCYzpGf3g6hrnsNqeuG029gnIJTK42q
         q22/jGKN8il/nmura2F8+2jPsohPKWnYjFjQYl8xA+guwf+l5Rhtbz4czdWdzQ0GFS74
         1XghuXmzpDOXWqepS1PJuYqM/K7AFVJHDoWV4j4EYADL8y7o1fefjXKSU2TFH6VvTzXG
         wHVq9JPo5o8Q0Tuvd87VMwH+f0ZWOZotIESPHOatRHNHMKgv4qS2AEIp313PE0F0Abab
         PKwg==
X-Gm-Message-State: AAQBX9cdsLPUWGVR1s6YYv1E7wkCKykoul9O0OIs1HNNn2DXVm/8QS6s
        f7RAkXCvXJTojNZv2YQlkJqyMw==
X-Google-Smtp-Source: AKy350ZSfGZXg/lW+W7YdjTftfPkbAG/5Xs05BCEMR1S/VVCsIkWnzZK2Qg0eD7kyb+fknQVOxyH/Q==
X-Received: by 2002:ac2:5a46:0:b0:4e8:47cd:b4ba with SMTP id r6-20020ac25a46000000b004e847cdb4bamr2350700lfn.13.1682165015987;
        Sat, 22 Apr 2023 05:03:35 -0700 (PDT)
Received: from [192.168.1.101] (abyj144.neoplus.adsl.tpnet.pl. [83.9.29.144])
        by smtp.gmail.com with ESMTPSA id b10-20020a056512024a00b004edc3bd7fa1sm872153lfo.201.2023.04.22.05.03.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Apr 2023 05:03:35 -0700 (PDT)
Message-ID: <0f2af683-07f9-7fc7-a043-ee55e41d65c3@linaro.org>
Date:   Sat, 22 Apr 2023 14:03:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH RFC 0/4] Add WCN3988 Bluetooth support for Fairphone 4
Content-Language: en-US
To:     Luca Weiss <luca.weiss@fairphone.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <20230421-fp4-bluetooth-v1-0-0430e3a7e0a2@fairphone.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230421-fp4-bluetooth-v1-0-0430e3a7e0a2@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.04.2023 16:11, Luca Weiss wrote:
> Just to start with the important part why this is an RFC:
> 
> While Bluetooth chip init works totally fine and bluez seems to be
> fairly happy with it, there's a (major) problem with scanning, as shown
> with this bluetoothctl snippet and dmesg snippet:
> 
>   [bluetooth]# scan on
>   Failed to start discovery: org.bluez.Error.InProgress
> 
>   [  202.371374] Bluetooth: hci0: Opcode 0x200b failed: -16
> 
> This opcode should be the following:
> 
>   include/net/bluetooth/hci.h:#define HCI_OP_LE_SET_SCAN_PARAM    0x200b
Not a bluetooth expert or anything, but does that thing support
bluetooth LE?

Konrad
> 
> Unfortunately trying various existing code branches in the Bluetooth
> driver doesn't show any sign of making this work and I don't really know
> where to look to debug this further.
> 
> On the other hand "discoverable on" makes the device show up on other
> devices during scanning , so the RF parts of the Bluetooth chip are
> generally functional for sure.
> 
> Any ideas are welcome.
> 
> @Bjorn: Patch "arm64: dts: qcom: sm6350: add uart1 node" should be fine
> to take regardless the RFC status, I don't think the problem is caused
> there.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
> Luca Weiss (4):
>       dt-bindings: net: qualcomm: Add WCN3988
>       Bluetooth: btqca: Add WCN3988 support
>       arm64: dts: qcom: sm6350: add uart1 node
>       arm64: dts: qcom: sm7225-fairphone-fp4: Add Bluetooth
> 
>  .../bindings/net/bluetooth/qualcomm-bluetooth.yaml |  2 +
>  arch/arm64/boot/dts/qcom/sm6350.dtsi               | 63 ++++++++++++++++++++++
>  arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts  | 17 ++++++
>  drivers/bluetooth/btqca.c                          | 13 ++++-
>  drivers/bluetooth/btqca.h                          | 12 ++++-
>  drivers/bluetooth/hci_qca.c                        | 12 +++++
>  6 files changed, 115 insertions(+), 4 deletions(-)
> ---
> base-commit: cf4c0112a0350cfe8a63b5eb3377e2366f57545b
> change-id: 20230421-fp4-bluetooth-b36a0e87b9c8
> 
> Best regards,
