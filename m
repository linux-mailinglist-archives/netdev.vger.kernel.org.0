Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E25AE952F8
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 03:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfHTBJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 21:09:19 -0400
Received: from mail-m965.mail.126.com ([123.126.96.5]:43002 "EHLO
        mail-m965.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728615AbfHTBJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 21:09:19 -0400
X-Greylist: delayed 1859 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Aug 2019 21:09:18 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=HVPsX
        U1SfpWPxXQpzpYv1zzZg0TkfnffyRW+Lv2MLXs=; b=EJO56Y93Nv03SK6KKqTpl
        KMS6Mwz77ay/U2AzlpM95yf5EaBitRIpXOh2e/1Or6+y24sm/56iEIRjkSTz2o+j
        n7tYx0cwds8Yw+ZeG6bm3T39LhvAKuiaENVT1CxcAjlU2mv/Y9PBYR3BRvyeDT2k
        Oyn9v+0HIb9Z5C29DZc2sk=
Received: from toolchain (unknown [114.249.221.222])
        by smtp10 (Coremail) with SMTP id NuRpCgA3N+K+QFtdllWIJw--.54S2;
        Tue, 20 Aug 2019 08:37:19 +0800 (CST)
Date:   Tue, 20 Aug 2019 08:37:18 +0800
From:   zhang kai <zhangkaiheb@126.com>
To:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     lvs-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] ipvs: change type of delta and previous_delta in ip_vs_seq.
Message-ID: <20190820003718.GA16620@toolchain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-CM-TRANSID: NuRpCgA3N+K+QFtdllWIJw--.54S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr45JF43ZF4rKry8AF1rtFb_yoW3uwb_uw
        n7WaykCw4rJw4fAr1jvF4rJw10934xtFy8u3sxtF1Ut3WUGF9xGryxJr129FZ3uwnrAF93
        A3yFvw4Utr4rWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUng_-DUUUUU==
X-Originating-IP: [114.249.221.222]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbiIR8X-lpD9TtRbgAAs-
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In NAT forwarding mode, Applications may decrease the size of packets,
and TCP sequences will get smaller, so both of variables will be negetive
values in this case.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
---
 include/net/ip_vs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 3759167f91f5..de7e75063c7c 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -346,8 +346,8 @@ enum ip_vs_sctp_states {
  */
 struct ip_vs_seq {
 	__u32			init_seq;	/* Add delta from this seq */
-	__u32			delta;		/* Delta in sequence numbers */
-	__u32			previous_delta;	/* Delta in sequence numbers
+	__s32			delta;		/* Delta in sequence numbers */
+	__s32			previous_delta;	/* Delta in sequence numbers
 						 * before last resized pkt */
 };
 
-- 
2.17.1

