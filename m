Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B52F660079
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbjAFMpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbjAFMpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:45:53 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A9069B33
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 04:45:51 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id m7so1158364wrn.10
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 04:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=khPmDzOyxE/W50Ody7PwHzpUcoSlWvXrUU0o2jFfLxk=;
        b=Fvsz5yRrcMX4nxoWRAXgOW27XaqYBWwY/JJP4Fojd5awfjCnzaOBcg5ufYCfqbDjGo
         uriwH7YQ+Go5EIRB9pOhU0M16q5ShJ8HZjF/BzJUMEtBy4eXSbsBrrUtBU9MWxQgAMcD
         TLc8uuMvd3SHIb7wl7LZZ8wT4KB8+CYXOMoGVRveeuBbnImDlUWpVINhGAu24isKgTr6
         cz6bN4U1vkJnY0d9ngCJaMj3QKWdru2dGZtObkMcm7WNXRfDxA/4EAbQTmoVy2Vr+iE4
         hBMHq9xY5COTWPBPdhY+agc7wN2vYeD3HdG7AqGDTRx82Totq6x1B0PEHhPuYONTVnMt
         C6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=khPmDzOyxE/W50Ody7PwHzpUcoSlWvXrUU0o2jFfLxk=;
        b=a1awnbdenIugi7kDSbtiToiO8GYY+lq8f39cAsmYgPR+fW2GoB86UZ0Ejoh/pPIeGG
         jrXiToEDUXejv13U6j6zEoZ0I0wCLR1II8ycA3OPQUA7U3piN/gsnQnMmUX4Y17uUOES
         q1Hrx83FSxe8cqPnClYV43E8wOw6TraGOJHwu/Rt0awqW+WZYZLRqIzJGYyUxCt0Gvee
         Pha9KmctEWTa94bPw47Pst/ASWCgYP9xVkHWPWcnpOSBQ5IcBefExt5p+buVYXQO64Zb
         6uPoTJcgZVcbPXeazmKzLAQk/WOWh1AMZTOLtTutlNEufnJhthh5i7jeQ+o8Sddz62CT
         efiQ==
X-Gm-Message-State: AFqh2krgsD949IsL6912CRiD9NeXFN0vlg7Ef53ehA7vFrXgRBxXp4zp
        izMQYnvuNd/FYCKdEdhmL4H4Cg==
X-Google-Smtp-Source: AMrXdXuoIOO5FVUdypctPo2dsGnGrRrAcBI04oxEbt1bBMpKVgLXEnDGKxUhk1TmLa3v1vFVO23y7w==
X-Received: by 2002:a5d:4249:0:b0:276:d612:4bbe with SMTP id s9-20020a5d4249000000b00276d6124bbemr33577771wrr.38.1673009150157;
        Fri, 06 Jan 2023 04:45:50 -0800 (PST)
Received: from [192.168.1.102] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id f8-20020a0560001b0800b002423edd7e50sm1100348wrz.32.2023.01.06.04.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 04:45:48 -0800 (PST)
Message-ID: <c114239e-2dae-3962-24f3-8277ff173582@linaro.org>
Date:   Fri, 6 Jan 2023 13:45:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 4/7] dt-bindings: net: Add support StarFive dwmac
Content-Language: en-US
To:     Yanhong Wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20230106030001.1952-1-yanhong.wang@starfivetech.com>
 <20230106030001.1952-5-yanhong.wang@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230106030001.1952-5-yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2023 03:59, Yanhong Wang wrote:
> Add documentation to describe StarFive dwmac driver(GMAC).
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>  .../bindings/net/starfive,jh7110-dwmac.yaml   | 113 ++++++++++++++++++
>  MAINTAINERS                                   |   5 +

Order the patches correctly. Why this binding patch is split from previous?

Best regards,
Krzysztof

