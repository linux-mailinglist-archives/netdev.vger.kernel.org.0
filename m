Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF60441E49
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhKAQiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhKAQiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:03 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE66C061714;
        Mon,  1 Nov 2021 09:35:29 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id f4so8050740edx.12;
        Mon, 01 Nov 2021 09:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mU1tlVkvRk2rzHXUt3RLzLRijy+rDCkpf/ENb/PKkNU=;
        b=NwMXqt83Xm3naC6CWKmtAaFDBUyKYbeZ7oc9fQUcJOTU666DsdAYhh87MRGCQ1mnXY
         AeESFBRXMNovpYxxMwLJF6Q6UpYRp1f3c6PVfPfwG9l9tN0/LGOWF2p5W5djODRREHJd
         UVKmnA/HS+/gsfgK8UNdHJGXqfFpCdC9DI0m66rUoBXpi8Lp/Ya4rLG5XEm0rwulps/l
         Mv5URqgMKF1QCYfEJT9CuylsF4nRB6CPmdYd1f8/f+AP3ifU4KqIPIENlqDPlHxs2y5Y
         P65v7ZcEYsk9+O7hYViDaEfDn83LIqh9lWUR1HIr/tmTZUrxuBx3v3UlhDd/Dee1lXXx
         B0dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mU1tlVkvRk2rzHXUt3RLzLRijy+rDCkpf/ENb/PKkNU=;
        b=jQhjRHIUJtC/GoA73SPt6pWkXwOjra5mz5uiK/h7zYepFdAgfWu0PnbYIRktQimS+I
         mUbMkgOPFQZr/3Mikn0RHs82TLSq+7W+0OuxSM/hr5syE0mqm7jhteSfLouTLQ7TZjLK
         OOi1gLp+G8qjrRrnxZ3ehZxG56UdDOCR00+Cpvzv0TV8z0DpOLtydLZOQDjsTlPrf+8B
         62SBhbOgiD1O6OLmNzlexp+PRLeCKLdoHAzYJf0cVoxD3REYOnAwmDzGjj+fuGaMZgmT
         p1YLX+IZU+DGW7XjwOSBptnq80e6RyCbHkyoDjSvUYUh5Afg9agLlwGi1k7uLGvqHRo/
         Qbyg==
X-Gm-Message-State: AOAM530uATn0GjxANcPagCYc6SEI7Av4gEYuxCB2OTVQONpKgtUSEaWq
        rXHT79tQGvFLGLoxrc3/nCM=
X-Google-Smtp-Source: ABdhPJyRINa4v5TBAuTtCJMtWaVYI8TyI2tjWusaK/A+PuTXvUf9UmeyMuUbUfTIJnPGG5EfgxF4xw==
X-Received: by 2002:a17:907:6e0d:: with SMTP id sd13mr18694601ejc.482.1635784528420;
        Mon, 01 Nov 2021 09:35:28 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:27 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
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
Subject: [PATCH v2] tcp: Initial support for RFC5925 auth option
Date:   Mon,  1 Nov 2021 18:34:35 +0200
Message-Id: <cover.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is similar to TCP MD5 in functionality but it's sufficiently
different that wire formats are incompatible. Compared to TCP-MD5 more
algorithms are supported and multiple keys can be used on the same
connection but there is still no negotiation mechanism.

Expected use-case is protecting long-duration BGP/LDP connections
between routers using pre-shared keys. The goal of this series is to
allow routers using the linux TCP stack to interoperate with vendors
such as Cisco and Juniper.

Both algorithms described in RFC5926 are implemented but the code is not
very easily extensible beyond that. In particular there are several code
paths making stack allocations based on RFC5926 maximum, those would
have to be increased.

This version implements SNE and l3mdev awareness and adds more tests.
Here are some known flaws and limitations:

* Interaction with TCP-MD5 not tested in all corners
* Interaction with FASTOPEN not tested and unlikely to work because
sequence number assumptions for syn/ack.
* Not clear if crypto_shash_setkey might sleep. If some implementation
do that then maybe they could be excluded through alloc flags.
* Traffic key is not cached (reducing performance)
* User is responsible for ensuring keys do not overlap.
* There is no useful way to list keys, making userspace debug difficult.
* There is no prefixlen support equivalent to md5. This is used in
some complex FRR configs.

