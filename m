Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1AF29A64A
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 09:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508834AbgJ0ILJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 04:11:09 -0400
Received: from verein.lst.de ([213.95.11.211]:37795 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393441AbgJ0ILH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 04:11:07 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C9A7967373; Tue, 27 Oct 2020 09:11:03 +0100 (CET)
Date:   Tue, 27 Oct 2020 09:11:03 +0100
From:   "hch@lst.de" <hch@lst.de>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+34dc2fea3478e659af01@syzkaller.appspotmail.com>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "hch@lst.de" <hch@lst.de>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linaro-mm-sig-owner@lists.linaro.org" 
        <linaro-mm-sig-owner@lists.linaro.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "sumit.semwal@linaro.org" <sumit.semwal@linaro.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: WARNING in dma_map_page_attrs
Message-ID: <20201027081103.GA22877@lst.de>
References: <000000000000335adc05b23300f6@google.com> <000000000000a0f8a305b261fe4a@google.com> <20201024111516.59abc9ec@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <BY5PR12MB4322CC03CE0D34B83269676ADC190@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB4322CC03CE0D34B83269676ADC190@BY5PR12MB4322.namprd12.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 05:23:48AM +0000, Parav Pandit wrote:
> Hi Christoph,
> 
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Saturday, October 24, 2020 11:45 PM
> > 
> > CC: rdma, looks like rdma from the stack trace
> > 
> > On Fri, 23 Oct 2020 20:07:17 -0700 syzbot wrote:
> > > syzbot has found a reproducer for the following issue on:
> > >
> > > HEAD commit:    3cb12d27 Merge tag 'net-5.10-rc1' of git://git.kernel.org/..
> 
> In [1] you mentioned that dma_mask should not be set for dma_virt_ops.
> So patch [2] removed it.
>
> But check to validate the dma mask for all dma_ops was added in [3].
> 
> What is the right way? Did I misunderstood your comment about dma_mask in [1]?

No, I did not say we don't need the mask.  I said copying over the
various dma-related fields from the parent is bogus.

I think rxe (and ther other drivers/infiniband/sw drivers) need a simple
dma_coerce_mask_and_coherent and nothing else.
