Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4303598992
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343535AbiHRRA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345252AbiHRRAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:00:20 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6BEC12CF
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:15 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id i129-20020a1c3b87000000b003a62f19b453so348188wma.3
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=JMKQ+xguX04WuDh2F6byjDdWILtlWwiHA3+aubyuFBw=;
        b=BzGDrMRZSkJu5WR0ePGF5NdgBejLg9/C/g/W6CqAAVVGSYX3jNLphpz686FA7NMZQz
         tqr2b0At1YnnsHg9S/oEYPv0S/y0eQCjXh7WNpEjTbgRrbDZHD9ievMawzW19ZPJGphF
         y4aicF4oLkgMptVirZ+Iicz9wP5TxDwIwlEyD3Gs+ArWzHDMcQ5euYL4xZUZvhz37xIl
         A2vgqF3sCUBBIGMyTSpUdCmJgrQkvbo/XLglHPXwRSDvPUZ12kabGNwp/Q4hFakQmyeF
         ZOttxtwDowcw8jj5Bg1EFkOO5+bW3DOJF/tUCopXmD7fqWsBy8tLaZ5SmsVDLn1HZU8M
         AfqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=JMKQ+xguX04WuDh2F6byjDdWILtlWwiHA3+aubyuFBw=;
        b=mSCT2lNJwAsB4xnOiE59dzaLytQKf2/r0ssd+CJzD+BU8/MyeiXWMIkZ/vEfnPQGf5
         RQlx6yTi1WbvkDOUNg0uHlFvViQi2qbiYG3v30Meu50XBfIOdDLaC2V9ZUD1H2RdFZjR
         F4AsO5y6umroll+8wW0DGQxIHzvKrddD9P7+p+usRNUN3PMTdvFAeT9VCx899TzXgiBV
         9CR3bEvSbhehwAr09rH+3vsbmpdsy2bRqM5uuiGyH4GhcICSW3f9ZQUCFAnncF86W3rX
         mL2O+gM6QiE/8tjYU5xsG+2g+XgCqAoJOvQOyFfD+odk/2HrzYSCIXJoqHnG0JqNQCsV
         izcQ==
X-Gm-Message-State: ACgBeo3inEDZXfsuMLgdQuQPr62ooOhWeEJtFscOJc8EhioiKVzBmA8S
        R89NNneIc8sp4VNRUCjkZAUfiw==
X-Google-Smtp-Source: AA6agR63SjBLpPG4dqxXE830PltqErc5iMRQx70WlwUYczxq3ExyPIs73bggjQHdMsafS+F/VErY/g==
X-Received: by 2002:a05:600c:4f05:b0:3a5:ffec:b6b with SMTP id l5-20020a05600c4f0500b003a5ffec0b6bmr5558746wmq.199.1660842013158;
        Thu, 18 Aug 2022 10:00:13 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:12 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
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
Subject: [PATCH 00/31] net/tcp: Add TCP-AO support
Date:   Thu, 18 Aug 2022 17:59:34 +0100
Message-Id: <20220818170005.747015-1-dima@arista.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset implements the TCP-AO option as described in RFC5925. There
is a request from industry to move away from TCP-MD5SIG and it seems the time
is right to have a TCP-AO upstreamed. This TCP option is meant to replace
the TCP MD5 option and address its shortcomings. Specifically, it provides
more secure hashing, key rotation and support for long-lived connections
(see the summary of TCP-AO advantages over TCP-MD5 in (1.3) of RFC5925).
The patch series starts with six patches that are not specific to TCP-AO
but implement a general crypto facility that we thought is useful
to eliminate code duplication between TCP-MD5SIG and TCP-AO as well as other
crypto users. These six patches are being submitted separately in
a different patchset [1]. Including them here will show better the gain
in code sharing. Next are 18 patches that implement the actual TCP-AO option,
followed by patches implementing selftests.

The patch set was written as a collaboration of three authors (in alphabetical
order): Dmitry Safonov, Francesco Ruggeri and Salam Noureddine. Additional
credits should be given to Prasad Koya, who was involved in early prototyping
a few years back. There is also a separate submission done by Leonard Crestez
whom we thank for his efforts getting an implementation of RFC5925 submitted
for review upstream [2]. This is an independent implementation that makes
different design decisions.