Test suite was added to tools/selftests/tcp_authopt. Tests are written
in python using pytest and scapy and check the API in some detail and
validate packet captures. Python code is already used in linux and in
kselftests but virtualenvs not very much, this particular test suite
uses `pip` to create a private virtualenv and hide dependencies.

This actually forms the bulk of the series by raw line-count. Since
there is a lot of code it was mostly split on "functional area" so most
files are only affected by a single code. A lot of those tests are
relevant to TCP-MD5 so perhaps it might help to split into a separate
series?

Some testing support is included in nettest and fcnal-test.sh, similar
to the current level of tcp-md5 testing.

SNE was tested by creating connections in a loop until a large SEQ is
randomly selected and then making it rollover. The "connect in a loop"
step ran into timewait overflow and connection failure on port reuse.
After spending some time on this issue and my conclusion is that AO
makes it impossible to kill remainders of old connections in a manner
similar to unsigned or md5sig, this is because signatures are dependent
on ISNs.  This means that if a timewait socket is closed improperly then
information required to RST the peer is lost.

The fact that AO completely breaks all connection-less RSTs is
acknowledged in the RFC and the workaround of "respect timewait" seems
acceptable.

Changes for frr (old): https://github.com/FRRouting/frr/pull/9442
That PR was made early for ABI feedback, it has many issues.

Changes for yabgp (old): https://github.com/cdleonard/yabgp/commits/tcp_authopt
This can be use for easy interoperability testing with cisco/juniper/etc.

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

