Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7724D180BA1
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgCJWeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:34:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43350 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgCJWeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:34:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF38A14BBE02E;
        Tue, 10 Mar 2020 15:34:08 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:34:08 -0700 (PDT)
Message-Id: <20200310.153408.209273615201195266.davem@davemloft.net>
To:     shakeelb@google.com
Cc:     edumazet@google.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, gthelen@google.com, akpm@linux-foundation.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] net: memcg: late association of sock to memcg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310051606.33121-2-shakeelb@google.com>
References: <20200310051606.33121-1-shakeelb@google.com>
        <20200310051606.33121-2-shakeelb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 15:34:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>
Date: Mon,  9 Mar 2020 22:16:06 -0700

> If a TCP socket is allocated in IRQ context or cloned from unassociated
> (i.e. not associated to a memcg) in IRQ context then it will remain
> unassociated for its whole life. Almost half of the TCPs created on the
> system are created in IRQ context, so, memory used by such sockets will
> not be accounted by the memcg.
> 
> This issue is more widespread in cgroup v1 where network memory
> accounting is opt-in but it can happen in cgroup v2 if the source socket
> for the cloning was created in root memcg.
> 
> To fix the issue, just do the association of the sockets at the accept()
> time in the process context and then force charge the memory buffer
> already used and reserved by the socket.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

Applied and queued up for -stable.
