Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265383F6B37
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238999AbhHXVgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235659AbhHXVg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:36:27 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCEEC0613CF;
        Tue, 24 Aug 2021 14:35:42 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id x11so47312584ejv.0;
        Tue, 24 Aug 2021 14:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zNzXEuIS7lPdfXUfFlF+z8/ZgMYTzkoaohsw19PRcTc=;
        b=H5cn49RLakZObp4CT/LlsMcJOCdYbmURMxRjQVvXO3kQh+5s2su/da8a57QVkOkb0B
         S6QS3gBlA/g4hZDT/UBNLLc+BlTuAEDLxWO33P2X3Y0PynKeqbzMvLRQk//FUGrSVR8r
         gR9Yz2c0EhBHVSNwPK0VQew5YteTL+gBhL+H53dfgQiXHbKvUM7b+KawEyiddbhNU9L5
         ZxH0gZb9utlBoOmHqs+WXNkl54FNWZ8D93r/9mKpyY2eAXx/34OGveeXspnA/Z61x5Rk
         B7i+ekePKBGZrfgjhnQbQVHuEBawoavmkWe5cdoQuJ0fTk+jzQGA4BJCqNDF+25I7vUL
         8Uvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zNzXEuIS7lPdfXUfFlF+z8/ZgMYTzkoaohsw19PRcTc=;
        b=gf3lqKmMGLmOR1aF3PEOjBLHqvuYrph7tr7NL6IcM6jqA/aq6O3xuVbdC8AVKdRzQ+
         OcKwl9aD8ilSRFYrsRR3SfeSU1qPgn+gMgvHykajQAThxem3RfzvC/OBBoXHb4T801fk
         hjjf3XNXMkWCJdTGTC+kfV3kXe9CLcX0LGca07grMMXToaahe4WmrRvtq0k0snfxquuS
         ctw14wHQck0rQufPTYK4NRNVBtmKYR2bipeo2BFUm3fi9cZTc2dg65Y1s40ueqgsIzyN
         9A38fCXkxPCvJdOyrZBGYJHn7VYyjlxBWD0TwW8lwpVXDYlWVgpturuF2Rs52WIuydrA
         YaAg==
X-Gm-Message-State: AOAM533L/D81oirWzd8bW9inwOo9JJnn/M1uWRywNdqPmX2w8WYyqzY/
        LmnFIKyR0TVk0F2044Iggyw=
X-Google-Smtp-Source: ABdhPJwM3FAsoxHxtxsieIz6+wy2DnugvtBgY5W5St453yNFF4Fg1+ABS/LGLnVijaFJ4do+QJyx8A==
X-Received: by 2002:a17:907:5096:: with SMTP id fv22mr6307510ejc.95.1629840941025;
        Tue, 24 Aug 2021 14:35:41 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ed0a:7326:fbac:b4c])
        by smtp.gmail.com with ESMTPSA id d16sm12348357edu.8.2021.08.24.14.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:35:40 -0700 (PDT)
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
Subject: [RFCv3 09/15] selftests: tcp_authopt: Test key address binding
Date:   Wed, 25 Aug 2021 00:34:42 +0300
Message-Id: <09c7cff43f832d0aba8dfad67f56066aeeca8475.1629840814.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1629840814.git.cdleonard@gmail.com>
References: <cover.1629840814.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default TCP-AO keys apply to all possible peers but it's possible to
have different keys for different remote hosts.

This patch adds initial tests for the behavior behind the
TCP_AUTHOPT_KEY_BIND_ADDR flag. Server rejection is tested via client
timeout so this can be slightly slow.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 .../tcp_authopt_test/netns_fixture.py         |  63 +++++++
 .../tcp_authopt/tcp_authopt_test/server.py    |  82 ++++++++++
 .../tcp_authopt/tcp_authopt_test/test_bind.py | 143 ++++++++++++++++
 .../tcp_authopt/tcp_authopt_test/utils.py     | 154 ++++++++++++++++++
 4 files changed, 442 insertions(+)
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/netns_fixture.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/server.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_bind.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/utils.py

diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/netns_fixture.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/netns_fixture.py
new file mode 100644
index 000000000000..20bb12c2aae2
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/netns_fixture.py
@@ -0,0 +1,63 @@
+# SPDX-License-Identifier: GPL-2.0
+import subprocess
+import socket
+from ipaddress import IPv4Address
+from ipaddress import IPv6Address
+
+
+class NamespaceFixture:
+    """Create a pair of namespaces connected by one veth pair
+
+    Each end of the pair has multiple addresses but everything is in the same subnet
+    """
+
+    ns1_name = "tcp_authopt_test_1"
+    ns2_name = "tcp_authopt_test_2"
+
+    @classmethod
+    def get_ipv4_addr(cls, ns=1, index=1) -> IPv4Address:
+        return IPv4Address("10.10.0.0") + (ns << 8) + index
+
+    @classmethod
+    def get_ipv6_addr(cls, ns=1, index=1) -> IPv6Address:
+        return IPv6Address("fd00::") + (ns << 16) + index
+
+    @classmethod
+    def get_addr(cls, address_family=socket.AF_INET, ns=1, index=1):
+        if address_family == socket.AF_INET:
+            return cls.get_ipv4_addr(ns, index)
+        elif address_family == socket.AF_INET6:
+            return cls.get_ipv6_addr(ns, index)
+        else:
+            raise ValueError(f"Bad address_family={address_family}")
+
+    def __init__(self, **kw):
+        for k, v in kw.items():
+            setattr(self, k, v)
+
+    def __enter__(self):
+        script = f"""
+set -e -x
+ip netns del {self.ns1_name} || true
+ip netns del {self.ns2_name} || true
+ip netns add {self.ns1_name}
+ip netns add {self.ns2_name}
+ip link add veth0 netns {self.ns1_name} type veth peer name veth0 netns {self.ns2_name}
+ip netns exec {self.ns1_name} ip link set veth0 up
+ip netns exec {self.ns2_name} ip link set veth0 up
+"""
+        for index in [1, 2, 3]:
+            script += f"ip -n {self.ns1_name} addr add {self.get_ipv4_addr(1, index)}/16 dev veth0\n"
+            script += f"ip -n {self.ns2_name} addr add {self.get_ipv4_addr(2, index)}/16 dev veth0\n"
+            script += f"ip -n {self.ns1_name} addr add {self.get_ipv6_addr(1, index)}/64 dev veth0 nodad\n"
+            script += f"ip -n {self.ns2_name} addr add {self.get_ipv6_addr(2, index)}/64 dev veth0 nodad\n"
+        subprocess.run(script, shell=True, check=True)
+        return self
+
+    def __exit__(self, *a):
+        script = f"""
+set -e -x
+ip netns del {self.ns1_name} || true
+ip netns del {self.ns2_name} || true
+"""
+        subprocess.run(script, shell=True, check=True)
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/server.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/server.py
new file mode 100644
index 000000000000..c4cce8f5862a
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/server.py
@@ -0,0 +1,82 @@
+# SPDX-License-Identifier: GPL-2.0
+import logging
+import os
+import selectors
+from contextlib import ExitStack
+from threading import Thread
+
+logger = logging.getLogger(__name__)
+
+
+class SimpleServerThread(Thread):
+    """Simple server thread for testing TCP sockets
+
+    All data is read in 1000 bytes chunks and either echoed back or discarded.
+    """
+
+    def __init__(self, socket, mode="recv"):
+        self.listen_socket = socket
+        self.server_socket = []
+        self.mode = mode
+        super().__init__()
+
+    def _read(self, conn, events):
+        # logger.debug("events=%r", events)
+        data = conn.recv(1000)
+        # logger.debug("len(data)=%r", len(data))
+        if len(data) == 0:
+            # logger.info("closing %r", conn)
+            conn.close()
+            self.sel.unregister(conn)
+        else:
+            if self.mode == "echo":
+                conn.sendall(data)
+            elif self.mode == "recv":
+                pass
+            else:
+                raise ValueError(f"Unknown mode {self.mode}")
+
+    def _stop_pipe_read(self, conn, events):
+        self.should_loop = False
+
+    def start(self) -> None:
+        self.exit_stack = ExitStack()
+        self._stop_pipe_rfd, self._stop_pipe_wfd = os.pipe()
+        self.exit_stack.callback(lambda: os.close(self._stop_pipe_rfd))
+        self.exit_stack.callback(lambda: os.close(self._stop_pipe_wfd))
+        return super().start()
+
+    def _accept(self, conn, events):
+        assert conn == self.listen_socket
+        conn, _addr = self.listen_socket.accept()
+        conn = self.exit_stack.enter_context(conn)
+        conn.setblocking(False)
+        self.sel.register(conn, selectors.EVENT_READ, self._read)
+        self.server_socket.append(conn)
+
+    def run(self):
+        self.should_loop = True
+        self.sel = self.exit_stack.enter_context(selectors.DefaultSelector())
+        self.sel.register(
+            self._stop_pipe_rfd, selectors.EVENT_READ, self._stop_pipe_read
+        )
+        self.sel.register(self.listen_socket, selectors.EVENT_READ, self._accept)
+        # logger.debug("loop init")
+        while self.should_loop:
+            for key, events in self.sel.select(timeout=1):
+                callback = key.data
+                callback(key.fileobj, events)
+        # logger.debug("loop done")
+
+    def stop(self):
+        """Try to stop nicely"""
+        os.write(self._stop_pipe_wfd, b"Q")
+        self.join()
+        self.exit_stack.close()
+
+    def __enter__(self):
+        self.start()
+        return self
+
+    def __exit__(self, *args):
+        self.stop()
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_bind.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_bind.py
new file mode 100644
index 000000000000..980954098e97
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_bind.py
@@ -0,0 +1,143 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Test TCP-AO keys can be bound to specific remote addresses"""
+from contextlib import ExitStack
+import socket
+import pytest
+from .netns_fixture import NamespaceFixture
+from .utils import create_listen_socket
+from .server import SimpleServerThread
+from . import linux_tcp_authopt
+from .linux_tcp_authopt import (
+    tcp_authopt,
+    set_tcp_authopt,
+    set_tcp_authopt_key,
+    tcp_authopt_key,
+)
+from .utils import netns_context, DEFAULT_TCP_SERVER_PORT, check_socket_echo
+from .conftest import skipif_missing_tcp_authopt
+
+pytestmark = skipif_missing_tcp_authopt
+
+
+@pytest.mark.parametrize("address_family", [socket.AF_INET, socket.AF_INET6])
+def test_addr_server_bind(exit_stack: ExitStack, address_family):
+    """ "Server only accept client2, check client1 fails"""
+    nsfixture = exit_stack.enter_context(NamespaceFixture())
+    server_addr = str(nsfixture.get_addr(address_family, 1, 1))
+    client_addr = str(nsfixture.get_addr(address_family, 2, 1))
+    client_addr2 = str(nsfixture.get_addr(address_family, 2, 2))
+
+    # create server:
+    listen_socket = exit_stack.push(
+        create_listen_socket(family=address_family, ns=nsfixture.ns1_name)
+    )
+    exit_stack.enter_context(SimpleServerThread(listen_socket, mode="echo"))
+
+    # set keys:
+    server_key = tcp_authopt_key(
+        alg=linux_tcp_authopt.TCP_AUTHOPT_ALG_HMAC_SHA_1_96,
+        key="hello",
+        flags=linux_tcp_authopt.TCP_AUTHOPT_KEY_BIND_ADDR,
+        addr=client_addr2,
+    )
+    set_tcp_authopt(
+        listen_socket,
+        tcp_authopt(flags=linux_tcp_authopt.TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED),
+    )
+    set_tcp_authopt_key(listen_socket, server_key)
+
+    # create client socket:
+    def create_client_socket():
+        with netns_context(nsfixture.ns2_name):
+            client_socket = socket.socket(address_family, socket.SOCK_STREAM)
+        client_key = tcp_authopt_key(
+            alg=linux_tcp_authopt.TCP_AUTHOPT_ALG_HMAC_SHA_1_96,
+            key="hello",
+        )
+        set_tcp_authopt_key(client_socket, client_key)
+        return client_socket
+
+    # addr match:
+    # with create_client_socket() as client_socket2:
+    #    client_socket2.bind((client_addr2, 0))
+    #    client_socket2.settimeout(1.0)
+    #    client_socket2.connect((server_addr, TCP_SERVER_PORT))
+
+    # addr mismatch:
+    with create_client_socket() as client_socket1:
+        client_socket1.bind((client_addr, 0))
+        with pytest.raises(socket.timeout):
+            client_socket1.settimeout(1.0)
+            client_socket1.connect((server_addr, DEFAULT_TCP_SERVER_PORT))
+
+
+@pytest.mark.parametrize("address_family", [socket.AF_INET, socket.AF_INET6])
+def test_addr_client_bind(exit_stack: ExitStack, address_family):
+    """ "Client configures different keys with same id but different addresses"""
+    nsfixture = exit_stack.enter_context(NamespaceFixture())
+    server_addr1 = str(nsfixture.get_addr(address_family, 1, 1))
+    server_addr2 = str(nsfixture.get_addr(address_family, 1, 2))
+    client_addr = str(nsfixture.get_addr(address_family, 2, 1))
+
+    # create servers:
+    listen_socket1 = exit_stack.enter_context(
+        create_listen_socket(
+            family=address_family, ns=nsfixture.ns1_name, bind_addr=server_addr1
+        )
+    )
+    listen_socket2 = exit_stack.enter_context(
+        create_listen_socket(
+            family=address_family, ns=nsfixture.ns1_name, bind_addr=server_addr2
+        )
+    )
+    exit_stack.enter_context(SimpleServerThread(listen_socket1, mode="echo"))
+    exit_stack.enter_context(SimpleServerThread(listen_socket2, mode="echo"))
+
+    # set keys:
+    set_tcp_authopt_key(
+        listen_socket1,
+        tcp_authopt_key(
+            alg=linux_tcp_authopt.TCP_AUTHOPT_ALG_HMAC_SHA_1_96,
+            key="11111",
+        ),
+    )
+    set_tcp_authopt_key(
+        listen_socket2,
+        tcp_authopt_key(
+            alg=linux_tcp_authopt.TCP_AUTHOPT_ALG_HMAC_SHA_1_96,
+            key="22222",
+        ),
+    )
+
+    # create client socket:
+    def create_client_socket():
+        with netns_context(nsfixture.ns2_name):
+            client_socket = socket.socket(address_family, socket.SOCK_STREAM)
+        set_tcp_authopt_key(
+            client_socket,
+            tcp_authopt_key(
+                alg=linux_tcp_authopt.TCP_AUTHOPT_ALG_HMAC_SHA_1_96,
+                key="11111",
+                flags=linux_tcp_authopt.TCP_AUTHOPT_KEY_BIND_ADDR,
+                addr=server_addr1,
+            ),
+        )
+        set_tcp_authopt_key(
+            client_socket,
+            tcp_authopt_key(
+                alg=linux_tcp_authopt.TCP_AUTHOPT_ALG_HMAC_SHA_1_96,
+                key="22222",
+                flags=linux_tcp_authopt.TCP_AUTHOPT_KEY_BIND_ADDR,
+                addr=server_addr2,
+            ),
+        )
+        client_socket.settimeout(1.0)
+        client_socket.bind((client_addr, 0))
+        return client_socket
+
+    with create_client_socket() as client_socket1:
+        client_socket1.connect((server_addr1, DEFAULT_TCP_SERVER_PORT))
+        check_socket_echo(client_socket1)
+    with create_client_socket() as client_socket2:
+        client_socket2.connect((server_addr2, DEFAULT_TCP_SERVER_PORT))
+        check_socket_echo(client_socket2)
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/utils.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/utils.py
new file mode 100644
index 000000000000..22bd3f0a142a
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/utils.py
@@ -0,0 +1,154 @@
+# SPDX-License-Identifier: GPL-2.0
+import json
+import random
+import subprocess
+import threading
+import typing
+import socket
+from dataclasses import dataclass
+from contextlib import nullcontext
+
+from nsenter import Namespace
+from scapy.sendrecv import AsyncSniffer
+
+
+# TCP port does not impact Authentication Option so define a single default
+DEFAULT_TCP_SERVER_PORT = 17971
+
+
+class SimpleWaitEvent(threading.Event):
+    @property
+    def value(self) -> bool:
+        return self.is_set()
+
+    @value.setter
+    def value(self, value: bool):
+        if value:
+            self.set()
+        else:
+            self.clear()
+
+    def wait(self, timeout=None):
+        """Like Event.wait except raise on timeout"""
+        super().wait(timeout)
+        if not self.is_set():
+            raise TimeoutError(f"Timed out timeout={timeout!r}")
+
+
+def recvall(sock, todo):
+    """Receive exactly todo bytes unless EOF"""
+    data = bytes()
+    while True:
+        chunk = sock.recv(todo)
+        if not len(chunk):
+            return data
+        data += chunk
+        todo -= len(chunk)
+        if todo == 0:
+            return data
+        assert todo > 0
+
+
+def randbytes(count) -> bytes:
+    """Return a random byte array"""
+    return bytes([random.randint(0, 255) for index in range(count)])
+
+
+def check_socket_echo(sock, size=1024):
+    """Send random bytes and check they are received"""
+    send_buf = randbytes(size)
+    sock.sendall(send_buf)
+    recv_buf = recvall(sock, size)
+    assert send_buf == recv_buf
+
+
+def nstat_json(command_prefix: str = ""):
+    """Parse nstat output into a python dict"""
+    runres = subprocess.run(
+        f"{command_prefix}nstat -a --zeros --json",
+        shell=True,
+        check=True,
+        stdout=subprocess.PIPE,
+        encoding="utf-8",
+    )
+    return json.loads(runres.stdout)
+
+
+def netns_context(ns: str = ""):
+    """Create context manager for a certain optional netns
+
+    If the ns argument is empty then just return a `nullcontext`
+    """
+    if ns:
+        return Namespace("/var/run/netns/" + ns, "net")
+    else:
+        return nullcontext()
+
+
+def create_listen_socket(
+    ns: str = "",
+    family=socket.AF_INET,
+    reuseaddr=True,
+    listen_depth=10,
+    bind_addr="",
+    bind_port=DEFAULT_TCP_SERVER_PORT,
+):
+    with netns_context(ns):
+        listen_socket = socket.socket(family, socket.SOCK_STREAM)
+    if reuseaddr:
+        listen_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
+    listen_socket.bind((str(bind_addr), bind_port))
+    listen_socket.listen(listen_depth)
+    return listen_socket
+
+
+@dataclass
+class tcphdr_authopt:
+    """Representation of a TCP auth option as it appears in a TCP packet"""
+
+    keyid: int
+    rnextkeyid: int
+    mac: bytes
+
+    @classmethod
+    def unpack(cls, buf) -> "tcphdr_authopt":
+        return cls(buf[0], buf[1], buf[2:])
+
+    def __repr__(self):
+        return f"tcphdr_authopt({self.keyid}, {self.rnextkeyid}, bytes.fromhex({self.mac.hex(' ')!r})"
+
+
+def scapy_tcp_get_authopt_val(tcp) -> typing.Optional[tcphdr_authopt]:
+    for optnum, optval in tcp.options:
+        if optnum == 29:
+            return tcphdr_authopt.unpack(optval)
+    return None
+
+
+def scapy_sniffer_start_block(sniffer: AsyncSniffer, timeout=1):
+    """Like AsyncSniffer.start except block until sniffing starts
+
+    This ensures no lost packets and no delays
+    """
+    if sniffer.kwargs.get("started_callback"):
+        raise ValueError("sniffer must not already have a started_callback")
+
+    e = SimpleWaitEvent()
+    sniffer.kwargs["started_callback"] = e.set
+    sniffer.start()
+    e.wait(timeout=timeout)
+
+
+def scapy_sniffer_stop(sniffer: AsyncSniffer):
+    """Like AsyncSniffer.stop except no error is raising if not running"""
+    if sniffer is not None and sniffer.running:
+        sniffer.stop()
+
+
+class AsyncSnifferContext(AsyncSniffer):
+    def __enter__(self):
+        scapy_sniffer_start_block(self)
+        return self
+
+    def __exit__(self, *a):
+        scapy_sniffer_stop(self)
-- 
2.25.1

