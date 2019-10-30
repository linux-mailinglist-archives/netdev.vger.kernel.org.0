Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 446DDEA549
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfJ3VTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:19:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46706 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3VTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:19:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DCACC14C2C722;
        Wed, 30 Oct 2019 14:19:47 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:19:47 -0700 (PDT)
Message-Id: <20191030.141947.1034101510343049475.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     gvrose8192@gmail.com, pshelar@ovn.org, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: Re: [PATCH net-next v5 06/10] net: openvswitch: simplify the
 flow_hash
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571472524-73832-7-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
        <1571472524-73832-7-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 14:19:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Sat, 19 Oct 2019 16:08:40 +0800

> @@ -432,13 +432,9 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
>  static u32 flow_hash(const struct sw_flow_key *key,
>  		     const struct sw_flow_key_range *range)
>  {
> -	int key_start = range->start;
> -	int key_end = range->end;
> -	const u32 *hash_key = (const u32 *)((const u8 *)key + key_start);
> -	int hash_u32s = (key_end - key_start) >> 2;
> -
> +	const u32 *hash_key = (const u32 *)((const u8 *)key + range->start);
>  	/* Make sure number of hash bytes are multiple of u32. */
> -	BUILD_BUG_ON(sizeof(long) % sizeof(u32));
> +	int hash_u32s = range_n_bytes(range) >> 2;

Please place an empty line between the last local variable declaration and
the start of comments and code in the body of the function.

Thank you.
