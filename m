Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBE3143F3A
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgAUOR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:17:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50367 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726968AbgAUOR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:17:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579616276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=weYoN+US5pU0ArR581BNHqxlBCJqtsz9O4P+flr6fqg=;
        b=O7yRA6K45XDRe+NlK+2+QxgfD18wWIvicEtKiD9qkOSbeoC6pMSPSnjGYTyX0EpzB3UC56
        5XVI2PwjorVDFI2D6Hmw0FKOubNSJFtBYW+SlUs+SSff3ETkFbY1GiUsjFuv9a2sWp9MXQ
        JV5CLPCOHpZODCI4e7i8dgFJhyLTtsM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-Dn3S9G-2NH2fcHwBxbzJKQ-1; Tue, 21 Jan 2020 09:17:54 -0500
X-MC-Unique: Dn3S9G-2NH2fcHwBxbzJKQ-1
Received: by mail-qk1-f200.google.com with SMTP id f124so1793559qkb.22
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 06:17:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=weYoN+US5pU0ArR581BNHqxlBCJqtsz9O4P+flr6fqg=;
        b=XfKuo5LVihXgCqNHfPEZTqivi3COohld95u5tdHdjaN2hJ+1LNhcPctpruoOMyh6sf
         uoyYzhmczYhbwS7QUgMF452E3P7SD+iDgKNTfml+k75OrG4TOy4sGqnO1sq+ATd7P7O3
         vi8UuVOVVSe0K3f5Ga12FAjL6jFO0Kh9q5HKzxTMfhkCqp32ou3xmuANc3MjK0/iyUO/
         hXe1t0T07mFsPgUDIjuDpgE3rpTTzfmTrwU+Kg9KBmVRSXcvlKktQ2Zq88arlx+IFOJZ
         jaz0lKVvRkC457old4Eb7oSvqEtqeF7Bno913aSt23tQjymiUJqLdpx4Lce7e8aagcbK
         lbrA==
X-Gm-Message-State: APjAAAW8JyVegJr3JPcyIWLbu6UwZpL7F6Xk9FmqIZJEaKasou4mk6Pl
        r0o9EaOhzh4E8k8PKAZVmhaHbUlWrejVCMzNYB94Yw4W/DwO+B1aK88d2axV5PNcM7TtDM5vPsn
        LelvGh1cjitKpFbg+
X-Received: by 2002:a37:ad0e:: with SMTP id f14mr4590850qkm.213.1579616274071;
        Tue, 21 Jan 2020 06:17:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqwj1pwuzC/egPO4VzjPyAoce9o3J4cQVep1NUGRibBObTVNFPOqxPxAnfDJfRf0s0obsdxWcg==
X-Received: by 2002:a37:ad0e:: with SMTP id f14mr4590813qkm.213.1579616273755;
        Tue, 21 Jan 2020 06:17:53 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id u4sm17072928qkh.59.2020.01.21.06.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 06:17:53 -0800 (PST)
Date:   Tue, 21 Jan 2020 09:17:45 -0500
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
Message-ID: <20200121091636-mutt-send-email-mst@kernel.org>
References: <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
 <20200120174933.GB3891@mellanox.com>
 <2a324cec-2863-58f4-c58a-2414ee32c930@redhat.com>
 <20200121004047-mutt-send-email-mst@kernel.org>
 <b9ad744e-c4cd-82f9-f56a-1ecc185e9cd7@redhat.com>
 <20200121031506-mutt-send-email-mst@kernel.org>
 <20200121140456.GA12330@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121140456.GA12330@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 02:05:04PM +0000, Jason Gunthorpe wrote:
> On Tue, Jan 21, 2020 at 03:15:43AM -0500, Michael S. Tsirkin wrote:
> > > This sounds more flexible e.g driver may choose to implement static mapping
> > > one through commit. But a question here, it looks to me this still requires
> > > the DMA to be synced with at least commit here. Otherwise device may get DMA
> > > fault? Or device is expected to be paused DMA during begin?
> > > 
> > > Thanks
> > 
> > For example, commit might switch one set of tables for another,
> > without need to pause DMA.
> 
> I'm not aware of any hardware that can do something like this
> completely atomically..

FWIW VTD can do this atomically.

> Any mapping change API has to be based around add/remove regions
> without any active DMA (ie active DMA is a guest error the guest can
> be crashed if it does this)
> 
> Jason

Right, lots of cases are well served by only changing parts of
mapping that aren't in active use. Memory hotplug is such a case.
That's not the same as a completely static mapping.

-- 
MST

