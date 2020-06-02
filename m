Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EB81EC41B
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 23:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgFBVBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 17:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgFBVBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 17:01:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD58C08C5C0;
        Tue,  2 Jun 2020 14:01:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B9DB51276B16B;
        Tue,  2 Jun 2020 14:01:11 -0700 (PDT)
Date:   Tue, 02 Jun 2020 14:01:08 -0700 (PDT)
Message-Id: <20200602.140108.2199333313862275860.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     patrickeigensatz@gmail.com, dsahern@kernel.org,
        scan-admin@coverity.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: nexthop: Fix deadcode issue by performing a
 proper NULL check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4e6ba1a8-be3b-fd22-e0b8-485d33bb51eb@cumulusnetworks.com>
References: <20200601111201.64124-1-patrick.eigensatz@gmail.com>
        <20200601.110654.1178868171436999333.davem@davemloft.net>
        <4e6ba1a8-be3b-fd22-e0b8-485d33bb51eb@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jun 2020 14:01:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Tue, 2 Jun 2020 10:23:09 +0300

> On 01/06/2020 21:06, David Miller wrote:
>> From: patrickeigensatz@gmail.com
>> Date: Mon,  1 Jun 2020 13:12:01 +0200
>> 
>>> From: Patrick Eigensatz <patrickeigensatz@gmail.com>
>>>
>>> After allocating the spare nexthop group it should be tested for kzalloc()
>>> returning NULL, instead the already used nexthop group (which cannot be
>>> NULL at this point) had been tested so far.
>>>
>>> Additionally, if kzalloc() fails, return ERR_PTR(-ENOMEM) instead of NULL.
>>>
>>> Coverity-id: 1463885
>>> Reported-by: Coverity <scan-admin@coverity.com>
>>> Signed-off-by: Patrick Eigensatz <patrickeigensatz@gmail.com>
>> 
>> Applied, thank you.
>> 
> 
> Hi Dave,
> I see this patch in -net-next but it should've been in -net as I wrote in my
> review[1]. This patch should go along with the recent nexthop set that fixes
> a few bugs, since it could result in a null ptr deref if the spare group cannot
> be allocated.
> How would you like to proceed? Should it be submitted for -net as well?

When I'm leading up to the merge window I just toss everything into net-next
and still queue things to -stable as needed.
