Return-Path: <netdev+bounces-4717-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7785070DFEA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:09:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05226280DCD
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D24BB1F930;
	Tue, 23 May 2023 15:09:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAC54C7B
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1BDC433D2;
	Tue, 23 May 2023 15:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684854552;
	bh=ByR3MfyEq4mpigKz6m9bitnXynTJ/qyPMBapRD2DW0s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZpxXsgg+VGXbpih/fZY2l2+SXaUBHtjWrXkYy6LaZVks/kDpp8x0zAlrKqYceUXiZ
	 agq4i+jtZFPEziMNy96Q6F7GoM2GvJqFvv8gf9GLgHCVKTNt+CdxW+p5FdV/MLOf7K
	 7zZ8vS81K5XLjBI07KnnnYVw4VX65BLKtG4dngQmtnIarJ6HaX0CixuZtRR06myIbv
	 ugjcL6KK+gKUoSqVB4lqGZJSlYJg3EUiECBEceYQgsKTDSBuDQYoGKvf339ldcoWqC
	 Y726PcUQMnPPpXL9ptwni3QUJirXRILmCK/2bSCNsdkckfM2unNzvY2YqL5KQT/oYx
	 3DpnsdPAxkOeg==
Message-ID: <d18721ef-5938-0fab-73a1-238fb5fb2aaa@kernel.org>
Date: Tue, 23 May 2023 09:09:11 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/3] ping: Stop using RTO_ONLINK.
Content-Language: en-US
To: Guillaume Nault <gnault@redhat.com>, David Miller <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <cover.1684764727.git.gnault@redhat.com>
 <f4ceb3ad415f7353885baf0a0dc56226ebe8302e.1684764727.git.gnault@redhat.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <f4ceb3ad415f7353885baf0a0dc56226ebe8302e.1684764727.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/22/23 8:37 AM, Guillaume Nault wrote:
> Define a new helper to figure out the correct route scope to use on TX,
> depending on socket configuration, ancillary data and send flags.
> 
> Use this new helper to properly initialise the scope in
> flowi4_init_output(), instead of overriding tos with the RTO_ONLINK
> flag.
> 
> The objective is to eventually remove RTO_ONLINK, which will allow
> converting .flowi4_tos to dscp_t.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  include/net/ip.h | 13 +++++++++++++
>  net/ipv4/ping.c  | 15 +++++----------
>  2 files changed, 18 insertions(+), 10 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


