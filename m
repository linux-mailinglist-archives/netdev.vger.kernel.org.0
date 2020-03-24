Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5843D191D74
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgCXXXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:23:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37850 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgCXXXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:23:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D19E159F4DA1;
        Tue, 24 Mar 2020 16:23:21 -0700 (PDT)
Date:   Tue, 24 Mar 2020 16:23:20 -0700 (PDT)
Message-Id: <20200324.162320.60114994463504898.davem@davemloft.net>
To:     kuniyu@amazon.co.jp
Cc:     kuba@kernel.org, edumazet@google.com, gerrit@erg.abdn.ac.uk,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        dccp@vger.kernel.org, netdev@vger.kernel.org, kuni1840@gmail.com,
        osa-contribution-log@amazon.com
Subject: Re: [PATCH v2 net-next] tcp/dccp: Move initialisation of
 refcounted into if block.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200324113331.29031-1-kuniyu@amazon.co.jp>
References: <20200324113331.29031-1-kuniyu@amazon.co.jp>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Mar 2020 16:23:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date: Tue, 24 Mar 2020 20:33:31 +0900

> The refcounted seems to be initialised at most three times, but the
> complier can optimize that and the refcounted is initialised only at once.
> 
>   - __inet_lookup_skb() sets it true.
>   - skb_steal_sock() is false and __inet_lookup() sets it true.
>   - __inet_lookup_established() is false and __inet_lookup() sets it false.
> 
> The code is bit confusing, so this patch makes it more readable so that no
> one doubt about the complier optimization.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

I don't think this improves the code readability nor code generation, it's
just noise changes and will make backporting more difficult.

I'm not applying this sorry.

In the future, I am going to apply a large threshold as to whether
changes like this are reasonable and appropriate.  Please keep that
in mind for your submissions.

Thank you.
