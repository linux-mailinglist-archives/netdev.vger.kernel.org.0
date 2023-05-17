Return-Path: <netdev+bounces-3174-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 363CA705DF2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:21:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F52F1C20D83
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7307917F2;
	Wed, 17 May 2023 03:21:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2A117E0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E22C433EF;
	Wed, 17 May 2023 03:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684293660;
	bh=b8ppDmEIaTnXIk/SW60spPG5VJdPpOY7pKL70uyLalg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GLmOJd/IhPXHU/VrBXs/eQuyxrt7RhgP4ss9zIJnezsMFH2Mpi85XpiydHpdPpcjA
	 S2R2yNz8hwvkptdI4EHISBf5RnFSlsjL2/bjOLGeOMjjqWJM2xN8NOKg/xDSEJuPJZ
	 RI/qtKWLZhfrjX2gZl2fvnqkBTddlOhuJrV4pm9AO53QwWG94yMf1GN7lNB5UfESZT
	 v5Nh1HON40Tfdms7mzJokGItxLPLtTVgKPxf8rinOQt1kvf6dbfI26/dMr8CeS7FQo
	 fNmU6J5TQKyISi0adkUfBMzX07LdhBXlg5wBIh6ZdXiN4iQUdGIoRIRIFv8+9Ezx7v
	 QCHOszeuT5DJQ==
Date: Tue, 16 May 2023 20:20:59 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, wuych <yunchuan@nfschina.com>,
 dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: liquidio: lio_core: Remove unnecessary
 (void*) conversions
Message-ID: <20230516202059.09aab4d0@kernel.org>
In-Reply-To: <ZGKT01kLOQNRqx9I@corigine.com>
References: <20230515084906.61491-1-yunchuan@nfschina.com>
	<61522ef5-7c7a-4bee-bcf6-6905a3290e76@kili.mountain>
	<2c8a5e3f-965e-422a-b347-741bcc7d33ce@kili.mountain>
	<ZGKT01kLOQNRqx9I@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 May 2023 22:19:31 +0200 Simon Horman wrote:
> On Mon, May 15, 2023 at 05:56:21PM +0300, Dan Carpenter wrote:
> > On Mon, May 15, 2023 at 12:28:19PM +0300, Dan Carpenter wrote:  
> > > Networking code needs to be in Reverse Christmas Tree order.  Longest
> > > lines first.  This code wasn't really in Reverse Christmas Tree order
> > > to begine with but now it's more obvious.  
> > 
> > Oh, duh.  This obviously can't be reversed because it depends on the
> > first declaration.  Sorry for the noise.  
> 
> FWIIW, I think the preferred approach for such cases is to
> separate the declaration and initialisation. Something like:
> 
> 	struct octeon_device *oct = droq->oct_dev;
> 	struct octeon_device_priv *oct_priv;
> 
> 	oct_priv = oct->priv;

I don't think these changes are worth bothering with at all, TBH.

