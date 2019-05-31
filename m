Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC99E309CD
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfEaIDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:03:09 -0400
Received: from mail.us.es ([193.147.175.20]:38980 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbfEaIDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:03:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5ABEABAEA3
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 10:03:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 381C4DA79D
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 10:03:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 94374DA7F3; Fri, 31 May 2019 10:03:00 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21354DA705;
        Fri, 31 May 2019 10:02:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 10:02:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E74284265A32;
        Fri, 31 May 2019 10:02:57 +0200 (CEST)
Date:   Fri, 31 May 2019 10:02:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yuehaibing <yuehaibing@huawei.com>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de,
        linux-kernel@vger.kernel.org, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nf_conntrack_bridge: Fix build error
 without IPV6
Message-ID: <20190531080257.62mfimdlwuv42bk3@salvia>
References: <20190531024643.3840-1-yuehaibing@huawei.com>
 <19095cab-fbc5-f200-a40c-cb4c1a12fbc6@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mledociainyopav3"
Content-Disposition: inline
In-Reply-To: <19095cab-fbc5-f200-a40c-cb4c1a12fbc6@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mledociainyopav3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 31, 2019 at 11:06:49AM +0800, Yuehaibing wrote:
> +cc netdev
> 
> On 2019/5/31 10:46, YueHaibing wrote:
> > Fix gcc build error while CONFIG_IPV6 is not set
> > 
> > In file included from net/netfilter/core.c:19:0:
> > ./include/linux/netfilter_ipv6.h: In function 'nf_ipv6_br_defrag':
> > ./include/linux/netfilter_ipv6.h:110:9: error: implicit declaration of function 'nf_ct_frag6_gather' [-Werror=implicit-function-declaration]
> > 
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
> >  include/linux/netfilter_ipv6.h | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
> > index a21b8c9..4ea97fd 100644
> > --- a/include/linux/netfilter_ipv6.h
> > +++ b/include/linux/netfilter_ipv6.h
> > @@ -96,6 +96,8 @@ static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
> >  #endif
> >  }
> >  
> > +int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user);
> > +

This is already defined in:

include/net/netfilter/ipv6/nf_defrag_ipv6.h

Probably this?

--mledociainyopav3
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

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

--mledociainyopav3--
