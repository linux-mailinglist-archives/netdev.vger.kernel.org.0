Return-Path: <netdev+bounces-2266-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C930700F98
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 22:23:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E3481C21332
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 20:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E2ED14288;
	Fri, 12 May 2023 20:23:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B67A14275
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 20:23:26 +0000 (UTC)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E65D052
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:23:20 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-3077d134028so6130820f8f.3
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1683922999; x=1686514999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dexVUbxVMC/g4Gx5V0+YcxVS4qadt5atlQh9E/fcJsM=;
        b=b3eZvxG3rf+dxtbV65JljgAspnc01zbYIkzFOKjprVr8wZEWqKY2sATMkAOD2UgOSM
         BMbXUnYkY9BsG+luSh5KByrde+CGGLtwM/eHNIPAvEB3BxLTr43u43FKKRqeKqCgiY/w
         p1NGpbDu98NuqMPxb6zm6c9Bsdt8q70GXwub0yDblHj3pAQC+q7HimVyBT+sK/FvJ+v7
         Y5llyiWdtZcLgt6HYp40OjRdD1sCqjnEm3Aza64jZwgBV+TXfzOIgxfxES+wVQu+YgpB
         ti1ehB27jsA8YJQOuVEFH7fqPCFPiKFjASVKv7y90pEwU1TnT/eIDYfrQsDhu+7sa+4O
         p1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683922999; x=1686514999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dexVUbxVMC/g4Gx5V0+YcxVS4qadt5atlQh9E/fcJsM=;
        b=Xv0rItviIm2O4IAZkWaNl3F/qOg1rvzuQDlou2/0t7C/rx09KwuS1Dn/NlcvwKJ5Qd
         bSrPka0y4tFDtLdECSMjl6ZIwoeekYhemE7HM6Qg6aEFbqT9BqhKBUHpbBwnUVuPi4fT
         O9uA/kZwlwdHgekDdgRnLHL63WJDbXmSGrOCkblS7WARZpFm34fHZp3+6KmjIiDYNdsb
         iJWdm8QzH5+H2z5fqEPx0BIGfQrejbI3KnDzlRATmT4JTjebsUKb77dv+BxFjpu+vlAH
         l8EIJWICObiXKfChHdmSySCfi3Hz+pYMStbFMHPKm2HJaI2Q/DJyyvBhAIxPqEX89CjA
         kV/A==
X-Gm-Message-State: AC+VfDzd8p6HnJZLTnv6snFPcK7WGir+n4F+Cwt5UHH2J5HRIinzvP2l
	ZZyXgfUu/h+cyiG26Q7wLwZfCw==
X-Google-Smtp-Source: ACHHUZ6oWCK0e0RdqbxWYV7FMUJAgiYN8s6ubxlSxNeUNZRkT5MyewPrm0tY74c03bQZ4Wz0TBkeKg==
X-Received: by 2002:a5d:4d4f:0:b0:302:5d34:38a7 with SMTP id a15-20020a5d4d4f000000b003025d3438a7mr18616699wru.36.1683922998516;
        Fri, 12 May 2023 13:23:18 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n9-20020a05600c294900b003f423508c6bsm17304527wmd.44.2023.05.12.13.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 13:23:18 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: linux-kernel@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <dima@arista.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [PATCH v6 00/21] net/tcp: Add TCP-AO support
Date: Fri, 12 May 2023 21:22:50 +0100
Message-Id: <20230512202311.2845526-1-dima@arista.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is version 6 of TCP-AO support. The biggest change is
the adaptation of Herbert's crypto-clone-tfm patches [6].
They are already in v6.4-rc1, so I base this on Torvald's master.
It seems that at this moment all feedback that was given to previous
versions was addressed, the items in TODO list are the ones I intend
to fix "earlier" than "later".
Please, provide your inputs what's left to make it merge-ready.

Note, that I've sent another patches set, that touches send_reset()
and do_time_wait:
https://lore.kernel.org/all/20230509221608.2569333-1-dima@arista.com/T/#u
depending on those patches outcome, TCP-AO will be rebased on the top.

Here are iperf[3] benchmarks on my laptop for this version:
                           v6.4-rc1                 TCP-AO-v6
  TCP                      43.9 Gbits/sec           43.5 Gbits/sec
  TCP-MD5                  2.20 Gbits/sec           2.25 Gbits/sec
  TCP-AO(hmac(sha1))                                2.53 Gbits/sec
  TCP-AO(hmac(sha512))                              1.67 Gbits/sec
  TCP-AO(hmac(sha384))                              1.77 Gbits/sec
  TCP-AO(hmac(sha224))                              1.29 Gbits/sec
  TCP-AO(hmac(sha3-512))                             481 Mbits/sec
  TCP-AO(hmac(md5))                                 2.07 Gbits/sec
  TCP-AO(hmac(rmd160))                              1.01 Gbits/sec
  TCP-AO(cmac(aes128))                              2.11 Gbits/sec

All seem to be withing benchmark's variance, no performance regression
noticed.

