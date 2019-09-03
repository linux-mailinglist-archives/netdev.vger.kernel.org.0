Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6885A62FB
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 09:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbfICHqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 03:46:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbfICHqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 03:46:00 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD6805AFDE
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 07:45:59 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id h3so9981884wrw.7
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 00:45:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=afLRR+Y6/XWNAyGbBu630m0eglXDmP7UhfuV7wpot38=;
        b=IxBbv9awGyntbzeDlktzhI2EooAgCvfu2wZeo4kqtJeekNR2lh5h2b2KF3vMbpOPUG
         1jsR91BXbtE8k9a0W9d3X7aTzX4EqeAIjoNOh3OmZsRaXGOfSKovDfc8Uln61rvGwCKS
         vR2TVfdU2YebjCfBN3CkIryPJ9OqqoJMyCZeqdM0OYxCOp87A+s+C/XrUNoQiGdHjSBV
         LVi7R/1fM8Q5WhIyQAyQwME2Ab3B4MErKm4r6TToA0e8MF2k52Bfqs4f38hk7YjVrcIh
         I5nd35fUe+LC4YG7KzEbqWJ+1/4tl48yphy2R3t+9SToOiHZvwmY1vZHwKKuk4sz7Cig
         Hy8g==
X-Gm-Message-State: APjAAAV1IdMRM/PcKoZq0+RLCMNFhzyrUZoOAoTf2jvWAByp5Amt1NWf
        hqRoaD5RMYYJsCf139X/s4FDWgb/TQBxv0xHxIhpZy0Q1aPqOBuHmD17SBFm47XdDFEGu78YsZk
        ICPXCETcMTO6IaDTY
X-Received: by 2002:a1c:984b:: with SMTP id a72mr15750240wme.149.1567496758380;
        Tue, 03 Sep 2019 00:45:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx9640LTLNpf5tgrM8awc95gC1ytFwievAzkPz7D7FKlbtNZiw8m+0po4nQhhx9AFdnL0h8rA==
X-Received: by 2002:a1c:984b:: with SMTP id a72mr15750224wme.149.1567496758176;
        Tue, 03 Sep 2019 00:45:58 -0700 (PDT)
Received: from steredhat (host170-61-dynamic.36-79-r.retail.telecomitalia.it. [79.36.61.170])
        by smtp.gmail.com with ESMTPSA id l62sm41378400wml.13.2019.09.03.00.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 00:45:57 -0700 (PDT)
Date:   Tue, 3 Sep 2019 09:45:54 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190903074554.mq6spyivftuodahy@steredhat>
References: <20190729143622-mutt-send-email-mst@kernel.org>
 <20190730093539.dcksure3vrykir3g@steredhat>
 <20190730163807-mutt-send-email-mst@kernel.org>
 <20190801104754.lb3ju5xjfmnxioii@steredhat>
 <20190801091106-mutt-send-email-mst@kernel.org>
 <20190801133616.sik5drn6ecesukbb@steredhat>
 <20190901025815-mutt-send-email-mst@kernel.org>
 <20190901061707-mutt-send-email-mst@kernel.org>
 <20190902095723.6vuvp73fdunmiogo@steredhat>
 <20190903003823-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903003823-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 12:39:19AM -0400, Michael S. Tsirkin wrote:
> On Mon, Sep 02, 2019 at 11:57:23AM +0200, Stefano Garzarella wrote:
> > > 
> > > Assuming we miss nothing and buffers < 4K are broken,
> > > I think we need to add this to the spec, possibly with
> > > a feature bit to relax the requirement that all buffers
> > > are at least 4k in size.
> > > 
> > 
> > Okay, should I send a proposal to virtio-dev@lists.oasis-open.org?
> 
> How about we also fix the bug for now?

This series unintentionally fix the bug because we are introducing a way
to split the packet depending on the buffer size ([PATCH 4/5] vhost/vsock:
split packets to send using multiple buffers) and we removed the limit
to 4K buffers ([PATCH 5/5] vsock/virtio: change the maximum packet size
allowed).

I discovered that there was a bug while we discussed memory accounting.

Do you think it's enough while we introduce the feature bit in the spec?

Thanks,
Stefano
