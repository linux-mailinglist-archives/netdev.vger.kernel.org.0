Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19087441E58
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhKAQiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbhKAQiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:10 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E1BC061764;
        Mon,  1 Nov 2021 09:35:36 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z20so66624171edc.13;
        Mon, 01 Nov 2021 09:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pjvxhxZ2q7jfMD4WaKkEJI1NGChDWADwI/tiFcTFnC0=;
        b=WSWA1/JOlJOnXQVjNvqTu+vyr+kqHWKeLE9ASxTr7Ul4XU3EEpMEOS21Xl8HVtna/C
         3fXhFm2nMJNyBS4ushPo3MHUoRkVlINeUPxdf+Hg0pjJiBNlxKLbaZD5+hkETO/sHtuQ
         q++XSKcUaMhOZVc3y4DEw0FyVyEEvp9MtHKN9A0E5hNsFFyEwyWA8lGfTSz9NIRKFbkL
         NFnVmc5y+3b9yDlZROXbqOkYhe2tPQhFK9YSwUI7xdRaMlmw1hcVBYiBdUTYPW5DLElJ
         loN3CugVqNpjAWK5wRgXQB4nTgwxeEVd02hoCS5L9ZELrXUibf2TNmQow6Gqtf48KLvr
         yr+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pjvxhxZ2q7jfMD4WaKkEJI1NGChDWADwI/tiFcTFnC0=;
        b=z88Sd0p+B2MpNyLn3InDLeb+b+Elcj+BSDzEZzzUM+SpzU+ZUR6aAqrGcS5Ilu/+sn
         noeaBMddT+wMbPifDZf4daEyW4uyu6gK4Oi1hpS+Sl2OVKuZzXJfVuGICGFMoLQ+UpmB
         ZqeCbbrbru+/+hyvQwW2zQig/LxUQMOPq+uTvWxXsHLuvdRCmkDWADeMXFCntsVob6fR
         MvJReAZcZ6+Kn6TV4nR7qMGzwvOWaAH+g+jlU+F+dPb7w8dUe58UzGWjf1t1BzwO/831
         uJSlQXe7oi8/Qibh6D5RNueUPcceIi46E9yMWRdJEO13gjIqtXBJDBZ6mp9Me5PHADlW
         oXAA==
X-Gm-Message-State: AOAM531f+wpuNz25l+o0l5HBAQ6DteH89/Y2uDR/OIRSPsJTE7qcv9+2
        W9gL26tjOP8NdANJfNGvwxk=
X-Google-Smtp-Source: ABdhPJwDZiWmETfUuItKPavEfKeTYE9gQfQcJBvS5X6dekanhQBxy+HbZ5GaKGaBwq1mG97Uk53nlA==
X-Received: by 2002:a50:a40e:: with SMTP id u14mr22503676edb.164.1635784534897;
        Mon, 01 Nov 2021 09:35:34 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:34 -0700 (PDT)
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
Subject: [PATCH v2 04/25] selftests: tcp_authopt: Initial sockopt manipulation
Date:   Mon,  1 Nov 2021 18:34:39 +0200
Message-Id: <f4f651740378974dad93bc97ced6d5cc97ffb373.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a python translation of the linux ABI for tcpao and test the
behavior of TCP_AUTHOPT and TCP_AUTHOPT_KEY sockopts.

This includes several corner cases not normally covered by traffic
tests.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 .../tcp_authopt/tcp_authopt_test/conftest.py  |  71 +++++
 .../tcp_authopt_test/linux_tcp_authopt.py     | 266 ++++++++++++++++++
 .../tcp_authopt/tcp_authopt_test/sockaddr.py  | 122 ++++++++
 .../tcp_authopt_test/test_sockopt.py          | 203 +++++++++++++
 4 files changed, 662 insertions(+)
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/sockaddr.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py

diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py
new file mode 100644
index 000000000000..a06ba848669d
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py
@@ -0,0 +1,71 @@
+# SPDX-License-Identifier: GPL-2.0
+import logging
+import os
+from contextlib import ExitStack, nullcontext
+from typing import ContextManager
+
+import pytest
+
+from .linux_tcp_authopt import enable_sysctl_tcp_authopt, has_tcp_authopt
+
+logger = logging.getLogger(__name__)
+
+skipif_missing_tcp_authopt = pytest.mark.skipif(
+    not has_tcp_authopt(), reason="Need CONFIG_TCP_AUTHOPT"
+)
+
+
+def get_effective_capabilities():
+    for line in open("/proc/self/status", "r"):
+        if line.startswith("CapEff:"):
+            return int(line.split(":")[1], 16)
+
+
+def has_effective_capability(bit) -> bool:
+    return get_effective_capabilities() & (1 << bit) != 0
+
+
+def can_capture() -> bool:
+    return has_effective_capability(13)
+
+
+def raise_skip_no_netns():
+    if not has_effective_capability(12):
+        pytest.skip("Need CAP_NET_ADMIN for network namespaces")
+
+
+skipif_cant_capture = pytest.mark.skipif(
+    not can_capture(), reason="run as root to capture packets"
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
+
+
+def pytest_configure():
+    # Silence messages regarding netns enter/exit:
+    logging.getLogger("nsenter").setLevel(logging.INFO)
+    if has_tcp_authopt():
+        enable_sysctl_tcp_authopt()
+
+
+def parametrize_product(**kw):
+    """Parametrize each key to each item in the value list"""
+    import itertools
+
+    return pytest.mark.parametrize(",".join(kw.keys()), itertools.product(*kw.values()))
+
+
+def raises_optional_exception(expected_exception, **kw) -> ContextManager:
+    """Like pytest.raises except accept expected_exception=None"""
+    if expected_exception is None:
+        return nullcontext()
+    else:
+        return pytest.raises(expected_exception, **kw)
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
new file mode 100644
index 000000000000..b9dc9decda07
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
@@ -0,0 +1,266 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Python wrapper around linux TCP_AUTHOPT ABI"""
+
+import errno
+import logging
+import socket
+import struct
+import typing
+from dataclasses import dataclass
+from enum import IntEnum, IntFlag
+
+from .sockaddr import (
+    SockaddrConvertType,
+    sockaddr_base,
+    sockaddr_convert,
+    sockaddr_storage,
+    sockaddr_unpack,
+)
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
+
+class TCP_AUTHOPT_FLAG(IntFlag):
+    REJECT_UNEXPECTED = BIT(2)
+
+
+class TCP_AUTHOPT_KEY_FLAG(IntFlag):
+    DEL = BIT(0)
+    EXCLUDE_OPTS = BIT(1)
+    BIND_ADDR = BIT(2)
+
+
+class TCP_AUTHOPT_ALG(IntEnum):
+    HMAC_SHA_1_96 = 1
+    AES_128_CMAC_96 = 2
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
+    return sock.setsockopt(socket.SOL_TCP, TCP_AUTHOPT, bytes(opt))
+
+
+def get_tcp_authopt(sock: socket.socket) -> tcp_authopt:
+    b = sock.getsockopt(socket.SOL_TCP, TCP_AUTHOPT, tcp_authopt.sizeof)
+    return tcp_authopt.unpack(b)
+
+
+class tcp_authopt_key:
+    """Like linux struct tcp_authopt_key
+
+    :ivar auto_flags: If true(default) then set "binding" flags based on non-null values attributes.
+    """
+
+    KeyArgType = typing.Union[str, bytes]
+    AddrArgType = typing.Union[None, str, bytes, SockaddrConvertType]
+
+    def __init__(
+        self,
+        flags: TCP_AUTHOPT_KEY_FLAG = TCP_AUTHOPT_KEY_FLAG(0),
+        send_id: int = 0,
+        recv_id: int = 0,
+        alg=TCP_AUTHOPT_ALG.HMAC_SHA_1_96,
+        key: KeyArgType = b"",
+        addr: AddrArgType = None,
+        auto_flags: bool = True,
+        include_options=None,
+    ):
+        self.flags = flags
+        self.send_id = send_id
+        self.recv_id = recv_id
+        self.alg = alg
+        self.key = key
+        self.addr = addr
+        self.auto_flags = auto_flags
+        if include_options is not None:
+            self.include_options = include_options
+
+    def get_real_flags(self) -> TCP_AUTHOPT_KEY_FLAG:
+        result = self.flags
+        if self.auto_flags:
+            if self.addr is not None:
+                result |= TCP_AUTHOPT_KEY_FLAG.BIND_ADDR
+            else:
+                result &= ~TCP_AUTHOPT_KEY_FLAG.BIND_ADDR
+        return result
+
+    def pack(self):
+        if len(self.key) > TCP_AUTHOPT_MAXKEYLEN:
+            raise ValueError(f"Max key length is {TCP_AUTHOPT_MAXKEYLEN}")
+        data = struct.pack(
+            "IBBBB80s",
+            self.get_real_flags(),
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
+    def key(self) -> KeyArgType:
+        return self._key
+
+    @key.setter
+    def key(self, val: KeyArgType) -> bytes:
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
+    def addr(self, val: AddrArgType):
+        if isinstance(val, bytes):
+            if len(val) > sockaddr_storage.sizeof:
+                raise ValueError(f"Must be up to {sockaddr_storage.sizeof}")
+            self.addrbuf = val
+        elif val is None:
+            self.addrbuf = b""
+        elif isinstance(val, sockaddr_base):
+            self.addr = bytes(val)
+        else:
+            self.addr = sockaddr_convert(val)
+        return self.addr
+
+    @property
+    def include_options(self) -> bool:
+        return not self.flags & TCP_AUTHOPT_KEY_FLAG.EXCLUDE_OPTS
+
+    @include_options.setter
+    def include_options(self, value) -> bool:
+        if value:
+            self.flags &= ~TCP_AUTHOPT_KEY_FLAG.EXCLUDE_OPTS
+        else:
+            self.flags |= TCP_AUTHOPT_KEY_FLAG.EXCLUDE_OPTS
+        return value
+
+    @property
+    def delete_flag(self) -> bool:
+        return bool(self.flags & TCP_AUTHOPT_KEY_FLAG.DEL)
+
+    @delete_flag.setter
+    def delete_flag(self, value) -> bool:
+        if value:
+            self.flags |= TCP_AUTHOPT_KEY_FLAG.DEL
+        else:
+            self.flags &= ~TCP_AUTHOPT_KEY_FLAG.DEL
+        return value
+
+
+def set_tcp_authopt_key(sock, keyopt: tcp_authopt_key):
+    return sock.setsockopt(socket.SOL_TCP, TCP_AUTHOPT_KEY, bytes(keyopt))
+
+
+def set_tcp_authopt_key_kwargs(sock, keyopt: tcp_authopt_key = None, **kw):
+    if keyopt is None:
+        keyopt = tcp_authopt_key()
+    for k, v in kw.items():
+        setattr(keyopt, k, v)
+    return set_tcp_authopt_key(sock, keyopt)
+
+
+def del_tcp_authopt_key(sock, key: tcp_authopt_key) -> bool:
+    """Try to delete an authopt key
+
+    :return: True if a key was deleted, False if it was not present
+    """
+    import copy
+
+    key = copy.copy(key)
+    key.delete_flag = True
+    try:
+        sock.setsockopt(socket.SOL_TCP, TCP_AUTHOPT_KEY, bytes(key))
+        return True
+    except OSError as e:
+        if e.errno == errno.ENOENT:
+            return False
+        raise
+
+
+def get_sysctl_tcp_authopt() -> typing.Optional[bool]:
+    from pathlib import Path
+
+    path = Path("/proc/sys/net/ipv4/tcp_authopt")
+    if path.exists():
+        return path.read_text().strip() != "0"
+    else:
+        return None
+
+
+def enable_sysctl_tcp_authopt():
+    from pathlib import Path
+
+    path = Path("/proc/sys/net/ipv4/tcp_authopt")
+    # Do nothing if absent
+    if not path.exists():
+        return
+    try:
+        if path.read_text().strip() == "0":
+            path.write_text("1")
+    except:
+        raise Exception("Failed to enable /proc/sys/net/ipv4/tcp_authopt")
+
+
+def has_tcp_authopt() -> bool:
+    """Check is TCP_AUTHOPT is implemented by the OS
+
+    Returns True if implemented but disabled by sysctl
+    Returns False if disabled at compile time
+    """
+    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
+        try:
+            optbuf = bytes(4)
+            sock.setsockopt(socket.SOL_TCP, TCP_AUTHOPT, optbuf)
+            return True
+        except OSError as e:
+            if e.errno == errno.ENOPROTOOPT:
+                return False
+            elif e.errno == errno.EPERM and get_sysctl_tcp_authopt() is False:
+                return True
+            else:
+                raise
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/sockaddr.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/sockaddr.py
new file mode 100644
index 000000000000..3ad22c0b4015
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/sockaddr.py
@@ -0,0 +1,122 @@
+# SPDX-License-Identifier: GPL-2.0
+"""pack/unpack wrappers for sockaddr"""
+import socket
+import struct
+import typing
+from dataclasses import dataclass
+from ipaddress import IPv4Address, IPv6Address, ip_address
+
+
+class sockaddr_base:
+    def pack(self) -> bytes:
+        raise NotImplementedError()
+
+    def __bytes__(self):
+        return self.pack()
+
+
+class sockaddr_in(sockaddr_base):
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
+
+@dataclass
+class sockaddr_in6(sockaddr_base):
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
+
+@dataclass
+class sockaddr_storage(sockaddr_base):
+    family: int
+    data: bytes
+    sizeof = 128
+
+    def pack(self):
+        return struct.pack("H126s", self.family, self.data)
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
+
+
+SockaddrConvertType = typing.Union[
+    sockaddr_in, sockaddr_in6, sockaddr_storage, IPv4Address, IPv6Address, str
+]
+
+
+def sockaddr_convert(val: SockaddrConvertType) -> sockaddr_base:
+    """Try to convert address into some sort of sockaddr"""
+    if (
+        isinstance(val, sockaddr_in)
+        or isinstance(val, sockaddr_in6)
+        or isinstance(val, sockaddr_storage)
+    ):
+        return val
+    if isinstance(val, IPv4Address):
+        return sockaddr_in(addr=val)
+    if isinstance(val, IPv6Address):
+        return sockaddr_in6(addr=val)
+    if isinstance(val, str):
+        return sockaddr_convert(ip_address(val))
+    raise TypeError(f"Don't know how to convert {val!r} to sockaddr")
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py
new file mode 100644
index 000000000000..41ebde8b1b7c
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py
@@ -0,0 +1,203 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Test TCP_AUTHOPT sockopt API"""
+import errno
+import socket
+import struct
+from ipaddress import IPv4Address, IPv6Address
+
+import pytest
+
+from .conftest import skipif_missing_tcp_authopt
+from .linux_tcp_authopt import (
+    TCP_AUTHOPT,
+    TCP_AUTHOPT_ALG,
+    TCP_AUTHOPT_FLAG,
+    TCP_AUTHOPT_KEY,
+    TCP_AUTHOPT_KEY_FLAG,
+    del_tcp_authopt_key,
+    get_tcp_authopt,
+    set_tcp_authopt,
+    set_tcp_authopt_key,
+    tcp_authopt,
+    tcp_authopt_key,
+)
+from .sockaddr import sockaddr_in, sockaddr_in6, sockaddr_unpack
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
+
+
+def test_get_tcp_authopt():
+    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
+        with pytest.raises(OSError) as e:
+            sock.getsockopt(socket.SOL_TCP, TCP_AUTHOPT, 4)
+        assert e.value.errno == errno.ENOENT
+
+
+def test_set_get_tcp_authopt_flags():
+    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
+        # No flags by default
+        set_tcp_authopt(sock, tcp_authopt())
+        opt = get_tcp_authopt(sock)
+        assert opt.flags == 0
+
+        # simple flags are echoed
+        goodflag = TCP_AUTHOPT_FLAG.REJECT_UNEXPECTED
+        set_tcp_authopt(sock, tcp_authopt(flags=goodflag))
+        opt = get_tcp_authopt(sock)
+        assert opt.flags == goodflag
+
+        # attempting to set a badflag returns an error and has no effect
+        badflag = 1 << 27
+        with pytest.raises(OSError) as e:
+            set_tcp_authopt(sock, tcp_authopt(flags=badflag))
+        opt = get_tcp_authopt(sock)
+        assert opt.flags == goodflag
+
+
+def test_set_ipv6_key_on_ipv4():
+    """Binding a key to an ipv6 address on an ipv4 socket makes no sense"""
+    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
+        key = tcp_authopt_key("abc")
+        key.flags = TCP_AUTHOPT_KEY_FLAG.BIND_ADDR
+        key.addr = IPv6Address("::1234")
+        with pytest.raises(OSError):
+            set_tcp_authopt_key(sock, key)
+
+
+def test_set_ipv4_key_on_ipv6():
+    """This could be implemented for ipv6-mapped-ipv4 but it is not
+
+    TCP_MD5SIG has a similar limitation
+    """
+    with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as sock:
+        key = tcp_authopt_key("abc")
+        key.flags = TCP_AUTHOPT_KEY_FLAG.BIND_ADDR
+        key.addr = IPv4Address("1.2.3.4")
+        with pytest.raises(OSError):
+            set_tcp_authopt_key(sock, key)
+
+
+def test_authopt_key_badflags():
+    """Don't pretend to handle unknown flags"""
+    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
+        with pytest.raises(OSError):
+            set_tcp_authopt_key(sock, tcp_authopt_key(flags=0xABCDEF))
+
+
+def test_authopt_key_longer_bad():
+    """Test that pass a longer sockopt with unknown data fails
+
+    Old kernels won't pretend to handle features they don't know about
+    """
+    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
+        key = tcp_authopt_key(alg=TCP_AUTHOPT_ALG.HMAC_SHA_1_96, key="aaa")
+        optbuf = bytes(key)
+        optbuf = optbuf.ljust(len(optbuf) + 256, b"\x5a")
+        with pytest.raises(OSError):
+            sock.setsockopt(socket.SOL_TCP, TCP_AUTHOPT_KEY, optbuf)
+
+
+def test_authopt_key_longer_zeros():
+    """Test that passing a longer sockopt padded with zeros works
+
+    This ensures applications using a larger struct tcp_authopt_key won't have
+    to pass a shorter optlen on old kernels.
+    """
+    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
+        key = tcp_authopt_key(alg=TCP_AUTHOPT_ALG.HMAC_SHA_1_96, key="aaa")
+        optbuf = bytes(key)
+        optbuf = optbuf.ljust(len(optbuf) + 256, b"\x00")
+        sock.setsockopt(socket.SOL_TCP, TCP_AUTHOPT_KEY, optbuf)
+        # the key was added and can be deleted normally
+        assert del_tcp_authopt_key(sock, key) == True
+        assert del_tcp_authopt_key(sock, key) == False
+
+
+def test_authopt_longer_baddata():
+    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
+        opt = tcp_authopt()
+        optbuf = bytes(opt)
+        optbuf = optbuf.ljust(len(optbuf) + 256, b"\x5a")
+        with pytest.raises(OSError):
+            sock.setsockopt(socket.SOL_TCP, TCP_AUTHOPT, optbuf)
+
+
+def test_authopt_longer_zeros():
+    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
+        opt = tcp_authopt()
+        optbuf = bytes(opt)
+        optbuf = optbuf.ljust(len(optbuf) + 256, b"\x00")
+        sock.setsockopt(socket.SOL_TCP, TCP_AUTHOPT, optbuf)
+
+
+def test_authopt_setdel_addrbind():
+    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
+        key = tcp_authopt_key(addr="1.1.1.1", recv_id=1, send_id=1)
+        key2 = tcp_authopt_key(addr="1.1.1.2", recv_id=1, send_id=1)
+        set_tcp_authopt_key(sock, key)
+        assert del_tcp_authopt_key(sock, key2) == False
+        assert del_tcp_authopt_key(sock, key) == True
+        assert del_tcp_authopt_key(sock, key) == False
+
+
+def test_authopt_include_options():
+    key = tcp_authopt_key()
+    assert key.include_options
+    key.include_options = False
+    assert key.flags & TCP_AUTHOPT_KEY_FLAG.EXCLUDE_OPTS
+    assert not key.include_options
-- 
2.25.1

