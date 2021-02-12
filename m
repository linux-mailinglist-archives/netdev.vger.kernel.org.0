Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EC231A217
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhBLPuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:50:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229512AbhBLPux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:50:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613144966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZruydGNsAevmRAQmdfrf2uJr5yjAlxh3AVpI5mrLs70=;
        b=U7xNvlk7exFH1cowRmpqMhR2v9YeBufiNGh2AEQQBr0W/Eil/59tpF98wAw07hDEJM5QrB
        3/cyeFQmyzFHXjfjbNQ/fZm82Dagk2vPmn/5IeXTCnozbul9SX6obL70TOQYJ4NoJEx3x7
        IHFxjYBwNgNeiNoedqoUTh6mD8M4HPs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-Bae2amJkPrOc64HvfAvkXQ-1; Fri, 12 Feb 2021 10:49:22 -0500
X-MC-Unique: Bae2amJkPrOc64HvfAvkXQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0139380403E;
        Fri, 12 Feb 2021 15:49:21 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 968BD5D6BA;
        Fri, 12 Feb 2021 15:49:01 +0000 (UTC)
Date:   Fri, 12 Feb 2021 16:49:00 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, bpf@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        brouer@redhat.com
Subject: Re: [PATCH net-next V1] net: adjust net_device layout for cacheline
 usage
Message-ID: <20210212164900.53a9a452@carbon>
In-Reply-To: <20210129150058.34e3a855@carbon>
References: <161168277983.410784.12401225493601624417.stgit@firesoul>
        <52835f1f-96e1-b36e-2631-1182649ac3a8@gmail.com>
        <20210129150058.34e3a855@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 15:00:58 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> On Fri, 29 Jan 2021 14:33:02 +0100
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > On 1/26/21 6:39 PM, Jesper Dangaard Brouer wrote:  
> > > The current layout of net_device is not optimal for cacheline usage.
> > > 
[...]
> > > @@ -1877,6 +1876,23 @@ struct net_device {
[...]
> > > +
> > >  	netdev_features_t	features;
> > >  	netdev_features_t	hw_features;
> > >  	netdev_features_t	wanted_features;    
> > 
> > Probably wanted_features, hw_features are not used in fast path, only
> > in control path ?  
> 
> Yes, that was also my analysis.  I did consider moving those down, but
> I wanted to keep the first iteration simple ;-)

I've send a followup[1] to address this, thanks for pointing it out.

[1] https://patchwork.kernel.org/project/netdevbpf/patch/161313782625.1008639.6000589679659428869.stgit@firesoul/
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

