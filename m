Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAC9472A68
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240300AbhLMKkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240213AbhLMKk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:40:26 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53937C09B11D;
        Mon, 13 Dec 2021 02:31:38 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x10so33063275edd.5;
        Mon, 13 Dec 2021 02:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8ajaG0r3AY2WCDG/q8D9I8wf17cwfsvzkE8wUg9D0e0=;
        b=dbnnpFB5EfI6LLj8quzFfJRvKgmuhncw6YR3uOb95IUGFHWJAXdyYMlzUepIxwz9JE
         LBU6C0y5fFV5fnyNlpWU6sUo65wNxKHGZm5d/y+RxS+5bKsFOgN3QVupFqFGiB1pU/4a
         LX+GYwDsANL4Ojk5PSbw7bBN74SUFhqf2zCHeGr9wpo6iXT6oWCgxW92vr3snQ4/gwCw
         U+xPrYf1TA43R3Giejn5+uzRDcX4/QKpTrjb4y9xSkfKRGf3Il+13iikr73v0VSekcyg
         0ziKH/3rDXlRDlB4YNF+pkQIoI/5bsb4Vb6JUT0pkZdziVepj4alsOVqT/3AW5ljgDIg
         1icA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8ajaG0r3AY2WCDG/q8D9I8wf17cwfsvzkE8wUg9D0e0=;
        b=Q6mCXs2GtMiTEMqxubP1yaYxRFndg527Rmt1Q5k8WsOUofQzIucywZ/+LWHvdoCmvL
         xo6g1v/hEjZiAGV3QUyBOBIowB9umLOL+sXd+u1rZhD/BE1tEHy5SFvo77PbpJXZgGmc
         AqJ68OQD6uEVHwi3wTLri55MFJoayN9bQSZqAEEJXz9CFq1tj6IalhzCOcf0UnFAZW5/
         0uPiSmTpxYuuTx/eigUTIlgdy3TPv1hl2Z4Y4X/kCr36tpa06GgFkartKyBipB2LCIJA
         vsrEqlkd75r3TM0G+ZJ4tFCx5z+K6tYjzj5E6pi526GPEUVI9bMle6yQDlA6UIarBwNQ
         8HVw==
X-Gm-Message-State: AOAM533AYNU4N+/OzBFjrkBdKpwvVgdLiQ9jCW4GaSBS53kSeA/vD9eO
        Es8C5Hkj5Gp1psM//r/V90G7vhSx+9OdbA==
X-Google-Smtp-Source: ABdhPJw3nUdVh6UymMClDq3ERf5SACFWxfgKdQNnjmBR9BVS/ymRsIRG2ViUtLIU/ZabEZMQhd6Ijg==
X-Received: by 2002:a17:906:6a0a:: with SMTP id qw10mr45390074ejc.141.1639391496682;
        Mon, 13 Dec 2021 02:31:36 -0800 (PST)
Received: from ?IPv6:2a04:241e:501:3870:b23a:8c53:d7fd:f077? ([2a04:241e:501:3870:b23a:8c53:d7fd:f077])
        by smtp.gmail.com with ESMTPSA id e8sm6452233edz.73.2021.12.13.02.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 02:31:35 -0800 (PST)
