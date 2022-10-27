Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0706102F0
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236699AbiJ0UoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbiJ0Un6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:43:58 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5125A7173C
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:43:56 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id bs21so4165468wrb.4
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TYGHZDqvvBxnsm6EcMaKF3Cm5D7EL8Qs7lX7iPvQ5j0=;
        b=RYI345U3vuySGiBaniPTJBMKW9tUFQHDSDdUVwcQDiEwcup36zDRObQtMNu2e9PayL
         bc0RMaCCr1Fsw9dRGj/BkFCyJ1fZXMfCeeJ5FhCCFh8iD3oBNSpVpQk8J00BjZXE02Rh
         1OzbWaKkCovxwhLGaR+NQU1Ym9ckcvQSFubMl/EJj4k3kUHmbCqLA1niFWVonbD5i08s
         3uOu/KHIGUJu1rU/nn/s0X067vGiz+Aol9OzvIXja1DrmNzwUB9hK8M5lerzXmCK4WLQ
         5eRtLe5WWcjWjQyYlyP3JOra2NilNL3EJShJS9+ortqZX4939v7dhgnSOea8uek+PhI3
         tFDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TYGHZDqvvBxnsm6EcMaKF3Cm5D7EL8Qs7lX7iPvQ5j0=;
        b=lomclNdZE92K/fKnHocVCMaRFRDOrnY9xWBKIOehO2S9vwEeCCFJddem/r1+hIgFz0
         S6JYLvrtyL/8IinynC1Q1yUCTeX+iZwGEUHpkjjCa/w6CpSGPaeqgnPXULBELDs4F5gx
         5Xp/b0svyTJgV9T1PNB3R4NBYznQhlRTPs4PLUcWhLT8nJqVdiYCs9T1R6Hlf5c6PgVW
         DgRYGJGN8aeYUGVEMN47CgXTdFE9vRJPeSn1SeOgQ/lNXn2tbqH37+NVRqkB36VpOrzd
         Wm3Vrbr/NJmcjpfvi6yPGuCvX+9LGNniBa309NkNRIvQi1Uzcx9vjH9chMvznogeMapH
         /BZw==
X-Gm-Message-State: ACrzQf2cnQbmfCS8/2mp3IxKwCuTbQoLOJRgXsXHnchfVof7CqSTshyj
        nZSr7W7kUp4VFmYQALZfKhROLg==
X-Google-Smtp-Source: AMsMyM4eztAZtqknRs4qeLpH9k950PuifsLvhIzAgHD8+jckaiXLgHQax2e2xMDZ/MdYdr89UcFOyw==
X-Received: by 2002:a5d:4e47:0:b0:236:6dca:d355 with SMTP id r7-20020a5d4e47000000b002366dcad355mr16534317wrt.498.1666903434741;
        Thu, 27 Oct 2022 13:43:54 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:43:54 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
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
Subject: [PATCH v3 00/36] net/tcp: Add TCP-AO support
Date:   Thu, 27 Oct 2022 21:43:11 +0100
Message-Id: <20221027204347.529913-1-dima@arista.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In TODO (expect in next versions):
- Documentation/ page about TCP-AO kernel design, UAPI
- Support VRFs in setsockopt()
- setsockopt() UAPI padding + a test that structures are of the same
  size on 32-bit as on 64-bit platforms
- IPv4-mapped-IPv6 addresses
- Measure/benchmark TCP-AO and regular TCP connections (on hw)
- setsockopt(TCP_REPAIR) with TCP-AO

