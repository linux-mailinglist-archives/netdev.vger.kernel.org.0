Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACE85AF115
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbiIFQto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiIFQtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:49:22 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449FE17ABC
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 09:34:50 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k9so16336077wri.0
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 09:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=UMK536Buc3tyACpoqD9UkBRLk6CrV6AwT1m3G1iH3lY=;
        b=W79QCDBfsBZhY3udIZXglanrIDIK2Ag1acFspTBUuEF1/zduN20nn5hDx0oEbVDSMK
         D42ymkytni7ohKpgDiTTnfh0xZSCPowoGk/EGCUuXijnMyeFTOAeMw92RcCouQquFJKw
         m7ZbK5S8QyorES2/LX7nPUU7GThTaJERju5MWunPdatU9CiIKW6MSqIPKwI43A9n5ONc
         MG7PgczvAiv7WsYVx65gS5Y8wVJNMHgcuFnkofV6IxZt0WvuveZOE4Wr8MdVgZ2CpJTM
         LaRgUp+qTdp5OcCZhqfOJFvnSOAV0iqXj1d5dKPxEDdbG64E9NWwcaerpXj3iryPfoIp
         rRQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=UMK536Buc3tyACpoqD9UkBRLk6CrV6AwT1m3G1iH3lY=;
        b=OfIaajk0t0VCjyTDMmk0LmQPkk2qXWi3lutEkmoOp4k3YbdAdaXGCiwDaqF6NZxYiS
         8QV19R0IwNOiRUS8SpYeSFGW6z+dP3aKwdip5PykvyydGh07ibxDCxr0jY5mteUebyl/
         /+BCcm6NI4w8l+LJZ8Mh/AjYsvFa8xdub9eReTRwN40TdqA/CW8cnZUZHTt2zQtKiiTw
         ThryTmhjgI7KJErPm0ccdpTBNHXJqSP6Cpqgi9EXUwRCVH8SnQh6ajJpEgLTQDeJhW2C
         aQSTr0i+YTVKPTJF7dzGZwMszM0wxzzVM10QvUr/F2qEuvJpbdnzGhDtVb11o+LTbsB1
         mQYg==
X-Gm-Message-State: ACgBeo1z1f14g+j0TI0YuM+lfarqxRGccJ0z4G30bJ4xSFd0wgiGgHzY
        ppKLvirlhdoaS/BuxAhXdHP6rg==
X-Google-Smtp-Source: AA6agR6+rkMERc3iXtzDpZ+FTje+AOXKMpuCsOvyq1Fd9KZABhY8d5Qu2LPDFxvU6PJAtNvmf5WUtw==
X-Received: by 2002:a05:6000:1549:b0:225:652e:45d4 with SMTP id 9-20020a056000154900b00225652e45d4mr28679809wry.15.1662482089343;
        Tue, 06 Sep 2022 09:34:49 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n5-20020a05600c304500b003a5de95b105sm20477031wmh.41.2022.09.06.09.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 09:34:48 -0700 (PDT)
Message-ID: <8fb27342-2b32-b0e7-09d9-622ce16e8e76@arista.com>
Date:   Tue, 6 Sep 2022 17:34:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 25/31] selftests/net: Add TCP-AO library
Content-Language: en-US
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20220818170005.747015-1-dima@arista.com>
 <20220818170005.747015-26-dima@arista.com>
 <aa0143bc-b0d1-69fb-c117-1e7241f0ad89@linuxfoundation.org>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <aa0143bc-b0d1-69fb-c117-1e7241f0ad89@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/22 16:47, Shuah Khan wrote:
> On 8/18/22 10:59 AM, Dmitry Safonov wrote:
[..]
>> +
>> +__attribute__((__format__(__printf__, 2, 3)))
>> +static inline void __test_print(void (*fn)(const char *), const char
>> *fmt, ...)
>> +{
>> +#define TEST_MSG_BUFFER_SIZE 4096
>> +    char buf[TEST_MSG_BUFFER_SIZE];
>> +    va_list arg;
>> +
>> +    va_start(arg, fmt);
>> +    vsnprintf(buf, sizeof(buf), fmt, arg);
>> +    va_end(arg);
>> +    fn(buf);
>> +}
>> +
> 
> Is there a reason add these instead of using kselftest_* print
> functions?

