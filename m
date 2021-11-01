Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A24441EA5
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhKAQlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbhKAQjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:39:03 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F39AC06122C;
        Mon,  1 Nov 2021 09:36:08 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id w1so12371686edd.10;
        Mon, 01 Nov 2021 09:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4pFQpBW+bTqSHMEmT/uXp9IkEtiNQgA2UVT11sb4WfE=;
        b=HQYWs0uplUyKIu4nX6kTcLVbwVDlN6FFYAlnXZCY0R1adzwGcJqJl1jO3Z5NfLFA9f
         ktf2lBVoS27bm4aTk/uviML4RptpSPBQ36x56QAHaIAZkCg0htXPmVURQJUmjoG2K2Ho
         Dejxzd90Dks3amK+ySu/1x66/ZXy1Q/rFKkk4eFOGxAb+2Sx5raoHUmCV+kPheh/8d27
         0zj5uC7B5bE/4auJe6zozFSJKsSUTAkOCmHDcQgc/tWLfznH2YxNhSHL+T7/5Mkc+/qM
         f4xr8NnJN1dKHeE1czjauKGBF3hFuL9wq+28W7pGayjzAeOpe7eFlTAO2GZU8khnSjkS
         7yUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4pFQpBW+bTqSHMEmT/uXp9IkEtiNQgA2UVT11sb4WfE=;
        b=tn6fRk0XQMvn0Hmm4IyMJeq2zUy9e0LWsVC+J5t0NOqQo9Upc07YoPwaGsb7nydtkR
         5WmSQlJi0AG1aivIP7StgFiKylQ2tllblQlmZgt/ujYV1MdLB8EwiwrRa9wF9iuOOGdN
         dDHA6+tUFgvZQgcBRrvZFxzAF0U/PYAqgnvbYGRBbV7UasIlKjljT9QjVygkd6liwsVf
         CcKFt/GNSq6Fu8zifVB6jV6NlE50y0K0theyRRGkho4FUmrmC90PRufXjEUvwQFKbMGn
         lYyiuLSvJ3AhLO0i0Np6isVpRXGqeKKNy6lnU5knRPxk16us5RZETFUVlCx4hOBKc40a
         BtiQ==
X-Gm-Message-State: AOAM530BTHRIhUiHYX7XxZmbFFcje6ffVDtyU01Xd0ksidDra4CZsaRQ
        H7+F6gAZ2tbt4FOF+iBrYWM=
X-Google-Smtp-Source: ABdhPJxKrRbS9SzCafEF7SyrYrvhgfqsc8a+e78WzMcDTyEXwDTlGKa1goxPha5jt9cWKyW9ha94Zg==
X-Received: by 2002:a17:906:1fc1:: with SMTP id e1mr36551453ejt.515.1635784567123;
        Mon, 01 Nov 2021 09:36:07 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:36:06 -0700 (PDT)
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
Subject: [PATCH v2 22/25] selftests: tcp_authopt: Initial tests for l3mdev handling
Date:   Mon,  1 Nov 2021 18:34:57 +0200
Message-Id: <aa93b9dade20a827f26e63417eab6ac4184de94c.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These tests also verify functionality in TCP-MD5 and unsigned traffic
modes. They were used to find the issue fixed in commit 86f1e3a8489f
("tcp: md5: Fix overlap between vrf and non-vrf keys")

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 .../tcp_authopt_test/linux_tcp_authopt.py     |   9 +
 .../tcp_authopt_test/test_vrf_bind.py         | 492 ++++++++++++++++++
 .../tcp_authopt_test/vrf_netns_fixture.py     | 127 +++++
 3 files changed, 628 insertions(+)
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vrf_bind.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/vrf_netns_fixture.py

diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
index 75cf5f993ccb..2a720d49cba2 100644
--- a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
@@ -38,10 +38,11 @@ class TCP_AUTHOPT_FLAG(IntFlag):
 
 class TCP_AUTHOPT_KEY_FLAG(IntFlag):
     DEL = BIT(0)
     EXCLUDE_OPTS = BIT(1)
     BIND_ADDR = BIT(2)
+    IFINDEX = BIT(3)
 
 
 class TCP_AUTHOPT_ALG(IntEnum):
     HMAC_SHA_1_96 = 1
     AES_128_CMAC_96 = 2
