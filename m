Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7761D550DAA
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 01:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbiFSXsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 19:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiFSXsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 19:48:42 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A799FFA;
        Sun, 19 Jun 2022 16:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655682521; x=1687218521;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kyIkiZAiAiTXNFNHwizDZ9FyvnKD+JgDWZnNKx1jLVE=;
  b=YmXR9mxZ2FN0PgBb/7zuuRV7WmL+xX2JwsuBxL8ndW0n26D/yaBatRL1
   1/fHNM3ZZib1LiXiuVZlvI+OiI8ARXYN3BV3tfF+aBgeUkMGKNk+Qh0zS
   JYcja+nzT4hApAsg1Hfhrzvmbea4Aw2GGek0zHH0DD2oHTIok8Uq7Kkcw
   w=;
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-7d84505d.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 19 Jun 2022 23:48:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-7d84505d.us-west-2.amazon.com (Postfix) with ESMTPS id 554E9800F0;
        Sun, 19 Jun 2022 23:48:28 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 19 Jun 2022 23:48:27 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.51) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 19 Jun 2022 23:48:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <sfr@canb.auug.org.au>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuniyu@amazon.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Date:   Sun, 19 Jun 2022 16:48:12 -0700
Message-ID: <20220619234812.57765-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620093424.0615a374@canb.auug.org.au>
References: <20220620093424.0615a374@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.51]
X-ClientProxiedBy: EX13D38UWC002.ant.amazon.com (10.43.162.46) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Date:   Mon, 20 Jun 2022 09:34:24 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> net/ipv4/raw.c: In function 'raw_icmp_error':
> net/ipv4/raw.c:266:9: error: ISO C90 forbids mixed declarations and code [-Werror=declaration-after-statement]
>   266 |         struct hlist_nulls_head *hlist;
>       |         ^~~~~~
> cc1: all warnings being treated as errors
> 
> Introduced by commit
> 
>   ba44f8182ec2 ("raw: use more conventional iterators")
> 
> I have applied the following patch for today.

I have posted the same patch just few minutes ago,
https://lore.kernel.org/netdev/20220619232927.54259-2-kuniyu@amazon.com/


> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 20 Jun 2022 09:21:01 +1000
> Subject: [PATCH] raw: fix build error
> 
> The linux-next x86_64 allmodconfig build produced this error:
> 
> net/ipv4/raw.c: In function 'raw_icmp_error':
> net/ipv4/raw.c:266:9: error: ISO C90 forbids mixed declarations and code [-Werror=declaration-after-statement]
>   266 |         struct hlist_nulls_head *hlist;
>       |         ^~~~~~
> cc1: all warnings being treated as errors
> 
> Fixes: ba44f8182ec2 ("raw: use more conventional iterators")
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  net/ipv4/raw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
> index d28bf0b901a2..b3b255db9021 100644
> --- a/net/ipv4/raw.c
> +++ b/net/ipv4/raw.c
> @@ -262,7 +262,7 @@ static void raw_err(struct sock *sk, struct sk_buff *skb, u32 info)
>  
>  void raw_icmp_error(struct sk_buff *skb, int protocol, u32 info)
>  {
> -	struct net *net = dev_net(skb->dev);;
> +	struct net *net = dev_net(skb->dev);
>  	struct hlist_nulls_head *hlist;
>  	struct hlist_nulls_node *hnode;
>  	int dif = skb->dev->ifindex;
> -- 
> 2.35.1
> 
> -- 
> Cheers,
> Stephen Rothwell
