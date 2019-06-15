Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6057D46DD0
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfFOCas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:30:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57504 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFOCas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:30:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E728913C267E2;
        Fri, 14 Jun 2019 19:30:47 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:30:47 -0700 (PDT)
Message-Id: <20190614.193047.261788013564267611.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, pablo@netfilter.org, alexanderk@mellanox.com,
        pabeni@redhat.com, mlxsw@mellanox.com, jiri@mellanox.com
Subject: Re: [PATCH net] net: sched: flower: don't call synchronize_rcu()
 on mask creation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190613145404.4774-1-vladbu@mellanox.com>
References: <20190613145404.4774-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:30:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Thu, 13 Jun 2019 17:54:04 +0300

> Current flower mask creating code assumes that temporary mask that is used
> when inserting new filter is stack allocated. To prevent race condition
> with data patch synchronize_rcu() is called every time fl_create_new_mask()
> replaces temporary stack allocated mask. As reported by Jiri, this
> increases runtime of creating 20000 flower classifiers from 4 seconds to
> 163 seconds. However, this design is no longer necessary since temporary
> mask was converted to be dynamically allocated by commit 2cddd2014782
> ("net/sched: cls_flower: allocate mask dynamically in fl_change()").
> 
> Remove synchronize_rcu() calls from mask creation code. Instead, refactor
> fl_change() to always deallocate temporary mask with rcu grace period.
> 
> Fixes: 195c234d15c9 ("net: sched: flower: handle concurrent mask insertion")
> Reported-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Applied, thanks.
