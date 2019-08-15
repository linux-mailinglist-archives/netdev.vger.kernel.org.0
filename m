Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B748F4DF
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733024AbfHOTll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:41:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49200 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733019AbfHOTlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:41:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CCC0414011A96;
        Thu, 15 Aug 2019 12:41:39 -0700 (PDT)
Date:   Thu, 15 Aug 2019 12:41:39 -0700 (PDT)
Message-Id: <20190815.124139.445961347424567252.davem@davemloft.net>
To:     john.fastabend@gmail.com
Cc:     jakub.kicinski@netronome.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, andreyknvl@google.com
Subject: Re: [net PATCH] net: tls, fix sk_write_space NULL write when tx
 disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156576071416.1402.5907777786031481705.stgit@ubuntu3-kvm1>
References: <156576071416.1402.5907777786031481705.stgit@ubuntu3-kvm1>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 12:41:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>
Date: Wed, 14 Aug 2019 05:31:54 +0000

> The ctx->sk_write_space pointer is only set when TLS tx mode is enabled.
> When running without TX mode its a null pointer but we still set the
> sk sk_write_space pointer on close().
> 
> Fix the close path to only overwrite sk->sk_write_space when the current
> pointer is to the tls_write_space function indicating the tls module should
> clean it up properly as well.
> 
> Reported-by: Hillf Danton <hdanton@sina.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: Andrey Konovalov <andreyknvl@google.com>
> Fixes: 57c722e932cfb ("net/tls: swap sk_write_space on close")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Applied, thanks John.

That Fixes tag takes one through an interesting chain of fixes to fixes.
I'll queue this up for -stable and make sure it all ends up in the
proper place.

Thanks.
