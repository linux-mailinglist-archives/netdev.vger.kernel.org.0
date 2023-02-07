Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4962D68D488
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjBGKjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbjBGKjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:39:22 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAD03867B
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 02:38:55 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id q8so10694141wmo.5
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 02:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4lFvnNUEfmFOZfC45OwvN3PFMk0fFsXufSpzORMwHDk=;
        b=EDxzu3TsCDNriK0w84Lk1nw+1AacJKCVYQf/T5G5+W4VcReJW6LHMqspzdCN8XFBhM
         Esm0DmEjb8XJGxHv9CiXEKYvhiY0GsW08xyGl7izi1HmeWxF4RJVJUdYRYjTx0Z4F0AV
         h4uocSKdFbqP0fuJbflEBWAliE7VPwf8R55x/qvS906+9Ij3d+8SEEhQR9GCUXDNHVJy
         El8L4lc0pOUNfjRVszr5zgLgGNxivA5YV6uYsdLF+ywgMgNlvtU+uY3zq1ultazVANqH
         Yl/OSk7aOqNvolpM01EiDUEi2X52i3aFPBigRXtIpdBvYHqA5j6O20SsDytYHZ9sg6G+
         7B+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4lFvnNUEfmFOZfC45OwvN3PFMk0fFsXufSpzORMwHDk=;
        b=nnNYmAHKBgFzo5mYVZAckbhI16LCiHdpuo2B0bvN2TTPfBRAffUMgPcOSXadzdnKbY
         fGiS+Fp/a4otO+15nFhSAC5kI4fvIKJV0850t8ZYGe+ED5p/UDncZJgf8SJFS9/eX80J
         FFCVKhMB+VhLGreCOZh5WgZ+URHQ81w372J/XcvB9we2M86lq9tVFs1iCWGmBEXv3vGb
         F5c3nL+e9ipHvUShKhXqiY2vRQQE86AKECYqjhPgX1aPuGeAXOdimg9FKWXehRiZZxRs
         oOPGjSNla7c6YM982RgUlHtIIFhKLRLlo3RDYfqRJXzBV8yA0S/Z1DBFu9hfCMoj6TM6
         mjHQ==
X-Gm-Message-State: AO0yUKU/5KGq0ekHgMlkoiJoNF6cQqHYxcj588KLHhaXPfCD1bUkLaDU
        A3/okSPGX6eZnp1L2d2zRrz29w==
X-Google-Smtp-Source: AK7set9EA70AZrV3ayvDW+3CXaJxEpJLLXtDp/TCoH8Algcq36FWfYcEPeGEadcXYAC4a1d9kulBKg==
X-Received: by 2002:a05:600c:4919:b0:3df:a04a:1a7 with SMTP id f25-20020a05600c491900b003dfa04a01a7mr2731579wmp.22.1675766332065;
        Tue, 07 Feb 2023 02:38:52 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id t6-20020a05600c450600b003dc433bb5e1sm14444330wmo.9.2023.02.07.02.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 02:38:51 -0800 (PST)
Message-ID: <4fb45056-3004-b68d-06b7-b4109e813c51@linaro.org>
Date:   Tue, 7 Feb 2023 11:38:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 1/2] dt: bindings: net: ath11k: add dt entry for XO
 calibration support
Content-Language: en-US
To:     Youghandhar Chintala <quic_youghand@quicinc.com>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230207103607.12213-1-quic_youghand@quicinc.com>
 <20230207103607.12213-2-quic_youghand@quicinc.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230207103607.12213-2-quic_youghand@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2023 11:36, Youghandhar Chintala wrote:
> Add dt binding to get XO calibration data support for Wi-Fi RF clock.
> 
> Retrieve the XO trim offset via system firmware (e.g., device tree),
> especially in the case where the device doesn't have a useful EEPROM
> on which to store the calibrated XO offset.
> Calibrated XO offset is sent to firmware, which compensate the RF clock
> drift by programing the XO trim register.
> 

And this is second v3 and still not fixed. The same as previous v3 and
previous v2 (???).

Best regards,
Krzysztof

