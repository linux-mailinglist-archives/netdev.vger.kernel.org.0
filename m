Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D8017FCA
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 20:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfEHS0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 14:26:45 -0400
Received: from upbd19pa07.eemsg.mail.mil ([214.24.27.82]:29884 "EHLO
        upbd19pa07.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727974AbfEHS0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 14:26:45 -0400
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 May 2019 14:26:42 EDT
X-EEMSG-check-017: 222955656|UPBD19PA07_EEMSG_MP7.csd.disa.mil
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by upbd19pa07.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 08 May 2019 18:16:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1557339391; x=1588875391;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=YDcVUsMEfD9zsFH26BDz4jKfAef5YIxDGE0n3aaTxrY=;
  b=Qn2SOAQ9BQLT62sRSkUYJwXtqGPqoBoz9xviwIT5io7ZU72Fqpz5Ws22
   Klq/bXVqP4YfLF2O6lSftzLoD11a0+l4hiWC2g1HseJI04m8ywOQPz28p
   bhHgGShgTzf2S0G3fbmFbzgkApfGC3KJPRy+YPrXOe30G9gGaHGuTzEkS
   m6UibodQE/J/AmVQkCobCGrqOETahHo3JduazorL8/SnScQatXXWdVBNv
   j0P+Nqkj7XLvniJlamEB0m5lRSDHPczz9zmooJNqYy+dfc8fh6ng4p7n2
   oCDXmpfrTBRUG+cJ9PnROLDDoCug16hT0+yjgMCft/eeLKwIcw6WNVVrc
   A==;
X-IronPort-AV: E=Sophos;i="5.60,446,1549929600"; 
   d="scan'208";a="23346947"
IronPort-PHdr: =?us-ascii?q?9a23=3A3OyhPhX0nx8JLDhB1s2/O4j1fTXV8LGtZVwlr6?=
 =?us-ascii?q?E/grcLSJyIuqrYZRWOtadThVPEFb/W9+hDw7KP9fy5ACpQut3Y6SFKWacPfi?=
 =?us-ascii?q?dNsd8RkQ0kDZzNImzAB9muURYHGt9fXkRu5XCxPBsdMs//Y1rPvi/6tmZKSV?=
 =?us-ascii?q?3wOgVvO+v6BJPZgdip2OCu4Z3TZBhDiCagbb9oIxi6sBjdutMVjIZsJao91w?=
 =?us-ascii?q?bFr39VcOlK2G1kIk6ekQzh7cmq5p5j9CpQu/Ml98FeVKjxYro1Q79FAjk4Km?=
 =?us-ascii?q?45/MLkuwXNQguJ/XscT34ZkgFUDAjf7RH1RYn+vy3nvedgwiaaPMn2TbcpWT?=
 =?us-ascii?q?S+6qpgVRHlhDsbOzM/7WrakdJ7gr5Frx29phx/24/Ub5+TNPpiZaPWYNcWSX?=
 =?us-ascii?q?NcUspNSyBNB4WxYIUVD+oFIO1WsY/zqVUTphe6HAWhCufixjpOi3Tr36M1zv?=
 =?us-ascii?q?4hHBnb0gI+EdIAsHfaotv7O6gdU++60KbGwC7fb/5Uwzrx9JTEfx4jrPyKQL?=
 =?us-ascii?q?l+cdDRyU4qFw7dk1uQtZLqPyuV1usTtWiQ8vduVee1hG4jrwF+vDiuzdorh4?=
 =?us-ascii?q?nSm40V0UvJ9Tl5wYkpJd24T1R3Ydi/EJRKrS2aOIx2Qt07TmxupS00yaUGtI?=
 =?us-ascii?q?amcCUFx5kr3R7SZ+Gdf4SW7R/vSvydLSp+iXl4YrywnQyy/lKlyuDkU8m010?=
 =?us-ascii?q?tFoTRdn9nXs3ANywTT6s+aSvth5kuh2SiA1wTU6uxcPUA7j7DbK588wr4rjJ?=
 =?us-ascii?q?YTrUTCETP2mEXxlqOWcFkr+vO05Oj9Z7Xmp5ucO5d1igH4LKsuhtSyDfk3Pw?=
 =?us-ascii?q?UBRWSW+fmw2Kf98UD2XrlGlOA6nrHcsJ/AJMQboqC5AxVS0oYm8xu/FCqp0M?=
 =?us-ascii?q?8DkHkbLFNKZBKHj4/zN1HIO/D3F+2zg1urkDd13/zGJKHuAo3RLnjfl7fsZa?=
 =?us-ascii?q?595FRHxwUty9Bf5olZCqsfL/3uWk/+rsDYAgUlPAyzxubtEM992Z8GWWKTHq?=
 =?us-ascii?q?+ZN7vfsUeS6eIyJ+mBf5cVtyzgK/gh/vLuiHg5mVgHfaa3x5cYdHe4HvF+KU?=
 =?us-ascii?q?WDfXXsmssBEXsNvgcmV+zlllmCUT9VZ3avUKMx/S87CI24AofZXIytg6KO3D?=
 =?us-ascii?q?29HpJIYmBKEFeMEW3nd4+cQfcDdDqSItN9kjwDTbWhTZEu1Q2zuwDk1bpqNf?=
 =?us-ascii?q?TU+iIGupL5ztR15PPclQs09TNqC8SRyWaNT3t7nmkQXT85wLh/oVBhyleEya?=
 =?us-ascii?q?V4n+FXGsJI5/xXUgY6M4XRz/ZkBN/vWgLOZMuJREy6TdWhBDE7VsgxzMMWY0?=
 =?us-ascii?q?ZhB9WiiQjO3y+wDL8Pi7OEGpg08qXG03j1Ocl9ymrG1K8/gFk8WcZPOmimib?=
 =?us-ascii?q?R+9wjXHYLGj0KZl6Oyf6QGwCHN7HuDzXaJvExASg5wULnKXXAFaUvMsNv2/l?=
 =?us-ascii?q?/NQKeuCbs9MwtBz9CNKrBRZ9LykVVGRfHjOMjAbGKrnWe/GwqIyqmQY4rtfm?=
 =?us-ascii?q?VOlBnaXXANlAQUtV+MOA4/TnO5qmjTCj1GD1/jY0rwt+J5rSX/Bnc90gXCSk?=
 =?us-ascii?q?pmzbf9rgYcmPi0U/oO2vcBvyA7pnN/G1PrjPzMDN/VnBZsZKVRZ5sG5V5D0W?=
 =?us-ascii?q?/I/1hmMoeIM7FphllYdR9++UzpyUMkWc17jcE2oSZyn0JJIqWC3QYELmjJ0A?=
 =?us-ascii?q?=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2B+AAA9HNNc/wHyM5BkHAEBAQQBAQcEAQGBUwUBAQsBg?=
 =?us-ascii?q?WYqgToBMiiEEJNeAQQGgTWJTI8GgXsJATQBAoQ/AoIIIzYHDgEDAQEBBAEBA?=
 =?us-ascii?q?QEDAQFsKII6KQGCZwEFIwQRQRALDgoCAiYCAlcGAQwGAgEBgl8/gXcUrU58M?=
 =?us-ascii?q?4VHgx2BRoELJwGLTRd4gQeBESeCaz5phmWCWASLF4d8lC8JgguCBpBDBhuVV?=
 =?us-ascii?q?y2IaIMPkUKFMQExgVYrCAIYCCEPgyeCGxeOOyMDMIEGAQGQCAEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 08 May 2019 18:16:29 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x48IGSvR017971;
        Wed, 8 May 2019 14:16:28 -0400
Subject: Re: [PATCH net] selinux: do not report error on connect(AF_UNSPEC)
To:     Paolo Abeni <pabeni@redhat.com>, Paul Moore <paul@paul-moore.com>
Cc:     selinux@vger.kernel.org, netdev@vger.kernel.org,
        Tom Deseyn <tdeseyn@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Richard Haines <richard_c_haines@btinternet.com>
References: <7301017039d68c920cb9120c035a1a0df3e6b30d.1557322358.git.pabeni@redhat.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <36e13dc4-be40-d1f6-0be5-32cd4fc38f6e@tycho.nsa.gov>
Date:   Wed, 8 May 2019 14:12:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <7301017039d68c920cb9120c035a1a0df3e6b30d.1557322358.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/19 9:32 AM, Paolo Abeni wrote:
> calling connect(AF_UNSPEC) on an already connected TCP socket is an
> established way to disconnect() such socket. After commit 68741a8adab9
> ("selinux: Fix ltp test connect-syscall failure") it no longer works
> and, in the above scenario connect() fails with EAFNOSUPPORT.
> 
> Fix the above falling back to the generic/old code when the address family
> is not AF_INET{4,6}, but leave the SCTP code path untouched, as it has
> specific constraints.
> 
> Fixes: 68741a8adab9 ("selinux: Fix ltp test connect-syscall failure")
> Reported-by: Tom Deseyn <tdeseyn@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>   security/selinux/hooks.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index c61787b15f27..d82b87c16b0a 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -4649,7 +4649,7 @@ static int selinux_socket_connect_helper(struct socket *sock,
>   		struct lsm_network_audit net = {0,};
>   		struct sockaddr_in *addr4 = NULL;
>   		struct sockaddr_in6 *addr6 = NULL;
> -		unsigned short snum;
> +		unsigned short snum = 0;
>   		u32 sid, perm;
>   
>   		/* sctp_connectx(3) calls via selinux_sctp_bind_connect()
> @@ -4674,12 +4674,12 @@ static int selinux_socket_connect_helper(struct socket *sock,
>   			break;
>   		default:
>   			/* Note that SCTP services expect -EINVAL, whereas
> -			 * others expect -EAFNOSUPPORT.
> +			 * others must handle this at the protocol level:
> +			 * connect(AF_UNSPEC) on a connected socket is
> +			 * a documented way disconnect the socket.
>   			 */
>   			if (sksec->sclass == SECCLASS_SCTP_SOCKET)
>   				return -EINVAL;
> -			else
> -				return -EAFNOSUPPORT;

I think we need to return 0 here.  Otherwise, we'll fall through with an 
uninitialized snum, triggering a random/bogus permission check.

>   		}
>   
>   		err = sel_netport_sid(sk->sk_protocol, snum, &sid);
> 

