Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0287444AD5
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 23:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhKCWZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 18:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhKCWZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 18:25:29 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8915C061714;
        Wed,  3 Nov 2021 15:22:52 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id f8so14723073edy.4;
        Wed, 03 Nov 2021 15:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J2NdaQ8T+dt9p0jHQsB0InvqWOp8/QEv69XWnnosGBY=;
        b=GzUMX9Jd1JqRALeydvQkd1EteV+LGofdP3599Qk4mjqzSesoDGjQdQcKoqGFR4aoDk
         JsSLfMQxKvkEfaa+V4djLBHJg7gcSyqFtQvkkMJEbH9MofIg56bjXxLf+Vbfyf6NuNdZ
         efy9VFnCdyjcQmueGYDvJv5cL8JcrhSDLQls9ycfzplAA8GWc8BwHVEAqTfPJQkWi5Ov
         41UH+Cfvqw8ipreeDS/0Lo/dbZJuIAK2WVBsv7ekD1Rfdf/uNBVLkKM3v/YbFoTyqxWw
         UwIxMgDH50zWAm2SzdskqS58ZW6oBLOos6zQQG4FhNXgtAMqfWXQXyuOg0AszvkWxh7i
         Tr6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J2NdaQ8T+dt9p0jHQsB0InvqWOp8/QEv69XWnnosGBY=;
        b=yLj5H2Hk3FYmZ6a7Uta8ESfZ8EROBMuEhyp5ZT0kcyu1zudciX2HaTV5WrD4DL7bZO
         ddxzjLUnZxrYCifmjsGOCGsUlvj/PmOf7QgprAdWjPdfrEDlldsmlP2SQB7wz8UHuaJd
         R3bTuyVoBGKF5MQLP0Iqc8RGvKIsZ/qRP6JGfh2D8CzNy8VDCNU9B0lakmsgqYaf1EfZ
         //NgvSKqcGEexR1HYNmewfUuzzvxJkX1LeukCqr+hm3ed00zjmaXtsck4A/gTvHbwaBK
         YZ4LrgGhkdM91CAi8tNs+ZFsIQ1ilsujJy+Gscv+e6z3dw448k4iPnntJ6ysOEgHh6db
         It8Q==
X-Gm-Message-State: AOAM532wfw64ASo5iuz5H+QuXBYwaV4fzH5BxuAfadyurH7wKcjae6fn
        LPnJ3/QaYQxTrkC9cwS54SKGJ/JOz91Tpg==
X-Google-Smtp-Source: ABdhPJzV4/y5qTs4xQPrAXlnayDNX8Mrj7BkhVqpL8WzEHl/VS/hgdFLOpFJr0DwVrlp/gonwlrvsA==
X-Received: by 2002:a17:907:1c85:: with SMTP id nb5mr23550781ejc.502.1635978171338;
        Wed, 03 Nov 2021 15:22:51 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3800:dd98:1fb5:16b3:cb28? ([2a04:241e:501:3800:dd98:1fb5:16b3:cb28])
        by smtp.gmail.com with ESMTPSA id p23sm2064759edw.94.2021.11.03.15.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 15:22:50 -0700 (PDT)
Subject: Re: [PATCH v2] tcp: Initial support for RFC5925 auth option
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
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
        linux-kernel@vger.kernel.org
References: <cover.1635784253.git.cdleonard@gmail.com>
 <832e6d49-8490-ab8b-479b-0420596d0aaa@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <9bcd27f0-e14e-ab89-88a4-f6cf6b4323b4@gmail.com>
Date:   Thu, 4 Nov 2021 00:22:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <832e6d49-8490-ab8b-479b-0420596d0aaa@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/21 5:18 AM, David Ahern wrote:
> On 11/1/21 10:34 AM, Leonard Crestez wrote:
>> This is similar to TCP MD5 in functionality but it's sufficiently
>> different that wire formats are incompatible. Compared to TCP-MD5 more
>> algorithms are supported and multiple keys can be used on the same
>> connection but there is still no negotiation mechanism.
>>
>> Expected use-case is protecting long-duration BGP/LDP connections
>> between routers using pre-shared keys. The goal of this series is to
>> allow routers using the linux TCP stack to interoperate with vendors
>> such as Cisco and Juniper.
>>
>> Both algorithms described in RFC5926 are implemented but the code is not
>> very easily extensible beyond that. In particular there are several code
>> paths making stack allocations based on RFC5926 maximum, those would
>> have to be increased.
>>
>> This version implements SNE and l3mdev awareness and adds more tests.
>> Here are some known flaws and limitations:
>>
>> * Interaction with TCP-MD5 not tested in all corners
>> * Interaction with FASTOPEN not tested and unlikely to work because
>> sequence number assumptions for syn/ack.
>> * Not clear if crypto_shash_setkey might sleep. If some implementation
>> do that then maybe they could be excluded through alloc flags.
>> * Traffic key is not cached (reducing performance)
>> * User is responsible for ensuring keys do not overlap.
>> * There is no useful way to list keys, making userspace debug difficult.
>> * There is no prefixlen support equivalent to md5. This is used in
>> some complex FRR configs.
>>
>> Test suite was added to tools/selftests/tcp_authopt. Tests are written
>> in python using pytest and scapy and check the API in some detail and
>> validate packet captures. Python code is already used in linux and in
>> kselftests but virtualenvs not very much, this particular test suite
>> uses `pip` to create a private virtualenv and hide dependencies.
>>
>> This actually forms the bulk of the series by raw line-count. Since
>> there is a lot of code it was mostly split on "functional area" so most
>> files are only affected by a single code. A lot of those tests are
>> relevant to TCP-MD5 so perhaps it might help to split into a separate
>> series?
>>
>> Some testing support is included in nettest and fcnal-test.sh, similar
>> to the current level of tcp-md5 testing.
>>
>> SNE was tested by creating connections in a loop until a large SEQ is
>> randomly selected and then making it rollover. The "connect in a loop"
>> step ran into timewait overflow and connection failure on port reuse.
>> After spending some time on this issue and my conclusion is that AO
>> makes it impossible to kill remainders of old connections in a manner
>> similar to unsigned or md5sig, this is because signatures are dependent
>> on ISNs.  This means that if a timewait socket is closed improperly then
>> information required to RST the peer is lost.
>>
>> The fact that AO completely breaks all connection-less RSTs is
>> acknowledged in the RFC and the workaround of "respect timewait" seems
>> acceptable.
>>
>> Changes for frr (old): https://github.com/FRRouting/frr/pull/9442
>> That PR was made early for ABI feedback, it has many issues.
>>
> 
> overall looks ok to me. I did not wade through the protocol details.
> 
> I did see the comment about no prefixlen support in the tests. A lot of
> patches to absorb, perhaps I missed it. Does AuthOpt support for
> prefixes? If not, you should consider adding that as a quick follow on
> (within the same dev cycle). MD5 added prefix support for scalability;
> seems like AO should be concerned about the same.

I just skipped it because it's not required for core functionality.

It's very straight forward so I will add it to the next version.

--
Regards,
Leonard
