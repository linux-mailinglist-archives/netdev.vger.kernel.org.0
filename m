Return-Path: <netdev+bounces-182-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B5B96F5B47
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 17:34:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF71D281660
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 15:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A02FA107B1;
	Wed,  3 May 2023 15:34:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4D5D30C;
	Wed,  3 May 2023 15:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3EBC433D2;
	Wed,  3 May 2023 15:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683128058;
	bh=gkPd8aDQYb0daSvr4xmJ+11gUtz98UqLKYxVlN45ATI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iyO9bcnV+KsXcw5bg/cfFOEme1bnL7xc7MqPEXbMOUKtzM88oLWUsrPhUrA4voE0V
	 K8bSrgyvRO5/XAoIIjykJHQx6y5VoOAtx2XrmHWOTuG6wH1RqokcSnkMHKmzWciqvk
	 loE+0gnc0T7JWHrNoaXPWKI8d48lL4KCtBzmHU32qFzPCdxiVTHD/gU9yWoOtlf265
	 AKOjBxNLLtLlu+e8e5+Xd3LsNqu7sPzI31Ar+fpl8OY5yM6+Uu/CthGjp2ElBXHeAT
	 w5Of+AkRLiDPnKObpfEvA20SVksC7mI25EE9zSqtqQfaM+dUpaxuNiL2dMfuY0DSM2
	 D/i0/sVVkgnRQ==
Date: Wed, 3 May 2023 17:34:12 +0200
From: Simon Horman <horms@kernel.org>
To: Shenwei Wang <shenwei.wang@nxp.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Wei Fang <wei.fang@nxp.com>,
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
Message-ID: <ZFJ+9Ij+jOJO1+wu@kernel.org>
References: <20230502220818.691444-1-shenwei.wang@nxp.com>
 <20230502220818.691444-2-shenwei.wang@nxp.com>
 <6dff0a5b-c74b-4516-8461-26fcd5d615f3@lunn.ch>
 <PAXPR04MB9185BD38BA486104EE5B7213896C9@PAXPR04MB9185.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PAXPR04MB9185BD38BA486104EE5B7213896C9@PAXPR04MB9185.eurprd04.prod.outlook.com>

On Wed, May 03, 2023 at 12:53:57PM +0000, Shenwei Wang wrote:
> 
> 
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Tuesday, May 2, 2023 6:19 PM
> > To: Shenwei Wang <shenwei.wang@nxp.com>
> > Cc: Wei Fang <wei.fang@nxp.com>; David S. Miller <davem@davemloft.net>;
> > Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> > Paolo Abeni <pabeni@redhat.com>; Clark Wang <xiaoning.wang@nxp.com>; dl-
> > linux-imx <linux-imx@nxp.com>; Alexei Starovoitov <ast@kernel.org>; Daniel
> > Borkmann <daniel@iogearbox.net>; Jesper Dangaard Brouer
> > <hawk@kernel.org>; John Fastabend <john.fastabend@gmail.com>; Alexander
> > Lobakin <alexandr.lobakin@intel.com>; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org; imx@lists.linux.dev
> > Subject: [EXT] Re: [PATCH v2 net 2/2] net: fec: restructuring the functions to
> > avoid forward declarations
> > 
> > Caution: This is an external email. Please take care when clicking links or
> > opening attachments. When in doubt, report the message using the 'Report this
> > email' button
> > 
> > 
> > On Tue, May 02, 2023 at 05:08:18PM -0500, Shenwei Wang wrote:
> > > The patch reorganizes functions related to XDP frame transmission,
> > > moving them above the fec_enet_run_xdp implementation. This eliminates
> > > the need for forward declarations of these functions.
> > 
> > I'm confused. Are these two patches in the wrong order?
> > 
> > The reason that i asked you to fix the forward declaration in net-next is that it
> > makes your fix two patches. Sometimes that is not obvious to people back
> > porting patches, and one gets lost, causing build problems. So it is better to have
> > a single patch which is maybe not 100% best practice merged to stable, and then
> > a cleanup patch merged to the head of development.
> > 
> 
> If that is the case, we should forgo the second patch. Its purpose was to
> reorganize function order such that the subsequent patch to net-next
> enabling XDP_TX would not encounter forward declaration issues.

I think a good plan would be, as I understood Andrew's original suggestion,
to:

1. Only have patch 2/2, targeted at 'net', for now
2. Later, once that patch has been accepted into 'net', 'net-next' has
   reopened, and that patch is present in 'net-next', then follow-up
   with patch 1/2, which is a cleanup.

