Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E612604E84
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 19:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiJSRXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 13:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiJSRXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 13:23:32 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6834118DD5F;
        Wed, 19 Oct 2022 10:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666200211; x=1697736211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NqEfRLIEqpNvt19+pyCqi9Pu8gzTCcHAInBn9m1EzFI=;
  b=i4LXfHGl/Glc2aI379sL7YHbfRC9sgS486bI+Jo3JF3D3+Okm5qcl62C
   wlNywZN4bVqk0PiRWJgh/riSjGcO4mKXbd6LC1JrgP4j9oslC6E+IM35t
   0XJD2PkcaJ3BAUHQn/oXeeygO5Hz+sKB93iPrsmIg6dAJ2KxxFuaFBhSR
   I=;
X-IronPort-AV: E=Sophos;i="5.95,196,1661817600"; 
   d="scan'208";a="234388839"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 17:23:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com (Postfix) with ESMTPS id B74AE81B92;
        Wed, 19 Oct 2022 17:23:22 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 19 Oct 2022 17:23:21 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.69) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Wed, 19 Oct 2022 17:23:18 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <xu.xin.sc@gmail.com>
CC:     <asml.silence@gmail.com>, <ast@kernel.org>, <davem@davemloft.net>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuniyu@amazon.com>, <linux-kernel@vger.kernel.org>,
        <martin.lau@kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <xu.xin16@zte.com.cn>,
        <yoshfuji@linux-ipv6.org>, <zealci@zte.com.cn>,
        <zhang.yunkai@zte.com.cn>
Subject: [PATCH linux-next] net: remove useless parameter of __sock_cmsg_send The
Date:   Wed, 19 Oct 2022 10:22:52 -0700
Message-ID: <20221019172252.72890-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221019093014.389738-1-xu.xin16@zte.com.cn>
References: <20221019093014.389738-1-xu.xin16@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.69]
X-ClientProxiedBy: EX13D47UWA004.ant.amazon.com (10.43.163.47) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   xu.xin.sc@gmail.com
Date:   Wed, 19 Oct 2022 09:30:14 +0000
> From: xu xin <xu.xin16@zte.com.cn>
> 
> parameter 'msg' has never been used by __sock_cmsg_send, so we can remove it
> safely.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> Reviewed-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>

The tail 'The' in the subject should be the head of the body.
Otherwise, looks good.

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>


> ---
>  include/net/sock.h     | 2 +-
>  net/core/sock.c        | 4 ++--
>  net/ipv4/ip_sockglue.c | 2 +-
>  net/ipv6/datagram.c    | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 9e464f6409a7..b1dacc4d68c9 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1901,7 +1901,7 @@ static inline void sockcm_init(struct sockcm_cookie *sockc,
>  	*sockc = (struct sockcm_cookie) { .tsflags = sk->sk_tsflags };
>  }
>  
> -int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct cmsghdr *cmsg,
> +int __sock_cmsg_send(struct sock *sk, struct cmsghdr *cmsg,
>  		     struct sockcm_cookie *sockc);
>  int sock_cmsg_send(struct sock *sk, struct msghdr *msg,
>  		   struct sockcm_cookie *sockc);
> diff --git a/net/core/sock.c b/net/core/sock.c
> index a3ba0358c77c..944a9ea75f65 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2730,7 +2730,7 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
>  }
>  EXPORT_SYMBOL(sock_alloc_send_pskb);
>  
> -int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct cmsghdr *cmsg,
> +int __sock_cmsg_send(struct sock *sk, struct cmsghdr *cmsg,
>  		     struct sockcm_cookie *sockc)
>  {
>  	u32 tsflags;
> @@ -2784,7 +2784,7 @@ int sock_cmsg_send(struct sock *sk, struct msghdr *msg,
>  			return -EINVAL;
>  		if (cmsg->cmsg_level != SOL_SOCKET)
>  			continue;
> -		ret = __sock_cmsg_send(sk, msg, cmsg, sockc);
> +		ret = __sock_cmsg_send(sk, cmsg, sockc);
>  		if (ret)
>  			return ret;
>  	}
> diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> index 6e19cad154f5..5f16807d3235 100644
> --- a/net/ipv4/ip_sockglue.c
> +++ b/net/ipv4/ip_sockglue.c
> @@ -267,7 +267,7 @@ int ip_cmsg_send(struct sock *sk, struct msghdr *msg, struct ipcm_cookie *ipc,
>  		}
>  #endif
>  		if (cmsg->cmsg_level == SOL_SOCKET) {
> -			err = __sock_cmsg_send(sk, msg, cmsg, &ipc->sockc);
> +			err = __sock_cmsg_send(sk, cmsg, &ipc->sockc);
>  			if (err)
>  				return err;
>  			continue;
> diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
> index 5ecb56522f9d..df7e032ce87d 100644
> --- a/net/ipv6/datagram.c
> +++ b/net/ipv6/datagram.c
> @@ -771,7 +771,7 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
>  		}
>  
>  		if (cmsg->cmsg_level == SOL_SOCKET) {
> -			err = __sock_cmsg_send(sk, msg, cmsg, &ipc6->sockc);
> +			err = __sock_cmsg_send(sk, cmsg, &ipc6->sockc);
>  			if (err)
>  				return err;
>  			continue;
> -- 
> 2.25.1
