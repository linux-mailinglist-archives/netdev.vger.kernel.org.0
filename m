Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC70C3F6B30
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbhHXVgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237149AbhHXVga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:36:30 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201DBC0613D9;
        Tue, 24 Aug 2021 14:35:45 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id x11so47312827ejv.0;
        Tue, 24 Aug 2021 14:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IeHOYpgSN/r/aILc2O4sIwLLNyeKU8mTdl0ifnTRw7U=;
        b=Li4OJISU0JyyBoJHCIThLFde9YoZzWVNCr9KdeIZhO2qqRKVYl/UQTexcmBwisKpQR
         0VIxxnnuCYmAiZ6OegwioFtZ2fTd2uiV5RktyB4+Ilr8fkgUj0wRzcGAJmySaDM6qQFB
         rFa1TUWCoKePQ+jqX9hCdOQ4esmyluTHquE7uF85YR/JaAVh9aKQkxD13px5sNva8uLe
         6fBouoXgwBbIv8ZMfz5zGHGLTqmy3jtT2gsTLlM9amKRvj7v2uz3Y+tI6IFqkmhenh0l
         7BqAytEvTQ6rm4DeQf7Uk/o1Z4TF1JteN15XJq33ZAYXHybxdubsqdlkPR1XxHJ1GeGA
         nRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IeHOYpgSN/r/aILc2O4sIwLLNyeKU8mTdl0ifnTRw7U=;
        b=f5Xc3uEQBsF5VA/DKIC00FkUQrG1ADOyJThO9OsFyWMQnAQmsNyzo1HI2228kn518Y
         MKBhiUjcraaW+H8ESefOnUhZybbfBXY+XksOAAaGhFHVHL24TRfNeoRS0aRccR7Wh+79
         pLWN0BnJK/Hfc3EZ13yuzcuo1/stq+WYahFhjlEJKMK2IbGS+kKEolKUbqmvzQO3nUUS
         f0j1JA6JCywzDfFksW/U4QGNlCAFpgqslPLkUlFu3MdvnNpn0mwzE+Srs/U5m6sCLOAD
         G4Snlxi27rZgfDpMDjPSBhilla7uqN0l98jvV5VR0M7qupw+v9w+DmpeBodwaAmSTNxI
         3ZgQ==
X-Gm-Message-State: AOAM531cHH7piDGD9ZP3BRR6C7WOd/lRnFwUgyLln7AZ9/HyS0zzpw2b
        clVzm+vf/5WZApTjRPYlLxo=
X-Google-Smtp-Source: ABdhPJxlNPyQMAA4qbKzhdotUtgCi9DBkjMaisGznnxM/9cuPq7r3Nyaz0gfsGMukVtsRj3VW8EvRA==
X-Received: by 2002:a17:906:4346:: with SMTP id z6mr42161581ejm.403.1629840943232;
        Tue, 24 Aug 2021 14:35:43 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ed0a:7326:fbac:b4c])
        by smtp.gmail.com with ESMTPSA id d16sm12348357edu.8.2021.08.24.14.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:35:42 -0700 (PDT)
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
Subject: [RFCv3 10/15] selftests: tcp_authopt: Capture and verify packets
Date:   Wed, 25 Aug 2021 00:34:43 +0300
Message-Id: <11486ba2d081cb733b8c1e34acd5bd7f26932209.1629840814.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1629840814.git.cdleonard@gmail.com>
References: <cover.1629840814.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tools like tcpdump and wireshark can parse the TCP Authentication Option
but there is not yet support to verify correct signatures.

This patch implements TCP-AO signature verification using scapy and the
python cryptography package and applies it to captures of linux traffic
in multiple scenarios (ipv4, ipv6 etc).

