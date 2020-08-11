Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51697241F19
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 19:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgHKRXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 13:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729150AbgHKRXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 13:23:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5346C06174A;
        Tue, 11 Aug 2020 10:23:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0C43812880A14;
        Tue, 11 Aug 2020 10:06:55 -0700 (PDT)
Date:   Tue, 11 Aug 2020 10:23:39 -0700 (PDT)
Message-Id: <20200811.102339.667052777479413338.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     joel@joelfernandes.org, jknoos@google.com, gvrose8192@gmail.com,
        urezki@gmail.com, paulmck@kernel.org, dev@openvswitch.org,
        netdev@vger.kernel.org, rcu@vger.kernel.org
Subject: Re: [PATCH] net: openvswitch: introduce common code for flushing
 flows
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200811011001.75690-1-xiangxia.m.yue@gmail.com>
References: <20200811011001.75690-1-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Aug 2020 10:06:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Tue, 11 Aug 2020 09:10:01 +0800

> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 42f8cc70bb2c..5fec47e62615 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -1756,6 +1756,9 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  /* Called with ovs_mutex. */
>  static void __dp_destroy(struct datapath *dp)
>  {
> +	struct flow_table *table = &dp->table;
> +	struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
> +	struct table_instance *ti = ovsl_dereference(table->ti);
>  	int i;
>  
>  	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++) {

Please use reverse christmas tree ordering for local variables.
