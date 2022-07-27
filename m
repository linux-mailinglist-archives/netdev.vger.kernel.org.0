Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A6A582225
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 10:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiG0I35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 04:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiG0I34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 04:29:56 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F8945067;
        Wed, 27 Jul 2022 01:29:55 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id os14so30272224ejb.4;
        Wed, 27 Jul 2022 01:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=90LqK0tDYlhW8mw1jbLiJzHeD5M9TR6TiTXrmORdnOs=;
        b=okISiEP+PtJfYiUEirmWFvT+EiyVBemKOhG0cra6EYc8SxjT6Ld3XWVhGH6wE3YjPL
         //MTk2EVguBKcVkcycxLcPMH61oynJ0HMIwEbw0TsEil4E2v4xOfS59ZE6gdsjL4P8Z6
         XaGofnStM4r5xp6TDYrpSsVACdx2sqU764VOWnhoaSiSKWpbTKioQvXAgx9Ck2iGuQa/
         80ARrTVPno0j3cJGGOeRyhoDc0wegUJO0o/dhdTOLjLjO5yjeoUKTj+rIXnXfJ8uRhqM
         /8TlWcua1ktW5LHvMoIXoYaxsHieUoGt6ZuBa3Le7S3E72k6iaYaa73r+U6c+JVoD6VI
         hfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=90LqK0tDYlhW8mw1jbLiJzHeD5M9TR6TiTXrmORdnOs=;
        b=HfFz6eWNGQjeA7QK57Rxoa9JTZrgQmhriuz8+EFWYkFC5eUH0TrdrW9f8WS1rMNPaL
         whVqyFMSX6tZbztm5Z18++Xt1o5BlmxHVXffwiMl49CyGGh2d2hlTpqxZdPJ28eHz4g+
         adGuQVOeFUprnBAcQNzlLsKB01fSDhQAqSNQTPjkN+EN4g7MF5Q46LDIVzx0fhLrx6Ol
         XZODk8UcjptNMVecUs2bNFc+Ut8UXJxVhf0vsp6+N6fgKkKTMHw+DgtPsuhPh3hkZMay
         lQm10jMOF8KS5yCr4nYfBh20x97PN1/Vilq6TiX6q8UDln+TVvzjgctVjy4o0xzvmzjs
         ASiw==
X-Gm-Message-State: AJIora8sohxfAazqlcmcMWVOzaGa83yHDEHpTKj6RDkPtB+sq1+jV8MF
        aXzR99+ZRtQqB3ZP9IoVVTc=
X-Google-Smtp-Source: AGRyM1sNTzVUPxdy7HWTJlsYBjJH63nKjJstW2gmAH/G15DWwbey+3gZVLzL1sYPMK+Wgys7gik6iA==
X-Received: by 2002:a17:906:5d04:b0:722:f46c:b891 with SMTP id g4-20020a1709065d0400b00722f46cb891mr17290342ejt.4.1658910593479;
        Wed, 27 Jul 2022 01:29:53 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:994d:5eac:a62d:7a76? ([2a04:241e:502:a09c:994d:5eac:a62d:7a76])
        by smtp.gmail.com with ESMTPSA id u2-20020a1709061da200b0072f42ca2934sm7375578ejh.148.2022.07.27.01.29.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 01:29:53 -0700 (PDT)
Message-ID: <dd2ca85e-ab29-2973-f129-9afafb405851@gmail.com>
Date:   Wed, 27 Jul 2022 11:29:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Leonard Crestez <cdleonard@gmail.com>
Subject: Re: [PATCH v6 21/26] selftests: net/fcnal: Initial tcp_authopt
 support
To:     Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
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
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <cover.1658815925.git.cdleonard@gmail.com>
 <ad19d5c8a24054d48e1c35bb0ec92075b9f0dc6a.1658815925.git.cdleonard@gmail.com>
 <CANn89i+ByJsdKLXi982jq0H3irYg_ANSEdmL2zwZ_7G-E_g2eg@mail.gmail.com>
 <CANn89i+=LVDFx_zjDy6uK+QorR+fosdkb8jqNMO6syqOsS7ZqQ@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CANn89i+=LVDFx_zjDy6uK+QorR+fosdkb8jqNMO6syqOsS7ZqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/26/22 10:27, Eric Dumazet wrote:
> On Tue, Jul 26, 2022 at 9:06 AM Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Tue, Jul 26, 2022 at 8:16 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>>>
>>> Tests are mostly copied from tcp_md5 with minor changes.
>>>
>>> It covers VRF support but only based on binding multiple servers: not
>>> multiple keys bound to different interfaces.
>>>
>>> Also add a specific -t tcp_authopt to run only these tests specifically.
>>>
>>
>> Thanks for the test.
>>
>> Could you amend the existing TCP MD5 test to make sure dual sockets
>> mode is working ?
>>
>> Apparently, if we have a dual stack listener socket (AF_INET6),
>> correct incoming IPV4 SYNs are dropped.

>>   If this is the case, fixing MD5 should happen first ;

I remember looking into this and my conclusion was that ipv4-mapped-ipv6 
is not worth supporting for AO, at least not in the initial version.

Instead I just wrote a test to check that ipv4-mapped-ipv6 fails for AO:
https://github.com/cdleonard/tcp-authopt-test/blob/main/tcp_authopt_test/test_verify_capture.py#L191

On a closer look it does appear that support existed for 
ipv4-mapped-ipv6 in TCP-MD5 but my test didn't actually exercise it 
correctly so the test had to be fixed.


Do you think it makes sense to add support for ipv4-mapped-ipv6 for AO? 
It's not particularly difficult to test, it was skipped due to a lack of 
application use case and to keep the initial series smaller.

Adding support for this later as a separate commit should be fine. Since 
ivp4-mapped-ipv6 addresses shouldn't appear on the wire giving them 
special treatment "later" should raise no compatibility concerns.


>> I think that we are very late in the cycle (linux-5.19 should be
>> released in 5 days), and your patch set should not be merged so late.

This was posted in order to get code reviews, I'm not actually expecting 
inclusion.

--
Regards,
Leonard
