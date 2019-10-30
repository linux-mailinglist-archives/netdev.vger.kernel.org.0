Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C74EA545
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfJ3VSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:18:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46686 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3VSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:18:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 735C814C60CF9;
        Wed, 30 Oct 2019 14:18:37 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:18:34 -0700 (PDT)
Message-Id: <20191030.141834.1101560184694944976.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     gvrose8192@gmail.com, pshelar@ovn.org, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: Re: [PATCH net-next v5 02/10] net: openvswitch: convert mask list
 in mask array
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571472524-73832-3-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
        <1571472524-73832-3-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 14:18:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Sat, 19 Oct 2019 16:08:36 +0800

> @@ -611,13 +683,8 @@ struct sw_flow *ovs_flow_tbl_lookup_ufid(struct flow_table *tbl,
>  
>  int ovs_flow_tbl_num_masks(const struct flow_table *table)
>  {
> -	struct sw_flow_mask *mask;
> -	int num = 0;
> -
> -	list_for_each_entry(mask, &table->mask_list, list)
> -		num++;
> -
> -	return num;
> +	struct mask_array *ma = rcu_dereference_ovsl(table->mask_array);
> +	return ma->count;
>  }

Please put an empty line between the variable declarations and the start of the
code in this function.
