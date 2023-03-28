Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FAE6CCA5C
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 21:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjC1TAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 15:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjC1TAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 15:00:54 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8052D52
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 12:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680030051; x=1711566051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kY+QYzNupvQUIeaqKrJbkf0jTI4nJrbZblwDysT65ZI=;
  b=Z/P8VhgnAHhNJUETt/D4e6q3urmgcME+hukCVLCONetEbn5LYEv7N8Ci
   bg6vchXh6oi6qSvSLSgKNDVB/OBW1Vqn5QO+1V5ntwjFhQEQcJHOJFwxc
   VmUvMk49OfBUr7SrdbIY1PC7mkPht1wv5f/KLcbYJe9HRrJ5dJlc/UuF3
   8=;
X-IronPort-AV: E=Sophos;i="5.98,297,1673913600"; 
   d="scan'208";a="198430175"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 19:00:48 +0000
Received: from EX19MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com (Postfix) with ESMTPS id 288F8E1FC4;
        Tue, 28 Mar 2023 19:00:44 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.22; Tue, 28 Mar 2023 19:00:42 +0000
Received: from 88665a182662.ant.amazon.com (10.187.171.35) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Tue, 28 Mar 2023 19:00:39 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <mbloch@nvidia.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v2 net-next 2/2] 6lowpan: Remove redundant initialisation.
Date:   Tue, 28 Mar 2023 12:00:31 -0700
Message-ID: <20230328190031.65422-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <b880d6ef-fe6b-4b39-d023-b66efeae4fc8@nvidia.com>
References: <b880d6ef-fe6b-4b39-d023-b66efeae4fc8@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.35]
X-ClientProxiedBy: EX19D037UWB003.ant.amazon.com (10.13.138.115) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Mark Bloch <mbloch@nvidia.com>
Date:   Tue, 28 Mar 2023 09:27:43 +0300
> On 28/03/2023 2:54, Kuniyuki Iwashima wrote:
> > We'll call memset(&tmp, 0, sizeof(tmp)) later.
> 
> Why not just remove the first memset() then?

The same pattern (memset(), init, compare) is repeated twice, and
I thought it's cleaner.  I don't have no strong preference though.

Also, we need not init it if we hit 'goto out' in the first switch.

---8<---
static u8 lowpan_compress_ctx_addr(u8 **hc_ptr, const struct net_device *dev,
				   const struct in6_addr *ipaddr,
				   const struct lowpan_iphc_ctx *ctx,
				   const unsigned char *lladdr, bool sam)
{
	struct in6_addr tmp;
	u8 dam;

	switch (lowpan_dev(dev)->lltype) {
	case LOWPAN_LLTYPE_IEEE802154:
		if (lowpan_iphc_compress_ctx_802154_lladdr(ipaddr, ctx,
							   lladdr)) {
			dam = LOWPAN_IPHC_DAM_11;
			goto out;
		}
		break;
	default:
		if (lowpan_iphc_addr_equal(dev, ctx, ipaddr, lladdr)) {
			dam = LOWPAN_IPHC_DAM_11;
			goto out;
		}
		break;
	}

	memset(&tmp, 0, sizeof(tmp));
	/* check for SAM/DAM = 10 */
	tmp.s6_addr[11] = 0xFF;
	tmp.s6_addr[12] = 0xFE;
	memcpy(&tmp.s6_addr[14], &ipaddr->s6_addr[14], 2);
	/* context information are always used */
	ipv6_addr_prefix_copy(&tmp, &ctx->pfx, ctx->plen);
	if (ipv6_addr_equal(&tmp, ipaddr)) {
		lowpan_push_hc_data(hc_ptr, &ipaddr->s6_addr[14], 2);
		dam = LOWPAN_IPHC_DAM_10;
		goto out;
	}

	memset(&tmp, 0, sizeof(tmp));
	/* check for SAM/DAM = 01, should always match */
	memcpy(&tmp.s6_addr[8], &ipaddr->s6_addr[8], 8);
	/* context information are always used */
	ipv6_addr_prefix_copy(&tmp, &ctx->pfx, ctx->plen);
	if (ipv6_addr_equal(&tmp, ipaddr)) {
		lowpan_push_hc_data(hc_ptr, &ipaddr->s6_addr[8], 8);
		dam = LOWPAN_IPHC_DAM_01;
		goto out;
	}
...
}
---8<---


> 
> Mark
> 
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  net/6lowpan/iphc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/6lowpan/iphc.c b/net/6lowpan/iphc.c
> > index 52fad5dad9f7..e116d308a8df 100644
> > --- a/net/6lowpan/iphc.c
> > +++ b/net/6lowpan/iphc.c
> > @@ -848,7 +848,7 @@ static u8 lowpan_compress_ctx_addr(u8 **hc_ptr, const struct net_device *dev,
> >  				   const struct lowpan_iphc_ctx *ctx,
> >  				   const unsigned char *lladdr, bool sam)
> >  {
> > -	struct in6_addr tmp = {};
> > +	struct in6_addr tmp;
> >  	u8 dam;
> >  
> >  	switch (lowpan_dev(dev)->lltype) {
