Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2476C22D1C1
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 00:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgGXWXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 18:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgGXWXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 18:23:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2C8C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 15:23:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D48F1274C3A7;
        Fri, 24 Jul 2020 15:07:01 -0700 (PDT)
Date:   Fri, 24 Jul 2020 15:23:45 -0700 (PDT)
Message-Id: <20200724.152345.2053253632022349577.davem@davemloft.net>
To:     lariel@mellanox.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, kuba@kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [PATCH net-next v4 0/2] TC datapath hash api
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722220301.4575-1-lariel@mellanox.com>
References: <20200722220301.4575-1-lariel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 15:07:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>
Date: Thu, 23 Jul 2020 01:02:59 +0300

> Hash based packet classification allows user to set up rules that
> provide load balancing of traffic across multiple vports and
> for ECMP path selection while keeping the number of rule at minimum.
> 
> Instead of matching on exact flow spec, which requires a rule per
> flow, user can define rules based on a their hash value and distribute
> the flows to different buckets. The number of rules
> in this case will be constant and equal to the number of buckets.
> 
> The series introduces an extention to the cls flower classifier
> and allows user to add rules that match on the hash value that
> is stored in skb->hash while assuming the value was set prior to
> the classification.
> 
> Setting the skb->hash can be done in various ways and is not defined
> in this series - for example:
> 1. By the device driver upon processing an rx packet.
> 2. Using tc action bpf with a program which computes and sets the
> skb->hash value.
> 
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 2 proto ip \
> flower hash 0x0/0xf  \
> action mirred egress redirect dev ens1f0_1
> 
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 2 proto ip \
> flower hash 0x1/0xf  \
> action mirred egress redirect dev ens1f0_2
> 
> v3 -> v4:
>  *Drop hash setting code leaving only the classidication parts.
>   Setting the hash will be possible via existing tc action bpf.
> 
> v2 -> v3:
>  *Split hash algorithm option into 2 different actions.
>   Asym_l4 available via act_skbedit and bpf via new act_hash.

Series applied, thank you.
