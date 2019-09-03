Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4C7A631A
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 09:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfICHwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 03:52:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34272 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727999AbfICHwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 03:52:31 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D515A85543
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 07:52:30 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id d9so18165205qko.8
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 00:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xgXUEt0EG11zEupkHnOGVQFJLT+xonOin/Bks/3F7us=;
        b=QrxYeGwLQgwQaeZDrsC7/NiUQ8CgzMYobPn/PFrtqKOaAXu3P+aScz+UecH7jH5yMI
         ZyR+b3wbeKytBE9VQsogHMNolZJpqI+TEUY2DGK4t1w/Kiw56MMdG3SBUe8znmeRCcMr
         Z8jxqJ1ujiumkIUnItSh3GwxTd2x1x+eCWxYHZc6BtHYWDjJ42UY64eFimU07t++s46k
         xMqLBnP/vqTaM1KRVqOCHk8pqvcEp3M/rSZQE9Ou4ArRReq+5pejRBzUhrQUoW9VIDBa
         meL7PnL6/vs216ssdWQk3Cf+Yl3MPVVR/bIduv3RJAtmz8gWsQr3eoqrzGGsUDZkOb/y
         hTFQ==
X-Gm-Message-State: APjAAAXVbLOI9ol1rlu55OqPoNqDk/MSAe1RtMDXsjyzT7gF4GN6lAI6
        mlEYHRl/UtVzPiRZ/3o8yeevTBHz2+Xq+QEyplnklhh/s398D5g/ZbNvByZjnC6APcrHlb3kgny
        QlSl0BUKgTBgmqiZI
X-Received: by 2002:a37:5844:: with SMTP id m65mr11138656qkb.8.1567497150226;
        Tue, 03 Sep 2019 00:52:30 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxPKf56D4zulPkjS1uniJi2ZthFcDbuCfyyWQiloLWW+r84IVWn8HgdNxVCd23C2u8N+9ZKag==
X-Received: by 2002:a37:5844:: with SMTP id m65mr11138647qkb.8.1567497150074;
        Tue, 03 Sep 2019 00:52:30 -0700 (PDT)
Received: from redhat.com (bzq-79-180-62-110.red.bezeqint.net. [79.180.62.110])
        by smtp.gmail.com with ESMTPSA id d45sm5358006qtc.70.2019.09.03.00.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 00:52:29 -0700 (PDT)
Date:   Tue, 3 Sep 2019 03:52:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190903034747-mutt-send-email-mst@kernel.org>
References: <20190730093539.dcksure3vrykir3g@steredhat>
 <20190730163807-mutt-send-email-mst@kernel.org>
 <20190801104754.lb3ju5xjfmnxioii@steredhat>
 <20190801091106-mutt-send-email-mst@kernel.org>
 <20190801133616.sik5drn6ecesukbb@steredhat>
 <20190901025815-mutt-send-email-mst@kernel.org>
 <20190901061707-mutt-send-email-mst@kernel.org>
 <20190902095723.6vuvp73fdunmiogo@steredhat>
 <20190903003823-mutt-send-email-mst@kernel.org>
 <20190903074554.mq6spyivftuodahy@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903074554.mq6spyivftuodahy@steredhat>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 09:45:54AM +0200, Stefano Garzarella wrote:
> On Tue, Sep 03, 2019 at 12:39:19AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Sep 02, 2019 at 11:57:23AM +0200, Stefano Garzarella wrote:
> > > > 
> > > > Assuming we miss nothing and buffers < 4K are broken,
> > > > I think we need to add this to the spec, possibly with
> > > > a feature bit to relax the requirement that all buffers
> > > > are at least 4k in size.
> > > > 
> > > 
> > > Okay, should I send a proposal to virtio-dev@lists.oasis-open.org?
> > 
> > How about we also fix the bug for now?
> 
> This series unintentionally fix the bug because we are introducing a way
> to split the packet depending on the buffer size ([PATCH 4/5] vhost/vsock:
> split packets to send using multiple buffers) and we removed the limit
> to 4K buffers ([PATCH 5/5] vsock/virtio: change the maximum packet size
> allowed).
> 
> I discovered that there was a bug while we discussed memory accounting.
> 
> Do you think it's enough while we introduce the feature bit in the spec?
> 
> Thanks,
> Stefano

Well locking is also broken (patch 3/5).  It seems that 3/5 and 4/5 work
by themselves, right?  So how about we ask Dave to send these to stable?
Also, how about 1/5? Also needed for stable?


-- 
MST
