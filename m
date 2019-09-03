Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8249CA634A
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 10:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfICIAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 04:00:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbfICIAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 04:00:45 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5EAE57BDA7
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 08:00:45 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id n6so8105747wrm.20
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 01:00:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=km45+BEk3dwp3Utn2bSkKzNYGd4+gITECdfMrKLm8PQ=;
        b=jU8v/pWzvqQuD4B/acOd6Swqfm/ED2KOnOOKaknBG0AeRquOFLYWMowlfZ3nvnzujB
         rTWK3e67a6k91wWZ08WKJo+0OVSGEOKd0LjLwptkPm26VA75ylDDxYircFRKjSXIdvST
         Ub2rbCe3wPP1WSMIyvN5CvOoiwBSgW+/OIxdDAOqeuPZIV4ZD1zIat8ZZnmtLYQLO8mP
         WgQ+XoNJfmBXdI9pTufG4eBeWpeXaTuqZesFicjVQwrs/ShBEVbcTwUvXieMz9bCYJ2m
         lo3RLkllNsHLrPZs3ZcPzWQJ4MGB+xdX6m6Z8m74IemPsy1JYNKDRmGU4XO2JrnbuxAm
         ByFw==
X-Gm-Message-State: APjAAAXO5gikjEjueKlULfXCsefBKBRJSLZ4YuYWWXfNeT/fV8wlrKuw
        Hc62VfXdOd+ZQ+IUZ9c+XxJ8GcaGBiJMrOsVGXeFU98dW7Chb/5lxr93BrL75gm+KNjl6cnT9ks
        aA2v/hALM456mrJRY
X-Received: by 2002:adf:ec48:: with SMTP id w8mr7118767wrn.198.1567497644031;
        Tue, 03 Sep 2019 01:00:44 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxMsaernHW7gP4+VmWPWrfNSo8Uzvmt4xAnmZkVHcbrUv+Po6RA+io+GPiFHKNQgzEQGBpXBw==
X-Received: by 2002:adf:ec48:: with SMTP id w8mr7118749wrn.198.1567497643808;
        Tue, 03 Sep 2019 01:00:43 -0700 (PDT)
Received: from steredhat (host170-61-dynamic.36-79-r.retail.telecomitalia.it. [79.36.61.170])
        by smtp.gmail.com with ESMTPSA id a7sm31638025wra.43.2019.09.03.01.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 01:00:43 -0700 (PDT)
Date:   Tue, 3 Sep 2019 10:00:40 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190903080040.pfsxrlhcny6xyfee@steredhat>
References: <20190730163807-mutt-send-email-mst@kernel.org>
 <20190801104754.lb3ju5xjfmnxioii@steredhat>
 <20190801091106-mutt-send-email-mst@kernel.org>
 <20190801133616.sik5drn6ecesukbb@steredhat>
 <20190901025815-mutt-send-email-mst@kernel.org>
 <20190901061707-mutt-send-email-mst@kernel.org>
 <20190902095723.6vuvp73fdunmiogo@steredhat>
 <20190903003823-mutt-send-email-mst@kernel.org>
 <20190903074554.mq6spyivftuodahy@steredhat>
 <20190903034747-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903034747-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 03:52:24AM -0400, Michael S. Tsirkin wrote:
> On Tue, Sep 03, 2019 at 09:45:54AM +0200, Stefano Garzarella wrote:
> > On Tue, Sep 03, 2019 at 12:39:19AM -0400, Michael S. Tsirkin wrote:
> > > On Mon, Sep 02, 2019 at 11:57:23AM +0200, Stefano Garzarella wrote:
> > > > > 
> > > > > Assuming we miss nothing and buffers < 4K are broken,
> > > > > I think we need to add this to the spec, possibly with
> > > > > a feature bit to relax the requirement that all buffers
> > > > > are at least 4k in size.
> > > > > 
> > > > 
> > > > Okay, should I send a proposal to virtio-dev@lists.oasis-open.org?
> > > 
> > > How about we also fix the bug for now?
> > 
> > This series unintentionally fix the bug because we are introducing a way
> > to split the packet depending on the buffer size ([PATCH 4/5] vhost/vsock:
> > split packets to send using multiple buffers) and we removed the limit
> > to 4K buffers ([PATCH 5/5] vsock/virtio: change the maximum packet size
> > allowed).
> > 
> > I discovered that there was a bug while we discussed memory accounting.
> > 
> > Do you think it's enough while we introduce the feature bit in the spec?
> > 
> > Thanks,
> > Stefano
> 
> Well locking is also broken (patch 3/5).  It seems that 3/5 and 4/5 work
> by themselves, right?  So how about we ask Dave to send these to stable?

Yes, they work by themselves and I agree that should be send to stable.

> Also, how about 1/5? Also needed for stable?

I think so, without this patch if we flood the guest with 1-byte packets,
we can consume ~ 1 GB of guest memory per-socket.

Thanks,
Stefano
