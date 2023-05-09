Return-Path: <netdev+bounces-1076-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA1236FC173
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:13:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 664F7280C1A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746C317ACD;
	Tue,  9 May 2023 08:13:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D582567
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C530C433EF;
	Tue,  9 May 2023 08:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683620001;
	bh=TwagzWwS0vhrdNWcaN9Qbdu1OhbyGdBZ15TxIBHhmdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uL7gQe7YV6G/tUURRlsOvMfVpjay9b3sDSbZXDUwINJvUIKityU55FwC+gaIr1jhU
	 +FE+jhAz9uZsBtEP1fXFDGgimECOTwDdLfojOwEiEAAtiz/pA5d5SskIBU9VV0SXan
	 bugEllZXRNuDE9QVUvwUXDICacYb6+klBOVEe07djSDs+SlOdy0FlzX4W7TszDZRpC
	 dMziAhDDY1i+Ez6KQpt77xv+9haa3QKqmtzf0r/8MQXpUWaJe+FlAsJfVHYifh4AIL
	 UP7cz4oTDZAVJIoIslabFxZgJ9UIhoXwjkUJ1s6Sla8T142SKfdfY+pms+Ti2AXjvU
	 ndJr+ednfZpWA==
Date: Tue, 9 May 2023 11:13:17 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Louis Peens <louis.peens@corigine.com>
Cc: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
	oss-drivers@corigine.com
Subject: Re: [PATCH net-next] nfp: improve link modes reading process
Message-ID: <20230509081317.GI38143@unreal>
References: <20230509075817.10566-1-louis.peens@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509075817.10566-1-louis.peens@corigine.com>

On Tue, May 09, 2023 at 09:58:17AM +0200, Louis Peens wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> Avoid reading link modes from management firmware every time when
> `ethtool_get_link_ksettings` is called, only communicate with
> management firmware when necessary like we do for eth_table info.
> 
> This change can ease the situation that when large number of vlan
> sub-interfaces are created and their information is requested by
> some monitoring process like PCP [1] through ethool ioctl frequently.
> 
> [1] https://pcp.io
> 
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Acked-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> ---
>  .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 32 +++++------
>  .../ethernet/netronome/nfp/nfpcore/nfp_nsp.h  |  7 ++-
>  .../netronome/nfp/nfpcore/nfp_nsp_eth.c       | 54 +++++++++----------
>  3 files changed, 45 insertions(+), 48 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

