Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF943413714
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbhIUQRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbhIUQRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:17:50 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0B4C061756;
        Tue, 21 Sep 2021 09:16:21 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id u27so4125480edi.9;
        Tue, 21 Sep 2021 09:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bo193j9WkJUseteBvAhrYoO7Qa88YBRwtbT9jsrq7Ns=;
        b=P5+v8uHdnw4dI4XEd47Qzv+7dqHBkJJPemogaNdM1nqoNtBG8gp1LMPnaabUqGIDF/
         cBQj80Cq9QYYxTM5WeoSw5tkdZjDr3hZivtPfimyrEHwnN9xZDh2jtdsr2i+s5rMEZgh
         A3C/RLPmKarQFMV85hBOz6rpzQ6ewF/iuHYcZoPkOX6NEl6vuyizSCbqir9cXOdFuJ2l
         N0rvR2qG3GEpW6DRiEE1mOCMuaPblOes8xL/BG07EFInUXZWolPPyOamVA58Bf5jk8gk
         Mmo+jPwvXi1YC+bPblnEXQb8raqb4+KrcbzN7QU/X60+6SJ8IZQthZXXFcipot8AKCJ0
         d00A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bo193j9WkJUseteBvAhrYoO7Qa88YBRwtbT9jsrq7Ns=;
        b=7Ld4KrKdFqajrOpf928HkecjW3AmZTAtvoe0vzHdYM/Fxmvtxf+KNH8eYHKsMO1BcX
         U5lWn0i0tTu3d292su8wKO9/cLye/LPIULdZA5GLKSl8B56SLFGoSSI+E79xwu00xLtg
         UpLQOfQ2RYt2AHYZL6WLrvIftau+6cqgTofOjGLVtVCkY0Hmh+9J2SeB25/AHlyQ2w2a
         M9bhmDEYF1KDRZSlwDRogsXUcLKoR+yJsV0EUt+xDWHnjVHJRThNCPrEGUiC4SSe1NdK
         8/XTQX3oQF8diO8nZUbMMD9qS42JJVFBtVqPv+QwRLbolPiztSKdzSRSk8Hg4r4qdQE3
         niUg==
X-Gm-Message-State: AOAM531FJZNBa+Ga/htqfCY7PRZufPMnxRT5WLlBgHTF4d9zno3QzctY
        hsE8kBa1KoPQqW6XQMY9lUg=
X-Google-Smtp-Source: ABdhPJxhkMPeddMIJVJdgN+fpybQqToKuDhxTr/PPpJln8PJV1V8VnkWGneXixFYeokEWA6iCoLl1g==
X-Received: by 2002:a17:907:3e03:: with SMTP id hp3mr34886161ejc.183.1632240915037;
        Tue, 21 Sep 2021 09:15:15 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:14 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
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
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/19] tcp: Initial support for RFC5925 auth option
Date:   Tue, 21 Sep 2021 19:14:43 +0300
Message-Id: <cover.1632240523.git.cdleonard@gmail.com>
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

This version is incorporates previous feedback and expands the handling
of timewait sockets and RST packets. Here are some known flaws and
limits:

* Interaction with TCP-MD5 is not tested in all corners
* Interaction with FASTOPEN not tested but unlikely to work because
sequence number assumptions for syn/ack.
* Sequence Number Extension not implemented so connections will flap
every ~4G of traffic.
* Not clear if crypto_shash_setkey might sleep. If some implementation
do that then maybe they could be excluded through alloc flags.
* Traffic key is not cached (reducing performance)
* User is responsible for ensuring keys do not overlap

I labeled this as [PATCH]] because the issues above are not critical.

Test suite was added to tools/selftests/tcp_authopt. Tests are written
in python using pytest and scapy and check the API in some detail and
validate packet captures. Python code is already used in linux and in
kselftests but virtualenvs not very much. This test suite uses `tox` to
create a private virtualenv and hide dependencies. There is no clear
guidance for how to add python-based kselftests so I made it up.

Limited testing support is also included in nettest and fcnal-test.sh.
Coverage is extremely limited, I did not expand it because the tests run
too slowly.

Changes for frr: https://github.com/FRRouting/frr/pull/9442
That PR was made early for ABI feedback, it has many issues.

Changes for yabgp: https://github.com/cdleonard/yabgp/commits/tcp_authopt
This can be use for easy interoperability testing with cisco/juniper/etc.

Changes since RFCv3:
* Implement TCP_AUTHOPT handling for timewait and reset replies. Write
tests to execute these paths by injecting packets with scapy
* Handle combining md5 and authopt: if both are configured use authopt.
* Fix locking issues around send_key, introduced in on of the later
patches.
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

