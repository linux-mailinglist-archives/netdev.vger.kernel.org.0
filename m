Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B31CE87D
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfJGP6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbfJGP6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 11:58:09 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD81E20684;
        Mon,  7 Oct 2019 15:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570463888;
        bh=c2cfttHvioIgEOzycWuuy+TYcKeyths19DaSZsB4C6g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hwnI64sy4HqOg1CMWWQH2IFC/O3zAnQeXbC6EVy7VCIAFo3x9ATytEY84MhiFPMOH
         slszY64fvIwUS4X04Y8dprJlyY/xjFUYDwEQeJPL5GCoHmLD7lZ3jwQgHucsl39poY
         KnLbPtzPI/OQ23kzKcyk2AReO5I7vDlNOdhWaSh4=
Date:   Mon, 7 Oct 2019 18:58:03 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 2/3] RDMA/rw: Support threshold for
 registration vs scattering to local pages
Message-ID: <20191007155803.GA5855@unreal>
References: <20191007135933.12483-1-leon@kernel.org>
 <20191007135933.12483-3-leon@kernel.org>
 <04420039-1877-c35d-83ce-b7365c1e6b65@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04420039-1877-c35d-83ce-b7365c1e6b65@acm.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 08:12:37AM -0700, Bart Van Assche wrote:
> On 10/7/19 6:59 AM, Leon Romanovsky wrote:
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > index 4f671378dbfc..60fd98a9b7e8 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -445,6 +445,8 @@ struct ib_device_attr {
> >   	struct ib_tm_caps	tm_caps;
> >   	struct ib_cq_caps       cq_caps;
> >   	u64			max_dm_size;
> > +	/* Max entries for sgl for optimized performance per READ */
>                                    ^^^^^^^^^
>                                    optimal?
>
> Should it be mentioned that zero means that the HCA has not set this
> parameter?

It is always the case for other max_* values.

>
> > +	u32			max_sgl_rd;
>
> Thanks,
>
> Bart.
