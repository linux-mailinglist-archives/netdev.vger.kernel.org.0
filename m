Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0071859EA45
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiHWRsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiHWRs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:48:26 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1662AF0CE
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 08:47:41 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id x10-20020a4a410a000000b004456a27110fso2498303ooa.7
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 08:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=KRDDD/ZTQOm4jKNRqZwPa4ZNh2t/HyznlxFVrDjnB8U=;
        b=U0+/YUjFon/lph3ldYw4TkScr3J/MCVglErPGQ/vLneIjcO1gaF5o5kOCT+o/eHcGQ
         SupMAksppFSPyPxykYtJXnXyLaFvHiVLigvoxvWN3yO7JXzpn2KnJa5J+9jQQMgD94ah
         TJMxrcFPWD6bdOXSgMKgdNxUyhd05pKT4u84M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=KRDDD/ZTQOm4jKNRqZwPa4ZNh2t/HyznlxFVrDjnB8U=;
        b=3ofMqkhMvBghq4EgzXGCgDiByM7S9eqirVSAHDWDlZbRoQVM20lxJ2IqDK+YXiZKbC
         w+rDw0fxq/qu1+Kn0F43HyrG/WphfA9w5/jUBzJqQw/X/PApEhHc65z3DJxqgjqL59Lb
         CcfpqOXoIxadIY8c3rvM9nqUvkpW3q0vsIhwZyqbNLJ4z3EXtIrBTu+gFAAAf6dy9eDb
         ObXeJWn89ACWcntuoxOr2tts+h9P+vHK6tE10vK+unRjl+0ewwjWOam0Tcc6inNXEz+P
         1QQlAH4gvISA41h15iGC5SRExWNolMLmwdHT2ztLYB9wLIraAnkmkapW8rNxStPfhoLo
         1CgA==
X-Gm-Message-State: ACgBeo2J39xubk2Ojoerq78UxEe1lzCTSwr9tl8gC06EwjyEZw7lkIJy
        dguxttyzB2Z6FhqGm+45Sx7NXQ==
X-Google-Smtp-Source: AA6agR6YzN5it96eWePaUxUMLxCc1S5wDKWZtrIqKyxwFBsKCHEzkbrHxTXvzBuqngWPpKKk7XzXuA==
X-Received: by 2002:a4a:4541:0:b0:435:cf9f:1a45 with SMTP id y62-20020a4a4541000000b00435cf9f1a45mr8241849ooa.17.1661269661024;
        Tue, 23 Aug 2022 08:47:41 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id b23-20020a056830105700b006373175cde0sm3894735otp.44.2022.08.23.08.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 08:47:40 -0700 (PDT)
Subject: Re: [PATCH 25/31] selftests/net: Add TCP-AO library
To:     Dmitry Safonov <dima@arista.com>,
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
        linux-crypto@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220818170005.747015-1-dima@arista.com>
 <20220818170005.747015-26-dima@arista.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <aa0143bc-b0d1-69fb-c117-1e7241f0ad89@linuxfoundation.org>
