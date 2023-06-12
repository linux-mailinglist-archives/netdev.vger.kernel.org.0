Return-Path: <netdev+bounces-9972-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9B3F72B7F9
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:13:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F3E4281038
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 06:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA23F23CB;
	Mon, 12 Jun 2023 06:13:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B79D20F1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B004C433EF;
	Mon, 12 Jun 2023 06:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686550433;
	bh=58MbQy7xKDiKseM5d6mW8cUc/YGdsopViJxC6mgqasw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iqqmYapoPKherGGRx8hLARAa//bmyZ+dt/X+ZAPtzPZglpSDqTneR/j3kA3uqyNUi
	 9PTz0iOSueDU66hcvVYaVsovvg7hBKcYz4wHjVQw+C34oETuB3MyDnyNVbhsoVUQ51
	 nRGHLnKEaYDYZDPgb677soAW9dsp7xNFYtlY+oeJyqFzaEocHS8X/TfFyJzZw0Vg+Y
	 zKY6Yo9Gip0xKZjM0ygd4u+SAR1dmN0+J/udwPAWKQnMKpYF6+gPKIYB7mrhKFgmOh
	 pHXUqYpqTPo2GKG6orVc5WuOEpIZeHZTB8htyUGMq+lxozNIXAfMvO1+973Vbu5fEP
	 JW2UJO/qG7JDA==
Date: Mon, 12 Jun 2023 09:13:49 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Wei Hu <weh@microsoft.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	Long Li <longli@microsoft.com>,
	Ajay Sharma <sharmaajay@microsoft.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, KY Srinivasan <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
	"shradhagupta@linux.microsoft.com" <shradhagupta@linux.microsoft.com>
Subject: Re: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Message-ID: <20230612061349.GM12152@unreal>
References: <20230606151747.1649305-1-weh@microsoft.com>
 <20230607213903.470f71ae@kernel.org>
 <SI2P153MB0441DAC4E756A1991A03520FBB54A@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SI2P153MB0441DAC4E756A1991A03520FBB54A@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>

On Mon, Jun 12, 2023 at 04:44:44AM +0000, Wei Hu wrote:
> Hi Jakub,
> 
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Thursday, June 8, 2023 12:39 PM
> > To: Wei Hu <weh@microsoft.com>
> > Cc: netdev@vger.kernel.org; linux-hyperv@vger.kernel.org; linux-
> > rdma@vger.kernel.org; Long Li <longli@microsoft.com>; Ajay Sharma
> > <sharmaajay@microsoft.com>; jgg@ziepe.ca; leon@kernel.org; KY
> > Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> > wei.liu@kernel.org; Dexuan Cui <decui@microsoft.com>;
> > davem@davemloft.net; edumazet@google.com; pabeni@redhat.com;
> > vkuznets@redhat.com; ssengar@linux.microsoft.com;
> > shradhagupta@linux.microsoft.com
> > Subject: Re: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to
> > mana ib driver.
> > 
> > On Tue,  6 Jun 2023 15:17:47 +0000 Wei Hu wrote:
> > >  drivers/infiniband/hw/mana/cq.c               |  32 ++++-
> > >  drivers/infiniband/hw/mana/main.c             |  87 ++++++++++++
> > >  drivers/infiniband/hw/mana/mana_ib.h          |   4 +
> > >  drivers/infiniband/hw/mana/qp.c               |  90 +++++++++++-
> > >  .../net/ethernet/microsoft/mana/gdma_main.c   | 131 ++++++++++--------
> > >  drivers/net/ethernet/microsoft/mana/mana_en.c |   1 +
> > >  include/net/mana/gdma.h                       |   9 +-
> > 
> > IB and netdev are different subsystem, can you put it on a branch and send a
> > PR as the cover letter so that both subsystems can pull?
> > 
> > Examples:
> > https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.
> > kernel.org%2Fall%2F20230607210410.88209-1-
> > saeed%40kernel.org%2F&data=05%7C01%7Cweh%40microsoft.com%7Cb672
> > 4a9f672f47d433ef08db67da4ada%7C72f988bf86f141af91ab2d7cd011db47%7C
> > 1%7C0%7C638217959538674174%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiM
> > C4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000
> > %7C%7C%7C&sdata=amO0W8QsR2I5INNNzCNOKEjrsYbzuZ92KXhNdfwSCHA
> > %3D&reserved=0
> > https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.
> > kernel.org%2Fall%2F20230602171302.745492-1-
> > anthony.l.nguyen%40intel.com%2F&data=05%7C01%7Cweh%40microsoft.co
> > m%7Cb6724a9f672f47d433ef08db67da4ada%7C72f988bf86f141af91ab2d7cd0
> > 11db47%7C1%7C0%7C638217959538674174%7CUnknown%7CTWFpbGZsb3d8
> > eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
> > D%7C3000%7C%7C%7C&sdata=A%2BjjtSx%2FvY2T%2BNIEPGuftk%2BCr%2Fv
> > Yt2Xc1q8B6h2tb6g%3D&reserved=0
> 
> Thanks for you comment. I am  new to the process. I have a few questions regarding to this and hope you can help. First of all, the patch is mostly for IB. Is it possible for the patch to just go through the RDMA branch, since most of the changes are in RDMA? 

Yes, it can, we (RDMA) will handle it.

Thanks

