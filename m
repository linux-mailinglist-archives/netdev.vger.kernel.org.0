Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBBA44635B
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 13:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhKEM3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 08:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhKEM3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 08:29:41 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1527CC061714;
        Fri,  5 Nov 2021 05:27:02 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w1so32727693edd.10;
        Fri, 05 Nov 2021 05:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VWnwoguiS8Ek3wXdinAoUlLWrPmI0p9qcxlIOqqvuf4=;
        b=WQTtiepPdxr+1qL1KOH7sLyVAHlZ4keVF2ROBKBaalj+LYa8+kUcsWY8b+ZnFEaseG
         ROTVJpXjPrRSfBHrfQcX+6W9DZFhS4teSACoXplshotQffNKW3wxCaE3eOS4eKHrDfoH
         LvjsMuvNbJSbaYKvsQehN/eRQnBheZjA8ncbrmpO+f2kSDuPmKcI3AnfXAzWWkUuKVAN
         mnj/RAbhMPbLwZxPJCiNnyCPBsqM6u/cq6Jtd5OT+efqhTJCggfYSwD97E9iyabfdMeI
         XbuAdP0tII+p9J/1g5aJ/Wm7RastZAQjeP+g7JGMkaGbeHClk+k3jXZSglBN/Q8a8zKi
         t5ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VWnwoguiS8Ek3wXdinAoUlLWrPmI0p9qcxlIOqqvuf4=;
        b=ofsJbqap6nPjPHdhkU1+LI37jk2ZMIDJc6bnk28tjLwImWqnF0ITJ942mrsqJKV7X4
         KiN6CGOtRdqQs2RRcdLMqDpZHu/mmywbcCRL1CqpPf7Us3Ovj/FnIoSrQuSTn3uBOepM
         cuOcdfETP23HEUUMIpBiUNqIpwiHYmLF/XFphBuvxmP3Nn4PennpXOq14wJ4gC0ZataE
         /wnh1mbdQ1oAjCsYGIz/1mb1e3G1dQ57xriepbvE6a4coWzdmCgh0KQ8Twibh4AhnsBy
         s+A/vq9mlqwBb8gYSUTFSs1oPIYIJuO3j+8jhOb/rVavvO/0h5Vmzm+gyxCcS393MsMw
         4Rew==
X-Gm-Message-State: AOAM531VLBTQQ622Qs4TUGYL7/ijQoCxiS0sCuFPxYPQlk7MztzITLUH
        Q4tB+1ZXPxOCyNIP/suFRvaKkRC29GZn0w==
X-Google-Smtp-Source: ABdhPJy1p4mx96iQlG4iPSiOJ8nL03P+wrgU9AOxqAdkTOF/0WQLNezrp9b8Abnn76W3ALi6elQrTQ==
X-Received: by 2002:a17:906:d541:: with SMTP id cr1mr74734988ejc.81.1636115220681;
        Fri, 05 Nov 2021 05:27:00 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:9439:4202:183c:5296? ([2a04:241e:501:3870:9439:4202:183c:5296])
        by smtp.gmail.com with ESMTPSA id oz13sm4081898ejc.65.2021.11.05.05.26.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 05:27:00 -0700 (PDT)
Subject: Re: [PATCH v2 21/25] tcp: authopt: Add initial l3index support
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
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
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1635784253.git.cdleonard@gmail.com>
 <4e049d1ade4be3010b4ea63daf2ef3bed4e1892b.1635784253.git.cdleonard@gmail.com>
 <e08a7554-bd3e-e524-830d-64b76853ace2@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <320b8801-1f35-a283-be11-a4f4275847d2@gmail.com>
Date:   Fri, 5 Nov 2021 14:26:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e08a7554-bd3e-e524-830d-64b76853ace2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/21 5:06 AM, David Ahern wrote:
> On 11/1/21 10:34 AM, Leonard Crestez wrote:
>> @@ -584,10 +614,24 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
>>   		return -EINVAL;
>>   	err = tcp_authopt_alg_require(alg);
>>   	if (err)
>>   		return err;
>>   
>> +	/* check ifindex is valid (zero is always valid) */
>> +	if (opt.flags & TCP_AUTHOPT_KEY_IFINDEX && opt.ifindex) {
>> +		struct net_device *dev;
>> +
>> +		rcu_read_lock();
>> +		dev = dev_get_by_index_rcu(sock_net(sk), opt.ifindex);
>> +		if (dev && netif_is_l3_master(dev))
>> +			l3index = dev->ifindex;
>> +		rcu_read_unlock();
> 
> rcu_read_lock()... rcu_read_unlock() can be replaced with
> netif_index_is_l3_master(...)

Yes, this makes the code shorter.
