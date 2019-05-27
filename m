Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF1D82ADF0
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 07:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfE0FP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 01:15:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50736 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfE0FP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 01:15:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 876F6149027E0;
        Sun, 26 May 2019 22:15:56 -0700 (PDT)
Date:   Sun, 26 May 2019 22:15:56 -0700 (PDT)
Message-Id: <20190526.221556.885075788672387642.davem@davemloft.net>
To:     Igor.Russkikh@aquantia.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 1/4] net: aquantia: tx clean budget logic error
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f659b94aff7f57a4592d89d797060d24f22a1bb9.1558777421.git.igor.russkikh@aquantia.com>
References: <cover.1558777421.git.igor.russkikh@aquantia.com>
        <f659b94aff7f57a4592d89d797060d24f22a1bb9.1558777421.git.igor.russkikh@aquantia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 22:15:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <Igor.Russkikh@aquantia.com>
Date: Sat, 25 May 2019 09:57:59 +0000

> In case no other traffic happening on the ring, full tx cleanup
> may not be completed. That may cause socket buffer to overflow
> and tx traffic to stuck until next activity on the ring happens.
> 
> This is due to logic error in budget variable decrementor.
> Variable is compared with zero, and then post decremented,
> causing it to become MAX_INT. Solution is remove decrementor
> from the `for` statement and rewrite it in a clear way.
> 
> Fixes: b647d3980948e ("net: aquantia: Add tx clean budget and valid budget handling logic")
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>

I think the TX clean budget is a very bad idea.

You should always do as much TX clean work as there is TODO.
