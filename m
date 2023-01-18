Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B1E671567
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjARHtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjARHsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:48:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D82F45F46;
        Tue, 17 Jan 2023 23:17:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDA42B81B3E;
        Wed, 18 Jan 2023 07:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB21C433EF;
        Wed, 18 Jan 2023 07:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674026236;
        bh=TPFbez4kRFQWTS4pIsn2TRE2Yeh3bO7Q6hZYSQ1W6pw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gBE1GvKyWgekNTYsa39JH90glVPf/zresTYnQ0oYxuizvsX6fM5mfbTi+0R6Ij98l
         YyaDFKnsM6lTyQmL6e2hpKrsC5rvStWq4oOvBnVVT0o/wKzFhIVItTIkr2TYxKT23l
         7rqy5WkpcyR27VdIF1yTxHowykDskkvhjoUUG53ZfOQR2moXA8Jxhb1pFtb7BfhQWW
         P0tpyi+0OtQuTEKt00PruI9rK9RKu8zppqgEd/TVL/h3TTTQsh2MB7hpZmsviYbo8P
         vLSJorCADin7THDqDQl/r4t7iaa9cPH75VNP1IT+BlbB2MeyX2Jv7uPewvM9XoZFkR
         ObUnV48z0C9Bg==
Date:   Tue, 17 Jan 2023 23:17:14 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" 
        <linux-trace-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 00/13] Add RDMA inline crypto support
Message-ID: <Y8ec+vUqitvvLKHL@sol.localdomain>
References: <cover.1673873422.git.leon@kernel.org>
 <Y8eWEPZahIFAfnoI@sol.localdomain>
 <95692a47-09e7-0055-2006-46d085b2eadb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95692a47-09e7-0055-2006-46d085b2eadb@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 07:14:30AM +0000, Chaitanya Kulkarni wrote:
> Eric,
> 
> >> Notes:
> >>   - At plaintext mode only, the user set a master key and the fscrypt
> >>     driver derived from it the DEK and the key identifier.
> >>   - 152c41b2ea39fa3d90ea06448456e7fb is the derived key identifier
> >>   - Only on the first IO, nvme-rdma gets a callback to load the derived DEK.
> >>
> >> There is no special configuration to support crypto at nvme modules.
> >>
> >> Thanks
> > 
> > Very interesting work!  Can you Cc me on future versions?
> > 
> > I'm glad to see that this hardware allows all 16 IV bytes to be specified.
> > 
> > Does it also handle programming and evicting keys efficiently?
> > 
> > Also, just checking: have you tested that the ciphertext that this inline
> > encryption hardware produces is correct?  That's always super important to test.
> > There are xfstests that test for it, e.g. generic/582.  Another way to test it
> > is to just manually test whether encrypted files that were created when the
> > filesystem was mounted with '-o inlinecrypt' show the same contents when the
> > filesystem is *not* mounted with '-o inlinecrypt' (or vice versa).
> > 
> > - Eric
> > 
> 
> I'm wondering which are the xfstests that needs to run in order
> to establish the correctness/stability apart from generic/582
> this work ?
> 

See https://docs.kernel.org/filesystems/fscrypt.html#tests.

- Eric
