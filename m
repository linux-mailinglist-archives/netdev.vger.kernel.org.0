Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CA6598D08
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245733AbiHRUAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiHRUAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:00:19 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F38CD11D4;
        Thu, 18 Aug 2022 13:00:18 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gk3so5172672ejb.8;
        Thu, 18 Aug 2022 13:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=CQ3cDlGI20sRjmx6kJdbD0nMrqU8+ddkQlKCP8IAvlo=;
        b=i7nDM1U/d2W4Mj6IVQWh68CpwhGrUx9cvCRih2I0B2NA2pYMmpDb33Z8U/BX4ebbIo
         A0t3JyWjXZuI3iN8gJHbenOzAuwHNJgzpTWu+S/8+5Ls5Ipa29vPVFU2kedOoRXZ6FfC
         0rtcWyRf1wdgiboM/TIg/HaQLXM93ffNso9sw+e3T6Puy4GgoKzGpSXD33RtJxEAuE5X
         wExX8C+higvLRzbqZiPCQw+xyAsxlAWc5Q2b7KAReJv/ra2b6tf53il9D4teoW+ofNUz
         DGGyJxDBhB3BjRfjx658nnLqSc+7Qv9EwspYmieq1CwUES4MIohSBcR71RbLIfqPieOg
         HGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=CQ3cDlGI20sRjmx6kJdbD0nMrqU8+ddkQlKCP8IAvlo=;
        b=T33OWqxCWZZBrkEsyfXCwtG9AM80LTiI9PXDxG49W9otvdEFZNH3NyzO9vcN/VCYO9
         wQOqmi3VJxcxP+umOvBw+LtBtFN6Zg9MlczlksXvmj1DtbQiPJgIwvTJDJNMw2SurLGd
         pJBIIQMWguP8z/4jnbzSFvxkXNLwuHkofwOFDZbq7vNRAzsRH9zl6CJsgKAGVEpkv5HY
         f1qJD28IB7EaU4YctqTjWAnRdoiel1q7NVZfeDkDF2cadLLMTnFzYtCG+XDmLNsOtPFe
         eMlruLbgSB7Jm9bwzPdSerROVnQ5BfWSFyTCPhsc5Rs2MZk0hw6o0tSEMXaZKlk9o+0G
         0+mg==
X-Gm-Message-State: ACgBeo3MaaS2AXgw3ZNjkb+9KwiF/aWkCrD/ZD02ZlLoqK9BIbAUu/yc
        lyGRSM1lDW7kE445KvBPEM0=
X-Google-Smtp-Source: AA6agR6DBJSOFPFV9C3+zzpYb3fGnr25rPZ7eYoCfzT373gilfHVuB+uO6KFwAKQvz0FfDHMpENMCA==
X-Received: by 2002:a17:907:284a:b0:731:5a2f:655a with SMTP id el10-20020a170907284a00b007315a2f655amr2768527ejc.403.1660852816455;
        Thu, 18 Aug 2022 13:00:16 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:15 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
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
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 00/26] tcp: Initial support for RFC5925 auth option
Date:   Thu, 18 Aug 2022 22:59:34 +0300
Message-Id: <cover.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is similar to TCP-MD5 in functionality but it's sufficiently
different that packet formats and interfaces are incompatible.
Compared to TCP-MD5 more algorithms are supported and multiple keys
can be used on the same connection but there is still no negotiation
mechanism.

Expected use-case is protecting long-duration BGP/LDP connections
between routers using pre-shared keys. The goal of this series is to
allow routers using the Linux TCP stack to interoperate with vendors
such as Cisco and Juniper. An fully-featured userspace implementation
using this patchset exists but it is not going to be published.

A completely unrelated series that implements the same features was posted
recently: https://lore.kernel.org/netdev/20220818170005.747015-1-dima@arista.com/

Despite receiving a few review comments from the people that worked on
that series I had no idea that they had their own implementation. I never
ran into an issue of conflicting patches before so don't know what to do
about it. Maybe I should have moved faster?


I've recently been talking with Phillip Paeps who is working on an BSD
implementation of the same standard and he suggested sharing ABI in
order to make userspace compatibility easier. The current ABI is
entirely made up by me alone.

A key difference versus MD5 is that keys are global rather than
per-socket. Older versions had per-socket keys but in practice
applications want to always use a consistent set of keys for communication
with a specific peer and keeping those keys in sync from userspace is
difficult and prone to races. The implementation from Arista uses
per-socket keys and dumps additional difficulty on userspace, I consider
both choices to be valid.

