Return-Path: <netdev+bounces-8131-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07BA0722DC0
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47CA71C20C6C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0DB71DDD0;
	Mon,  5 Jun 2023 17:39:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE2DAD2E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 17:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C4EC433EF;
	Mon,  5 Jun 2023 17:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685986791;
	bh=ap63rJMVKkBxtjoP41zii95vBpIMMqUObWxCvmE5tfs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=krsPBC55oRuNp2drEw1oycxPxzslAw/4L/Nvm8kys6ThM6VvlL66z52nVHCmIJ6AM
	 n+lP73gJHs4yS9TwUPuHOshFPkv3QP6t0zwkYofylmGX4kvbYGU5iq5HJsbIKhBQ7+
	 99yqZGpxCEx+XwB+lcd8bNBXDLGmvtH5M9rAx4/dJGyU3nq3MrBKTxbjZ2w+hmkmRf
	 T/tesB4aTJj7MqveWpy+erk/iHf8+EOEC88BN6xeMIDlbHXcCKAzyv0mGPjMA9daEo
	 RRyFOaE2DHhs0dfS/dZp0s+OOzBQMrPEdjpZ0BgoR6m27doyIcOKTKDQ5KDAb8ciso
	 w5zP8QC7levOA==
Date: Mon, 5 Jun 2023 10:39:49 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com,
 anjali.singhai@intel.com, namrata.limaye@intel.com, tom@sipanda.io,
 p4tc-discussions@netdevconf.info, mleitner@redhat.com,
 Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com, tomasz.osinski@intel.com,
 jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, vladbu@nvidia.com,
 simon.horman@corigine.com, khalidm@nvidia.com, toke@redhat.com
Subject: Re: [PATCH RFC v2 net-next 03/28] net/sched: act_api: increase
 TCA_ID_MAX
Message-ID: <20230605103949.3317f1ed@kernel.org>
In-Reply-To: <20230517110232.29349-3-jhs@mojatatu.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
	<20230517110232.29349-3-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 May 2023 07:02:07 -0400 Jamal Hadi Salim wrote:
> Increase TCA_ID_MAX from 255 to 1023
> 
> Given P4TC dynamic actions required new IDs (dynamically) and 30 of those are
> already taken by the standard actions (such as gact, mirred and ife) we are left
> with 225 actions to create, which seems like a small number.

> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index 5b66df3ec332..337411949ad0 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -140,9 +140,9 @@ enum tca_id {
>  	TCA_ID_MPLS,
>  	TCA_ID_CT,
>  	TCA_ID_GATE,
> -	TCA_ID_DYN,
> +	TCA_ID_DYN = 256,
>  	/* other actions go here */
> -	__TCA_ID_MAX = 255
> +	__TCA_ID_MAX = 1023
>  };
>  
>  #define TCA_ID_MAX __TCA_ID_MAX

I haven't look at any of the patches but this stands out as bad idea
on the surface.

