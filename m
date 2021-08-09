Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46923E4E84
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbhHIVgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbhHIVgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:36:09 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0655EC0613D3;
        Mon,  9 Aug 2021 14:35:47 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id i6so26848384edu.1;
        Mon, 09 Aug 2021 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oov78986EG0HSkPUbFnP2N923dA5GdFIRRnoEpZTjxs=;
        b=VIGZwio8Va+ADneopNaDgHhUeOXbD8xX1skMLq7uX8kLnoHZt04XygNIV4+wCJLZCx
         HuPs8QNC9p7yXhfde6fYNUO3vpnAyYeBjRQFMSmtaeMRMbc43pHRvGtbU4jLFol3yQBM
         AhqyAmjEKDIGPNxLO2a4vsaP0vI0qqgKHo+s7228vHagQ89PMjAJdILrea2EOZ4Dtpcq
         F4vH5lSDgGBRTVEFZRvVtqNsdYwYWxHT9iZYchBR6uaDMGJjwOTI5fQBMCc60wT/wNKc
         ABcYvGuPDGBt8ZLaYZ9f5yNa1uga1O1avdXNTCottLdSUjpBbIiOwPGq34K65j9LZYdo
         97Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oov78986EG0HSkPUbFnP2N923dA5GdFIRRnoEpZTjxs=;
        b=Vs7xTypPhpdh7tkmLfkAdee/gZGwnwXSB6zrgLtBvIRvKQrBbjnfAU5Em02N9uaHUz
         /BAT1xWRY3wBQzZPQuxLfNmivKeDdS9YolXaGcXFQN2TygVbpJmC/zuL3bXJMiyFntoz
         xH3cdz4PORqvYWsUvrbyxXMk2syIvSr71YZWv0U5MNgSuQyXqUJJ2tJF57ySOGVsNJBy
         XN43rJzs2hg8iamdok1/yUqsp8/OYCFwDCiZzdbTGpL2SZPkdRGqg0vuioyvN/UIPvOx
         Qwhlis6DQoa26h5x/yIzdzhOEk68JSM2El+05rnmRzHahMRCRc6w1oRfFUMczbfw4bO8
         bqCw==
X-Gm-Message-State: AOAM532YJeVO4OnAt47tLFpUUGRxDHog3ujuv/K0bSBx2BIHOwpHIsju
        RzaJD9GhhmsSZhzFCgvc8bg=
X-Google-Smtp-Source: ABdhPJxxhRu6xfmDS5OtZm2eAikpQU0cAAj6zF4dEIKzg69KhpcSNJ5IEXyN7ohKVX3RzZrHdIOsrw==
X-Received: by 2002:a50:f1c2:: with SMTP id y2mr496240edl.64.1628544946517;
        Mon, 09 Aug 2021 14:35:46 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:688d:23e:82c6:84aa])
        by smtp.gmail.com with ESMTPSA id v24sm5542932edt.41.2021.08.09.14.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 14:35:45 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFCv2 0/9] tcp: Initial support for RFC5925 auth option
Date:   Tue, 10 Aug 2021 00:35:29 +0300
Message-Id: <cover.1628544649.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is similar to TCP MD5 in functionality but it's sufficiently
different that userspace interface and wire formats are incompatible.
Compared to TCP-MD5 more algorithms are supported and multiple keys can
be used on the same connection but there is still no negotiation
mechanism. Expected use-case is protecting long-duration BGP/LDP
connections between routers using pre-shared keys.

This version is mostly functional though more testing is required. Many
obvious optimizations were skipped in favor of adding functionality.
Here are several flaws:

* RST and TIMEWAIT are mostly unhandled
* A lock might be required for tcp_authopt
* Sequence Number Extension not implemented
* User is responsible for ensuring keys do not overlap (could be fine)
* Traffic key is not cached (reducing performance)

Test suite used during development is here: https://github.com/cdleonard/tcp-authopt-test
Tests are written in python using pytest and scapy and check the API in
detail and validate packet captures.

Limited kselftest support for tcp_authopt in nettest/fcnal-test.sh is
also included in this series. Those tests are slow and cover very
little.

Changes for yabgp are here:
https://github.com/cdleonard/yabgp/commits/tcp_authopt
The patched version of yabgp can establish a BGP session protected by
TCP Authentication Option with a Cisco IOS-XR router.

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

The key control support is not based on the requirements of any
particular app (a routing daemon) but rather the recommendations of
RFC5925. Several vendors implement key chain management similar to
RFC8177 but this belongs in userspace.

Previously: https://lore.kernel.org/netdev/01383a8751e97ef826ef2adf93bfde3a08195a43.1626693859.git.cdleonard@gmail.com/

Leonard Crestez (9):
  tcp: authopt: Initial support and key management
  docs: Add user documentation for tcp_authopt
  tcp: authopt: Add crypto initialization
  tcp: authopt: Compute packet signatures
  tcp: authopt: Hook into tcp core
  tcp: authopt: Add key selection controls
  tcp: authopt: Add snmp counters
  selftests: Initial TCP-AO support for nettest
  selftests: Initial TCP-AO support for fcnal-test

 Documentation/networking/index.rst        |    1 +
 Documentation/networking/tcp_authopt.rst  |   69 ++
 include/linux/tcp.h                       |    6 +
 include/net/tcp.h                         |    1 +
 include/net/tcp_authopt.h                 |  121 +++
 include/uapi/linux/snmp.h                 |    1 +
 include/uapi/linux/tcp.h                  |  103 ++
 net/ipv4/Kconfig                          |   14 +
 net/ipv4/Makefile                         |    1 +
 net/ipv4/proc.c                           |    1 +
 net/ipv4/tcp.c                            |   27 +
 net/ipv4/tcp_authopt.c                    | 1091 +++++++++++++++++++++
 net/ipv4/tcp_input.c                      |   17 +
 net/ipv4/tcp_ipv4.c                       |    5 +
 net/ipv4/tcp_minisocks.c                  |    2 +
 net/ipv4/tcp_output.c                     |   56 +-
 net/ipv6/tcp_ipv6.c                       |    4 +
 tools/testing/selftests/net/fcnal-test.sh |   22 +
 tools/testing/selftests/net/nettest.c     |   43 +-
 19 files changed, 1583 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/networking/tcp_authopt.rst
 create mode 100644 include/net/tcp_authopt.h
 create mode 100644 net/ipv4/tcp_authopt.c


base-commit: 2a2b6e3640c43a808dcb5226963e2cc0669294b1
-- 
2.25.1

