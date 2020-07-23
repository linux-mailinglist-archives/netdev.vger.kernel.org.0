Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3D122B935
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGWWL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgGWWL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 18:11:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7A2C0619D3;
        Thu, 23 Jul 2020 15:11:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A80C611E48C62;
        Thu, 23 Jul 2020 14:55:13 -0700 (PDT)
Date:   Thu, 23 Jul 2020 15:11:58 -0700 (PDT)
Message-Id: <20200723.151158.2190104866687627036.davem@davemloft.net>
To:     madhuparnabhowmik10@gmail.com
Cc:     isdn@linux-pingi.de, arnd@arndb.de, gregkh@linuxfoundation.org,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrianov@ispras.ru,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] drivers: isdn: capi: Fix data-race bug
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722172329.16727-1-madhuparnabhowmik10@gmail.com>
References: <20200722172329.16727-1-madhuparnabhowmik10@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 14:55:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: madhuparnabhowmik10@gmail.com
Date: Wed, 22 Jul 2020 22:53:29 +0530

> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> In capi_init(), after register_chrdev() the file operation callbacks
> can be called. However capinc_tty_init() is called later.
> Since capiminors and capinc_tty_driver are initialized in
> capinc_tty_init(), their initialization can race with their usage
> in various callbacks like in capi_release().
> 
> Therefore, call capinc_tty_init() before register_chrdev to avoid
> such race conditions.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

I agree with Arnd that this just exchanges one set of problems for
another.
