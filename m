Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A61318389E
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgCLS0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:26:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33564 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbgCLS0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:26:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44F29157413E1;
        Thu, 12 Mar 2020 11:26:35 -0700 (PDT)
Date:   Thu, 12 Mar 2020 11:26:34 -0700 (PDT)
Message-Id: <20200312.112634.1418678520292902314.davem@davemloft.net>
To:     vinicius.gomes@intel.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, aaron.f.brown@intel.com, sasha.neftin@intel.com,
        michael.schmidt@eti.uni-siegen.de
Subject: Re: [PATCH net v1] taprio: Fix sending packets without dequeueing
 them
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309173953.2822360-1-vinicius.gomes@intel.com>
References: <20200309173953.2822360-1-vinicius.gomes@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 11:26:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Mon,  9 Mar 2020 10:39:53 -0700

> There was a bug that was causing packets to be sent to the driver
> without first calling dequeue() on the "child" qdisc. And the KASAN
> report below shows that sending a packet without calling dequeue()
> leads to bad results.
> 
> The problem is that when checking the last qdisc "child" we do not set
> the returned skb to NULL, which can cause it to be sent to the driver,
> and so after the skb is sent, it may be freed, and in some situations a
> reference to it may still be in the child qdisc, because it was never
> dequeued.
> 
> The crash log looks like this:
 ...
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
> Reported-by: Michael Schmidt <michael.schmidt@eti.uni-siegen.de>
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Applied and queued up for -stable, thanks.
