Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC68D4084FF
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 08:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhIMG4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 02:56:13 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:52222 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237357AbhIMG4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 02:56:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9052A2019C;
        Mon, 13 Sep 2021 08:54:55 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id opzlf57cRu9C; Mon, 13 Sep 2021 08:54:54 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B6A202057E;
        Mon, 13 Sep 2021 08:54:54 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id B0A6E80004A;
        Mon, 13 Sep 2021 08:54:54 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 13 Sep 2021 08:54:54 +0200
Received: from moon.secunet.de (172.18.26.121) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Mon, 13 Sep
 2021 08:54:53 +0200
Date:   Mon, 13 Sep 2021 08:54:46 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Eugene Syromiatnikov <esyr@redhat.com>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antony Antony <antony.antony@secunet.com>,
        Christian Langrock <christian.langrock@secunet.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        <selinux@vger.kernel.org>, Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        "Eric Paris" <eparis@parisplace.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Dmitry V. Levin" <ldv@strace.io>,
        <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2] include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI
 breakage
Message-ID: <20210913065446.GA2611@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20210912122234.GA22469@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210912122234.GA22469@asgard.redhat.com>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks!

Acked-by: Antony Antony <antony.antony@secunet.com>

-antony

On Sun, Sep 12, 2021 at 14:22:34 +0200, Eugene Syromiatnikov wrote:
> Commit 2d151d39073a ("xfrm: Add possibility to set the default to block
> if we have no policy") broke ABI by changing the value of the XFRM_MSG_MAPPING
> enum item, thus also evading the build-time check
> in security/selinux/nlmsgtab.c:selinux_nlmsg_lookup for presence of proper
> security permission checks in nlmsg_xfrm_perms.  Fix it by placing
> XFRM_MSG_SETDEFAULT/XFRM_MSG_GETDEFAULT to the end of the enum, right before
> __XFRM_MSG_MAX, and updating the nlmsg_xfrm_perms accordingly.
> 
> Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
> References: https://lore.kernel.org/netdev/20210901151402.GA2557@altlinux.org/
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
> v2:
>  - Updated SELinux nlmsg_xfrm_perms permissions table and selinux_nlmsg_lookup
>    build-time check accordingly.
> 
> v1: https://lore.kernel.org/lkml/20210901153407.GA20446@asgard.redhat.com/
> ---
>  include/uapi/linux/xfrm.h   | 6 +++---
>  security/selinux/nlmsgtab.c | 4 +++-
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
> index b96c1ea..26f456b1 100644
> --- a/include/uapi/linux/xfrm.h
> +++ b/include/uapi/linux/xfrm.h
> @@ -213,13 +213,13 @@ enum {
>  	XFRM_MSG_GETSPDINFO,
>  #define XFRM_MSG_GETSPDINFO XFRM_MSG_GETSPDINFO
>  
> +	XFRM_MSG_MAPPING,
> +#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
> +
>  	XFRM_MSG_SETDEFAULT,
>  #define XFRM_MSG_SETDEFAULT XFRM_MSG_SETDEFAULT
>  	XFRM_MSG_GETDEFAULT,
>  #define XFRM_MSG_GETDEFAULT XFRM_MSG_GETDEFAULT
> -
> -	XFRM_MSG_MAPPING,
> -#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
>  	__XFRM_MSG_MAX
>  };
>  #define XFRM_MSG_MAX (__XFRM_MSG_MAX - 1)
> diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
> index d59276f..94ea2a8 100644
> --- a/security/selinux/nlmsgtab.c
> +++ b/security/selinux/nlmsgtab.c
> @@ -126,6 +126,8 @@ static const struct nlmsg_perm nlmsg_xfrm_perms[] =
>  	{ XFRM_MSG_NEWSPDINFO,	NETLINK_XFRM_SOCKET__NLMSG_WRITE },
>  	{ XFRM_MSG_GETSPDINFO,	NETLINK_XFRM_SOCKET__NLMSG_READ  },
>  	{ XFRM_MSG_MAPPING,	NETLINK_XFRM_SOCKET__NLMSG_READ  },
> +	{ XFRM_MSG_SETDEFAULT,	NETLINK_XFRM_SOCKET__NLMSG_WRITE },
> +	{ XFRM_MSG_GETDEFAULT,	NETLINK_XFRM_SOCKET__NLMSG_READ  },
>  };
>  
>  static const struct nlmsg_perm nlmsg_audit_perms[] =
> @@ -189,7 +191,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
>  		 * structures at the top of this file with the new mappings
>  		 * before updating the BUILD_BUG_ON() macro!
>  		 */
> -		BUILD_BUG_ON(XFRM_MSG_MAX != XFRM_MSG_MAPPING);
> +		BUILD_BUG_ON(XFRM_MSG_MAX != XFRM_MSG_GETDEFAULT);
>  		err = nlmsg_perm(nlmsg_type, perm, nlmsg_xfrm_perms,
>  				 sizeof(nlmsg_xfrm_perms));
>  		break;
> -- 
> 2.1.4
> 
