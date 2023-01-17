Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2BD66DD0E
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 13:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbjAQMAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 07:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbjAQMAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 07:00:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4EA36FD9;
        Tue, 17 Jan 2023 03:59:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16A12B81187;
        Tue, 17 Jan 2023 11:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B004C433D2;
        Tue, 17 Jan 2023 11:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673956794;
        bh=aTQYYKmLmNf07nxBHwjaA+StqUovg0SS7JYEnCH+EZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JcktzRZbthNjyz+5qDuk41oZMxJYCCPDkgEXy01vFYTwlnZjxjziBy/fjRBFrmcSa
         E+PMfnpmsxQOvk4Nnoif+2kebtJFzsk6MLmCF0naHyrUxRwLUY0egDjGMueOewYX9U
         jY95uj2yF2tCHsBQgxOnBrKJInMJKFTeLLsroP9Qz+Zmb5S5ohasJ2sIlHVuXyrdKU
         +JQlAVyRuTN0m1l13Oc+TNnPPuP7Sr59v4b9nO4VxcqClgsxIrXN9pyrNM8z/w85BT
         oBD2AKo9teesJp1MkdO9eUCNiMo/mj0umhmkVIhKlpMUQYQSsiQ5U2bWLoyBYl3VOM
         zsK3K8o3KkQoA==
Date:   Tue, 17 Jan 2023 13:59:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
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
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 11/13] nvme: Introduce a local variable
Message-ID: <Y8aNt9YB9irSVXNo@unreal>
References: <cover.1673873422.git.leon@kernel.org>
 <cf5bc542e014f465f7ae443e52e70def2993aef1.1673873422.git.leon@kernel.org>
 <c095c9a9-0e77-c8ab-d34e-f4ab42b11938@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c095c9a9-0e77-c8ab-d34e-f4ab42b11938@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 12:32:59AM +0000, Chaitanya Kulkarni wrote:
> On 1/16/23 05:05, Leon Romanovsky wrote:
> > From: Israel Rukshin <israelr@nvidia.com>
> > 
> > The patch doesn't change any logic.
> > 
> > Signed-off-by: Israel Rukshin <israelr@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leon@kernel.org>
> > ---
> >   drivers/nvme/host/core.c | 7 ++++---
> >   1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> > index 7be562a4e1aa..51a9880db6ce 100644
> > --- a/drivers/nvme/host/core.c
> > +++ b/drivers/nvme/host/core.c
> > @@ -1870,6 +1870,7 @@ static void nvme_update_disk_info(struct gendisk *disk,
> >   	sector_t capacity = nvme_lba_to_sect(ns, le64_to_cpu(id->nsze));
> >   	unsigned short bs = 1 << ns->lba_shift;
> >   	u32 atomic_bs, phys_bs, io_opt = 0;
> > +	struct nvme_ctrl *ctrl = ns->ctrl;
> >   
> 
> I don't think this patch is needed, existing code is more readable and
> gives much clarity that we are accessing ctrl from namespace since we
> are in nvme_update_disk_info() which is namespace based.

I don't have strong opinion here.

Thanks

> 
> -ck
> 