For example, we chose a similar design to the TCP-MD5SIG implementation and
used setsockopt()s to program per-socket keys, avoiding the extra complexity
of managing a centralized key database in the kernel. A centralized database
in the kernel has dubious benefits since it doesn’t eliminate per-socket
setsockopts needed to specify which sockets need TCP-AO and what are the
currently preferred keys. It also complicates traffic key caching and
preventing deletion of in-use keys.

In this implementation, a centralized database of keys can be thought of
as living in user space and user applications would have to program those
keys on matching sockets. On the server side, the user application programs
keys (MKTS in TCP-AO nomenclature) on the listening socket for all peers that
are expected to connect. Prefix matching on the peer address is supported.
When a peer issues a successful connect, all the MKTs matching the IP address
of the peer are copied to the newly created socket. On the active side,
when a connect() is issued all MKTs that do not match the peer are deleted
from the socket since they will never match the peer. This implementation
uses three setsockopt()s for adding, deleting and modifying keys on a socket.
All three setsockopt()s have extensive sanity checks that prevent
inconsistencies in the keys on a given socket. A getsockopt() is provided
to get key information from any given socket.

Few things to note about this implementation:
- Traffic keys are cached for established connections avoiding the cost of
  such calculation for each packet received or sent.
- Great care has been taken to avoid deleting in-use MKTs
  as required by the RFC.
- Any crypto algorithm supported by the Linux kernel can be used
  to calculate packet hashes.
- Fastopen works with TCP-AO but hasn’t been tested extensively.
- Tested for interop with other major networking vendors (on linux-4.19),
  including testing for key rotation and long lived connections.

There are a couple of limitations that we’re aware of, including (but not
limited to) the following:
- setsockopt(TCP_REPAIR) not supported yet
- IPv4-mapped-IPv6 addresses not tested
- static key not implemented yet
- CONFIG_TCP_AO depends on CONFIG_TCP_MD5SIG
- A small window for a race condition exists between accept and key
  adding/deletion on a listening socket but can be easily overcome by using
  the getsockopt() to make sure the right keys are there on a newly accepted
  connection
- Key matching by TCP port numbers, peer ranges, asterisks is unsupported
  as it’s unlikely to be useful

