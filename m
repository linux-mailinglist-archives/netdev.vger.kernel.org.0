Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1364AA9BE
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380264AbiBEPw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:52:28 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:52554 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380262AbiBEPw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:52:28 -0500
Received: from ubuntu.home (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 708F0200E1DC;
        Sat,  5 Feb 2022 16:52:26 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 708F0200E1DC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1644076346;
        bh=7w5IPUg3D+4fL9V6TwlnfgmwwPb2LipSpZDXVHAIuPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzDEB2TrrlxJPIbXXACFHe6GT/W261oaf0VhnnxyAM1UKZpOwEM1+UaKbNwVy1418
         iL+GNIfNHyCmJ2DqMM4VLyqekoqEUTJyaBbFV0Os3zrX97qcw1/2bFjLZMeW0folYP
         NBN88hVy9WWIWQK4WJegU2EnJW0IoJEAFn4uDY/ZBMWNReGe5W2O4a9StQgvSNYcZW
         RYoPoAzJ9WTbMTSzqkLCmhPIUyLiFgnu/BW2uwJ9xcbhhfuFtvRutP4kTwvmKxX4F+
         0bZVni55r2wRUUvi7eONH58cib80APUbwVAAjIFifwLPrj4y+ZBU6d5vALOUIRugvm
         ulB49toDr9ydg==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, stephen@networkplumber.org,
        justin.iurman@uliege.be
Subject: [PATCH iproute2-next 2/2] Update documentation
Date:   Sat,  5 Feb 2022 16:52:08 +0100
Message-Id: <20220205155208.22531-3-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220205155208.22531-1-justin.iurman@uliege.be>
References: <20220205155208.22531-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the ip-route documentation to include the IOAM insertion
frequency.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 man/man8/ip-route.8.in | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/man/man8/ip-route.8.in b/man/man8/ip-route.8.in
index ed628455..462ff269 100644
--- a/man/man8/ip-route.8.in
+++ b/man/man8/ip-route.8.in
@@ -245,7 +245,9 @@ throw " | " unreachable " | " prohibit " | " blackhole " | " nat " ]"
 
 .ti -8
 .IR ENCAP_IOAM6 " := "
-.B ioam6
+.BR ioam6 " ["
+.B freq
+.IR K "/" N " ] "
 .BR mode " [ "
 .BR inline " | " encap " | " auto " ] ["
 .B tundst
@@ -919,6 +921,9 @@ address is set as described in \fBip-sr\fR(8).
 
 .B ioam6
 .in +2
+.B freq K/N
+- Inject IOAM in K packets every N packets (default is 1/1).
+
 .B mode inline
 - Directly insert IOAM after IPv6 header (default mode).
 .sp
@@ -1274,9 +1279,9 @@ ip -6 route add 2001:db8:1::/64 encap seg6local action End.DT46 vrftable 100 dev
 Adds an IPv6 route with SRv6 decapsulation and forward with lookup in VRF table.
 .RE
 .PP
-ip -6 route add 2001:db8:1::/64 encap ioam6 mode encap tundst 2001:db8:42::1 trace prealloc type 0x800000 ns 1 size 12 dev eth0
+ip -6 route add 2001:db8:1::/64 encap ioam6 freq 2/5 mode encap tundst 2001:db8:42::1 trace prealloc type 0x800000 ns 1 size 12 dev eth0
 .RS 4
-Adds an IPv6 route with an IOAM Pre-allocated Trace encapsulation (ip6ip6) that only includes the hop limit and the node id, configured for the IOAM namespace 1 and a pre-allocated data block of 12 octets.
+Adds an IPv6 route with an IOAM Pre-allocated Trace encapsulation (ip6ip6) that only includes the hop limit and the node id, configured for the IOAM namespace 1 and a pre-allocated data block of 12 octets (will be injected in 2 packets every 5 packets).
 .RE
 .PP
 ip route add 10.1.1.0/30 nhid 10
-- 
2.25.1

