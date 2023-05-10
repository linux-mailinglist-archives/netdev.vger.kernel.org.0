Return-Path: <netdev+bounces-1559-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 166526FE4A9
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:56:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6BBD28144D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 19:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3EB717FF3;
	Wed, 10 May 2023 19:55:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4CC8C0F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A230C433EF;
	Wed, 10 May 2023 19:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683748555;
	bh=RYWlkEMmtKFcnSA1V7d0hw2msjiuCUgItNg8KSF4cFo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Atwqa+YzIQfnswYmmBW4QgMpJubIDT7+rloomC7xWS6GNM+c3oGS0NWzMVdCF1sb/
	 BbI9qqoJ5DlKvfDSybwo3Phg8AMVi10krhWhwnQE0So/E6UhozBL4bJ1aryvfHy2he
	 /XxzmOgKaHpCxepDnJ8gsYU74QtoOgBm4cGdRNqGzd2G+rAKZ4TG9kA5eWz2QgCd4K
	 3G9Kax56/pBiaBIPZqbsUENzp1dRdoOSQZUhjvZIPpnsBgjCBst+yQHzoFuf1yC478
	 DRvW9tD7IBFXnv8dNiIM7/oLy+wyJDF7TLEQXSDUtjHi9e6hh/dzbyhN0cu0/mHtJU
	 6xGtxjwMxGvgw==
Message-ID: <03652ea0-09fc-6185-e71e-5ad603811609@kernel.org>
Date: Wed, 10 May 2023 13:55:53 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [net 1/2] selftests: seg6: disable DAD on IPv6 router cfg for
 srv6_end_dt4_l3vpn_test
Content-Language: en-US
To: Andrea Mayer <andrea.mayer@uniroma2.it>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Stefano Salsano <stefano.salsano@uniroma2.it>,
 Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
 Ahmed Abdelsalam <ahabdels.dev@gmail.com>, Hangbin Liu <liuhangbin@gmail.com>
References: <20230510111638.12408-1-andrea.mayer@uniroma2.it>
 <20230510111638.12408-2-andrea.mayer@uniroma2.it>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230510111638.12408-2-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/10/23 5:16 AM, Andrea Mayer wrote:
> The srv6_end_dt4_l3vpn_test instantiates a virtual network consisting of
> several routers (rt-1, rt-2) and hosts.
> When the IPv6 addresses of rt-{1,2} routers are configured, the Deduplicate
> Address Detection (DAD) kicks in when enabled in the Linux distros running
> the selftests. DAD is used to check whether an IPv6 address is already
> assigned in a network. Such a mechanism consists of sending an ICMPv6 Echo
> Request and waiting for a reply.
> As the DAD process could take too long to complete, it may cause the
> failing of some tests carried out by the srv6_end_dt4_l3vpn_test script.
> 
> To make the srv6_end_dt4_l3vpn_test more robust, we disable DAD on routers
> since we configure the virtual network manually and do not need any address
> deduplication mechanism at all.
> 
> Fixes: 2195444e09b4 ("selftests: add selftest for the SRv6 End.DT4 behavior")
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



