Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064BF8F4AD
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732561AbfHOTdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:33:09 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42858 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732499AbfHOTdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:33:04 -0400
Received: by mail-qt1-f194.google.com with SMTP id t12so3543093qtp.9
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 12:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=d/Vs2YH0f5xNou4jHOnIZOohEAfDIJUopBMHuRVrEaM=;
        b=DSQnzP2boVVz05frK9Rf9m+2jw7zFPx+9AUXj2jqSyufMDNrAKls4vo+Fb+WrAEgvO
         ktfk/TjL4ijraP2CEooza64EfLjaFdcqjeQ5Vv3suWLQE3AFJsd5YcPid89lanEu0ZoG
         VOQYC/bNeGf1IZi2CVdyacQhQw7JiSZnXckYhCGW/PB/p43g8HasbOXkyAfk/T5vpF3D
         xiyWjGC5nu7KpcLH5DDONB00uambPQIgUVk3jQbczWBzrPFHJZNpEMI+ZlEgjUg+75rH
         LjzpVx3i2jLsC6X0ifOF/LcBrXk/+s6IlAd5gRScNQG9jSmLI4mn6ct4mUNoFB6ybWFo
         /qdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=d/Vs2YH0f5xNou4jHOnIZOohEAfDIJUopBMHuRVrEaM=;
        b=r5nE5B33COTMUnM1WtTDEeqhU5x6rcPE6C2UUxInWaNEE+AcL0kWwwj9d+kttTeJjf
         haxFEsvGjpGv6iJl7kzkueLgAGiMP738M72uQsJGNKbYwy4U7WNytoyWB+1Sj9ru3bir
         TNGgCidEt3V9TzXAfaE7zYFvD8dLzDs9RtnOuz5MOuH8df0OyhtzDRA04RkHYOTunGyW
         gqUQKrZ3722Oa5jAKu2LWSEhyUQTDciQwRSyvCp1w2z+4QuS2Avq0aV3G4is+X5ZzlAg
         SFq4xJ8FAsO2XJ+lKCv6/qvIPxeppx0zKlrLRCQahie/AnquUrcEwXsCoGoTnxOI5j+t
         8bQA==
X-Gm-Message-State: APjAAAVI6zF8HMgrpo0RDYbt60ekM0FeVor4WzA3si6AfL43pZAkdHA6
        VsThmP+zi0CQTYtBvneHuqu8bQ==
X-Google-Smtp-Source: APXvYqzizPYl2LrtkxXjbmjRPnD30yqIwKDY6KgNsz0NbhIueWjJnIkysTmtYLAdQWA6iei+yUmzJQ==
X-Received: by 2002:ac8:5343:: with SMTP id d3mr5516461qto.50.1565897583402;
        Thu, 15 Aug 2019 12:33:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id s4sm1862094qkb.130.2019.08.15.12.33.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Aug 2019 12:33:03 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hyLUc-0008Aa-AF; Thu, 15 Aug 2019 16:33:02 -0300
Date:   Thu, 15 Aug 2019 16:33:02 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V5 0/9] Fixes for vhost metadata acceleration
Message-ID: <20190815193302.GT21596@ziepe.ca>
References: <20190809054851.20118-1-jasowang@redhat.com>
 <20190810134948-mutt-send-email-mst@kernel.org>
 <360a3b91-1ac5-84c0-d34b-a4243fa748c4@redhat.com>
 <20190812054429-mutt-send-email-mst@kernel.org>
 <20190812130252.GE24457@ziepe.ca>
 <9a9641fe-b48f-f32a-eecc-af9c2f4fbe0e@redhat.com>
 <20190813115707.GC29508@ziepe.ca>
 <74838e61-3a5e-0f51-2092-f4a16d144b45@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74838e61-3a5e-0f51-2092-f4a16d144b45@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 11:26:46AM +0800, Jason Wang wrote:
> 
> On 2019/8/13 下午7:57, Jason Gunthorpe wrote:
> > On Tue, Aug 13, 2019 at 04:31:07PM +0800, Jason Wang wrote:
> > 
> > > What kind of issues do you see? Spinlock is to synchronize GUP with MMU
> > > notifier in this series.
> > A GUP that can't sleep can't pagefault which makes it a really weird
> > pattern
> 
> 
> My understanding is __get_user_pages_fast() assumes caller can fail or have
> fallback. And we have graceful fallback to copy_{to|from}_user().

My point is that if you can fall back to copy_user then it is weird to
call the special non-sleeping GUP under a spinlock.

AFAIK the only reason this is done is because of the way the notifier
is being locked...

Jason
