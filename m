Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133B73F7AB7
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242059AbhHYQge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbhHYQgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:36:32 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93E7C061757;
        Wed, 25 Aug 2021 09:35:45 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id i21so11569079ejd.2;
        Wed, 25 Aug 2021 09:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oB+gyP5iMcMqw9Ky0nyzgG868F6WdIo6LMQb39S8Z9E=;
        b=pudzFZzN9DKM6ytg4NKy0f7hjl6/BWg5HXWlsO2fZUjza2apr4vizt7h5MT/E6vUZk
         XDp4IjT5hvwnoG1PttePRIQJbpMurFX1Rsoqt7+ONvC+Xge8TneYzitJ2f7xfyvZ3XO+
         bRbq9Vm5u6OoAVXFUQIy2HHpDGlgTOY/yyTE/ibtSSoUTSpKyUxCq47Tkg5kpC165NtZ
         I3G7toluQm55HSD8EVFbja4ax8qY/9nzGXtPzuWrC3dolsFM75bQBMI3FtqJg6DPZtdx
         yD4DL7mVxn4L/3CP4BR6Ql44ZyJVh6UTRi5F48+jkuYLjrgvK9UgqGp439+k0dA/Zv1N
         SaAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oB+gyP5iMcMqw9Ky0nyzgG868F6WdIo6LMQb39S8Z9E=;
        b=LOfDfS/1iJK+dm7Q6tTEmumDnqp7zBxdC3PPFpm5eFwi4HgKe2SRO6p5vaElOyxWqc
         E356rI2suiE3dHtwt7Hz3mWYpuYdzyyGaOHFn8kRDaGldnXZXqRsQ7NPOVJ3ug945YvN
         L59EmXcEjUYA3ZKrvB4hnM0Qx4vbyiShS63l9Uc6TKbkxP921OxfLgK2q6/TGp/iKf8w
         HwTI0/p/EFSXB5T0CAvbrfBcgbVPDPdV3pY4XNJMuEg+xX+tlZmue5VxEf+jT23ZXGwP
         2CsH6CGeJMmj6ye+PNbHeVwoHB9vEcVaATWG/MfDEsBV1qsarGmE2M/+7ZbE4gojgL+8
         3yEA==
X-Gm-Message-State: AOAM531UTfHIC21nBF2pfNIWGZc8oyLZD2/2SuwnkTI3Fl9R7jUy/OW3
        qAiFKWPkfrsWhkiktJXy3wA=
X-Google-Smtp-Source: ABdhPJyrX1Bh3v6ARE48EfSRHa7EneDL31j+w/IPXjowHQFGs88jW8HA8j2zkqr41Ao/ivOXg5fsjw==
X-Received: by 2002:a17:906:114c:: with SMTP id i12mr10962653eja.207.1629909344442;
        Wed, 25 Aug 2021 09:35:44 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:f02c:a1bd:70b1:fe95? ([2a04:241e:502:1d80:f02c:a1bd:70b1:fe95])
        by smtp.gmail.com with ESMTPSA id o3sm72797eju.123.2021.08.25.09.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 09:35:43 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
Subject: Re: [RFCv3 05/15] tcp: authopt: Add crypto initialization
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>
References: <cover.1629840814.git.cdleonard@gmail.com>
 <abb720b34b9eef1cc52ef68017334e27a2af83c6.1629840814.git.cdleonard@gmail.com>
 <30f73293-ea03-d18f-d923-0cf499d4b208@gmail.com>
Message-ID: <27e56f61-3267-de50-0d49-5fcfc59af93c@gmail.com>
Date:   Wed, 25 Aug 2021 19:35:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <30f73293-ea03-d18f-d923-0cf499d4b208@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.08.2021 02:34, Eric Dumazet wrote:
> On 8/24/21 2:34 PM, Leonard Crestez wrote:
>> The crypto_shash API is used in order to compute packet signatures. The
>> API comes with several unfortunate limitations:
>>
>> 1) Allocating a crypto_shash can sleep and must be done in user context.
>> 2) Packet signatures must be computed in softirq context
>> 3) Packet signatures use dynamic "traffic keys" which require exclusive
>> access to crypto_shash for crypto_setkey.
>>
>> The solution is to allocate one crypto_shash for each possible cpu for
>> each algorithm at setsockopt time. The per-cpu tfm is then borrowed from
>> softirq context, signatures are computed and the tfm is returned.
>>
> 
> I could not see the per-cpu stuff that you mention in the changelog.

That's a little embarrasing, I forgot to implement the actual per-cpu 
stuff. tcp_authopt_alg_imp.tfm is meant to be an array up to NR_CPUS and 
tcp_authopt_alg_get_tfm needs no locking other than preempt_disable 
(which should already be the case).

The reference counting would still only happen from very few places: 
setsockopt, close and openreq. This would only impact request/response 
traffic and relatively little.

Performance was not a major focus so far. Preventing impact on non-AO 
connections is important but typical AO usecases are long-lived 
low-traffic connections.

--
Regards,
Leonard
