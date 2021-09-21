Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1309E41376D
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbhIUQVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbhIUQVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:21:08 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A1AC061756;
        Tue, 21 Sep 2021 09:17:40 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r5so6713743edi.10;
        Tue, 21 Sep 2021 09:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dLdOrq6p6YlC74JgT3Np29LL5CxIsdwa3KL77estloo=;
        b=Pt9xVQKOvbo778npQiES3OZYFWy9GPujeShjeRO7dOXNG9tds8ghExfQbxqalENHme
         Iqz7YG+KhabAfY5HZKjziKDm7u6DmFWCqi3YZ+1aA0EZ25raxePSYu85oHJTvy+ExP/S
         VBt8GucxoQplfT9R54EwcBTmR+MGlWblY2JgyQ0erEkThtl/p3XQhcTeUTAoAri0EPmi
         47Re/rPICjvd3TgxtsXbTtkMyTO7yHYbXwo6TZ0xV/s7iJ0E1z8Nzo+b8Did35bXL1HP
         xzjm/558In1cJxJkswBwnBnbK0r2pM4AoigfzLJM09Do18Xtk0TGcdRptq3jC0Z8Rzwa
         /mUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dLdOrq6p6YlC74JgT3Np29LL5CxIsdwa3KL77estloo=;
        b=5b04Xlh2Dvunu4aAGy7sqUXXUzgJUDgubobfot5ljVp0c18ruOiWNOKCLvy61BE6Vr
         eZ6YcoTsILibs1KnBUEvxrj89vqe9YpKKi1hwEpvTY8zJzl3AZ9xPB+lJSkBn5kR9k1l
         TpozrzvrFZCgv0EnMTWzJ9Yw4Q0oPWxWIQLlyYL2Hur97pbx78PBKhlRM7Fv8p8+LvxW
         FejVc8EJeUeuakhvDKOuVMzXxEyaFJkIISTjO1zGdyA+adI4WtLJMzKWK0i6RbTOsNW1
         8fo8mi67aRU/cs7AqrOBoeCfj6yU3kNzoNgFY8hLErqGtGQWwwmPZMrSdqxm2QggWPl8
         SLWA==
X-Gm-Message-State: AOAM533iJ+ODhG0uifKjpFgOoXTzw2qQeJOpnHmMwMknJae2ZtG0Wqwm
        dBEPTJ2Pvz6RdOKZwAdq5EY=
X-Google-Smtp-Source: ABdhPJyGobVBpoZmZ0OkLX2I2OxqgiAEHCT+m7AJXeBfWN0NPaUS/9OM0odxWVHYwu0x7MTwqj/W5Q==
X-Received: by 2002:a17:906:1c99:: with SMTP id g25mr35044598ejh.521.1632240922371;
        Tue, 21 Sep 2021 09:15:22 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:21 -0700 (PDT)
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
Subject: [PATCH 04/19] selftests: tcp_authopt: Initial sockopt manipulation
Date:   Tue, 21 Sep 2021 19:14:47 +0300
Message-Id: <1d55493c5879971355f31d6a8ac33612f07df500.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 .../tcp_authopt/tcp_authopt_test/conftest.py  |  41 +++
 .../tcp_authopt_test/linux_tcp_authopt.py     | 238 ++++++++++++++++++
 .../tcp_authopt/tcp_authopt_test/sockaddr.py  | 112 +++++++++
 .../tcp_authopt_test/test_sockopt.py          | 185 ++++++++++++++
 4 files changed, 576 insertions(+)
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/sockaddr.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py

diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py
new file mode 100644
index 000000000000..dfab5a631e34
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/conftest.py
@@ -0,0 +1,41 @@
+# SPDX-License-Identifier: GPL-2.0
+import logging
+import os
+from contextlib import ExitStack
+
+import pytest
+
+from .linux_tcp_authopt import has_tcp_authopt, enable_sysctl_tcp_authopt
+
+logger = logging.getLogger(__name__)
+
+skipif_missing_tcp_authopt = pytest.mark.skipif(
+    not has_tcp_authopt(), reason="Need CONFIG_TCP_AUTHOPT"
+)
+
+
+def can_capture():
+    # This is too restrictive:
+    return os.geteuid() == 0
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
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
new file mode 100644
index 000000000000..339298998ff9
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
@@ -0,0 +1,238 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Python wrapper around linux TCP_AUTHOPT ABI"""
+
+from dataclasses import dataclass
+from ipaddress import IPv4Address, IPv6Address, ip_address
+import socket
+from enum import IntEnum, IntFlag
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
+    """Like linux struct tcp_authopt_key"""
+
+    def __init__(
+        self,
+        flags: int = 0,
+        send_id: int = 0,
+        recv_id: int = 0,
+        alg=TCP_AUTHOPT_ALG.HMAC_SHA_1_96,
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
+        return (self.flags & TCP_AUTHOPT_KEY.EXCLUDE_OPTS) == 0
+
+    @include_options.setter
+    def include_options(self, value) -> bool:
+        if value:
+            self.flags &= ~TCP_AUTHOPT_KEY_FLAG.EXCLUDE_OPTS
+        else:
+            self.flags |= TCP_AUTHOPT_KEY_FLAG.EXCLUDE_OPTS
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
+
+
+def set_tcp_authopt_key(sock, key: tcp_authopt_key):
+    return sock.setsockopt(socket.SOL_TCP, TCP_AUTHOPT_KEY, bytes(key))
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
+def get_sysctl_tcp_authopt() -> bool:
+    from pathlib import Path
+
+    path = Path("/proc/sys/net/ipv4/tcp_authopt")
+    if path.exists():
+        return path.read_text().strip() != "0"
+
+
+def enable_sysctl_tcp_authopt() -> bool:
+    from pathlib import Path
+
+    path = Path("/proc/sys/net/ipv4/tcp_authopt")
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
index 000000000000..be1745ac10ab
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/sockaddr.py
@@ -0,0 +1,112 @@
+# SPDX-License-Identifier: GPL-2.0
+"""pack/unpack wrappers for sockaddr"""
+import socket
+import struct
+from dataclasses import dataclass
+from ipaddress import IPv4Address, IPv6Address, ip_address
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
+
+
+def sockaddr_convert(val):
+    """Try to convert address into some sort of sockaddr"""
+    if isinstance(val, IPv4Address):
+        return sockaddr_in(addr=val)
+    if isinstance(val, IPv6Address):
+        return sockaddr_in6(addr=val)
+    if isinstance(val, str):
+        return sockaddr_convert(ip_address(val))
+    raise TypeError(f"Don't know how to convert {val!r} to sockaddr")
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py
new file mode 100644
index 000000000000..dd389ae6055e
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sockopt.py
@@ -0,0 +1,185 @@
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
+    TCP_AUTHOPT,
+    TCP_AUTHOPT_KEY,
+    TCP_AUTHOPT_ALG,
+    TCP_AUTHOPT_FLAG,
+    TCP_AUTHOPT_KEY_FLAG,
+    set_tcp_authopt,
+    get_tcp_authopt,
+    set_tcp_authopt_key,
+    del_tcp_authopt_key,
+    tcp_authopt,
+    tcp_authopt_key,
+)
+from .sockaddr import sockaddr_in, sockaddr_in6, sockaddr_unpack
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
+            set_tcp_authopt_key(sock, tcp_authopt_key(flags=0xabcdef))
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
-- 
2.25.1

