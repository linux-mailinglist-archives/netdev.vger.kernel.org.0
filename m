Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797B03FD7F9
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237132AbhIAKs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbhIAKs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:48:57 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F33DC061575;
        Wed,  1 Sep 2021 03:48:00 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id z4so3786084wrr.6;
        Wed, 01 Sep 2021 03:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8ZVMMm/7VePbBno+rUu3lisTUfXZQKB7offQjykcbVw=;
        b=Q10+tV9VtWrF5qDcZ0QrAtn3VL6ZaqjFS48EO6ppUs1CuMr1++kWs2W+FyvEjG1f4N
         lKjmvYkFA3Wp4cDYKrlbQgEIWloLiNgKVwAq82uLsV2Z9bzgbTgZj0Is8nOb3VFQAXgx
         44a0Fs6PilSrQ8Kq1AM0rOToqZLEPbexCtEoqIAXy7NUAMIKwSSU1yWoc/XB8IKrZxPk
         ZRY693QpM8dCLkQ5cezG2V3g6mwuvDvskgI5ELiAYIa7ug2vBfyzfpdLv2cySLgrZanO
         gqOXeVht/F9p16MJcBn3KgDu45OCWIeix7yjiEDQZ0AR3f/TGxAwRtjF87a14m0czOpS
         7g0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8ZVMMm/7VePbBno+rUu3lisTUfXZQKB7offQjykcbVw=;
        b=klgUtGDOPlCPMtL1kyL8uvI3HIrbVckBEUpRa+1u3GZH+K3Qery9W9/3/pmlmVwQqc
         acagjzsZYnBKwAumkPCfJaVk84D9kotZ9NAB3JOxONt48rW1Kf6ghSt/NyuFhlk5aNL+
         P7zV5d0XRL4bV3L4aEydpDWWx2NLWGIxg42a+xqBom34/y8ZaezAkIPP3LA8wZQNozKn
         rfHRriUa5PIInMc5fzoTNiGK+FYYMVwRDww977JjojR5qugFUGx7hdGPLXRaNvicnyJh
         bibBRNDWytxpotK+JbPSBYmPbRT8be+vAhFIyusP/awi8p/PXyEL8wLvWtsILmEIUy6F
         LsFw==
X-Gm-Message-State: AOAM533nPEhfnCtBomFktQOhZalfk+XaT5RNT7GdttJeVZWqNstkuu08
        X2ECHHa/kY99TZE0/MpFYz1Us5uQ7bHnvMZZ
X-Google-Smtp-Source: ABdhPJxaXNoPTEFJluW4XJr9g2RYRAYIb9ufYvtEOVmFWK35OJqXQEYJhcvK58GISC9LvJnreLJ8bQ==
X-Received: by 2002:adf:9084:: with SMTP id i4mr37328158wri.23.1630493278690;
        Wed, 01 Sep 2021 03:47:58 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r12sm21530843wrv.96.2021.09.01.03.47.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 03:47:58 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next 00/20] selftests: xsk: facilitate adding tests
Date:   Wed,  1 Sep 2021 12:47:12 +0200
Message-Id: <20210901104732.10956-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set facilitates adding new tests as well as describing
existing ones in the xsk selftests suite and adds 3 new test suites at
the end. The idea is to isolate the run-time that executes the test
from the actual implementation of the test. Today, implementing a test
amounts to adding test specific if-statements all around the run-time,
which is not scalable or amenable for reuse. This patch set instead
introduces a test specification that is the only thing that a test
fills in. The run-time then gets this specification and acts upon it
completely unaware of what test it is executing. This way, we can get
rid of all test specific if-statements from the run-time and the
implementation of the test can be contained in a single function. This
hopefully makes it easier to add tests and for users to understand
what the test accomplishes.

As a recap of what the run-time does: each test is based on the
run-time launching two threads and connecting a veth link between the
two threads. Each thread opens an AF_XDP socket on that veth interface
and one of them sends traffic that the other one receives and
validates. Each thread has its own umem. Note that this behavior is
not changed by this patch set.

A test specification consists of several items. Most importantly:

* Two packet streams. One for Tx thread that specifies what traffic to
  send and one for the Rx thread that specifies what that thread
  should receive. If it receives exactly what is specified, the test
  passes, otherwise it fails. A packet stream can also specify what
  buffers in the umem that should be used by the Rx and Tx threads.

* What kind of AF_XDP sockets it should create and bind to what
  interfaces

* How many times it should repeat the socket creation and destruction

* The name of the test

The interface for the test spec is the following:

void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
                    struct ifobject *ifobj_rx, enum test_mode mode);

/* Reset everything but the interface specifications and the mode */
void test_spec_reset(struct test_spec *test);

void test_spec_set_name(struct test_spec *test, const char *name);


Packet streams have the following interfaces:

struct pkt *pkt_stream_get_pkt(struct pkt_stream *pkt_stream, u32 pkt_nb)

