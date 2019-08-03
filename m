Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC1F08037A
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 02:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392554AbfHCA3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 20:29:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52538 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392478AbfHCA3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 20:29:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1DAD1264F78D;
        Fri,  2 Aug 2019 17:29:43 -0700 (PDT)
Date:   Fri, 02 Aug 2019 17:29:42 -0700 (PDT)
Message-Id: <20190802.172942.1360727502972215986.davem@davemloft.net>
To:     suyj.fnst@cn.fujitsu.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net: ipv6: Fix a bug in ndisc_send_ns when
 netdev only has a global address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564537972-76503-1-git-send-email-suyj.fnst@cn.fujitsu.com>
References: <1564537972-76503-1-git-send-email-suyj.fnst@cn.fujitsu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Aug 2019 17:29:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
Date: Wed, 31 Jul 2019 09:52:52 +0800

> When the egress interface does not have a link local address, it can
> not communicate with other hosts.
> 
> In RFC4861, 7.2.2 says
> "If the source address of the packet prompting the solicitation is the
> same as one of the addresses assigned to the outgoing interface, that
> address SHOULD be placed in the IP Source Address of the outgoing
> solicitation.  Otherwise, any one of the addresses assigned to the
> interface should be used."
> 
> In this patch we try get a global address if we get ll address failed.
> 
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> ---
> Changes since V2:
> 	- Let banned_flags under the scope of its use.

I do not want to apply this.

The only situation where this can occur is when userland is managing the
interface addresses and has failed to properly add a link local address.

That is a failure by userspace to uphold it's responsibilites when it
has taken over management of these issues, not a situation the kernel
should handle.

Sorry.
