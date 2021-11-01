Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2571E441E94
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhKAQj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbhKAQig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:36 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EE7C061205;
        Mon,  1 Nov 2021 09:36:00 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z20so66628034edc.13;
        Mon, 01 Nov 2021 09:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ufYFZBJ9VEr56IXSsNWfLzy7MWr0YUwgDAXQztjCufM=;
        b=kQLPjL5fQ9m1acixa4Y6AGC2t6mYbM2rE5F62eO3q4bIn8cpiog4AIMD6teAN0jvnt
         71Ug3EnndFPH5cKkdW/IkUKgQcv6cOLQK2BHGDC4pejzOFWRjx3m9A2YQFQ8w/DAsZt8
         qzDEuWqJAr5+Ugjj/mITUZSR+E4hp1UHPms2NCKvI10VIfbvxCNWjCpr+JCTgy+z86wY
         3UYKIob7Q4RsbmFJ8NI5J45eWcyQEqqX5hQSKFk0N8nM8dq3AgjNpjR0t0rvwKAbvefB
         w/N0oNcMXvYi9d58LCuBDBvXCo0pX9zs8qCbLLzCnrRpngwlunHoWGLv1poRssL/doC7
         chgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ufYFZBJ9VEr56IXSsNWfLzy7MWr0YUwgDAXQztjCufM=;
        b=JUARReWQ0eqs6R4VfapblgnZodM3PfwvDgJ1Nmhjd9ZimmUHWN7O3aHKJJpc3E5x8L
         oYGYxlhk3/mUIKx1BMzQhv8eYaPf77TzC3fWypJM8i4pxigfjwQn2iLdwKZxM/cqzW6K
         LU+bt4YWMBEWwme8Y8CnaQFLreNO97YtXhY0gGZq2mWK5IyUYoqWYzRNOFke5mcavYid
         a6mnKSocji73X7H/ncwiRapRpvUpZ79HbDvSOLZg5FPLyBTBVo3rHMybZElyj8h6Jsrw
         lQv7WQ17whLlfzcKbIzlY1/4jAGnOO9Cm4zWGTD07PhizwOyuS2gIC/ncxmd/+Nic4Ii
         cEjg==
X-Gm-Message-State: AOAM532+8tokpHexL/8fB+tv9AvUo4g739wnqxQEEat+5DQvy27VEYrl
        akdF+VXWODuIZqooLa+QdV0=
X-Google-Smtp-Source: ABdhPJwOA8sq9VznxmVmIvo0FS3NLldIrMKRpa3xLdbqdxNw2MdXE0lgi+4d2WT+WC7h4uRUin2F1w==
X-Received: by 2002:a50:f08b:: with SMTP id v11mr37503183edl.96.1635784559186;
        Mon, 01 Nov 2021 09:35:59 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:58 -0700 (PDT)
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
Subject: [PATCH v2 18/25] selftests: tcp_authopt: Initial sne test
Date:   Mon,  1 Nov 2021 18:34:53 +0200
Message-Id: <cc1f1ce2d723613db48b15249406e9c9f14479a4.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to trigger a seq or ack rollover create many connection in a
loop and check for a "high" value, then make a lot of traffic.

This relies on both TCP_REPAIR and TCP_REPAIR_AUTHOPT, making it unfit
for upstream.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 .../tcp_authopt_test/linux_tcp_repair.py      |  67 ++++++
 .../tcp_authopt/tcp_authopt_test/test_sne.py  | 202 ++++++++++++++++++
 2 files changed, 269 insertions(+)
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_repair.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sne.py

diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_repair.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_repair.py
new file mode 100644
index 000000000000..68f111a207e6
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_repair.py
@@ -0,0 +1,67 @@
+# SPDX-License-Identifier: GPL-2.0
+import socket
+import struct
+from contextlib import contextmanager
+from enum import IntEnum
+
+# Extra sockopts not present in python stdlib
+TCP_REPAIR = 19
+TCP_REPAIR_QUEUE = 20
+TCP_QUEUE_SEQ = 21
+TCP_REPAIR_OPTIONS = 22
+TCP_REPAIR_WINDOW = 29
+
+
+class TCP_REPAIR_VAL(IntEnum):
+    OFF = 0
+    ON = 1
+    OFF_NO_WP = -1
+
+
+def get_tcp_repair(sock) -> TCP_REPAIR_VAL:
+    return TCP_REPAIR_VAL(sock.getsockopt(socket.SOL_TCP, TCP_REPAIR))
+
+
+def set_tcp_repair(sock, val: TCP_REPAIR_VAL) -> None:
+    return sock.setsockopt(socket.SOL_TCP, TCP_REPAIR, int(val))
+
+
+class TCP_REPAIR_QUEUE_ID(IntEnum):
+    NO_QUEUE = 0
+    RECV_QUEUE = 1
+    SEND_QUEUE = 2
+
+
+def get_tcp_repair_queue(sock) -> TCP_REPAIR_QUEUE_ID:
+    return TCP_REPAIR_QUEUE_ID(sock.getsockopt(socket.SOL_TCP, TCP_REPAIR_QUEUE))
+
+
+def set_tcp_repair_queue(sock, val: TCP_REPAIR_QUEUE_ID) -> None:
+    return sock.setsockopt(socket.SOL_TCP, TCP_REPAIR_QUEUE, int(val))
+
+
+def get_tcp_queue_seq(sock) -> int:
+    return struct.unpack("I", sock.getsockopt(socket.SOL_TCP, TCP_QUEUE_SEQ, 4))[0]
+
+
+def set_tcp_queue_seq(sock, val: int) -> None:
+    return sock.setsockopt(socket.SOL_TCP, TCP_QUEUE_SEQ, val)[0]
+
+
+@contextmanager
+def tcp_repair_toggle(sock, off_val=TCP_REPAIR_VAL.OFF_NO_WP):
+    """Set TCP_REPAIR on/off as a context"""
+    try:
+        set_tcp_repair(sock, TCP_REPAIR_VAL.ON)
+        yield
+    finally:
+        set_tcp_repair(sock, off_val)
+
+
+def get_tcp_repair_recv_send_queue_seq(sock):
+    with tcp_repair_toggle(sock):
+        set_tcp_repair_queue(sock, TCP_REPAIR_QUEUE_ID.RECV_QUEUE)
+        recv_seq = get_tcp_queue_seq(sock)
+        set_tcp_repair_queue(sock, TCP_REPAIR_QUEUE_ID.SEND_QUEUE)
+        send_seq = get_tcp_queue_seq(sock)
+        return (recv_seq, send_seq)
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sne.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sne.py
new file mode 100644
index 000000000000..180d7cdbd5f3
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sne.py
@@ -0,0 +1,202 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Validate SNE implementation for TCP-AO"""
+
+import logging
+import socket
+from contextlib import ExitStack
+from ipaddress import ip_address
+
+import pytest
+
+from .linux_tcp_authopt import set_tcp_authopt_key_kwargs
+from .linux_tcp_repair import get_tcp_repair_recv_send_queue_seq, tcp_repair_toggle
+from .netns_fixture import NamespaceFixture
+from .scapy_conntrack import TCPConnectionKey, TCPConnectionTracker
+from .scapy_utils import AsyncSnifferContext, create_capture_socket, tcp_seq_wrap
+from .server import SimpleServerThread
+from .utils import (
+    DEFAULT_TCP_SERVER_PORT,
+    check_socket_echo,
+    create_client_socket,
+    create_listen_socket,
+    socket_set_linger,
+)
+from .validator import TcpAuthValidator, TcpAuthValidatorKey
+
+logger = logging.getLogger(__name__)
+
+
+def add_connection_info(
+    tracker: TCPConnectionTracker,
+    saddr,
+    daddr,
+    sport,
+    dport,
+    sisn,
+    disn,
+):
+    client2server_key = TCPConnectionKey(
+        saddr=saddr,
+        daddr=daddr,
+        sport=sport,
+        dport=dport,
+    )
+    client2server_conn = tracker.get_or_create(client2server_key)
+    client2server_conn.sisn = sisn
+    client2server_conn.disn = disn
+    client2server_conn.snd_sne.reset(sisn)
+    client2server_conn.rcv_sne.reset(disn)
+    client2server_conn.found_syn = True
+    client2server_conn.found_synack = True
+    server2client_conn = tracker.get_or_create(client2server_key.rev())
+    server2client_conn.sisn = disn
+    server2client_conn.disn = sisn
+    server2client_conn.snd_sne.reset(disn)
+    server2client_conn.rcv_sne.reset(sisn)
+    server2client_conn.found_syn = True
+    server2client_conn.found_synack = True
+
+
+@pytest.mark.parametrize("signed", [False, True])
+def test_high_seq_rollover(exit_stack: ExitStack, signed: bool):
+    """Test SNE by rolling over from a high seq/ack value
+
+    Create many connections until a very high seq/ack is found and then transfer
+    enough for those values to roll over.
+
+    A side effect of this approach is that this stresses connection
+    establishment.
+    """
+    overflow = 0x200000
+    bufsize = 0x10000
+    secret_key = b"12345"
+    mode = "echo"
+    validator_enabled = True
+
+    nsfixture = exit_stack.enter_context(NamespaceFixture())
+    server_addr = nsfixture.get_addr(socket.AF_INET, 1)
+    client_addr = nsfixture.get_addr(socket.AF_INET, 2)
+    server_addr_port = (str(server_addr), DEFAULT_TCP_SERVER_PORT)
+    listen_socket = create_listen_socket(
+        ns=nsfixture.server_netns_name,
+        bind_addr=server_addr,
+        listen_depth=1024,
+    )
+    exit_stack.enter_context(listen_socket)
+    if signed:
+        set_tcp_authopt_key_kwargs(listen_socket, key=secret_key)
+    server_thread = SimpleServerThread(listen_socket, mode=mode, bufsize=bufsize)
+    exit_stack.enter_context(server_thread)
+
+    found = False
+    client_socket = None
+    for iternum in range(50000):
+        try:
+            # Manually assign increasing client ports
+            #
+            # Sometimes linux kills timewait sockets (TCPTimeWaitOverflow) and
+            # then attempts to reuse the port. The stricter validation
+            # requirements of TCP-AO mean the other side of the socket survives
+            # and rejects packets coming from the reused port.
+            #
+            # This issue is not related to SNE so a workaround is acceptable.
+            client_socket = create_client_socket(
+                ns=nsfixture.client_netns_name,
+                bind_addr=client_addr,
+                bind_port=10000 + iternum,
+            )
+            if signed:
+                set_tcp_authopt_key_kwargs(client_socket, key=secret_key)
+            try:
+                client_socket.connect(server_addr_port)
+            except:
+                logger.error("failed connect on iteration %d", iternum, exc_info=True)
+                raise
+
+            recv_seq, send_seq = get_tcp_repair_recv_send_queue_seq(client_socket)
+            if (recv_seq + overflow > 0x100000000 and mode == "echo") or (
+                send_seq + overflow > 0x100000000
+            ):
+                found = True
+                break
+            # Wait for graceful close to avoid swamping server listen queue.
+            # This makes the test work even with a server listen_depth=1 but set
+            # a very high value anyway.
+            socket_set_linger(client_socket, 1, 1)
+            client_socket.close()
+            client_socket = None
+        finally:
+            if not found and client_socket:
+                client_socket.close()
+    assert found
+    assert client_socket is not None
+
+    logger.debug("setup recv_seq %08x send_seq %08x", recv_seq, send_seq)
+
+    # Init validator
+    if signed and validator_enabled:
+        capture_filter = f"tcp port {DEFAULT_TCP_SERVER_PORT}"
+        capture_socket = create_capture_socket(
+            ns=nsfixture.client_netns_name,
+            iface="veth0",
+            filter=capture_filter,
+        )
+        sniffer = exit_stack.enter_context(
+            AsyncSnifferContext(opened_socket=capture_socket)
+        )
+        validator = TcpAuthValidator()
+        validator.keys.append(
+            TcpAuthValidatorKey(key=secret_key, alg_name="HMAC-SHA-1-96")
+        )
+
+        # SYN+SYNACK is not captured so initialize connection info manually
+        add_connection_info(
+            validator.tracker,
+            saddr=ip_address(client_addr),
+            daddr=ip_address(server_addr),
+            dport=client_socket.getpeername()[1],
+            sport=client_socket.getsockname()[1],
+            sisn=tcp_seq_wrap(send_seq - 1),
+            disn=tcp_seq_wrap(recv_seq - 1),
+        )
+
+    logger.info("transfer %d bytes", 2 * overflow)
+    fail_transfer = False
+    for iternum in range(2 * overflow // bufsize):
+        try:
+            if mode == "recv":
+                from .utils import randbytes
+
+                send_buf = randbytes(bufsize)
+                client_socket.sendall(send_buf)
+            else:
+                check_socket_echo(client_socket, bufsize)
+        except:
+            logger.error("failed traffic on iteration %d", iternum, exc_info=True)
+            fail_transfer = True
+            break
+
+    new_recv_seq, new_send_seq = get_tcp_repair_recv_send_queue_seq(client_socket)
+    logger.debug("final recv_seq %08x send_seq %08x", new_recv_seq, new_send_seq)
+    assert new_recv_seq < recv_seq or new_send_seq < send_seq
+
+    # Validate capture
+    if signed and validator_enabled:
+        sniffer.stop()
+        for p in sniffer.results:
+            validator.handle_packet(p)
+        # Allow incomplete connections from FIN/ACK of connections dropped
+        # because of low seq/ack
+        validator.raise_errors(allow_incomplete=True)
+        client_scappy_key = TCPConnectionKey(
+            saddr=ip_address(client_addr),
+            daddr=ip_address(server_addr),
+            dport=client_socket.getpeername()[1],
+            sport=client_socket.getsockname()[1],
+        )
+        client_scappy_conn = validator.tracker.get(client_scappy_key)
+        snd_sne_rollover = client_scappy_conn.snd_sne.sne != 0
+        rcv_sne_rollover = client_scappy_conn.rcv_sne.sne != 0
+        assert snd_sne_rollover or rcv_sne_rollover
+
+    assert not fail_transfer
-- 
2.25.1

