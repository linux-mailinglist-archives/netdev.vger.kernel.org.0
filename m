Return-Path: <netdev+bounces-12093-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10503736090
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 02:18:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21EDF1C20938
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 00:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3AC819A;
	Tue, 20 Jun 2023 00:18:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28EF184
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 00:18:31 +0000 (UTC)
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18429B4
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 17:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1687220311; x=1718756311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vC/KA24yn1mFO9ef3iJ2Mg2LEInjOwpD551mdmJ+f7w=;
  b=MhqXaEyqc2MmTMv8Mf0au6wDuR0l2+yhbVPNtjKrE9QgHrkEao2XMwdO
   UvEEbqlOCYz9TOByml60Ze40aCUShQceO78iuV4jlaKfSsQ1cTIiOvhSe
   X4yBOkKUFgKs4Wf85txdWxI9Wfi8u9M/xwWgnUD/R7mOPPpfRl3gnbhus
   8=;
X-IronPort-AV: E=Sophos;i="6.00,255,1681171200"; 
   d="scan'208";a="655800116"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-a65ebc6e.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 00:18:24 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1e-m6i4x-a65ebc6e.us-east-1.amazon.com (Postfix) with ESMTPS id 5558F63572;
	Tue, 20 Jun 2023 00:18:17 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 20 Jun 2023 00:18:16 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.47) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Tue, 20 Jun 2023 00:18:13 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <maze@google.com>
CC: <edumazet@google.com>, <eyal.birger@gmail.com>, <kuba@kernel.org>,
	<larysa.zaremba@intel.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<prohr@google.com>, <simon.horman@corigine.com>, <zenczykowski@gmail.com>,
	<kuniyu@amazon.com>
Subject: Re: [PATCH net v2] revert "net: align SO_RCVMARK required privileges with SO_MARK"
Date: Mon, 19 Jun 2023 17:17:57 -0700
Message-ID: <20230620001757.13161-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230618103130.51628-1-maze@google.com>
References: <20230618103130.51628-1-maze@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.100.47]
X-ClientProxiedBy: EX19D037UWC002.ant.amazon.com (10.13.139.250) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Maciej Żenczykowski <maze@google.com>
Date: Sun, 18 Jun 2023 03:31:30 -0700
> This reverts commit 1f86123b9749 ("net: align SO_RCVMARK required
> privileges with SO_MARK") because the reasoning in the commit message
> is not really correct:
>   SO_RCVMARK is used for 'reading' incoming skb mark (via cmsg), as such
>   it is more equivalent to 'getsockopt(SO_MARK)' which has no priv check
>   and retrieves the socket mark, rather than 'setsockopt(SO_MARK) which
>   sets the socket mark and does require privs.
> 
>   Additionally incoming skb->mark may already be visible if
>   sysctl_fwmark_reflect and/or sysctl_tcp_fwmark_accept are enabled.
> 
>   Furthermore, it is easier to block the getsockopt via bpf
>   (either cgroup setsockopt hook, or via syscall filters)
>   then to unblock it if it requires CAP_NET_RAW/ADMIN.
> 
> On Android the socket mark is (among other things) used to store
> the network identifier a socket is bound to.  Setting it is privileged,
> but retrieving it is not.  We'd like unprivileged userspace to be able
> to read the network id of incoming packets (where mark is set via
> iptables [to be moved to bpf])...
> 
> An alternative would be to add another sysctl to control whether
> setting SO_RCVMARK is privilged or not.
> (or even a MASK of which bits in the mark can be exposed)
> But this seems like over-engineering...
> 
> Note: This is a non-trivial revert, due to later merged commit e42c7beee71d
> ("bpf: net: Consider has_current_bpf_ctx() when testing capable() in sk_setsockopt()")
> which changed both 'ns_capable' into 'sockopt_ns_capable' calls.
> 
> Fixes: 1f86123b9749 ("net: align SO_RCVMARK required privileges with SO_MARK")
> Cc: Larysa Zaremba <larysa.zaremba@intel.com>
> Cc: Simon Horman <simon.horman@corigine.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Eyal Birger <eyal.birger@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Patrick Rohr <prohr@google.com>
> Signed-off-by: Maciej Żenczykowski <maze@google.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>


> ---
>  net/core/sock.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 24f2761bdb1d..6e5662ca00fe 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1362,12 +1362,6 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
>  		__sock_set_mark(sk, val);
>  		break;
>  	case SO_RCVMARK:
> -		if (!sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
> -		    !sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
> -			ret = -EPERM;
> -			break;
> -		}
> -
>  		sock_valbool_flag(sk, SOCK_RCVMARK, valbool);
>  		break;
>  
> -- 
> 2.41.0.162.gfafddb0af9-goog

