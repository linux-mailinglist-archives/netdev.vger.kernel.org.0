Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3329DC8D3F
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 17:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfJBPr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 11:47:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33118 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfJBPr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 11:47:28 -0400
Received: from localhost (unknown [172.58.43.221])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 94C4214D07211;
        Wed,  2 Oct 2019 08:47:25 -0700 (PDT)
Date:   Wed, 02 Oct 2019 11:47:09 -0400 (EDT)
Message-Id: <20191002.114709.1902747897923909745.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, pabeni@redhat.com,
        edumazet@google.com, petrm@mellanox.com, sd@queasysnail.net,
        f.fainelli@gmail.com, stephen@networkplumber.org,
        mlxsw@mellanox.com, andrew@lunn.ch
Subject: Re: [patch net-next 2/3] net: introduce per-netns netdevice
 notifiers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190930081511.26915-3-jiri@resnulli.us>
References: <20190930081511.26915-1-jiri@resnulli.us>
        <20190930081511.26915-3-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 08:47:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Mon, 30 Sep 2019 10:15:10 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Often the code for example in drivers is interested in getting notifier
> call only from certain network namespace. In addition to the existing
> global netdevice notifier chain introduce per-netns chains and allow
> users to register to that. Eventually this would eliminate unnecessary
> overhead in case there are many netdevices in many network namespaces.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Ok, so there was a discussion about stop semantics.

Honestly, I think that's fine.

Stop means the operation cannot be performed and whoever is firing off
the notifier will have to fail and undo the config change being
attempted.

In that context, it doesn't matter who or where in the chain we
trigger the stop.

Given all of that I am pretty sure this change is fine and I will
add it to net-next.  We can fix any actual semantic problems this
might introduce as a follow-on.
