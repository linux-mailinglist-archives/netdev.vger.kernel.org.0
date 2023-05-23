Return-Path: <netdev+bounces-4720-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B516570E016
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A41D1C20D96
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1AE91F93B;
	Tue, 23 May 2023 15:14:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23CC1F922
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587BCC433EF;
	Tue, 23 May 2023 15:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684854847;
	bh=Sty+pfhmLmM2kIuCzfnd947lu1RITsEpVCdIUrHG8jg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WXZ/9HqHEfQIZhlMbEJQpjbxQiN8PIar6A1iZ7K6fOyHGFA+qAcwnbK4rs+iRBv9B
	 qoORNRcTpaXTB+8aq/Qt+ZhqNcA5y4xulusyujhiV/H9fV0AWewdKOuInn9mp+LmQs
	 CzNgXcmkXc27HteundQObXdbalOJXhaqWkembP+788NH5uxlixNyRl151NZs3Dl8zv
	 4C/tOBc24ytesre9xSj9Qp+fPr7jyHH/96LrfQLFkdy5ztzvH41iF6YjOpLSJEEBMn
	 QidQFm4w7+HN5NZogkemS5bbQdIk4Dyb3iFhP92+8FR3NXUV7EgMjXeMVYnoBtd2qC
	 Ohr0Ino4ie+gQ==
Message-ID: <a9dec8d0-9485-e044-5954-54d6e7f55685@kernel.org>
Date: Tue, 23 May 2023 09:14:06 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 3/3] udp: Stop using RTO_ONLINK.
Content-Language: en-US
To: Guillaume Nault <gnault@redhat.com>, David Miller <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <cover.1684764727.git.gnault@redhat.com>
 <abc28174280c6947ab78ce77772df695b812843c.1684764727.git.gnault@redhat.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <abc28174280c6947ab78ce77772df695b812843c.1684764727.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/22/23 8:38 AM, Guillaume Nault wrote:
> Use ip_sendmsg_scope() to properly initialise the scope in
> flowi4_init_output(), instead of overriding tos with the RTO_ONLINK
> flag. The objective is to eventually remove RTO_ONLINK, which will
> allow converting .flowi4_tos to dscp_t.
> 
> Now that the scope is determined by ip_sendmsg_scope(), we need to
> check its result to set the 'connected' variable.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  net/ipv4/udp.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