Date:   Tue, 23 Aug 2022 09:47:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220818170005.747015-26-dima@arista.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/22 10:59 AM, Dmitry Safonov wrote:
> Provide functions to create selftests dedicated to TCP-AO.
> They can run in parallel, as they use temporary net namespaces.
> They can be very specific to the feature being tested.
> This will allow to create a lot of TCP-AO tests, without complicating
> one binary with many --options and to create scenarios, that are
> hard to put in bash script that uses one binary.
> 
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
>   tools/testing/selftests/Makefile              |   1 +
>   tools/testing/selftests/net/tcp_ao/.gitignore |   2 +
>   tools/testing/selftests/net/tcp_ao/Makefile   |  45 +++
>   tools/testing/selftests/net/tcp_ao/connect.c  |  81 +++++
>   .../testing/selftests/net/tcp_ao/lib/aolib.h  | 333 +++++++++++++++++
>   .../selftests/net/tcp_ao/lib/netlink.c        | 341 ++++++++++++++++++
>   tools/testing/selftests/net/tcp_ao/lib/proc.c | 267 ++++++++++++++
>   .../testing/selftests/net/tcp_ao/lib/setup.c  | 297 +++++++++++++++
>   tools/testing/selftests/net/tcp_ao/lib/sock.c | 294 +++++++++++++++
>   .../testing/selftests/net/tcp_ao/lib/utils.c  |  30 ++
>   10 files changed, 1691 insertions(+)
>   create mode 100644 tools/testing/selftests/net/tcp_ao/.gitignore
>   create mode 100644 tools/testing/selftests/net/tcp_ao/Makefile
>   create mode 100644 tools/testing/selftests/net/tcp_ao/connect.c
>   create mode 100644 tools/testing/selftests/net/tcp_ao/lib/aolib.h
>   create mode 100644 tools/testing/selftests/net/tcp_ao/lib/netlink.c
>   create mode 100644 tools/testing/selftests/net/tcp_ao/lib/proc.c
>   create mode 100644 tools/testing/selftests/net/tcp_ao/lib/setup.c
>   create mode 100644 tools/testing/selftests/net/tcp_ao/lib/sock.c
>   create mode 100644 tools/testing/selftests/net/tcp_ao/lib/utils.c
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 10b34bb03bc1..2a3b15a13ccb 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -46,6 +46,7 @@ TARGETS += net
>   TARGETS += net/af_unix
>   TARGETS += net/forwarding
>   TARGETS += net/mptcp
> +TARGETS += net/tcp_ao

Please look into a wayto invoke all of them instead of adding individual
net/* to the main Makefile. This list seems to be growing. :)

>   TARGETS += netfilter
>   TARGETS += nsfs
>   TARGETS += pidfd

[snip]

> +
> +__attribute__((__format__(__printf__, 2, 3)))
> +static inline void __test_print(void (*fn)(const char *), const char *fmt, ...)
> +{
> +#define TEST_MSG_BUFFER_SIZE 4096
> +	char buf[TEST_MSG_BUFFER_SIZE];
> +	va_list arg;
> +
> +	va_start(arg, fmt);
> +	vsnprintf(buf, sizeof(buf), fmt, arg);
> +	va_end(arg);
> +	fn(buf);
> +}
> +

Is there a reason add these instead of using kselftest_* print
functions?

> +#define test_print(fmt, ...)						\
> +	__test_print(__test_msg, "%ld[%s:%u] " fmt "\n",		\
> +		     syscall(SYS_gettid),				\
> +		     __FILE__, __LINE__, ##__VA_ARGS__)
> +
> +#define test_ok(fmt, ...)						\
> +	__test_print(__test_ok, fmt "\n", ##__VA_ARGS__)
> +
> +#define test_fail(fmt, ...)						\
> +do {									\
> +	if (errno)							\
> +		__test_print(__test_fail, fmt ": %m\n", ##__VA_ARGS__);	\
> +	else								\
> +		__test_print(__test_fail, fmt "\n", ##__VA_ARGS__);	\
> +	test_failed();							\
> +} while(0)
> +
> +#define KSFT_FAIL  1
> +#define test_error(fmt, ...)						\
> +do {									\
> +	if (errno)							\
> +		__test_print(__test_error, "%ld[%s:%u] " fmt ": %m\n",	\
> +			     syscall(SYS_gettid), __FILE__, __LINE__,	\
> +			     ##__VA_ARGS__);				\
> +	else								\
> +		__test_print(__test_error, "%ld[%s:%u] " fmt "\n",	\
> +			     syscall(SYS_gettid), __FILE__, __LINE__,	\
> +			     ##__VA_ARGS__);				\
> +	exit(KSFT_FAIL);						\
> +} while(0)
> +

Is there a reason add these instead of using kselftest_* print
functions?

> + * Timeout on syscalls where failure is not expected.
> + * You may want to rise it if the test machine is very busy.
> + */
> +#ifndef TEST_TIMEOUT_SEC
> +#define TEST_TIMEOUT_SEC	5
> +#endif
> +

