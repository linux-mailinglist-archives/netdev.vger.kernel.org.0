Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBF5169D6B
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 06:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgBXFOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 00:14:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59100 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgBXFOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 00:14:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1499D153DA507;
        Sun, 23 Feb 2020 21:14:46 -0800 (PST)
Date:   Sun, 23 Feb 2020 21:14:45 -0800 (PST)
Message-Id: <20200223.211445.2002575104492612118.davem@davemloft.net>
To:     lirongqing@baidu.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH][net-next] tcpv6: define th variable only once
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1582444614-6461-1-git-send-email-lirongqing@baidu.com>
References: <1582444614-6461-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Feb 2020 21:14:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>
Date: Sun, 23 Feb 2020 15:56:54 +0800

> @@ -51,7 +51,7 @@ static struct sk_buff *tcp6_gso_segment(struct sk_buff *skb,
>  
>  	if (unlikely(skb->ip_summed != CHECKSUM_PARTIAL)) {
>  		const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
> -		struct tcphdr *th = tcp_hdr(skb);
> +		th = tcp_hdr(skb);
>  
>  		/* Set up pseudo header, usually expect stack to have done

This doesn't leave a new line before local variable declarations and
statements.

But even more interesting, is that the top level declaration of 'th'
can be removed the solve this warning and restricts the scope of 'th'
to where it is actually used.
