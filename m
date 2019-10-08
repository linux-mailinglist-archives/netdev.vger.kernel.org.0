Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81DD9CF241
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 07:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbfJHFxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 01:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729440AbfJHFxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 01:53:21 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5127D206BB;
        Tue,  8 Oct 2019 05:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570514001;
        bh=wtVkErxzLeCqnsmorlDLTmhwQSUBKXlv8tUwBlRU7uQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rUhM6PLqi7E2hPkE3tkijTD0vVZRGbFU4qMcnr+nDdEC5B1/D4fQ86pzqUgLirnF9
         78banokZTEhybYozKNN9//hVCEEFpcxubiaKroLo4p1wFr+ckN0mg4wN0KOKlf64D/
         +kAlP8T6D3eULslgGLx8bPiMFpNhRxHOFKklLM7M=
Date:   Tue, 8 Oct 2019 08:53:17 +0300
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
Message-ID: <20191008055317.GD5855@unreal>
References: <20191007135933.12483-1-leon@kernel.org>
 <20191007135933.12483-3-leon@kernel.org>
 <c0105196-b0e4-854e-88ff-40f5ba2d4105@acm.org>
 <20191007160336.GB5855@unreal>
 <8d610a58-abb5-941a-2a52-96ab9287572b@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d610a58-abb5-941a-2a52-96ab9287572b@acm.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 03:22:30PM -0700, Bart Van Assche wrote:
> On 10/7/19 9:03 AM, Leon Romanovsky wrote:
> > On Mon, Oct 07, 2019 at 08:07:55AM -0700, Bart Van Assche wrote:
> > > On 10/7/19 6:59 AM, Leon Romanovsky wrote:
> > > >    /*
> > > > - * Check if the device might use memory registration.  This is currently only
> > > > - * true for iWarp devices. In the future we can hopefully fine tune this based
> > > > - * on HCA driver input.
> > > > + * Check if the device might use memory registration. This is currently
> > > > + * true for iWarp devices and devices that have optimized SGL registration
> > > > + * logic.
> > > >     */
> > >
> > > The following sentence in the above comment looks confusing to me: "Check if
> > > the device might use memory registration." That sentence suggests that the
> > > HCA decides whether or not to use memory registration. Isn't it the RDMA R/W
> > > code that decides whether or not to use memory registration?
> >
> > I'm open for any reasonable text, what do you expect to be written there?
>
> Hi Leon,
>
> How about the following (not sure whether this is correct)?
>
> /*
>  * Report whether memory registration should be used. Memory
>  * registration must be used for iWarp devices because of
>  * iWARP-specific limitations. Memory registration is also enabled if
>  * registering memory will yield better performance than using multiple
>  * SGE entries.
>  */

"Better performance" is relevant for mlx5 only, maybe others will use
this max_.. field to overcome their HW limitations.

Thanks

>
> Thanks,
>
> Bart.