@@ -102,25 +103,31 @@ class tcp_authopt_key:
         recv_id: int = 0,
         alg=TCP_AUTHOPT_ALG.HMAC_SHA_1_96,
         key: KeyArgType = b"",
         addr: AddrArgType = None,
         auto_flags: bool = True,
+        ifindex: typing.Optional[int] = None,
         include_options=None,
     ):
         self.flags = flags
         self.send_id = send_id
         self.recv_id = recv_id
         self.alg = alg
         self.key = key
+        self.ifindex = ifindex
         self.addr = addr
         self.auto_flags = auto_flags
         if include_options is not None:
             self.include_options = include_options
 
     def get_real_flags(self) -> TCP_AUTHOPT_KEY_FLAG:
         result = self.flags
         if self.auto_flags:
+            if self.ifindex is not None:
+                result |= TCP_AUTHOPT_KEY_FLAG.IFINDEX
+            else:
+                result &= ~TCP_AUTHOPT_KEY_FLAG.IFINDEX
             if self.addr is not None:
                 result |= TCP_AUTHOPT_KEY_FLAG.BIND_ADDR
             else:
                 result &= ~TCP_AUTHOPT_KEY_FLAG.BIND_ADDR
         return result
@@ -136,10 +143,12 @@ class tcp_authopt_key:
             self.alg,
             len(self.key),
             self.key,
         )
         data += bytes(self.addrbuf.ljust(sockaddr_storage.sizeof, b"\x00"))
