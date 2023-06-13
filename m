Return-Path: <netdev+bounces-10493-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6304A72EB79
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:04:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4BE1280AA7
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:04:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CE35294C9;
	Tue, 13 Jun 2023 19:04:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDC220F8;
	Tue, 13 Jun 2023 19:04:03 +0000 (UTC)
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7F292;
	Tue, 13 Jun 2023 12:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686683044; x=1718219044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K5+Giq/eW/XK8GIxl1uK5VSys+gvOj3g0+/asIlylGs=;
  b=TvQ3cI+mHVKQ9cP5FMZ8kSQwTihgj7kFjSTGVGL+4sES/OzjNKaia0vR
   18CcbyX2vW5mxJIYJ6G69rASToeP/X0oTQyym3UneDqwPr37jyoHF+jHb
   VoykzFx1dsQr3ORSPqV5RbdQ72MWzAJITS64smuE6Ge2bsPg3ZBFxpPNh
   U=;
X-IronPort-AV: E=Sophos;i="6.00,240,1681171200"; 
   d="scan'208";a="566395106"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 19:04:01 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com (Postfix) with ESMTPS id 8AD4580D31;
	Tue, 13 Jun 2023 19:03:54 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 13 Jun 2023 19:03:53 +0000
Received: from 88665a182662.ant.amazon.com.com (10.95.246.146) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 13 Jun 2023 19:03:47 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <lmb@isovalent.com>
CC: <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
	<daniel@iogearbox.net>, <davem@davemloft.net>, <dsahern@kernel.org>,
	<edumazet@google.com>, <haoluo@google.com>, <hemanthmalla@gmail.com>,
	<joe@wand.net.nz>, <john.fastabend@gmail.com>, <jolsa@kernel.org>,
	<kpsingh@kernel.org>, <kuba@kernel.org>, <kuniyu@amazon.com>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<martin.lau@linux.dev>, <mykolal@fb.com>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <sdf@google.com>, <shuah@kernel.org>, <song@kernel.org>,
	<willemdebruijn.kernel@gmail.com>, <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2 4/6] net: remove duplicate sk_lookup helpers
Date: Tue, 13 Jun 2023 12:03:39 -0700
Message-ID: <20230613190339.65042-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230613-so-reuseport-v2-4-b7c69a342613@isovalent.com>
References: <20230613-so-reuseport-v2-4-b7c69a342613@isovalent.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.95.246.146]
X-ClientProxiedBy: EX19D046UWA003.ant.amazon.com (10.13.139.18) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Lorenz Bauer <lmb@isovalent.com>
Date: Tue, 13 Jun 2023 11:14:59 +0100
> Now that inet[6]_lookup_reuseport are parameterised on the ehashfn
> we can remove two sk_lookup helpers.
> 
> Signed-off-by: Lorenz Bauer <lmb@isovalent.com>
> ---
>  include/net/inet6_hashtables.h |  9 +++++++++
>  include/net/inet_hashtables.h  |  7 +++++++
>  net/ipv4/inet_hashtables.c     | 26 +++++++++++++-------------
>  net/ipv4/udp.c                 | 32 +++++---------------------------
>  net/ipv6/inet6_hashtables.c    | 30 +++++++++++++++---------------
>  net/ipv6/udp.c                 | 34 +++++-----------------------------
>  6 files changed, 54 insertions(+), 84 deletions(-)
> 
> diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
> index 49d586454287..4d2a1a3c0be7 100644
> --- a/include/net/inet6_hashtables.h
> +++ b/include/net/inet6_hashtables.h
> @@ -73,6 +73,15 @@ struct sock *inet6_lookup_listener(struct net *net,
>  				   const unsigned short hnum,
>  				   const int dif, const int sdif);
>  
> +struct sock *inet6_lookup_run_sk_lookup(struct net *net,

I understand this comes from SEC("sk_lookup"), but this sounds
redundant and run_bpf is clearer for non-BPF folks.

