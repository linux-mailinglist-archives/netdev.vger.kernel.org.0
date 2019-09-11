Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A3BB0592
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 00:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbfIKWcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 18:32:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49710 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfIKWcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 18:32:17 -0400
Received: from localhost (unknown [88.214.186.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 405B7154F89E1;
        Wed, 11 Sep 2019 15:32:13 -0700 (PDT)
Date:   Thu, 12 Sep 2019 00:32:09 +0200 (CEST)
Message-Id: <20190912.003209.917226424625610557.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com, jay.vosburgh@canonical.com
Subject: Re: [PATCH net v2 01/11] net: core: limit nested device depth
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190907134532.31975-1-ap420073@gmail.com>
References: <20190907134532.31975-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 15:32:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Sat,  7 Sep 2019 22:45:32 +0900

> Current code doesn't limit the number of nested devices.
> Nested devices would be handled recursively and this needs huge stack
> memory. So, unlimited nested devices could make stack overflow.
 ...
> Splat looks like:
> [  140.483124] BUG: looking up invalid subclass: 8
> [  140.483505] turning off the locking correctness validator.

The limit here is not stack memory, but a limit in the lockdep
validator, which can probably be fixed by other means.

This was the feedback I saw given for the previous version of
this series as well.
