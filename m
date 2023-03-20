Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD4F6C0B6F
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 08:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjCTHhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 03:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjCTHhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 03:37:00 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610DF12CF9
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 00:36:58 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id ek18so42931382edb.6
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 00:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679297817;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1u1keNrwlSxZAkuogiDlSpUUhe7tlydyWOAQpr6eUZQ=;
        b=i5YWulF8A13Hk2/Fuq9ts3lAKcaK4to9nIq9nroeit9Akcy3epLW2uJ5w6it25FK43
         Z6ENW1Ns41950R96kAqJGRu4St5J2XdKp85FN92vs4n4dnh531BCajjP9pjuFyu0KAhN
         ZVvAyIXF+P3/rjgBe3KMOzh5j9TjUG0n4a2w5czc9jafFeaX2Q9jooBYLcJBO1xVrhXY
         HZl2hj2Gpnkj7+n41E1J1YsV+FjgEgKwHU905b0UzVAn+kl4PlECIaRMpMYrpnAKbZq6
         SxwD9pBjPns94eiENlpOj8SXXHCMmUDBxm7EtXrDNsHNB0yzbBqJkRRsMzA+tVH1ZJiC
         v3/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679297817;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1u1keNrwlSxZAkuogiDlSpUUhe7tlydyWOAQpr6eUZQ=;
        b=Og+KoKdvyxVxvaAZAi2LxfFXE/8BvJoLi3UDopvs0TFiCErylKNmg+7hfXYThOy5SB
         ti114Tkkdt+Bz6uuJIxFeep8psMYLPfKEggw9B9O5xxpsqpmOlvUdb66TtGC+MS80cJW
         vTDhtbDviGS3qH0JBcYSQrej0104gWYZp8wKTX7/ZVccLKqfbecSgOMAyGExHjfRyEVs
         1MFT1xwN3kiqNLPpClWM0uEL3wLpaF2gtPkXm8gTEceHW2XJZeoYaZcB78fNT50infXj
         e8EpZb/3UMnhzqFm/U6UtwDIv1Fg3u3Im3gKEiq4an1TqhTD3IyJ2rrE9VH8vIKVHTm6
         JQtA==
X-Gm-Message-State: AO0yUKXVX08w6nfoXbpRifnOeljJVcGfmJ+R7jE6ge18WcYpTEOT/mHv
        9rFUzrbMgx6C0kQp/oERw0pxcw==
X-Google-Smtp-Source: AK7set/t+53oOOD8eIyQPbZd6RDd9nOYzNrI9c5ak3LVckOfd3cTjKFbFUi1el1Yx5F45xPvoX28uw==
X-Received: by 2002:aa7:c858:0:b0:4fd:2a29:ceac with SMTP id g24-20020aa7c858000000b004fd2a29ceacmr11280938edt.14.1679297816830;
        Mon, 20 Mar 2023 00:36:56 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:4428:8354:afb6:2992? ([2a02:810d:15c0:828:4428:8354:afb6:2992])
        by smtp.gmail.com with ESMTPSA id u27-20020a50951b000000b004bf999f8e57sm4426183eda.19.2023.03.20.00.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 00:36:56 -0700 (PDT)
Message-ID: <34cb347f-17cf-3da1-b484-0c793ae8c5db@linaro.org>
Date:   Mon, 20 Mar 2023 08:36:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] MAINTAINERS: remove file entry in NFC SUBSYSTEM after
 platform_data movement
Content-Language: en-US
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     linux-nfc@lists.01.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230320073201.32401-1-lukas.bulwahn@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230320073201.32401-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/03/2023 08:32, Lukas Bulwahn wrote:
> Commit 053fdaa841bd ("nfc: mrvl: Move platform_data struct into driver")
> moves the nfcmrvl.h header file from include/linux/platform_data to the
> driver's directory, but misses to adjust MAINTAINERS.
> 
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> broken reference.


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

