Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D86169CAA
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 04:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgBXDhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 22:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbgBXDhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Feb 2020 22:37:11 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9ED720658;
        Mon, 24 Feb 2020 03:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582515431;
        bh=bMWinYyvGT80w5oedT9Rbs/engnkzF2JnlWfsVIxAuo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YqrqJt4l8GfWNjwMJZacU2i237vH9VE9qQ2bX5hH/AQWu11v2lPCUnwB8Khb+3d2Q
         FcCypZYTJfmPT7CG+IvMIdZAQe9AMoT9QRHtp13A8I1tLQGghZvfOBBSS6sd5okbtu
         HpcwrrJDyVsKyo5KzhcqfNkDcETpa12TqalyEt7o=
Date:   Sun, 23 Feb 2020 19:37:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Arjun Roy <arjunroy@google.com>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH resend mm,net-next 3/3] net-zerocopy: Use
 vm_insert_pages() for tcp rcv zerocopy.
Message-Id: <20200223193710.596fb5d9ebb23959a3fee187@linux-foundation.org>
In-Reply-To: <CAOFY-A0G+NOpi7r=gnrLNsJ-OHYnGKCJ0mJ5PWwH5m7_99bD5w@mail.gmail.com>
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
        <20200128025958.43490-3-arjunroy.kdev@gmail.com>
        <20200212185605.d89c820903b7aa9fbbc060b2@linux-foundation.org>
        <CAOFY-A1o0L_D7Oyi1S=+Ng+2dK35-QHSSUQ9Ct3EA5y-DfWaXA@mail.gmail.com>
        <CAOFY-A0G+NOpi7r=gnrLNsJ-OHYnGKCJ0mJ5PWwH5m7_99bD5w@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Feb 2020 13:21:41 -0800 Arjun Roy <arjunroy@google.com> wrote:

> I remain a bit concerned regarding the merge process for this specific
> patch (0003, the net/ipv4/tcp.c change) since I have other in-flight
> changes for TCP receive zerocopy that I'd like to upstream for
> net-next - and would like to avoid weird merge issues.
> 
> So perhaps the following could work:
> 
> 1. Andrew, perhaps we could remove this particular patch (0003, the
> net/ipv4/tcp.c change) from mm-next; that way we merge
> vm_insert_pages() but not the call-site within TCP, for now.
> 2. net-next will eventually pick vm_insert_pages() up.
> 3. I can modify the zerocopy code to use it at that point?
> 
> Else I'm concerned a complicated merge situation may result.
> 
> What do you all think?

We could do that.

For now, I'll stage the entire patch series after linux-next and shall
wait and see whether things which appear in linux-next cause serious
merge issues to occur.  Sound OK?
