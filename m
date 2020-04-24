Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EF51B6FE0
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 10:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgDXIjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 04:39:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20576 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726383AbgDXIjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 04:39:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O8ZmwS026536;
        Fri, 24 Apr 2020 01:39:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=9QuR3BgF7gSO+TF73rZJRPAEpcka20p8EDsgraG7cr4=;
 b=hgNVBG1bYCOntlwZeKA9g8zYkuHWesRI2cPVjQP/g6YPga3IKZdQ+jWyKkLTRk5ziE6f
 RKMI35y9MsHK9rx9KeLm9PZZ1DiwELGsh+LBZ0+LQ+oG6iit2ZzyaZEWC0+3VNqMLGHj
 dbb79Tei0jyWU7Is5Ca3qJKlMToQ7VmPCIogrzcmb69z0Jk8Z71Eub/J8VKYUHlUIcdc
 BoUqCyt4FygwjOg6TZeljboJ+S7aQH1ktr26kxhsuCXsb4DkLCgchEfw5ccZvWscaLOK
 3hBa86MivxlYlzT8RMg/w0wKafP36lV9iiQ9iWv1EGACuZIAslA3GPiIcQqjaYstXWBl 4A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsbcg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 01:39:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 01:39:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 01:39:04 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 4DA163F7044;
        Fri, 24 Apr 2020 01:39:02 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH iproute2-next 1/2] macsec: add support for MAC offload
Date:   Fri, 24 Apr 2020 11:38:56 +0300
Message-ID: <20200424083857.1265-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424083857.1265-1-irusskikh@marvell.com>
References: <20200424083857.1265-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_02:2020-04-23,2020-04-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch enables MAC HW offload usage in iproute, since MACSec
implementation supports it now.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 ip/ipmacsec.c        | 3 ++-
 man/man8/ip-macsec.8 | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index 4e500e4e..d214b101 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -34,6 +34,7 @@ static const char * const validate_str[] = {
 static const char * const offload_str[] = {
 	[MACSEC_OFFLOAD_OFF] = "off",
 	[MACSEC_OFFLOAD_PHY] = "phy",
+	[MACSEC_OFFLOAD_MAC] = "mac",
 };
 
 struct sci {
@@ -98,7 +99,7 @@ static void ipmacsec_usage(void)
 		"       ip macsec del DEV rx SCI sa { 0..3 }\n"
 		"       ip macsec show\n"
 		"       ip macsec show DEV\n"
-		"       ip macsec offload DEV [ off | phy ]\n"
+		"       ip macsec offload DEV [ off | phy | mac ]\n"
 		"where  OPTS := [ pn <u32> ] [ on | off ]\n"
 		"       ID   := 128-bit hex string\n"
 		"       KEY  := 128-bit or 256-bit hex string\n"
diff --git a/man/man8/ip-macsec.8 b/man/man8/ip-macsec.8
index d5f9d240..b2ee7bee 100644
--- a/man/man8/ip-macsec.8
+++ b/man/man8/ip-macsec.8
@@ -54,7 +54,7 @@ ip-macsec \- MACsec device configuration
 .RI "{ " 0..3 " }"
 
 .BI "ip macsec offload " DEV
-.RB "{ " off " | " phy " }"
+.RB "{ " off " | " phy " | " mac " }"
 
 .B ip macsec show
 .RI [ " DEV " ]
-- 
2.20.1

