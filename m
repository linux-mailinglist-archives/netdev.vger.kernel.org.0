Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E4B13780
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 06:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfEDElJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 00:41:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56212 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfEDElJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 00:41:09 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B1D514D8D47F;
        Fri,  3 May 2019 21:41:03 -0700 (PDT)
Date:   Sat, 04 May 2019 00:41:00 -0400 (EDT)
Message-Id: <20190504.004100.415091334346243894.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, ian.kumlien@gmail.com,
        alan.maguire@oracle.com, dsahern@gmail.com
Subject: Re: [PATCH net] neighbor: Reset gc_entries counter if new entry is
 released before insert
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190502010834.25519-1-dsahern@kernel.org>
References: <20190502010834.25519-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 21:41:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed,  1 May 2019 18:08:34 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Ian and Alan both reported seeing overflows after upgrades to 5.x kernels:
>   neighbour: arp_cache: neighbor table overflow!
> 
> Alan's mpls script helped get to the bottom of this bug. When a new entry
> is created the gc_entries counter is bumped in neigh_alloc to check if a
> new one is allowed to be created. ___neigh_create then searches for an
> existing entry before inserting the just allocated one. If an entry
> already exists, the new one is dropped in favor of the existing one. In
> this case the cleanup path needs to drop the gc_entries counter. There
> is no memory leak, only a counter leak.
> 
> Fixes: 58956317c8d ("neighbor: Improve garbage collection")
> Reported-by: Ian Kumlien <ian.kumlien@gmail.com>
> Reported-by: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied and queued up for -stable.
