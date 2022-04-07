Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955344F849A
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345586AbiDGQM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbiDGQMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:12:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CB76A415;
        Thu,  7 Apr 2022 09:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEB2A61F44;
        Thu,  7 Apr 2022 16:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAEBC385A4;
        Thu,  7 Apr 2022 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649347816;
        bh=i/wI2nzdbQUEB94WRWW6f8QcGZr6oohGA822sn6gZF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eVbBbFbyiyzgR20zLG+AnfXVrI5nEGG79xuOPOVMalMxhIGSGEVoKz4Zk0uK6hYA9
         ZjXmnPLmqX+MvdzV+QsQYZfEkumyWyeOCvicUvezw+zRZBxNE+Awinh1hRxGnvb6R0
         CE2CEqtYGmJyCucjKbJiuRfKZISkJABZP6d1a2NTJBVEqrwtkZCa4wq1S/9msusv2d
         h8wmCqOxNpk6rbbTrVQApUZhu+ZMHOzRREJlW6GwcNwIs8d/9JF3sTQGds6ptSAsAO
         4ia9BQBibsx6GwI+Pql5oR6OVE4ikKAodu2gV9J8J9TRcIpghQvpJiGxjm7aUYDN/J
         PSHcKxS6aFCRA==
Date:   Thu, 7 Apr 2022 19:10:12 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Ariel Elior <aelior@marvell.com>,
        Anna Schumaker <anna@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christian Benvenuti <benve@cisco.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Christoph Hellwig <hch@lst.de>,
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
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH v2] RDMA: Split kernel-only global device caps from
 uverbs device caps
Message-ID: <Yk8M5C/7YO7F9sk2@unreal>
References: <0-v2-22c19e565eef+139a-kern_caps_jgg@nvidia.com>
 <ca06d463-cf68-4b6f-8432-a86e34398bf0@acm.org>
 <20220407155244.GP2120790@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407155244.GP2120790@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 12:52:44PM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 06, 2022 at 12:57:31PM -0700, Bart Van Assche wrote:
> > On 4/6/22 12:27, Jason Gunthorpe wrote:
> > > +enum ib_kernel_cap_flags {
> > > +	/*
> > > +	 * This device supports a per-device lkey or stag that can be
> > > +	 * used without performing a memory registration for the local
> > > +	 * memory.  Note that ULPs should never check this flag, but
> > > +	 * instead of use the local_dma_lkey flag in the ib_pd structure,
> > > +	 * which will always contain a usable lkey.
> > > +	 */
> > > +	IBK_LOCAL_DMA_LKEY = 1 << 0,
> > > +	/* IB_QP_CREATE_INTEGRITY_EN is supported to implement T10-PI */
> > > +	IBK_INTEGRITY_HANDOVER = 1 << 1,
> > > +	/* IB_ACCESS_ON_DEMAND is supported during reg_user_mr() */
> > > +	IBK_ON_DEMAND_PAGING = 1 << 2,
> > > +	/* IB_MR_TYPE_SG_GAPS is supported */
> > > +	IBK_SG_GAPS_REG = 1 << 3,
> > > +	/* Driver supports RDMA_NLDEV_CMD_DELLINK */
> > > +	IBK_ALLOW_USER_UNREG = 1 << 4,
> > > +
> > > +	/* ipoib will use IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK */
> > > +	IBK_BLOCK_MULTICAST_LOOPBACK = 1 << 5,
> > > +	/* iopib will use IB_QP_CREATE_IPOIB_UD_LSO for its QPs */
> > > +	IBK_UD_TSO = 1 << 6,
> > > +	/* iopib will use the device ops:
> > > +	 *   get_vf_config
> > > +	 *   get_vf_guid
> > > +	 *   get_vf_stats
> > > +	 *   set_vf_guid
> > > +	 *   set_vf_link_state
> > > +	 */
> > > +	IBK_VIRTUAL_FUNCTION = 1 << 7,
> > > +	/* ipoib will use IB_QP_CREATE_NETDEV_USE for its QPs */
> > > +	IBK_RDMA_NETDEV_OPA = 1 << 8,
> > > +};
> > 
> > Has it been considered to use the kernel-doc syntax? This means moving all
> > comments above "enum ib_kernel_cap_flags {".
> 
> TBH I'm not a huge fan of kdoc for how wordy it is:
> 
>  /** @IBK_RDMA_NETDEV_OPA: ipoib will use IB_QP_CREATE_NETDEV_USE for its QPs */
>  IBK_RDMA_NETDEV_OPA = 1 << 8,
> 
> Is the shortest format and still a bit awkward.
> 
> Given that we don't have a proper kdoc for rdma I haven't been putting
> much energy there.
> 
> If someone came with patches to make a kdoc chapter and start to
> organize it nicely I could see enforcing kdoc format..

Do you see any value in kdoc?

I personally didn't find it useful for kernel at all.

> 
> Jason
