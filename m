Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8838B7B0
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 13:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbfHML5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 07:57:09 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36115 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfHML5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 07:57:09 -0400
Received: by mail-qt1-f195.google.com with SMTP id z4so106072396qtc.3
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 04:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RPb0NU5H2rzwjdvr45r58ZWni2Zoy4JljRGSpgnMMr4=;
        b=ap0SmPcZPZ6NNFvNyFkpypRbg36yi8bdsTd4/F6gQQqPPgiM5IjDvTKZEGGxca8l8F
         u5EQEn7sEyhGruMuB7cjg3kUgzh9Cv/quO6ECF3rbawY4hb6Yw2dyN9iU6PgCvTDOCh0
         xsYZVNW0ajla3uTLaTh6ZCITFtrsONP4+81D6sumJLjqzxf2snBDmJYrwx6qXccYld+H
         swJwSMjlc5QmHizDCiZoTu8O5ptOxdiKgiKAZ9i3JGi/jhbj1siIrzDAKpRTStg72MQw
         /hWyMVuaK40viEpVJr1GXiLhMU2L4bLITv7lm7rfgwRXFHTHOxuSU5tATEjLqz3Rmkx9
         LONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RPb0NU5H2rzwjdvr45r58ZWni2Zoy4JljRGSpgnMMr4=;
        b=cKppGh9XHAKHahhUHW+NV2GSlB5Ko4N+i1U2irCwsg2D5GSKIe4N+uo8BWET8eFWGm
         ftldtMbwb8wn0yF4I3BlK8CGoKmsjnDnEJEiVr+mPnBFu4ZvNEtLDycW0TlCM/R61rRH
         2HjYaSyd92pCYqC/Fe9Nd7gkBsccJ+sx6QXrDJUpv6tpdx3y4PuyQ2b5JGjAj+rTTCXc
         vJ6orBIjat7haygtaq/lNuqdU3D9Q3QiwgbSVDUF1eocICmUbg/OtovhlDDeRgH605ny
         tBZnXp+v76oxBqMEmlubO7P2flviw/oiPm6eyFRrgi42u481FrHE4Q+7HQnOslmil9Bn
         KyNQ==
X-Gm-Message-State: APjAAAWNubvzFljCf3GE1Lhuh3MdEKQWbn0Gyq3wPxowxGLvOc4DCUom
        6Xaw4o4qmqbESlKJDbe7O7/vWg==
X-Google-Smtp-Source: APXvYqyQLbr3IuoVdbXppS/ZGOesGhtgbHcYTwB9ezrUQfPYFcx2A9k+2h1mf3jK0ev1zMtBSQ9gpg==
X-Received: by 2002:a0c:f193:: with SMTP id m19mr33863324qvl.20.1565697428498;
        Tue, 13 Aug 2019 04:57:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id r4sm69930362qta.93.2019.08.13.04.57.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 13 Aug 2019 04:57:07 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hxVQJ-0007sn-HH; Tue, 13 Aug 2019 08:57:07 -0300
Date:   Tue, 13 Aug 2019 08:57:07 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V5 0/9] Fixes for vhost metadata acceleration
Message-ID: <20190813115707.GC29508@ziepe.ca>
References: <20190809054851.20118-1-jasowang@redhat.com>
 <20190810134948-mutt-send-email-mst@kernel.org>
 <360a3b91-1ac5-84c0-d34b-a4243fa748c4@redhat.com>
 <20190812054429-mutt-send-email-mst@kernel.org>
 <20190812130252.GE24457@ziepe.ca>
 <9a9641fe-b48f-f32a-eecc-af9c2f4fbe0e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a9641fe-b48f-f32a-eecc-af9c2f4fbe0e@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 04:31:07PM +0800, Jason Wang wrote:

> What kind of issues do you see? Spinlock is to synchronize GUP with MMU
> notifier in this series.

A GUP that can't sleep can't pagefault which makes it a really weird
pattern

> Btw, back to the original question. May I know why synchronize_rcu() is not
> suitable? Consider:

We already went over this. You'd need to determine it doesn't somehow
deadlock the mm on reclaim paths. Maybe it is OK, the rcq_gq_wq is
marked WQ_MEM_RECLAIM at least..

I also think Michael was concerned about the latency spikes a long RCU
delay would cause.

Jason
