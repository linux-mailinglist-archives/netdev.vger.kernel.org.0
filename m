Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0643AD5A
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 04:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387475AbfFJCyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 22:54:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48896 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387400AbfFJCyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 22:54:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5BE0114EADFBE;
        Sun,  9 Jun 2019 19:54:21 -0700 (PDT)
Date:   Sun, 09 Jun 2019 19:54:20 -0700 (PDT)
Message-Id: <20190609.195420.1742255944804133266.davem@davemloft.net>
To:     hariprasad.kelam@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: exthdrs: fix warning comparison to bool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190608083532.GA7288@hari-Inspiron-1545>
References: <20190608083532.GA7288@hari-Inspiron-1545>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 19:54:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Date: Sat, 8 Jun 2019 14:05:33 +0530

> Fix below warning reported by coccicheck
> 
> net/ipv6/exthdrs.c:180:9-29: WARNING: Comparison to bool
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
 ...
> diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> index ab5add0..e137325 100644
> --- a/net/ipv6/exthdrs.c
> +++ b/net/ipv6/exthdrs.c
> @@ -177,7 +177,7 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
>  					/* type specific length/alignment
>  					   checks will be performed in the
>  					   func(). */
> -					if (curr->func(skb, off) == false)
> +					if (!curr->func(skb, off))

curr->func() returns type 'bool', whats wrong with comparing against the
same type?

I'm not applying stuff like this, sorry.
