Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43990349BF3
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 22:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhCYVuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 17:50:12 -0400
Received: from ma1-aaemail-dr-lapp03.apple.com ([17.171.2.72]:58916 "EHLO
        ma1-aaemail-dr-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230440AbhCYVt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 17:49:59 -0400
X-Greylist: delayed 10762 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Mar 2021 17:49:59 EDT
Received: from pps.filterd (ma1-aaemail-dr-lapp03.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp03.apple.com (8.16.0.42/8.16.0.42) with SMTP id 12PImwn6031904;
        Thu, 25 Mar 2021 11:50:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=from : content-type :
 content-transfer-encoding : mime-version : subject : message-id : date :
 to; s=20180706; bh=HvRrQdHSok2zeZKp2kJcOzXJjsJYJ5UbdugaLvUYau4=;
 b=fE8/sF6ZnxpaWRmjmy6TT9V9wS+TntK/HxOCFmTa8CzJ4XDtUjpf39sP7UUr/qnhgwT6
 u1Fksx2eRdGyHiEeORwmO2gjz/l+3CvDf7dDzaV3vvUvCyqrPSOHauXbEKt5yraa29eg
 cSVW18wFlQOOdPNtQXGNMU14NYYsW/3HW+agSHPdxeX36luSaglt8raXK/KgZjNgZ+dm
 /3Cd0cJh6++KHEN77dG2e/FGc98Bk+zHdhm4B6CB4ULXLqHV89XIfa52guUd+uScJ8td
 EQgb/eO6REfEfFY0InNV5HeXHbxUz/t1DKL3nFO6ULlx/eqm63s1V9nonusNj5InVrKq vQ== 
Received: from crk-mailsvcp-mta-lapp04.euro.apple.com (crk-mailsvcp-mta-lapp04.euro.apple.com [17.66.55.17])
        by ma1-aaemail-dr-lapp03.apple.com with ESMTP id 37dg1vkg0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Thu, 25 Mar 2021 11:50:33 -0700
Received: from crk-mailsvcp-mmp-lapp02.euro.apple.com
 (crk-mailsvcp-mmp-lapp02.euro.apple.com [17.72.136.16])
 by crk-mailsvcp-mta-lapp04.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPS id <0QQJ00U0HGC8DA00@crk-mailsvcp-mta-lapp04.euro.apple.com>; Thu,
 25 Mar 2021 18:50:32 +0000 (GMT)
Received: from process_milters-daemon.crk-mailsvcp-mmp-lapp02.euro.apple.com by
 crk-mailsvcp-mmp-lapp02.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020)) id <0QQJ00300GBY6700@crk-mailsvcp-mmp-lapp02.euro.apple.com>; Thu,
 25 Mar 2021 18:50:32 +0000 (GMT)
X-Va-A: 
X-Va-T-CD: bcd587c70f2b893a4541eb5ac66e0494
X-Va-E-CD: 148ad133188105e62a3bc79cff51a8db
X-Va-R-CD: e1500ae658eab21eaee7bfe5430b4792
X-Va-CD: 0
X-Va-ID: a53b4dfa-6596-4489-a58b-ec431952f546
X-V-A:  
X-V-T-CD: bcd587c70f2b893a4541eb5ac66e0494
X-V-E-CD: 148ad133188105e62a3bc79cff51a8db
X-V-R-CD: e1500ae658eab21eaee7bfe5430b4792
X-V-CD: 0
X-V-ID: d44ad4c3-bfcc-4bef-8e43-87676770cc53
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_07:2021-03-25,2021-03-25 signatures=0
Received: from [17.232.106.97] (unknown [17.232.106.97])
 by crk-mailsvcp-mmp-lapp02.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPSA id <0QQJ00LDQGC7IZ00@crk-mailsvcp-mmp-lapp02.euro.apple.com>;
 Thu, 25 Mar 2021 18:50:32 +0000 (GMT)
From:   Norman Maurer <norman_maurer@apple.com>
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: quoted-printable
MIME-version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: udp: Add support for getsockopt(..., ..., UDP_GRO, ..., ...);
Message-id: <5AFF0F2A-96FD-40D6-9CE6-74F7CE8CEB4F@apple.com>
Date:   Thu, 25 Mar 2021 19:50:31 +0100
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org
X-Mailer: Apple Mail (2.3654.60.0.2.21)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_07:2021-03-25,2021-03-25 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for UDP_GRO was added in the past but the implementation for
getsockopt was missed which did lead to an error when we tried to
retrieve the setting for UDP_GRO. This patch adds the missing switch
case for UDP_GRO

Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
Signed-off-by: Norman Maurer <norman_maurer@apple.com>
---
 net/ipv4/udp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4a0478b17243..99d743eb9dc4 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2754,6 +2754,10 @@ int udp_lib_getsockopt(struct sock *sk, int =
level, int optname,
 		val =3D up->gso_size;
 		break;

+	case UDP_GRO:
+		val =3D up->gro_enabled;
+		break;
+
 	/* The following two cannot be changed on UDP sockets, the =
return is
 	 * always 0 (which corresponds to the full checksum coverage of =
UDP). */
 	case UDPLITE_SEND_CSCOV:
--
2.29.2

