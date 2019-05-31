Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1CB309E1
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfEaILw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:11:52 -0400
Received: from mail.us.es ([193.147.175.20]:47022 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbfEaILw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:11:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 443BCFB36A
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 10:11:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37CE4DA717
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 10:11:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2C545DA710; Fri, 31 May 2019 10:11:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F423BDA710;
        Fri, 31 May 2019 10:11:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 10:11:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A63244265A31;
        Fri, 31 May 2019 10:11:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sfr@canb.auug.org.au,
        yuehaibing@huawei.com, lkp@intel.com
Subject: [PATCH net-next] netfilter: missing #include for nf_ct_frag6_gather declaration
Date:   Fri, 31 May 2019 10:11:43 +0200
Message-Id: <20190531081143.21446-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In file included from net/netfilter/utils.c:5:
include/linux/netfilter_ipv6.h: In function 'nf_ipv6_br_defrag':
include/linux/netfilter_ipv6.h:110:9: error: implicit declaration of function 'nf_ct_frag6_gather'; did you mean 'nf_ct_attach'? [-Werror=implicit-function-declaration]
  return nf_ct_frag6_gather(net, skb, user);
         ^~~~~~~~~~~~~~~~~~

Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv6.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index a21b8c9623ee..3a3dc4b1f0e7 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -96,6 +96,8 @@ static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
 #endif
 }
 
+#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
+
 static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
 				    u32 user)
 {
-- 
2.11.0