Where is the TEST_TIMEOUT_SEC usually defined? Does this come
from shell wrapper that runs this test? Can we add a message before
starting the test print the timeout used?

> +/*
> + * Timeout on connect() where a failure is expected.
> + * If set to 0 - kernel will try to retransmit SYN number of times, set in
> + * /proc/sys/net/ipv4/tcp_syn_retries
> + * By default set to 1 to make tests pass faster on non-busy machine.
> + */
> +#ifndef TEST_RETRANSMIT_SEC
> +#define TEST_RETRANSMIT_SEC	1
> +#endif
> +

Where would this TEST_RETRANSMIT_SEC defined usually?

> +
> +static inline int _test_connect_socket(int sk, const union tcp_addr taddr,
> +					unsigned port, time_t timeout)
> +{
> +#ifdef IPV6_TEST
> +	struct sockaddr_in6 addr = {
> +		.sin6_family	= AF_INET6,
> +		.sin6_port	= htons(port),
> +		.sin6_addr	= taddr.a6,
> +	};
> +#else
> +	struct sockaddr_in addr = {
> +		.sin_family	= AF_INET,
> +		.sin_port	= htons(port),
> +		.sin_addr	= taddr.a4,
> +	};
> +#endif

Why do we defined these here - are they also defined in a kernel
header?

> +	return __test_connect_socket(sk, (void *)&addr, sizeof(addr), timeout);
> +}
> +
> +static inline int test_connect_socket(int sk,
> +		const union tcp_addr taddr, unsigned port)
> +{
> +	return _test_connect_socket(sk, taddr, port, TEST_TIMEOUT_SEC);
> +}
> +
> +extern int test_prepare_ao_sockaddr(struct tcp_ao *ao,
> +		const char *alg, uint16_t flags,
> +		void *addr, size_t addr_sz, uint8_t prefix,
> +		uint8_t sndid, uint8_t rcvid, uint8_t maclen,
> +		uint8_t keyflags, uint8_t keylen, const char *key);
> +
> +static inline int test_prepare_ao(struct tcp_ao *ao,
> +		const char *alg, uint16_t flags,
> +		union tcp_addr in_addr, uint8_t prefix,
> +		uint8_t sndid, uint8_t rcvid, uint8_t maclen,
> +		uint8_t keyflags, uint8_t keylen, const char *key)
> +{
> +#ifdef IPV6_TEST
> +	struct sockaddr_in6 addr = {
> +		.sin6_family	= AF_INET6,
> +		.sin6_port	= 0,
> +		.sin6_addr	= in_addr.a6,
> +	};
> +#else
> +	struct sockaddr_in addr = {
> +		.sin_family	= AF_INET,
> +		.sin_port	= 0,
> +		.sin_addr	= in_addr.a4,
> +	};
> +#endif
> +

Same question here. In general having these ifdefs isn't ideal without
a good reason.

> +	return test_prepare_ao_sockaddr(ao, alg, flags,
> +			(void *)&addr, sizeof(addr), prefix, sndid, rcvid,
> +			maclen, keyflags, keylen, key);
> +}
> +
> +static inline int test_prepare_def_ao(struct tcp_ao *ao,
> +		const char *key, uint16_t flags,
> +		union tcp_addr in_addr, uint8_t prefix,
> +		uint8_t sndid, uint8_t rcvid)
> +{
> +	if (prefix > DEFAULT_TEST_PREFIX)
> +		prefix = DEFAULT_TEST_PREFIX;
> +
> +	return test_prepare_ao(ao, DEFAULT_TEST_ALGO, flags, in_addr,
> +			prefix, sndid, rcvid, 0, 0, strlen(key), key);
> +}
> +
> +extern int test_get_one_ao(int sk, struct tcp_ao_getsockopt *out,
> +			   uint16_t flags, void *addr, size_t addr_sz,
> +			   uint8_t prefix, uint8_t sndid, uint8_t rcvid);
> +extern int test_cmp_getsockopt_setsockopt(const struct tcp_ao *a,
> +					  const struct tcp_ao_getsockopt *b);
> +
> +static inline int test_verify_socket_ao(int sk, struct tcp_ao *ao)
> +{
> +	struct tcp_ao_getsockopt tmp;
> +	int err;
> +
> +	err = test_get_one_ao(sk, &tmp, 0, &ao->tcpa_addr,
> +			sizeof(ao->tcpa_addr), ao->tcpa_prefix,
> +			ao->tcpa_sndid, ao->tcpa_rcvid);
> +	if (err)
> +		return err;

Is this always an error or could this a skip if dependencies aren't
met to run the test? This is a global comment for all error cases.

> +
> +	return test_cmp_getsockopt_setsockopt(ao, &tmp);
> +}
> +
> +static inline int test_set_ao(int sk, const char *key, uint16_t flags,
> +			      union tcp_addr in_addr, uint8_t prefix,
> +			      uint8_t sndid, uint8_t rcvid)
> +{
> +	struct tcp_ao tmp;
> +	int err;
> +
> +	err = test_prepare_def_ao(&tmp, key, flags, in_addr,
> +			prefix, sndid, rcvid);
> +	if (err)
> +		return err;

Same comment as above here.

> +
> +	if (setsockopt(sk, IPPROTO_TCP, TCP_AO, &tmp, sizeof(tmp)) < 0)
> +		return -errno;
> +
> +	return test_verify_socket_ao(sk, &tmp);
> +}
> +
> +extern ssize_t test_server_run(int sk, ssize_t quota, time_t timeout_sec);
> +extern ssize_t test_client_loop(int sk, char *buf, size_t buf_sz,
> +				const size_t msg_len, time_t timeout_sec);
> +extern int test_client_verify(int sk, const size_t msg_len, const size_t nr,
> +			      time_t timeout_sec);
> +
> +struct netstat;
> +extern struct netstat *netstat_read(void);
> +extern void netstat_free(struct netstat *ns);
> +extern void netstat_print_diff(struct netstat *nsa, struct netstat *nsb);
> +extern uint64_t netstat_get(struct netstat *ns,
> +			    const char *name, bool *not_found);
> +
> +static inline uint64_t netstat_get_one(const char *name, bool *not_found)
> +{
> +	struct netstat *ns = netstat_read();
> +	uint64_t ret;
> +
> +	ret = netstat_get(ns, name, not_found);
> +
> +	netstat_free(ns);
> +	return ret;
> +}
> +
> +#endif /* _AOLIB_H_ */
> diff --git a/tools/testing/selftests/net/tcp_ao/lib/netlink.c b/tools/testing/selftests/net/tcp_ao/lib/netlink.c
> new file mode 100644
> index 000000000000..f04757c921d0
> --- /dev/null
> +++ b/tools/testing/selftests/net/tcp_ao/lib/netlink.c
> @@ -0,0 +1,341 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Original from tools/testing/selftests/net/ipsec.c */
> +#include <linux/netlink.h>
> +#include <linux/random.h>
> +#include <linux/rtnetlink.h>
> +#include <linux/veth.h>
> +#include <net/if.h>
> +#include <stdint.h>
> +#include <string.h>
> +#include <sys/socket.h>
> +
> +#include "aolib.h"
> +
> +#define MAX_PAYLOAD		2048

tools/testing/selftests/net/gro.c seem to define this as:

#define MAX_PAYLOAD (IP_MAXPACKET - sizeof(struct tcphdr) - sizeof(struct ipv6hdr))

Can you do the same instead of hard-coding?


> +
> +const struct sockaddr_in6 addr_any6 = {
> +	.sin6_family	= AF_INET6,
> +};
> +
> +const struct sockaddr_in addr_any4 = {
> +	.sin_family	= AF_INET,
> +};
> 

A couple of things to look at closely. For some failures such as
memory allocation for the test or not being able to open a file

fnetstat = fopen("/proc/net/netstat", "r");

Is this a failure or missing config or not having the right permissions
to open the fail. All of these cases would be a SKIP and not a test fail.

thanks,
-- Shuah

