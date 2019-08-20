Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD14896AF9
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbfHTU6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:58:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51012 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729833AbfHTU6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 16:58:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C2E66148190A1;
        Tue, 20 Aug 2019 13:58:03 -0700 (PDT)
Date:   Tue, 20 Aug 2019 13:58:03 -0700 (PDT)
Message-Id: <20190820.135803.846099092737191145.davem@davemloft.net>
To:     liudongxu3@huawei.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Fix detection for IPv4 duplicate address.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190820151905.13148-1-liudongxu3@huawei.com>
References: <20190820151905.13148-1-liudongxu3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 13:58:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dongxu Liu <liudongxu3@huawei.com>
Date: Tue, 20 Aug 2019 23:19:05 +0800

> @@ -800,8 +800,11 @@ static int arp_process(struct net *net, struct sock *sk, struct sk_buff *skb)
>  			    iptunnel_metadata_reply(skb_metadata_dst(skb),
>  						    GFP_ATOMIC);
>  
> -	/* Special case: IPv4 duplicate address detection packet (RFC2131) */
> -	if (sip == 0) {
> +/* Special case: IPv4 duplicate address detection packet (RFC2131).
> + * Linux usually sends zero to detect duplication, and windows may
> + * send a same ip (not zero, sip equal to tip) to do this detection.
> + */
> +	if (sip == 0 || sip == tip) {

Regardless of whether this is a valid change or not, you've unindented the
comment which is completely inappropriate.