Subject: Re: [PATCH v3 00/18] tcp: Initial support for RFC5925 auth option
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Francesco Ruggeri <fruggeri@arista.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1638962992.git.cdleonard@gmail.com>
Message-ID: <ad5858d9-aa06-60fe-d444-1158174796d2@gmail.com>
Date:   Mon, 13 Dec 2021 12:31:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <cover.1638962992.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/21 1:37 PM, Leonard Crestez wrote:
> This is similar to TCP MD5 in functionality but it's sufficiently
> different that wire formats are incompatible. Compared to TCP-MD5 more
> algorithms are supported and multiple keys can be used on the same
> connection but there is still no negotiation mechanism.
> 
> Expected use-case is protecting long-duration BGP/LDP connections
> between routers using pre-shared keys. The goal of this series is to
> allow routers using the linux TCP stack to interoperate with vendors
> such as Cisco and Juniper.
> 
> Both algorithms described in RFC5926 are implemented but the code is not
> very easily extensible beyond that. In particular there are several code
> paths making stack allocations based on RFC5926 maximum, those would
> have to be increased. Support for arbitrary algorithms was requested
> in reply to previous posts but I believe there is no real use case for
> that.
> 
> The current implementation is somewhat loose regarding configuration:
> * Overlaping MKTs can be configured despite what RFC5925 says
> * Current key can be deleted
> * If multiple keys are valid for a destination the kernel picks one
> in an unpredictable manner (this can be overridden).
> These conditions could be tightened but it is not clear the kernel
> should prevent misconfiguration from userspace.
> 
> This version implements prefixlen and incorporates comments from v2 as
> well as some unrelated fixes. Here are some known flaws and limitations:
> 
> * Crypto API is used with buffers on the stack and inside struct sock,
> this might not work on all arches. I'm currently only testing x64 VMs
> * Interaction with TCP-MD5 not tested in all corners.
> * Interaction with FASTOPEN not tested and unlikely to work because
> sequence number assumptions for syn/ack.
> * Not clear if crypto_ahash_setkey might sleep. If some implementation
> do that then maybe they could be excluded through alloc flags.
> * Traffic key is not cached (reducing performance)
> * There is no useful way to list keys, making userspace debug difficult.
> 
> Some testing support is included in nettest and fcnal-test.sh, similar
> to the current level of tcp-md5 testing.
> 
> A more elaborate test suite using pytest and scapy is available out of
> tree: https://github.com/cdleonard/tcp-authopt-test That test suite is
> much larger that the kernel code and did not receive many comments so
> I will attempt to push it separately (if at all).
> 
> Changes for frr (old): https://github.com/FRRouting/frr/pull/9442
> That PR was made early for ABI feedback, it has many issues.
> 
> Changes for yabgp (old): https://github.com/cdleonard/yabgp/commits/tcp_authopt
> This can be use for easy interoperability testing with cisco/juniper/etc.
> 
> Changes since PATCH v2:
> * Protect tcp_authopt_alg_get/put_tfm with local_bh_disable instead of
> preempt_disable. This caused signature corruption when send path executing
> with BH enabled was interrupted by recv.
> * Fix accepted keyids not configured locally as "unexpected". If any key
> is configured that matches the peer then traffic MUST be signed.
> * Fix issues related to sne rollover during handshake itself. (Francesco)
> * Implement and test prefixlen (David)
> * Replace shash with ahash and reuse some of the MD5 code (Dmitry)
> * Parse md5+ao options only once in the same function (Dmitry)
> * Pass tcp_authopt_info into inbound check path, this avoids second rcu
> dereference for same packet.
> * Pass tcp_request_socket into inbound check path instead of just listen
> socket. This is required for SNE rollover during handshake and clearifies
> ISN handling.
> * Do not allow disabling via sysctl after enabling once, this is difficult
> to support well (David)
> * Verbose check for sysctl_tcp_authopt (Dmitry)
> * Use netif_index_is_l3_master (David)
> * Cleanup ipvx_addr_match (David)
> * Add a #define tcp_authopt_needed to wrap static key usage because it looks
> nicer.
> * Replace rcu_read_lock with rcu_dereference_protected in SNE updates (Eric)
> Link: https://lore.kernel.org/netdev/cover.1635784253.git.cdleonard@gmail.com/
> 
> Changes since PATCH v1:
> * Implement Sequence Number Extension
> * Implement l3index for vrf: TCP_AUTHOPT_KEY_IFINDEX as equivalent of
> TCP_MD5SIG_FLAG_IFINDEX
> * Expand TCP-AO tests in fcnal-test.sh to near-parity with md5.
> * Show addr/port on failure similar to md5
> * Remove tox dependency from test suite (create venv directly)
> * Switch default pytest output format to TAP (kselftest standard)
> * Fix _copy_from_sockptr_tolerant stack corruption on short sockopts.
> This was covered in test but error was invisible without STACKPROTECTOR=y
> * Fix sysctl_tcp_authopt check in tcp_get_authopt_val before memset. This
> was harmless because error code is checked in getsockopt anyway.
> * Fix dropping md5 packets on all sockets with AO enabled
> * Fix checking (key->recv_id & TCP_AUTHOPT_KEY_ADDR_BIND) instead of
> key->flags in tcp_authopt_key_match_exact
> * Fix PATCH 1/19 not compiling due to missing "int err" declaration
> * Add ratelimited message for AO and MD5 both present
> * Export all symbols required by CONFIG_IPV6=m (again)
> * Fix compilation with CONFIG_TCP_AUTHOPT=y CONFIG_TCP_MD5SIG=n
> * Fix checkpatch issues
> * Pass -rrequirements.txt to tox to avoid dependency variation.
> Link: https://lore.kernel.org/netdev/cover.1632240523.git.cdleonard@gmail.com/
> 
> Changes since RFCv3:
> * Implement TCP_AUTHOPT handling for timewait and reset replies. Write
> tests to execute these paths by injecting packets with scapy
> * Handle combining md5 and authopt: if both are configured use authopt.
> * Fix locking issues around send_key, introduced in on of the later patches.
> * Handle IPv4-mapped-IPv6 addresses: it used to be that an ipv4 SYN sent
> to an ipv6 socket with TCP-AO triggered WARN
> * Implement un-namespaced sysctl disabled this feature by default
> * Allocate new key before removing any old one in setsockopt (Dmitry)
> * Remove tcp_authopt_key_info.local_id because it's no longer used (Dmitry)
> * Propagate errors from TCP_AUTHOPT getsockopt (Dmitry)
> * Fix no-longer-correct TCP_AUTHOPT_KEY_DEL docs (Dmitry)
> * Simplify crypto allocation (Eric)
> * Use kzmalloc instead of __GFP_ZERO (Eric)
> * Add static_key_false tcp_authopt_needed (Eric)
> * Clear authopt_info copied from oldsk in __tcp_authopt_openreq (Eric)
> * Replace memcmp in ipv4 and ipv6 addr comparisons (Eric)
> * Export symbols for CONFIG_IPV6=m (kernel test robot)
> * Mark more functions static (kernel test robot)
> * Fix build with CONFIG_PROVE_RCU_LIST=y (kernel test robot)
> Link: https://lore.kernel.org/netdev/cover.1629840814.git.cdleonard@gmail.com/
> 
> Changes since RFCv2:
> * Removed local_id from ABI and match on send_id/recv_id/addr
> * Add all relevant out-of-tree tests to tools/testing/selftests
> * Return an error instead of ignoring unknown flags, hopefully this makes
> it easier to extend.
> * Check sk_family before __tcp_authopt_info_get_or_create in tcp_set_authopt_key
> * Use sock_owned_by_me instead of WARN_ON(!lockdep_sock_is_held(sk))
> * Fix some intermediate build failures reported by kbuild robot
> * Improve documentation
> Link: https://lore.kernel.org/netdev/cover.1628544649.git.cdleonard@gmail.com/
>   
> Changes since RFC:
> * Split into per-topic commits for ease of review. The intermediate
> commits compile with a few "unused function" warnings and don't do
> anything useful by themselves.
> * Add ABI documention including kernel-doc on uapi
> * Fix lockdep warnings from crypto by creating pools with one shash for
> each cpu
> * Accept short options to setsockopt by padding with zeros; this
> approach allows increasing the size of the structs in the future.
> * Support for aes-128-cmac-96
> * Support for binding addresses to keys in a way similar to old tcp_md5
> * Add support for retrieving received keyid/rnextkeyid and controling
> the keyid/rnextkeyid being sent.
> Link: https://lore.kernel.org/netdev/01383a8751e97ef826ef2adf93bfde3a08195a43.1626693859.git.cdleonard@gmail.com/
> ```
> 
> Leonard Crestez (18):
>    tcp: authopt: Initial support and key management
>    docs: Add user documentation for tcp_authopt
>    tcp: authopt: Add crypto initialization
>    tcp: md5: Refactor tcp_sig_hash_skb_data for AO
>    tcp: authopt: Compute packet signatures
>    tcp: authopt: Hook into tcp core
>    tcp: authopt: Disable via sysctl by default
>    tcp: authopt: Implement Sequence Number Extension
>    tcp: ipv6: Add AO signing for tcp_v6_send_response
>    tcp: authopt: Add support for signing skb-less replies
>    tcp: ipv4: Add AO signing for skb-less replies
>    tcp: authopt: Add key selection controls
>    tcp: authopt: Add initial l3index support
>    tcp: authopt: Add NOSEND/NORECV flags
>    tcp: authopt: Add prefixlen support
>    selftests: nettest: Rename md5_prefix to key_addr_prefix
>    selftests: nettest: Initial tcp_authopt support
>    selftests: net/fcnal: Initial tcp_authopt support
> 
>   Documentation/networking/index.rst        |    1 +
>   Documentation/networking/ip-sysctl.rst    |    6 +
>   Documentation/networking/tcp_authopt.rst  |   69 +
>   include/linux/tcp.h                       |    9 +
>   include/net/tcp.h                         |   27 +-
>   include/net/tcp_authopt.h                 |  316 ++++
>   include/uapi/linux/snmp.h                 |    1 +
>   include/uapi/linux/tcp.h                  |  137 ++
>   net/ipv4/Kconfig                          |   14 +
>   net/ipv4/Makefile                         |    1 +
>   net/ipv4/proc.c                           |    1 +
>   net/ipv4/sysctl_net_ipv4.c                |   39 +
>   net/ipv4/tcp.c                            |   68 +-
>   net/ipv4/tcp_authopt.c                    | 1671 +++++++++++++++++++++
>   net/ipv4/tcp_input.c                      |   41 +-
>   net/ipv4/tcp_ipv4.c                       |  136 +-
>   net/ipv4/tcp_minisocks.c                  |   12 +
>   net/ipv4/tcp_output.c                     |   86 +-
>   net/ipv6/tcp_ipv6.c                       |  108 +-
>   tools/testing/selftests/net/fcnal-test.sh |  298 ++++
>   tools/testing/selftests/net/nettest.c     |  123 +-
>   21 files changed, 3085 insertions(+), 79 deletions(-)
>   create mode 100644 Documentation/networking/tcp_authopt.rst
>   create mode 100644 include/net/tcp_authopt.h
>   create mode 100644 net/ipv4/tcp_authopt.c
> 
> 
> base-commit: 1fe5b01262844be03de98afdd56d1d393df04d7e


One issue that I realized recently is that there is an ugly race with 
the following steps:

1) remote connect
2) server key delete on listen socket
3) server accept

Under the current implementation the new file descriptor created at step 
3 has a set of key that is essentially unpredictable. This is because 
the list of keys is copied from listen socket to newly accepted socket 
at "tcp_create_openreq_child" time which happens after the 3-way 
handshake is completely (with an ACK from client) but before accept().

The simplest incorrect behavior is that an incoming connection using a 
key that is being deleted may be accepted and it will last indefinitely. 
But it's worse than that: if server sockets have an arbitrarily old 
version of the key chain then userspace can't reliably implement key 
management.

Possible solutions:

1. Make linux TCP copy the keys list from the listen socket on "accept" 
specifically. Not clear where in the code.
2. Add a sockopt to copy keys on demand from listen to accept. Like 
solution 2 but dumped on userspace.
3. Make userspace check if current key on accepted sockets is expired? 
Not clear how exactly and right now there isn't even an interface to 
list current keys on a socket.
4. Make keys global, per-namespace instead of per-socket.

Solution 4 is quite a large change to make so late but it would also 
simplify userspace in other ways, for example there would no longer be a 
need to do the same keyadd/keydel on all the established sockets.

Can you think of other solutions? TCP_MD5SIG does not suffer from this 
very much because it only ever supports one for each established socket.

---

I also had a recent conversation with Philip Paeps which plans to 
implement TCP-AO for freebsd and various open-source userspace daemons, 
hopefully in a way that requires minimum os-specific ifdefs.

His initial idea was to use PF_KEY for a global list of keys but I don't 
think it has any clear advantage over just doing SOL_TCP setsockopts on 
any random TCP socket. I think if an interface such as PF_KEY or xfrm or 
netlink would be supported it would still make sense to have an internal 
list of custom struct tcp_authopt_key anyway. So why not just implement 
the most specific interface.

Global keys would also be vaguely aligned to this suggestion from FRR: 
(https://github.com/FRRouting/frr/pull/9442#issuecomment-904766419)

In theory it would be possible to support both socket-specific and 
global keys, but I can't think of a reason to do so other than 
compatibility with older version of this patch series.

Can anyone think of a realistic scenario that can only be made to work 
with per-socket keys?

---

It would also be possible to push all key rollover policy into the 
kernel. Current proprietary implementations implement something similar 
to RFC8177: optional time intervals for "accept" and "send". This logic 
is very simple, it just requires extending the key struct with 4 
wall-time fields.

This is not however required for making keys global so it can be a 
separate discussion.

I also received a bunch of kernel build robot complains that I need to fix.

It's also not clear that making the tcp_authopt_info member in twsk a 
plain pointer is correct, it might need RCU annotations.

--
Regards,
Leonard
