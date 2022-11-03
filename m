Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41996183B9
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 17:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbiKCQHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 12:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbiKCQHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 12:07:03 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A9BD50
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 09:06:22 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id h10so1426031qvq.7
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 09:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BAwWVgTndPY/btJdMWBIl8yfS+4klgWQn8G3RCVkmhs=;
        b=vGY8dP8EH3AfGZTE0Boh+fFEXkvrnnMIRVpUONpp7uYHujUJyCbc9+kyd8lkvZyeaF
         ysN7/h9tkeplmo1K16z2c8Bd8b0dLkItq8xSJtsCsp4uleaaP1jI2ni5FzHUL27RiPiC
         zrvKpUP2Z5vjKvPXBaPmEDHAP7fmnY1sIbAIp9jCBxcebkmAXEU1K8U3ISCk6F98twYd
         aRxquHWkE1mXymB/JFzEkx/QS/7yDzjM5g0p6uoNE8ILFViQhhSiZMbPG/D72wxR6wIw
         cD1jL7j8XaYbewfGU9gg8ghsAZRJ+W08In+MY6VOOoBw6/M0OUONF+OFRmy9zOEdDy+Q
         3L/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BAwWVgTndPY/btJdMWBIl8yfS+4klgWQn8G3RCVkmhs=;
        b=iXXLB4XodNotb69FPpOGubijPr7d38a1MFYG5HkfMHsG1AUfJ1Y+f64oysUVC1hCvr
         8i8+eUErKa4sQkuSVdFrGntf03ExqydMzK5O34NDIATXaPFWI0Hgr4oN88st+iAzhAYr
         5/fEr7IgrAcOCFCldPSd2fPx+j8iubCp0qp23b/jtra8NbhwjVoXLfa4FEcGDVzYL2mG
         9bd8NHTw7VB9ODE4w3k/bhcVPQkhhaP1nxt44Ytebwn3EL0kodORql3Khyz4YHb/p1/p
         A9/6BMwraHGu4DqOnfJygo/h/y1K+Sao7+qpfvU/CjFLKX2RE9dcEjl4r4s55uyy6blI
         mzfA==
X-Gm-Message-State: ACrzQf1sQtHGU31r/eAjnuNj29G9uG+QIbyH5bVyp+FqrsZSIVVBZzFH
        Ux6lQLIrJ3UWaKr523+CR6lMGf+NU/J6+Q==
X-Google-Smtp-Source: AMsMyM5uzhsQnE4eql7/hkVuYY8+64udvAuHMLB4kBHRWoVA/Pr7DYZbZUM/Ty6d9E42fiFm1SzayQ==
X-Received: by 2002:a05:6214:f21:b0:4bb:b1f7:4cb7 with SMTP id iw1-20020a0562140f2100b004bbb1f74cb7mr27252582qvb.107.1667491581214;
        Thu, 03 Nov 2022 09:06:21 -0700 (PDT)
Received: from ?IPV6:2601:586:5000:570:a35d:9f85:e3f7:d9fb? ([2601:586:5000:570:a35d:9f85:e3f7:d9fb])
        by smtp.gmail.com with ESMTPSA id l16-20020a37f910000000b006ecdfcf9d81sm993778qkj.84.2022.11.03.09.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 09:06:20 -0700 (PDT)
Message-ID: <326aeb6b-e2f3-dfb5-b604-a4d2d32e412e@linaro.org>
Date:   Thu, 3 Nov 2022 12:06:19 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next] net: axiemac: add PM callbacks to support
 suspend/resume
Content-Language: en-US
To:     Andy Chiu <andy.chiu@sifive.com>, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, greentime.hu@sifive.com
References: <20221101011139.900930-1-andy.chiu@sifive.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221101011139.900930-1-andy.chiu@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/10/2022 21:11, Andy Chiu wrote:
> Support basic system-wide suspend and resume functions
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 36 +++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 

Why Ccing us?

Best regards,
Krzysztof

