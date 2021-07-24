Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6573D48D6
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 19:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhGXQk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 12:40:57 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:40853 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhGXQk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 12:40:56 -0400
Received: from ubuntu.home (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id DBB48200F83A;
        Sat, 24 Jul 2021 19:21:25 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be DBB48200F83A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1627147286;
        bh=shUzBFwwERa/LYEDS7rLFIt6yEEfrl/PAsDjlwZGhVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qE+JqEcgMP+hUY0RusJVxgYrFrkrVfHv1IG2Ophk1LlVntPMDhXLAQqhdxKoiyRfY
         hLP3EVHU5lxZwgxqPLLalw7QNCMfNvgRZSnSWsvN90EB6/Abc7aQLTkItIUQwZKccI
         z9InXOgqtMcWbanVk3yVnjGFqYuhtcjUKGZxvdOU+ZUB+JaM24lkRKgprJC13R2TGG
         EmUMnhC8HmnD+kLK6aIvDjxp2ttRq3sfovm4FZlEj4jI4ukOwhQMu98SGnv6WxgUCi
         tO22NRXv2H2IK53yUis3rESjy+z9gO93TNujdZ1l4DYDVw4C21ktXV6Hy+QGxlJkiI
         azBXAgF8aaAtw==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, justin.iurman@uliege.be
Subject: [PATCH iproute2-next v2 3/3] IOAM man8
Date:   Sat, 24 Jul 2021 19:21:08 +0200
Message-Id: <20210724172108.26524-4-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210724172108.26524-1-justin.iurman@uliege.be>
References: <20210724172108.26524-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch provides man8 documentation for IOAM inside ip, ip-ioam and ip-route.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 man/man8/ip-ioam.8     | 72 ++++++++++++++++++++++++++++++++++++++++++
 man/man8/ip-route.8.in | 35 +++++++++++++++++++-
 man/man8/ip.8          |  7 +++-
 3 files changed, 112 insertions(+), 2 deletions(-)
 create mode 100644 man/man8/ip-ioam.8

diff --git a/man/man8/ip-ioam.8 b/man/man8/ip-ioam.8
new file mode 100644
index 00000000..1bdc0ece
--- /dev/null
+++ b/man/man8/ip-ioam.8
@@ -0,0 +1,72 @@
+.TH IP\-IOAM 8 "05 Jul 2021" "iproute2" "Linux"
+.SH "NAME"
+ip-ioam \- IPv6 In-situ OAM (IOAM)
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+.ti -8
+.B ip ioam
+.RI " { " COMMAND " | "
+.BR help " }"
+.sp
+.ti -8
+
+.ti -8
+.B ip ioam namespace show
+
+.ti -8
+.B ip ioam namespace add
+.I ID
+.BR " [ "
+.B data
+.I DATA32
+.BR "]"
+.BR " [ "
+.B wide
+.I DATA64
+.BR "]"
+
+.ti -8
+.B ip ioam namespace del
+.I ID
+
+.ti -8
+.B ip ioam schema show
+
+.ti -8
+.B ip ioam schema add
+.I ID DATA
+
+.ti -8
+.B ip ioam schema del
+.I ID
+
+.ti -8
+.B ip ioam namespace set
+.I ID
+.B schema
+.RI " { " ID " | "
+.BR none " }"
+
+.SH DESCRIPTION
+The \fBip ioam\fR command is used to configure IPv6 In-situ OAM (IOAM6)
+internal parameters, namely IOAM namespaces and schemas.
+.PP
+Those parameters also include the mapping between an IOAM namespace and an IOAM
+schema.
+
+.SH EXAMPLES
+.PP
+.SS Configure an IOAM namespace (ID = 1) with both data (32 bits) and wide data (64 bits)
+.nf
+# ip ioam namespace add 1 data 0xdeadbeef wide 0xcafec0caf00dc0de
+.PP
+.SS Link an existing IOAM schema (ID = 7) to an existing IOAM namespace (ID = 1)
+.nf
+# ip ioam namespace set 1 schema 7
+.SH SEE ALSO
+.br
+.BR ip-route (8)
+.SH AUTHOR
+Justin Iurman <justin.iurman@uliege.be>
diff --git a/man/man8/ip-route.8.in b/man/man8/ip-route.8.in
index 4b1947ab..e12ccf6b 100644
--- a/man/man8/ip-route.8.in
+++ b/man/man8/ip-route.8.in
@@ -190,7 +190,7 @@ throw " | " unreachable " | " prohibit " | " blackhole " | " nat " ]"
 .ti -8
 .IR ENCAP " := [ "
 .IR ENCAP_MPLS " | " ENCAP_IP " | " ENCAP_BPF " | "
-.IR ENCAP_SEG6 " | " ENCAP_SEG6LOCAL " ] "
+.IR ENCAP_SEG6 " | " ENCAP_SEG6LOCAL " | " ENCAP_IOAM6 " ] "
 
 .ti -8
 .IR ENCAP_MPLS " := "
@@ -243,6 +243,17 @@ throw " | " unreachable " | " prohibit " | " blackhole " | " nat " ]"
 .IR SEG6_ACTION_PARAM " ] [ "
 .BR count " ] "
 
+.ti -8
+.IR ENCAP_IOAM6 " := "
+.B ioam6
+.BR trace
+.BR type
+.IR IOAM6_TRACE_TYPE
+.BR ns
+.IR IOAM6_NAMESPACE
+.BR size
+.IR IOAM6_TRACE_SIZE
+
 .ti -8
 .IR ROUTE_GET_FLAGS " := "
 .BR " [ "
@@ -717,6 +728,9 @@ is a string specifying the supported encapsulation type. Namely:
 .sp
 .BI seg6local
 - local SRv6 segment processing
+.sp
+.BI ioam6
+- encapsulation type IPv6 IOAM
 
 .in -8
 .I ENCAPHDR
@@ -896,6 +910,20 @@ Additionally, encapsulate the matching packet within an outer IPv6 header
 followed by the specified SRH. The destination address of the outer IPv6
 header is set to the first segment of the new SRH. The source
 address is set as described in \fBip-sr\fR(8).
+.in -2
+
+.B ioam6
+.in +2
+.I IOAM6_TRACE_TYPE
+- List of IOAM data required in the trace, represented by a bitfield (24 bits).
+.sp
+
+.I IOAM6_NAMESPACE
+- Numerical value to represent an IOAM namespace. See \fBip-ioam\fR(8).
+.sp
+
+.I IOAM6_TRACE_SIZE
+- Size, in octets, of the pre-allocated trace data block.
 .in -4
 
 .in -8
@@ -1220,6 +1248,11 @@ ip -6 route add 2001:db8:1::/64 encap seg6local action End.DT46 vrftable 100 dev
 Adds an IPv6 route with SRv6 decapsulation and forward with lookup in VRF table.
 .RE
 .PP
+ip -6 route add 2001:db8:1::/64 encap ioam6 trace type 0x800000 ns 1 size 12 dev eth0
+.RS 4
+Adds an IPv6 route with an IOAM Pre-allocated Trace encapsulation that only includes the hop limit and the node id, configured for the IOAM namespace 1 and a pre-allocated data block of 12 octets.
+.RE
+.PP
 ip route add 10.1.1.0/30 nhid 10
 .RS 4
 Adds an ipv4 route using nexthop object with id 10.
diff --git a/man/man8/ip.8 b/man/man8/ip.8
index c9f7671e..87cd2df8 100644
--- a/man/man8/ip.8
+++ b/man/man8/ip.8
@@ -22,7 +22,7 @@ ip \- show / manipulate routing, network devices, interfaces and tunnels
 .BR link " | " address " | " addrlabel " | " route " | " rule " | " neigh " | "\
  ntable " | " tunnel " | " tuntap " | " maddress " | "  mroute " | " mrule " | "\
  monitor " | " xfrm " | " netns " | "  l2tp " | "  tcp_metrics " | " token " | "\
- macsec " | " vrf " | " mptcp " }"
+ macsec " | " vrf " | " mptcp " | " ioam " }"
 .sp
 
 .ti -8
@@ -252,6 +252,10 @@ readability.
 .B addrlabel
 - label configuration for protocol address selection.
 
+.TP
+.B ioam
+- manage IOAM namespaces and IOAM schemas.
+
 .TP
 .B l2tp
 - tunnel ethernet over IP (L2TPv3).
@@ -405,6 +409,7 @@ was written by Alexey N. Kuznetsov and added in Linux 2.2.
 .SH SEE ALSO
 .BR ip-address (8),
 .BR ip-addrlabel (8),
+.BR ip-ioam (8),
 .BR ip-l2tp (8),
 .BR ip-link (8),
 .BR ip-maddress (8),
-- 
2.25.1

