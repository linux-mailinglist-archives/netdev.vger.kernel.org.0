Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A28D3F6B3D
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239185AbhHXVhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbhHXVgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:36:39 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F396C0613D9;
        Tue, 24 Aug 2021 14:35:54 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id cn28so33787529edb.6;
        Tue, 24 Aug 2021 14:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uYg+pR6vYz9c1bRkh62Hdk42D02UPnrW7k5nCWY1NW8=;
        b=pvMk+T4WZCrC7nWe5m9ylmSL9MQXtm/fzxow/nqQFgOpAB62Qi2IKTZrz275eYB+F6
         B9qkKa/apTpeJ1JQnyAekVkZG034OQ3uV53tnKX678WcUfytsV+uTgrBh3ky8s18Grd1
         AtGjr+ZXM3FVtYdd+fKBFH8bXn5N/lAj4391t6S4Hb+qEgA+0UPMKhwloDh4+AdD0xsL
         qbRtshmG1c7rOWHN8dlNt17MmiMreHy9vbobTRE0ZAdirnpP73t/O5z+1rpwyxwPp8E6
         YAd1CNsdQGO8hN4u31zrOxnoWfHn9cX0IunUue6JYw8hAUtT1xdVXZpHnUNr6ibKNpdH
         h+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uYg+pR6vYz9c1bRkh62Hdk42D02UPnrW7k5nCWY1NW8=;
        b=FmOYksf0JdT8SJBYkpUMZApythhVKabCZnmiuQmkyTjirolzguwZc//j0eHKLAe3zV
         o2yz5p5R358/3j7sbNr+XoA/uEjFCe9oGCo+JieIfGRi0+JBAnBoRA5TjVQA+1mhLnP7
         re0DSjGQGkAzp+aw1mv+5RCJ4c886j1UYNBI/2gFm5MmUuKr/VThJh4kdhckmrIiDNFw
         YJHYnG7EBGzd0z8RdevmDDRfNtg4qOJkceW1/JRTvoow47jHtgba++WQOEuglh7bz4hA
         CLkQihxOJp2zFUmN5j4p7fA6rVlgODU0suAUzQplfBUw9vEqzKm89pO+LGXTh7PK16K6
         L5ag==
X-Gm-Message-State: AOAM531uy5EJHr4vsTQH23t2XNrwIc/iHm9yUjq8ozJC+tFdEBZ35TeB
        c2XvHmB6jMWw9MblZ0yo1Yp4rJJA5hfp9OfU
X-Google-Smtp-Source: ABdhPJwM0O/eQj0aHa0mdC8c0VZLnoY0K6EGSdGpZerSepu5QoUz5VhXh9saUk7+Xz7cXMSOsgYpgw==
X-Received: by 2002:a05:6402:3512:: with SMTP id b18mr14022046edd.240.1629840952781;
        Tue, 24 Aug 2021 14:35:52 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ed0a:7326:fbac:b4c])
        by smtp.gmail.com with ESMTPSA id d16sm12348357edu.8.2021.08.24.14.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:35:52 -0700 (PDT)
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
Subject: [RFCv3 15/15] selftests: tcp_authopt: Add tests for rollover
Date:   Wed, 25 Aug 2021 00:34:48 +0300
Message-Id: <67aea6d5bd20f43ca74b3aea63cc1f043edd3750.1629840814.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1629840814.git.cdleonard@gmail.com>
References: <cover.1629840814.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC5925 requires that the use can examine or control the keys being
used. This is implemented in linux via fields on the TCP_AUTHOPT
sockopt.

Add socket-level tests for the adjusting keyids on live connections and
checking the they are reflected on the peer.

Also check smooth transitions via rnextkeyid.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 .../tcp_authopt_test/linux_tcp_authopt.py     |  16 +-
 .../tcp_authopt_test/test_rollover.py         | 181 ++++++++++++++++++
 2 files changed, 194 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_rollover.py

diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
index 41374f9851aa..23de148a4078 100644
--- a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
@@ -20,10 +20,12 @@ def BIT(x):
 TCP_AUTHOPT = 38
 TCP_AUTHOPT_KEY = 39
 
 TCP_AUTHOPT_MAXKEYLEN = 80
 
+TCP_AUTHOPT_FLAG_LOCK_KEYID = BIT(0)
+TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID = BIT(1)
 TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED = BIT(2)
 
 TCP_AUTHOPT_KEY_DEL = BIT(0)
 TCP_AUTHOPT_KEY_EXCLUDE_OPTS = BIT(1)
 TCP_AUTHOPT_KEY_BIND_ADDR = BIT(2)
