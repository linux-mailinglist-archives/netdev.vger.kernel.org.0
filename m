Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42714441E8D
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbhKAQjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbhKAQic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:32 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17269C06120B;
        Mon,  1 Nov 2021 09:35:59 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id r12so66541594edt.6;
        Mon, 01 Nov 2021 09:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B2WrctCyn/He5ee2APqEO63ozLYAdf1lhC/l4cc+WZg=;
        b=XaUCYPyVb3XGFqvFY+mZK8he0CE+6vz9ZX/4FLUhTudPnaZWUWZZU75zpoPWHvM0/D
         1VxoBFy3/6mQ3EW7YMZveHIDLiEMK+KyL6UTvzY22957yJggBIG8qLULBfCmEEr73aWr
         WeexGbRFsNY1QRWGfpl6T8YIvLo0vQhrkCh3wGhz9upizKb0JQmwQjjI9hKw1DDOjngS
         1iZe+xc8GdkFCIIKOwZYwI2N3zyYD1vJOwx+ehOZr+zMf15R+c0hy2YrVJmCa3Sd8uqp
         Mp85GASSX/U27ucjnE037nY30+j7aUJ9m5RxUsca5zmngaT8WCa/sH6Rskl0+QfRYwWA
         ec/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B2WrctCyn/He5ee2APqEO63ozLYAdf1lhC/l4cc+WZg=;
        b=CJQ1MrM6IcF1joAnRGfMBDk4WbWDogVYEQCTxkcFMqPB1RNnSQp669WixzRTU+GZcX
         cqo4SjGZz/MktAJ5+ePlXDQXloRreT+5lEbdAbDI0A1Iby+eay4if9RsxhSX7ZbmREPR
         9f/VeWpztrqZujz4IFBj93/NW6rKqwF5AOGSfYcSFeXY7SQ8o9bP4oYhRaEOLZRyM6Er
         3c3bQ6HtsNP9dPI5WUuQskMkMlr5qSMGTueq7ABtMEbsBPJOydJ36kvTl+ef4x1EclVp
         t6KI+AVT4ukMwgaL1daC34XuNcMJG8AYy7yyFDDRFzHA3aWvbKWjRvr+xdgvRfPZG/zO
         FWOA==
X-Gm-Message-State: AOAM532zpjv9qkXWTNIN8NDkm0sbCK6RL9Ni6CvPeohOn7YIOtpttAZ4
        lYl8AVPxX4RdCV9mqhWW9R4=
X-Google-Smtp-Source: ABdhPJzc9+Mh/hoEMmg4UbMVYD9tdEBc4ntT0vCOMkWE9eDSy4chZ2Y3Xmtv4HwVxiiPZNcE6KbN7A==
X-Received: by 2002:aa7:d494:: with SMTP id b20mr599902edr.243.1635784557481;
        Mon, 01 Nov 2021 09:35:57 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:56 -0700 (PDT)
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
Subject: [PATCH v2 17/25] selftests: tcp_authopt: Add packet-level tests
Date:   Mon,  1 Nov 2021 18:34:52 +0200
Message-Id: <f0492ff469c9246de9638f0be66254b67e9e3c03.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch validates that the TCP-AO signatures inserted by linux are
correct in all algorithm permutations, using scapy.

It also tests that TCP-AO behaves correctly in a number of corner cases
such as:

* reset handling
* timewait
* syn-recv
* ipv4-mapped ipv6
* interaction with tcp-md5

This reverts commit 297a301a4f1c3abe41d554a9f6df192257a017b8.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 .../full_tcp_sniff_session.py                 |  91 +++
 .../tcp_authopt_test/linux_tcp_md5sig.py      | 110 ++++
 .../tcp_authopt_test/scapy_conntrack.py       | 173 ++++++
 .../tcp_connection_fixture.py                 | 276 +++++++++
 .../tcp_authopt_test/test_verify_capture.py   | 559 ++++++++++++++++++
 5 files changed, 1209 insertions(+)
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/full_tcp_sniff_session.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_md5sig.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_conntrack.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/tcp_connection_fixture.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_verify_capture.py

diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/full_tcp_sniff_session.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/full_tcp_sniff_session.py
new file mode 100644
index 000000000000..d37f7d947bcd
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/full_tcp_sniff_session.py
@@ -0,0 +1,91 @@
+# SPDX-License-Identifier: GPL-2.0
+import logging
+import threading
+import typing
+
+import scapy.sessions
+from scapy.packet import Packet
+
+from .scapy_conntrack import TCPConnectionInfo, TCPConnectionTracker
+
+logger = logging.getLogger(__name__)
+
+
+class FullTCPSniffSession(scapy.sessions.DefaultSession):
+    """Implementation of a scapy sniff session that can wait for a full TCP capture
+
+    Allows another thread to wait for a complete FIN handshake without polling or sleep.
+    """
+
+    #: Server port used to identify client and server
+    server_port: int
+    #: Connection tracker
+    tracker: TCPConnectionTracker
+
+    def __init__(self, server_port, **kw):
+        super().__init__(**kw)
+        self.server_port = server_port
+        self.tracker = TCPConnectionTracker()
+        self._close_event = threading.Event()
+        self._init_isn_event = threading.Event()
+        self._client_info = None
+        self._server_info = None
+
+    @property
+    def client_info(self) -> TCPConnectionInfo:
+        if not self._client_info:
+            self._client_info = self.tracker.match_one(dport=self.server_port)
+        return self._client_info
+
+    @property
+    def server_info(self) -> TCPConnectionInfo:
+        if not self._server_info:
+            self._server_info = self.tracker.match_one(sport=self.server_port)
+        return self._server_info
+
+    @property
+    def client_isn(self):
+        return self.client_info.sisn
+
+    @property
+    def server_isn(self):
+        return self.server_info.sisn
+
+    def on_packet_received(self, p: Packet):
+        super().on_packet_received(p)
+        self.tracker.handle_packet(p)
+
+        # check events:
+        if self.client_info.sisn is not None and self.client_info.disn is not None:
+            assert (
+                self.client_info.sisn == self.server_info.disn
+                and self.server_info.sisn == self.client_info.disn
+            )
+            self._init_isn_event.set()
+        if self.client_info.found_recv_finack and self.server_info.found_recv_finack:
+            self._close_event.set()
+
+    def reset(self):
+        """Reset known information about client/server"""
+        self.tracker.reset()
+        self._server_info = None
+        self._client_info = None
+        self._close_event.clear()
+        self._init_isn_event.clear()
+
+    def wait_close(self, timeout=10):
+        """Wait for a graceful close with FINs acked by both side"""
+        self._close_event.wait(timeout=timeout)
+        if not self._close_event.is_set():
+            raise TimeoutError("Timed out waiting for graceful close")
+
+    def wait_init_isn(self, timeout=10):
+        """Wait for both client_isn and server_isn to be determined"""
+        self._init_isn_event.wait(timeout=timeout)
+        if not self._init_isn_event.is_set():
+            raise TimeoutError("Timed out waiting for Initial Sequence Numbers")
+
+    def get_client_server_isn(self, timeout=10) -> typing.Tuple[int, int]:
+        """Return client/server ISN, blocking until they are captured"""
+        self.wait_init_isn(timeout=timeout)
+        return self.client_isn, self.server_isn
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_md5sig.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_md5sig.py
new file mode 100644
index 000000000000..5cfd0428672a
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_md5sig.py
@@ -0,0 +1,110 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Python wrapper around linux TCP_MD5SIG ABI"""
+
+import socket
+import struct
+import typing
+from dataclasses import dataclass
+from enum import IntFlag
+
+from .sockaddr import sockaddr_convert, sockaddr_unpack
+
+TCP_MD5SIG = 14
+TCP_MD5SIG_EXT = 32
+TCP_MD5SIG_MAXKEYLEN = 80
+
+
+class TCP_MD5SIG_FLAG(IntFlag):
+    PREFIX = 0x1
+    IFINDEX = 0x2
+
+
+@dataclass
+class tcp_md5sig:
+    """Like linux struct tcp_md5sig"""
+
+    addr: typing.Any
+    flags: typing.Optional[int]
+    prefixlen: typing.Optional[int]
+    keylen: typing.Optional[int]
+    ifindex: typing.Optional[int]
+    key: bytes
+
+    sizeof = 128 + 88
+
+    def __init__(
+        self, addr=None, flags=None, prefixlen=None, keylen=None, ifindex=0, key=bytes()
+    ):
+        self.addr = addr
+        self.flags = flags
+        self.prefixlen = prefixlen
+        self.ifindex = ifindex
+        self.key = key
+        self.keylen = keylen
+
+    def get_auto_flags(self):
+        return (TCP_MD5SIG_FLAG.PREFIX if self.prefixlen is not None else 0) | (
+            TCP_MD5SIG_FLAG.IFINDEX if self.ifindex else 0
+        )
+
+    def get_real_flags(self):
+        if self.flags is None:
+            return self.get_auto_flags()
+        else:
+            return self.flags
+
+    def get_addr_bytes(self) -> bytes:
+        if self.addr is None:
+            return b"\0" * 128
+        if self.addr is bytes:
+            assert len(self.addr) == 128
+            return self.addr
+        return sockaddr_convert(self.addr).pack()
+
+    def pack(self) -> bytes:
+        return struct.pack(
+            "128sBBHi80s",
+            self.get_addr_bytes(),
+            self.get_real_flags(),
+            self.prefixlen if self.prefixlen is not None else 0,
+            self.keylen if self.keylen is not None else len(self.key),
+            self.ifindex if self.ifindex is not None else 0,
+            self.key,
+        )
+
+    def __bytes__(self):
+        return self.pack()
+
+    @classmethod
+    def unpack(cls, buffer: bytes) -> "tcp_md5sig":
+        tup = struct.unpack("128sBBHi80s", buffer)
+        addr = sockaddr_unpack(tup[0])
+        return cls(addr, *tup[1:])
+
+    def set_ipv4_addr_all(self):
+        from .sockaddr import sockaddr_in
+
+        self.addr = sockaddr_in()
+        self.prefixlen = 0
+
+    def set_ipv6_addr_all(self):
+        from .sockaddr import sockaddr_in6
+
+        self.addr = sockaddr_in6()
+        self.prefixlen = 0
+
+
+def setsockopt_md5sig(sock, opt: tcp_md5sig):
+    if opt.flags != 0:
+        optname = TCP_MD5SIG_EXT
+    else:
+        optname = TCP_MD5SIG
+    return sock.setsockopt(socket.SOL_TCP, optname, bytes(opt))
+
+
+def setsockopt_md5sig_kwargs(sock, opt: tcp_md5sig = None, **kw):
+    if opt is None:
+        opt = tcp_md5sig()
+    for k, v in kw.items():
+        setattr(opt, k, v)
+    return setsockopt_md5sig(sock, opt)
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_conntrack.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_conntrack.py
new file mode 100644
index 000000000000..0f7cba70a917
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_conntrack.py
@@ -0,0 +1,173 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Identify TCP connections inside a capture and collect per-connection information"""
+import typing
+from dataclasses import dataclass
+
+from scapy.layers.inet import TCP
+from scapy.packet import Packet
+
+from .scapy_utils import IPvXAddress, get_packet_ipvx_dst, get_packet_ipvx_src
+from .sne_alg import SequenceNumberExtenderLinux
+
+
+@dataclass(frozen=True)
+class TCPConnectionKey:
+    """TCP connection identification key: standard 4-tuple"""
+
+    saddr: typing.Optional[IPvXAddress] = None
+    daddr: typing.Optional[IPvXAddress] = None
+    sport: int = 0
+    dport: int = 0
+
+    def rev(self) -> "TCPConnectionKey":
+        return TCPConnectionKey(self.daddr, self.saddr, self.dport, self.sport)
+
+
+def get_packet_tcp_connection_key(p: Packet) -> TCPConnectionKey:
+    th = p[TCP]
+    return TCPConnectionKey(
+        get_packet_ipvx_src(p), get_packet_ipvx_dst(p), th.sport, th.dport
+    )
+
+
+class TCPConnectionInfo:
+    saddr: typing.Optional[IPvXAddress] = None
+    daddr: typing.Optional[IPvXAddress] = None
+    sport: int = 0
+    dport: int = 0
+    sisn: typing.Optional[int] = None
+    disn: typing.Optional[int] = None
+    rcv_sne: SequenceNumberExtenderLinux
+    snd_sne: SequenceNumberExtenderLinux
+
+    found_syn = False
+    found_synack = False
+
+    found_send_fin = False
+    found_send_finack = False
+    found_recv_fin = False
+    found_recv_finack = False
+
+    def __init__(self):
+        self.rcv_sne = SequenceNumberExtenderLinux()
+        self.snd_sne = SequenceNumberExtenderLinux()
+
+    def get_key(self):
+        return TCPConnectionKey(self.saddr, self.daddr, self.sport, self.dport)
+
+    @classmethod
+    def from_key(cls, key: TCPConnectionKey) -> "TCPConnectionInfo":
+        obj = cls()
+        obj.saddr = key.saddr
+        obj.daddr = key.daddr
+        obj.sport = key.sport
+        obj.dport = key.dport
+        return obj
+
+    def handle_send(self, p: Packet):
+        th = p[TCP]
+        if self.get_key() != get_packet_tcp_connection_key(p):
+            raise ValueError("Packet not for this connection")
+
+        if th.flags.S and not th.flags.A:
+            assert th.ack == 0
+            self.found_syn = True
+            self.sisn = th.seq
+            self.snd_sne.reset(th.seq)
+        elif th.flags.S and th.flags.A:
+            self.found_synack = True
+            self.sisn = th.seq
+            self.snd_sne.reset(th.seq)
+            assert self.disn == th.ack - 1
+
+        # Should track seq numbers instead
+        if th.flags.F:
+            self.found_send_fin = True
+        if th.flags.A and self.found_recv_fin:
+            self.found_send_finack = True
+
+        # Should only take valid packets into account
+        self.snd_sne.calc(th.seq)
+
+    def handle_recv(self, p: Packet):
+        th = p[TCP]
+        if self.get_key().rev() != get_packet_tcp_connection_key(p):
+            raise ValueError("Packet not for this connection")
+
+        if th.flags.S and not th.flags.A:
+            assert th.ack == 0
+            self.found_syn = True
+            self.disn = th.seq
+            self.rcv_sne.reset(th.seq)
+        elif th.flags.S and th.flags.A:
+            self.found_synack = True
+            self.disn = th.seq
+            self.rcv_sne.reset(th.seq)
+            assert self.sisn == th.ack - 1
+
+        # Should track seq numbers instead
+        if th.flags.F:
+            self.found_recv_fin = True
+        if th.flags.A and self.found_send_fin:
+            self.found_recv_finack = True
+
+        # Should only take valid packets into account
+        self.rcv_sne.calc(th.seq)
+
+
+class TCPConnectionTracker:
+    table: typing.Dict[TCPConnectionKey, TCPConnectionInfo]
+
+    def __init__(self):
+        self.table = {}
+
+    def reset(self):
+        """Forget known connections"""
+        self.table = {}
+
+    def get_or_create(self, key: TCPConnectionKey) -> TCPConnectionInfo:
+        info = self.table.get(key, None)
+        if info is None:
+            info = TCPConnectionInfo.from_key(key)
+            self.table[key] = info
+        return info
+
+    def get(self, key: TCPConnectionKey) -> typing.Optional[TCPConnectionInfo]:
+        return self.table.get(key, None)
+
+    def handle_packet(self, p: Packet):
+        if not p or not TCP in p:
+            return
+        key = get_packet_tcp_connection_key(p)
+        info = self.get_or_create(key)
+        info.handle_send(p)
+        rkey = key.rev()
+        rinfo = self.get_or_create(rkey)
+        rinfo.handle_recv(p)
+
+    def iter_match(self, saddr=None, daddr=None, sport=None, dport=None):
+        def attr_optional_match(obj, name, val) -> bool:
+            if val is None:
+                return True
+            else:
+                return getattr(obj, name) == val
+
+        for key, info in self.table.items():
+            if (
+                attr_optional_match(key, "saddr", saddr)
+                and attr_optional_match(key, "daddr", daddr)
+                and attr_optional_match(key, "sport", sport)
+                and attr_optional_match(key, "dport", dport)
+            ):
+                yield info
+
+    def match_one(
+        self, saddr=None, daddr=None, sport=None, dport=None
+    ) -> typing.Optional[TCPConnectionInfo]:
+        res = list(self.iter_match(saddr, daddr, sport, dport))
+        if len(res) == 1:
+            return res[0]
+        elif len(res) == 0:
+            return None
+        else:
+            raise ValueError("Multiple connection matches")
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/tcp_connection_fixture.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/tcp_connection_fixture.py
new file mode 100644
index 000000000000..0d14f343c282
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/tcp_connection_fixture.py
@@ -0,0 +1,276 @@
+# SPDX-License-Identifier: GPL-2.0
+import logging
+import socket
+import subprocess
+from contextlib import ExitStack
+
+import pytest
+from scapy.data import ETH_P_IP, ETH_P_IPV6
+from scapy.layers.inet import IP, TCP
+from scapy.layers.inet6 import IPv6
+from scapy.layers.l2 import Ether
+from scapy.packet import Packet
+
+from . import linux_tcp_authopt
+from .full_tcp_sniff_session import FullTCPSniffSession
+from .linux_tcp_authopt import set_tcp_authopt_key, tcp_authopt_key
+from .netns_fixture import NamespaceFixture
+from .scapy_utils import (
+    AsyncSnifferContext,
+    create_capture_socket,
+    create_l2socket,
+    scapy_tcp_get_authopt_val,
+    scapy_tcp_get_md5_sig,
+)
+from .server import SimpleServerThread
+from .utils import (
+    DEFAULT_TCP_SERVER_PORT,
+    create_client_socket,
+    create_listen_socket,
+    netns_context,
+    nstat_json,
+)
+
+logger = logging.getLogger(__name__)
+
+
+class TCPConnectionFixture:
+    """Test fixture with an instrumented TCP connection
+
+    Includes:
+    * pair of network namespaces
+    * one listen socket
+    * server thread with echo protocol
+    * one client socket
+    * one async sniffer on the server interface
+    * A `FullTCPSniffSession` examining TCP packets
+    * l2socket allowing packet injection from client
+
+    :ivar tcp_md5_key: Secret key for md5 (addr is implicit)
+    """
+
+    sniffer_session: FullTCPSniffSession
+
+    def __init__(
+        self,
+        address_family=socket.AF_INET,
+        sniffer_kwargs=None,
+        tcp_authopt_key: tcp_authopt_key = None,
+        server_thread_kwargs=None,
+        tcp_md5_key=None,
+    ):
+        self.address_family = address_family
+        self.server_port = DEFAULT_TCP_SERVER_PORT
+        self.client_port = 27972
+        self.sniffer_session = FullTCPSniffSession(DEFAULT_TCP_SERVER_PORT)
+        if sniffer_kwargs is None:
+            sniffer_kwargs = {}
+        self.sniffer_kwargs = sniffer_kwargs
+        self.tcp_authopt_key = tcp_authopt_key
+        self.server_thread = SimpleServerThread(
+            mode="echo", **(server_thread_kwargs or {})
+        )
+        self.tcp_md5_key = tcp_md5_key
+
+    def _set_tcp_md5(self):
+        from . import linux_tcp_md5sig
+        from .sockaddr import sockaddr_convert
+
+        linux_tcp_md5sig.setsockopt_md5sig(
+            self.listen_socket,
+            linux_tcp_md5sig.tcp_md5sig(
+                key=self.tcp_md5_key, addr=sockaddr_convert(self.client_addr)
+            ),
+        )
+        linux_tcp_md5sig.setsockopt_md5sig(
+            self.client_socket,
+            linux_tcp_md5sig.tcp_md5sig(
+                key=self.tcp_md5_key, addr=sockaddr_convert(self.server_addr)
+            ),
+        )
+
+    def create_client_socket(self, bind_port=0):
+        return create_client_socket(
+            ns=self.nsfixture.client_netns_name,
+            family=self.address_family,
+            bind_addr=self.client_addr,
+            bind_port=bind_port,
+        )
+
+    def __enter__(self):
+        if self.tcp_authopt_key and not linux_tcp_authopt.has_tcp_authopt():
+            pytest.skip("Need TCP_AUTHOPT")
+
+        self.exit_stack = ExitStack()
+        self.exit_stack.__enter__()
+
+        self.nsfixture = self.exit_stack.enter_context(NamespaceFixture())
+        self.server_addr = self.nsfixture.get_addr(self.address_family, 1)
+        self.client_addr = self.nsfixture.get_addr(self.address_family, 2)
+
+        self.listen_socket = create_listen_socket(
+            ns=self.nsfixture.server_netns_name,
+            family=self.address_family,
+            bind_addr=self.server_addr,
+            bind_port=self.server_port,
+        )
+        self.exit_stack.enter_context(self.listen_socket)
+        self.client_socket = self.create_client_socket(bind_port=self.client_port)
+        self.exit_stack.enter_context(self.client_socket)
+        self.server_thread.add_listen_socket(self.listen_socket)
+        self.exit_stack.enter_context(self.server_thread)
+
+        if self.tcp_authopt_key:
+            set_tcp_authopt_key(self.listen_socket, self.tcp_authopt_key)
+            set_tcp_authopt_key(self.client_socket, self.tcp_authopt_key)
+
+        if self.tcp_md5_key:
+            self._set_tcp_md5()
+
+        capture_filter = f"tcp port {self.server_port}"
+        self.capture_socket = create_capture_socket(
+            ns=self.nsfixture.server_netns_name, iface="veth0", filter=capture_filter
+        )
+        self.exit_stack.enter_context(self.capture_socket)
+
+        self.sniffer = AsyncSnifferContext(
+            opened_socket=self.capture_socket,
+            session=self.sniffer_session,
+            prn=log_tcp_authopt_packet,
+            **self.sniffer_kwargs,
+        )
+        self.exit_stack.enter_context(self.sniffer)
+
+        self.client_l2socket = create_l2socket(
+            ns=self.nsfixture.client_netns_name, iface="veth0"
+        )
+        self.exit_stack.enter_context(self.client_l2socket)
+        self.server_l2socket = create_l2socket(
+            ns=self.nsfixture.server_netns_name, iface="veth0"
+        )
+        self.exit_stack.enter_context(self.server_l2socket)
+
+    def __exit__(self, *args):
+        self.exit_stack.__exit__(*args)
+
+    @property
+    def ethertype(self):
+        if self.address_family == socket.AF_INET:
+            return ETH_P_IP
+        elif self.address_family == socket.AF_INET6:
+            return ETH_P_IPV6
+        else:
+            raise ValueError("bad address_family={self.address_family}")
+
+    def scapy_iplayer(self):
+        if self.address_family == socket.AF_INET:
+            return IP
+        elif self.address_family == socket.AF_INET6:
+            return IPv6
+        else:
+            raise ValueError("bad address_family={self.address_family}")
+
+    def create_client2server_packet(self) -> Packet:
+        return (
+            Ether(
+                type=self.ethertype,
+                src=self.nsfixture.client_mac_addr,
+                dst=self.nsfixture.server_mac_addr,
+            )
+            / self.scapy_iplayer()(src=str(self.client_addr), dst=str(self.server_addr))
+            / TCP(sport=self.client_port, dport=self.server_port)
+        )
+
+    def create_server2client_packet(self) -> Packet:
+        return (
+            Ether(
+                type=self.ethertype,
+                src=self.nsfixture.server_mac_addr,
+                dst=self.nsfixture.client_mac_addr,
+            )
+            / self.scapy_iplayer()(src=str(self.server_addr), dst=str(self.client_addr))
+            / TCP(sport=self.server_port, dport=self.client_port)
+        )
+
+    @property
+    def server_addr_port(self):
+        return (str(self.server_addr), self.server_port)
+
+    @property
+    def server_netns_name(self):
+        return self.nsfixture.server_netns_name
+
+    @property
+    def client_netns_name(self):
+        return self.nsfixture.client_netns_name
+
+    def client_nstat_json(self):
+        with netns_context(self.client_netns_name):
+            return nstat_json()
+
+    def server_nstat_json(self):
+        with netns_context(self.server_netns_name):
+            return nstat_json()
+
+    def assert_no_snmp_output_failures(self):
+        client_nstat_dict = self.client_nstat_json()
+        assert client_nstat_dict["TcpExtTCPAuthOptFailure"] == 0
+        server_nstat_dict = self.server_nstat_json()
+        assert server_nstat_dict["TcpExtTCPAuthOptFailure"] == 0
+
+    def _get_state_via_ss(self, command_prefix: str):
+        # Every namespace should have at most one socket
+        # the "state connected" filter includes TIME-WAIT but not LISTEN
+        cmd = command_prefix + "ss --numeric --no-header --tcp state connected"
+        out = subprocess.check_output(cmd, text=True, shell=True)
+        lines = out.splitlines()
+        # No socket found usually means "CLOSED". It is distinct from "TIME-WAIT"
+        if len(lines) == 0:
+            return None
+        if len(lines) > 1:
+            raise ValueError("At most one line expected")
+        return lines[0].split()[0]
+
+    def get_client_tcp_state(self):
+        return self._get_state_via_ss(f"ip netns exec {self.client_netns_name} ")
+
+    def get_server_tcp_state(self):
+        return self._get_state_via_ss(f"ip netns exec {self.server_netns_name} ")
+
+
+def format_tcp_authopt_packet(
+    p: Packet, include_ethernet=False, include_seq=False, include_md5=True
+) -> str:
+    """Format a TCP packet in a way that is useful for TCP-AO testing"""
+    if not TCP in p:
+        return p.summary()
+    th = p[TCP]
+    if isinstance(th.underlayer, IP):
+        result = p.sprintf(r"%IP.src%:%TCP.sport% > %IP.dst%:%TCP.dport%")
+    elif isinstance(th.underlayer, IPv6):
+        result = p.sprintf(r"%IPv6.src%:%TCP.sport% > %IPv6.dst%:%TCP.dport%")
+    else:
+        raise ValueError(f"Unknown TCP underlayer {th.underlayer}")
+    result += p.sprintf(r" Flags %-2s,TCP.flags%")
+    if include_ethernet:
+        result = p.sprintf(r"ethertype %Ether.type% ") + result
+        result = p.sprintf(r"%Ether.src% > %Ether.dst% ") + result
+    if include_seq:
+        result += p.sprintf(r" seq %TCP.seq% ack %TCP.ack%")
+        result += f" len {len(p[TCP].payload)}"
+    authopt = scapy_tcp_get_authopt_val(p[TCP])
+    if authopt:
+        result += f" AO keyid={authopt.keyid} rnextkeyid={authopt.rnextkeyid} mac={authopt.mac.hex()}"
+    else:
+        result += " no AO"
+    if include_md5:
+        md5sig = scapy_tcp_get_md5_sig(p[TCP])
+        if md5sig:
+            result += f" MD5 {md5sig.hex()}"
+        else:
+            result += " no MD5"
+    return result
+
+
+def log_tcp_authopt_packet(p):
+    logger.info("sniff %s", format_tcp_authopt_packet(p, include_seq=True))
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_verify_capture.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_verify_capture.py
new file mode 100644
index 000000000000..68d002139974
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_verify_capture.py
@@ -0,0 +1,559 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Capture packets with TCP-AO and verify signatures"""
+
+import logging
+import os
+import socket
+import subprocess
+from contextlib import ExitStack, nullcontext
+
+import pytest
+import waiting
+from scapy.layers.inet import TCP
+
+from .conftest import (
+    raises_optional_exception,
+    skipif_cant_capture,
+    skipif_missing_tcp_authopt,
+)
+from .full_tcp_sniff_session import FullTCPSniffSession
+from .linux_tcp_authopt import (
+    TCP_AUTHOPT_ALG,
+    TCP_AUTHOPT_KEY_FLAG,
+    set_tcp_authopt_key,
+    tcp_authopt_key,
+)
+from .netns_fixture import NamespaceFixture
+from .scapy_tcp_authopt import (
+    TcpAuthOptAlg_HMAC_SHA1,
+    add_tcp_authopt_signature,
+    break_tcp_authopt_signature,
+)
+from .scapy_utils import (
+    AsyncSnifferContext,
+    scapy_sniffer_stop,
+    scapy_tcp_get_authopt_val,
+    scapy_tcp_get_md5_sig,
+    tcp_seq_wrap,
+)
+from .server import SimpleServerThread
+from .tcp_connection_fixture import TCPConnectionFixture
+from .utils import (
+    DEFAULT_TCP_SERVER_PORT,
+    check_socket_echo,
+    create_client_socket,
+    create_listen_socket,
+    nstat_json,
+    socket_set_linger,
+)
+from .validator import TcpAuthValidator, TcpAuthValidatorKey
+
+logger = logging.getLogger(__name__)
+pytestmark = [skipif_missing_tcp_authopt, skipif_cant_capture]
+DEFAULT_TCP_AUTHOPT_KEY = tcp_authopt_key(
+    alg=TCP_AUTHOPT_ALG.HMAC_SHA_1_96,
+    key=b"hello",
+)
+
+
+def get_alg_id(alg_name) -> int:
+    if alg_name == "HMAC-SHA-1-96":
+        return TCP_AUTHOPT_ALG.HMAC_SHA_1_96
+    elif alg_name == "AES-128-CMAC-96":
+        return TCP_AUTHOPT_ALG.AES_128_CMAC_96
+    else:
+        raise ValueError()
+
+
+@pytest.mark.parametrize(
+    "address_family,alg_name,include_options,transfer_data",
+    [
+        (socket.AF_INET, "HMAC-SHA-1-96", True, True),
+        (socket.AF_INET, "AES-128-CMAC-96", True, True),
+        (socket.AF_INET, "AES-128-CMAC-96", False, True),
+        (socket.AF_INET6, "HMAC-SHA-1-96", True, True),
+        (socket.AF_INET6, "HMAC-SHA-1-96", False, True),
+        (socket.AF_INET6, "AES-128-CMAC-96", True, True),
+        (socket.AF_INET, "HMAC-SHA-1-96", True, False),
+        (socket.AF_INET6, "AES-128-CMAC-96", False, False),
+    ],
+)
+def test_verify_capture(
+    exit_stack, address_family, alg_name, include_options, transfer_data
+):
+    master_key = b"testvector"
+    alg_id = get_alg_id(alg_name)
+
+    session = FullTCPSniffSession(server_port=DEFAULT_TCP_SERVER_PORT)
+    sniffer = exit_stack.enter_context(
+        AsyncSnifferContext(
+            filter=f"inbound and tcp port {DEFAULT_TCP_SERVER_PORT}",
+            iface="lo",
+            session=session,
+        )
+    )
+
+    listen_socket = create_listen_socket(family=address_family)
+    listen_socket = exit_stack.enter_context(listen_socket)
+    exit_stack.enter_context(SimpleServerThread(listen_socket, mode="echo"))
+
+    client_socket = socket.socket(address_family, socket.SOCK_STREAM)
+    client_socket = exit_stack.push(client_socket)
+
+    key = tcp_authopt_key(alg=alg_id, key=master_key, include_options=include_options)
+    set_tcp_authopt_key(listen_socket, key)
+    set_tcp_authopt_key(client_socket, key)
+
+    # even if one signature is incorrect keep processing the capture
+    old_nstat = nstat_json()
+    valkey = TcpAuthValidatorKey(
+        key=master_key, alg_name=alg_name, include_options=include_options
+    )
+    validator = TcpAuthValidator(keys=[valkey])
+
+    try:
+        client_socket.settimeout(1.0)
+        client_socket.connect(("localhost", DEFAULT_TCP_SERVER_PORT))
+        if transfer_data:
+            for _ in range(5):
+                check_socket_echo(client_socket)
+        client_socket.close()
+        session.wait_close()
+    except socket.timeout:
+        # If invalid packets are sent let the validator run
+        logger.warning("socket timeout", exc_info=True)
+        pass
+
+    sniffer.stop()
+
+    logger.info("capture: %r", sniffer.results)
+    for p in sniffer.results:
+        validator.handle_packet(p)
+    validator.raise_errors()
+
+    new_nstat = nstat_json()
+    assert old_nstat["TcpExtTCPAuthOptFailure"] == new_nstat["TcpExtTCPAuthOptFailure"]
+
+
+@pytest.mark.parametrize(
+    "address_family,use_tcp_authopt,use_tcp_md5sig",
+    [
+        (socket.AF_INET, 0, 0),
+        (socket.AF_INET, 1, 0),
+        (socket.AF_INET, 0, 1),
+        (socket.AF_INET6, 0, 0),
+        (socket.AF_INET6, 1, 0),
+        (socket.AF_INET6, 0, 1),
+        (socket.AF_INET, 1, 1),
+        (socket.AF_INET6, 1, 1),
+    ],
+)
+def test_both_authopt_md5(exit_stack, address_family, use_tcp_authopt, use_tcp_md5sig):
+    """Basic test for interaction between TCP_AUTHOPT and TCP_MD5SIG
+
+    Configuring both on same socket is allowed but RFC5925 doesn't allow both on the
+    same packet or same connection.
+
+    The naive handling of inserting or validation both options is incorrect.
+    """
+    con = TCPConnectionFixture(address_family=address_family)
+    if use_tcp_authopt:
+        con.tcp_authopt_key = DEFAULT_TCP_AUTHOPT_KEY
+    if use_tcp_md5sig:
+        con.tcp_md5_key = b"hello"
+    exit_stack.enter_context(con)
+
+    con.client_socket.connect(con.server_addr_port)
+    check_socket_echo(con.client_socket)
+    check_socket_echo(con.client_socket)
+    check_socket_echo(con.client_socket)
+    con.client_socket.close()
+
+    scapy_sniffer_stop(con.sniffer)
+    fail = False
+    for p in con.sniffer.results:
+        has_tcp_authopt = scapy_tcp_get_authopt_val(p[TCP]) is not None
+        has_tcp_md5sig = scapy_tcp_get_md5_sig(p[TCP]) is not None
+
+        if has_tcp_authopt and has_tcp_md5sig:
+            logger.error("Packet has both AO and MD5: %r", p)
+            fail = False
+
+        if use_tcp_authopt:
+            if not has_tcp_authopt:
+                logger.error("missing AO: %r", p)
+                fail = True
+        elif use_tcp_md5sig:
+            if not has_tcp_md5sig:
+                logger.error("missing MD5: %r", p)
+                fail = True
+        else:
+            if has_tcp_md5sig or has_tcp_authopt:
+                logger.error("unexpected MD5 or AO: %r", p)
+                fail = True
+
+    assert not fail
+
+
+@pytest.mark.parametrize("mode", ["none", "ao", "ao-addrbind", "md5"])
+def test_v4mapv6(exit_stack, mode: str):
+    """Test ipv4 client and ipv6 server with and without TCP-AO
+
+    By default any IPv6 server will also receive packets from IPv4 clients. This
+    is not currently supported by TCP_AUTHOPT but it should fail in an orderly
+    manner.
+    """
+    nsfixture = NamespaceFixture()
+    exit_stack.enter_context(nsfixture)
+    server_ipv4_addr = nsfixture.get_addr(socket.AF_INET, 1)
+
+    listen_socket = create_listen_socket(
+        ns=nsfixture.server_netns_name, family=socket.AF_INET6
+    )
+    listen_socket = exit_stack.enter_context(listen_socket)
+
+    server_thread = SimpleServerThread(listen_socket, mode="echo")
+    exit_stack.enter_context(server_thread)
+
+    client_socket = create_client_socket(
+        ns=nsfixture.client_netns_name,
+        family=socket.AF_INET,
+    )
+    client_socket = exit_stack.push(client_socket)
+
+    if mode == "ao":
+        alg = TCP_AUTHOPT_ALG.HMAC_SHA_1_96
+        key = tcp_authopt_key(alg=alg, key="hello")
+        set_tcp_authopt_key(listen_socket, key)
+        set_tcp_authopt_key(client_socket, key)
+
+    if mode == "ao-addrbind":
+        alg = TCP_AUTHOPT_ALG.HMAC_SHA_1_96
+        client_ipv6_addr = nsfixture.get_addr(socket.AF_INET6, 2)
+        server_key = tcp_authopt_key(alg=alg, key="hello", addr=client_ipv6_addr)
+        server_key.flags = TCP_AUTHOPT_KEY_FLAG.BIND_ADDR
+        set_tcp_authopt_key(listen_socket, server_key)
+
+        client_key = tcp_authopt_key(alg=alg, key="hello")
+        set_tcp_authopt_key(client_socket, client_key)
+
+    if mode == "md5":
+        from . import linux_tcp_md5sig
+
+        server_md5key = linux_tcp_md5sig.tcp_md5sig(key=b"hello")
+        server_md5key.set_ipv6_addr_all()
+        linux_tcp_md5sig.setsockopt_md5sig(listen_socket, server_md5key)
+        client_md5key = linux_tcp_md5sig.tcp_md5sig(key=b"hellx")
+        client_md5key.set_ipv4_addr_all()
+        linux_tcp_md5sig.setsockopt_md5sig(client_socket, client_md5key)
+
+    with raises_optional_exception(socket.timeout if mode != "none" else None):
+        client_socket.connect((str(server_ipv4_addr), DEFAULT_TCP_SERVER_PORT))
+        check_socket_echo(client_socket)
+    client_socket.close()
+
+
+@pytest.mark.parametrize(
+    "address_family,signed",
+    [
+        (socket.AF_INET, True),
+        (socket.AF_INET, False),
+        (socket.AF_INET6, True),
+        (socket.AF_INET6, False),
+    ],
+)
+def test_rst(exit_stack: ExitStack, address_family, signed: bool):
+    """Check that an unsigned RST breaks a normal connection but not one protected by TCP-AO"""
+
+    con = TCPConnectionFixture(address_family=address_family)
+    if signed:
+        con.tcp_authopt_key = DEFAULT_TCP_AUTHOPT_KEY
+    exit_stack.enter_context(con)
+
+    # connect
+    con.client_socket.connect(con.server_addr_port)
+    check_socket_echo(con.client_socket)
+
+    client_isn, server_isn = con.sniffer_session.get_client_server_isn()
+    p = con.create_client2server_packet()
+    p[TCP].flags = "R"
+    p[TCP].seq = tcp_seq_wrap(client_isn + 1001)
+    p[TCP].ack = tcp_seq_wrap(server_isn + 1001)
+    con.client_l2socket.send(p)
+
+    if signed:
+        # When protected by TCP-AO unsigned RSTs are ignored.
+        check_socket_echo(con.client_socket)
+    else:
+        # By default an RST that guesses seq can kill the connection.
+        with pytest.raises(ConnectionResetError):
+            check_socket_echo(con.client_socket)
+
+
+@pytest.mark.parametrize("address_family", [socket.AF_INET, socket.AF_INET6])
+def test_rst_signed_manually(exit_stack: ExitStack, address_family):
+    """Check that an manually signed RST breaks a connection protected by TCP-AO"""
+
+    con = TCPConnectionFixture(address_family=address_family)
+    con.tcp_authopt_key = key = DEFAULT_TCP_AUTHOPT_KEY
+    exit_stack.enter_context(con)
+
+    # connect
+    con.client_socket.connect(con.server_addr_port)
+    check_socket_echo(con.client_socket)
+
+    client_isn, server_isn = con.sniffer_session.get_client_server_isn()
+    p = con.create_client2server_packet()
+    p[TCP].flags = "R"
+    p[TCP].seq = tcp_seq_wrap(client_isn + 1001)
+    p[TCP].ack = tcp_seq_wrap(server_isn + 1001)
+
+    add_tcp_authopt_signature(
+        p, TcpAuthOptAlg_HMAC_SHA1(), key.key, client_isn, server_isn
+    )
+    con.client_l2socket.send(p)
+
+    # The server socket will close in response to RST without a TIME-WAIT
+    # Attempting to send additional packets will result in a timeout because
+    # the signature can't be validated.
+    with pytest.raises(socket.timeout):
+        check_socket_echo(con.client_socket)
+
+
+@pytest.mark.parametrize("address_family", [socket.AF_INET, socket.AF_INET6])
+def test_tw_ack(exit_stack: ExitStack, address_family):
+    """Manually sent a duplicate ACK after FIN and check TWSK signs replies correctly
+
+    Kernel has a custom code path for this
+    """
+
+    con = TCPConnectionFixture(address_family=address_family)
+    con.tcp_authopt_key = key = DEFAULT_TCP_AUTHOPT_KEY
+    exit_stack.enter_context(con)
+
+    # connect and close nicely
+    con.client_socket.connect(con.server_addr_port)
+    check_socket_echo(con.client_socket)
+    assert con.get_client_tcp_state() == "ESTAB"
+    assert con.get_server_tcp_state() == "ESTAB"
+    con.client_socket.close()
+    con.sniffer_session.wait_close()
+
+    assert con.get_client_tcp_state() == "TIME-WAIT"
+    assert con.get_server_tcp_state() is None
+
+    # Sent a duplicate FIN/ACK
+    client_isn, server_isn = con.sniffer_session.get_client_server_isn()
+    p = con.create_server2client_packet()
+    p[TCP].flags = "FA"
+    p[TCP].seq = tcp_seq_wrap(server_isn + 1001)
+    p[TCP].ack = tcp_seq_wrap(client_isn + 1002)
+    add_tcp_authopt_signature(
+        p, TcpAuthOptAlg_HMAC_SHA1(), key.key, server_isn, client_isn
+    )
+    pr = con.server_l2socket.sr1(p)
+    assert pr[TCP].ack == tcp_seq_wrap(server_isn + 1001)
+    assert pr[TCP].seq == tcp_seq_wrap(client_isn + 1001)
+    assert pr[TCP].flags == "A"
+
+    scapy_sniffer_stop(con.sniffer)
+
+    val = TcpAuthValidator()
+    val.keys.append(TcpAuthValidatorKey(key=b"hello", alg_name="HMAC-SHA-1-96"))
+    for p in con.sniffer.results:
+        val.handle_packet(p)
+    val.raise_errors()
+
+    # The server does not have enough state to validate the ACK from TIME-WAIT
+    # so it reports a failure.
+    assert con.server_nstat_json()["TcpExtTCPAuthOptFailure"] == 1
+    assert con.client_nstat_json()["TcpExtTCPAuthOptFailure"] == 0
+
+
+@pytest.mark.parametrize("address_family", [socket.AF_INET, socket.AF_INET6])
+def test_tw_rst(exit_stack: ExitStack, address_family):
+    """Manually sent a signed invalid packet after FIN and check TWSK signs RST correctly
+
+    Kernel has a custom code path for this
+    """
+    key = DEFAULT_TCP_AUTHOPT_KEY
+    con = TCPConnectionFixture(
+        address_family=address_family,
+        tcp_authopt_key=key,
+    )
+    con.server_thread.keep_half_open = True
+    exit_stack.enter_context(con)
+
+    # connect, transfer data and close client nicely
+    con.client_socket.connect(con.server_addr_port)
+    check_socket_echo(con.client_socket)
+    con.client_socket.close()
+
+    # since server keeps connection open client goes to FIN-WAIT-2
+    def check_socket_states():
+        client_tcp_state_name = con.get_client_tcp_state()
+        server_tcp_state_name = con.get_server_tcp_state()
+        logger.info("%s %s", client_tcp_state_name, server_tcp_state_name)
+        return (
+            client_tcp_state_name == "FIN-WAIT-2"
+            and server_tcp_state_name == "CLOSE-WAIT"
+        )
+
+    waiting.wait(check_socket_states)
+
+    # sending a FIN-ACK with incorrect seq makes
+    # tcp_timewait_state_process return a TCP_TW_RST
+    client_isn, server_isn = con.sniffer_session.get_client_server_isn()
+    p = con.create_server2client_packet()
+    p[TCP].flags = "FA"
+    p[TCP].seq = tcp_seq_wrap(server_isn + 1001 + 1)
+    p[TCP].ack = tcp_seq_wrap(client_isn + 1002)
+    add_tcp_authopt_signature(
+        p, TcpAuthOptAlg_HMAC_SHA1(), key.key, server_isn, client_isn
+    )
+    con.server_l2socket.send(p)
+
+    # remove delay by scapy trick?
+    import time
+
+    time.sleep(1)
+    scapy_sniffer_stop(con.sniffer)
+
+    # Check client socket moved from FIN-WAIT-2 to CLOSED
+    assert con.get_client_tcp_state() is None
+
+    # Check some RST was seen
+    def is_tcp_rst(p):
+        return TCP in p and p[TCP].flags.R
+
+    assert any(is_tcp_rst(p) for p in con.sniffer.results)
+
+    # Check everything was valid
+    val = TcpAuthValidator()
+    val.keys.append(TcpAuthValidatorKey(key=b"hello", alg_name="HMAC-SHA-1-96"))
+    for p in con.sniffer.results:
+        val.handle_packet(p)
+    val.raise_errors()
+
+    # Check no snmp failures
+    con.assert_no_snmp_output_failures()
+
+
+def test_rst_linger(exit_stack: ExitStack):
+    """Test RST sent deliberately via SO_LINGER is valid"""
+    con = TCPConnectionFixture(
+        sniffer_kwargs=dict(count=8), tcp_authopt_key=DEFAULT_TCP_AUTHOPT_KEY
+    )
+    exit_stack.enter_context(con)
+
+    con.client_socket.connect(con.server_addr_port)
+    check_socket_echo(con.client_socket)
+    socket_set_linger(con.client_socket, 1, 0)
+    con.client_socket.close()
+
+    con.sniffer.join(timeout=3)
+
+    val = TcpAuthValidator()
+    val.keys.append(TcpAuthValidatorKey(key=b"hello", alg_name="HMAC-SHA-1-96"))
+    for p in con.sniffer.results:
+        val.handle_packet(p)
+    val.raise_errors()
+
+    def is_tcp_rst(p):
+        return TCP in p and p[TCP].flags.R
+
+    assert any(is_tcp_rst(p) for p in con.sniffer.results)
+
+
+@pytest.mark.parametrize(
+    "address_family,mode",
+    [
+        (socket.AF_INET, "goodsign"),
+        (socket.AF_INET, "fakesign"),
+        (socket.AF_INET, "unsigned"),
+        (socket.AF_INET6, "goodsign"),
+        (socket.AF_INET6, "fakesign"),
+        (socket.AF_INET6, "unsigned"),
+    ],
+)
+def test_badack_to_synack(exit_stack, address_family, mode: str):
+    """Test bad ack in response to server to syn/ack.
+
+    This is handled by a minisocket in the TCP_SYN_RECV state on a separate code path
+    """
+    con = TCPConnectionFixture(address_family=address_family)
+    if mode != "unsigned":
+        con.tcp_authopt_key = tcp_authopt_key(
+            alg=TCP_AUTHOPT_ALG.HMAC_SHA_1_96,
+            key=b"hello",
+        )
+    exit_stack.enter_context(con)
+
+    client_l2socket = con.client_l2socket
+    client_isn = 1000
+    server_isn = 0
+
+    def sign(packet):
+        if mode == "unsigned":
+            return
+        add_tcp_authopt_signature(
+            packet,
+            TcpAuthOptAlg_HMAC_SHA1(),
+            con.tcp_authopt_key.key,
+            client_isn,
+            server_isn,
+        )
+
+    # Prevent TCP in client namespace from sending RST
+    # Do this by removing the client address and insert a static ARP on server side
+    client_prefix_length = con.nsfixture.get_prefix_length(address_family)
+    subprocess.run(
+        f"""\
+set -e
+ip netns exec {con.nsfixture.client_netns_name} ip addr del {con.client_addr}/{client_prefix_length} dev veth0
+ip netns exec {con.nsfixture.server_netns_name} ip neigh add {con.client_addr} lladdr {con.nsfixture.client_mac_addr} dev veth0
+""",
+        shell=True,
+        check=True,
+    )
+
+    p1 = con.create_client2server_packet()
+    p1[TCP].flags = "S"
+    p1[TCP].seq = client_isn
+    p1[TCP].ack = 0
+    sign(p1)
+
+    p2 = client_l2socket.sr1(p1, timeout=1)
+    server_isn = p2[TCP].seq
+    assert p2[TCP].ack == client_isn + 1
+    assert p2[TCP].flags == "SA"
+
+    p3 = con.create_client2server_packet()
+    p3[TCP].flags = "A"
+    p3[TCP].seq = client_isn + 1
+    p3[TCP].ack = server_isn + 1
+    sign(p3)
+    if mode == "fakesign":
+        break_tcp_authopt_signature(p3)
+
+    assert con.server_nstat_json()["TcpExtTCPAuthOptFailure"] == 0
+    client_l2socket.send(p3)
+
+    def confirm_good():
+        return len(con.server_thread.server_socket) > 0
+
+    def confirm_fail():
+        return con.server_nstat_json()["TcpExtTCPAuthOptFailure"] == 1
+
+    def wait_good():
+        assert not confirm_fail()
+        return confirm_good()
+
+    def wait_fail():
+        assert not confirm_good()
+        return confirm_fail()
+
+    if mode == "fakesign":
+        waiting.wait(wait_fail, timeout_seconds=5, sleep_seconds=0.1)
+    else:
+        waiting.wait(wait_good, timeout_seconds=5, sleep_seconds=0.1)
-- 
2.25.1

