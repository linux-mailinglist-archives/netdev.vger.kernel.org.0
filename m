Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13C9413742
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbhIUQTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234475AbhIUQSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:18:35 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78991C061764;
        Tue, 21 Sep 2021 09:17:06 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id bx4so32132965edb.4;
        Tue, 21 Sep 2021 09:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HeAfkH4ROj0yxoB2AlM931ZPipLTsDyKMbP+SmnI7KE=;
        b=CCt4Bl5CFLY2QNtn0yqZVnMYe6HFvqET7vCz1B0bQ2PxGQHLOFpkme9Wst7S1EPIvT
         bRpL1nZZWi2vayi8ZgW8n0hpc0uBr4wSGLGnpk/Nz8E64JlDzIjc0s0QDpeXycDxZTHC
         2ExGBB3cQOn2IaYfadgbaVv/Y0iqDC4y4elnbGCuMwOfIy1uS/U2vtjeSbzURyS0HQyX
         IreA7Ze9M2PceBXdjAbPAj4HM2zCmqM15Eeb0pToBrHI/qODo3jOrqJEAGsoWSqajaON
         ShjzrDRm5f0BXPhJ2sEANDq65AKjuWbpbzirTgJycJjzlEv+ARC2eDJcA9s+7PhM08S7
         clAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HeAfkH4ROj0yxoB2AlM931ZPipLTsDyKMbP+SmnI7KE=;
        b=rZPiTJtnlBbe8CX8kvWuyH9kLAEEJJqa/hfNP6RBNkgu1zh+Tm0WZ8szrRAqucDMfN
         0A6jT9niHti1K2ZXTZ7iUlVlPDr1DdEIw66Q1hTIJrJSQvmRVPtdC5nsXfX1o14C6znV
         DOjhUkFKy1HimzE0mMEsEXNhum+OdTPskh81H3UFfM+YwNjiwkf2XJ+qj1/3KcjGSUK9
         LxH+PeUvtVJcbEd/E4oH/u7P33gYvi8XZUOYTYzNzH7C0Mwp1Shf09cEmr4BdU4LhNoC
         eaAdg2lE5ZZSALJB4pg2uzNXphBGOML2BDkmGU+bMvrNAIti8ogHnN8PBUUpJvb/y88X
         Z+wg==
X-Gm-Message-State: AOAM531HQ8x2rFmXcfip2naLSl6NQQfi9xp0FE/CwgJvEgOOBnFxO4fN
        QzIb+lGkB6nWuMaHJ2lUzRE=
X-Google-Smtp-Source: ABdhPJzCA0IYASRKvJIbSUlBfGDIhzTLtT3IanpwvQ6xEHdXbO24xVofplUkJ/gyPwJ8cLsPr+BJbQ==
X-Received: by 2002:a17:906:7047:: with SMTP id r7mr34942161ejj.342.1632240938899;
        Tue, 21 Sep 2021 09:15:38 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:38 -0700 (PDT)
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
Subject: [PATCH 13/19] selftests: tcp_authopt: Add scapy-based packet signing code
Date:   Tue, 21 Sep 2021 19:14:56 +0300
Message-Id: <c1bf4fd9a5eefd6b566da7e530515351db118fbf.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tools like tcpdump and wireshark can parse the TCP Authentication Option
but there is not yet support to verify correct signatures.

This patch implements TCP-AO signature verification using scapy and the
python cryptography package.

The python code is verified itself with a subset of IETF test vectors
from this page:
https://datatracker.ietf.org/doc/html/draft-touch-tcpm-ao-test-vectors-02

The code in this commit is not specific to linux

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 .../tcp_authopt_test/scapy_tcp_authopt.py     | 211 ++++++++++
 .../tcp_authopt_test/scapy_utils.py           | 176 +++++++++
 .../tcp_authopt_test/test_vectors.py          | 359 ++++++++++++++++++
 .../tcp_authopt/tcp_authopt_test/validator.py | 127 +++++++
 4 files changed, 873 insertions(+)
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_tcp_authopt.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_utils.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vectors.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/validator.py

diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_tcp_authopt.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_tcp_authopt.py
new file mode 100644
index 000000000000..c32f9d931d2b
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_tcp_authopt.py
@@ -0,0 +1,211 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Packet-processing utilities implementing RFC5925 and RFC2926"""
+
+import logging
+from scapy.layers.inet import TCP
+from scapy.packet import Packet
+from .scapy_utils import TCPOPT_AUTHOPT, IPvXAddress, get_packet_ipvx_src, get_packet_ipvx_dst, get_tcp_pseudoheader, get_tcp_doff
+import struct
+import hmac
+
+logger = logging.getLogger(__name__)
+
+
+def _cmac_aes_digest(key: bytes, msg: bytes) -> bytes:
+    from cryptography.hazmat.primitives import cmac
+    from cryptography.hazmat.primitives.ciphers import algorithms
+    from cryptography.hazmat.backends import default_backend
+
+    backend = default_backend()
+    c = cmac.CMAC(algorithms.AES(key), backend=backend)
+    c.update(bytes(msg))
+    return c.finalize()
+
+
+class TcpAuthOptAlg:
+    @classmethod
+    def kdf(cls, master_key: bytes, context: bytes) -> bytes:
+        raise NotImplementedError()
+
+    @classmethod
+    def mac(cls, traffic_key: bytes, message: bytes) -> bytes:
+        raise NotImplementedError()
+
+    maclen = -1
+
+
+class TcpAuthOptAlg_HMAC_SHA1(TcpAuthOptAlg):
+    @classmethod
+    def kdf(cls, master_key: bytes, context: bytes) -> bytes:
+        input = b"\x01" + b"TCP-AO" + context + b"\x00\xa0"
+        return hmac.digest(master_key, input, "SHA1")
+
+    @classmethod
+    def mac(cls, traffic_key: bytes, message: bytes) -> bytes:
+        return hmac.digest(traffic_key, message, "SHA1")[:12]
+
+    maclen = 12
+
+
+class TcpAuthOptAlg_CMAC_AES(TcpAuthOptAlg):
+    @classmethod
+    def kdf(self, master_key: bytes, context: bytes) -> bytes:
+        if len(master_key) == 16:
+            key = master_key
+        else:
+            key = _cmac_aes_digest(b"\x00" * 16, master_key)
+        return _cmac_aes_digest(key, b"\x01" + b"TCP-AO" + context + b"\x00\x80")
+
+    @classmethod
+    def mac(self, traffic_key: bytes, message: bytes) -> bytes:
+        return _cmac_aes_digest(traffic_key, message)[:12]
+
+    maclen = 12
+
+
+def get_alg(name: str) -> TcpAuthOptAlg:
+    if name.upper() == "HMAC-SHA-1-96":
+        return TcpAuthOptAlg_HMAC_SHA1()
+    elif name.upper() == "AES-128-CMAC-96":
+        return TcpAuthOptAlg_CMAC_AES()
+    else:
+        raise ValueError(f"Bad TCP AuthOpt algorithms {name}")
+
+
+def build_context(
+    saddr: IPvXAddress, daddr: IPvXAddress, sport, dport, src_isn, dst_isn
+) -> bytes:
+    """Build context bytes as specified by RFC5925 section 5.2"""
+    return (
+        saddr.packed
+        + daddr.packed
+        + struct.pack(
+            "!HHII",
+            sport,
+            dport,
+            src_isn,
+            dst_isn,
+        )
+    )
+
+
+def build_context_from_packet(p: Packet, src_isn: int, dst_isn: int) -> bytes:
+    """Build context based on a scapy Packet and src/dst initial-sequence numbers"""
+    return build_context(
+        get_packet_ipvx_src(p),
+        get_packet_ipvx_dst(p),
+        p[TCP].sport,
+        p[TCP].dport,
+        src_isn,
+        dst_isn,
+    )
+
+
+def build_message_from_packet(p: Packet, include_options=True, sne=0) -> bytearray:
+    """Build message bytes as described by RFC5925 section 5.1"""
+    result = bytearray()
+    result += struct.pack("!I", sne)
+    th = p[TCP]
+
+    # ip pseudo-header:
+    result += get_tcp_pseudoheader(th)
+
+    # tcp header with checksum set to zero
+    th_bytes = bytes(p[TCP])
+    result += th_bytes[:16]
+    result += b"\x00\x00"
+    result += th_bytes[18:20]
+
+    # Even if include_options=False the TCP-AO option itself is still included
+    # with the MAC set to all-zeros. This means we need to parse TCP options.
+    pos = 20
+    tcphdr_optend = get_tcp_doff(th) * 4
+    # logger.info("th_bytes: %s", th_bytes.hex(' '))
+    assert len(th_bytes) >= tcphdr_optend
+    while pos < tcphdr_optend:
+        optnum = th_bytes[pos]
+        pos += 1
+        if optnum == 0 or optnum == 1:
+            if include_options:
+                result += bytes([optnum])
+            continue
+
+        optlen = th_bytes[pos]
+        pos += 1
+        if pos + optlen - 2 > tcphdr_optend:
+            logger.info(
+                "bad tcp option %d optlen %d beyond end-of-header", optnum, optlen
+            )
+            break
+        if optlen < 2:
+            logger.info("bad tcp option %d optlen %d less than two", optnum, optlen)
+            break
+        if optnum == TCPOPT_AUTHOPT:
+            if optlen < 4:
+                logger.info("bad tcp option %d optlen %d", optnum, optlen)
+                break
+            result += bytes([optnum, optlen])
+            result += th_bytes[pos : pos + 2]
+            result += (optlen - 4) * b"\x00"
+        elif include_options:
+            result += bytes([optnum, optlen])
+            result += th_bytes[pos : pos + optlen - 2]
+        pos += optlen - 2
+    result += bytes(p[TCP].payload)
+    return result
+
+
+def check_tcp_authopt_signature(
+    p: Packet, alg: TcpAuthOptAlg, master_key, sisn, disn, include_options=True, sne=0
+):
+    from .scapy_utils import scapy_tcp_get_authopt_val
+
+    ao = scapy_tcp_get_authopt_val(p[TCP])
+    if ao is None:
+        return None
+
+    context_bytes = build_context_from_packet(p, sisn, disn)
+    traffic_key = alg.kdf(master_key, context_bytes)
+    message_bytes = build_message_from_packet(
+        p, include_options=include_options, sne=sne
+    )
+    mac = alg.mac(traffic_key, message_bytes)
+    return mac == ao.mac
+
+
+def add_tcp_authopt_signature(
+    p: Packet,
+    alg: TcpAuthOptAlg,
+    master_key,
+    sisn,
+    disn,
+    keyid=0,
+    rnextkeyid=0,
+    include_options=True,
+    sne=0,
+):
+    """Sign a packet"""
+    th = p[TCP]
+    keyids = struct.pack("BB", keyid, rnextkeyid)
+    th.options = th.options + [(TCPOPT_AUTHOPT, keyids + alg.maclen * b"\x00")]
+
+    context_bytes = build_context_from_packet(p, sisn, disn)
+    traffic_key = alg.kdf(master_key, context_bytes)
+    message_bytes = build_message_from_packet(
+        p, include_options=include_options, sne=sne
+    )
+    mac = alg.mac(traffic_key, message_bytes)
+    th.options[-1] = (TCPOPT_AUTHOPT, keyids + mac)
+
+
+def break_tcp_authopt_signature(packet: Packet):
+    """Invalidate TCP-AO signature inside a packet
+
+    The packet must already be signed and it gets modified in-place.
+    """
+    opt = packet[TCP].options[-1]
+    if opt[0] != TCPOPT_AUTHOPT:
+        raise ValueError("TCP option list must end with TCP_AUTHOPT")
+    opt_mac = bytearray(opt[1])
+    opt_mac[-1] ^= 0xFF
+    packet[TCP].options[-1] = (opt[0], bytes(opt_mac))
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_utils.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_utils.py
new file mode 100644
index 000000000000..5000b8fe9ada
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/scapy_utils.py
@@ -0,0 +1,176 @@
+import typing
+import struct
+import socket
+import threading
+from dataclasses import dataclass
+from ipaddress import IPv4Address, IPv6Address
+
+from scapy.packet import Packet
+from scapy.layers.inet import IP, TCP
+from scapy.layers.inet6 import IPv6
+from scapy.config import conf as scapy_conf
+from scapy.sendrecv import AsyncSniffer
+
+from .utils import netns_context
+
+# TCPOPT numbers are apparently not available in scapy
+TCPOPT_MD5SIG = 19
+TCPOPT_AUTHOPT = 29
+
+# Easy generic handling of IPv4/IPv6Address
+IPvXAddress = typing.Union[IPv4Address, IPv6Address]
+
+
+def get_packet_ipvx_src(p: Packet) -> IPvXAddress:
+    if IP in p:
+        return IPv4Address(p[IP].src)
+    elif IPv6 in p:
+        return IPv6Address(p[IPv6].src)
+    else:
+        raise Exception("Neither IP nor IPv6 found on packet")
+
+
+def get_packet_ipvx_dst(p: Packet) -> IPvXAddress:
+    if IP in p:
+        return IPv4Address(p[IP].dst)
+    elif IPv6 in p:
+        return IPv6Address(p[IPv6].dst)
+    else:
+        raise Exception("Neither IP nor IPv6 found on packet")
+
+
+def get_tcp_doff(th: TCP):
+    """Get the TCP data offset, even if packet is not yet built"""
+    doff = th.dataofs
+    if doff is None:
+        opt_len = len(th.get_field("options").i2m(th, th.options))
+        doff = 5 + ((opt_len + 3) // 4)
+    return doff
+
+
+def get_tcp_v4_pseudoheader(tcp_packet: TCP) -> bytes:
+    iph = tcp_packet.underlayer
+    return struct.pack(
+        "!4s4sHH",
+        IPv4Address(iph.src).packed,
+        IPv4Address(iph.dst).packed,
+        socket.IPPROTO_TCP,
+        get_tcp_doff(tcp_packet) * 4 + len(tcp_packet.payload),
+    )
+
+
+def get_tcp_v6_pseudoheader(tcp_packet: TCP) -> bytes:
+    ipv6 = tcp_packet.underlayer
+    return struct.pack(
+        "!16s16sII",
+        IPv6Address(ipv6.src).packed,
+        IPv6Address(ipv6.dst).packed,
+        get_tcp_doff(tcp_packet) * 4 + len(tcp_packet.payload),
+        socket.IPPROTO_TCP,
+    )
+
+
+def get_tcp_pseudoheader(tcp_packet: TCP):
+    if isinstance(tcp_packet.underlayer, IP):
+        return get_tcp_v4_pseudoheader(tcp_packet)
+    if isinstance(tcp_packet.underlayer, IPv6):
+        return get_tcp_v6_pseudoheader(tcp_packet)
+    raise ValueError("TCP underlayer is neither IP nor IPv6")
+
+
+def tcp_seq_wrap(seq):
+    return seq & 0xFFFFFFFF
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
+        if optnum == TCPOPT_AUTHOPT:
+            return tcphdr_authopt.unpack(optval)
+    return None
+
+
+def scapy_tcp_get_md5_sig(tcp) -> typing.Optional[bytes]:
+    """Return the MD5 signature (as bytes) or None"""
+    for optnum, optval in tcp.options:
+        if optnum == TCPOPT_MD5SIG:
+            return optval
+    return None
+
+
+def calc_tcp_md5_hash(p, key: bytes) -> bytes:
+    """Calculate TCP-MD5 hash from packet and return a 16-byte string"""
+    import hashlib
+
+    h = hashlib.md5()
+    tp = p[TCP]
+    th_bytes = bytes(p[TCP])
+    h.update(get_tcp_pseudoheader(tp))
+    h.update(th_bytes[:16])
+    h.update(b"\x00\x00")
+    h.update(th_bytes[18:20])
+    h.update(bytes(tp.payload))
+    h.update(key)
+
+    return h.digest()
+
+
+def create_l2socket(ns: str = "", **kw):
+    """Create a scapy L2socket inside a namespace"""
+
+    with netns_context(ns):
+        return scapy_conf.L2socket(**kw)
+
+
+def create_capture_socket(ns: str = "", **kw):
+    """Create a scapy L2listen socket inside a namespace"""
+    from scapy.config import conf as scapy_conf
+
+    with netns_context(ns):
+        return scapy_conf.L2listen(**kw)
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
+    e = threading.Event()
+    sniffer.kwargs["started_callback"] = e.set
+    sniffer.start()
+    e.wait(timeout=timeout)
+    if not e.is_set():
+        raise TimeoutError("Timed out waiting for sniffer to start")
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
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vectors.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vectors.py
new file mode 100644
index 000000000000..e918439ef9f4
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vectors.py
@@ -0,0 +1,359 @@
+# SPDX-License-Identifier: GPL-2.0
+import logging
+from ipaddress import IPv4Address, IPv6Address
+from scapy.layers.inet import IP, TCP
+from scapy.layers.inet6 import IPv6
+from .scapy_tcp_authopt import get_alg, build_context_from_packet, build_message_from_packet
+from .scapy_utils import scapy_tcp_get_authopt_val
+import socket
+
+logger = logging.getLogger(__name__)
+
+
+class TestIETFVectors:
+    """Test python implementation of TCP-AO algorithms
+
+    Data is a subset of IETF test vectors:
+    https://datatracker.ietf.org/doc/html/draft-touch-tcpm-ao-test-vectors-02
+    """
+
+    master_key = b"testvector"
+    client_keyid = 61
+    server_keyid = 84
+    client_ipv4 = IPv4Address("10.11.12.13")
+    client_ipv6 = IPv6Address("FD00::1")
+    server_ipv4 = IPv4Address("172.27.28.29")
+    server_ipv6 = IPv6Address("FD00::2")
+
+    client_isn_41x = 0xFBFBAB5A
+    server_isn_41x = 0x11C14261
+    client_isn_42x = 0xCB0EFBEE
+    server_isn_42x = 0xACD5B5E1
+    client_isn_61x = 0x176A833F
+    server_isn_61x = 0x3F51994B
+    client_isn_62x = 0x020C1E69
+    server_isn_62x = 0xEBA3734D
+
+    def check(
+        self,
+        packet_hex: str,
+        traffic_key_hex: str,
+        mac_hex: str,
+        src_isn,
+        dst_isn,
+        include_options=True,
+        alg_name="HMAC-SHA-1-96",
+        sne=0,
+    ):
+        packet_bytes = bytes.fromhex(packet_hex)
+
+        # sanity check for ip version
+        ipv = packet_bytes[0] >> 4
+        if ipv == 4:
+            p = IP(bytes.fromhex(packet_hex))
+            assert p[IP].proto == socket.IPPROTO_TCP
+        elif ipv == 6:
+            p = IPv6(bytes.fromhex(packet_hex))
+            assert p[IPv6].nh == socket.IPPROTO_TCP
+        else:
+            raise ValueError(f"bad ipv={ipv}")
+
+        # sanity check for seq/ack in SYN/ACK packets
+        if p[TCP].flags.S and p[TCP].flags.A is False:
+            assert p[TCP].seq == src_isn
+            assert p[TCP].ack == 0
+        if p[TCP].flags.S and p[TCP].flags.A:
+            assert p[TCP].seq == src_isn
+            assert p[TCP].ack == dst_isn + 1
+
+        # check traffic key
+        alg = get_alg(alg_name)
+        context_bytes = build_context_from_packet(p, src_isn, dst_isn)
+        traffic_key = alg.kdf(self.master_key, context_bytes)
+        assert traffic_key.hex(" ") == traffic_key_hex
+
+        # check mac
+        message_bytes = build_message_from_packet(
+            p, include_options=include_options, sne=sne
+        )
+        mac = alg.mac(traffic_key, message_bytes)
+        assert mac.hex(" ") == mac_hex
+
+        # check option bytes in header
+        opt = scapy_tcp_get_authopt_val(p[TCP])
+        assert opt is not None
+        assert opt.keyid in [self.client_keyid, self.server_keyid]
+        assert opt.rnextkeyid in [self.client_keyid, self.server_keyid]
+        assert opt.mac.hex(" ") == mac_hex
+
+    def test_4_1_1(self):
+        self.check(
+            """
+            45 e0 00 4c dd 0f 40 00 ff 06 bf 6b 0a 0b 0c 0d
+            ac 1b 1c 1d e9 d7 00 b3 fb fb ab 5a 00 00 00 00
+            e0 02 ff ff ca c4 00 00 02 04 05 b4 01 03 03 08
+            04 02 08 0a 00 15 5a b7 00 00 00 00 1d 10 3d 54
+            2e e4 37 c6 f8 ed e6 d7 c4 d6 02 e7
+            """,
+            "6d 63 ef 1b 02 fe 15 09 d4 b1 40 27 07 fd 7b 04 16 ab b7 4f",
+            "2e e4 37 c6 f8 ed e6 d7 c4 d6 02 e7",
+            self.client_isn_41x,
+            0,
+        )
+
+    def test_4_1_2(self):
+        self.check(
+            """
+            45 e0 00 4c 65 06 40 00 ff 06 37 75 ac 1b 1c 1d
+            0a 0b 0c 0d 00 b3 e9 d7 11 c1 42 61 fb fb ab 5b
+            e0 12 ff ff 37 76 00 00 02 04 05 b4 01 03 03 08
+            04 02 08 0a 84 a5 0b eb 00 15 5a b7 1d 10 54 3d
+            ee ab 0f e2 4c 30 10 81 51 16 b3 be
+            """,
+            "d9 e2 17 e4 83 4a 80 ca 2f 3f d8 de 2e 41 b8 e6 79 7f ea 96",
+            "ee ab 0f e2 4c 30 10 81 51 16 b3 be",
+            self.server_isn_41x,
+            self.client_isn_41x,
+        )
+
+    def test_4_1_3(self):
+        self.check(
+            """
+            45 e0 00 87 36 a1 40 00 ff 06 65 9f 0a 0b 0c 0d
+            ac 1b 1c 1d e9 d7 00 b3 fb fb ab 5b 11 c1 42 62
+            c0 18 01 04 a1 62 00 00 01 01 08 0a 00 15 5a c1
+            84 a5 0b eb 1d 10 3d 54 70 64 cf 99 8c c6 c3 15
+            c2 c2 e2 bf ff ff ff ff ff ff ff ff ff ff ff ff
+            ff ff ff ff 00 43 01 04 da bf 00 b4 0a 0b 0c 0d
+            26 02 06 01 04 00 01 00 01 02 02 80 00 02 02 02
+            00 02 02 42 00 02 06 41 04 00 00 da bf 02 08 40
+            06 00 64 00 01 01 00
+            """,
+            "d2 e5 9c 65 ff c7 b1 a3 93 47 65 64 63 b7 0e dc 24 a1 3d 71",
+            "70 64 cf 99 8c c6 c3 15 c2 c2 e2 bf",
+            self.client_isn_41x,
+            self.server_isn_41x,
+        )
+
+    def test_4_1_4(self):
+        self.check(
+            """
+            45 e0 00 87 1f a9 40 00 ff 06 7c 97 ac 1b 1c 1d
+            0a 0b 0c 0d 00 b3 e9 d7 11 c1 42 62 fb fb ab 9e
+            c0 18 01 00 40 0c 00 00 01 01 08 0a 84 a5 0b f5
+            00 15 5a c1 1d 10 54 3d a6 3f 0e cb bb 2e 63 5c
+            95 4d ea c7 ff ff ff ff ff ff ff ff ff ff ff ff
+            ff ff ff ff 00 43 01 04 da c0 00 b4 ac 1b 1c 1d
+            26 02 06 01 04 00 01 00 01 02 02 80 00 02 02 02
+            00 02 02 42 00 02 06 41 04 00 00 da c0 02 08 40
+            06 00 64 00 01 01 00
+            """,
+            "d9 e2 17 e4 83 4a 80 ca 2f 3f d8 de 2e 41 b8 e6 79 7f ea 96",
+            "a6 3f 0e cb bb 2e 63 5c 95 4d ea c7",
+            self.server_isn_41x,
+            self.client_isn_41x,
+        )
+
+    def test_4_2_1(self):
+        self.check(
+            """
+            45 e0 00 4c 53 99 40 00 ff 06 48 e2 0a 0b 0c 0d
+            ac 1b 1c 1d ff 12 00 b3 cb 0e fb ee 00 00 00 00
+            e0 02 ff ff 54 1f 00 00 02 04 05 b4 01 03 03 08
+            04 02 08 0a 00 02 4c ce 00 00 00 00 1d 10 3d 54
+            80 af 3c fe b8 53 68 93 7b 8f 9e c2
+            """,
+            "30 ea a1 56 0c f0 be 57 da b5 c0 45 22 9f b1 0a 42 3c d7 ea",
+            "80 af 3c fe b8 53 68 93 7b 8f 9e c2",
+            self.client_isn_42x,
+            0,
+            include_options=False,
+        )
+
+    def test_4_2_2(self):
+        self.check(
+            """
+            45 e0 00 4c 32 84 40 00 ff 06 69 f7 ac 1b 1c 1d
+            0a 0b 0c 0d 00 b3 ff 12 ac d5 b5 e1 cb 0e fb ef
+            e0 12 ff ff 38 8e 00 00 02 04 05 b4 01 03 03 08
+            04 02 08 0a 57 67 72 f3 00 02 4c ce 1d 10 54 3d
+            09 30 6f 9a ce a6 3a 8c 68 cb 9a 70
+            """,
+            "b5 b2 89 6b b3 66 4e 81 76 b0 ed c6 e7 99 52 41 01 a8 30 7f",
+            "09 30 6f 9a ce a6 3a 8c 68 cb 9a 70",
+            self.server_isn_42x,
+            self.client_isn_42x,
+            include_options=False,
+        )
+
+    def test_4_2_3(self):
+        self.check(
+            """
+            45 e0 00 87 a8 f5 40 00 ff 06 f3 4a 0a 0b 0c 0d
+            ac 1b 1c 1d ff 12 00 b3 cb 0e fb ef ac d5 b5 e2
+            c0 18 01 04 6c 45 00 00 01 01 08 0a 00 02 4c ce
+            57 67 72 f3 1d 10 3d 54 71 06 08 cc 69 6c 03 a2
+            71 c9 3a a5 ff ff ff ff ff ff ff ff ff ff ff ff
+            ff ff ff ff 00 43 01 04 da bf 00 b4 0a 0b 0c 0d
+            26 02 06 01 04 00 01 00 01 02 02 80 00 02 02 02
+            00 02 02 42 00 02 06 41 04 00 00 da bf 02 08 40
+            06 00 64 00 01 01 00
+            """,
+            "f3 db 17 93 d7 91 0e cd 80 6c 34 f1 55 ea 1f 00 34 59 53 e3",
+            "71 06 08 cc 69 6c 03 a2 71 c9 3a a5",
+            self.client_isn_42x,
+            self.server_isn_42x,
+            include_options=False,
+        )
+
+    def test_4_2_4(self):
+        self.check(
+            """
+            45 e0 00 87 54 37 40 00 ff 06 48 09 ac 1b 1c 1d
+            0a 0b 0c 0d 00 b3 ff 12 ac d5 b5 e2 cb 0e fc 32
+            c0 18 01 00 46 b6 00 00 01 01 08 0a 57 67 72 f3
+            00 02 4c ce 1d 10 54 3d 97 76 6e 48 ac 26 2d e9
+            ae 61 b4 f9 ff ff ff ff ff ff ff ff ff ff ff ff
+            ff ff ff ff 00 43 01 04 da c0 00 b4 ac 1b 1c 1d
+            26 02 06 01 04 00 01 00 01 02 02 80 00 02 02 02
+            00 02 02 42 00 02 06 41 04 00 00 da c0 02 08 40
+            06 00 64 00 01 01 00
+            """,
+            "b5 b2 89 6b b3 66 4e 81 76 b0 ed c6 e7 99 52 41 01 a8 30 7f",
+            "97 76 6e 48 ac 26 2d e9 ae 61 b4 f9",
+            self.server_isn_42x,
+            self.client_isn_42x,
+            include_options=False,
+        )
+
+    def test_5_1_1(self):
+        self.check(
+            """
+            45 e0 00 4c 7b 9f 40 00 ff 06 20 dc 0a 0b 0c 0d
+            ac 1b 1c 1d c4 fa 00 b3 78 7a 1d df 00 00 00 00
+            e0 02 ff ff 5a 0f 00 00 02 04 05 b4 01 03 03 08
+            04 02 08 0a 00 01 7e d0 00 00 00 00 1d 10 3d 54
+            e4 77 e9 9c 80 40 76 54 98 e5 50 91
+            """,
+            "f5 b8 b3 d5 f3 4f db b6 eb 8d 4a b9 66 0e 60 e3",
+            "e4 77 e9 9c 80 40 76 54 98 e5 50 91",
+            0x787A1DDF,
+            0,
+            include_options=True,
+            alg_name="AES-128-CMAC-96",
+        )
+
+    def test_6_1_1(self):
+        self.check(
+            """
+            6e 08 91 dc 00 38 06 40 fd 00 00 00 00 00 00 00
+            00 00 00 00 00 00 00 01 fd 00 00 00 00 00 00 00
+            00 00 00 00 00 00 00 02 f7 e4 00 b3 17 6a 83 3f
+            00 00 00 00 e0 02 ff ff 47 21 00 00 02 04 05 a0
+            01 03 03 08 04 02 08 0a 00 41 d0 87 00 00 00 00
+            1d 10 3d 54 90 33 ec 3d 73 34 b6 4c 5e dd 03 9f
+            """,
+            "62 5e c0 9d 57 58 36 ed c9 b6 42 84 18 bb f0 69 89 a3 61 bb",
+            "90 33 ec 3d 73 34 b6 4c 5e dd 03 9f",
+            self.client_isn_61x,
+            0,
+            include_options=True,
+        )
+
+    def test_6_1_2(self):
+        self.check(
+            """
+            6e 01 00 9e 00 38 06 40 fd 00 00 00 00 00 00 00
+            00 00 00 00 00 00 00 02 fd 00 00 00 00 00 00 00
+            00 00 00 00 00 00 00 01 00 b3 f7 e4 3f 51 99 4b
+            17 6a 83 40 e0 12 ff ff bf ec 00 00 02 04 05 a0
+            01 03 03 08 04 02 08 0a bd 33 12 9b 00 41 d0 87
+            1d 10 54 3d f1 cb a3 46 c3 52 61 63 f7 1f 1f 55
+            """,
+            "e4 a3 7a da 2a 0a fc a8 71 14 34 91 3f e1 38 c7 71 eb cb 4a",
+            "f1 cb a3 46 c3 52 61 63 f7 1f 1f 55",
+            self.server_isn_61x,
+            self.client_isn_61x,
+            include_options=True,
+        )
+
+    def test_6_2_2(self):
+        self.check(
+            """
+            6e 0a 7e 1f 00 38 06 40 fd 00 00 00 00 00 00 00
+            00 00 00 00 00 00 00 02 fd 00 00 00 00 00 00 00
+            00 00 00 00 00 00 00 01 00 b3 c6 cd eb a3 73 4d
+            02 0c 1e 6a e0 12 ff ff 77 4d 00 00 02 04 05 a0
+            01 03 03 08 04 02 08 0a 5e c9 9b 70 00 9d b9 5b
+            1d 10 54 3d 3c 54 6b ad 97 43 f1 2d f8 b8 01 0d
+            """,
+            "40 51 08 94 7f 99 65 75 e7 bd bc 26 d4 02 16 a2 c7 fa 91 bd",
+            "3c 54 6b ad 97 43 f1 2d f8 b8 01 0d",
+            self.server_isn_62x,
+            self.client_isn_62x,
+            include_options=False,
+        )
+
+    def test_6_2_4(self):
+        self.check(
+            """
+            6e 0a 7e 1f 00 73 06 40 fd 00 00 00 00 00 00 00
+            00 00 00 00 00 00 00 02 fd 00 00 00 00 00 00 00
+            00 00 00 00 00 00 00 01 00 b3 c6 cd eb a3 73 4e
+            02 0c 1e ad c0 18 01 00 71 6a 00 00 01 01 08 0a
+            5e c9 9b 7a 00 9d b9 65 1d 10 54 3d 55 9a 81 94
+            45 b4 fd e9 8d 9e 13 17 ff ff ff ff ff ff ff ff
+            ff ff ff ff ff ff ff ff 00 43 01 04 fd e8 00 b4
+            01 01 01 7a 26 02 06 01 04 00 01 00 01 02 02 80
+            00 02 02 02 00 02 02 42 00 02 06 41 04 00 00 fd
+            e8 02 08 40 06 00 64 00 01 01 00
+            """,
+            "40 51 08 94 7f 99 65 75 e7 bd bc 26 d4 02 16 a2 c7 fa 91 bd",
+            "55 9a 81 94 45 b4 fd e9 8d 9e 13 17",
+            self.server_isn_62x,
+            self.client_isn_62x,
+            include_options=False,
+        )
+
+    server_isn_71x = 0xA6744ECB
+    client_isn_71x = 0x193CCCEC
+
+    def test_7_1_2(self):
+        self.check(
+            """
+            6e 06 15 20 00 38 06 40 fd 00 00 00 00 00 00 00
+            00 00 00 00 00 00 00 02 fd 00 00 00 00 00 00 00
+            00 00 00 00 00 00 00 01 00 b3 f8 5a a6 74 4e cb
+            19 3c cc ed e0 12 ff ff ea bb 00 00 02 04 05 a0
+            01 03 03 08 04 02 08 0a 71 da ab c8 13 e4 ab 99
+            1d 10 54 3d dc 28 43 a8 4e 78 a6 bc fd c5 ed 80
+            """,
+            "cf 1b 1e 22 5e 06 a6 36 16 76 4a 06 7b 46 f4 b1",
+            "dc 28 43 a8 4e 78 a6 bc fd c5 ed 80",
+            self.server_isn_71x,
+            self.client_isn_71x,
+            alg_name="AES-128-CMAC-96",
+            include_options=True,
+        )
+
+    def test_7_1_4(self):
+        self.check(
+            """
+            6e 06 15 20 00 73 06 40 fd 00 00 00 00 00 00 00
+            00 00 00 00 00 00 00 02 fd 00 00 00 00 00 00 00
+            00 00 00 00 00 00 00 01 00 b3 f8 5a a6 74 4e cc
+            19 3c cd 30 c0 18 01 00 52 f4 00 00 01 01 08 0a
+            71 da ab d3 13 e4 ab a3 1d 10 54 3d c1 06 9b 7d
+            fd 3d 69 3a 6d f3 f2 89 ff ff ff ff ff ff ff ff
+            ff ff ff ff ff ff ff ff 00 43 01 04 fd e8 00 b4
+            01 01 01 7a 26 02 06 01 04 00 01 00 01 02 02 80
+            00 02 02 02 00 02 02 42 00 02 06 41 04 00 00 fd
+            e8 02 08 40 06 00 64 00 01 01 00
+            """,
+            "cf 1b 1e 22 5e 06 a6 36 16 76 4a 06 7b 46 f4 b1",
+            "c1 06 9b 7d fd 3d 69 3a 6d f3 f2 89",
+            self.server_isn_71x,
+            self.client_isn_71x,
+            alg_name="AES-128-CMAC-96",
+            include_options=True,
+        )
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/validator.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/validator.py
new file mode 100644
index 000000000000..9becd39dc31e
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/validator.py
@@ -0,0 +1,127 @@
+# SPDX-License-Identifier: GPL-2.0
+import logging
+import typing
+from dataclasses import dataclass
+
+from scapy.layers.inet import TCP
+from scapy.packet import Packet
+
+from . import scapy_tcp_authopt
+from .scapy_conntrack import TCPConnectionTracker, get_packet_tcp_connection_key
+from .scapy_utils import scapy_tcp_get_authopt_val
+
+logger = logging.getLogger(__name__)
+
+
+@dataclass
+class TcpAuthValidatorKey:
+    """Representation of a TCP Authentication Option key for the validator
+
+    The matching rules are independent.
+    """
+
+    key: bytes
+    alg_name: str
+    include_options: bool = True
+    keyid: typing.Optional[int] = None
+    sport: typing.Optional[int] = None
+    dport: typing.Optional[int] = None
+
+    def match_packet(self, p: Packet) -> bool:
+        """Determine if this key matches a specific packet"""
+        if not TCP in p:
+            return False
+        authopt = scapy_tcp_get_authopt_val(p[TCP])
+        if authopt is None:
+            return False
+        if self.keyid is not None and authopt.keyid != self.keyid:
+            return False
+        if self.sport is not None and p[TCP].sport != self.sport:
+            return False
+        if self.dport is not None and p[TCP].dport != self.dport:
+            return False
+        return True
+
+    def get_alg_imp(self):
+        return scapy_tcp_authopt.get_alg(self.alg_name)
+
+
+class TcpAuthValidator:
+    """Validate TCP Authentication Option signatures inside a capture
+
+    This can track multiple connections, determine their initial sequence numbers
+    and verify their signatues independently.
+
+    Keys are provided as a collection of `.TcpAuthValidatorKey`
+    """
+
+    keys: typing.List[TcpAuthValidatorKey]
+    tracker: TCPConnectionTracker
+    any_incomplete: bool = False
+    any_unsigned: bool = False
+    any_fail: bool = False
+
+    def __init__(self, keys=None):
+        self.keys = keys or []
+        self.tracker = TCPConnectionTracker()
+        self.conn_dict = {}
+
+    def get_key_for_packet(self, p):
+        for k in self.keys:
+            if k.match_packet(p):
+                return k
+        return None
+
+    def handle_packet(self, p: Packet):
+        if not TCP in p:
+            return
+        self.tracker.handle_packet(p)
+        authopt = scapy_tcp_get_authopt_val(p[TCP])
+        if not authopt:
+            self.any_unsigned = True
+            logger.debug("skip packet without tcp authopt: %r", p)
+            return
+        key = self.get_key_for_packet(p)
+        if not key:
+            self.any_unsigned = True
+            logger.debug("skip packet not matching any known keys: %r", p)
+            return
+        tcp_track_key = get_packet_tcp_connection_key(p)
+        conn = self.tracker.get(tcp_track_key)
+
+        if not conn.found_syn:
+            logger.warning("missing SYN for %s", p)
+            self.any_incomplete = True
+            return
+        if not conn.found_synack and not p[TCP].flags.S:
+            logger.warning("missing SYNACK for %s", p)
+            self.any_incomplete = True
+            return
+
+        alg = key.get_alg_imp()
+        context_bytes = scapy_tcp_authopt.build_context_from_packet(
+            p, conn.sisn or 0, conn.disn or 0
+        )
+        traffic_key = alg.kdf(key.key, context_bytes)
+        message_bytes = scapy_tcp_authopt.build_message_from_packet(
+            p, include_options=key.include_options
+        )
+        computed_mac = alg.mac(traffic_key, message_bytes)
+        captured_mac = authopt.mac
+        if computed_mac == captured_mac:
+            logger.debug("ok - mac %s", computed_mac.hex())
+        else:
+            self.any_fail = True
+            logger.error(
+                "not ok - captured %s computed %s",
+                captured_mac.hex(),
+                computed_mac.hex(),
+            )
+
+    def raise_errors(self, allow_unsigned=False, allow_incomplete=False):
+        if self.any_fail:
+            raise Exception("Found failed signatures")
+        if self.any_incomplete and not allow_incomplete:
+            raise Exception("Incomplete capture missing SYN/ACK")
+        if self.any_unsigned and not allow_unsigned:
+            raise Exception("Found unsigned packets")
-- 
2.25.1

