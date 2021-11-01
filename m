Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A968C441E66
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhKAQiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbhKAQiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:20 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88850C061714;
        Mon,  1 Nov 2021 09:35:46 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r4so65633889edi.5;
        Mon, 01 Nov 2021 09:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t3iUkzKs6a3XJDVfNpYK8LJcRr0Bt7NB6W+eQj1+QVg=;
        b=mGOT0UiEZB+N7AoeZbYdTteff53857ivqufXN7NwWT9EKpTaG9Orq6h/GGq4FvrtYP
         DJ8c7xasY2PaUbYCV/AylQOHgUFZ6YWSUEhaRXliki0jJhHCKn//TAfKJanvfxGVVYP+
         bGm24IjX+iJwcTRb/frOr45s9soNEVsOSpdH0Ch88Ok7JUyuTmEijjhr7Z50jEOZMu4Z
         izbdjutXbpd1xNQdvizpt37U7ohN/ZtWwWLv1+DagytfYiXeFQtc+IK+jTYCtfn4NjOA
         XTsWbTAwxdNUHyE68lNTWc6jTNyf6CM8yHy3xGAyQgBbF0/lpaiez45RYPpKyNkDPnsb
         Pjqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t3iUkzKs6a3XJDVfNpYK8LJcRr0Bt7NB6W+eQj1+QVg=;
        b=wIa8hXobYhzUV4eQ0tEAdxMZtDtaGv4PxwnULQJNmKpSpFM+j9NYNrInd8lWCDExlx
         A7PQg2hHa1dSmmlPajASXosyJmcZQhbd+MnXRU1Pzzx3YMdu6LuR6NAh3CFDZ4LaRZof
         MmSqUAwEaFkws1lC+bpRlAqV41kf0E/dsFrAsoUFh4zhOd6zzfgR14JF8R/JCcbFRejX
         jFN1HEird369WAqACNX7SzTAfoJKxIP+MoxnVWcLreKjYKpHvgJ8EKUOnaXqHFJfHClp
         D03OyVu+w6Iy4PIqGHKC1r5R5qbqFgar4gxZlzOx7CWEOOkvFII0M/3BHJI/W+h3Hlel
         0UWg==
X-Gm-Message-State: AOAM5328iAvBJYQQ3p4mYaxx8y/5RjDdIBJDCuui5HlKEz3UCA5UPNEg
        jtXHtyQuTGU3U2t5eRRBcV0=
X-Google-Smtp-Source: ABdhPJyicnsYbkkWdIWuz+jfCQ/I+003lBUtWZOlNLwX4PhlpCSWtE02hW01cWFsyZY1ZVtAKJj3CQ==
X-Received: by 2002:a05:6402:50cd:: with SMTP id h13mr43128552edb.27.1635784545114;
        Mon, 01 Nov 2021 09:35:45 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:44 -0700 (PDT)
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
Subject: [PATCH v2 10/25] selftests: tcp_authopt: Test key address binding
Date:   Mon,  1 Nov 2021 18:34:45 +0200
Message-Id: <4b4f69bb41c21af41c9c8b8c9e2d939980d33ec2.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
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
 .../tcp_authopt_test/netns_fixture.py         |  85 ++++++++++
 .../tcp_authopt/tcp_authopt_test/server.py    | 124 ++++++++++++++
 .../tcp_authopt/tcp_authopt_test/test_bind.py | 155 ++++++++++++++++++
 .../tcp_authopt/tcp_authopt_test/utils.py     | 114 +++++++++++++
 4 files changed, 478 insertions(+)
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/netns_fixture.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/server.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_bind.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/utils.py

diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/netns_fixture.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/netns_fixture.py
new file mode 100644
index 000000000000..9c10fafd8694
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/netns_fixture.py
@@ -0,0 +1,85 @@
+# SPDX-License-Identifier: GPL-2.0
+import socket
+import subprocess
+from ipaddress import IPv4Address, IPv6Address
+
+from .conftest import raise_skip_no_netns
+
+
+class NamespaceFixture:
+    """Create a pair of namespaces connected by one veth pair
+
+    Each end of the pair has multiple addresses but everything is in the same subnet
+    """
+
+    server_netns_name = "tcp_authopt_test_server"
+    client_netns_name = "tcp_authopt_test_client"
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
+    # 02:* means "locally administered"
+    server_mac_addr = "02:00:00:00:00:01"
+    client_mac_addr = "02:00:00:00:00:02"
+
+    ipv4_prefix_len = 16
+    ipv6_prefix_len = 64
+
+    @classmethod
+    def get_prefix_length(cls, address_family) -> int:
+        return {
+            socket.AF_INET: cls.ipv4_prefix_len,
+            socket.AF_INET6: cls.ipv6_prefix_len,
+        }[address_family]
+
+    def __init__(self, **kw):
+        raise_skip_no_netns()
+        for k, v in kw.items():
+            setattr(self, k, v)
+
+    def __enter__(self):
+        self._del_netns()
+        script = f"""
+set -e
+ip netns add {self.server_netns_name}
+ip netns add {self.client_netns_name}
+ip link add veth0 netns {self.server_netns_name} type veth peer name veth0 netns {self.client_netns_name}
+ip netns exec {self.server_netns_name} ip link set veth0 up addr {self.server_mac_addr}
+ip netns exec {self.client_netns_name} ip link set veth0 up addr {self.client_mac_addr}
+"""
+        for index in [1, 2, 3]:
+            script += f"ip -n {self.server_netns_name} addr add {self.get_ipv4_addr(1, index)}/16 dev veth0\n"
+            script += f"ip -n {self.client_netns_name} addr add {self.get_ipv4_addr(2, index)}/16 dev veth0\n"
+            script += f"ip -n {self.server_netns_name} addr add {self.get_ipv6_addr(1, index)}/64 dev veth0 nodad\n"
+            script += f"ip -n {self.client_netns_name} addr add {self.get_ipv6_addr(2, index)}/64 dev veth0 nodad\n"
+        subprocess.run(script, shell=True, check=True)
+        return self
+
+    def _del_netns(self):
+        script = f"""\
+set -e
+if ip netns list | grep -q {self.server_netns_name}; then
+    ip netns del {self.server_netns_name}
+fi
+if ip netns list | grep -q {self.client_netns_name}; then
+    ip netns del {self.client_netns_name}
+fi
+"""
+        subprocess.run(script, shell=True, check=True)
+
+    def __exit__(self, *a):
+        self._del_netns()
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/server.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/server.py
new file mode 100644
index 000000000000..4cad2d61093b
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/server.py
@@ -0,0 +1,124 @@
+# SPDX-License-Identifier: GPL-2.0
+import logging
+import os
+import selectors
+import socket
+import typing
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
+
+    :ivar _listen_socket_list: List of listen sockets, not for direct manipulation.
+    :ivar server_socket: List of accepted sockets.
+    :ivar keep_half_open: do not close in response to remote close.
+    """
+
+    DEFAULT_BUFSIZE = 1000
+    _listen_socket_list: typing.List[socket.socket]
+    server_socket: typing.List[socket.socket]
+    sel: typing.Optional[selectors.BaseSelector]
+
+    def __init__(
+        self,
+        sockarg: typing.Union[None, socket.socket, typing.List[socket.socket]] = None,
+        mode="recv",
+        bufsize=DEFAULT_BUFSIZE,
+        keep_half_open=False,
+    ):
+        if isinstance(sockarg, socket.socket):
+            self._listen_socket_list = [sockarg]
+        elif isinstance(sockarg, list):
+            self._listen_socket_list = sockarg
+        elif sockarg is None:
+            self._listen_socket_list = []
+        else:
+            raise TypeError(f"Bad sockarg={sockarg!r}")
+        self.server_socket = []
+        self.bufsize = bufsize
+        self.keep_half_open = keep_half_open
+        self.mode = mode
+        self.sel = None
+        super().__init__()
+
+    def _read(self, conn, events):
+        # logger.debug("events=%r", events)
+        try:
+            data = conn.recv(self.bufsize)
+        except ConnectionResetError:
+            # logger.info("reset %r", conn)
+            conn.close()
+            self.sel.unregister(conn)
+            return
+        # logger.debug("len(data)=%r", len(data))
+        if len(data) == 0:
+            if not self.keep_half_open:
+                # logger.info("closing %r", conn)
+                conn.close()
+                self.sel.unregister(conn)
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
+        self.sel = self.exit_stack.enter_context(selectors.DefaultSelector())
+        self.sel.register(
+            self._stop_pipe_rfd,
+            selectors.EVENT_READ,
+            self._stop_pipe_read,
+        )
+        for sock in self._listen_socket_list:
+            self.sel.register(sock, selectors.EVENT_READ, self._accept)
+        self.should_loop = True
+        return super().start()
+
+    def _accept(self, sock, events):
+        # logger.info("accept on %r", sock)
+        conn, _addr = sock.accept()
+        conn = self.exit_stack.enter_context(conn)
+        conn.setblocking(False)
+        self.sel.register(conn, selectors.EVENT_READ, self._read)
+        self.server_socket.append(conn)
+
+    def add_listen_socket(self, sock):
+        self._listen_socket_list.append(sock)
+        if self.sel:
+            self.sel.register(sock, selectors.EVENT_READ, self._accept)
+
+    def run(self):
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
index 000000000000..73074535c9ca
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_bind.py
@@ -0,0 +1,155 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Test TCP-AO keys can be bound to specific remote addresses"""
+import socket
+from contextlib import ExitStack
+
+import pytest
+
+from .conftest import skipif_missing_tcp_authopt
+from .linux_tcp_authopt import (
+    TCP_AUTHOPT_ALG,
+    TCP_AUTHOPT_FLAG,
+    TCP_AUTHOPT_KEY_FLAG,
+    set_tcp_authopt,
+    set_tcp_authopt_key,
+    tcp_authopt,
+    tcp_authopt_key,
+)
+from .netns_fixture import NamespaceFixture
+from .server import SimpleServerThread
+from .utils import (
+    DEFAULT_TCP_SERVER_PORT,
+    check_socket_echo,
+    create_listen_socket,
+    netns_context,
+)
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
+        create_listen_socket(family=address_family, ns=nsfixture.server_netns_name)
+    )
+    exit_stack.enter_context(SimpleServerThread(listen_socket, mode="echo"))
+
+    # set keys:
+    server_key = tcp_authopt_key(
+        alg=TCP_AUTHOPT_ALG.HMAC_SHA_1_96,
+        key="hello",
+        flags=TCP_AUTHOPT_KEY_FLAG.BIND_ADDR,
+        addr=client_addr2,
+    )
+    set_tcp_authopt(
+        listen_socket,
+        tcp_authopt(flags=TCP_AUTHOPT_FLAG.REJECT_UNEXPECTED),
+    )
+    set_tcp_authopt_key(listen_socket, server_key)
+
+    # create client socket:
+    def create_client_socket():
+        with netns_context(nsfixture.client_netns_name):
+            client_socket = socket.socket(address_family, socket.SOCK_STREAM)
+        client_key = tcp_authopt_key(
+            alg=TCP_AUTHOPT_ALG.HMAC_SHA_1_96,
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
+    """Client configures different keys with same id but different addresses"""
+    nsfixture = exit_stack.enter_context(NamespaceFixture())
+    server_addr1 = str(nsfixture.get_addr(address_family, 1, 1))
+    server_addr2 = str(nsfixture.get_addr(address_family, 1, 2))
+    client_addr = str(nsfixture.get_addr(address_family, 2, 1))
+
+    # create servers:
+    listen_socket1 = exit_stack.enter_context(
+        create_listen_socket(
+            family=address_family,
+            ns=nsfixture.server_netns_name,
+            bind_addr=server_addr1,
+        )
+    )
+    listen_socket2 = exit_stack.enter_context(
+        create_listen_socket(
+            family=address_family,
+            ns=nsfixture.server_netns_name,
+            bind_addr=server_addr2,
+        )
+    )
+    exit_stack.enter_context(SimpleServerThread(listen_socket1, mode="echo"))
+    exit_stack.enter_context(SimpleServerThread(listen_socket2, mode="echo"))
+
+    # set keys:
+    set_tcp_authopt_key(
+        listen_socket1,
+        tcp_authopt_key(
+            alg=TCP_AUTHOPT_ALG.HMAC_SHA_1_96,
+            key="11111",
+        ),
+    )
+    set_tcp_authopt_key(
+        listen_socket2,
+        tcp_authopt_key(
+            alg=TCP_AUTHOPT_ALG.HMAC_SHA_1_96,
+            key="22222",
+        ),
+    )
+
+    # create client socket:
+    def create_client_socket():
+        with netns_context(nsfixture.client_netns_name):
+            client_socket = socket.socket(address_family, socket.SOCK_STREAM)
+        set_tcp_authopt_key(
+            client_socket,
+            tcp_authopt_key(
+                alg=TCP_AUTHOPT_ALG.HMAC_SHA_1_96,
+                key="11111",
+                flags=TCP_AUTHOPT_KEY_FLAG.BIND_ADDR,
+                addr=server_addr1,
+            ),
+        )
+        set_tcp_authopt_key(
+            client_socket,
+            tcp_authopt_key(
+                alg=TCP_AUTHOPT_ALG.HMAC_SHA_1_96,
+                key="22222",
+                flags=TCP_AUTHOPT_KEY_FLAG.BIND_ADDR,
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
index 000000000000..473e8e954d92
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/utils.py
@@ -0,0 +1,114 @@
+# SPDX-License-Identifier: GPL-2.0
+import json
+import random
+import socket
+import subprocess
+import typing
+from contextlib import nullcontext
+
+from nsenter import Namespace
+
+# TCP port does not impact Authentication Option so define a single default
+DEFAULT_TCP_SERVER_PORT = 17971
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
+def check_socket_echo(sock: socket.socket, size=1000):
+    """Send random bytes and check they are received
+
+    The default size is equal to `SimpleServerThread.DEFAULT_BUFSIZE` which
+    means that a single pair of packets will be sent at the TCP level.
+    """
+    send_buf = randbytes(size)
+    sock.sendall(send_buf)
+    recv_buf = recvall(sock, size)
+    assert send_buf == recv_buf
+
+
+def nstat_json(command_prefix: str = "", namespace=None):
+    """Parse nstat output into a python dict"""
+    if namespace is not None:
+        command_prefix += f"ip netns exec {namespace} "
+    runres = subprocess.run(
+        f"{command_prefix}nstat -a --zeros --json",
+        shell=True,
+        check=True,
+        stdout=subprocess.PIPE,
+        encoding="utf-8",
+    )
+    return json.loads(runres.stdout)["kernel"]
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
+def socket_set_bindtodevice(sock, dev: str):
+    """Set SO_BINDTODEVICE"""
+    opt = dev.encode("utf-8") + b"\0"
+    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE, opt)
+
+
+def create_listen_socket(
+    ns: str = "",
+    family=socket.AF_INET,
+    reuseaddr=True,
+    listen_depth=10,
+    bind_addr="",
+    bind_port=DEFAULT_TCP_SERVER_PORT,
+    bind_device: typing.Optional[str] = None,
+):
+    with netns_context(ns):
+        listen_socket = socket.socket(family, socket.SOCK_STREAM)
+    if reuseaddr:
+        listen_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
+    if bind_device:
+        socket_set_bindtodevice(listen_socket, bind_device)
+    listen_socket.bind((str(bind_addr), bind_port))
+    listen_socket.listen(listen_depth)
+    return listen_socket
+
+
+def create_client_socket(
+    ns: str = "", family=socket.AF_INET, bind_addr="", bind_port=0, timeout=1.0
+):
+    with netns_context(ns):
+        client_socket = socket.socket(family, socket.SOCK_STREAM)
+    if bind_addr or bind_port:
+        client_socket.bind((str(bind_addr), bind_port))
+    if timeout is not None:
+        client_socket.settimeout(timeout)
+    return client_socket
+
+
+def socket_set_linger(sock, onoff, value):
+    import struct
+
+    sock.setsockopt(
+        socket.SOL_SOCKET, socket.SO_LINGER, struct.pack("ii", int(onoff), int(value))
+    )
-- 
2.25.1

