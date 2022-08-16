Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAA8595A89
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbiHPLqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbiHPLpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:45:35 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A471179
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 04:18:48 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id u6so10190266ljk.8
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 04:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=ahlHZt6wMpsmmfs0QS0vK63rtQP8YDKkCtKg6V0r2Pk=;
        b=IL7FC1vJvvHK9WxLcCuSh/XcTk1gbum4cZ/b34iIxq1Lnd+4OIto+CvNIQ+PYM2KdR
         3BvVULGQwv1V95J3w7EDj4+mDYROK1hqCm5/OCbZzM0tlqSQoiFuIF2PkvJseJlZmzvl
         fOvWZFJphpCE3YLfi7Ws0vHfAH8Q4OWiyPBZlReyluc1R6uq+3sL9rXtKLK5OumoqcGN
         PMAWH0PXS5Df4vv68HIas8lB9uuFjtV6c1+h11Jn60tRHRbP0omMR2xHkFx3sL0/20P1
         VzMF8AcGoQNCi/C+AgfXCsiE46qaQ+EupE0fRIkpVSPok3++l/x6Vt0r3AvYbm7IfPEY
         infg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=ahlHZt6wMpsmmfs0QS0vK63rtQP8YDKkCtKg6V0r2Pk=;
        b=h2bb5OqPiD95BFaq2GB+SdGmlfag1LD4ukoWnjwg2U3wGc3xwOwp8FEY5wWKvjI2qS
         bsUT60r9pdyWoKSaoci89P5e3lCiOx9B84bN4VS0YKLKoIeZh0n34x4GWH6VXoWvfk7u
         bPBAp5BaiTosGERP86Etw777dIso7F1dV96mH7enWl6QSK05hIdqEJrjbUhn4GT8B8y5
         qGQ1HeMjrke/ytwH3x8/uGSeFn6cM/Gsj33Dd7a0lP/KKIv+Rdp3qQk/uUhYsdS8cmru
         2b2w6D5p0I/jZwtWxAB+r8R2KfbfKHg5edukkM9PGTxjaX7TCpaantksG9/bA/QD23vD
         XX+A==
X-Gm-Message-State: ACgBeo1BDNI/H97GC8jPDR9j0ehnsEYjRgp6V/N/pqA1BtdXFjZh5fF0
        3LaUD6LyP5+hKi+z8MQyczbXcQ==
X-Google-Smtp-Source: AA6agR7R2WGkVknzhv7N5shmDhgnFVXYpWlD+OCJ3gumTMxZC/mqGJiD3IwZU5x5Ofj/1ZbunbQcDw==
X-Received: by 2002:a2e:80d7:0:b0:25e:7277:f184 with SMTP id r23-20020a2e80d7000000b0025e7277f184mr6332259ljg.244.1660648725917;
        Tue, 16 Aug 2022 04:18:45 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ae:539c:1782:dd68:b0c1:c1a4? (d15l54g8c71znbtrbzt-4.rev.dnainternet.fi. [2001:14bb:ae:539c:1782:dd68:b0c1:c1a4])
        by smtp.gmail.com with ESMTPSA id z23-20020a195057000000b0048b08f0c4e9sm1354663lfj.176.2022.08.16.04.18.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 04:18:45 -0700 (PDT)
Message-ID: <eb0670b6-794a-7a13-1264-0a789a47a8b4@linaro.org>
Date:   Tue, 16 Aug 2022 14:18:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/2] dt-bindings: vertexcom-mse102x: Update email address
Content-Language: en-US
To:     Stefan Wahren <stefan.wahren@i2se.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        stefan.wahren@chargebyte.com
References: <20220815080626.9688-1-stefan.wahren@i2se.com>
 <dc0c6c80-7af0-ee7c-2019-cdb6eb96c3f5@linaro.org>
 <6b3bfb9d-1acf-8445-7181-d5e1ecf4745d@i2se.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <6b3bfb9d-1acf-8445-7181-d5e1ecf4745d@i2se.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/08/2022 14:14, Stefan Wahren wrote:
> Hi Krzystof,
> 
> Am 16.08.22 um 12:24 schrieb Krzysztof Kozlowski:
>> On 15/08/2022 11:06, Stefan Wahren wrote:
>>> in-tech smart charging is now chargebyte. So update the email address
>>> accordingly.
>>>
>>> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
>> Yet you used third email address... which is fine, just a bit confusing.
>> Since in-tech.com still works and you might be (or not) different
>> Stefan, it's difficult to judge...
> 
> sorry about the confusion. I'm that person. Unfortuntely the other 
> accounts are using a M$ Exchange server, so i switched to the i2se 
> account for this setup before sending broken patches ...
> 
> in-tech was the parent company, but the accounts will unavailable in the 
> future.

Email used for authorship and for sending can be different. It makes
things more obvious.


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