Other vendors supporting TCP-AO implement a notion of a "key chain"
roughly similar to what is described in RFC8177. The current ABI is
sufficient to do the same but it requires a bunch of userspace work
to add and delete keys at the appropriate time or mark them as "NOSEND"
and "NORECV". Userspace also has to insert a "dummy" key when all other
keys are expired in order to prevent unsigned traffic going through. This
feature might be considerably easier to use from userspace if validity
times were added in the kernel for each key.


Here are some known flaws and limitations:

* Crypto API is used with buffers on the stack and inside struct sock,
this might not work on all arches. I'm currently only testing x64 VMs
* Interaction with FASTOPEN not tested and unlikely to work because
sequence number assumptions for syn/ack.
* Traffic key is not cached (reducing performance)
* No caching or hashing for key lookups so this will scale poorly with
many keys
* Overlaping MKTs can be configured despite what RFC5925 says
* Current key can be deleted. RFC says this shouldn't be allowed but
enforcing this belongs at an admin shell rather than in the kernel.
* If multiple keys are valid for a destination the kernel picks one
in an unpredictable manner (this can be overridden).

There is deliberately very little code sharing with the TCP_MD5SIG
feature because I wanted to avoid complex unrelated refactoring.

Some testing support is included in nettest and fcnal-test.sh, similar
to the current level of tcp-md5 testing.

A more elaborate test suite using pytest and scapy is available out of
tree: https://github.com/cdleonard/tcp-authopt-test
There is an automatic system that runs that test suite in vagrant in
gitlab-ci: https://gitlab.com/cdleonard/vagrantcpao
That test suite fully covers the ABI of this patchset.

Changes for frr (obsolete): https://github.com/FRRouting/frr/pull/9442
That PR was made early for ABI feedback, it has many issues.

Changes for yabgp (obsolete): https://github.com/cdleonard/yabgp/commits/tcp_authopt
This was used for interoperability testing with cisco.
Would need updates for global keys to avoid leaks.

Changes since PATCH v6:
* Squash "remove unused noops" patch (forgot to do this before v5 send).
* Make TCP_REPAIR_AUTHOPT fail if (!tp->repair)
* Add {snd,rcv}_seq to struct tcp_repair_authopt next to {snd,rcv}_sne.
The fact that internally snd_sne is maintained as a 64-bit extension of
sne_nxt is a problem for TCP_REPAIR implementation in userspace which might
not have access to snd_nxt during live traffic. By exposing a full 64-bit
“recent sequence number” to userspace it's possible to ignore which exact
SEQ number the SNE value is an extension of.
* Fix ipv6_addr_is_prefix helper; it was incorrect and dependant on
uninitialized stack memory. This was caught by test suite after many rebases.
* Implement ipv4-mapped-ipv6 support, request by Eric Dumazet
Link: https://lore.kernel.org/netdev/cover.1658815925.git.cdleonard@gmail.com/

Changes since PATCH v5:
* Rebased on recent net-next, including recent changes refactoring md5
* Use to skb_drop_reason
* Fix using sock_kmalloc for key alloc but regular kfree for free. Use kmalloc
because keys are global
* Fix mentioning non-existent copy_from_sockopt in doc for _copy_from_sockptr_tolerant
* If no valid keys are available for a destination then report a socket error
instead of sending unsigned traffic
* Remove several noop implementations which are always called from ifdef
* Fix build issues in all scenarios, including -Werror at every point.
* Split "tcp: Refactor tcp_inbound_md5_hash into tcp_inbound_sig_hash" into a separate commit.
* Add TCP_AUTHOPT_FLAG_ACTIVE to distinguish between "keys configured for socket"
and "connection authenticated". A listen socket with authentication enabled will return
other sockets with authentication enabled on accept() but if no key is configured for the
peer then authentication will be inactive.
* Add support for TCP_REPAIR_AUTHOPT new sockopts which loads/saves the AO-specific
information.
Link: https://lore.kernel.org/netdev/cover.1643026076.git.cdleonard@gmail.com/

Changes since PATCH v4:
* Move the traffic_key context_bytes header to stack. If it's a constant
string then ahash can fail unexpectedly.
* Fix allowing unsigned traffic if all keys are marked norecv.
* Fix crashing in __tcp_authopt_alg_init on failure.
* Try to respect the rnextkeyid from SYN on SYNACK (new patch)
* Fix incorrect check for TCP_AUTHOPT_KEY_DEL in __tcp_authopt_select_key
* Improve docs on __tcp_authopt_select_key
* Fix build with CONFIG_PROC_FS=n (kernel build robot)
* Fix build with CONFIG_IPV6=n (kernel build robot)
Link: https://lore.kernel.org/netdev/cover.1640273966.git.cdleonard@gmail.com/