[1]: https://lore.kernel.org/all/20220726201600.1715505-1-dima@arista.com/
[2]: https://lore.kernel.org/all/cover.1658815925.git.cdleonard@gmail.com/

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Bob Gilligan <gilligan@arista.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Francesco Ruggeri <fruggeri@arista.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Ivan Delalande <colona@arista.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Leonard Crestez <cdleonard@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Salam Noureddine <noureddine@arista.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Dmitry Safonov (31):
  crypto: Introduce crypto_pool
  crypto_pool: Add crypto_pool_reserve_scratch()
  net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
  net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction
  net/tcp: Use crypto_pool for TCP-MD5
  net/ipv6: sr: Switch to using crypto_pool
  tcp: Add TCP-AO config and structures
  net/tcp: Introduce TCP_AO setsockopt()s
  net/tcp: Prevent TCP-MD5 with TCP-AO being set
  net/tcp: Calculate TCP-AO traffic keys
  net/tcp: Add TCP-AO sign to outgoing packets
  net/tcp: Add tcp_parse_auth_options()
  net/tcp: Add AO sign to RST packets
  net/tcp: Add TCP-AO sign to twsk
  net/tcp: Wire TCP-AO to request sockets
  net/tcp: Sign SYN-ACK segments with TCP-AO
  net/tcp: Verify inbound TCP-AO signed segments
  net/tcp: Add TCP-AO segments counters
  net/tcp: Add TCP-AO SNE support
  net/tcp: Add tcp_hash_fail() ratelimited logs
  net/tcp: Ignore specific ICMPs for TCP-AO connections
  net/tcp: Add option for TCP-AO to (not) hash header
  net/tcp: Add getsockopt(TCP_AO_GET)
  net/tcp: Allow asynchronous delete for TCP-AO keys (MKTs)
  selftests/net: Add TCP-AO library
  selftests/net: Verify that TCP-AO complies with ignoring ICMPs
  selftest/net: Add TCP-AO ICMPs accept test
  selftest/tcp-ao: Add a test for MKT matching
  selftest/tcp-ao: Add test for TCP-AO add setsockopt() command
  selftests/tcp-ao: Add TCP-AO + TCP-MD5 + no sign listen socket tests
  selftests/aolib: Add test/benchmark for removing MKTs

 crypto/Kconfig                                |   12 +
 crypto/Makefile                               |    1 +
 crypto/crypto_pool.c                          |  323 +++
 include/crypto/pool.h                         |   33 +
 include/linux/sockptr.h                       |   23 +
 include/linux/tcp.h                           |   24 +
 include/net/dropreason.h                      |   25 +
 include/net/seg6_hmac.h                       |    7 -
 include/net/tcp.h                             |  193 +-
 include/net/tcp_ao.h                          |  283 +++
 include/uapi/linux/snmp.h                     |    5 +
 include/uapi/linux/tcp.h                      |   62 +
 net/ipv4/Kconfig                              |   15 +-
 net/ipv4/Makefile                             |    1 +
 net/ipv4/proc.c                               |    5 +
 net/ipv4/tcp.c                                |  191 +-
 net/ipv4/tcp_ao.c                             | 1939 +++++++++++++++++
 net/ipv4/tcp_input.c                          |   94 +-
 net/ipv4/tcp_ipv4.c                           |  385 +++-
 net/ipv4/tcp_minisocks.c                      |   37 +-
 net/ipv4/tcp_output.c                         |  188 +-
 net/ipv6/Kconfig                              |    2 +-
 net/ipv6/Makefile                             |    1 +
 net/ipv6/seg6.c                               |    3 -
 net/ipv6/seg6_hmac.c                          |  204 +-
 net/ipv6/tcp_ao.c                             |  151 ++
 net/ipv6/tcp_ipv6.c                           |  327 ++-
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/net/tcp_ao/.gitignore |    2 +
 tools/testing/selftests/net/tcp_ao/Makefile   |   50 +
 .../selftests/net/tcp_ao/bench-lookups.c      |  403 ++++
 .../selftests/net/tcp_ao/connect-deny.c       |  217 ++
 tools/testing/selftests/net/tcp_ao/connect.c  |   81 +
 .../selftests/net/tcp_ao/icmps-accept.c       |    1 +
 .../selftests/net/tcp_ao/icmps-discard.c      |  447 ++++
 .../testing/selftests/net/tcp_ao/lib/aolib.h  |  333 +++
 .../selftests/net/tcp_ao/lib/netlink.c        |  341 +++
 tools/testing/selftests/net/tcp_ao/lib/proc.c |  267 +++
 .../testing/selftests/net/tcp_ao/lib/setup.c  |  297 +++
 tools/testing/selftests/net/tcp_ao/lib/sock.c |  294 +++
 .../testing/selftests/net/tcp_ao/lib/utils.c  |   30 +
 .../selftests/net/tcp_ao/setsockopt-closed.c  |  191 ++
 .../selftests/net/tcp_ao/unsigned-md5.c       |  483 ++++
 43 files changed, 7516 insertions(+), 456 deletions(-)
 create mode 100644 crypto/crypto_pool.c
 create mode 100644 include/crypto/pool.h
 create mode 100644 include/net/tcp_ao.h
 create mode 100644 net/ipv4/tcp_ao.c
 create mode 100644 net/ipv6/tcp_ao.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/.gitignore
 create mode 100644 tools/testing/selftests/net/tcp_ao/Makefile
 create mode 100644 tools/testing/selftests/net/tcp_ao/bench-lookups.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/connect-deny.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/connect.c
 create mode 120000 tools/testing/selftests/net/tcp_ao/icmps-accept.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/icmps-discard.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/lib/aolib.h
 create mode 100644 tools/testing/selftests/net/tcp_ao/lib/netlink.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/lib/proc.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/lib/setup.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/lib/sock.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/lib/utils.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/setsockopt-closed.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/unsigned-md5.c


base-commit: e34cfee65ec891a319ce79797dda18083af33a76
-- 
2.37.2

