Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB94461E533
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 19:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiKFSDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 13:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiKFSDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 13:03:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98821B4A1;
        Sun,  6 Nov 2022 10:03:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CF3860D32;
        Sun,  6 Nov 2022 18:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF18EC433D6;
        Sun,  6 Nov 2022 18:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667757785;
        bh=uuxDn1OITqIDqXPA7ridGX3rAXW+cFLB1pbNkqErXvY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cKOlW8pTjdb8KK9IW6NYiUtQVKx+CHTSjHFA53h2KnIDxSXC80moVIwZ62X90iVTv
         YoODVvHeoVTjjtnnKQWuyzITRnfZqlsUuDpL/j9vxn2Zl3HVbbRPcPORFohLhFmQtg
         9MoRuv3IzEnL6uyDcUY3qTNIkbUDvsia7CAkCLpnRa1DtL+dfUX3Z8PL5hbZBNV9Di
         YwWkeZRX/RAfH1S3DL63aVkTCwvL8OcRogfsbk/nxectFS9PMG4fqnIcyX9FIt8Ug8
         E/Rz0hnfUIQBF0mTJXPOz+bU3yoI+y//JEhQjFhVPtOxDhevWpM7SS9jyFjEpfKMcu
         MGaB+BMURUc6Q==
Date:   Sun, 6 Nov 2022 20:03:00 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Rohit Nair <rohit.sajan.kumar@oracle.com>
Cc:     jgg@ziepe.ca, saeedm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, manjunath.b.patil@oracle.com,
        rama.nichanamatlu@oracle.com,
        Michael Guralnik <michaelgur@nvidia.com>
Subject: Re: [External] : Re: [PATCH 1/1] IB/mlx5: Add a signature check to
 received EQEs and CQEs
Message-ID: <Y2f21JKWkQg8KtyK@unreal>
References: <20221005174521.63619-1-rohit.sajan.kumar@oracle.com>
 <Y0UYml07lb1I38MQ@unreal>
 <5bab650a-3c0b-cfd2-d6a7-2e39c8474514@oracle.com>
 <Y1p4OEIWNObQCDoG@unreal>
 <fdb9f874-1998-5270-4360-61c74c34294d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdb9f874-1998-5270-4360-61c74c34294d@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 04:48:53PM -0700, Rohit Nair wrote:
> On 10/27/22 5:23 AM, Leon Romanovsky wrote:
> > On Tue, Oct 25, 2022 at 10:44:12AM -0700, Rohit Nair wrote:
> > > Hey Leon,
> > > 
> > > Please find my replies to your comments here below:
> > 
> > <...>
> > 
> > > > 
> > > > > This patch does not introduce any significant performance degradations
> > > > > and has been tested using qperf.
> > > > What does it mean? You made changes in kernel verbs flow, they are not
> > > > executed through qperf.
> > > We also conducted several extensive performance tests using our test-suite
> > > which utilizes rds-stress and also saw no significant performance
> > > degrdations in those results.
> > 
> > What does it mean "also"? Your change is applicable ONLY for kernel path.
> > 
> > Anyway, I'm not keen adding rare debug code to performance critical path.
> > 
> > Thanks
> 
> rds-stress exercises the codepath we are modifying here. rds-stress didn't
> show much of performance degrade when we ran internally. We also requested
> our DB team for performance regression testing and this change passed their
> test suite. This motivated us to submit this to upstream.
> 
> If there is any other test that is better suited for this change, I am
> willing to test it. Please let me know if you have something in mind. We can
> revisit this patch after such a test may be.
> 
> I agree that, this was a rare debug scenario, but it took lot more than
> needed to narrow down[engaged vendor on live sessions]. We are adding this
> in the hope to finding the cause at the earliest or at least point us which
> direction to look at. We also requested the vendor[mlx] to include some
> diagnostics[HW counter], which can help us narrow it faster next time. This
> is our attempt to add kernel side of diagnostics.

The thing is that "vendor" failed to explain internally if this debug
code is useful. Like I said, extremely rare debug code shouldn't be part
of main data path.

Thanks

> 
> Feel free to share your suggestions
> 
> Thanks
> 
