Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72CA441E9D
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhKAQjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbhKAQii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:38 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0A6C061714;
        Mon,  1 Nov 2021 09:36:04 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g10so66001779edj.1;
        Mon, 01 Nov 2021 09:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QRZdHrUUoGvPLEH765/cEa9sCMOEuFjZCleWmzxDxms=;
        b=G8MUuAzIGX57PoSvSyz9UjJYCJF9A6kZ5UZ5namTpifEShVdvBlfv9h6LMcafx2iZe
         OKTRyrA8pp9GrxfogmjwePWWrBFfI2uw8HnUCaw8yNPaq1BPhKTav2DxTYtqWvyPMhNB
         VYrO0SVfW+xhRvriryapmgSQb8NWAkP0iI14macQH7rxqvSktVKYUdN7o3fthjuN47KF
         oUS9Qj0FraAfEGDUD04jZQFiceut1lFb3Q1e++TT7tc7u3MXr7HqJ9peVtTq/DgQYiJH
         jXlhjxvqF0Rzb29Csz+5RSEgzvnurhikvOX2g8xXVRa6qHV0BWY8I8F1y6mYn/d3Exbs
         UwwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QRZdHrUUoGvPLEH765/cEa9sCMOEuFjZCleWmzxDxms=;
        b=4MjRScjzfX94QcEMFGr39/GC3BxaV1ivDNFCE8qG/j7GgdjaMokmVOTcwU2TDIPBFw
         B96G7F4Ywexv2UhC0RV5eqio7OfK+k34S2d2eChLDypaYquBRRy4oGP1/6OkE67BYtk6
         Qd/xlP9enw/Qns05Dx77T0qomCpiqOPmANSWx1DFZ1x6IZv1qZdWax4nkbYb+7hd2jtm
         XsVlYlI5ueY2qzgm4C5WUlI4f7+aV1UINgfoBOxTbFxR/DMcghjYHanRVHJJCX28TZ1a
         VyE9HU3Cv2CXKKL+I1n0CUNa6q6Hl0cZ6J1VhUCc4YKZhrCA65Hc7VMFumWJjlHIkbYH
         wXig==
X-Gm-Message-State: AOAM533JfKWQYibV0sqTck8/cjGFyxCWM3Oj7aPhsbfU0S9zuescb5QW
        jXo4xbLTFb6r8KkfMijKU98=
X-Google-Smtp-Source: ABdhPJxk21FOQEa7rqg2ABvkP4KDDBhDewL5wRDP1Y5PLnavpU4y5P1bYhVlhnVBBEAHhP1AtNyheg==
X-Received: by 2002:a17:906:3745:: with SMTP id e5mr37886114ejc.400.1635784563351;
        Mon, 01 Nov 2021 09:36:03 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:36:02 -0700 (PDT)
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
Subject: [PATCH v2 20/25] selftests: tcp_authopt: Add tests for rollover
Date:   Mon,  1 Nov 2021 18:34:55 +0200
Message-Id: <070c753a89b9aa53c1fef03d10a1bf14503fcc11.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
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
index b9dc9decda07..75cf5f993ccb 100644
--- a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
@@ -29,10 +29,12 @@ TCP_AUTHOPT_KEY = 39
 
 TCP_AUTHOPT_MAXKEYLEN = 80
 
 
 class TCP_AUTHOPT_FLAG(IntFlag):
+    LOCK_KEYID = BIT(0)
+    LOCK_RNEXTKEYID = BIT(1)
     REJECT_UNEXPECTED = BIT(2)
 
 
 class TCP_AUTHOPT_KEY_FLAG(IntFlag):
     DEL = BIT(0)
@@ -48,24 +50,32 @@ class TCP_AUTHOPT_ALG(IntEnum):
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
     return sock.setsockopt(socket.SOL_TCP, TCP_AUTHOPT, bytes(opt))
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_rollover.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_rollover.py
new file mode 100644
index 000000000000..2f48706a90e5
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_rollover.py
@@ -0,0 +1,181 @@
+# SPDX-License-Identifier: GPL-2.0
+import socket
+import typing
+from contextlib import ExitStack, contextmanager
+
+from .conftest import skipif_missing_tcp_authopt
+from .linux_tcp_authopt import (
+    TCP_AUTHOPT_FLAG,
+    get_tcp_authopt,
+    set_tcp_authopt,
+    set_tcp_authopt_key,
+    tcp_authopt,
+    tcp_authopt_key,
+)
+from .server import SimpleServerThread
+from .utils import DEFAULT_TCP_SERVER_PORT, check_socket_echo, create_listen_socket
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
+) -> typing.Iterator[typing.Tuple[socket.socket, socket.socket]]:
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
+                send_keyid=12, flags=TCP_AUTHOPT_FLAG.LOCK_KEYID
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
+        client_socket, tcp_authopt(send_keyid=22, flags=TCP_AUTHOPT_FLAG.LOCK_KEYID)
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
+                send_keyid=12, flags=TCP_AUTHOPT_FLAG.LOCK_KEYID
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
+        tcp_authopt(send_rnextkeyid=21, flags=TCP_AUTHOPT_FLAG.LOCK_RNEXTKEYID),
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
+                send_keyid=12, flags=TCP_AUTHOPT_FLAG.LOCK_KEYID
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

