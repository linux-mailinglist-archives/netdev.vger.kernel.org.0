Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E174F4023F6
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238694AbhIGHVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237917AbhIGHU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:20:56 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27FCC061575;
        Tue,  7 Sep 2021 00:19:50 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i28so1665172wrb.2;
        Tue, 07 Sep 2021 00:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=57y+D1jaNuf+dA8njcRRFYfyja6UIY8ZiSSjfzf6Ntc=;
        b=gEz+CcXAVQLTfpzRz9ifvYVNh5tiqsqrQhX3ERY50/SKaNMXrAt74fJY+Pebv5Qwtq
         hJpOEZHgzBR2nzS8SSIXy4uoIkOgyhoe2MDYb9c7W0RkmiaxYU/rg3NxiuDoh6JeeuGO
         HKqrGtGuqC/9sCwb5m7cLEmWEyRT4n+Sj1Kfy5mFZNWk4EpSvHKO1VymPSugxBlm7bIl
         UNMIOJLpKebJ16WgNq7pbehmh4AtEzFVdZUiHTIUcp5IpSV0l1cZEzny2IuKCUi7LKCF
         FZzoFRKdXpL6syoMlpfXl74ixdmFM6wHMRcQ1OqYBb8J3LWgvKNv3VvsBhW+fYrCVo2n
         7ukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=57y+D1jaNuf+dA8njcRRFYfyja6UIY8ZiSSjfzf6Ntc=;
        b=UDJMzLewxnGZMt2qbVqsuLSbmLfQuo2wdmA4an7YenPOmGFqg2lUmXiNZEoWH3isSH
         e8sZ49cybjrxeu6G4GQqHuuurdL5kuGn1xuY/Nfzi4zSpnK+xTIxzePGqrb9m6nH97yw
         VokAcnsLiLfJ4nAv0Sjdd9zxPGsBCctGhRQeP5BNt8CFcfZR/j7V7pc/gRAS0WSE76tr
         vfV7X9dJOFJTBZ4IYhq8vMu/i3r+IVtjdjjWij3I8m+8HW0eRDNcrS76V7SzqGsPmybv
         sPNTwS6AtrtQYvJg+aEtYWzvDVAq56E6Iu96H9WRmq1gBihontpGxQrEmZDdMOM/54Xh
         LmAg==
X-Gm-Message-State: AOAM531NcyNiv9fbZJmxqqzyFQEsJHjqn3UOtjH/oeYzjuC+XgcPRNfn
        7WofL8d8YwYoqWnNtGPrBZA=
X-Google-Smtp-Source: ABdhPJzmozhtf05DW3DnV94IT+x5i7bWwUzw5GlFjSATidz/qkZw3WverncRk8Ur5dZa93bR/MfrXA==
X-Received: by 2002:a5d:6e91:: with SMTP id k17mr17176429wrz.77.1630999189348;
        Tue, 07 Sep 2021 00:19:49 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.19.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:19:48 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 00/20] selftests: xsk: facilitate adding tests
Date:   Tue,  7 Sep 2021 09:19:08 +0200
Message-Id: <20210907071928.9750-1-magnus.karlsson@gmail.com>
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
void pkt_stream_generate_custom(struct test_spec *test, struct pkt *pkts,
                                u32 nb_pkts);

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

* Introduce pacing of sent packets so that they are never dropped
  by the receiver even if it is stalled for some reason. If you run
  the current tests on a heavily loaded system, they might fail in SKB
  mode due to packets being dropped by the driver on Tx. Though I have
  never seen it, it might happen.

v1 -> v2:

* Fixed a number of spelling errors [Maciej]
* Fixed use after free bug in pkt_stream_replace() [Maciej]
* pkt_stream_set -> pkt_stream_generate_custom [Maciej]
* Fixed formatting problem in testapp_invalid_desc() [Maciej]

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

 tools/testing/selftests/bpf/xdpxceiver.c | 872 +++++++++++++++--------
 tools/testing/selftests/bpf/xdpxceiver.h |  66 +-
 2 files changed, 608 insertions(+), 330 deletions(-)


base-commit: 27151f177827d478508e756c7657273261aaf8a9
--
2.29.0
