Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334126B630C
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 04:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCLDbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 22:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLDbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 22:31:32 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43308410A5
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 19:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678591892; x=1710127892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HvAFSus6UN3kUUNKWb0K7+JsK3aC7GoTEolIndVCbBg=;
  b=c6BX6i+TgOt0+P9Q0RnEQwaNXtritWhem3a++YRkCAtr0s46AWqpdjcD
   f7Dp5VcS8aG8nw/ZQQGlWoZ3RQ9O/bD7qfSfVN6WAuNs4R7C2AkobzIpP
   GhblnBqBPLEz5Ht43hUMXSRZ4S+PtNGto2wIZEOnxWk1d0rZen+Fnho36
   8=;
X-IronPort-AV: E=Sophos;i="5.98,253,1673913600"; 
   d="scan'208";a="192310397"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 03:31:29 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com (Postfix) with ESMTPS id 8F9D78107C;
        Sun, 12 Mar 2023 03:31:26 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Sun, 12 Mar 2023 03:31:25 +0000
Received: from 88665a182662.ant.amazon.com (10.119.80.90) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Sun, 12 Mar 2023 03:31:23 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <vincenzopalazzodev@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v2] net: socket: suppress unused warning
Date:   Sat, 11 Mar 2023 19:31:03 -0800
Message-ID: <20230312033103.5526-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230310221851.304657-1-vincenzopalazzodev@gmail.com>
References: <20230310221851.304657-1-vincenzopalazzodev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.119.80.90]
X-ClientProxiedBy: EX19D046UWA002.ant.amazon.com (10.13.139.39) To
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
Date:   Fri, 10 Mar 2023 23:18:51 +0100
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

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thanks,
Kuniyuki


> ---
>  net/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/socket.c b/net/socket.c
> index 6bae8ce7059e..ad081c9b429f 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2295,9 +2295,9 @@ INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
>  int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
>  		int __user *optlen)
>  {
> +	int max_optlen __maybe_unused;
>  	int err, fput_needed;
>  	struct socket *sock;
> -	int max_optlen;
>  
>  	sock = sockfd_lookup_light(fd, &err, &fput_needed);
>  	if (!sock)
> -- 
> 2.39.2
