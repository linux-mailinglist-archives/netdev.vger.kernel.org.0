Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFC77AC7D
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 17:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732451AbfG3PiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 11:38:09 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34802 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730358AbfG3PiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 11:38:08 -0400
Received: by mail-wm1-f66.google.com with SMTP id w9so45568426wmd.1
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 08:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=+V7Ycpw0BpHnpfdUJNk0+mUgrmqws4rmdWBhU3jRPak=;
        b=b/z0d7GKg9z+X/deLmZjU935RsXsnClmJkWFHx4F4Ix3Il5XfOVvZHc0Q2dgsxV8bs
         wq6zaVtfgrQqrIYeW8g8QzzbdrPolh6P28RvrAYr0/lz2zCNHQ/xEm9pWY5w+d+lIaNC
         FPG3COYfpZsHKrKa9ur8Q2/1ADggRBlorNINOSXYYMSi+uB7THpH9ih/81PGXT3kVzSD
         XLb19S1dxo7Mo2SlpqX43urWjtCpN64ByVAGvsfXk4+a7BrQ5EZDJo0m5gzTnErztfh/
         wiMUVv4or1jHTrDAnvVV4UlcDKsFYy/2nWzZiGYEnKT5mIqhbRIKqUZv2hWXp2GWmu77
         JD8w==
X-Gm-Message-State: APjAAAUOvsffkfg2fBS27qRddeTJs8601gOgQPE63qLjCVKS5aPUjZ1O
        F23qYxmWOI3HdaDH0cQbvW4USA==
X-Google-Smtp-Source: APXvYqzl/+3onAWYKDAvYxlWjOt0dpZaL10v8LdZHXOcP0ynq8N8FAuHDBrbBG+gxlVDb61R4WP+1w==
X-Received: by 2002:a1c:2d8b:: with SMTP id t133mr105582983wmt.57.1564501086525;
        Tue, 30 Jul 2019 08:38:06 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id b19sm46496455wmj.13.2019.07.30.08.38.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 08:38:05 -0700 (PDT)
Date:   Tue, 30 Jul 2019 17:38:03 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 0/5] vsock/virtio: optimizations to increase the
 throughput
Message-ID: <20190730153803.qxilmuvaylzyeqi4@steredhat>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190729095743-mutt-send-email-mst@kernel.org>
 <20190730094013.ruqjllqrjmkdnh5y@steredhat>
 <fc568e3d-7af5-5895-89e8-32e35b0f9af4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fc568e3d-7af5-5895-89e8-32e35b0f9af4@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 06:03:24PM +0800, Jason Wang wrote:
> 
> On 2019/7/30 下午5:40, Stefano Garzarella wrote:
> > On Mon, Jul 29, 2019 at 09:59:23AM -0400, Michael S. Tsirkin wrote:
> > > On Wed, Jul 17, 2019 at 01:30:25PM +0200, Stefano Garzarella wrote:
> > > > This series tries to increase the throughput of virtio-vsock with slight
> > > > changes.
> > > > While I was testing the v2 of this series I discovered an huge use of memory,
> > > > so I added patch 1 to mitigate this issue. I put it in this series in order
> > > > to better track the performance trends.
> > > Series:
> > > 
> > > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > > 
> > > Can this go into net-next?
> > > 
> > I think so.
> > Michael, Stefan thanks to ack the series!
> > 
> > Should I resend it with net-next tag?
> > 
> > Thanks,
> > Stefano
> 
> 
> I think so.

Okay, I'll resend it!

Thanks,
Stefano