The python code is verified itself with a subset of IETF test vectors
from this page:
https://datatracker.ietf.org/doc/html/draft-touch-tcpm-ao-test-vectors-02

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 .../full_tcp_sniff_session.py                 |  53 +++
 .../tcp_authopt_test/tcp_authopt_alg.py       | 276 ++++++++++++++
 .../tcp_authopt_test/test_vectors.py          | 359 ++++++++++++++++++
 .../tcp_authopt_test/test_verify_capture.py   | 123 ++++++
 .../tcp_authopt/tcp_authopt_test/validator.py | 158 ++++++++
 5 files changed, 969 insertions(+)
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/full_tcp_sniff_session.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/tcp_authopt_alg.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vectors.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_verify_capture.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/validator.py

diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/full_tcp_sniff_session.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/full_tcp_sniff_session.py
new file mode 100644
index 000000000000..d709e83c8700
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/full_tcp_sniff_session.py
@@ -0,0 +1,53 @@
+# SPDX-License-Identifier: GPL-2.0
+import scapy.sessions
+from scapy.layers.inet import TCP
+
+from .utils import SimpleWaitEvent
+
+
+class FullTCPSniffSession(scapy.sessions.DefaultSession):
+    """Implementation of a scapy sniff session that can wait for a full TCP capture
+
+    Allows another thread to wait for a complete FIN handshake without polling or sleep.
+    """
+
+    found_syn = False
+    found_synack = False
+    found_fin = False
+    found_client_fin = False
+    found_server_fin = False
+
+    def __init__(self, server_port=None, **kw):
+        super().__init__(**kw)
+        self.server_port = server_port
+        self._close_event = SimpleWaitEvent()
+
+    def on_packet_received(self, p):
+        super().on_packet_received(p)
+        if not p or not TCP in p:
+            return
+        th = p[TCP]
+        # logger.debug("sport=%d dport=%d flags=%s", th.sport, th.dport, th.flags)
+        if th.flags.S and not th.flags.A:
+            if th.dport == self.server_port or self.server_port is None:
+                self.found_syn = True
+        if th.flags.S and th.flags.A:
+            if th.sport == self.server_port or self.server_port is None:
+                self.found_synack = True
+        if th.flags.F:
+            if self.server_port is None:
+                self.found_fin = True
+                self._close_event.set()
+            elif self.server_port == th.dport:
+                self.found_client_fin = True
+                self.found_fin = True
+                if self.found_server_fin and self.found_client_fin:
+                    self._close_event.set()
+            elif self.server_port == th.sport:
+                self.found_server_fin = True
+                self.found_fin = True
+                if self.found_server_fin and self.found_client_fin:
+                    self._close_event.set()
+
+    def wait_close(self, timeout=10):
+        self._close_event.wait(timeout=timeout)
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/tcp_authopt_alg.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/tcp_authopt_alg.py
new file mode 100644
index 000000000000..093cb4716184
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/tcp_authopt_alg.py
@@ -0,0 +1,276 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Packet-processing utilities implementing RFC5925 and RFC2926"""
+
+import logging
+from dataclasses import dataclass
+from ipaddress import IPv4Address, IPv6Address
+from scapy.layers.inet import IP, TCP
+from scapy.layers.inet6 import IPv6
+from scapy.packet import Packet
+import socket
+import struct
+import typing
+import hmac
+
+logger = logging.getLogger(__name__)
+
+
+def kdf_sha1(master_key: bytes, context: bytes) -> bytes:
+    """RFC5926 section 3.1.1.1"""
+    input = b"\x01" + b"TCP-AO" + context + b"\x00\xa0"
+    return hmac.digest(master_key, input, "SHA1")
+
+
+def mac_sha1(traffic_key: bytes, message: bytes) -> bytes:
+    """RFC5926 section 3.2.1"""
+    return hmac.digest(traffic_key, message, "SHA1")[:12]
+
+
+def cmac_aes_digest(key: bytes, msg: bytes) -> bytes:
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
+def kdf_cmac_aes(master_key: bytes, context: bytes) -> bytes:
+    if len(master_key) == 16:
+        key = master_key
+    else:
+        key = cmac_aes_digest(b"\x00" * 16, master_key)
+    return cmac_aes_digest(key, b"\x01" + b"TCP-AO" + context + b"\x00\x80")
+
+
+def mac_cmac_aes(traffic_key: bytes, message: bytes) -> bytes:
+    return cmac_aes_digest(traffic_key, message)[:12]
+
+
+class TcpAuthOptAlg:
+    def kdf(self, master_key: bytes, context: bytes) -> bytes:
+        raise NotImplementedError()
+
+    def mac(self, traffic_key: bytes, message: bytes) -> bytes:
+        raise NotImplementedError()
+
+
+class TcpAuthOptAlg_HMAC_SHA1(TcpAuthOptAlg):
+    def kdf(self, master_key: bytes, context: bytes) -> bytes:
+        return kdf_sha1(master_key, context)
+
+    def mac(self, traffic_key: bytes, message: bytes) -> bytes:
+        return mac_sha1(traffic_key, message)
+
+
+class TcpAuthOptAlg_CMAC_AES(TcpAuthOptAlg):
+    def kdf(self, master_key: bytes, context: bytes) -> bytes:
+        return kdf_cmac_aes(master_key, context)
+
+    def mac(self, traffic_key: bytes, message: bytes) -> bytes:
+        return mac_cmac_aes(traffic_key, message)
+
+
+def get_alg(name) -> TcpAuthOptAlg:
+    if name.upper() == "HMAC-SHA-1-96":
+        return TcpAuthOptAlg_HMAC_SHA1()
+    elif name.upper() == "AES-128-CMAC-96":
+        return TcpAuthOptAlg_CMAC_AES()
+    else:
+        raise ValueError(f"Bad TCP AuthOpt algorithms {name}")
+
+
+IPvXAddress = typing.Union[IPv4Address, IPv6Address]
+
+
+def get_scapy_ipvx_src(p: Packet) -> IPvXAddress:
+    if IP in p:
+        return IPv4Address(p[IP].src)
+    elif IPv6 in p:
+        return IPv6Address(p[IPv6].src)
+    else:
+        raise Exception("Neither IP nor IPv6 found on packet")
+
+
+def get_scapy_ipvx_dst(p: Packet) -> IPvXAddress:
+    if IP in p:
+        return IPv4Address(p[IP].dst)
+    elif IPv6 in p:
+        return IPv6Address(p[IPv6].dst)
+    else:
+        raise Exception("Neither IP nor IPv6 found on packet")
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
+def build_context_from_scapy(p: Packet, src_isn: int, dst_isn: int) -> bytes:
+    """Build context based on a scapy Packet and src/dst initial-sequence numbers"""
+    return build_context(
+        get_scapy_ipvx_src(p),
+        get_scapy_ipvx_dst(p),
+        p[TCP].sport,
+        p[TCP].dport,
+        src_isn,
+        dst_isn,
+    )
+
+
+def build_context_from_scapy_syn(p: Packet) -> bytes:
+    """Build context for a scapy SYN packet"""
+    return build_context_from_scapy(p, p[TCP].seq, 0)
+
+
+def build_context_from_scapy_synack(p: Packet) -> bytes:
+    """Build context for a scapy SYN/ACK packet"""
+    return build_context_from_scapy(p, p[TCP].seq, p[TCP].ack - 1)
+
+
+def build_message_from_scapy(p: Packet, include_options=True, sne=0) -> bytearray:
+    """Build message bytes as described by RFC5925 section 5.1"""
+    result = bytearray()
+    result += struct.pack("!I", sne)
+    # ip pseudo-header:
+    if IP in p:
+        result += struct.pack(
+            "!4s4sHH",
+            IPv4Address(p[IP].src).packed,
+            IPv4Address(p[IP].dst).packed,
+            socket.IPPROTO_TCP,
+            p[TCP].dataofs * 4 + len(p[TCP].payload),
+        )
+        assert p[TCP].dataofs * 4 + len(p[TCP].payload) + p[IP].ihl * 4 == p[IP].len
+    elif IPv6 in p:
+        result += struct.pack(
+            "!16s16sII",
+            IPv6Address(p[IPv6].src).packed,
+            IPv6Address(p[IPv6].dst).packed,
+            p[IPv6].plen,
+            socket.IPPROTO_TCP,
+        )
+        assert p[TCP].dataofs * 4 + len(p[TCP].payload) == p[IPv6].plen
+    else:
+        raise Exception("Neither IP nor IPv6 found on packet")
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
+    tcphdr_optend = p[TCP].dataofs * 4
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
+        if optnum == 29:
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
+@dataclass
+class TCPAuthContext:
+    """Context used to TCP Authentication option as defined in RFC5925 5.2"""
+
+    saddr: IPvXAddress = None
+    daddr: IPvXAddress = None
+    sport: int = 0
+    dport: int = 0
+    sisn: int = 0
+    disn: int = 0
+
+    def pack(self, syn=False, rev=False) -> bytes:
+        if rev:
+            return build_context(
+                self.daddr,
+                self.saddr,
+                self.dport,
+                self.sport,
+                self.disn if not syn else 0,
+                self.sisn,
+            )
+        else:
+            return build_context(
+                self.saddr,
+                self.daddr,
+                self.sport,
+                self.dport,
+                self.sisn,
+                self.disn if not syn else 0,
+            )
+
+    def rev(self) -> "TCPAuthContext":
+        """Reverse"""
+        return TCPAuthContext(
+            saddr=self.daddr,
+            daddr=self.saddr,
+            sport=self.dport,
+            dport=self.sport,
+            sisn=self.disn,
+            disn=self.sisn,
+        )
+
+    def init_from_syn_packet(self, p):
+        """Init from a SYN packet (and set dist to zero)"""
+        assert p[TCP].flags.S and not p[TCP].flags.A and p[TCP].ack == 0
+        self.saddr = get_scapy_ipvx_src(p)
+        self.daddr = get_scapy_ipvx_dst(p)
+        self.sport = p[TCP].sport
+        self.dport = p[TCP].dport
+        self.sisn = p[TCP].seq
+        self.disn = 0
+
+    def update_from_synack_packet(self, p):
+        """Update disn and check everything else matches"""
+        assert p[TCP].flags.S and p[TCP].flags.A
+        assert self.saddr == get_scapy_ipvx_dst(p)
+        assert self.daddr == get_scapy_ipvx_src(p)
+        assert self.sport == p[TCP].dport
+        assert self.dport == p[TCP].sport
+        assert self.sisn == p[TCP].ack - 1
+        self.disn = p[TCP].seq
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vectors.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vectors.py
new file mode 100644
index 000000000000..f622bcf0dcbc
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_vectors.py
@@ -0,0 +1,359 @@
+# SPDX-License-Identifier: GPL-2.0
+import logging
+from ipaddress import IPv4Address, IPv6Address
+from scapy.layers.inet import IP, TCP
+from scapy.layers.inet6 import IPv6
+from .tcp_authopt_alg import get_alg, build_context_from_scapy, build_message_from_scapy
+from .utils import scapy_tcp_get_authopt_val, tcphdr_authopt
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
+        context_bytes = build_context_from_scapy(p, src_isn, dst_isn)
+        traffic_key = alg.kdf(self.master_key, context_bytes)
+        assert traffic_key.hex(" ") == traffic_key_hex
+
+        # check mac
+        message_bytes = build_message_from_scapy(
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
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_verify_capture.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_verify_capture.py
new file mode 100644
index 000000000000..1bc0f05197b8
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_verify_capture.py
@@ -0,0 +1,123 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Capture packets with TCP-AO and verify signatures"""
+
+import logging
+import os
+import socket
+
+import pytest
+
+from . import linux_tcp_authopt, tcp_authopt_alg
+from .full_tcp_sniff_session import FullTCPSniffSession
+from .linux_tcp_authopt import (
+    set_tcp_authopt_key,
+    tcp_authopt_key,
+)
+from .server import SimpleServerThread
+from .utils import (
+    DEFAULT_TCP_SERVER_PORT,
+    AsyncSnifferContext,
+    check_socket_echo,
+    create_listen_socket,
+    nstat_json,
+)
+from .validator import TcpAuthValidator, TcpAuthValidatorKey
+from .conftest import skipif_missing_tcp_authopt
+
+logger = logging.getLogger(__name__)
+pytestmark = skipif_missing_tcp_authopt
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
+def get_alg_id(alg_name) -> int:
+    if alg_name == "HMAC-SHA-1-96":
+        return linux_tcp_authopt.TCP_AUTHOPT_ALG_HMAC_SHA_1_96
+    elif alg_name == "AES-128-CMAC-96":
+        return linux_tcp_authopt.TCP_AUTHOPT_ALG_AES_128_CMAC_96
+    else:
+        raise ValueError()
+
+
+@skipif_cant_capture
+@pytest.mark.parametrize(
+    "address_family,alg_name,include_options",
+    [
+        (socket.AF_INET, "HMAC-SHA-1-96", True),
+        (socket.AF_INET, "AES-128-CMAC-96", True),
+        (socket.AF_INET, "AES-128-CMAC-96", False),
+        (socket.AF_INET6, "HMAC-SHA-1-96", True),
+        (socket.AF_INET6, "HMAC-SHA-1-96", False),
+        (socket.AF_INET6, "AES-128-CMAC-96", True),
+    ],
+)
+def test_verify_capture(exit_stack, address_family, alg_name, include_options):
+    master_key = b"testvector"
+    alg_id = get_alg_id(alg_name)
+
+    session = FullTCPSniffSession(server_port=DEFAULT_TCP_SERVER_PORT)
+    sniffer = exit_stack.enter_context(
+        AsyncSnifferContext(
+            filter=f"tcp port {DEFAULT_TCP_SERVER_PORT}",
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
+    set_tcp_authopt_key(
+        listen_socket,
+        tcp_authopt_key(alg=alg_id, key=master_key, include_options=include_options),
+    )
+    set_tcp_authopt_key(
+        client_socket,
+        tcp_authopt_key(alg=alg_id, key=master_key, include_options=include_options),
+    )
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
+        for _ in range(5):
+            check_socket_echo(client_socket)
+    except socket.timeout:
+        logger.warning("socket timeout", exc_info=True)
+        pass
+    client_socket.close()
+    session.wait_close()
+    sniffer.stop()
+
+    logger.info("capture: %r", sniffer.results)
+    for p in sniffer.results:
+        validator.handle_packet(p)
+
+    assert not validator.any_fail
+    assert not validator.any_unsigned
+    # Fails because of duplicate packets:
+    # assert not validator.any_incomplete
+    new_nstat = nstat_json()
+    assert (
+        0
+        == new_nstat["kernel"]["TcpExtTCPAuthOptFailure"]
+        - old_nstat["kernel"]["TcpExtTCPAuthOptFailure"]
+    )
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/validator.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/validator.py
new file mode 100644
index 000000000000..5f0e83421af5
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/validator.py
@@ -0,0 +1,158 @@
+# SPDX-License-Identifier: GPL-2.0
+from tcp_authopt_test.utils import scapy_tcp_get_authopt_val
+import typing
+import logging
+
+from dataclasses import dataclass
+from scapy.packet import Packet
+from scapy.layers.inet import TCP
+from . import tcp_authopt_alg
+from .tcp_authopt_alg import IPvXAddress, TCPAuthContext
+from .tcp_authopt_alg import get_scapy_ipvx_src
+from .tcp_authopt_alg import get_scapy_ipvx_dst
+
+logger = logging.getLogger(__name__)
+
+
+@dataclass(frozen=True)
+class TCPSocketPair:
+    """TCP connection identifier"""
+
+    saddr: IPvXAddress = None
+    daddr: IPvXAddress = None
+    sport: int = 0
+    dport: int = 0
+
+    def rev(self) -> "TCPSocketPair":
+        return TCPSocketPair(self.daddr, self.saddr, self.dport, self.sport)
+
+
+@dataclass
+class TcpAuthValidatorKey:
+    key: bytes
+    alg_name: str
+    include_options: bool = True
+    keyid: typing.Optional[int] = None
+    sport: typing.Optional[int] = None
+    dport: typing.Optional[int] = None
+
+    def match_packet(self, p: Packet):
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
+        return tcp_authopt_alg.get_alg(self.alg_name)
+
+
+def is_init_syn(p: Packet) -> bool:
+    return p[TCP].flags.S and not p[TCP].flags.A
+
+
+class TcpAuthValidator:
+    """Validate TCP auth sessions inside a capture"""
+
+    keys: typing.List[TcpAuthValidatorKey]
+    conn_dict: typing.Dict[TCPSocketPair, TCPAuthContext]
+    any_incomplete: bool = False
+    any_unsigned: bool = False
+    any_fail: bool = False
+
+    def __init__(self, keys=None):
+        self.keys = keys or []
+        self.conn_dict = {}
+
+    def get_key_for_packet(self, p):
+        for k in self.keys:
+            if k.match_packet(p):
+                return k
+        return None
+
+    def handle_packet(self, p: Packet):
+        if TCP not in p:
+            logger.debug("skip non-TCP packet")
+            return
+        key = self.get_key_for_packet(p)
+        if not key:
+            self.any_unsigned = True
+            logger.debug("skip packet not matching any known keys: %r", p)
+            return
+        authopt = scapy_tcp_get_authopt_val(p[TCP])
+        if not authopt:
+            self.any_unsigned = True
+            logger.debug("skip packet without tcp authopt: %r", p)
+            return
+        captured_mac = authopt.mac
+
+        saddr = get_scapy_ipvx_src(p)
+        daddr = get_scapy_ipvx_dst(p)
+
+        conn_key = TCPSocketPair(saddr, daddr, p[TCP].sport, p[TCP].dport)
+        if p[TCP].flags.S:
+            conn = self.conn_dict.get(conn_key, None)
+            if conn is not None:
+                logger.warning("overwrite %r", conn)
+                self.any_incomplete = True
+            conn = TCPAuthContext()
+            conn.saddr = saddr
+            conn.daddr = daddr
+            conn.sport = p[TCP].sport
+            conn.dport = p[TCP].dport
+            self.conn_dict[conn_key] = conn
+
+            if p[TCP].flags.A == False:
+                # SYN
+                conn.sisn = p[TCP].seq
+                conn.disn = 0
+                logger.info("Initialized for SYN: %r", conn)
+            else:
+                # SYN/ACK
+                conn.sisn = p[TCP].seq
+                conn.disn = p[TCP].ack - 1
+                logger.info("Initialized for SYNACK: %r", conn)
+
+                # Update opposite connection with dst_isn
+                rconn_key = conn_key.rev()
+                rconn = self.conn_dict.get(rconn_key, None)
+                if rconn is None:
+                    logger.warning("missing SYN for SYNACK: %s", rconn_key)
+                    self.any_incomplete = True
+                else:
+                    assert rconn.sisn == conn.disn
+                    assert rconn.disn == 0 or rconn.disn == conn.sisn
+                    rconn.disn = conn.sisn
+                    rconn.update_from_synack_packet(p)
+                    logger.info("Updated peer for SYNACK: %r", rconn)
+        else:
+            conn = self.conn_dict.get(conn_key, None)
+            if conn is None:
+                logger.warning("missing TCP syn for %r", conn_key)
+                self.any_incomplete = True
+                return
+        # logger.debug("conn %r found for packet %r", conn, p)
+
+        context_bytes = conn.pack(syn=is_init_syn(p))
+        alg = key.get_alg_imp()
+        traffic_key = alg.kdf(key.key, context_bytes)
+        message_bytes = tcp_authopt_alg.build_message_from_scapy(
+            p, include_options=key.include_options
+        )
+        computed_mac = alg.mac(traffic_key, message_bytes)
+        if computed_mac == captured_mac:
+            logger.debug("ok - mac %s", computed_mac.hex())
+        else:
+            self.any_fail = True
+            logger.error(
+                "not ok - captured %s computed %s",
+                captured_mac.hex(),
+                computed_mac.hex(),
+            )
-- 
2.25.1