In TODO:
- Documentation/ page about TCP-AO kernel design, UAPI
- setsockopt(TCP_REPAIR) with TCP-AO
- rebase TCP-AO's tcp_{v4,v6}_send_reset() part on TCP-MD5 changes 
  don't send non-signed RST or twsk segments when TCP-AO was used;
  never change any TCP state on non-verified segments on TCP-AO sk
- add a selftest for RST segments
- add a selftest for TIME-WAIT sockets
- provide crypto_clone_cipher() and drop per-CPU crypto request
  pre-allocation for cmac(aes128)

This is also available as a git branch for pull:
https://github.com/0x7f454c46/linux/tree/tcp-ao-v6
And another branch with selftests, that will be sent later separately:
https://github.com/0x7f454c46/linux/tree/tcp-ao-v6-with-selftests

Thanks for your time, reviews and to Herbert for new crypto-clone API,
         Dmitry

--- Changelog ---

Changes from v5:
- removed check for TCP_AO_KEYF_IFINDEX in delete command:
  VRF might have been destroyed, there still needs to be a way to delete
  keys that were bound to that l3intf (should tcp_v{4,6}_parse_md5_keys()
  avoid the same check as well?)
- corrected copy'n'paste typo in tcp_ao_info_cmd() (assign ao_info->rnext_key)
- simplified a bit tcp_ao_copy_mkts_to_user(); added more UAPI checks
  for getsockopt(TCP_AO_GET_KEYS)
- More UAPI selftests in setsockopt-closed: 29 => 120
- ported TCP-AO patches on Herbert's clone-tfm changes
- adjusted iperf patch for TCP-AO UAPI changes from version 5
- added measures for TCP-AO with tcp_sigpool & clone_tfm backends

Version 5: https://lore.kernel.org/all/20230403213420.1576559-1-dima@arista.com/T/#u

Changes from v4:
- Renamed tcp_ao_matched_key() => tcp_ao_established_key()
- Missed `static` in function definitions
  (kernel test robot <lkp@intel.com>)
- Fixed CONFIG_IPV6=m build
- Unexported tcp_md5_*_sigpool() functions
- Cleaned up tcp_ao.h: undeclared tcp_ao_cache_traffic_keys(),
  tcp_v4_ao_calc_key_skb(); removed tcp_v4_inbound_ao_hash()
- Marked "net/tcp: Prepare tcp_md5sig_pool for TCP-AO" as a [draft] patch
- getsockopt() now returns TCP-AO per-key counters
- Another getsockopt() now returns per-ao_info stats: counters
  and accept_icmps flag state
- Wired up getsockopt() returning counters to selftests
- Fixed a porting mistake: TCP-AO hash in some cases was written in TCP
  header without accounting for MAC length of the key, rewritting skb
  shared info
- Fail adding a key with L3 ifindex when !TCP_AO_KEYF_IFINDEX, instead
  of ignoring tcpa_ifindex (stricter UAPI check)
- Added more test-cases to setsockopt-closed.c selftest
- tcp_ao_hash_skb_data() was a copy'n'paste of tcp_md5_hash_skb_data()
  share it now under tcp_sigpool_hash_skb_data()
- tcp_ao_mkt_overlap_v{4,6}() deleted as they just re-invented
  tcp_ao_do_lookup(). That fixes an issue with multiple IPv4-mapped-IPv6
  keys for different peers on a listening socket.
- getsockopt() now is tested to return correct VRF number for a key
- TCP-AO and TCP-MD5 interraction in non/default VRFs: added +19 selftests
  made them SKIP when CONFIG_VRF=n
- unsigned-md5 selftests now checks both scenarios:
  (1) adding TCP-AO key _after_ TCP-MD5 key
  (2) adding TCP-MD5 key _after_ TCP-AO key
- Added a ratelimited warning if TCP-AO key.ifindex doesn't match
  sk->sk_bound_dev_if - that will warn a user for potential VRF issues
- tcp_v{4,6}_parse_md5_keys() now allows adding TCP-MD5 key with
  ifindex=0 and TCP_MD5SIG_FLAG_IFINDEX together with TCP-AO key from
  another VRF
- Add TCP_AO_CMDF_AO_REQUIRED, which makes a socket TCP-AO only,
  rejecting TCP-MD5 keys or any unsigned TCP segments
- Remove `tcpa_' prefix for UAPI structure members
- UAPI cleanup: I've separated & renamed per-socket settings
  (such as ao_info flags + current/rnext set) from per-key changes:
  TCP_AO     => TCP_AO_ADD_KEY
  TCP_AO_DEL => TCP_AO_DEL_KEY
  TCP_AO_GET => TCP_AO_GET_KEYS
  TCP_AO_MOD => TCP_AO_INFO, the structure is now valid for both
                getsockopt() and setsockopt().
- tcp_ao_current_rnext() was split up in order to fail earlier when
  sndid/rcvid specified can't be set, before anything was changed in ao_info
- fetch current_key before dumping TCP-AO keys in getsockopt(TCP_AO_GET_KEYS):
  it may race with changing current_key by RX, which in result might
  produce a dump with no current_key for userspace.
- instead of TCP_AO_CMDF_* flags, used bitfileds: the flags weren't
  shared between all TCP_AO_{ADD,GET,DEL}_KEY{,S}, so bitfields are more
  descriptive here
- use READ_ONCE()/WRITE_ONCE() for current_key and rnext_key more
  consistently; document in comment the rules for accessing them
- selftests: check all setsockopts()/getsockopts() support extending
  option structs

Version 4: https://lore.kernel.org/all/20230215183335.800122-1-dima@arista.com/T/#u

Changes from v3:
- TCP_MD5 dynamic static key enable/disable patches merged separately [4]
- crypto_pool patches were nacked [5], so instead this patch set extends
  TCP-MD5-sigpool to be used for TCP-AO as well as for TCP-MD5
- Added missing `static' for tcp_v6_ao_calc_key()
  (kernel test robot <lkp@intel.com>)
