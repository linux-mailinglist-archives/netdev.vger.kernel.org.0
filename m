Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBC43693DB
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 15:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhDWNmF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 09:42:05 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:38598 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229479AbhDWNmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 09:42:01 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-8QsdtI__OD24co9640BgGw-1; Fri, 23 Apr 2021 09:41:22 -0400
X-MC-Unique: 8QsdtI__OD24co9640BgGw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DA4819253C2;
        Fri, 23 Apr 2021 13:41:21 +0000 (UTC)
Received: from hog (unknown [10.40.192.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A30BB60BE5;
        Fri, 23 Apr 2021 13:41:19 +0000 (UTC)
Date:   Fri, 23 Apr 2021 15:41:17 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH v2] net: geneve: modify IP header check in
 geneve6_xmit_skb and geneve_xmit_skb
Message-ID: <YILOfTt6qKNwYtV6@hog>
References: <20210422234945.1190-1-phil@philpotter.co.uk>
MIME-Version: 1.0
In-Reply-To: <20210422234945.1190-1-phil@philpotter.co.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-04-23, 00:49:45 +0100, Phillip Potter wrote:
> Modify the header size check in geneve6_xmit_skb and geneve_xmit_skb
> to use pskb_inet_may_pull rather than pskb_network_may_pull. This fixes
> two kernel selftest failures introduced by the commit introducing the
> checks:
> IPv4 over geneve6: PMTU exceptions
> IPv4 over geneve6: PMTU exceptions - nexthop objects
> 
> It does this by correctly accounting for the fact that IPv4 packets may
> transit over geneve IPv6 tunnels (and vice versa), and still fixes the
> uninit-value bug fixed by the original commit.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Fixes: 6628ddfec758 ("net: geneve: check skb is large enough for IPv4/IPv6 header")
> Suggested-by: Sabrina Dubroca <sd@queasysnail.net>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> ---
> 
> V2:
> * Incorporated feedback from Sabrina Dubroca regarding pskb_inet_may_pull
> * Added Fixes: tag as requested by Eric Dumazet

Thanks Phillip.

Acked-by: Sabrina Dubroca <sd@queasysnail.net>

Jakub/David, it would be great if this could get in 5.12, otherwise
geneve is a bit broken:
https://bugzilla.kernel.org/show_bug.cgi?id=212749

-- 
Sabrina

