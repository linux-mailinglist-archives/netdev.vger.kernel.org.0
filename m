Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE6A5C709
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfGBCSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:18:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54054 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGBCSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:18:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 38C1C14DE9A78;
        Mon,  1 Jul 2019 19:18:19 -0700 (PDT)
Date:   Mon, 01 Jul 2019 19:18:18 -0700 (PDT)
Message-Id: <20190701.191818.2016313422296779356.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 0/2] Fix batched event generation for mirred
 action
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561746618-29349-1-git-send-email-mrv@mojatatu.com>
References: <1561746618-29349-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 19:18:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Fri, 28 Jun 2019 14:30:16 -0400

> When adding or deleting a batch of entries, the kernel sends upto
> TCA_ACT_MAX_PRIO entries in an event to user space. However it does not
> consider that the action sizes may vary and require different skb sizes.
> 
> For example :
> 
> % cat tc-batch.sh
> TC="sudo /mnt/iproute2.git/tc/tc"
> 
> $TC actions flush action mirred
> for i in `seq 1 $1`;
> do
>    cmd="action mirred egress redirect dev lo index $i "
>    args=$args$cmd
> done
> $TC actions add $args
> %
> % ./tc-batch.sh 32
> Error: Failed to fill netlink attributes while adding TC action.
> We have an error talking to the kernel
> %
> 
> patch 1 adds callback in tc_action_ops of mirred action, which calculates
> the action size, and passes size to tcf_add_notify()/tcf_del_notify().
> 
> patch 2 updates the TDC test suite with relevant test cases.

Series applied, thanks.
