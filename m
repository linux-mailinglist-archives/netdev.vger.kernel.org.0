Return-Path: <netdev+bounces-5850-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACB50713266
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 06:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66A91281971
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 04:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F0F3646;
	Sat, 27 May 2023 04:01:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408AB389
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 04:01:09 +0000 (UTC)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441E5116;
	Fri, 26 May 2023 21:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685160068; x=1716696068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CQt0nDKa/AaCvMZ5vbLQ2an2NAXwM5jDjQNkJukx6WI=;
  b=T5ehh+1UsuVPXB4PesipDyOKqukVFmsD/B+opgLIH6HWqdyRc8x2Y/Fv
   j42cQ5IB79AokRFcq2maahyUoNY3XJUNwPf6S66afF++BIV3Uy9pJKklN
   z+ekXU4CLpIWgAfCey7/mdQRNQuTyDHgF/a8Y0CSIUlcG3d0DbFtpDI8q
   k=;
X-IronPort-AV: E=Sophos;i="6.00,195,1681171200"; 
   d="scan'208";a="336193380"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2023 04:01:05 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com (Postfix) with ESMTPS id E7004803C8;
	Sat, 27 May 2023 04:01:02 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Sat, 27 May 2023 04:00:48 +0000
Received: from 88665a182662.ant.amazon.com.com (10.142.145.230) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Sat, 27 May 2023 04:00:46 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <linmiaohe@huawei.com>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH] net: skbuff: fix missing a __noreturn annotation warning
Date: Fri, 26 May 2023 21:00:38 -0700
Message-ID: <20230527040038.6783-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230527110409.497408-1-linmiaohe@huawei.com>
References: <20230527110409.497408-1-linmiaohe@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.142.145.230]
X-ClientProxiedBy: EX19D035UWB002.ant.amazon.com (10.13.138.97) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Sat, 27 May 2023 19:04:09 +0800
> Add __noreturn annotation to fix the warning:
>  net/core/skbuff.o: warning: objtool: skb_push+0x3c: skb_panic() is missing a __noreturn annotation
>  net/core/skbuff.o: warning: objtool: skb_put+0x4e: skb_panic() is missing a __noreturn annotation

What arch are you using ?

IIUC, BUG() should have an annotation for objtool, for
example, __builtin_unreachable() for x86.

Maybe the arch is missing such an annotation ?

Also I'm curious why objtool complains about only skb_push(),
there should be more non-inline functions that has BUG().

Thanks,
Kuniyuki


> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  net/core/skbuff.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 6724a84ebb09..12b525aa4783 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -181,8 +181,8 @@ EXPORT_SYMBOL_GPL(drop_reasons_unregister_subsys);
>   *	Keep out of line to prevent kernel bloat.
>   *	__builtin_return_address is not used because it is not always reliable.
>   */
> -static void skb_panic(struct sk_buff *skb, unsigned int sz, void *addr,
> -		      const char msg[])
> +static void __noreturn skb_panic(struct sk_buff *skb, unsigned int sz, void *addr,
> +				 const char msg[])
>  {
>  	pr_emerg("%s: text:%px len:%d put:%d head:%px data:%px tail:%#lx end:%#lx dev:%s\n",
>  		 msg, addr, skb->len, sz, skb->head, skb->data,
> -- 
> 2.27.0

