Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465BA282476
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 16:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgJCOKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 10:10:41 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:5462 "EHLO smtp6-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgJCOKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 10:10:41 -0400
Received: from [IPv6:2a01:e34:ec0c:ae81:8d77:4856:46b:2117] (unknown [IPv6:2a01:e34:ec0c:ae80:8d77:4856:46b:2117])
        by smtp6-g21.free.fr (Postfix) with ESMTPS id 29C3A780336;
        Sat,  3 Oct 2020 14:10:06 +0000 (UTC)
Subject: [PATCH] iproute2: ip addr: Fix noprefixroute and autojoin for IPv4
From:   Adel Belhouane <bugs.a.b@free.fr>
To:     netdev@vger.kernel.org
Cc:     Adel Belhouane <bugs.a.b@free.fr>
Message-ID: <1869e1c3-cf1e-a851-77ac-5482c694f5b3@free.fr>
Date:   Sat, 3 Oct 2020 16:10:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These were reported as IPv6-only and ignored:

     # ip address add 192.0.2.2/24 dev dummy5 noprefixroute
     Warning: noprefixroute option can be set only for IPv6 addresses
     # ip address add 224.1.1.10/24 dev dummy5 autojoin
     Warning: autojoin option can be set only for IPv6 addresses

This enables them back for IPv4.

Fixes: 9d59c86e575b5 ("iproute2: ip addr: Organize flag properties
structurally")
Signed-off-by: Adel Belhouane <bugs.a.b@free.fr>
---
  ip/ipaddress.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index ccf67d1dd55c..2b4cb48a485e 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1249,8 +1249,8 @@ static const struct ifa_flag_data_t {
  	{ .name = "tentative",		.mask = IFA_F_TENTATIVE,	.readonly = true,	.v6only = true},
  	{ .name = "permanent",		.mask = IFA_F_PERMANENT,	.readonly = true,	.v6only = true},
  	{ .name = "mngtmpaddr",		.mask = IFA_F_MANAGETEMPADDR,	.readonly = false,	.v6only = true},
-	{ .name = "noprefixroute",	.mask = IFA_F_NOPREFIXROUTE,	.readonly = false,	.v6only = true},
-	{ .name = "autojoin",		.mask = IFA_F_MCAUTOJOIN,	.readonly = false,	.v6only = true},
+	{ .name = "noprefixroute",	.mask = IFA_F_NOPREFIXROUTE,	.readonly = false,	.v6only = false},
+	{ .name = "autojoin",		.mask = IFA_F_MCAUTOJOIN,	.readonly = false,	.v6only = false},
  	{ .name = "stable-privacy",	.mask = IFA_F_STABLE_PRIVACY, 	.readonly = true,	.v6only = true},
  };
  
-- 
2.20.1

