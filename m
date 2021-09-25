Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D766041828E
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 16:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343668AbhIYOQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 10:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbhIYOQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 10:16:30 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D47C061570;
        Sat, 25 Sep 2021 07:14:55 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id ee50so47968737edb.13;
        Sat, 25 Sep 2021 07:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hi5r/QTKc0hakYYPxOLmnUQF3xIEtGRWHl7PZ9tsfa4=;
        b=ikUsUlqEpAEVeeQr8KpV9A0k3XvxLReCSOUdzvuL7OFNhnoMCW0fS/heeVX++tm2Fj
         brF+FOgZdoHFcuHMCSXyDvtr67eA4uS+dsEschaOGJoxB6B02uXdMuqJdGOLMRGVxJU7
         TnGK9Qs7FOVNDiU20Iim1oNxuMnj+OXttG3ZqpXXnG7elhu6vGz/Au4DAw9TcOd8Vv1s
         eFc6w68nXOTpZfkBPAEUT1jot4nJW6OLJo9jAOThhBqHjdAe2uGfi5JBCG8e6f2UToMN
         CSk3oSOvNIrfks3NLTSLOUSO0qPCQNSDWV6lwWc76oGn3cXpl4uwKjhsdUqzaxdltq7t
         EWBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hi5r/QTKc0hakYYPxOLmnUQF3xIEtGRWHl7PZ9tsfa4=;
        b=HyYjx2f5V9FgBh00ZdR78KAtyzuzneYMl/LHH89/seSCaQjgNk5RRKr2WBTYHPF20b
         YZd/qfRDfrIxrJLQ29MCyRD3ZfVa2tWuTo1gpNFm6ot3qS7UqNTUUgZBeMEcYeaXWwoQ
         8ZiheWx9uAgj3urW9o/rmLiy0BNihvZ15n17TmP9frXBfYBmcYAglXwEgj123kqftkGa
         mWFRhkNBPKaq1kBzCXbbdE9NfLbq1+yRd6nbzD38gyNFFKdwv6HwJTaNIowfljuELTNy
         5iRVilf+eiawGHU9FQDQ+M+c59eHu2AgcMFWQ90+5rMO2ASYWDeFKjMM0oL+wSG9z7PK
         2QQQ==
X-Gm-Message-State: AOAM532Eud2LAsk1GzmLE87kjMw3HZPBH0fDmE6xT2jgE+AMVQvO0Yp0
        ruieUebJweEK0my1f4oskb1XDyXtRS/rhDWLSwk=
X-Google-Smtp-Source: ABdhPJyw95qtw/Li2PyMyMyWxpjzmlZNuzkRi9jH/UEyb7cWbwy6LipocE7q899bLht3ndlmaN6Npg==
X-Received: by 2002:a17:906:32c9:: with SMTP id k9mr17484811ejk.218.1632579293736;
        Sat, 25 Sep 2021 07:14:53 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3800:55c:dc9d:9cc1:2c16? ([2a04:241e:501:3800:55c:dc9d:9cc1:2c16])
        by smtp.gmail.com with ESMTPSA id e11sm6297928ejm.41.2021.09.25.07.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 07:14:53 -0700 (PDT)
Subject: Re: [PATCH 08/19] tcp: authopt: Disable via sysctl by default
To:     David Ahern <dsahern@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
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
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1632240523.git.cdleonard@gmail.com>
 <b0abf2b789220708011a862a892c37b0fd76dc25.1632240523.git.cdleonard@gmail.com>
 <cafecbeb-7d4d-489c-177d-29fff78eb4d1@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <65ed79e3-bef1-19c4-ac1d-9d6833236a1c@gmail.com>
Date:   Sat, 25 Sep 2021 17:14:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <cafecbeb-7d4d-489c-177d-29fff78eb4d1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/21 4:57 AM, David Ahern wrote:
> On 9/21/21 10:14 AM, Leonard Crestez wrote:
>> This is mainly intended to protect against local privilege escalations
>> through a rarely used feature so it is deliberately not namespaced.
>>
>> Enforcement is only at the setsockopt level, this should be enough to
>> ensure that the tcp_authopt_needed static key never turns on.
>>
>> No effort is made to handle disabling when the feature is already in
>> use.
>>
> 
> MD5 does not require a sysctl to use it, so why should this auth mechanism?

I think it would make sense for both these features to be off by 
default. They interact with TCP in complex ways and are available to all 
unprivileged users but their real usecases are actually very limited.

Having to flip a few sysctls is very reasonable in the context of 
setting up a router.

My concern is that this feature ends up in distro kernels and somebody 
finds a way to use it for privilege escalation.

It also seems reasonable for "experimental" features to be off by default.

--
Regards,
Leonard
