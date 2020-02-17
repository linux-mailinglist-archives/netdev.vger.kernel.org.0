Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1AE160837
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgBQCdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:33:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgBQCdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:33:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7EC3E153808C0;
        Sun, 16 Feb 2020 18:33:15 -0800 (PST)
Date:   Sun, 16 Feb 2020 18:33:15 -0800 (PST)
Message-Id: <20200216.183315.143837712192250537.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     jiri@mellanox.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: objagg: Replace zero-length arrays with
 flexible-array member
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200211205356.GA23101@embeddedor>
References: <20200211205356.GA23101@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 18:33:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Tue, 11 Feb 2020 14:53:56 -0600

> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertenly introduced[3] to the codebase from now on.
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied to net-next.
