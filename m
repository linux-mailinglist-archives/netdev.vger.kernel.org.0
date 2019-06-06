Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E4F37C69
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfFFSm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:42:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55674 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfFFSm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:42:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 74E2914DE9A90;
        Thu,  6 Jun 2019 11:42:56 -0700 (PDT)
Date:   Thu, 06 Jun 2019 11:42:55 -0700 (PDT)
Message-Id: <20190606.114255.365204463731451300.davem@davemloft.net>
To:     jcline@redhat.com
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, ian.kumlien@gmail.com,
        alan.maguire@oracle.com, dsahern@gmail.com
Subject: Re: [PATCH net] neighbor: Reset gc_entries counter if new entry is
 released before insert
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190606170729.GA15882@laptop.jcline.org>
References: <20190502010834.25519-1-dsahern@kernel.org>
        <20190504.004100.415091334346243894.davem@davemloft.net>
        <20190606170729.GA15882@laptop.jcline.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 11:42:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Cline <jcline@redhat.com>
Date: Thu, 6 Jun 2019 13:07:29 -0400

> Hi,
> 
> On Sat, May 04, 2019 at 12:41:00AM -0400, David Miller wrote:
>> From: David Ahern <dsahern@kernel.org>
>> Date: Wed,  1 May 2019 18:08:34 -0700
>> 
>> > From: David Ahern <dsahern@gmail.com>
>> > 
>> > Ian and Alan both reported seeing overflows after upgrades to 5.x kernels:
>> >   neighbour: arp_cache: neighbor table overflow!
>> > 
>> > Alan's mpls script helped get to the bottom of this bug. When a new entry
>> > is created the gc_entries counter is bumped in neigh_alloc to check if a
>> > new one is allowed to be created. ___neigh_create then searches for an
>> > existing entry before inserting the just allocated one. If an entry
>> > already exists, the new one is dropped in favor of the existing one. In
>> > this case the cleanup path needs to drop the gc_entries counter. There
>> > is no memory leak, only a counter leak.
>> > 
>> > Fixes: 58956317c8d ("neighbor: Improve garbage collection")
>> > Reported-by: Ian Kumlien <ian.kumlien@gmail.com>
>> > Reported-by: Alan Maguire <alan.maguire@oracle.com>
>> > Signed-off-by: David Ahern <dsahern@gmail.com>
>> 
>> Applied and queued up for -stable.
> 
> Did this get lost in the shuffle? I see it in mainline, but I don't see
> it in stable. Folks are encountering it with recent 5.1 kernels in
> Fedora: https://bugzilla.redhat.com/show_bug.cgi?id=1708717.

It's there in the -stable queue:

https://patchwork.ozlabs.org/bundle/davem/stable/?series=&submitter=&state=*&q=&archive=

So it will (eventually) get sent.