Changes from v2:
- Added more missing `static' declarations for local functions
  (kernel test robot <lkp@intel.com>)
- Building now with CONFIG_TCP_AO=n and CONFIG_TCP_MD5SIG=n
  (kernel test robot <lkp@intel.com>)
- Now setsockopt(TCP_AO) is allowed when it's TCP_LISTEN or TCP_CLOSE
  state OR the key added is not the first key on a socket (by Salam)
- CONFIG_TCP_AO does not depend on CONFIG_TCP_MD5SIG anymore
- Don't leak tcp_md5_needed static branch counter when TCP-MD5 key
  is modified/changed
- TCP-AO lookups are dynamically enabled/disabled with static key when
  there is ao_info in the system (and when it is destroyed)
- Wired SYN cookies up to TCP-AO (by Salam)
- Fix verification for possible re-transmitted SYN packets (by Salam)
- use sockopt_lock_sock() instead of lock_sock()
  (from v6.1 rebase, commit d51bbff2aba7)
- use sockptr_t in getsockopt(TCP_AO_GET)
  (from v6.1 rebase, commit 34704ef024ae)
- Fixed reallocating crypto_pool's scratch area by IPI while
  crypto_pool_get() was get by another CPU
- selftests on older kernels (or with CONFIG_TCP_AO=n) should exit with
  SKIP, not FAIL (Shuah Khan <shuah@kernel.org>)
- selftests that check interaction between TCP-AO and TCP-MD5 now
  SKIP when CONFIG_TCP_MD5SIG=n
- Measured the performance of different hashing algorithms for TCP-AO
  and compare with TCP-MD5 performance. This is done with hacky patches
  to iperf (see [3]). At this moment I've done it in qemu/KVM with CPU
  affinities set on Intel(R) Core(TM) i7-7600U CPU @ 2.80GHz.
  No performance degradation was noticed before/after patches, but given
  the measures were done in a VM, without measuring it on a physical dut
  it only gives a hint of relative speed for different hash algorithms
  with TCP-AO. Here are results, averaging on 30 measures each:
  TCP:                    3.51Gbits/sec
  TCP-MD5:                1.12Gbits/sec
  TCP-AO(HMAC(SHA1)):     1.53Gbits/sec
  TCP-AO(CMAC(AES128)):   621Mbits/sec
  TCP-AO(HMAC(SHA512)):   1.21Gbits/sec
  TCP-AO(HMAC(SHA384)):   1.20Gbits/sec
  TCP-AO(HMAC(SHA224)):   961Mbits/sec
  TCP-AO(HMAC(SHA3-512)): 157Mbits/sec
  TCP-AO(HMAC(RMD160)):   659Mbits/sec
  TCP-AO(HMAC(MD5):       1.12Gbits/sec
  (the last one is just for fun, but may make sense as it provides
  the same security as TCP-MD5, but allows multiple keys and a mechanism
  to change them from RFC5925)

Changes from v1:
- Building now with CONFIG_IPV6=n (kernel test robot <lkp@intel.com>)
- Added missing static declarations for local functions
  (kernel test robot <lkp@intel.com>)
- Addressed static analyzer and review comments by Dan Carpenter
  (thanks, they were very useful!)
- Fix elif without defined() for !CONFIG_TCP_AO
- Recursively build selftests/net/tcp_ao (Shuah Khan), patches in:
  https://lore.kernel.org/all/20220919201958.279545-1-dima@arista.com/T/#u
- Don't leak crypto_pool reference when TCP-MD5 key is modified/changed
- Add TCP-AO support for nettest.c and fcnal-test.sh
  (will be used for VRF testing in later versions)

Comparison between Leonard proposal and this (overview):
https://lore.kernel.org/all/3cf03d51-74db-675c-b392-e4647fa5b5a6@arista.com/T/#u

Version 2: https://lore.kernel.org/all/20220923201319.493208-1-dima@arista.com/T/#u
Version 1: https://lore.kernel.org/all/20220818170005.747015-1-dima@arista.com/T/#u

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
used setsockopts to program per-socket keys, avoiding the extra complexity
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

[1]: https://lore.kernel.org/all/20220726201600.1715505-1-dima@arista.com/
[2]: https://lore.kernel.org/all/cover.1658815925.git.cdleonard@gmail.com/
[3]: https://github.com/0x7f454c46/iperf/tree/tcp-md5-ao

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Bob Gilligan <gilligan@arista.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
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

Dmitry Safonov (36):
  crypto: Introduce crypto_pool
  crypto_pool: Add crypto_pool_reserve_scratch()
  net/tcp: Separate tcp_md5sig_info allocation into
    tcp_md5sig_info_add()
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
  net/tcp-ao: Add static_key for TCP-AO
  selftests/net: Add TCP-AO library
  selftests/net: Verify that TCP-AO complies with ignoring ICMPs
  selftest/net: Add TCP-AO ICMPs accept test
  selftest/tcp-ao: Add a test for MKT matching
  selftest/tcp-ao: Add test for TCP-AO add setsockopt() command
  selftests/tcp-ao: Add TCP-AO + TCP-MD5 + no sign listen socket tests
  selftests/aolib: Add test/benchmark for removing MKTs
  selftests/nettest: Remove client_pw
  selftest/nettest: Rename md5_prefix* => auth_prefix*
  selftests/nettest: Add TCP-AO support
  selftests/fcnal-test.sh: Add TCP-AO tests

 crypto/Kconfig                                |   12 +
 crypto/Makefile                               |    1 +
 crypto/crypto_pool.c                          |  338 +++
 include/crypto/pool.h                         |   33 +
 include/linux/sockptr.h                       |   23 +
 include/linux/tcp.h                           |   30 +-
 include/net/dropreason.h                      |   25 +
 include/net/seg6_hmac.h                       |    7 -
 include/net/tcp.h                             |  195 +-
 include/net/tcp_ao.h                          |  305 +++
 include/uapi/linux/snmp.h                     |    5 +
 include/uapi/linux/tcp.h                      |   62 +
 net/ipv4/Kconfig                              |   14 +-
 net/ipv4/Makefile                             |    1 +
 net/ipv4/proc.c                               |    5 +
 net/ipv4/syncookies.c                         |    2 +
 net/ipv4/tcp.c                                |  197 +-
 net/ipv4/tcp_ao.c                             | 2038 +++++++++++++++++
 net/ipv4/tcp_input.c                          |  105 +-
 net/ipv4/tcp_ipv4.c                           |  404 +++-
 net/ipv4/tcp_minisocks.c                      |   37 +-
 net/ipv4/tcp_output.c                         |  192 +-
 net/ipv6/Kconfig                              |    2 +-
 net/ipv6/Makefile                             |    1 +
 net/ipv6/seg6.c                               |    3 -
 net/ipv6/seg6_hmac.c                          |  204 +-
 net/ipv6/syncookies.c                         |    2 +
 net/ipv6/tcp_ao.c                             |  151 ++
 net/ipv6/tcp_ipv6.c                           |  357 ++-
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/net/fcnal-test.sh     |  471 +++-
 tools/testing/selftests/net/nettest.c         |  217 +-
 tools/testing/selftests/net/tcp_ao/.gitignore |    2 +
 tools/testing/selftests/net/tcp_ao/Makefile   |   50 +
 .../selftests/net/tcp_ao/bench-lookups.c      |  403 ++++
 .../selftests/net/tcp_ao/connect-deny.c       |  217 ++
 tools/testing/selftests/net/tcp_ao/connect.c  |   81 +
 .../selftests/net/tcp_ao/icmps-accept.c       |    1 +
 .../selftests/net/tcp_ao/icmps-discard.c      |  446 ++++
 .../testing/selftests/net/tcp_ao/lib/aolib.h  |  336 +++
 .../selftests/net/tcp_ao/lib/netlink.c        |  341 +++
 tools/testing/selftests/net/tcp_ao/lib/proc.c |  267 +++
 .../testing/selftests/net/tcp_ao/lib/setup.c  |  343 +++
 tools/testing/selftests/net/tcp_ao/lib/sock.c |  294 +++
 .../testing/selftests/net/tcp_ao/lib/utils.c  |   30 +
 .../selftests/net/tcp_ao/setsockopt-closed.c  |  191 ++
 .../selftests/net/tcp_ao/unsigned-md5.c       |  524 +++++
 47 files changed, 8323 insertions(+), 643 deletions(-)
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


base-commit: 4dc12f37a8e98e1dca5521c14625c869537b50b6
-- 
2.38.1

