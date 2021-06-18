Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FBD3ACCCC
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbhFRNyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:54:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234179AbhFRNyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:54:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624024321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4m43haMZkXo+6dMXFc2UeeK5bFqrx7krUnKM0CcDLn0=;
        b=N2oNHRoQm4XreItOb1b05Fuu6J68Xne6rx/pggnCMgST95xcem4fEMEOBe//Fsp8LFcyTc
        RhQhzX/uBvCxL01XcFWJqv8AhWRkaFWUqkuUpjo393ztjEoo3t520ceeqK+SaYi9BPBk5I
        GKqD51CDTtrs6SatHFUp2YM99Jj8gZk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-u2eCPeqcOH2SwN_2kOm35g-1; Fri, 18 Jun 2021 09:51:51 -0400
X-MC-Unique: u2eCPeqcOH2SwN_2kOm35g-1
Received: by mail-wm1-f71.google.com with SMTP id v20-20020a05600c2154b029019a6368bfe4so3791040wml.2
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 06:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4m43haMZkXo+6dMXFc2UeeK5bFqrx7krUnKM0CcDLn0=;
        b=N/zyCw13Kkz6PrXYI372O9K1JiIXSj77Lf0yEaEtg/qQXcwZr/MW9u9z53W2v5e6El
         /VA/fCoM42Gc96Oqb9EWbryw03et2S4QHIy24fZ5EVDN99eE/KRVhAuPW9Tr0aGhTLF8
         Dg2lcKU1MbBJU5/gZpYFgwzHNGnXtvtUm3xkmZQzI3pKWmYBekLMp3eyK7boSDLvdOhK
         JkLpH9Iin1ccYqY3I5bLzL/mxfrY6kh229nF7K+X4LOy4KCys2LYPY03ZypTWGOwLvT+
         /DU/qG8ln88JRZRCjADDb2kD7SgYDROVvZKFNZWGEpvTax7FskP/lGGsJaY6clTKIjDt
         g1jA==
X-Gm-Message-State: AOAM533NupgTkX0osxmKGXh2sElneQolprDO2K5FvMeypKx7RZhcnLLg
        /5LO3gQZZwY97HKhohmPdil0vTsIntrhgnTh15g3F3ZThCbNyh8z0KBU3uoJGnY5jptLkB+0YnM
        jH/ht45OmWyTZbhFO
X-Received: by 2002:a5d:6350:: with SMTP id b16mr12960560wrw.41.1624024310549;
        Fri, 18 Jun 2021 06:51:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqJ3GZeW6jRvmnJbJ7b1ZhOousWSFHH5OW+Xxp1vDn8d5uUTDBmjRCWu6e4mCUYbWrxf7YAw==
X-Received: by 2002:a5d:6350:: with SMTP id b16mr12960548wrw.41.1624024310425;
        Fri, 18 Jun 2021 06:51:50 -0700 (PDT)
Received: from redhat.com ([77.126.22.11])
        by smtp.gmail.com with ESMTPSA id b11sm8767138wrf.43.2021.06.18.06.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 06:51:48 -0700 (PDT)
Date:   Fri, 18 Jun 2021 09:51:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        oxffffaa@gmail.com
Subject: Re: [PATCH v11 11/18] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210618095006-mutt-send-email-mst@kernel.org>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
 <20210611111241.3652274-1-arseny.krasnov@kaspersky.com>
 <20210618134423.mksgnbmchmow4sgh@steredhat.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618134423.mksgnbmchmow4sgh@steredhat.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 03:44:23PM +0200, Stefano Garzarella wrote:
> Hi Arseny,
> the series looks great, I have just a question below about
> seqpacket_dequeue.
> 
> I also sent a couple a simple fixes, it would be great if you can review
> them:
> https://lore.kernel.org/netdev/20210618133526.300347-1-sgarzare@redhat.com/

So given this was picked into net next, what's the plan? Just make spec
follow code? We can wait and see, if there are issues with the spec just
remember to mask the feature before release.

-- 
MST

