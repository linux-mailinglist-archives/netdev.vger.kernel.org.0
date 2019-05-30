Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3861730469
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfE3V6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:58:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60918 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfE3V6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:58:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 126A414DB0337;
        Thu, 30 May 2019 14:23:31 -0700 (PDT)
Date:   Thu, 30 May 2019 14:23:30 -0700 (PDT)
Message-Id: <20190530.142330.1051109681619079707.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/7] net: add rcu annotations for ifa_list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529114332.19163-1-fw@strlen.de>
References: <20190529114332.19163-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 14:23:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Wed, 29 May 2019 13:43:25 +0200

> Eric Dumazet reported follwing problem:
> 
>   It looks that unless RTNL is held, accessing ifa_list needs proper RCU
>   protection.  indev->ifa_list can be changed under us by another cpu
>   (which owns RTNL) [..]
> 
>   A proper rcu_dereference() with an happy sparse support would require
>   adding __rcu attribute.
> 
> This patch series does that: add __rcu to the ifa_list pointers.
> That makes sparse complain, so the series also adds the required
> rcu_assign_pointer/dereference helpers where needed.
> 
> All patches except the last one are preparation work.
> Two new macros are introduced for in_ifaddr walks.
> 
> Last patch adds the __rcu annotations and the assign_pointer/dereference
> helper calls.
> 
> This patch is a bit large, but I found no better way -- other
> approaches (annotate-first or add helpers-first) all result in
> mid-series sparse warnings.
 ...

Florian, this series looks fine to me.

Please address David's feedback and respin.

Thanks.
