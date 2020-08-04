Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF44C23B4AB
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 07:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbgHDFyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 01:54:47 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29664 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727862AbgHDFyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 01:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596520486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FZ8+mJeaOT8PSGUlyzRUmM90WxyPPaz3VWSJey/TOeU=;
        b=RYPS0Vt6CMhf4eEk9MDFxp/l1amLnbujC3UWPHEBe0ULAQNkiYD6wwjUfH9xJO/VFCnbQQ
        2J2+1R9f/Q7OgsWgPVBibSZSt35C4/R3iu3qr9yGcXzPsvLrJkpPFl5/iHaFA1yrlYG7/4
        PuXupzT2fshIZBtXeZG3Rj1h4/abpoE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-cLfXkQriM5G_nzM4C9UowQ-1; Tue, 04 Aug 2020 01:53:40 -0400
X-MC-Unique: cLfXkQriM5G_nzM4C9UowQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88D8A108E;
        Tue,  4 Aug 2020 05:53:38 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6662388D57;
        Tue,  4 Aug 2020 05:53:35 +0000 (UTC)
Date:   Tue, 4 Aug 2020 07:53:29 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/6] vxlan: Support for PMTU discovery on
 directly bridged links
Message-ID: <20200804075329.47dba2c8@elisabeth>
In-Reply-To: <2a4836b6-e435-953e-16b2-4dd8177ffeeb@gmail.com>
References: <cover.1596487323.git.sbrivio@redhat.com>
        <9c5e81621d9fc94cc1d1f77e177986434ca9564f.1596487323.git.sbrivio@redhat.com>
        <2a4836b6-e435-953e-16b2-4dd8177ffeeb@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Aug 2020 17:48:48 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 8/3/20 2:52 PM, Stefano Brivio wrote:
> > +		err = skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM,
> > +					    netif_is_bridge_port(dev) ||
> > +					    netif_is_ovs_port(dev));  
> 
> you have this check in a few places. Maybe a new helper like
> netif_is_any_bridge_port that can check both IFF flags in 1 go.

Ah, yes, good idea, added to 1/6 v2 as it's where it's needed now.

-- 
Stefano

