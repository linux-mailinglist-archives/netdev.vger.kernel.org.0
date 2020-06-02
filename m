Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD091EB5BC
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 08:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgFBGRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 02:17:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgFBGRT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 02:17:19 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4587B20772;
        Tue,  2 Jun 2020 06:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591078639;
        bh=ep5l1ExG4gfRIqOhdJgGRgQz5NIwz5nYtmlie8CVHk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BTHW6K9EtYZMHqWIKankCYohBkF5ZQUGzXIM0CeutRMPBUevZalzoyQq0KpjOBcaD
         qeiETdixprK14YCDQgZZi8fU5rKI5bsfKoWUKChQzkBX9p4SAY97jBGGjch8ww5MfK
         Jz/83myBFWfGC6X66baOsPAZqwi0hQHXH44PRGIM=
Date:   Tue, 2 Jun 2020 09:17:15 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Rao Shoaib <rao.shoaib@oracle.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, somasundaram.krishnasamy@oracle.com
Subject: Re: [PATCH net-next] rds: transport module should be auto loaded
 when transport is set
Message-ID: <20200602061715.GA56352@unreal>
References: <20200527081742.25718-1-rao.shoaib@oracle.com>
 <20200529.164107.1817677145426311890.davem@davemloft.net>
 <4f86d778-1f6b-d533-c062-c78daa257829@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f86d778-1f6b-d533-c062-c78daa257829@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 09:59:30AM -0700, Rao Shoaib wrote:
>
> On 5/29/20 4:41 PM, David Miller wrote:
> > From: rao.shoaib@oracle.com
> > Date: Wed, 27 May 2020 01:17:42 -0700
> >
> > > diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
> > > index cba368e55863..7273c681e6c1 100644
> > > --- a/include/uapi/linux/rds.h
> > > +++ b/include/uapi/linux/rds.h
> > > @@ -64,7 +64,7 @@
> > >   /* supported values for SO_RDS_TRANSPORT */
> > >   #define	RDS_TRANS_IB	0
> > > -#define	RDS_TRANS_IWARP	1
> > > +#define	RDS_TRANS_GAP	1
> > >   #define	RDS_TRANS_TCP	2
> > >   #define RDS_TRANS_COUNT	3
> > >   #define	RDS_TRANS_NONE	(~0)
> > You can't break user facing UAPI like this, sorry.
>
> I was hoping that this could be considered an exception as IWARP has been
> deprecated for almost a decade and there is no current product using it.
> With the change any old binary will continue to work, a new compilation fill
> fail so that the code can be examined, otherwise we will never be able to
> reuse this number.
>
> If the above is not acceptable I can revert this part of the change.

Nothing prohibits you from adding the following lines:

+ /* don't use RDS_TRANS_IWARP - it is deprecated */
+ #define  RDS_TRANS_GAP RDS_TRANS_IWARP

>
> Shoaib
>
