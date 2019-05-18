Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1C422450
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 19:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbfERRpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 13:45:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58484 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfERRpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 13:45:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91BCA14DD8E90;
        Sat, 18 May 2019 10:45:14 -0700 (PDT)
Date:   Sat, 18 May 2019 10:45:12 -0700 (PDT)
Message-Id: <20190518.104512.963962673481938495.davem@davemloft.net>
To:     u9012063@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] net: ip6_gre: access skb data after skb_cow_head()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558023948-9428-1-git-send-email-u9012063@gmail.com>
References: <1558023948-9428-1-git-send-email-u9012063@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 May 2019 10:45:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Tu <u9012063@gmail.com>
Date: Thu, 16 May 2019 09:25:48 -0700

> When increases the headroom, skb's pointer might get re-allocated.
> Fix it by moving skb_cow_head before accessing the skb->data pointer.
> 
> Fixes: 01b8d064d58b4 ("net: ip6_gre: Request headroom in __gre6_xmit()")
> Reported-by: Haichao Ma <haichaom@vmware.com>
> Signed-off-by: William Tu <u9012063@gmail.com>

I don't understand the problem.

The fl6->daddr assignments are object copies, not pointer assignments.

So there are no dangling pointer references I can see.

Also, you need to explain exactly what dangling pointer is the problem
in your commit message.