+        if self.ifindex is not None:
+            data += bytes(struct.pack("I", self.ifindex))
         return data
 
     def __bytes__(self):
         return self.pack()
 
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vrf_bind.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vrf_bind.py
new file mode 100644
index 000000000000..da43ac8842e5
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vrf_bind.py
@@ -0,0 +1,492 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Test VRF overlap behavior
+
+With tcp_l3mdev_accept single server should be able to differentiate multiple
+clients with same IP coming from different VRFs.
+"""
+import errno
+import logging
+import socket
+from contextlib import ExitStack
+
+import pytest
+
+from . import linux_tcp_md5sig
+from .conftest import parametrize_product, skipif_missing_tcp_authopt
+from .linux_tcp_authopt import (
+    set_tcp_authopt_key,
+    set_tcp_authopt_key_kwargs,
+    tcp_authopt_key,
+)
+from .server import SimpleServerThread
+from .utils import (
+    DEFAULT_TCP_SERVER_PORT,
+    check_socket_echo,
+    create_client_socket,
+    create_listen_socket,
+)
+from .vrf_netns_fixture import VrfNamespaceFixture
+
+logger = logging.getLogger(__name__)
+
+
+class VrfFixture:
+    """Fixture for VRF testing
+
+    Single server has two interfaces with same IP addr: one inside VRF and one
+    outside. Two clients two namespaces have same client IP, one connected to
+    VRF and one outside.
+    """
+
+    def __init__(
+        self,
+        address_family=socket.AF_INET,
+        tcp_l3mdev_accept=1,
+        init_default_listen_socket=True,
+    ):
+        self.address_family = address_family
+        self.tcp_l3mdev_accept = tcp_l3mdev_accept
+        self.init_default_listen_socket = init_default_listen_socket
+
+    @property
+    def server_addr(self):
+        if self.address_family == socket.AF_INET:
+            return self.nsfixture.server_ipv4_addr
+        else:
+            return self.nsfixture.server_ipv6_addr
+
+    @property
+    def client_addr(self):
+        if self.address_family == socket.AF_INET:
+            return self.nsfixture.client_ipv4_addr
+        else:
+            return self.nsfixture.client_ipv6_addr
+
+    @property
+    def server_addr_port(self):
+        return (str(self.server_addr), DEFAULT_TCP_SERVER_PORT)
+
+    @property
+    def vrf1_ifindex(self):
+        return self.nsfixture.server_vrf1_ifindex
+
+    @property
+    def vrf2_ifindex(self):
+        return self.nsfixture.server_vrf2_ifindex
+
+    def create_listen_socket(self, **kw):
+        result = create_listen_socket(
+            family=self.address_family,
+            ns=self.nsfixture.server_netns_name,
+            bind_addr=self.server_addr,
+            **kw
+        )
+        self.exit_stack.enter_context(result)
+        return result
+
+    def create_client_socket(self, ns):
+        result = create_client_socket(
+            ns=ns, family=self.address_family, bind_addr=self.client_addr
+        )
+        self.exit_stack.enter_context(result)
+        return result
+
+    def __enter__(self):
+        self.exit_stack = ExitStack()
+        self.exit_stack.__enter__()
+        self.nsfixture = self.exit_stack.enter_context(
+            VrfNamespaceFixture(tcp_l3mdev_accept=self.tcp_l3mdev_accept)
+        )
+
+        self.server_thread = SimpleServerThread(mode="echo")
+        if self.init_default_listen_socket:
+            self.listen_socket = self.create_listen_socket()
+            self.server_thread.add_listen_socket(self.listen_socket)
+        self.exit_stack.enter_context(self.server_thread)
+        return self
+
+    def __exit__(self, *args):
+        self.exit_stack.__exit__(*args)
+
+
+@pytest.mark.parametrize("address_family", [socket.AF_INET, socket.AF_INET6])
+def test_vrf_overlap_unsigned(exit_stack: ExitStack, address_family):
+    """Test without any signature support"""
+    fix = VrfFixture(address_family)
+    exit_stack.enter_context(fix)
+
+    client_socket0 = fix.create_client_socket(fix.nsfixture.client1_netns_name)
+    client_socket1 = fix.create_client_socket(fix.nsfixture.client1_netns_name)
+    client_socket2 = fix.create_client_socket(fix.nsfixture.client2_netns_name)
+
+    client_socket2.connect(fix.server_addr_port)
+    client_socket1.connect(fix.server_addr_port)
+    client_socket0.connect(fix.server_addr_port)
+    check_socket_echo(client_socket1)
+    check_socket_echo(client_socket2)
+    check_socket_echo(client_socket0)
+    check_socket_echo(client_socket1)
+    check_socket_echo(client_socket2)
+    check_socket_echo(client_socket0)
+    check_socket_echo(client_socket2)
+
+
+KEY0 = b"00000"
+KEY1 = b"1"
+KEY2 = b"22"
+
+
+def set_server_md5(fix, key=KEY0, **kw):
+    linux_tcp_md5sig.setsockopt_md5sig_kwargs(
+        fix.listen_socket, key=key, addr=fix.client_addr, **kw
+    )
+
+
+def set_server_md5_key0(fix, key=KEY0):
+    return set_server_md5(fix, key=key)
+
+
+def set_server_md5_key1(fix, key=KEY1):
+    return set_server_md5(fix, key=key, ifindex=fix.vrf1_ifindex)
+
+
+def set_server_md5_key2(fix, key=KEY2):
+    return set_server_md5(fix, key=key, ifindex=fix.vrf2_ifindex)
+
+
+def set_client_md5_key(fix, client_socket, key):
+    linux_tcp_md5sig.setsockopt_md5sig_kwargs(
+        client_socket, key=key, addr=fix.server_addr
+    )
+
+
+@pytest.mark.parametrize("address_family", [socket.AF_INET, socket.AF_INET6])
+def test_vrf_overlap_md5_samekey(exit_stack: ExitStack, address_family):
+    """Test overlapping keys that are identical"""
+    fix = VrfFixture(address_family)
+    exit_stack.enter_context(fix)
+    set_server_md5_key0(fix, b"same")
+    set_server_md5_key1(fix, b"same")
+    set_server_md5_key2(fix, b"same")
+    client_socket0 = fix.create_client_socket(fix.nsfixture.client0_netns_name)
+    client_socket1 = fix.create_client_socket(fix.nsfixture.client1_netns_name)
+    client_socket2 = fix.create_client_socket(fix.nsfixture.client2_netns_name)
+    set_client_md5_key(fix, client_socket0, b"same")
+    set_client_md5_key(fix, client_socket1, b"same")
+    set_client_md5_key(fix, client_socket2, b"same")
+    client_socket0.connect(fix.server_addr_port)
+    client_socket1.connect(fix.server_addr_port)
+    client_socket2.connect(fix.server_addr_port)
+    check_socket_echo(client_socket1)
+    check_socket_echo(client_socket2)
+    check_socket_echo(client_socket0)
+
+
+@pytest.mark.parametrize("address_family", [socket.AF_INET, socket.AF_INET6])
+def test_vrf_overlap12_md5(exit_stack: ExitStack, address_family):
+    """Test overlapping keys between vrfs"""
+    fix = VrfFixture(address_family)
+    exit_stack.enter_context(fix)
+    set_server_md5_key1(fix)
+    set_server_md5_key2(fix)
+    client_socket1 = fix.create_client_socket(fix.nsfixture.client1_netns_name)
+    client_socket2 = fix.create_client_socket(fix.nsfixture.client2_netns_name)
+    set_client_md5_key(fix, client_socket1, KEY1)
+    set_client_md5_key(fix, client_socket2, KEY2)
+    client_socket1.connect(fix.server_addr_port)
+    client_socket2.connect(fix.server_addr_port)
+    check_socket_echo(client_socket1)
+    check_socket_echo(client_socket2)
+
+
+@pytest.mark.parametrize("address_family", [socket.AF_INET, socket.AF_INET6])
+def test_vrf_overlap01_md5(exit_stack: ExitStack, address_family):
+    """Test overlapping keys inside and outside vrf, VRF key added second"""
+    fix = VrfFixture(address_family)
+    exit_stack.enter_context(fix)
+    set_server_md5_key0(fix)
+    set_server_md5_key1(fix)
+    client_socket0 = fix.create_client_socket(fix.nsfixture.client0_netns_name)
+    client_socket1 = fix.create_client_socket(fix.nsfixture.client1_netns_name)
+    set_client_md5_key(fix, client_socket0, KEY0)
+    set_client_md5_key(fix, client_socket1, KEY1)
+    client_socket1.connect(fix.server_addr_port)
+    client_socket0.connect(fix.server_addr_port)
+    check_socket_echo(client_socket0)
+    check_socket_echo(client_socket1)
+
+
+@pytest.mark.parametrize("address_family", [socket.AF_INET, socket.AF_INET6])
+def test_vrf_overlap10_md5(exit_stack: ExitStack, address_family):
+    """Test overlapping keys inside and outside vrf, VRF key added first"""
+    fix = VrfFixture(address_family)
+    exit_stack.enter_context(fix)
+    set_server_md5_key1(fix)
+    set_server_md5_key0(fix)
+    client_socket0 = fix.create_client_socket(fix.nsfixture.client0_netns_name)
+    client_socket1 = fix.create_client_socket(fix.nsfixture.client1_netns_name)
+    set_client_md5_key(fix, client_socket0, KEY0)
+    set_client_md5_key(fix, client_socket1, KEY1)
+    client_socket1.connect(fix.server_addr_port)
+    client_socket0.connect(fix.server_addr_port)
+    check_socket_echo(client_socket0)
+    check_socket_echo(client_socket1)
+
+
+@pytest.mark.parametrize("address_family", [socket.AF_INET])
+def test_vrf_overlap_md5_prefix(exit_stack: ExitStack, address_family):
+    """VRF keys should take precedence even if prefixlen is low"""
+    fix = VrfFixture(address_family)
+    exit_stack.enter_context(fix)
+    set_server_md5(fix, key=b"fail", prefixlen=16)
+    set_server_md5(
+        fix, key=b"pass", ifindex=fix.nsfixture.server_vrf1_ifindex, prefixlen=1
+    )
+    set_server_md5(fix, key=b"fail", prefixlen=24)
+
+    # connect via VRF
+    client_socket = fix.create_client_socket(fix.nsfixture.client1_netns_name)
+    set_client_md5_key(fix, client_socket, b"pass")
+    client_socket.connect(fix.server_addr_port)
+
+
+class TestVRFOverlapAOBoundKeyPrecedence:
+    """Keys bound to VRF should take precedence over unbound keys.
+
+    KEY0 is unbound (accepts all vrfs)
+    KEY1 is bound to vrf1
+    """
+
+    fix: VrfFixture
+
+    @pytest.fixture(
+        autouse=True,
+        scope="class",
+        params=[socket.AF_INET, socket.AF_INET6],
+    )
+    def init(self, request: pytest.FixtureRequest):
+        address_family = request.param
+        logger.info("init address_family=%s", address_family)
+        with ExitStack() as exit_stack:
+            fix = exit_stack.enter_context(VrfFixture(address_family))
+            set_tcp_authopt_key_kwargs(
+                fix.listen_socket,
+                key=KEY0,
+                ifindex=None,
+            )
+            set_tcp_authopt_key_kwargs(
+                fix.listen_socket,
+                key=KEY1,
+                ifindex=fix.vrf1_ifindex,
+            )
+            self.__class__.fix = fix
+            yield
+        logger.info("done address_family=%s", address_family)
+
+    def test_vrf1_key0(self):
+        client_socket = self.fix.create_client_socket(
+            self.fix.nsfixture.client1_netns_name
+        )
+        set_tcp_authopt_key_kwargs(client_socket, key=KEY0)
+        with pytest.raises(socket.timeout):
+            client_socket.connect(self.fix.server_addr_port)
+
+    def test_vrf1_key1(self):
+        client_socket = self.fix.create_client_socket(
+            self.fix.nsfixture.client1_netns_name
+        )
+        set_tcp_authopt_key_kwargs(client_socket, key=KEY1)
+        client_socket.connect(self.fix.server_addr_port)
+
+    def test_vrf2_key0(self):
+        client_socket = self.fix.create_client_socket(
+            self.fix.nsfixture.client2_netns_name
+        )
+        set_tcp_authopt_key_kwargs(client_socket, key=KEY0)
+        client_socket.connect(self.fix.server_addr_port)
+
+    def test_vrf2_key1(self):
+        client_socket = self.fix.create_client_socket(
+            self.fix.nsfixture.client2_netns_name
+        )
+        set_tcp_authopt_key_kwargs(client_socket, key=KEY1)
+        with pytest.raises(socket.timeout):
+            client_socket.connect(self.fix.server_addr_port)
+
+
+def assert_raises_enoent(func):
+    with pytest.raises(OSError) as e:
+        func()
+    assert e.value.errno == errno.ENOENT
+
+
+def test_vrf_overlap_md5_del_0110():
+    """Removing keys should not raise ENOENT because they are distinct"""
+    with VrfFixture() as fix:
+        set_server_md5(fix, key=KEY0)
+        set_server_md5(fix, key=KEY1, ifindex=fix.vrf1_ifindex)
+        set_server_md5(fix, key=b"", ifindex=fix.vrf1_ifindex)
+        set_server_md5(fix, key=b"")
+        assert_raises_enoent(lambda: set_server_md5(fix, key=b""))
+
+
+def test_vrf_overlap_md5_del_1001():
+    """Removing keys should not raise ENOENT because they are distinct"""
+    with VrfFixture() as fix:
+        set_server_md5(fix, key=KEY1, ifindex=fix.vrf1_ifindex)
+        set_server_md5(fix, key=KEY0)
+        set_server_md5(fix, key=b"")
+        set_server_md5(fix, key=b"", ifindex=fix.vrf1_ifindex)
+        assert_raises_enoent(lambda: set_server_md5(fix, key=b""))
+
+
+def test_vrf_overlap_md5_del_1010():
+    """Removing keys should not raise ENOENT because they are distinct"""
+    with VrfFixture() as fix:
+        set_server_md5(fix, key=KEY1, ifindex=fix.vrf1_ifindex)
+        set_server_md5(fix, key=KEY0)
+        set_server_md5(fix, key=b"", ifindex=fix.vrf1_ifindex)
+        set_server_md5(fix, key=b"")
+        assert_raises_enoent(lambda: set_server_md5(fix, key=b""))
+
+
+@skipif_missing_tcp_authopt
+@pytest.mark.parametrize("address_family", [socket.AF_INET, socket.AF_INET6])
+def test_vrf_overlap_ao_samekey(exit_stack: ExitStack, address_family):
+    """Single server serving both VRF and non-VRF client with same password.
+
+    This requires no special support from TCP-AO.
+    """
+    fix = VrfFixture(address_family)
+    exit_stack.enter_context(fix)
+    set_tcp_authopt_key(fix.listen_socket, tcp_authopt_key(key="11111"))
+
+    client_socket1 = fix.create_client_socket(fix.nsfixture.client1_netns_name)
+    client_socket2 = fix.create_client_socket(fix.nsfixture.client2_netns_name)
+
+    set_tcp_authopt_key(client_socket1, tcp_authopt_key(key="11111"))
+    set_tcp_authopt_key(client_socket2, tcp_authopt_key(key="11111"))
+    client_socket1.connect(fix.server_addr_port)
+    client_socket2.connect(fix.server_addr_port)
+    check_socket_echo(client_socket1)
+    check_socket_echo(client_socket2)
+    check_socket_echo(client_socket1)
+    check_socket_echo(client_socket2)
+
+
+@skipif_missing_tcp_authopt
+@pytest.mark.parametrize("address_family", [socket.AF_INET, socket.AF_INET6])
+def test_vrf_overlap_ao(exit_stack: ExitStack, address_family):
+    """Single server serving both VRF and non-VRF client with different passwords
+
+    This requires kernel to handle ifindex
+    """
+    fix = VrfFixture(address_family)
+    exit_stack.enter_context(fix)
+    set_tcp_authopt_key(
+        fix.listen_socket,
+        tcp_authopt_key(key=KEY0, ifindex=0),
+    )
+    set_tcp_authopt_key(
+        fix.listen_socket,
+        tcp_authopt_key(key=KEY1, ifindex=fix.vrf1_ifindex),
+    )
+    set_tcp_authopt_key(
+        fix.listen_socket,
+        tcp_authopt_key(key=KEY2, ifindex=fix.vrf2_ifindex),
+    )
+
+    client_socket0 = fix.create_client_socket(fix.nsfixture.client0_netns_name)
+    client_socket1 = fix.create_client_socket(fix.nsfixture.client1_netns_name)
+    client_socket2 = fix.create_client_socket(fix.nsfixture.client2_netns_name)
+    set_tcp_authopt_key(client_socket0, tcp_authopt_key(key=KEY0))
+    set_tcp_authopt_key(client_socket1, tcp_authopt_key(key=KEY1))
+    set_tcp_authopt_key(client_socket2, tcp_authopt_key(key=KEY2))
+    client_socket0.connect(fix.server_addr_port)
+    client_socket1.connect(fix.server_addr_port)
+    client_socket2.connect(fix.server_addr_port)
+    check_socket_echo(client_socket0)
+    check_socket_echo(client_socket1)
+    check_socket_echo(client_socket2)
+    check_socket_echo(client_socket0)
+    check_socket_echo(client_socket1)
+    check_socket_echo(client_socket2)
+
+
+@parametrize_product(
+    address_family=(socket.AF_INET, socket.AF_INET6),
+    tcp_l3mdev_accept=(0, 1),
+    bind_key_to_vrf=(0, 1),
+)
+def test_md5_pervrf(
+    exit_stack: ExitStack, address_family, tcp_l3mdev_accept, bind_key_to_vrf
+):
+    """Test one VRF-bound socket.
+
+    Since the socket is already bound to the vrf binding the key should not be required.
+    """
+    fix = VrfFixture(
+        address_family,
+        tcp_l3mdev_accept=tcp_l3mdev_accept,
+        init_default_listen_socket=False,
+    )
+    exit_stack.enter_context(fix)
+    listen_socket1 = fix.create_listen_socket(bind_device="veth1")
+    linux_tcp_md5sig.setsockopt_md5sig_kwargs(
+        listen_socket1,
+        key=KEY1,
+        addr=fix.client_addr,
+        ifindex=fix.vrf1_ifindex if bind_key_to_vrf else None,
+    )
+    fix.server_thread.add_listen_socket(listen_socket1)
+    client_socket1 = fix.create_client_socket(fix.nsfixture.client1_netns_name)
+    set_client_md5_key(fix, client_socket1, KEY1)
+    client_socket1.connect(fix.server_addr_port)
+    check_socket_echo(client_socket1)
+
+
+@pytest.mark.parametrize(
+    "address_family",
+    (socket.AF_INET, socket.AF_INET6),
+)
+def test_vrf_overlap_md5_pervrf(exit_stack: ExitStack, address_family):
+    """Test overlapping via per-VRF sockets"""
+    fix = VrfFixture(
+        address_family,
+        tcp_l3mdev_accept=0,
+        init_default_listen_socket=False,
+    )
+    exit_stack.enter_context(fix)
+    listen_socket0 = fix.create_listen_socket()
+    listen_socket1 = fix.create_listen_socket(bind_device="veth1")
+    listen_socket2 = fix.create_listen_socket(bind_device="veth2")
+    linux_tcp_md5sig.setsockopt_md5sig_kwargs(
+        listen_socket0,
+        key=KEY0,
+        addr=fix.client_addr,
+    )
+    linux_tcp_md5sig.setsockopt_md5sig_kwargs(
+        listen_socket1,
+        key=KEY1,
+        addr=fix.client_addr,
+    )
+    linux_tcp_md5sig.setsockopt_md5sig_kwargs(
+        listen_socket2,
+        key=KEY2,
+        addr=fix.client_addr,
+    )
+    fix.server_thread.add_listen_socket(listen_socket0)
+    fix.server_thread.add_listen_socket(listen_socket1)
+    fix.server_thread.add_listen_socket(listen_socket2)
+    client_socket0 = fix.create_client_socket(fix.nsfixture.client0_netns_name)
+    client_socket1 = fix.create_client_socket(fix.nsfixture.client1_netns_name)
+    client_socket2 = fix.create_client_socket(fix.nsfixture.client2_netns_name)
+    set_client_md5_key(fix, client_socket0, KEY0)
+    set_client_md5_key(fix, client_socket1, KEY1)
+    set_client_md5_key(fix, client_socket2, KEY2)
+    client_socket0.connect(fix.server_addr_port)
+    client_socket1.connect(fix.server_addr_port)
+    client_socket2.connect(fix.server_addr_port)
+    check_socket_echo(client_socket1)
+    check_socket_echo(client_socket1)
+    check_socket_echo(client_socket0)
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/vrf_netns_fixture.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/vrf_netns_fixture.py
new file mode 100644
index 000000000000..ff9c0959a268
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/vrf_netns_fixture.py
@@ -0,0 +1,127 @@
+# SPDX-License-Identifier: GPL-2.0
+import subprocess
+from ipaddress import IPv4Address, IPv6Address
+
+
+def ip_link_get_ifindex(dev: str, prefix: str = "") -> int:
+    out = subprocess.check_output(
+        f"{prefix}ip -o link show {dev}", text=True, shell=True
+    )
+    return int(out.split(":", 1)[0])
+
+
+def get_ipv4_addr(ns=1, index=1) -> IPv4Address:
+    return IPv4Address("10.10.0.0") + (ns << 8) + index
+
+
+def get_ipv6_addr(ns=1, index=1) -> IPv6Address:
+    return IPv6Address("fd00::") + (ns << 16) + index
+
+
+class VrfNamespaceFixture:
+    """Namespace fixture for VRF testing.
+
+    Single server has two interfaces with same IP addr: one inside VRF and one
+    outside.
+
+    Two clients two namespaces have same client IP, one connected to VRF and one
+    outside.
+    """
+
+    tcp_l3mdev_accept = 1
+
+    server_netns_name = "tcp_authopt_test_server"
+    client0_netns_name = "tcp_authopt_test_client0"
+    client1_netns_name = "tcp_authopt_test_client1"
+    client2_netns_name = "tcp_authopt_test_client2"
+
+    # 02:* means "locally administered"
+    server_veth0_mac_addr = "02:00:00:01:00:00"
+    server_veth1_mac_addr = "02:00:00:01:00:01"
+    server_veth2_mac_addr = "02:00:00:01:00:02"
+    client0_mac_addr = "02:00:00:02:00:00"
+    client1_mac_addr = "02:00:00:02:01:00"
+    client2_mac_addr = "02:00:00:02:02:00"
+
+    server_ipv4_addr = get_ipv4_addr(1, 1)
+    server_ipv6_addr = get_ipv6_addr(1, 1)
+    client_ipv4_addr = get_ipv4_addr(2, 1)
+    client_ipv6_addr = get_ipv6_addr(2, 1)
+
+    def __init__(self, **kw):
+        import os
+
+        import pytest
+
+        from .conftest import raise_skip_no_netns
+
+        raise_skip_no_netns()
+        if not os.path.exists("/proc/sys/net/ipv4/tcp_l3mdev_accept"):
+            pytest.skip(
+                "missing tcp_l3mdev_accept, is CONFIG_NET_L3_MASTER_DEV enabled?)"
+            )
+        for k, v in kw.items():
+            setattr(self, k, v)
+
+    def get_server_ifindex(self, dev):
+        return ip_link_get_ifindex(dev, f"ip netns exec {self.server_netns_name} ")
+
+    def __enter__(self):
+        self._del_netns()
+        script = f"""
+set -e
+ip netns add {self.server_netns_name}
+ip netns add {self.client0_netns_name}
+ip netns add {self.client1_netns_name}
+ip netns add {self.client2_netns_name}
+# Enable tcp_l3mdev unconditionally
+ip netns exec {self.server_netns_name} sysctl -q net.ipv4.tcp_l3mdev_accept={int(self.tcp_l3mdev_accept)}
+ip link add veth0 netns {self.server_netns_name} type veth peer name veth0 netns {self.client0_netns_name}
+ip link add veth1 netns {self.server_netns_name} type veth peer name veth0 netns {self.client1_netns_name}
+ip link add veth2 netns {self.server_netns_name} type veth peer name veth0 netns {self.client2_netns_name}
+ip link add vrf1 netns {self.server_netns_name} type vrf table 1000
+ip link add vrf2 netns {self.server_netns_name} type vrf table 2000
+ip -n {self.server_netns_name} link set vrf1 up
+ip -n {self.server_netns_name} link set vrf2 up
+ip -n {self.server_netns_name} link set veth1 vrf vrf1
+ip -n {self.server_netns_name} link set veth2 vrf vrf2
+ip -n {self.server_netns_name} link set veth0 up addr {self.server_veth0_mac_addr}
+ip -n {self.server_netns_name} link set veth1 up addr {self.server_veth1_mac_addr}
+ip -n {self.server_netns_name} link set veth2 up addr {self.server_veth2_mac_addr}
+ip -n {self.server_netns_name} addr add {self.server_ipv4_addr}/16 dev veth0
+ip -n {self.server_netns_name} addr add {self.server_ipv6_addr}/64 dev veth0 nodad
+ip -n {self.server_netns_name} addr add {self.server_ipv4_addr}/16 dev veth1
+ip -n {self.server_netns_name} addr add {self.server_ipv6_addr}/64 dev veth1 nodad
+ip -n {self.server_netns_name} addr add {self.server_ipv4_addr}/16 dev veth2
+ip -n {self.server_netns_name} addr add {self.server_ipv6_addr}/64 dev veth2 nodad
+ip -n {self.client0_netns_name} link set veth0 up addr {self.client0_mac_addr}
+ip -n {self.client0_netns_name} addr add {self.client_ipv4_addr}/16 dev veth0
+ip -n {self.client0_netns_name} addr add {self.client_ipv6_addr}/64 dev veth0 nodad
+ip -n {self.client1_netns_name} link set veth0 up addr {self.client1_mac_addr}
+ip -n {self.client1_netns_name} addr add {self.client_ipv4_addr}/16 dev veth0
+ip -n {self.client1_netns_name} addr add {self.client_ipv6_addr}/64 dev veth0 nodad
+ip -n {self.client2_netns_name} link set veth0 up addr {self.client2_mac_addr}
+ip -n {self.client2_netns_name} addr add {self.client_ipv4_addr}/16 dev veth0
+ip -n {self.client2_netns_name} addr add {self.client_ipv6_addr}/64 dev veth0 nodad
+"""
+        subprocess.run(script, shell=True, check=True)
+        self.server_veth0_ifindex = self.get_server_ifindex("veth0")
+        self.server_veth1_ifindex = self.get_server_ifindex("veth1")
+        self.server_veth2_ifindex = self.get_server_ifindex("veth2")
+        self.server_vrf1_ifindex = self.get_server_ifindex("vrf1")
+        self.server_vrf2_ifindex = self.get_server_ifindex("vrf2")
+        return self
+
+    def _del_netns(self):
+        script = f"""\
+set -e
+for ns in {self.server_netns_name} {self.client0_netns_name} {self.client1_netns_name} {self.client2_netns_name}; do
+    if ip netns list | grep -q "$ns"; then
+        ip netns del "$ns"
+    fi
+done
+"""
+        subprocess.run(script, shell=True, check=True)
+
+    def __exit__(self, *a):
+        self._del_netns()
-- 
2.25.1

