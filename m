Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106066EBEB0
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 12:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjDWKuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 06:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjDWKuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 06:50:05 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B21C1A4
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 03:50:04 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-506b8c6bbdbso4893496a12.1
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 03:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682247003; x=1684839003;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2fzBmJ5IaxGOE/MKESUjcu15ne21K7ZWZXs93DssTIU=;
        b=DVW+gq1t/Ga8g/padr1BQXIy9LolE6eOkEEqaXjDBMGvX6qCh08vb2eG4hWXN2TPQZ
         sq0ECt7m9ObNHuM9X7OTK8FFlXVE2shzNZixNcHBIPWELAYCrL38QiF6zjQ7w+Tc9C8X
         kWG6iMKlRRKNhu4j/AAcb27miqHERQWPzRiQUcSnSTNkoCYcn6N7O40EeDmwxY9MnF1V
         NvtFn38PDRZ9frpXRHospVkRm+g8uwS7qZ8/zSZpNg7UbyE5MdbtN+LW5Pw/MAR1iWVQ
         bsNN3bSrSuYTg2QB1+VDrKYo1qZ7N6GnlWnR7DmzLNVy/S6pzm1GHFUaY/BkYJiy4n0t
         metA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682247003; x=1684839003;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2fzBmJ5IaxGOE/MKESUjcu15ne21K7ZWZXs93DssTIU=;
        b=d5HorTttrfGto39N3pHUOus+7nAyyqse2CeOB2OgB4Fyf7bSDKkNu6bSO0sDvAGUJa
         ZSaDjc272lv00FvA0roJQmEzCdCDH0W/o/g80aHpyI1IEw9qmAmEVe24t9E4MYM6RfrK
         TMbiPW11m9oI95aa0dwml52Z2YyroB0d2kxqczv/oa9p2TmDtmSXICf7pjfjO+5SK2Lq
         UO3ETDSHgYMdcmKwEcO15xI+z1Mfyd3t0MnYTDHXDS3XCJfOa3oTTqnMp7ocjnNwP6O+
         Sv75++y4pdByvp8dsq9ozOO8Z2tdIMeEIW0o2g6tq22HOlv89Bd3/7/lR4b//cFhMMds
         AXSg==
X-Gm-Message-State: AAQBX9dA51Igsj/BfuEmBQrxHrengAv6xDzCw+GtklobUw+wwYAICfg/
        A4NfBexhv6xtza7Mok8Lav4epg==
X-Google-Smtp-Source: AKy350b60kIZRrMx1GXtSvsinNr30+8WRngC0UTGZPlTUxTXeSBxDO9eTw6EyUvjVqflIa4JLohPqw==
X-Received: by 2002:a17:907:9285:b0:959:8cbe:63a5 with SMTP id bw5-20020a170907928500b009598cbe63a5mr970045ejc.44.1682247002788;
        Sun, 23 Apr 2023 03:50:02 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:5d52:d466:d57f:118c? ([2a02:810d:15c0:828:5d52:d466:d57f:118c])
        by smtp.gmail.com with ESMTPSA id li14-20020a170907198e00b009572db67bf2sm2703485ejc.89.2023.04.23.03.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Apr 2023 03:50:02 -0700 (PDT)
Message-ID: <47f4cf35-50a7-51a0-5df6-3fadc5fee4cb@linaro.org>
Date:   Sun, 23 Apr 2023 12:49:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH RFC 1/4] dt-bindings: net: qualcomm: Add WCN3988
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
 <20230421-fp4-bluetooth-v1-1-0430e3a7e0a2@fairphone.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230421-fp4-bluetooth-v1-1-0430e3a7e0a2@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/04/2023 16:11, Luca Weiss wrote:
> Add the compatible for the Bluetooth part of the Qualcomm WCN3988
> chipset.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

