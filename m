Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399D76EBEB9
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 12:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjDWKvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 06:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjDWKvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 06:51:19 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEC61A5
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 03:51:17 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-506bfe81303so5647205a12.1
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 03:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682247076; x=1684839076;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l4fBDurIv/UK1aWcIcqRyq4AV8M0Z0IoKyje8gmCsdE=;
        b=R2gyjMmfrolv3Qy3l6Rig5kH3Rbn/DsWc26qVDQHEg9Q2Mh8Se97tnGuMb1bK6xJcx
         2Sc4+u7w7i7X5n6NNN3M9OR4Bapa97hQEzjR5jwMxQhhyo7gs7fskX89IKwzDvaIDFdy
         WV8xTPVAC7UFcn3TntDGqPKsRV5OLN8B5iLnwKg95LthkFOoxsU4sIvVJ3uFs+IaTxPu
         XlHI235e/W57+cWCSQpsfLRpn1Oa6JBmeR5fOVSOf+cxMMyPS80heWw0OVgEQv8dx/8q
         PBYpYUS4/1l4JlKUqe8RSb0M8BqqUx26fLEGRqDDjgGvIvgem4sGEeAnldqIOXE3lQdv
         SlMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682247076; x=1684839076;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l4fBDurIv/UK1aWcIcqRyq4AV8M0Z0IoKyje8gmCsdE=;
        b=IW9wjmP7Cej9EsTxiB1aIamlzpNT5tD0g/SfOKZdd+UyIQiEkpztC04543Z9ID692u
         rlxqG8ZWootYQ50LUCGkods/eHsm7oVMv3F/yGlovkI1SzFSk4TyrdRShdcGAGFf0PkM
         OGaClzmsNE2CsG8tFqnBKJtB0augcZ08w+vyAzFTH0Y6TfIwAxiSnsHNtBmop3Mah8xV
         agDCECQFs72xEkUOGDv85CsVzVcgRZK6m1Cq63nKRMA8faVoVMuHx+WAjpowXt/IhkRX
         bmwvsbZWwqwEP9HslqrtLGKoJ/aJzDo7g47eer6eIuPFz8ZxJPDmgxO1qAL5eut/+HsE
         +CiQ==
X-Gm-Message-State: AAQBX9fsHy/XDdr9IOc5YDiIPDQEd+lwgzmGbdDmOuah4RNF1RkVP3ki
        peAfeXD9dAmsOFCLUBNJ0JUOhw==
X-Google-Smtp-Source: AKy350a5qgDDOp2IDTSF99nlx2920R3KAK3ecPfrgSqsuZFCDGiHaJZ/dOX/8KseLHqVvkdKx7jA8Q==
X-Received: by 2002:a50:fb8e:0:b0:506:843f:2f27 with SMTP id e14-20020a50fb8e000000b00506843f2f27mr8731491edq.11.1682247076408;
        Sun, 23 Apr 2023 03:51:16 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:5d52:d466:d57f:118c? ([2a02:810d:15c0:828:5d52:d466:d57f:118c])
        by smtp.gmail.com with ESMTPSA id x3-20020aa7cd83000000b004fbf6b35a56sm3625450edv.76.2023.04.23.03.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Apr 2023 03:51:15 -0700 (PDT)
Message-ID: <8f312ded-8456-eced-85cc-0ae32a0c8bba@linaro.org>
Date:   Sun, 23 Apr 2023 12:51:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH RFC 3/4] arm64: dts: qcom: sm6350: add uart1 node
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
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <20230421-fp4-bluetooth-v1-0-0430e3a7e0a2@fairphone.com>
 <20230421-fp4-bluetooth-v1-3-0430e3a7e0a2@fairphone.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230421-fp4-bluetooth-v1-3-0430e3a7e0a2@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/04/2023 16:11, Luca Weiss wrote:
> Add the node describing uart1 incl. opp table and pinctrl.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  arch/arm64/boot/dts/qcom/sm6350.dtsi | 63 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)

Please do not send DTS patches for net-next. DTS must go via Qualcomm
SoC. Split the series and mention where is the bindings change in DTS
patchset.


Best regards,
Krzysztof