@@ -35,24 +37,32 @@ TCP_AUTHOPT_ALG_AES_128_CMAC_96 = 2
 @dataclass
 class tcp_authopt:
     """Like linux struct tcp_authopt"""
 
     flags: int = 0
-    sizeof = 4
+    send_keyid: int = 0
+    send_rnextkeyid: int = 0
+    recv_keyid: int = 0
+    recv_rnextkeyid: int = 0
+    sizeof = 8
 
     def pack(self) -> bytes:
         return struct.pack(
-            "I",
+            "IBBBB",
             self.flags,
+            self.send_keyid,
+            self.send_rnextkeyid,
+            self.recv_keyid,
+            self.recv_rnextkeyid,
         )
 
     def __bytes__(self):
         return self.pack()
 
     @classmethod
     def unpack(cls, b: bytes):
-        tup = struct.unpack("I", b)
+        tup = struct.unpack("IBBBB", b)
         return cls(*tup)
 
 
 def set_tcp_authopt(sock, opt: tcp_authopt):
     return sock.setsockopt(socket.IPPROTO_TCP, TCP_AUTHOPT, bytes(opt))
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_rollover.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_rollover.py
new file mode 100644
index 000000000000..68c59c6d1e33
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_rollover.py
@@ -0,0 +1,181 @@
+# SPDX-License-Identifier: GPL-2.0
+import typing
+import socket
+from .server import SimpleServerThread
+from .linux_tcp_authopt import (
+    TCP_AUTHOPT_FLAG_LOCK_KEYID,
+    TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID,
+    set_tcp_authopt_key,
+    tcp_authopt,
+    tcp_authopt_key,
+    set_tcp_authopt,
+    get_tcp_authopt,
+)
+from .utils import DEFAULT_TCP_SERVER_PORT, create_listen_socket, check_socket_echo
+from contextlib import ExitStack, contextmanager
+from .conftest import skipif_missing_tcp_authopt
+
+pytestmark = skipif_missing_tcp_authopt
+
+
+@contextmanager
+def make_tcp_authopt_socket_pair(
+    server_addr="127.0.0.1",
+    server_authopt: tcp_authopt = None,
+    server_key_list: typing.Iterable[tcp_authopt_key] = [],
+    client_authopt: tcp_authopt = None,
+    client_key_list: typing.Iterable[tcp_authopt_key] = [],
+) -> typing.Tuple[socket.socket, socket.socket]:
+    """Make a pair for connected sockets for key switching tests
+
+    Server runs in a background thread implementing echo protocol"""
+    with ExitStack() as exit_stack:
+        listen_socket = exit_stack.enter_context(
+            create_listen_socket(bind_addr=server_addr)
+        )
+        server_thread = exit_stack.enter_context(
+            SimpleServerThread(listen_socket, mode="echo")
+        )
+        client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
+        client_socket.settimeout(1.0)
+
+        if server_authopt:
+            set_tcp_authopt(listen_socket, server_authopt)
+        for k in server_key_list:
+            set_tcp_authopt_key(listen_socket, k)
+        if client_authopt:
+            set_tcp_authopt(client_socket, client_authopt)
+        for k in client_key_list:
+            set_tcp_authopt_key(client_socket, k)
+
+        client_socket.connect((server_addr, DEFAULT_TCP_SERVER_PORT))
+        check_socket_echo(client_socket)
+        server_socket = server_thread.server_socket[0]
+
+        yield client_socket, server_socket
+
+
+def test_get_keyids(exit_stack: ExitStack):
+    """Check reading key ids"""
+    sk1 = tcp_authopt_key(send_id=11, recv_id=12, key="111")
+    sk2 = tcp_authopt_key(send_id=21, recv_id=22, key="222")
+    ck1 = tcp_authopt_key(send_id=12, recv_id=11, key="111")
+    client_socket, server_socket = exit_stack.enter_context(
+        make_tcp_authopt_socket_pair(
+            server_key_list=[sk1, sk2],
+            client_key_list=[ck1],
+        )
+    )
+
+    check_socket_echo(client_socket)
+    client_tcp_authopt = get_tcp_authopt(client_socket)
+    server_tcp_authopt = get_tcp_authopt(server_socket)
+    assert server_tcp_authopt.send_keyid == 11
+    assert server_tcp_authopt.send_rnextkeyid == 12
+    assert server_tcp_authopt.recv_keyid == 12
+    assert server_tcp_authopt.recv_rnextkeyid == 11
+    assert client_tcp_authopt.send_keyid == 12
+    assert client_tcp_authopt.send_rnextkeyid == 11
+    assert client_tcp_authopt.recv_keyid == 11
+    assert client_tcp_authopt.recv_rnextkeyid == 12
+
+
+def test_rollover_send_keyid(exit_stack: ExitStack):
+    """Check reading key ids"""
+    sk1 = tcp_authopt_key(send_id=11, recv_id=12, key="111")
+    sk2 = tcp_authopt_key(send_id=21, recv_id=22, key="222")
+    ck1 = tcp_authopt_key(send_id=12, recv_id=11, key="111")
+    ck2 = tcp_authopt_key(send_id=22, recv_id=21, key="222")
+    client_socket, server_socket = exit_stack.enter_context(
+        make_tcp_authopt_socket_pair(
+            server_key_list=[sk1, sk2],
+            client_key_list=[ck1, ck2],
+            client_authopt=tcp_authopt(
+                send_keyid=12, flags=TCP_AUTHOPT_FLAG_LOCK_KEYID
+            ),
+        )
+    )
+
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(client_socket).recv_keyid == 11
+    assert get_tcp_authopt(server_socket).recv_keyid == 12
+
+    # Explicit request for key2
+    set_tcp_authopt(
+        client_socket, tcp_authopt(send_keyid=22, flags=TCP_AUTHOPT_FLAG_LOCK_KEYID)
+    )
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(client_socket).recv_keyid == 21
+    assert get_tcp_authopt(server_socket).recv_keyid == 22
+
+
+def test_rollover_rnextkeyid(exit_stack: ExitStack):
+    """Check reading key ids"""
+    sk1 = tcp_authopt_key(send_id=11, recv_id=12, key="111")
+    sk2 = tcp_authopt_key(send_id=21, recv_id=22, key="222")
+    ck1 = tcp_authopt_key(send_id=12, recv_id=11, key="111")
+    ck2 = tcp_authopt_key(send_id=22, recv_id=21, key="222")
+    client_socket, server_socket = exit_stack.enter_context(
+        make_tcp_authopt_socket_pair(
+            server_key_list=[sk1],
+            client_key_list=[ck1, ck2],
+            client_authopt=tcp_authopt(
+                send_keyid=12, flags=TCP_AUTHOPT_FLAG_LOCK_KEYID
+            ),
+        )
+    )
+
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(server_socket).recv_rnextkeyid == 11
+
+    # request rnextkeyd=22 but server does not have it
+    set_tcp_authopt(
+        client_socket,
+        tcp_authopt(send_rnextkeyid=21, flags=TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID),
+    )
+    check_socket_echo(client_socket)
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(server_socket).recv_rnextkeyid == 21
+    assert get_tcp_authopt(server_socket).send_keyid == 11
+
+    # after adding k2 on server the key is switched
+    set_tcp_authopt_key(server_socket, sk2)
+    check_socket_echo(client_socket)
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(server_socket).send_keyid == 21
+
+
+def test_rollover_delkey(exit_stack: ExitStack):
+    sk1 = tcp_authopt_key(send_id=11, recv_id=12, key="111")
+    sk2 = tcp_authopt_key(send_id=21, recv_id=22, key="222")
+    ck1 = tcp_authopt_key(send_id=12, recv_id=11, key="111")
+    ck2 = tcp_authopt_key(send_id=22, recv_id=21, key="222")
+    client_socket, server_socket = exit_stack.enter_context(
+        make_tcp_authopt_socket_pair(
+            server_key_list=[sk1, sk2],
+            client_key_list=[ck1, ck2],
+            client_authopt=tcp_authopt(
+                send_keyid=12, flags=TCP_AUTHOPT_FLAG_LOCK_KEYID
+            ),
+        )
+    )
+
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(server_socket).recv_keyid == 12
+
+    # invalid send_keyid is just ignored
+    set_tcp_authopt(client_socket, tcp_authopt(send_keyid=7))
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(client_socket).send_keyid == 12
+    assert get_tcp_authopt(server_socket).recv_keyid == 12
+    assert get_tcp_authopt(client_socket).recv_keyid == 11
+
+    # If a key is removed it is replaced by anything that matches
+    ck1.delete_flag = True
+    set_tcp_authopt_key(client_socket, ck1)
+    check_socket_echo(client_socket)
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(client_socket).send_keyid == 22
+    assert get_tcp_authopt(server_socket).send_keyid == 21
+    assert get_tcp_authopt(server_socket).recv_keyid == 22
+    assert get_tcp_authopt(client_socket).recv_keyid == 21
-- 
2.25.1

