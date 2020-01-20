Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2978B143392
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 22:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgATV7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 16:59:55 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21011 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726752AbgATV7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 16:59:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579557592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uj75GN8qSWP3VVg5lftwGXe8q8yW4gp4PPDyUXL15Kw=;
        b=UVuzl5mnxDZd2+Drvbx5vaJnYlVMb7GiZ+1aptop9NtNVdS4/6Vw/l5sN5vmFnoH+dkr9p
        TmrwRsG7Q72HiWqAUS7OJUwDM7uyZuMHQpEf7Ouu2JigUDO+pJ+DEEZpEAvcI4+ySz2ICQ
        Ne2nYGOxmKLiqPkwNOMpUITba3Omroc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-AeFwS-DEPPOllChwy5AtZw-1; Mon, 20 Jan 2020 16:59:51 -0500
X-MC-Unique: AeFwS-DEPPOllChwy5AtZw-1
Received: by mail-qk1-f200.google.com with SMTP id f22so569783qka.10
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 13:59:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uj75GN8qSWP3VVg5lftwGXe8q8yW4gp4PPDyUXL15Kw=;
        b=ojXlKD7w2RQ13QQ0zGiE5yWDBOtlpScqIeErzP0OBAmtXkdM58bAQsZ4wI2G6+b4PJ
         LGKN+0f1FjONQRn+/xV2OluPXArBFf5x1LwwedygS2BuHJ7y8sz0GTPToHvAl0O+Qm24
         zvliF6kRmfsiQNTbs1+Xd+P1Y5HgsEQbwcda8Z/7NqIhszYYF/A/kaiem4aqKMr35p5D
         lQ+Lm0u+1aGGhHq9Vv54gc+a/vxteQkGK1D+hAEauFqkYSHAl78cQ2pcq71KFJpwunFd
         Mhl04hRRYtu4Vbwxcu3032xFLdBRO2kclMAKmy2VVbLVrEYNTMeNmzdPqZEa/fjsqEmO
         neXQ==
X-Gm-Message-State: APjAAAVQ/rUMnkaxrf2OzZJwFlHTfCx0rq0F0jSH9QCrFukZkBqUjcYK
        HVxrlnOB2RG3Lai28oLJOK4b2d3a4vLQcT4zJov25Mxblh2/3RO0527AQ5BMJwpLKN16SgolaLw
        Jh4YSdLvxtiQb7AUu
X-Received: by 2002:ac8:684:: with SMTP id f4mr1528798qth.184.1579557590685;
        Mon, 20 Jan 2020 13:59:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqz+U1t48ZSvp7yADfjMy519C5Nq/S5aOWS7P9T7zadMKYs3JAMC/9t/X/yUUDCVetw9pP6VzA==
X-Received: by 2002:ac8:124a:: with SMTP id g10mr1502229qtj.303.1579557590069;
        Mon, 20 Jan 2020 13:59:50 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id q2sm16441312qkm.5.2020.01.20.13.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 13:59:49 -0800 (PST)
Date:   Mon, 20 Jan 2020 16:59:40 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Shahaf Shuler <shahafs@mellanox.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Jason Wang <jasowang@redhat.com>,
        Rob Miller <rob.miller@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Ariel Adam <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
Message-ID: <20200120165640-mutt-send-email-mst@kernel.org>
References: <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
 <20200120174933.GB3891@mellanox.com>
 <AM0PR0502MB3795C92485338180FC8059CFC3320@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <20200120162449-mutt-send-email-mst@kernel.org>
 <AM0PR0502MB3795A7BE7F434964D6102517C3320@AM0PR0502MB3795.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR0502MB3795A7BE7F434964D6102517C3320@AM0PR0502MB3795.eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 09:47:18PM +0000, Shahaf Shuler wrote:
> Monday, January 20, 2020 11:25 PM, Michael S. Tsirkin:
> > Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
> > 
> > On Mon, Jan 20, 2020 at 08:51:43PM +0000, Shahaf Shuler wrote:
> > > Monday, January 20, 2020 7:50 PM, Jason Gunthorpe:
> > > > Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
> > > >
> > > > On Mon, Jan 20, 2020 at 04:43:53PM +0800, Jason Wang wrote:
> > > > > This is similar to the design of platform IOMMU part of
> > > > > vhost-vdpa. We decide to send diffs to platform IOMMU there. If
> > > > > it's ok to do that in driver, we can replace set_map with incremental API
> > like map()/unmap().
> > > > >
> > > > > Then driver need to maintain rbtree itself.
> > > >
> > > > I think we really need to see two modes, one where there is a fixed
> > > > translation without dynamic vIOMMU driven changes and one that
> > > > supports vIOMMU.
> > > >
> > > > There are different optimization goals in the drivers for these two
> > > > configurations.
> > >
> > > +1.
> > > It will be best to have one API for static config (i.e. mapping can be
> > > set only before virtio device gets active), and one API for dynamic
> > > changes that can be set after the virtio device is active.
> > 
> > Frankly I don't see when we'd use the static one.
> > Memory hotplug is enabled for most guests...
> 
> The fact memory hotplug is enabled doesn't necessarily means there is not cold-plugged memory on the hot plugged slots. 
> So your claim is majority of guests are deployed w/o any cold-plugged memory? 

Sorry for not being clear. I was merely saying that dynamic one
can't be optional, and static one can. So how about we
start just with the dynamic one, then add the static one
as a later optimization?


> > 
> > > >
> > > > > > If the first one, then I think memory hotplug is a heavy flow
> > > > > > regardless. Do you think the extra cycles for the tree traverse
> > > > > > will be visible in any way?
> > > > >
> > > > > I think if the driver can pause the DMA during the time for
> > > > > setting up new mapping, it should be fine.
> > > >
> > > > This is very tricky for any driver if the mapping change hits the
> > > > virtio rings. :(
> > > >
> > > > Even a IOMMU using driver is going to have problems with that..
> > > >
> > > > Jason