Leonard Crestez (25):
  tcp: authopt: Initial support and key management
  docs: Add user documentation for tcp_authopt
  selftests: Initial tcp_authopt test module
  selftests: tcp_authopt: Initial sockopt manipulation
  tcp: authopt: Add crypto initialization
  tcp: authopt: Compute packet signatures
  tcp: Use BIT() for OPTION_* constants
  tcp: authopt: Hook into tcp core
  tcp: authopt: Disable via sysctl by default
  selftests: tcp_authopt: Test key address binding
  tcp: authopt: Implement Sequence Number Extension
  tcp: ipv6: Add AO signing for tcp_v6_send_response
  tcp: authopt: Add support for signing skb-less replies
  tcp: ipv4: Add AO signing for skb-less replies
  selftests: tcp_authopt: Implement SNE in python
  selftests: tcp_authopt: Add scapy-based packet signing code
  selftests: tcp_authopt: Add packet-level tests
  selftests: tcp_authopt: Initial sne test
  tcp: authopt: Add key selection controls
  selftests: tcp_authopt: Add tests for rollover
  tcp: authopt: Add initial l3index support
  selftests: tcp_authopt: Initial tests for l3mdev handling
  selftests: nettest: Rename md5_prefix to key_addr_prefix
  selftests: nettest: Initial tcp_authopt support
  selftests: net/fcnal: Initial tcp_authopt support

 Documentation/networking/index.rst            |    1 +
 Documentation/networking/ip-sysctl.rst        |    6 +
 Documentation/networking/tcp_authopt.rst      |   69 +
 include/linux/tcp.h                           |    9 +
 include/net/tcp.h                             |    1 +
 include/net/tcp_authopt.h                     |  271 +++
 include/uapi/linux/snmp.h                     |    1 +
 include/uapi/linux/tcp.h                      |  123 ++
 net/ipv4/Kconfig                              |   14 +
 net/ipv4/Makefile                             |    1 +
 net/ipv4/proc.c                               |    1 +
 net/ipv4/sysctl_net_ipv4.c                    |   10 +
 net/ipv4/tcp.c                                |   30 +
 net/ipv4/tcp_authopt.c                        | 1617 +++++++++++++++++
 net/ipv4/tcp_input.c                          |   18 +
 net/ipv4/tcp_ipv4.c                           |  104 +-
 net/ipv4/tcp_minisocks.c                      |   12 +
 net/ipv4/tcp_output.c                         |  100 +-
 net/ipv6/tcp_ipv6.c                           |   60 +-
 tools/testing/selftests/net/fcnal-test.sh     |  249 +++
 tools/testing/selftests/net/nettest.c         |  123 +-
 tools/testing/selftests/tcp_authopt/Makefile  |   10 +
 .../testing/selftests/tcp_authopt/README.rst  |   18 +
 tools/testing/selftests/tcp_authopt/config    |    6 +
 .../selftests/tcp_authopt/requirements.txt    |   46 +
 tools/testing/selftests/tcp_authopt/run.sh    |   31 +
 tools/testing/selftests/tcp_authopt/settings  |    1 +
 tools/testing/selftests/tcp_authopt/setup.cfg |   35 +
 tools/testing/selftests/tcp_authopt/setup.py  |    6 +
 .../tcp_authopt/tcp_authopt_test/__init__.py  |    0
 .../tcp_authopt/tcp_authopt_test/conftest.py  |   71 +
 .../full_tcp_sniff_session.py                 |   91 +
 .../tcp_authopt_test/linux_tcp_authopt.py     |  285 +++
 .../tcp_authopt_test/linux_tcp_md5sig.py      |  110 ++
 .../tcp_authopt_test/linux_tcp_repair.py      |   67 +
 .../tcp_authopt_test/netns_fixture.py         |   85 +
 .../tcp_authopt_test/scapy_conntrack.py       |  173 ++
 .../tcp_authopt_test/scapy_tcp_authopt.py     |  220 +++
 .../tcp_authopt_test/scapy_utils.py           |  177 ++
 .../tcp_authopt/tcp_authopt_test/server.py    |  124 ++
 .../tcp_authopt/tcp_authopt_test/sne_alg.py   |  111 ++
 .../tcp_authopt/tcp_authopt_test/sockaddr.py  |  122 ++
 .../tcp_connection_fixture.py                 |  276 +++
 .../tcp_authopt/tcp_authopt_test/test_bind.py |  155 ++
 .../tcp_authopt_test/test_rollover.py         |  181 ++
 .../tcp_authopt/tcp_authopt_test/test_sne.py  |  202 ++
 .../tcp_authopt_test/test_sne_alg.py          |   96 +
 .../tcp_authopt_test/test_sockopt.py          |  203 +++
 .../tcp_authopt_test/test_vectors.py          |  365 ++++
 .../tcp_authopt_test/test_verify_capture.py   |  559 ++++++
 .../tcp_authopt_test/test_vrf_bind.py         |  492 +++++
 .../tcp_authopt/tcp_authopt_test/utils.py     |  114 ++
 .../tcp_authopt/tcp_authopt_test/validator.py |  138 ++
 .../tcp_authopt_test/vrf_netns_fixture.py     |  127 ++
 54 files changed, 7471 insertions(+), 46 deletions(-)
 create mode 100644 Documentation/networking/tcp_authopt.rst
 create mode 100644 include/net/tcp_authopt.h
 create mode 100644 net/ipv4/tcp_authopt.c
 create mode 100644 tools/testing/selftests/tcp_authopt/Makefile
 create mode 100644 tools/testing/selftests/tcp_authopt/README.rst
 create mode 100644 tools/testing/selftests/tcp_authopt/config
 create mode 100644 tools/testing/selftests/tcp_authopt/requirements.txt
 create mode 100755 tools/testing/selftests/tcp_authopt/run.sh
 create mode 100644 tools/testing/selftests/tcp_authopt/settings
 create mode 100644 tools/testing/selftests/tcp_authopt/setup.cfg
 create mode 100644 tools/testing/selftests/tcp_authopt/setup.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/__init__.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/full_tcp_sniff_session.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_md5sig.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_repair.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/netns_fixture.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_conntrack.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_tcp_authopt.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_utils.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/server.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/sne_alg.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/sockaddr.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/tcp_connection_fixture.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_bind.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_rollover.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sne.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sne_alg.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vectors.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_verify_capture.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vrf_bind.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/utils.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/validator.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/vrf_netns_fixture.py


base-commit: d4a07dc5ac34528f292a4f328cf3c65aba312e1b
-- 
2.25.1