struct pkt *pkt_stream_get_next_rx_pkt(struct pkt_stream *pkt_stream)

struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem,
                                       u32 nb_pkts, u32 pkt_len);

void pkt_stream_delete(struct pkt_stream *pkt_stream);

struct pkt_stream *pkt_stream_clone(struct xsk_umem_info *umem,
                                    struct pkt_stream *pkt_stream);

/* Replaces all packets in the stream*/
void pkt_stream_replace(struct test_spec *test, u32 nb_pkts, u32 pkt_len);

/* Replaces every other packet in the stream */
void pkt_stream_replace_half(struct test_spec *test, u32 pkt_len, u32 offset);

/* For creating custom made packet streams */
void pkt_stream_set(struct test_spec *test, struct pkt *pkts, u32 nb_pkts);

/* Restores the default packet stream */
void pkt_stream_restore_default(struct test_spec *test);


A test can then then in the most basic case described like this
(provided the test specification has been created before calling the
function):

static bool testapp_aligned(struct test_spec *test)
{
        test_spec_set_name(test, "RUN_TO_COMPLETION");
        testapp_validate_traffic(test);
}

Running the same test in unaligned mode would then look like this:

static bool testapp_unaligned(struct test_spec *test)
{
        if (!hugepages_present(test->ifobj_tx)) {
                ksft_test_result_skip("No 2M huge pages present.\n");
                return false;
        }

        test_spec_set_name(test, "UNALIGNED_MODE");
        test->ifobj_tx->umem->unaligned_mode = true;
        test->ifobj_rx->umem->unaligned_mode = true;
        /* Let half of the packets straddle a buffer boundrary */
        pkt_stream_replace_half(test, PKT_SIZE,
                                XSK_UMEM__DEFAULT_FRAME_SIZE - 32);
	/* Populate fill ring with addresses in the packet stream */
        test->ifobj_rx->pkt_stream->use_addr_for_fill = true;
        testapp_validate_traffic(test);

        pkt_stream_restore_default(test);
	return true;
}

3 of the last 4 patches in the set add 3 new test suites, one for
unaligned mode, one for testing the rejection of tricky invalid
descriptors plus the acceptance of some valid ones in the Tx ring, and
one for testing 2K frame sizes (the default is 4K).

What is left to do for follow-up patches:

* Convert the statistics tests to the new framework.

* Implement a way of registering new tests without having the enum
  test_type. Once this has been done (together with the previous
  bullet), all the test types can be dropped from the header
  file. This means that we should be able to add tests by just writing
  a single function with a new test specification, which is one of the
  goals.

* Introduce functions for manipulating parts of the test or interface
  spec instead of direct manipulations such as
  test->ifobj_rx->pkt_stream->use_addr_for_fill = true; which is kind
  of awkward.

* Move the run-time and its interface to its own .c and .h files. Then
  we can have all the tests in a separate file.

* Better error reporting if a test fails. Today it does not state what
  test fails and might not continue execute the rest of the tests due
  to this failure. Failures are not propagated upwards through the
  functions so a failed test will also be a passed test, which messes
  up the stats counting. This needs to be changed.

* Add option to run specific test instead of all of them

* Introduce pacing of sent packets so that they are never dropped by
  the receiver even if it is stalled for some reason. If you run the
  current tests on a heavily loaded system, they might fail in SKB
  mode due to packets being dropped by the driver on Tx. Though I have
  never seen it, it might happen.

Thanks: Magnus

Magnus Karlsson (20):
  selftests: xsk: simplify xsk and umem arrays
  selftests: xsk: introduce type for thread function
  selftests: xsk: introduce test specifications
  selftests: xsk: move num_frames and frame_headroom to xsk_umem_info
  selftests: xsk: move rxqsize into xsk_socket_info
  selftests: xsk: make frame_size configurable
  selftests: xsx: introduce test name in test spec
  selftests: xsk: add use_poll to ifobject
  selftests: xsk: introduce rx_on and tx_on in ifobject
  selftests: xsk: replace second_step global variable
  selftests: xsk: specify number of sockets to create
  selftests: xsk: make xdp_flags and bind_flags local
  selftests: xsx: make pthreads local scope
  selftests: xsk: eliminate MAX_SOCKS define
  selftests: xsk: allow for invalid packets
  selftests: xsk: introduce replacing the default packet stream
  selftests: xsk: add test for unaligned mode
  selftests: xsk: eliminate test specific if-statement in test runner
  selftests: xsk: add tests for invalid xsk descriptors
  selftests: xsk: add tests for 2K frame size

 tools/testing/selftests/bpf/xdpxceiver.c | 870 +++++++++++++++--------
 tools/testing/selftests/bpf/xdpxceiver.h |  66 +-
 2 files changed, 606 insertions(+), 330 deletions(-)


base-commit: 9e9fb7655ed585da8f468e29221f0ba194a5f613
--
2.29.0
