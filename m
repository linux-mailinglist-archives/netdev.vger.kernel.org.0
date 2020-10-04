Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE8F282B14
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 16:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgJDOAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 10:00:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725927AbgJDOAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 10:00:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601820050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fm94G5MtLGooNgL+Wfv2prTlsVAS1DxhSlOCsJvBYgg=;
        b=i/O1lKxo+c+u3Peqk0NfO6cYS0fcZJuEypbJDern3mfw5/fH/8x+Ij2oz/WopMouH9K+XQ
        mD8Cm3RhL9TDYBLfvAAGyrXQPnz7rSSxYTJVcwWUno4YQCszORSvhxs+UASTby6eNs/38r
        Pq4fEGpP5BofnuBXzBQDK8YahhpXwCE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-LntC8MZdNtyY3hiG1A4fZg-1; Sun, 04 Oct 2020 10:00:48 -0400
X-MC-Unique: LntC8MZdNtyY3hiG1A4fZg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 745B11084C86;
        Sun,  4 Oct 2020 14:00:47 +0000 (UTC)
Received: from new-host-6 (unknown [10.40.192.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6BCB10013BD;
        Sun,  4 Oct 2020 14:00:45 +0000 (UTC)
Message-ID: <71bd92d07f21cbca5176e39774463b0ac135ad45.camel@redhat.com>
Subject: Re: [PATCH net] net/core: check length before updating Ethertype
 in skb_mpls_{push,pop}
From:   Davide Caratti <dcaratti@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Martin Varghese <martin.varghese@nokia.com>
In-Reply-To: <71ec98d51cc4aab7615061336fb1498ad16cda30.1601667845.git.gnault@redhat.com>
References: <71ec98d51cc4aab7615061336fb1498ad16cda30.1601667845.git.gnault@redhat.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Sun, 04 Oct 2020 16:00:44 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-02 at 21:53 +0200, Guillaume Nault wrote:
> Openvswitch allows to drop a packet's Ethernet header, therefore
> skb_mpls_push() and skb_mpls_pop() might be called with ethernet=true
> and mac_len=0. In that case the pointer passed to skb_mod_eth_type()
> doesn't point to an Ethernet header and the new Ethertype is written at
> unexpected locations.
> 
> Fix this by verifying that mac_len is big enough to contain an Ethernet
> header.
> 
> Fixes: fa4e0f8855fc ("net/sched: fix corrupted L2 header with MPLS 'push' and 'pop' actions")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
> Notes:
>   - Found by code inspection.
>   - Using commit fa4e0f8855fc for the Fixes tag because mac_len is
>     needed for the test. The problem probably exists since openvswitch
>     can pop the Ethernet header though.
> 
>  net/core/skbuff.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)


Acked-by: Davide Caratti <dcaratti@redhat.com>

thanks!

-- 
davide


