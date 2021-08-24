Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8E13F6B23
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbhHXVgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbhHXVgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:36:17 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A8DC061764;
        Tue, 24 Aug 2021 14:35:32 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y5so2954305edp.8;
        Tue, 24 Aug 2021 14:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=autER7PyitAMFgEV0l7oy4w2DFTvFUx0CJDt9c8sGts=;
        b=adotWc98jGjOBo1FXUq00DR7sewFLxSKWDkuUeEFVbFQQf52xraWGwpXvnvuUgDoPp
         YplJQgo9am+KHB0D6Cy8ID+v//XQt0gz2i4jTWlGPcUT7fV0toCzKOR4TBxifm5H37go
         ZrCiUDc1Ve9ZgbPCyPxIsxMZZU2/Y4jhYO+zuSkQ/P8KkzoijWly0Fn2864odonKxDqU
         B352kizqBKPbE9r3o5Vg7U1HySslaL3MoIrZtUo0Czg/JJgHn1J/QaGIBkpqH48P0Rk+
         UlOzYecoSYjLf4NEVGAzZaUsmRhRBmhkiHzwvLzuhZK45mnNgE1W54NB3dfwULr7jc0Y
         XXeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=autER7PyitAMFgEV0l7oy4w2DFTvFUx0CJDt9c8sGts=;
        b=IbsoTqOR1sYl6sLtxWMZCqeXdjZpQbwD4nDEkHE5W62kp4sGnlndbMDyLlzhVg9CPm
         Xqa8WJ7hWphnvRXE8kb3r7dDyBTrKCOmzkKojg6khWC8oQAsNssJQCaP72+9pS4hmpoN
         2RroyDinhCdPpCiXWmGZ8gO3yxLrxm9HH1lml3d40lDP5/W8irS1scMsVTJkJNG6tMZP
         c9PCBLWV7dTf2AfBgrZjVSDBhbM7EXdzsLJQT1SN0WE9iMQAlM7j3yJS/DTyRe7xkv7t
         cjSUexhGD1UPFRYUzMyiu0siROH2qVJMVJ4poHdCIhoB6dJ/cKnHcBZYxeh+RyKsJoSk
         spgA==
X-Gm-Message-State: AOAM532HfRUD6vbTY0ktCjuPNpQLzepPE4WpXkFaBmZGOMzqG9SMrOG9
        /tNvWjtFp2ZCRxYacieMuC8=
X-Google-Smtp-Source: ABdhPJw972+rsM6aYWwSKQPgplrJhNl29soKx2dG+lCrG8IP8FlHJOZU3+2mmUZU6inCP1msbzoZvw==
X-Received: by 2002:a05:6402:289b:: with SMTP id eg27mr40367810edb.106.1629840930743;
        Tue, 24 Aug 2021 14:35:30 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ed0a:7326:fbac:b4c])
        by smtp.gmail.com with ESMTPSA id d16sm12348357edu.8.2021.08.24.14.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:35:30 -0700 (PDT)
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
Subject: [RFCv3 04/15] selftests: tcp_authopt: Initial sockopt manipulation
Date:   Wed, 25 Aug 2021 00:34:37 +0300
Message-Id: <e5d1d887325815300c92953575b2b5272e5bc0e5.1629840814.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1629840814.git.cdleonard@gmail.com>
References: <cover.1629840814.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 .../tcp_authopt/tcp_authopt_test/conftest.py  |  21 ++
 .../tcp_authopt_test/linux_tcp_authopt.py     | 188 ++++++++++++++++++
 .../tcp_authopt/tcp_authopt_test/sockaddr.py  | 101 ++++++++++
 .../tcp_authopt_test/test_sockopt.py          |  74 +++++++
 4 files changed, 384 insertions(+)
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/sockaddr.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py

diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py
new file mode 100644
index 000000000000..c17c8ea2a943
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py
@@ -0,0 +1,21 @@
+# SPDX-License-Identifier: GPL-2.0
+from tcp_authopt_test.linux_tcp_authopt import has_tcp_authopt
+import pytest
+import logging
+from contextlib import ExitStack
+
+logger = logging.getLogger(__name__)
+
+skipif_missing_tcp_authopt = pytest.mark.skipif(
+    not has_tcp_authopt(), reason="Need CONFIG_TCP_AUTHOPT"
+)
+
+
+@pytest.fixture
+def exit_stack():
+    """Return a contextlib.ExitStack as a pytest fixture
+
+    This reduces indentation making code more readable
+    """
+    with ExitStack() as exit_stack:
+        yield exit_stack
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
new file mode 100644
index 000000000000..41374f9851aa
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
@@ -0,0 +1,188 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Python wrapper around linux TCP_AUTHOPT ABI"""
+
+from dataclasses import dataclass
+from ipaddress import IPv4Address, IPv6Address, ip_address
+import socket
+import errno
+import logging
+from .sockaddr import sockaddr_in, sockaddr_in6, sockaddr_storage, sockaddr_unpack
+import typing
+import struct
+
+logger = logging.getLogger(__name__)
+
+
+def BIT(x):
+    return 1 << x
+
+
+TCP_AUTHOPT = 38
+TCP_AUTHOPT_KEY = 39
+
+TCP_AUTHOPT_MAXKEYLEN = 80
+
+TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED = BIT(2)
+
+TCP_AUTHOPT_KEY_DEL = BIT(0)
+TCP_AUTHOPT_KEY_EXCLUDE_OPTS = BIT(1)
+TCP_AUTHOPT_KEY_BIND_ADDR = BIT(2)
+
+TCP_AUTHOPT_ALG_HMAC_SHA_1_96 = 1
+TCP_AUTHOPT_ALG_AES_128_CMAC_96 = 2
+
+
+@dataclass
+class tcp_authopt:
+    """Like linux struct tcp_authopt"""
+
+    flags: int = 0
+    sizeof = 4
+
+    def pack(self) -> bytes:
+        return struct.pack(
+            "I",
+            self.flags,
+        )
+
+    def __bytes__(self):
+        return self.pack()
+
+    @classmethod
+    def unpack(cls, b: bytes):
+        tup = struct.unpack("I", b)
+        return cls(*tup)
+
+
+def set_tcp_authopt(sock, opt: tcp_authopt):
+    return sock.setsockopt(socket.IPPROTO_TCP, TCP_AUTHOPT, bytes(opt))
+
+
+def get_tcp_authopt(sock: socket.socket) -> tcp_authopt:
+    b = sock.getsockopt(socket.IPPROTO_TCP, TCP_AUTHOPT, tcp_authopt.sizeof)
+    return tcp_authopt.unpack(b)
+
+
+class tcp_authopt_key:
+    """Like linux struct tcp_authopt_key"""
+
+    def __init__(
+        self,
+        flags: int = 0,
+        send_id: int = 0,
+        recv_id: int = 0,
+        alg=TCP_AUTHOPT_ALG_HMAC_SHA_1_96,
+        key: bytes = b"",
+        addr: bytes = b"",
+        include_options=None,
+    ):
+        self.flags = flags
+        self.send_id = send_id
+        self.recv_id = recv_id
+        self.alg = alg
+        self.key = key
+        self.addr = addr
+        if include_options is not None:
+            self.include_options = include_options
+
+    def pack(self):
+        if len(self.key) > TCP_AUTHOPT_MAXKEYLEN:
+            raise ValueError(f"Max key length is {TCP_AUTHOPT_MAXKEYLEN}")
+        data = struct.pack(
+            "IBBBB80s",
+            self.flags,
+            self.send_id,
+            self.recv_id,
+            self.alg,
+            len(self.key),
+            self.key,
+        )
+        data += bytes(self.addrbuf.ljust(sockaddr_storage.sizeof, b"\x00"))
+        return data
+
+    def __bytes__(self):
+        return self.pack()
+
+    @property
+    def key(self) -> bytes:
+        return self._key
+
+    @key.setter
+    def key(self, val: typing.Union[bytes, str]) -> bytes:
+        if isinstance(val, str):
+            val = val.encode("utf-8")
+        if len(val) > TCP_AUTHOPT_MAXKEYLEN:
+            raise ValueError(f"Max key length is {TCP_AUTHOPT_MAXKEYLEN}")
+        self._key = val
+        return val
+
+    @property
+    def addr(self):
+        if not self.addrbuf:
+            return None
+        else:
+            return sockaddr_unpack(bytes(self.addrbuf))
+
+    @addr.setter
+    def addr(self, val):
+        if isinstance(val, bytes):
+            if len(val) > sockaddr_storage.sizeof:
+                raise ValueError(f"Must be up to {sockaddr_storage.sizeof}")
+            self.addrbuf = val
+        elif val is None:
+            self.addrbuf = b""
+        elif isinstance(val, str):
+            self.addr = ip_address(val)
+        elif isinstance(val, IPv4Address):
+            self.addr = sockaddr_in(addr=val)
+        elif isinstance(val, IPv6Address):
+            self.addr = sockaddr_in6(addr=val)
+        elif (
+            isinstance(val, sockaddr_in)
+            or isinstance(val, sockaddr_in6)
+            or isinstance(val, sockaddr_storage)
+        ):
+            self.addr = bytes(val)
+        else:
+            raise TypeError(f"Can't handle addr {val}")
+        return self.addr
+
+    @property
+    def include_options(self) -> bool:
+        return (self.flags & TCP_AUTHOPT_KEY_EXCLUDE_OPTS) == 0
+
+    @include_options.setter
+    def include_options(self, value) -> bool:
+        if value:
+            self.flags &= ~TCP_AUTHOPT_KEY_EXCLUDE_OPTS
+        else:
+            self.flags |= TCP_AUTHOPT_KEY_EXCLUDE_OPTS
+
+    @property
+    def delete_flag(self) -> bool:
+        return bool(self.flags & TCP_AUTHOPT_KEY_DEL)
+
+    @delete_flag.setter
+    def delete_flag(self, value) -> bool:
+        if value:
+            self.flags |= TCP_AUTHOPT_KEY_DEL
+        else:
+            self.flags &= ~TCP_AUTHOPT_KEY_DEL
+
+
+def set_tcp_authopt_key(sock, key: tcp_authopt_key):
+    return sock.setsockopt(socket.IPPROTO_TCP, TCP_AUTHOPT_KEY, bytes(key))
+
+
+def has_tcp_authopt() -> bool:
+    """Check is TCP_AUTHOPT is implemented by the OS"""
+    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
+        try:
+            optbuf = bytes(4)
+            sock.setsockopt(socket.IPPROTO_TCP, TCP_AUTHOPT, optbuf)
+            return True
+        except OSError as e:
+            if e.errno == errno.ENOPROTOOPT:
+                return False
+            else:
+                raise
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/sockaddr.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/sockaddr.py
new file mode 100644
index 000000000000..f61d0f190a0c
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/sockaddr.py
@@ -0,0 +1,101 @@
+# SPDX-License-Identifier: GPL-2.0
+"""pack/unpack wrappers for sockaddr"""
+import socket
+import struct
+from dataclasses import dataclass
+from ipaddress import IPv4Address, IPv6Address
+
+
+@dataclass
+class sockaddr_in:
+    port: int
+    addr: IPv4Address
+    sizeof = 8
+
+    def __init__(self, port=0, addr=None):
+        self.port = port
+        if addr is None:
+            addr = IPv4Address(0)
+        self.addr = IPv4Address(addr)
+
+    def pack(self):
+        return struct.pack("HH4s", socket.AF_INET, self.port, self.addr.packed)
+
+    @classmethod
+    def unpack(cls, buffer):
+        family, port, addr_packed = struct.unpack("HH4s", buffer[:8])
+        if family != socket.AF_INET:
+            raise ValueError(f"Must be AF_INET not {family}")
+        return cls(port, addr_packed)
+
+    def __bytes__(self):
+        return self.pack()
+
+
+@dataclass
+class sockaddr_in6:
+    """Like sockaddr_in6 but for python. Always contains scope_id"""
+
+    port: int
+    addr: IPv6Address
+    flowinfo: int
+    scope_id: int
+    sizeof = 28
+
+    def __init__(self, port=0, addr=None, flowinfo=0, scope_id=0):
+        self.port = port
+        if addr is None:
+            addr = IPv6Address(0)
+        self.addr = IPv6Address(addr)
+        self.flowinfo = flowinfo
+        self.scope_id = scope_id
+
+    def pack(self):
+        return struct.pack(
+            "HHI16sI",
+            socket.AF_INET6,
+            self.port,
+            self.flowinfo,
+            self.addr.packed,
+            self.scope_id,
+        )
+
+    @classmethod
+    def unpack(cls, buffer):
+        family, port, flowinfo, addr_packed, scope_id = struct.unpack(
+            "HHI16sI", buffer[:28]
+        )
+        if family != socket.AF_INET6:
+            raise ValueError(f"Must be AF_INET6 not {family}")
+        return cls(port, addr_packed, flowinfo=flowinfo, scope_id=scope_id)
+
+    def __bytes__(self):
+        return self.pack()
+
+
+@dataclass
+class sockaddr_storage:
+    family: int
+    data: bytes
+    sizeof = 128
+
+    def pack(self):
+        return struct.pack("H126s", self.family, self.data)
+
+    def __bytes__(self):
+        return self.pack()
+
+    @classmethod
+    def unpack(cls, buffer):
+        return cls(*struct.unpack("H126s", buffer))
+
+
+def sockaddr_unpack(buffer: bytes):
+    """Unpack based on family"""
+    family = struct.unpack("H", buffer[:2])[0]
+    if family == socket.AF_INET:
+        return sockaddr_in.unpack(buffer)
+    elif family == socket.AF_INET6:
+        return sockaddr_in6.unpack(buffer)
+    else:
+        return sockaddr_storage.unpack(buffer)
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py
new file mode 100644
index 000000000000..06a05bf8aeec
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py
@@ -0,0 +1,74 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Test TCP_AUTHOPT sockopt API"""
+import errno
+import socket
+import struct
+from ipaddress import IPv4Address, IPv6Address
+
+import pytest
+
+from .linux_tcp_authopt import (
+    set_tcp_authopt,
+    set_tcp_authopt_key,
+    tcp_authopt,
+    tcp_authopt_key,
+)
+from .sockaddr import sockaddr_unpack
+from .conftest import skipif_missing_tcp_authopt
+
+pytestmark = skipif_missing_tcp_authopt
+
+
+def test_authopt_key_pack_noaddr():
+    b = bytes(tcp_authopt_key(key=b"a\x00b"))
+    assert b[7] == 3
+    assert b[8:13] == b"a\x00b\x00\x00"
+
+
+def test_authopt_key_pack_addr():
+    b = bytes(tcp_authopt_key(key=b"a\x00b", addr="10.0.0.1"))
+    assert struct.unpack("H", b[88:90])[0] == socket.AF_INET
+    assert sockaddr_unpack(b[88:]).addr == IPv4Address("10.0.0.1")
+
+
+def test_authopt_key_pack_addr6():
+    b = bytes(tcp_authopt_key(key=b"abc", addr="fd00::1"))
+    assert struct.unpack("H", b[88:90])[0] == socket.AF_INET6
+    assert sockaddr_unpack(b[88:]).addr == IPv6Address("fd00::1")
+
+
+def test_tcp_authopt_key_del_without_active(exit_stack):
+    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
+    exit_stack.push(sock)
+
+    # nothing happens:
+    key = tcp_authopt_key()
+    assert key.delete_flag is False
+    key.delete_flag = True
+    assert key.delete_flag is True
+    with pytest.raises(OSError) as e:
+        set_tcp_authopt_key(sock, key)
+    assert e.value.errno in [errno.EINVAL, errno.ENOENT]
+
+
+def test_tcp_authopt_key_setdel(exit_stack):
+    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
+    exit_stack.push(sock)
+    set_tcp_authopt(sock, tcp_authopt())
+
+    # delete returns ENOENT
+    key = tcp_authopt_key()
+    key.delete_flag = True
+    with pytest.raises(OSError) as e:
+        set_tcp_authopt_key(sock, key)
+    assert e.value.errno == errno.ENOENT
+
+    key = tcp_authopt_key(send_id=1, recv_id=2)
+    set_tcp_authopt_key(sock, key)
+    # First delete works fine:
+    key.delete_flag = True
+    set_tcp_authopt_key(sock, key)
+    # Duplicate delete returns ENOENT
+    with pytest.raises(OSError) as e:
+        set_tcp_authopt_key(sock, key)
+    assert e.value.errno == errno.ENOENT
-- 
2.25.1

