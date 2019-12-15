Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A643E11FB28
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 21:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfLOUlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 15:41:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43682 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbfLOUlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 15:41:20 -0500
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 23C6114D8519A;
        Sun, 15 Dec 2019 12:41:20 -0800 (PST)
Date:   Sun, 15 Dec 2019 12:41:19 -0800 (PST)
Message-Id: <20191215.124119.1034274845955800225.davem@davemloft.net>
To:     ptalbert@redhat.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: Use rx_nohandler for unhandled packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191211162107.4326-1-ptalbert@redhat.com>
References: <20191211162107.4326-1-ptalbert@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Dec 2019 12:41:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrick Talbert <ptalbert@redhat.com>
Date: Wed, 11 Dec 2019 17:21:07 +0100

> Since caf586e5f23c ("net: add a core netdev->rx_dropped counter") incoming
> packets which do not have a handler cause a counter named rx_dropped to be
> incremented. This can lead to confusion as some see a non-zero "drop"
> counter as cause for concern.
> 
> To avoid any confusion, instead use the existing rx_nohandler counter. Its
> name more closely aligns with the activity being tracked here.
> 
> Signed-off-by: Patrick Talbert <ptalbert@redhat.com>

I disagree with this change.

When deliver_exact is false we try to deliver the packet to an appropriate
ptype handler.  And we end up in the counter bump if no ptype handler
exists.

Therefore, the two counters allow to distinguish two very different
situations and providing that distinction is quite valuable.

I think this distinction was very much intentional.  Having people
understand that rx_dropped can have this meaning is merely a matter of
education.

I'm not applying this patch, sorry.
