Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BA74F22AC
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 07:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiDEFrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 01:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiDEFrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 01:47:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7DD5E15F;
        Mon,  4 Apr 2022 22:45:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30227B81A37;
        Tue,  5 Apr 2022 05:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CB4C340EE;
        Tue,  5 Apr 2022 05:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649137547;
        bh=gRpdesPvnbIGSxebVlyaRkNxgcCbKC3Od+BYMZifZO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WD+JRYvskhSmVVBMnMJw0/1G3H6a+N1C9uZFgKiHbKzNPvqVuI6L5OyuaPIU/GcVK
         p9Ezd99EsWg7F8epR/6qh8MV6eq7SgFXhFUqUug1upndo/Efkq0axblWoZn9JvLHDk
         NmqZsxxMKxC5s07o7hS+Re7Ai9CVbL9JWXZ4WmIn3HtdqclK0tbR58xtxwCEaUuNp4
         liDxWU7q1LiJKHCoGIo3C9Tw7hPvCg+1fKCDf2CEB0PL71aw64iAmFgGZNBJf/OMw9
         DEbVdO/ONbCL1LJqtEdfTkuVGmfBovn1Bkd5w68OE6L/BH3NiohJZN9o1fac11yUrW
         lKSD3HWND6PnA==
Date:   Tue, 5 Apr 2022 08:45:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Ariel Elior <aelior@marvell.com>,
        Anna Schumaker <anna@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christian Benvenuti <benve@cisco.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        target-devel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Xiao Yang <yangx.jy@fujitsu.com>
Subject: Re: [PATCH] RDMA: Split kernel-only global device caps from uvers
 device caps
Message-ID: <YkvXh28E3pLZSNTj@unreal>
References: <0-v1-47e161ac2db9+80f-kern_caps_jgg@nvidia.com>
 <20220405044331.GA22322@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405044331.GA22322@lst.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 06:43:31AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 04, 2022 at 01:18:00PM -0300, Jason Gunthorpe wrote:
> > Split ib_device::device_cap_flags into kernel_cap_flags that holds the
> > flags only used by the kernel.
> > 
> > This cleanly splits out the uverbs flags from the kernel flags to avoid
> > confusion in the flags bitmap.
> 
> > Followup from Xiao Yang's series
> 
> Can you point me to this series?

https://lore.kernel.org/all/20220331032419.313904-1-yangx.jy@fujitsu.com/
https://lore.kernel.org/all/20220331032419.313904-2-yangx.jy@fujitsu.com/

Thanks
