Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F45F676A2
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfGLWqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:46:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34452 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbfGLWqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:46:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44A9A14E038D1;
        Fri, 12 Jul 2019 15:46:07 -0700 (PDT)
Date:   Fri, 12 Jul 2019 15:46:06 -0700 (PDT)
Message-Id: <20190712.154606.493382088615011132.davem@davemloft.net>
To:     cai@lca.pw
Cc:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        arnd@arndb.de, dhowells@redhat.com, hpa@zytor.com,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] be2net: fix adapter->big_page_size miscaculation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562959401-19815-1-git-send-email-cai@lca.pw>
References: <1562959401-19815-1-git-send-email-cai@lca.pw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 15:46:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Date: Fri, 12 Jul 2019 15:23:21 -0400

> The commit d66acc39c7ce ("bitops: Optimise get_order()") introduced a
> problem for the be2net driver as "rx_frag_size" could be a module
> parameter that can be changed while loading the module.

Why is this a problem?

> That commit checks __builtin_constant_p() first in get_order() which
> cause "adapter->big_page_size" to be assigned a value based on the
> the default "rx_frag_size" value at the compilation time. It also
> generate a compilation warning,

rx_frag_size is not a constant, therefore the __builtin_constant_p()
test should not pass.

This explanation doesn't seem valid.
