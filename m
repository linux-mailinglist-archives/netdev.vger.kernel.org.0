Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FF83F7AC8
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241823AbhHYQie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhHYQid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:38:33 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1880C061757;
        Wed, 25 Aug 2021 09:37:47 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u3so52876744ejz.1;
        Wed, 25 Aug 2021 09:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1K9N5MpNmrjGAXxPDH6ASnSz5pQKTpuvkicsC84kSJQ=;
        b=g/6iBX5tJrRFfNspQP63D4yGRv27vOeGfOWrFoh+KDZaMsWO0TvTgvongSC9frZPMO
         0CtMaRip+gjDHUzTiN3ED4VCKiE+eOXnZV0PADS8PaRFzZ+QLxOf9NIjno9KzEVSKFez
         tvl7toFz+9dqEoBa/m7i/UkYTK/ym0xJKg/WhpgyOiRy621xbdotMyQmxHhKQ0PoaWDm
         uM2ChNbe1qc3aORXJGlP2KlEz3DBsEcJ1hapEwuvxUepBtbYHb6d/OuIdMWWwS02+H4h
         qSTnj8gMKhZRHKjtNG0arkqYh9QiZ1QKOawTbq+TmJ0DSSwTqDOhgs0T+6tayOe30Nqh
         cApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1K9N5MpNmrjGAXxPDH6ASnSz5pQKTpuvkicsC84kSJQ=;
        b=fH+rmHKZx/FPyCVBunTA/24Lc5z5655vJdqZVjz/cLOdze8TZhH0ntKfiwMSrNamT4
         3iYLg4/c216eD9yWUJnBd1g6WiGE8Vavk9hk84MfSoYfi5dIcv1Kw3xrznqY8lA8sbXN
         iEH4qlyDw2zsgDn/IcwvBU319ViDK5PPIkn7RODtfN8hUy82fTzKUZdNAG/MqoEwE1vh
         lzm3J1cdsjhkYDDaywCbrD6fJvDUSZXxvI61A8XnKMfu264rWmr+H3sbgONX+GD//YYj
         yN1vbqYFaTyMAjBVUuSRyCfrSVXtzxgOD/tDo8w/sakShiwbR0tXZr4jMSYNeXA5iWtu
         veVA==
X-Gm-Message-State: AOAM532eOBJNYcjribeRIg7m05f4Tv33L2rw+bUs/aguQE9mlS7hYBMr
        yHhdAtDJxqfPUSRNoYqC5jr9jkNqt2p2DQ==
X-Google-Smtp-Source: ABdhPJxBhRXzymupWy8orO37b7pnDcCkM/RCtXtmKzhqthB7ffqi0rlr2wCJimXkY60VuPmETgJ4oQ==
X-Received: by 2002:a17:907:1b02:: with SMTP id mp2mr47492298ejc.196.1629909464473;
        Wed, 25 Aug 2021 09:37:44 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:f02c:a1bd:70b1:fe95? ([2a04:241e:502:1d80:f02c:a1bd:70b1:fe95])
        by smtp.gmail.com with ESMTPSA id u18sm78992ejf.118.2021.08.25.09.37.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 09:37:43 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
Subject: Re: [RFCv3 09/15] selftests: tcp_authopt: Test key address binding
To:     David Ahern <dsahern@gmail.com>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
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
References: <cover.1629840814.git.cdleonard@gmail.com>
 <09c7cff43f832d0aba8dfad67f56066aeeca8475.1629840814.git.cdleonard@gmail.com>
 <922fe343-c867-62ff-14b8-3d84ed2e1b76@gmail.com>
Message-ID: <bb3fe6a6-0995-c235-6b58-383481001ef3@gmail.com>
Date:   Wed, 25 Aug 2021 19:37:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <922fe343-c867-62ff-14b8-3d84ed2e1b76@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.08.2021 08:18, David Ahern wrote:
> On 8/24/21 2:34 PM, Leonard Crestez wrote:
>> By default TCP-AO keys apply to all possible peers but it's possible to
>> have different keys for different remote hosts.
>>
>> This patch adds initial tests for the behavior behind the
>> TCP_AUTHOPT_KEY_BIND_ADDR flag. Server rejection is tested via client
>> timeout so this can be slightly slow.
>>
>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>> ---
>>   .../tcp_authopt_test/netns_fixture.py         |  63 +++++++
>>   .../tcp_authopt/tcp_authopt_test/server.py    |  82 ++++++++++
>>   .../tcp_authopt/tcp_authopt_test/test_bind.py | 143 ++++++++++++++++
>>   .../tcp_authopt/tcp_authopt_test/utils.py     | 154 ++++++++++++++++++
>>   4 files changed, 442 insertions(+)
>>   create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/netns_fixture.py
>>   create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/server.py
>>   create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_bind.py
>>   create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/utils.py
>>
> 
> This should be under selftests/net as a single "tcp_authopt" directory
> from what I can tell.

Maybe? I found no clear guidelines for organizing tests by subsystem. I 
just did a grep for .py in selftests and placed mine next to tc-testing.

Having a tcp_authopt_test code directory under tcp_authopt is the 
standard pattern for python packages, otherwise all submodules with 
utilities of dubious generality are dumped at the global level. Removing 
the tcp_authopt/tcp_authopt_test structure is awkward in python.

One way to deal with this is to add my test code in 
tools/testing/selftests/net/tcp_authopt and my setup.cfg and similar 
directly in tools/testing/selftests/net. This would make "net" the root 
of the package and make it easy to add other networking pytests. This 
seems close to what you mean.

kselftest itself does not seem to offer any special support for python 
code, only some for C and shell. Maybe it could offer a "kselftest" 
package with common utilities that are used by multiple test packages 
and everything would be installed into a single virtualenv by makefiles.

--
Regards,
Leonard
