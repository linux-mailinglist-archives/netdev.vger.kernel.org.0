Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF7EF1555B3
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 11:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgBGKbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 05:31:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40742 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgBGKbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 05:31:47 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 17CC315A31B38;
        Fri,  7 Feb 2020 02:31:45 -0800 (PST)
Date:   Fri, 07 Feb 2020 11:31:44 +0100 (CET)
Message-Id: <20200207.113144.779256801446560370.davem@davemloft.net>
To:     vinicius.gomes@intel.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: Re: [PATCH net v4 0/5] taprio: Some fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200206214610.1307191-1-vinicius.gomes@intel.com>
References: <20200206214610.1307191-1-vinicius.gomes@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 02:31:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Thu,  6 Feb 2020 13:46:05 -0800

 ...
> One bit that might need some attention is the fix for not dropping all
> packets when taprio and ETF offloading are used, patch 5/5. The
> behavior when the fix is applied is that packets that have a 'txtime'
> that would fall outside of their transmission window are now dropped
> by taprio. The question that might be raised is: should taprio be
> responsible for dropping these packets, or should it be handled lower
> in the stack?
> 
> My opinion is: taprio has all the information, and it's able to give
> feeback to the user. Lower in the stack, those packets might go into
> the void, and the only feedback could be a hard to find counter
> increasing.
> 
> Patch 1/5: Reported by Po Liu, is more of a improvement of usability for
> drivers implementing offloading features, now they can rely on the
> value of dev->num_tc, instead of going through some hops to get this
> value.
> 
> Patch 2/5: Use 'q->flags' as the source of truth for the offloading
> flags. Tries to solidify the current behavior, while avoiding going
> into invalid states, one of which was causing a "rcu stall" (more
> information in the commit message).
> 
> Patch 3/5: Adds the missing netlink attribute validation for
> TCA_TAPRIO_ATTR_FLAGS.
> 
> Patch 4/5: Replaces the usage of netdev_set_num_tc() with
> netdev_reset_tc() in taprio_destroy(), taprio_destroy() is called when
> applying a configuration fails, making sure that the device traffic
> class configuration goes back to the default state.
 ....

Series applied, thank you.