- Removed CONFIG_TCP_AO default=y and added "If unsure, say N."
- Don't leak ao_info and don't create an unsigned TCP socket if there was
  a TCP-AO key during handshake, but it was removed from listening socket
  while the connection was being established
- Migrate to use static_key_fast_inc_not_disabled() and check return
  code of static_branch_inc()
- Change some return codes to EAFNOSUPPORT for error-pathes where
  family is neither AF_INET nor AF_INET6
- setsockopt()s on a closed/listen socket might have created stray ao_info,
  remove it if connect() is called with a correct TCP-MD5 key, the same
  for the reverse situation: remove md5sig_info straight away from the
  socket if it's going to be TCP-AO connection
- IPv4-mapped-IPv6 addresses + selftest in fcnal-test.sh (by Salam)
- fix using uninitialized sisn/disn from stack - it would only make
  non-SYN packets fail verification on a listen socket, which are not
  expected anyway (kernel test robot <lkp@intel.com>)
- implicit padding in UAPI TCP-AO structures converted to explicit
  (spotted-by David Laight)
- Some selftests missed zero-initializers for uapi structs on stack
- Removed tcp_ao_do_lookup_rcvid() and tcp_ao_do_lookup_sndid() in
  favor of unified tcp_ao_matched_key()
- Disallowed setting current/rnext keys on listen sockets - that wasn't
  supported and didn't affect anything, cleanup for the UAPI
- VRFs support for TCP-AO

Version 3: https://lore.kernel.org/all/20221027204347.529913-1-dima@arista.com/T/#u

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

Version 2: https://lore.kernel.org/all/20220923201319.493208-1-dima@arista.com/T/#u

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
[4]: https://lore.kernel.org/all/166995421700.16716.17446147162780881407.git-patchwork-notify@kernel.org/T/#u
[5]: https://lore.kernel.org/all/Y8kSkW4X4vQdFyOl@gondor.apana.org.au/T/#u
[6]: https://lore.kernel.org/all/ZDefxOq6Ax0JeTRH@gondor.apana.org.au/T/#u

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Bob Gilligan <gilligan@arista.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David Laight <David.Laight@aculab.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Francesco Ruggeri <fruggeri05@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Ivan Delalande <colona@arista.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Leonard Crestez <cdleonard@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Salam Noureddine <noureddine@arista.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Dmitry Safonov (21):
  net/tcp: Prepare tcp_md5sig_pool for TCP-AO
  net/tcp: Add TCP-AO config and structures
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
  net/tcp: Add TCP-AO getsockopt()s
  net/tcp: Allow asynchronous delete for TCP-AO keys (MKTs)
  net/tcp: Add static_key for TCP-AO
  net/tcp: Wire up l3index to TCP-AO

 include/linux/sockptr.h       |   23 +
 include/linux/tcp.h           |   30 +-
 include/net/dropreason-core.h |   30 +
 include/net/tcp.h             |  224 +++-
 include/net/tcp_ao.h          |  317 +++++
 include/uapi/linux/snmp.h     |    5 +
 include/uapi/linux/tcp.h      |   97 ++
 net/ipv4/Kconfig              |   17 +
 net/ipv4/Makefile             |    2 +
 net/ipv4/proc.c               |    5 +
 net/ipv4/syncookies.c         |    4 +
 net/ipv4/tcp.c                |  226 ++--
 net/ipv4/tcp_ao.c             | 2145 +++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c          |  104 +-
 net/ipv4/tcp_ipv4.c           |  360 ++++--
 net/ipv4/tcp_minisocks.c      |   35 +-
 net/ipv4/tcp_output.c         |  226 +++-
 net/ipv4/tcp_sigpool.c        |  462 +++++++
 net/ipv6/Makefile             |    1 +
 net/ipv6/syncookies.c         |    5 +
 net/ipv6/tcp_ao.c             |  156 +++
 net/ipv6/tcp_ipv6.c           |  374 ++++--
 22 files changed, 4478 insertions(+), 370 deletions(-)
 create mode 100644 include/net/tcp_ao.h
 create mode 100644 net/ipv4/tcp_ao.c
 create mode 100644 net/ipv4/tcp_sigpool.c
 create mode 100644 net/ipv6/tcp_ao.c


base-commit: 47a2ee5d4a0bda05decdda7be0a77e792cdb09a3
-- 
2.40.0


