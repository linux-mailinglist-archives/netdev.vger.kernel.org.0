Return-Path: <netdev+bounces-7572-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1BA4720A46
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:28:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6EFB281A98
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE5BE1F193;
	Fri,  2 Jun 2023 20:28:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F861E535
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 20:28:11 +0000 (UTC)
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F081BE
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685737691; x=1717273691;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0EMdTrhgfZbDKfxMxHESTLXyCfgCHJOUpwixLzfnH8E=;
  b=SU5qUpBjCbLqoTUTu+XsfvHvOf3iZzYI9uSJwBZUmXCgg5TZ0MVL2l2p
   MPdroH49vm6oHKUcV9NTAlPA67opb98Kxs2yKv8bVLo765ALX9Z0d8UE9
   OKjLUwpPsmEd7SM8uXV7rCHehrrxv5ojsgnZJoEIq6XNjvvpPQ9aRZp4g
   U=;
X-IronPort-AV: E=Sophos;i="6.00,214,1681171200"; 
   d="scan'208";a="218514227"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 20:28:07 +0000
Received: from EX19MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
	by email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com (Postfix) with ESMTPS id 2A126806DD;
	Fri,  2 Jun 2023 20:28:06 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 20:28:05 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.9) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Fri, 2 Jun 2023 20:28:03 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <edumazet@google.com>
CC: <davem@davemloft.net>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH net 2/2] rfs: annotate lockless accesses to RFS sock flow table
Date: Fri, 2 Jun 2023 13:27:53 -0700
Message-ID: <20230602202753.51130-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230602163141.2115187-3-edumazet@google.com>
References: <20230602163141.2115187-3-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.9]
X-ClientProxiedBy: EX19D037UWC004.ant.amazon.com (10.13.139.254) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Eric Dumazet <edumazet@google.com>
Date: Fri,  2 Jun 2023 16:31:41 +0000
> Add READ_ONCE()/WRITE_ONCE() on accesses to the sock flow table.
> 
> This also prevents a (smart ?) compiler to remove the condition in:
> 
> if (table->ents[index] != newval)
>         table->ents[index] = newval;
> 
> We need the condition to avoid dirtying a shared cache line.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thanks!


> ---
>  include/linux/netdevice.h | 7 +++++--
>  net/core/dev.c            | 6 ++++--
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 08fbd4622ccf731daaee34ad99773d6dc2e82fa6..e6f22b7403d014a2cf4d81d931109a594ce1398e 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -768,8 +768,11 @@ static inline void rps_record_sock_flow(struct rps_sock_flow_table *table,
>  		/* We only give a hint, preemption can change CPU under us */
>  		val |= raw_smp_processor_id();
>  
> -		if (table->ents[index] != val)
> -			table->ents[index] = val;
> +		/* The following WRITE_ONCE() is paired with the READ_ONCE()
> +		 * here, and another one in get_rps_cpu().
> +		 */
> +		if (READ_ONCE(table->ents[index]) != val)
> +			WRITE_ONCE(table->ents[index], val);
>  	}
>  }
>  
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b3c13e0419356b943e90b1f46dd7e035c6ec1a9c..1495f8aff288e944c8cab21297f244a6fcde752f 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4471,8 +4471,10 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
>  		u32 next_cpu;
>  		u32 ident;
>  
> -		/* First check into global flow table if there is a match */
> -		ident = sock_flow_table->ents[hash & sock_flow_table->mask];
> +		/* First check into global flow table if there is a match.
> +		 * This READ_ONCE() pairs with WRITE_ONCE() from rps_record_sock_flow().
> +		 */
> +		ident = READ_ONCE(sock_flow_table->ents[hash & sock_flow_table->mask]);
>  		if ((ident ^ hash) & ~rps_cpu_mask)
>  			goto try_rps;
>  
> -- 
> 2.41.0.rc0.172.g3f132b7071-goog

