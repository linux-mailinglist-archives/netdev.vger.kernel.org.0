Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5CB444ACD
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 23:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhKCWVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 18:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhKCWVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 18:21:43 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A8DC061714;
        Wed,  3 Nov 2021 15:19:06 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id r4so14053003edi.5;
        Wed, 03 Nov 2021 15:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iN+fjjjE8vfKjzIBRU3snyLmptIrvKiwZXEyF/BTJnw=;
        b=ax33eDurqbRoL9UjcGlbrlGR8fopzR4Ls4sBXY5QqgvahEAnZS4gohngzmi+qqKrkq
         5ucrry5sbSAfNL0OEAM7VW9A1FfPlVpgPBvZpvInz7RQtySSvFBBb+McaLn6sxrmUltv
         tSlqGpXkApuE3iZq//IEq/Dplyu/2JoJlA5/qblQev1at7q90lP3GN04mQRdJVOLng3i
         FbV4DZWsD1uVZcVCdxPHXzxRs88Y8LdI/eW9hUiaPGtlILjkvv0Eb3LG1hh+2NDy5rpB
         IZKZWzdbrtTLw3tTwoZnZspCJoGRebGAbD4Wyn6TameJxFTMMGR+PpUrSq+vjeDUHIFh
         84xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iN+fjjjE8vfKjzIBRU3snyLmptIrvKiwZXEyF/BTJnw=;
        b=jW9S2R2QxJgGZQqZNa9NU3Knsn5R4QydDPe9uYQG35q/T9XxxdaT5VAix+HVT9eJ9N
         JKGWFD86jt3E/1c9bIhqVzqOCYh2gmmDc7LoFVq0Yriwjvq4t3LmWsnQPtt81yuv5RmF
         lOH27ucucbJyLn03T0CInJ68xQNg85BmL1C4rovsQ2LPl85ZAhTOMlb+8UXioyvRsMGc
         UE82KZfzzZjWqXeSn9ePltQx+g+BACn7C3ARkh1B7JJrcuh9lVC8kI/4I3JI1KXG8frn
         NGnBwSZyZS+gmr4nZmvDNNOwmbO2coK3qwLodEaU1lka+Ei2sLmEgg3Fl0GVRohj12pC
         D/Mg==
X-Gm-Message-State: AOAM530UmARiMU18VmkeEB71arovXdUdg0G3/bJ/v9VeeVncsTQyW95Y
        a+yzuNTgcFrHCLEBdyVSOmU=
X-Google-Smtp-Source: ABdhPJymCRkGj29o6X4rs34L4JYjl2N6jdyeOvhAAxYeQrmw34HklIKuSjbW01YvXpz1LWEQWtH9Bw==
X-Received: by 2002:a50:fb15:: with SMTP id d21mr56598633edq.85.1635977944889;
        Wed, 03 Nov 2021 15:19:04 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3800:dd98:1fb5:16b3:cb28? ([2a04:241e:501:3800:dd98:1fb5:16b3:cb28])
        by smtp.gmail.com with ESMTPSA id e13sm1694067eje.95.2021.11.03.15.19.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 15:19:04 -0700 (PDT)
Subject: Re: [PATCH v2 07/25] tcp: Use BIT() for OPTION_* constants
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
 <dc9dca0006fa1b586da44dcd54e29eb4300fe773.1635784253.git.cdleonard@gmail.com>
 <79ab8aae-8a61-b279-a702-15f24b406044@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <6f07bab3-0c6f-84a6-870a-0f5e68a746f4@gmail.com>
Date:   Thu, 4 Nov 2021 00:19:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <79ab8aae-8a61-b279-a702-15f24b406044@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/21 4:31 AM, David Ahern wrote:
> On 11/1/21 10:34 AM, Leonard Crestez wrote:
>> Extending these flags using the existing (1 << x) pattern triggers
>> complaints from checkpatch.
>>
>> Instead of ignoring checkpatch modify the existing values to use BIT(x)
>> style in a separate commit.
>>
>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>> ---
>>   net/ipv4/tcp_output.c | 14 +++++++-------
>>   1 file changed, 7 insertions(+), 7 deletions(-)
>>
> 
> This one could be sent outside of this patch set since you are not
> adding new values. Patch sets > 20 are generally frowned upon; sending
> this one separately helps get the number down.

In the past I've seen maintainers pick small cleanups and fixes from 
longer series that otherwise need further discussion.

Not sure if this practice is also common for netdev so I posted this 
patch separately.

--
Regards,
Leonard
