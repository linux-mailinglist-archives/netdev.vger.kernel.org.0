Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 249A41A0AD2
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 12:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgDGKI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 06:08:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34264 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726562AbgDGKI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 06:08:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586254137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z+d4Qx7H0BkaQ6jx/a91Q5D/w2sYbHgdntEiY9YRCI4=;
        b=QQzxlYeoIXLIC8aflNX1h/t/R+R3f3xXGUnyX44KKk/YoyhzY55ltr1tUgnJckE6crShQS
        gPpgeI2x6DwTjfabOJDcPYusPylWjNusHw903JGUujckyoY7JcxNRs/47/p+XJOnhfqXQd
        /8S9onyxxeHRdrc/XEIhOsrwoSU6usc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-FfrQDsRkOECRlb69Uv7Nhg-1; Tue, 07 Apr 2020 06:08:55 -0400
X-MC-Unique: FfrQDsRkOECRlb69Uv7Nhg-1
Received: by mail-wr1-f70.google.com with SMTP id 88so1520632wrq.4
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 03:08:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z+d4Qx7H0BkaQ6jx/a91Q5D/w2sYbHgdntEiY9YRCI4=;
        b=RJRha2iM3BOyiV5DcnhvKfzEbgtmWti3bp2fsz8/5tFXnNcTeojkA7wmFk1rhLCZ9B
         AeqxbZEwmAR8xGbX9nNdmrREY5CZUD+lqBPFnUQNVv3410rNak8AqHb75NWwdBLNAljw
         XZ5UEe0gmJzT/8s7GiqcX6QY6GKEqrOJyzT0SM4VJ7Rki1VZD1PKtmXJhhEGC+2RH3Fn
         Sk3sorS7U6WHRjVhyR3/8Dc79BB1O068qbZGgXSvPQ7LM2v/mSbLeO7ZAIsTQ5pLpSQf
         0u++2VHeen67GoPAcBgBWxb+gmX4Y3Geb9z1yMLvPq92ZDGTVIZ1346ljJVc54toSzxm
         SNeA==
X-Gm-Message-State: AGi0PubFOFv02mhNPAiTdS6Yq43HHNix+LFbiLi50liyCXq7pG4uHCux
        f9EalQ91bgok0gIYjk0bmOc485mZlieulyTzQQspOnq/wpUwFZd848EdgDXnEaYaFGtemmjOTAe
        vQ1QQ1aDQsQ4YJQhy
X-Received: by 2002:a05:600c:2c47:: with SMTP id r7mr1583545wmg.50.1586254134335;
        Tue, 07 Apr 2020 03:08:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypJjB2szx0xQgD9OibxDJRFX1Jm7Z1KhFoXl8BhDzxrbWSAltbqVX49bIubsJYfEtbHFRe8h+g==
X-Received: by 2002:a05:600c:2c47:: with SMTP id r7mr1583516wmg.50.1586254134095;
        Tue, 07 Apr 2020 03:08:54 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id n64sm1571755wme.45.2020.04.07.03.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 03:08:53 -0700 (PDT)
Date:   Tue, 7 Apr 2020 06:08:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexander.h.duyck@linux.intel.com, eperezma@redhat.com,
        jasowang@redhat.com, lingshan.zhu@intel.com, mhocko@kernel.org,
        namit@vmware.com, rdunlap@infradead.org, rientjes@google.com,
        tiwei.bie@intel.com, tysand@google.com, wei.w.wang@intel.com,
        xiao.w.wang@intel.com, yuri.benditovich@daynix.com
Subject: Re: [GIT PULL v2] vhost: cleanups and fixes
Message-ID: <20200407060741-mutt-send-email-mst@kernel.org>
References: <20200407055334-mutt-send-email-mst@kernel.org>
 <00a7ce5f-8fb4-8c3e-7113-9a422682abdf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00a7ce5f-8fb4-8c3e-7113-9a422682abdf@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 07, 2020 at 11:56:59AM +0200, David Hildenbrand wrote:
> On 07.04.20 11:53, Michael S. Tsirkin wrote:
> > Changes from PULL v1:
> > 	reverted a commit that was also in Andrew Morton's tree,
> > 	to resolve a merge conflict:
> > 	this is what Stephen Rothwell was doing to resolve it
> > 	in linux-next.
> > 
> > 
> > Now that many more architectures build vhost, a couple of these (um, and
> > arm with deprecated oabi) have reported build failures with randconfig,
> > however fixes for that need a bit more discussion/testing and will be
> > merged separately.
> > 
> > Not a regression - these previously simply didn't have vhost at all.
> > Also, there's some DMA API code in the vdpa simulator is hacky - if no
> > solution surfaces soon we can always disable it before release:
> > it's not a big deal either way as it's just test code.
> > 
> > 
> > The following changes since commit 16fbf79b0f83bc752cee8589279f1ebfe57b3b6e:
> > 
> >   Linux 5.6-rc7 (2020-03-22 18:31:56 -0700)
> > 
> > are available in the Git repository at:
> > 
> >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > 
> > for you to fetch changes up to 835a6a649d0dd1b1f46759eb60fff2f63ed253a7:
> > 
> >   virtio-balloon: Revert "virtio-balloon: Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM" (2020-04-07 05:44:57 -0400)
> > 
> > ----------------------------------------------------------------
> > virtio: fixes, vdpa
> > 
> > Some bug fixes.
> > The new vdpa subsystem with two first drivers.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > ----------------------------------------------------------------
> > David Hildenbrand (1):
> >       virtio-balloon: Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM
> 
> ^ stale leftover in this message only I assume

No - I did not rebase since I did not want to invalidate all the testing
people did, just tacked a revert on top.  So this commit is there
together with its revert.


> 
> -- 
> Thanks,
> 
> David / dhildenb