Leonard Crestez (19):
  tcp: authopt: Initial support and key management
  docs: Add user documentation for tcp_authopt
  selftests: Initial tcp_authopt test module
  selftests: tcp_authopt: Initial sockopt manipulation
  tcp: authopt: Add crypto initialization
  tcp: authopt: Compute packet signatures
  tcp: authopt: Hook into tcp core
  tcp: authopt: Disable via sysctl by default
  selftests: tcp_authopt: Test key address binding
  tcp: ipv6: Add AO signing for tcp_v6_send_response
  tcp: authopt: Add support for signing skb-less replies
  tcp: ipv4: Add AO signing for skb-less replies
  selftests: tcp_authopt: Add scapy-based packet signing code
  selftests: tcp_authopt: Add packet-level tests
  selftests: Initial tcp_authopt support for nettest
  selftests: Initial tcp_authopt support for fcnal-test
  selftests: Add -t tcp_authopt option for fcnal-test.sh
  tcp: authopt: Add key selection controls
  selftests: tcp_authopt: Add tests for rollover

 Documentation/networking/index.rst            |    1 +
 Documentation/networking/ip-sysctl.rst        |    6 +
 Documentation/networking/tcp_authopt.rst      |   69 +
 include/linux/tcp.h                           |    9 +
 include/net/tcp.h                             |    1 +
 include/net/tcp_authopt.h                     |  200 +++
 include/uapi/linux/snmp.h                     |    1 +
 include/uapi/linux/tcp.h                      |  110 ++
 net/ipv4/Kconfig                              |   14 +
 net/ipv4/Makefile                             |    1 +
 net/ipv4/proc.c                               |    1 +
 net/ipv4/sysctl_net_ipv4.c                    |   10 +
 net/ipv4/tcp.c                                |   30 +
 net/ipv4/tcp_authopt.c                        | 1450 +++++++++++++++++
 net/ipv4/tcp_input.c                          |   17 +
 net/ipv4/tcp_ipv4.c                           |  101 +-
 net/ipv4/tcp_minisocks.c                      |   12 +
 net/ipv4/tcp_output.c                         |   80 +-
 net/ipv6/tcp_ipv6.c                           |   56 +-
 tools/testing/selftests/net/fcnal-test.sh     |   34 +
 tools/testing/selftests/net/nettest.c         |   34 +-
 tools/testing/selftests/tcp_authopt/Makefile  |    5 +
 .../testing/selftests/tcp_authopt/README.rst  |   15 +
 tools/testing/selftests/tcp_authopt/config    |    6 +
 .../selftests/tcp_authopt/requirements.txt    |   40 +
 tools/testing/selftests/tcp_authopt/run.sh    |   15 +
 tools/testing/selftests/tcp_authopt/setup.cfg |   17 +
 tools/testing/selftests/tcp_authopt/setup.py  |    5 +
 .../tcp_authopt/tcp_authopt_test/__init__.py  |    0
 .../tcp_authopt/tcp_authopt_test/conftest.py  |   41 +
 .../full_tcp_sniff_session.py                 |   81 +
 .../tcp_authopt_test/linux_tcp_authopt.py     |  248 +++
 .../tcp_authopt_test/linux_tcp_md5sig.py      |   95 ++
 .../tcp_authopt_test/netns_fixture.py         |   83 +
 .../tcp_authopt_test/scapy_conntrack.py       |  150 ++
 .../tcp_authopt_test/scapy_tcp_authopt.py     |  211 +++
 .../tcp_authopt_test/scapy_utils.py           |  176 ++
 .../tcp_authopt/tcp_authopt_test/server.py    |   95 ++
 .../tcp_authopt/tcp_authopt_test/sockaddr.py  |  112 ++
 .../tcp_connection_fixture.py                 |  269 +++
 .../tcp_authopt/tcp_authopt_test/test_bind.py |  145 ++
 .../tcp_authopt_test/test_rollover.py         |  180 ++
 .../tcp_authopt_test/test_sockopt.py          |  185 +++
 .../tcp_authopt_test/test_vectors.py          |  359 ++++
 .../tcp_authopt_test/test_verify_capture.py   |  555 +++++++
 .../tcp_authopt/tcp_authopt_test/utils.py     |  102 ++
 .../tcp_authopt/tcp_authopt_test/validator.py |  127 ++
 47 files changed, 5544 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/networking/tcp_authopt.rst
 create mode 100644 include/net/tcp_authopt.h
 create mode 100644 net/ipv4/tcp_authopt.c
 create mode 100644 tools/testing/selftests/tcp_authopt/Makefile
 create mode 100644 tools/testing/selftests/tcp_authopt/README.rst
 create mode 100644 tools/testing/selftests/tcp_authopt/config
 create mode 100644 tools/testing/selftests/tcp_authopt/requirements.txt
 create mode 100755 tools/testing/selftests/tcp_authopt/run.sh
 create mode 100644 tools/testing/selftests/tcp_authopt/setup.cfg
 create mode 100644 tools/testing/selftests/tcp_authopt/setup.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/__init__.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/full_tcp_sniff_session.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_md5sig.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/netns_fixture.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_conntrack.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_tcp_authopt.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_utils.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/server.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/sockaddr.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/tcp_connection_fixture.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_bind.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_rollover.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vectors.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_verify_capture.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/utils.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/validator.py


base-commit: 07b855628c226511542d0911cba1b180541fbb84
-- 
2.25.1