Changes since PATCH v3:
* Made keys global (per-netns rather than per-sock).
* Add /proc/net/tcp_authopt with a table of keys (not sockets).
* Fix part of the shash/ahash conversion having slipped from patch 3 to patch 5
* Fix tcp_parse_sig_options assigning NULL incorrectly when both MD5 and AO
are disabled (kernel build robot)
* Fix sparse endianness warnings in prefix match (kernel build robot)
* Fix several incorrect RCU annotations reported by sparse (kernel build robot)
Link: https://lore.kernel.org/netdev/cover.1638962992.git.cdleonard@gmail.com/

Changes since PATCH v2:
* Protect tcp_authopt_alg_get/put_tfm with local_bh_disable instead of
preempt_disable. This caused signature corruption when send path executing
with BH enabled was interrupted by recv.
* Fix accepted keyids not configured locally as "unexpected". If any key
is configured that matches the peer then traffic MUST be signed.
* Fix issues related to sne rollover during handshake itself. (Francesco)
* Implement and test prefixlen (David)
* Replace shash with ahash and reuse some of the MD5 code (Dmitry)
* Parse md5+ao options only once in the same function (Dmitry)
* Pass tcp_authopt_info into inbound check path, this avoids second rcu
dereference for same packet.
* Pass tcp_request_socket into inbound check path instead of just listen
socket. This is required for SNE rollover during handshake and clearifies
ISN handling.
* Do not allow disabling via sysctl after enabling once, this is difficult
to support well (David)
* Verbose check for sysctl_tcp_authopt (Dmitry)
* Use netif_index_is_l3_master (David)
* Cleanup ipvx_addr_match (David)
* Add a #define tcp_authopt_needed to wrap static key usage because it looks
nicer.
* Replace rcu_read_lock with rcu_dereference_protected in SNE updates (Eric)
* Remove test suite
Link: https://lore.kernel.org/netdev/cover.1635784253.git.cdleonard@gmail.com/

Changes since PATCH v1:
* Implement Sequence Number Extension
* Implement l3index for vrf: TCP_AUTHOPT_KEY_IFINDEX as equivalent of
TCP_MD5SIG_FLAG_IFINDEX
* Expand TCP-AO tests in fcnal-test.sh to near-parity with md5.
* Show addr/port on failure similar to md5
* Remove tox dependency from test suite (create venv directly)
* Switch default pytest output format to TAP (kselftest standard)
* Fix _copy_from_sockptr_tolerant stack corruption on short sockopts.
This was covered in test but error was invisible without STACKPROTECTOR=y
* Fix sysctl_tcp_authopt check in tcp_get_authopt_val before memset. This
was harmless because error code is checked in getsockopt anyway.
* Fix dropping md5 packets on all sockets with AO enabled
* Fix checking (key->recv_id & TCP_AUTHOPT_KEY_ADDR_BIND) instead of
key->flags in tcp_authopt_key_match_exact
* Fix PATCH 1/19 not compiling due to missing "int err" declaration
* Add ratelimited message for AO and MD5 both present
* Export all symbols required by CONFIG_IPV6=m (again)
* Fix compilation with CONFIG_TCP_AUTHOPT=y CONFIG_TCP_MD5SIG=n
* Fix checkpatch issues
* Pass -rrequirements.txt to tox to avoid dependency variation.
Link: https://lore.kernel.org/netdev/cover.1632240523.git.cdleonard@gmail.com/

Changes since RFCv3:
* Implement TCP_AUTHOPT handling for timewait and reset replies. Write
tests to execute these paths by injecting packets with scapy
* Handle combining md5 and authopt: if both are configured use authopt.
* Fix locking issues around send_key, introduced in on of the later patches.
* Handle IPv4-mapped-IPv6 addresses: it used to be that an ipv4 SYN sent
to an ipv6 socket with TCP-AO triggered WARN
* Implement un-namespaced sysctl disabled this feature by default
* Allocate new key before removing any old one in setsockopt (Dmitry)
* Remove tcp_authopt_key_info.local_id because it's no longer used (Dmitry)
* Propagate errors from TCP_AUTHOPT getsockopt (Dmitry)
* Fix no-longer-correct TCP_AUTHOPT_KEY_DEL docs (Dmitry)
* Simplify crypto allocation (Eric)
* Use kzmalloc instead of __GFP_ZERO (Eric)
* Add static_key_false tcp_authopt_needed (Eric)
* Clear authopt_info copied from oldsk in __tcp_authopt_openreq (Eric)
* Replace memcmp in ipv4 and ipv6 addr comparisons (Eric)
* Export symbols for CONFIG_IPV6=m (kernel test robot)
* Mark more functions static (kernel test robot)
* Fix build with CONFIG_PROVE_RCU_LIST=y (kernel test robot)
Link: https://lore.kernel.org/netdev/cover.1629840814.git.cdleonard@gmail.com/

