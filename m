Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0C26B5270
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbjCJVBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjCJVAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:00:47 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2383220A3C
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 12:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678481992; x=1710017992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5r+5dlWshIeLN57YWPKY6azmTH0k5q4ut327XzfLM14=;
  b=UgAd0QOX9/uGcLwfIXAZOIub8OtPjvmSmmU4pZkAB0emGWHkhWVCIwwv
   HYS1meRDTaXxQ62ImZHwk7WaqjDTzWHZp/pYGRPOIL0OkMACG1KJGCEu4
   is5VlUb3fKDCrz8GwbO6foof/GH4//L7UbNZiCkYUSR9UvnlKZe5Sp8eO
   E=;
X-IronPort-AV: E=Sophos;i="5.98,250,1673913600"; 
   d="scan'208";a="307867333"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 20:59:49 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com (Postfix) with ESMTPS id 4322540E2E;
        Fri, 10 Mar 2023 20:59:48 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 10 Mar 2023 20:59:40 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.20) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Fri, 10 Mar 2023 20:59:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <vincenzopalazzodev@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH v1] net: socket: suppress unused warning
Date:   Fri, 10 Mar 2023 12:59:29 -0800
Message-ID: <20230310205929.23362-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230309160001.256420-1-vincenzopalazzodev@gmail.com>
References: <20230309160001.256420-1-vincenzopalazzodev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.100.20]
X-ClientProxiedBy: EX19D045UWA003.ant.amazon.com (10.13.139.46) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Date:   Thu,  9 Mar 2023 17:00:01 +0100
> suppress unused warnings and fix the error that there is
> with the W=1 enabled.
> 
> Warning generated
> 
> net/socket.c: In function ‘__sys_getsockopt’:
> net/socket.c:2300:13: error: variable ‘max_optlen’ set but not used [-Werror=unused-but-set-variable]
>  2300 |         int max_optlen;
> 
> Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
> ---
>  net/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/socket.c b/net/socket.c
> index 6bae8ce7059e..20edd4b222ca 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2297,7 +2297,7 @@ int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
>  {

Move max_optlen here to keep reverse xmas tree order.

	int max_optlen __maybe_unused;

>  	int err, fput_needed;
>  	struct socket *sock;
> -	int max_optlen;
> +	int max_optlen __maybe_unused;
>  
>  	sock = sockfd_lookup_light(fd, &err, &fput_needed);
>  	if (!sock)
> -- 
> 2.39.2

Thanks,
Kuniyuki
