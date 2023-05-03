Return-Path: <netdev+bounces-218-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D79B76F5F72
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 21:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E163F1C20960
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 19:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 047F2BE55;
	Wed,  3 May 2023 19:53:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A136FDF44;
	Wed,  3 May 2023 19:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAB0C433EF;
	Wed,  3 May 2023 19:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683143600;
	bh=0I3e4pFHAwWmZCl912lq1j5YX6PdAVZ1kzVgFaQMHYM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FelllHbqr+zO+aNz+h65w44/rT4QxQVt/M9H2S4J5Jjf1vhZNRLjGvxmcDWNn2TKQ
	 jfozuXowlOWjHaYkUluFfXbGv7c552ve7sy/CC+nZwAiWya56iGr7fyGuU/t0yobVH
	 SIvkR3CpLK9WejWXRhx0kCzpi4KqueGcRaY7+tzDHUpGMMrk8p11pvSr1kJfeQEmSn
	 XosydHc7dn3AosBOMNnqL/pBEVZoVOIvw439yluUiSYQejn6Jo2rI/GxewzYPVHZm4
	 HzFuNc8yzWNX9Js2wyq+Uxm8qFOOzzNj03606yBeJ4R/Q1WAwBlazuAg5/hRRh+31H
	 6uY/HVrBk0Jmw==
Date: Wed, 3 May 2023 21:53:13 +0200
From: Simon Horman <horms@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Shenwei Wang <shenwei.wang@nxp.com>, Wei Fang <wei.fang@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	dl-linux-imx <linux-imx@nxp.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [EXT] Re: [PATCH v2 net 2/2] net: fec: restructuring the
 functions to avoid forward declarations
Message-ID: <ZFK7qYkyg0cwxxKd@kernel.org>
References: <20230502220818.691444-1-shenwei.wang@nxp.com>
 <20230502220818.691444-2-shenwei.wang@nxp.com>
 <6dff0a5b-c74b-4516-8461-26fcd5d615f3@lunn.ch>
 <PAXPR04MB9185BD38BA486104EE5B7213896C9@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <ZFJ+9Ij+jOJO1+wu@kernel.org>
 <PAXPR04MB918564D93054CEDF255DA251896C9@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <ZFKw5seP5WclDCG2@kernel.org>
 <PAXPR04MB9185FA526B63311C3899BD9C896C9@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <48d0de18-942e-4a1a-9774-792fe16db6c1@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48d0de18-942e-4a1a-9774-792fe16db6c1@lunn.ch>

On Wed, May 03, 2023 at 09:40:30PM +0200, Andrew Lunn wrote:
> > Hi Simon,
> > 
> > I'm a bit confused.
> > 
> > Are you suggesting that I submit the following restructuring patch for 'net' at this time?
> > [PATCH v2 net 2/2] net: fec: restructuring the functions to avoid forward declarations
> > 
> > Thanks,
> > Shenwei
> 
> Submit the fix to 'net'. But only the fix.

Yes, that is what I meant.

> Once a week, net gets merged to net-next, so the fix will also appear
> in net-next. You can then do the cleanup in net-next.

