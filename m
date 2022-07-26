Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8254F580B02
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbiGZGPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiGZGPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:15:41 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A529D644C;
        Mon, 25 Jul 2022 23:15:39 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w5so4080824edd.13;
        Mon, 25 Jul 2022 23:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TBHNm+itT6V1xI3RXoopTxPFiKyF8tS1Yze0w6IdsN4=;
        b=k+AMX00NMCvEsZLU04hfPEilwVL49sA0Fc5RLdObq+S6gwHoqzymc4+u5YDKblzIHi
         S8XFV7IIVmQXV/lnHuprMiitLidliDZ32wnQpKBC4CQVFeKcw6zxTSOZOGrykykHw43P
         9/ULGLbKvNAzzf/gs3fm/wGTVlcvaTFe799ju8YGHnOQSefY899zVQYtQrd5vVj5eaZV
         2aoqPCngiUgG5UjMGHR32Vrxbg1fdfD0JdfOrIFJf2U4Kiqb92KahhYd4lSVN9DTckCQ
         DuSGldqba7rrdU5lPhH54UseerARf6GxPFtDT/AcitP18GCwn58WyJINqWVV06PLahDC
         AO8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TBHNm+itT6V1xI3RXoopTxPFiKyF8tS1Yze0w6IdsN4=;
        b=oGmFAmNpfDySnvFJCzWqUIpQj0I9ZPFZ5j0jreia1L8i2PXYJ5+Z4MUQSzJvxBAkYE
         q0aC19dDWjbpRx5EBnQUAq8bVtb7LIcNdltwZxMBJZD4ZxtBISN3/KMPvD2NSstdktXC
         vg87v63q4VxOibjpwakzV+bs4Jj6ciWrhTKHA4ApzOtzgq4hF+ajIFjjOH3d+dMukg+z
         DEnokZ+hfXcjvzwEPmWcdAKWFXQVtu0fDhvbtmk373jA/2FnmHDTxhyRDZi+OozVdyl1
         t6SdBtGLgtkF90dqfgRHsckhyWETkt07OA4Eb8F+totVZ+8vwkinapRN2FAQ03/BfN86
         L6Jg==
X-Gm-Message-State: AJIora/lbK40nDBY/YXdV2XaT05N6Ys3x5yn4rtrS1nAJczPBHKinbDh
        tF0MebMrig0wXoMge0ao1Ns=
X-Google-Smtp-Source: AGRyM1uYzfz4GaObUBBC1ARrZIlFbTy3jwGu9iuDuqVCAAmJFo038i44N5g34HGXSpU2hI/bgIGU4A==
X-Received: by 2002:a05:6402:48:b0:43a:caa8:756b with SMTP id f8-20020a056402004800b0043acaa8756bmr16407609edu.112.1658816138021;
        Mon, 25 Jul 2022 23:15:38 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:15:37 -0700 (PDT)
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
Subject: [PATCH v6 00/26] tcp: Initial support for RFC5925 auth option
Date:   Tue, 26 Jul 2022 09:15:02 +0300
Message-Id: <cover.1658815925.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
such as Cisco and Juniper.

The current code is largely feature complete and well-tested and
changes are relatively small compared to previous version. I should
have reposted this series earlier but was distracted by other things.

I'd welcome any advice for how to push this upstream. Only up to patch
13 is required for a minimal implementation, the rest are additional
features and tests. Maybe I could try posting reduced versions?


I've recently been talking with Phillip Paeps who is working on an BSD
implementation of the same standard and he suggested sharing ABI in
order to make userspace compatibility easier. The current ABI is
entirely made up by me alone.

One option would be to use PF_KEY because in FreeBSD PF_KEY is also used
for MD5, in a somewhat convoluted way. I'm not very familiar with PF_KEY
but perhaps a shim could be implemented inside linux PF_KEY support to
make some keys be handled in an entirely different way, using tcp_authopt
instead of xfrm. Does this make sense to anyone else?

A key difference versus MD5 is that keys are global rather than
per-socket. Older versions had per-socket keys but in practice
applications want to always use a consistent set of keys for communication
with a specific peer and keeping those keys in sync from userspace is
difficult and prone to races.

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
* No way to limit keys on a per-port basis (used to be implicit with
per-socket keys).
* Not clear if crypto_ahash_setkey might sleep. If some implementation
do that then maybe they could be excluded through alloc flags.
* Traffic key is not cached (reducing performance)
* No caching or hashing for key lookups so this will scale poorly with
many keys
* Overlaping MKTs can be configured despite what RFC5925 says
* Current key can be deleted. RFC says this shouldn't be allowed but
enforcing this belongs at an admin shell rather than in the kernel.
* If multiple keys are valid for a destination the kernel picks one
in an unpredictable manner (this can be overridden).

There is relatively little code sharing with the TCP_MD5SIG feature and
earlier versions shared even less. Unlike MD5 the AO feature is kept
separate from the rest of the TCP code and reusing code would require
many unrelated cleanup changes.

I'm not convinced that "authopt" is particularly good naming convention,
this name is a personal invention that does not appear anywhere else.
The RFC calls this "tcp-ao". Perhaps TCP_AOSIG would be a better name
and it would also make the close connection to TCP_MD5SIG more visible?

Some testing support is included in nettest and fcnal-test.sh, similar
to the current level of tcp-md5 testing.

A more elaborate test suite using pytest and scapy is available out of
tree: https://github.com/cdleonard/tcp-authopt-test
There is an automatic system that runs that test suite in vagrant in
gitlab-ci: https://gitlab.com/cdleonard/vagrantcpao

Changes for frr (obsolete): https://github.com/FRRouting/frr/pull/9442
That PR was made early for ABI feedback, it has many issues.

Changes for yabgp (obsolete): https://github.com/cdleonard/yabgp/commits/tcp_authopt
This was used for interoperability testing with cisco.

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
  tcp: authopt: Remove more unused noops
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
 include/uapi/linux/tcp.h                  |  165 ++
 net/ipv4/Kconfig                          |   14 +
 net/ipv4/Makefile                         |    1 +
 net/ipv4/proc.c                           |    1 +
 net/ipv4/sysctl_net_ipv4.c                |   39 +
 net/ipv4/tcp.c                            |  126 +-
 net/ipv4/tcp_authopt.c                    | 1952 +++++++++++++++++++++
 net/ipv4/tcp_input.c                      |   53 +-
 net/ipv4/tcp_ipv4.c                       |  100 +-
 net/ipv4/tcp_minisocks.c                  |   12 +
 net/ipv4/tcp_output.c                     |  106 +-
 net/ipv6/tcp_ipv6.c                       |   70 +-
 tools/testing/selftests/net/fcnal-test.sh |  329 +++-
 tools/testing/selftests/net/nettest.c     |  204 ++-
 24 files changed, 3546 insertions(+), 88 deletions(-)
 create mode 100644 Documentation/networking/tcp_authopt.rst
 create mode 100644 include/net/netns/tcp_authopt.h
 create mode 100644 include/net/tcp_authopt.h
 create mode 100644 net/ipv4/tcp_authopt.c

-- 
2.25.1

