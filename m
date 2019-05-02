Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F27C41127E
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 07:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbfEBFN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 01:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725681AbfEBFN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 01:13:27 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AD6B2081C;
        Thu,  2 May 2019 05:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556774006;
        bh=CrH2zf+C2T7OR/wQ8PNnjw3DEiFgZssh6zb6un90Zps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LWEwJ23DjdMowrXBg/ptNJY41dX3+6r/soZmIhRqjhArv/nEMECbV0p6BWdu5SCvd
         I1Re0hhrd7ewlsJVYEe40l2fgrUFv4LFxbUJ7E9Rs8ivC99nE/4OsZvU8t+dEFK7lQ
         jth9gdv6zlczoDm2VKJjyb0Vx0Dufh59VlSWVZF8=
Date:   Thu, 2 May 2019 08:13:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     michal.kalderon@marvell.com, David Miller <davem@davemloft.net>
Cc:     ariel.elior@marvell.com, jgg@ziepe.ca, dledford@redhat.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH net-next 07/10] qed*: Add iWARP 100g support
Message-ID: <20190502051320.GF7676@mtr-leonro.mtl.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
 <20190501095722.6902-8-michal.kalderon@marvell.com>
 <20190501.203522.1577716429222042609.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190501.203522.1577716429222042609.davem@davemloft.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 01, 2019 at 08:35:22PM -0400, David Miller wrote:
> From: Michal Kalderon <michal.kalderon@marvell.com>
> Date: Wed, 1 May 2019 12:57:19 +0300
>
> > diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
> > index d93c8a893a89..8bc6775abb79 100644
> > --- a/drivers/infiniband/hw/qedr/main.c
> > +++ b/drivers/infiniband/hw/qedr/main.c
> > @@ -52,6 +52,10 @@ MODULE_DESCRIPTION("QLogic 40G/100G ROCE Driver");
> >  MODULE_AUTHOR("QLogic Corporation");
> >  MODULE_LICENSE("Dual BSD/GPL");
> >
> > +static uint iwarp_cmt;
> > +module_param(iwarp_cmt, uint, 0444);
> > +MODULE_PARM_DESC(iwarp_cmt, " iWARP: Support CMT mode. 0 - Disabled, 1 - Enabled. Default: Disabled");
> > +
>
> Sorry no, this is totally beneath us.

It is not acceptable for RDMA too.

Also please don't use comments inside function calls, it complicates
various checkers without real need.
dev->ops->iwarp_set_engine_affin(dev->cdev, true /* reset */);
                                                ^^^^^^^^^^^^^^
Thanks