Changes since RFCv2:
* Removed local_id from ABI and match on send_id/recv_id/addr
* Add all relevant out-of-tree tests to tools/testing/selftests
* Return an error instead of ignoring unknown flags, hopefully this makes
it easier to extend.
* Check sk_family before __tcp_authopt_info_get_or_create in tcp_set_authopt_key
* Use sock_owned_by_me instead of WARN_ON(!lockdep_sock_is_held(sk))
* Fix some intermediate build failures reported by kbuild robot
* Improve documentation
Link: https://lore.kernel.org/netdev/cover.1628544649.git.cdleonard@gmail.com/

Changes since RFC:
* Split into per-topic commits for ease of review. The intermediate
commits compile with a few "unused function" warnings and don't do
anything useful by themselves.
* Add ABI documention including kernel-doc on uapi
* Fix lockdep warnings from crypto by creating pools with one shash for
each cpu
* Accept short options to setsockopt by padding with zeros; this
approach allows increasing the size of the structs in the future.
* Support for aes-128-cmac-96
* Support for binding addresses to keys in a way similar to old tcp_md5
* Add support for retrieving received keyid/rnextkeyid and controling
the keyid/rnextkeyid being sent.
Link: https://lore.kernel.org/netdev/01383a8751e97ef826ef2adf93bfde3a08195a43.1626693859.git.cdleonard@gmail.com/

Leonard Crestez (26):
  tcp: authopt: Initial support and key management
  docs: Add user documentation for tcp_authopt
  tcp: authopt: Add crypto initialization
  tcp: Refactor tcp_sig_hash_skb_data for AO
  tcp: authopt: Compute packet signatures
  tcp: Refactor tcp_inbound_md5_hash into tcp_inbound_sig_hash
  tcp: authopt: Hook into tcp core
  tcp: authopt: Disable via sysctl by default
  tcp: authopt: Implement Sequence Number Extension
  tcp: ipv6: Add AO signing for tcp_v6_send_response
  tcp: authopt: Add support for signing skb-less replies
  tcp: ipv4: Add AO signing for skb-less replies
  tcp: authopt: Add key selection controls
  tcp: authopt: Add initial l3index support
  tcp: authopt: Add NOSEND/NORECV flags
  tcp: authopt: Add prefixlen support
  tcp: authopt: Add v4mapped ipv6 address support
  tcp: authopt: Add /proc/net/tcp_authopt listing all keys
  selftests: nettest: Rename md5_prefix to key_addr_prefix
  selftests: nettest: Initial tcp_authopt support
  selftests: net/fcnal: Initial tcp_authopt support
  tcp: authopt: Try to respect rnextkeyid from SYN on SYNACK
  tcp: authopt: tcp_authopt_lookup_send: Add anykey output param
  tcp: authopt: Initial support for TCP_AUTHOPT_FLAG_ACTIVE
  tcp: authopt: If no keys are valid for send report an error
  tcp: authopt: Initial implementation of TCP_REPAIR_AUTHOPT

 Documentation/networking/index.rst        |    1 +
 Documentation/networking/ip-sysctl.rst    |    6 +
 Documentation/networking/tcp_authopt.rst  |   88 +
 include/linux/tcp.h                       |   15 +
 include/net/dropreason.h                  |   16 +
 include/net/net_namespace.h               |    4 +
 include/net/netns/tcp_authopt.h           |   12 +
 include/net/tcp.h                         |   55 +-
 include/net/tcp_authopt.h                 |  264 +++
 include/uapi/linux/snmp.h                 |    1 +
 include/uapi/linux/tcp.h                  |  169 ++
 net/ipv4/Kconfig                          |   14 +
 net/ipv4/Makefile                         |    1 +
 net/ipv4/proc.c                           |    1 +
 net/ipv4/sysctl_net_ipv4.c                |   39 +
 net/ipv4/tcp.c                            |  126 +-
 net/ipv4/tcp_authopt.c                    | 1980 +++++++++++++++++++++
 net/ipv4/tcp_input.c                      |   55 +-
 net/ipv4/tcp_ipv4.c                       |  100 +-
 net/ipv4/tcp_minisocks.c                  |   12 +
 net/ipv4/tcp_output.c                     |  106 +-
 net/ipv6/tcp_ipv6.c                       |   70 +-
 tools/testing/selftests/net/fcnal-test.sh |  329 +++-
 tools/testing/selftests/net/nettest.c     |  204 ++-
 24 files changed, 3580 insertions(+), 88 deletions(-)
 create mode 100644 Documentation/networking/tcp_authopt.rst
 create mode 100644 include/net/netns/tcp_authopt.h
 create mode 100644 include/net/tcp_authopt.h
 create mode 100644 net/ipv4/tcp_authopt.c

--
2.25.1