Inside __test_ok(), __test_msg(), __test_fail() and __test_error() are
calling ksft_*() functions. kselftest_*() by themselves are not
thread-safe and I was not sure if you would want them to be.

> 
>> +#define test_print(fmt, ...)                        \
>> +    __test_print(__test_msg, "%ld[%s:%u] " fmt "\n",        \
>> +             syscall(SYS_gettid),                \
>> +             __FILE__, __LINE__, ##__VA_ARGS__)
>> +
>> +#define test_ok(fmt, ...)                        \
>> +    __test_print(__test_ok, fmt "\n", ##__VA_ARGS__)
>> +
>> +#define test_fail(fmt, ...)                        \
>> +do {                                    \
>> +    if (errno)                            \
>> +        __test_print(__test_fail, fmt ": %m\n", ##__VA_ARGS__);    \
>> +    else                                \
>> +        __test_print(__test_fail, fmt "\n", ##__VA_ARGS__);    \
>> +    test_failed();                            \
>> +} while(0)
>> +
>> +#define KSFT_FAIL  1
>> +#define test_error(fmt, ...)                        \
>> +do {                                    \
>> +    if (errno)                            \
>> +        __test_print(__test_error, "%ld[%s:%u] " fmt ": %m\n",    \
>> +                 syscall(SYS_gettid), __FILE__, __LINE__,    \
>> +                 ##__VA_ARGS__);                \
>> +    else                                \
>> +        __test_print(__test_error, "%ld[%s:%u] " fmt "\n",    \
>> +                 syscall(SYS_gettid), __FILE__, __LINE__,    \
>> +                 ##__VA_ARGS__);                \
>> +    exit(KSFT_FAIL);                        \
>> +} while(0)
>> +
> 
> Is there a reason add these instead of using kselftest_* print
> functions?

The same reason: two or more threads my fail the test at the same
moment, I needed some way of protecting the output.

>> + * Timeout on syscalls where failure is not expected.
>> + * You may want to rise it if the test machine is very busy.
>> + */
>> +#ifndef TEST_TIMEOUT_SEC
>> +#define TEST_TIMEOUT_SEC    5
>> +#endif
>> +
> 
> Where is the TEST_TIMEOUT_SEC usually defined? Does this come
> from shell wrapper that runs this test? Can we add a message before
> starting the test print the timeout used?

Usually it's not re-defined and used as-is. Ifndef here is only to make
it easier to recompile with another timeout const: one can just add
CFLAGS+=-DTEST_TIMEOUT_SEC=10 and check if that helps on the busy hardware.


>> +/*
>> + * Timeout on connect() where a failure is expected.
>> + * If set to 0 - kernel will try to retransmit SYN number of times,
>> set in
>> + * /proc/sys/net/ipv4/tcp_syn_retries
>> + * By default set to 1 to make tests pass faster on non-busy machine.
>> + */
>> +#ifndef TEST_RETRANSMIT_SEC
>> +#define TEST_RETRANSMIT_SEC    1
>> +#endif
>> +
> 
> Where would this TEST_RETRANSMIT_SEC defined usually?

The same: I always used the default value, but protected by ifndef if
one wants to increase the value.

>> +
>> +static inline int _test_connect_socket(int sk, const union tcp_addr
>> taddr,
>> +                    unsigned port, time_t timeout)
>> +{
>> +#ifdef IPV6_TEST
>> +    struct sockaddr_in6 addr = {
>> +        .sin6_family    = AF_INET6,
>> +        .sin6_port    = htons(port),
>> +        .sin6_addr    = taddr.a6,
>> +    };
>> +#else
>> +    struct sockaddr_in addr = {
>> +        .sin_family    = AF_INET,
>> +        .sin_port    = htons(port),
>> +        .sin_addr    = taddr.a4,
>> +    };
>> +#endif
> 
> Why do we defined these here - are they also defined in a kernel
> header?

No, those functions are helpers that process family-specific members.
IPV6_TEST is coming from Makefile:
$(OUTPUT)/%_ipv6: %.c
	$(LINK.c) -DIPV6_TEST $^ $(LDLIBS) -o $@

This way all tests can be compiled from the same code for both address
families, resulting in *_ipv4 and *_ipv6 binaries that reuse all the
code, but just have those #ifdef IPV6_TEST in places where test converts
or produces IP addresses.

[..]
>> +static inline int test_prepare_ao(struct tcp_ao *ao,
>> +        const char *alg, uint16_t flags,
>> +        union tcp_addr in_addr, uint8_t prefix,
>> +        uint8_t sndid, uint8_t rcvid, uint8_t maclen,
>> +        uint8_t keyflags, uint8_t keylen, const char *key)
>> +{
>> +#ifdef IPV6_TEST
>> +    struct sockaddr_in6 addr = {
>> +        .sin6_family    = AF_INET6,
>> +        .sin6_port    = 0,
>> +        .sin6_addr    = in_addr.a6,
>> +    };
>> +#else
>> +    struct sockaddr_in addr = {
>> +        .sin_family    = AF_INET,
>> +        .sin_port    = 0,
>> +        .sin_addr    = in_addr.a4,
>> +    };
>> +#endif
>> +
> 
> Same question here. In general having these ifdefs isn't ideal without
> a good reason.

Same as above.

> 
>> +    return test_prepare_ao_sockaddr(ao, alg, flags,
>> +            (void *)&addr, sizeof(addr), prefix, sndid, rcvid,
>> +            maclen, keyflags, keylen, key);
>> +}
>> +
>> +static inline int test_prepare_def_ao(struct tcp_ao *ao,
>> +        const char *key, uint16_t flags,
>> +        union tcp_addr in_addr, uint8_t prefix,
>> +        uint8_t sndid, uint8_t rcvid)
>> +{
>> +    if (prefix > DEFAULT_TEST_PREFIX)
>> +        prefix = DEFAULT_TEST_PREFIX;
>> +
>> +    return test_prepare_ao(ao, DEFAULT_TEST_ALGO, flags, in_addr,
>> +            prefix, sndid, rcvid, 0, 0, strlen(key), key);
>> +}
>> +
>> +extern int test_get_one_ao(int sk, struct tcp_ao_getsockopt *out,
>> +               uint16_t flags, void *addr, size_t addr_sz,
>> +               uint8_t prefix, uint8_t sndid, uint8_t rcvid);
>> +extern int test_cmp_getsockopt_setsockopt(const struct tcp_ao *a,
>> +                      const struct tcp_ao_getsockopt *b);
>> +
>> +static inline int test_verify_socket_ao(int sk, struct tcp_ao *ao)
>> +{
>> +    struct tcp_ao_getsockopt tmp;
>> +    int err;
>> +
>> +    err = test_get_one_ao(sk, &tmp, 0, &ao->tcpa_addr,
>> +            sizeof(ao->tcpa_addr), ao->tcpa_prefix,
>> +            ao->tcpa_sndid, ao->tcpa_rcvid);
>> +    if (err)
>> +        return err;
> 
> Is this always an error or could this a skip if dependencies aren't
> met to run the test? This is a global comment for all error cases.

Yeah, at this moment all tests will FAIL if CONFIG_TCP_AO is disabled.
I'll look into making them SKIP when getsockopt()/setsockopt() returns
ENOPROTOOPT in next versions of patches.

> 
>> +
>> +    return test_cmp_getsockopt_setsockopt(ao, &tmp);
>> +}
>> +
>> +static inline int test_set_ao(int sk, const char *key, uint16_t flags,
>> +                  union tcp_addr in_addr, uint8_t prefix,
>> +                  uint8_t sndid, uint8_t rcvid)
>> +{
>> +    struct tcp_ao tmp;
>> +    int err;
>> +
>> +    err = test_prepare_def_ao(&tmp, key, flags, in_addr,
>> +            prefix, sndid, rcvid);
>> +    if (err)
>> +        return err;
> 
> Same comment as above here.
> 
>> +
>> +    if (setsockopt(sk, IPPROTO_TCP, TCP_AO, &tmp, sizeof(tmp)) < 0)
>> +        return -errno;
>> +
>> +    return test_verify_socket_ao(sk, &tmp);
>> +}
>> +
>> +extern ssize_t test_server_run(int sk, ssize_t quota, time_t
>> timeout_sec);
>> +extern ssize_t test_client_loop(int sk, char *buf, size_t buf_sz,
>> +                const size_t msg_len, time_t timeout_sec);
>> +extern int test_client_verify(int sk, const size_t msg_len, const
>> size_t nr,
>> +                  time_t timeout_sec);
>> +
>> +struct netstat;
>> +extern struct netstat *netstat_read(void);
>> +extern void netstat_free(struct netstat *ns);
>> +extern void netstat_print_diff(struct netstat *nsa, struct netstat
>> *nsb);
>> +extern uint64_t netstat_get(struct netstat *ns,
>> +                const char *name, bool *not_found);
>> +
>> +static inline uint64_t netstat_get_one(const char *name, bool
>> *not_found)
>> +{
>> +    struct netstat *ns = netstat_read();
>> +    uint64_t ret;
>> +
>> +    ret = netstat_get(ns, name, not_found);
>> +
>> +    netstat_free(ns);
>> +    return ret;
>> +}
>> +
>> +#endif /* _AOLIB_H_ */
>> diff --git a/tools/testing/selftests/net/tcp_ao/lib/netlink.c
>> b/tools/testing/selftests/net/tcp_ao/lib/netlink.c
>> new file mode 100644
>> index 000000000000..f04757c921d0
>> --- /dev/null
>> +++ b/tools/testing/selftests/net/tcp_ao/lib/netlink.c
>> @@ -0,0 +1,341 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Original from tools/testing/selftests/net/ipsec.c */
>> +#include <linux/netlink.h>
>> +#include <linux/random.h>
>> +#include <linux/rtnetlink.h>
>> +#include <linux/veth.h>
>> +#include <net/if.h>
>> +#include <stdint.h>
>> +#include <string.h>
>> +#include <sys/socket.h>
>> +
>> +#include "aolib.h"
>> +
>> +#define MAX_PAYLOAD        2048
> 
> tools/testing/selftests/net/gro.c seem to define this as:
> 
> #define MAX_PAYLOAD (IP_MAXPACKET - sizeof(struct tcphdr) -
> sizeof(struct ipv6hdr))
> 
> Can you do the same instead of hard-coding?

I think I could look into way of dynamically allocate netlink buffer for
requests, but I would say it's not as bad as it looks: the functions
always use constant size of messages for the netlink messages, so the
buffer size is always constant. And if anything doesn't fit, the helper
rtattr_pack() will just fail the test and it'll be visible straight away.
So, in my point of view, it could have been nicer, but this is the
easiest and simplest way by allocating const buffer on stack, rather
than dynamically.

>> +
>> +const struct sockaddr_in6 addr_any6 = {
>> +    .sin6_family    = AF_INET6,
>> +};
>> +
>> +const struct sockaddr_in addr_any4 = {
>> +    .sin_family    = AF_INET,
>> +};
>>
> 
> A couple of things to look at closely. For some failures such as
> memory allocation for the test or not being able to open a file
> 
> fnetstat = fopen("/proc/net/netstat", "r");
> 
> Is this a failure or missing config or not having the right permissions
> to open the fail. All of these cases would be a SKIP and not a test fail.

That makes sense, I'll look into making tests SKIP on failed memory
allocations or failed fopen()s.

Thank you for the review,
          Dmitry
