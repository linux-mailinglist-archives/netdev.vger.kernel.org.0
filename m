Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6CC89F18
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 15:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfHLNCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 09:02:54 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33860 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfHLNCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 09:02:54 -0400
Received: by mail-qt1-f195.google.com with SMTP id q4so5485905qtp.1
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 06:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=I794i5k43EsX/FqVLogBrtzHtLMobYzeCJsdWXiK9Gc=;
        b=VMgdsQq00foWkXG/3nO+dBstUoK1bGkCBdbj9tS6O2XJlAF+Gd74zMHMUkA+Njtq4M
         1/R9J5gzrQ28tiWtpEqv2TjemV4M0eUiyIrSXf3PQ8hy0bwMcgJk12CEU13SqDS3og6j
         JNN5DHxPwGYfzdPhRKhbUFwfch3e+YN+7HQiep9xP8CG++3zdsw5PnkTxkB2wXiq4SvK
         Jc/cZ3HS14Cb68kj4QXOugj+o8lOW80EABX+K7Y83ls68HVVwPHmyEC64WGA0jWTztDl
         Bgnp7cqMgeUbOoIkbiXSIXIHXYfgIR+WzAN3wNxJXn3/4k/pz1vaR9bWK24wuzC3Bdl/
         +Scg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=I794i5k43EsX/FqVLogBrtzHtLMobYzeCJsdWXiK9Gc=;
        b=HlNFmohXoeZqdWrT9JFwkMIv1syKqfLaHvmcvcAFyMgO6yxKVJrHHbH2UDPuC+Hktv
         oEPwKUnpbUFLhj2J9jU4LYjQjs5EEhNBS4KvpRVsf9EbEfsOiznDQyn5RVuVeJSaR1s6
         x3540pyDxNTAp/hHf5UO35+5gwVFJZmUCoSJOAHYZhUOHmVZVzUUxBXqYAUUXug5PTEe
         7GTH0Y72gzaRO6K8CwMFrrUN1yqPUkZRwdVQExhpFQK08MfMxQ+V/gAiKYj4g015rVtY
         jX3tbfYk2koPf8OxgaZxnUIabQsD5yfmmi9sSoIloQXbN6IX58W4JY2Y48Por6d80tAa
         P7OA==
X-Gm-Message-State: APjAAAXyxXytvT0iAXanZ9ryLHN7suGX289qXfpvh0+YTxjDtfevN8uF
        rqIY+LWNjntHGTPUChOZHfEofQ==
X-Google-Smtp-Source: APXvYqxZv3qaTOwcS5IthcJTSrZw2AL6CRuxLGSASG1s5/gI7k9gv8676nfdtEsaySWFu9y0gecVIg==
X-Received: by 2002:a0c:f687:: with SMTP id p7mr8778029qvn.160.1565614973155;
        Mon, 12 Aug 2019 06:02:53 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id f22sm42714130qkk.45.2019.08.12.06.02.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 12 Aug 2019 06:02:52 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hx9yO-0007Sg-5c; Mon, 12 Aug 2019 10:02:52 -0300
Date:   Mon, 12 Aug 2019 10:02:52 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V5 0/9] Fixes for vhost metadata acceleration
Message-ID: <20190812130252.GE24457@ziepe.ca>
References: <20190809054851.20118-1-jasowang@redhat.com>
 <20190810134948-mutt-send-email-mst@kernel.org>
 <360a3b91-1ac5-84c0-d34b-a4243fa748c4@redhat.com>
 <20190812054429-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190812054429-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 05:49:08AM -0400, Michael S. Tsirkin wrote:
> On Mon, Aug 12, 2019 at 10:44:51AM +0800, Jason Wang wrote:
> > 
> > On 2019/8/11 上午1:52, Michael S. Tsirkin wrote:
> > > On Fri, Aug 09, 2019 at 01:48:42AM -0400, Jason Wang wrote:
> > > > Hi all:
> > > > 
> > > > This series try to fix several issues introduced by meta data
> > > > accelreation series. Please review.
> > > > 
> > > > Changes from V4:
> > > > - switch to use spinlock synchronize MMU notifier with accessors
> > > > 
> > > > Changes from V3:
> > > > - remove the unnecessary patch
> > > > 
> > > > Changes from V2:
> > > > - use seqlck helper to synchronize MMU notifier with vhost worker
> > > > 
> > > > Changes from V1:
> > > > - try not use RCU to syncrhonize MMU notifier with vhost worker
> > > > - set dirty pages after no readers
> > > > - return -EAGAIN only when we find the range is overlapped with
> > > >    metadata
> > > > 
> > > > Jason Wang (9):
> > > >    vhost: don't set uaddr for invalid address
> > > >    vhost: validate MMU notifier registration
> > > >    vhost: fix vhost map leak
> > > >    vhost: reset invalidate_count in vhost_set_vring_num_addr()
> > > >    vhost: mark dirty pages during map uninit
> > > >    vhost: don't do synchronize_rcu() in vhost_uninit_vq_maps()
> > > >    vhost: do not use RCU to synchronize MMU notifier with worker
> > > >    vhost: correctly set dirty pages in MMU notifiers callback
> > > >    vhost: do not return -EAGAIN for non blocking invalidation too early
> > > > 
> > > >   drivers/vhost/vhost.c | 202 +++++++++++++++++++++++++-----------------
> > > >   drivers/vhost/vhost.h |   6 +-
> > > >   2 files changed, 122 insertions(+), 86 deletions(-)
> > > This generally looks more solid.
> > > 
> > > But this amounts to a significant overhaul of the code.
> > > 
> > > At this point how about we revert 7f466032dc9e5a61217f22ea34b2df932786bbfc
> > > for this release, and then re-apply a corrected version
> > > for the next one?
> > 
> > 
> > If possible, consider we've actually disabled the feature. How about just
> > queued those patches for next release?
> > 
> > Thanks
> 
> Sorry if I was unclear. My idea is that
> 1. I revert the disabled code
> 2. You send a patch readding it with all the fixes squashed
> 3. Maybe optimizations on top right away?
> 4. We queue *that* for next and see what happens.
> 
> And the advantage over the patchy approach is that the current patches
> are hard to review. E.g.  it's not reasonable to ask RCU guys to review
> the whole of vhost for RCU usage but it's much more reasonable to ask
> about a specific patch.

I think there are other problems here too, I don't like that the use
of mmu notifiers is so different from every other driver, or that GUP
is called under spinlock.

So I favor the revert and try again approach as well. It is hard to
get a clear picture with these endless bug fix patches

Jason
