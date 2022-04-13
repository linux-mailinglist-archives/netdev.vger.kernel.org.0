Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACADF4FF045
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 08:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbiDMHAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 03:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiDMHAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 03:00:16 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D6C3A5F0
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 23:57:56 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z99so1209293ede.5
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 23:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Sp7hvnptI/W931YQG2jYIshQ4aGCuypBebE/tzGdpNE=;
        b=DZYcVZPTG6D4QslsNYGDX5RqcCwCUafMJpigiGnSHDCSYV+q64FSGnHUfzJSPU5D4G
         jnQnCkMgolBpdMgsGJin3kk5/6VDc+qWq5/fFWXKKGWBsdlmnNNAv39e9yBZubRip+zm
         FpwkvHMP64vP8AceHhRoZhsU0FYAranP54kaRvkCODgfTKH/xcWem/Vsz8VBPRZQx6p9
         MomQ1FxYys+vUb0r4xGI+EqR48oCje0smOtK6b61DQoJubTvo7ha61G62MeiRuO1ETD2
         5rU9aubI/ZkSDGdFmU9QE5W0uE29o8cn8LeeX97Sa0NI0CLXy19vzzgyWrviBVqFFyNE
         mOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Sp7hvnptI/W931YQG2jYIshQ4aGCuypBebE/tzGdpNE=;
        b=rSDxel92P0mQw7CmSJtqjc9tDHVfCxvn/MM+TOw4R8rsSm9Kp/KHqrWKQDIBGZxL5b
         mTpjmaEVOxT2OLR/yRJdsoIcfkWzs4/NTzB2UxQ3vhaX+4d79wucqTVAtxxWROh288so
         8TNUXXt6/UQPvof+P9hhA87JYkN5JzzTWBpOcWXWyl42hIEW+/XBaDzoExiB/YrvY+7u
         t4QJvZbnnxZNQe2iEWnClh/YZzHApfQyEURZeizzOmF+PjeQpt/BmXJ1TeWVh9cChS5I
         xRkR44SQwKovVLBr9Gc889Zm/RYSwPVDsWSEKgGIXFkHx4c7N51O4o1SZ/528UT6o2Ou
         G+aQ==
X-Gm-Message-State: AOAM530Bxu60NZ+a9Pg0IriVEcr4V1hCzEwpoJ3wqss+pUBmPvMf52mA
        ZUPBuqGuLRr5OuykDOBhqxQnTvj/NR+iZvKJ
X-Google-Smtp-Source: ABdhPJzbzMuM4BvHhngh/VtLKxfaJL42ZAWCd0mGa6jKe4PYZJ7XnE4R/OnhhLTYyv2aEzA90bOaxA==
X-Received: by 2002:a05:6402:515b:b0:41d:82c2:2749 with SMTP id n27-20020a056402515b00b0041d82c22749mr11624701edd.38.1649833075220;
        Tue, 12 Apr 2022 23:57:55 -0700 (PDT)
Received: from [192.168.0.201] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id fq6-20020a1709069d8600b006e891c0b7e0sm3212170ejc.129.2022.04.12.23.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 23:57:54 -0700 (PDT)
Message-ID: <86da471e-b18f-94e2-64a9-e0f3417ade60@linaro.org>
Date:   Wed, 13 Apr 2022 08:57:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v0] nfc: nci: add flush_workqueue to prevent uaf
Content-Language: en-US
To:     Lin Ma <linma@zju.edu.cn>, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mudongliangabcd@gmail.com
References: <20220412160430.11581-1-linma@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220412160430.11581-1-linma@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/04/2022 18:04, Lin Ma wrote:
> Our detector found a concurrent use-after-free bug when detaching an
> NCI device. The main reason for this bug is the unexpected scheduling
> between the used delayed mechanism (timer and workqueue).
> 
> The race can be demonstrated below:
> 

Thanks!

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof
