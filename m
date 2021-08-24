Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BBB3F6B0C
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbhHXVgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235265AbhHXVgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:36:09 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A020AC061757;
        Tue, 24 Aug 2021 14:35:24 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z19so9235911edi.9;
        Tue, 24 Aug 2021 14:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v5KB3TDKU2JZKZBE8m69mrlD1i/Ya5eflODCh/zuQvA=;
        b=Jyus8ROef22dYWjwXe6vtkBVd8t/6YH+HpofLzFuer5LbL1PI53OdLxzoxXtygawQi
         LRgvu0+QCJVm7sWHEDCXoJr8d44QS3pGGWpBEG0uLTVGa8HGlrHw+lzNu9fuiO0NEbNx
         +Lwapsk9AtW5qjVim/7u0zKkfCempDbdpSzmONn9AE1zn2Mu61cDwR9ftA9y36uxmKaq
         vGfwdqo5ivVYPmqlrtSyW33IqZ9dwPv06X32nTPIsgP2wCD9XuEbgt/KvTSwNRDS51g/
         R5OznqLENpUI/QY9slKIDv5DTfn2WgBvWuc9a3c2EY0dM2RcYaeT6+36YitPTpdkboF9
         jNkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v5KB3TDKU2JZKZBE8m69mrlD1i/Ya5eflODCh/zuQvA=;
        b=TgZMnxY5G2RdE0f9avqQ3SkrGQeR4o1mcV3pQwz+3a13svY5Pf+da//ydmi289L2Jj
         fXVPKEn8yZSEmoWCNSsS4I/Tl5RN9b4sG60BfyH+onARZLoiu5byFV3oDNDTfnP+xrhW
         x4G9z98V+qPMu/q8kYhgmj4N8tggl9mhoVLTjelYFPyjqwuegaP7/8H2ckCQu/tJt0Nb
         uIHUJsOnyp1jS6pERrtn3P0cc/ahTcWDrmoVPTStSmZRX6ccvaMDbmu9hEpFDjB9eMgL
         HIL0FFEbdQC0fkiB3Qv8R6bOqXsH0N6N2xsH836fIXr+7DHGK2zqRIHwRgr3qDRla28P
         DCCA==
X-Gm-Message-State: AOAM531rrlmKvh7goyfLltx3LjqNNg8gBOZDqCPGjX5jshjHFahW/LHL
        HL7VKX0WkTvCqNSl7YWEIg2crG/IAIAGT6O+
X-Google-Smtp-Source: ABdhPJzdLq7IBaoRVFqNaDhK/Q5E4Jafw2rqtP73KSmRneKfKkBwuvt8JDasZi1rXA4JpvJUSWKzHw==
X-Received: by 2002:a50:eb8a:: with SMTP id y10mr1883448edr.137.1629840923195;
        Tue, 24 Aug 2021 14:35:23 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ed0a:7326:fbac:b4c])
        by smtp.gmail.com with ESMTPSA id d16sm12348357edu.8.2021.08.24.14.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:35:22 -0700 (PDT)
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
Subject: [RFCv3 00/15] tcp: Initial support for RFC5925 auth option
Date:   Wed, 25 Aug 2021 00:34:33 +0300
Message-Id: <cover.1629840814.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is similar to TCP MD5 in functionality but it's sufficiently
different that wire formats are incompatible. Compared to TCP-MD5
more algorithms are supported and multiple keys can be used on the
same connection but there is still no negotiation mechanism.
Expected use-case is protecting long-duration BGP/LDP connections
between routers using pre-shared keys.

This version is mostly functional, it incorporates ABI feedback from
previous versions and adds tests to kselftests. More discussion and
testing is required and obvious optimizations were skipped in favor of
adding functionality. Here are several flaws:

* RST and TIMEWAIT are mostly unhandled
* Locking is lockdep-clean but need to be revised
* Sequence Number Extension not implemented
* User is responsible for ensuring keys do not overlap
* Traffic key is not cached (reducing performance)

Not all ABI suggestions were incorporated, they can be discussed further.
However I very much want to avoid supporting algorithms beyond RFC5926.

Test suite was added to tools/selftests/tcp_authopt. Tests are written
in python using pytest and scapy and check the API in some detail and
validate packet captures. Python code is already in linux and in
kselftests but virtualenvs not very much. This test suite uses `tox` to
create a private virtualenv and hide dependencies. Let me know if this
is OK or how it can be improved.

Limited testing support is also included in nettest and fcnal-test.sh,
those tests are slow and cover much less.

Changes for frr: https://github.com/FRRouting/frr/pull/9442
That PR was made early for ABI feedback, it has many issues.

Changes for yabgp: https://github.com/cdleonard/yabgp/commits/tcp_authopt
The patched version of yabgp can establish a BGP session protected by
TCP Authentication Option with a Cisco IOS-XR router. It old now.

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

Leonard Crestez (15):
  tcp: authopt: Initial support and key management
  docs: Add user documentation for tcp_authopt
  selftests: Initial tcp_authopt test module
  selftests: tcp_authopt: Initial sockopt manipulation
  tcp: authopt: Add crypto initialization
  tcp: authopt: Compute packet signatures
  tcp: authopt: Hook into tcp core
  tcp: authopt: Add snmp counters
  selftests: tcp_authopt: Test key address binding
  selftests: tcp_authopt: Capture and verify packets
  selftests: Initial tcp_authopt support for nettest
  selftests: Initial tcp_authopt support for fcnal-test
  selftests: Add -t tcp_authopt option for fcnal-test.sh
  tcp: authopt: Add key selection controls
  selftests: tcp_authopt: Add tests for rollover

 Documentation/networking/index.rst            |    1 +
 Documentation/networking/tcp_authopt.rst      |   69 +
 include/linux/tcp.h                           |    6 +
 include/net/tcp.h                             |    1 +
 include/net/tcp_authopt.h                     |  134 ++
 include/uapi/linux/snmp.h                     |    1 +
 include/uapi/linux/tcp.h                      |  110 ++
 net/ipv4/Kconfig                              |   14 +
 net/ipv4/Makefile                             |    1 +
 net/ipv4/proc.c                               |    1 +
 net/ipv4/tcp.c                                |   27 +
 net/ipv4/tcp_authopt.c                        | 1168 +++++++++++++++++
 net/ipv4/tcp_input.c                          |   17 +
 net/ipv4/tcp_ipv4.c                           |    5 +
 net/ipv4/tcp_minisocks.c                      |    2 +
 net/ipv4/tcp_output.c                         |   74 +-
 net/ipv6/tcp_ipv6.c                           |    4 +
 tools/testing/selftests/net/fcnal-test.sh     |   34 +
 tools/testing/selftests/net/nettest.c         |   34 +-
 tools/testing/selftests/tcp_authopt/Makefile  |    5 +
 .../testing/selftests/tcp_authopt/README.rst  |   15 +
 tools/testing/selftests/tcp_authopt/config    |    6 +
 tools/testing/selftests/tcp_authopt/run.sh    |   11 +
 tools/testing/selftests/tcp_authopt/setup.cfg |   17 +
 tools/testing/selftests/tcp_authopt/setup.py  |    5 +
 .../tcp_authopt/tcp_authopt_test/__init__.py  |    0
 .../tcp_authopt/tcp_authopt_test/conftest.py  |   21 +
 .../full_tcp_sniff_session.py                 |   53 +
 .../tcp_authopt_test/linux_tcp_authopt.py     |  198 +++
 .../tcp_authopt_test/netns_fixture.py         |   63 +
 .../tcp_authopt/tcp_authopt_test/server.py    |   82 ++
 .../tcp_authopt/tcp_authopt_test/sockaddr.py  |  101 ++
 .../tcp_authopt_test/tcp_authopt_alg.py       |  276 ++++
 .../tcp_authopt/tcp_authopt_test/test_bind.py |  143 ++
 .../tcp_authopt_test/test_rollover.py         |  181 +++
 .../tcp_authopt_test/test_sockopt.py          |   74 ++
 .../tcp_authopt_test/test_vectors.py          |  359 +++++
 .../tcp_authopt_test/test_verify_capture.py   |  123 ++
 .../tcp_authopt/tcp_authopt_test/utils.py     |  154 +++
 .../tcp_authopt/tcp_authopt_test/validator.py |  158 +++
 40 files changed, 3746 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/networking/tcp_authopt.rst
 create mode 100644 include/net/tcp_authopt.h
 create mode 100644 net/ipv4/tcp_authopt.c
 create mode 100644 tools/testing/selftests/tcp_authopt/Makefile
 create mode 100644 tools/testing/selftests/tcp_authopt/README.rst
 create mode 100644 tools/testing/selftests/tcp_authopt/config
 create mode 100755 tools/testing/selftests/tcp_authopt/run.sh
 create mode 100644 tools/testing/selftests/tcp_authopt/setup.cfg
 create mode 100644 tools/testing/selftests/tcp_authopt/setup.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/__init__.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/full_tcp_sniff_session.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/netns_fixture.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/server.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/sockaddr.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/tcp_authopt_alg.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_bind.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_rollover.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vectors.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_verify_capture.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/utils.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/validator.py


base-commit: 3a62c333497b164868fdcd241842a1dd4e331825
-- 
2.25.1

