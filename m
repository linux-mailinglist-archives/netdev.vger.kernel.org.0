Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B577E143382
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 22:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgATVtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 16:49:09 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47102 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727312AbgATVtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 16:49:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579556947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7XraG6j1N/y3xLCXP92Th/VKfxmhRZrdg4uwGLI/Vm4=;
        b=b/oGc94Ifz3dnXu4d137Zl7ENNiYvuU4emeQUlY3tMmRediIJqph43VyGgpQheQ7O2WUve
        2+BIvmKqb1SMDRfyLPEVzUmgC12oUxdqkKx0/SCyLTRKbNNcP4LI9pabEQuZ0UScWdrO+b
        20jI9Fa3fINNxj5I53n2Y+isZpXdVqY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-KhDpiAQpPYuy7bNLcqy4VA-1; Mon, 20 Jan 2020 16:49:06 -0500
X-MC-Unique: KhDpiAQpPYuy7bNLcqy4VA-1
Received: by mail-qk1-f197.google.com with SMTP id 24so547909qka.16
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 13:49:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7XraG6j1N/y3xLCXP92Th/VKfxmhRZrdg4uwGLI/Vm4=;
        b=ptoeWEPc+Qeb2HPrtgqAiu6s6dFhTY2br9uh2xa/j+Fu2bggF+s6RnuH5g1E0EsceC
         JqyTaLDEa8Tcnc9x4ocb3NgxFBBFkuhlEVB+wBpJW8NOBvP7FyZKhpNef54P18vga5wI
         ikeeedqEPRvSpfs5OC2UuP2eDENhe1nCijOcQAaaMo3BvyqeYdU5K4wcUQAKvQDFR4ic
         glSXi9fGBbrIcVShAHN8ID8EikNKb2k9iTSntpfyjC7zKJNpzupMd4RVoyPNnIlDrZ/h
         azkAsCbU6LSP5+2kqI7xTpzydUosXWaKNMNCld13BZ2tPo+mzXqCqmzc4Vh/9Aee82bO
         zCUw==
X-Gm-Message-State: APjAAAWw2/orPag73e/dcz9NufI3lGvD/GHa0+ER07nfvzUdSUq8fsUW
        2vzUDAJIxuEbdaSUJRsYNVZlk3nc2QDaHMtA3ZbYQa2AHcGEdmaPM3FPrpot0Hbf6j6oGUnKgTw
        O5K+BgotBOlktaNkz
X-Received: by 2002:ad4:478b:: with SMTP id z11mr1807818qvy.185.1579556945808;
        Mon, 20 Jan 2020 13:49:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqxe+TaTURMeMIHCV1YM/fmBzkD8nEfrcjqkwq5BuJERHu3qsEZA9pujZr3ffzD4wXcl90YdAQ==
X-Received: by 2002:ad4:478b:: with SMTP id z11mr1807796qvy.185.1579556945609;
        Mon, 20 Jan 2020 13:49:05 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id g18sm18570113qtc.83.2020.01.20.13.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 13:49:04 -0800 (PST)
Date:   Mon, 20 Jan 2020 16:48:55 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
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
Message-ID: <20200120164756-mutt-send-email-mst@kernel.org>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
 <20200120174933.GB3891@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120174933.GB3891@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 05:49:39PM +0000, Jason Gunthorpe wrote:
> On Mon, Jan 20, 2020 at 04:43:53PM +0800, Jason Wang wrote:
> > This is similar to the design of platform IOMMU part of vhost-vdpa. We
> > decide to send diffs to platform IOMMU there. If it's ok to do that in
> > driver, we can replace set_map with incremental API like map()/unmap().
> > 
> > Then driver need to maintain rbtree itself.
> 
> I think we really need to see two modes, one where there is a fixed
> translation without dynamic vIOMMU driven changes and one that
> supports vIOMMU.
> 
> There are different optimization goals in the drivers for these two
> configurations.
> 
> > > If the first one, then I think memory hotplug is a heavy flow
> > > regardless. Do you think the extra cycles for the tree traverse
> > > will be visible in any way?
> > 
> > I think if the driver can pause the DMA during the time for setting up new
> > mapping, it should be fine.
> 
> This is very tricky for any driver if the mapping change hits the
> virtio rings. :(
> 
> Even a IOMMU using driver is going to have problems with that..
> 
> Jason

I think for starters we can assume this doesn't happen,
so any change doesn't affect any buffers in use.
Certainly true e.g. for memory hotplug.

-- 
MST

