Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8582C44DB43
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 18:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhKKRva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 12:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:52392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234393AbhKKRv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 12:51:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 435BF610F8;
        Thu, 11 Nov 2021 17:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636652918;
        bh=9ViDaevgAE4N+A7w52zOk8+4EOjzFCHGXL/8Iu1n7P0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OTkPoi6nDk35CPkeO4HJVyvNDCKFl7H5Cz56oCLpR7UOOR34WdFhHwkR/PZy/sWDD
         A6djGRriHVWrItleqnBrfroNOYETEw+uJm7v1F6JN6QqcLA5EeybpXWBnmqfjHkK/b
         NtdoTg2kC7tvpXd8xMliplM6tfygpR8UIhG7ZXk8FGGkZj1PbKTuTawTjImp0i8/sl
         ZifWHbQcoy2tQPgXABEeCyRx9BqNIp6RMxUNHoaPBp5epUminNzDexC+SNG/QdWrOE
         KsL5gzbWZe0xx8ts8AbN+LCVUTCXbaJUzc9/mj0K7WwLMd6xSBGjVSuZ+xk4TOjtT1
         a+PGwxMSME1lQ==
Date:   Thu, 11 Nov 2021 09:48:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [RFC PATCH net-next] rtnetlink: add RTNH_F_REJECT_MASK
Message-ID: <20211111094837.55937988@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211111160240.739294-2-alexander.mikhalitsyn@virtuozzo.com>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
        <20211111160240.739294-2-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 19:02:40 +0300 Alexander Mikhalitsyn wrote:
> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> index 5888492a5257..c15e591e5d25 100644
> --- a/include/uapi/linux/rtnetlink.h
> +++ b/include/uapi/linux/rtnetlink.h
> @@ -417,6 +417,9 @@ struct rtnexthop {
>  #define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | \
>  				 RTNH_F_OFFLOAD | RTNH_F_TRAP)
>  
> +/* these flags can't be set by the userspace */
> +#define RTNH_F_REJECT_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN)

You should probably drop the _F_ since RTNH_COMPARE_MASK above 
does not have it.
