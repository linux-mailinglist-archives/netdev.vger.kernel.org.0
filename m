Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3300B4AF40
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 03:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbfFSBBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 21:01:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56030 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfFSBBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 21:01:38 -0400
Received: from localhost (unknown [8.46.76.24])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9FD2614B5B895;
        Tue, 18 Jun 2019 18:01:29 -0700 (PDT)
Date:   Tue, 18 Jun 2019 21:01:25 -0400 (EDT)
Message-Id: <20190618.210125.383827657449306914.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] net: lio_core: fix potential sign-extension
 overflow on large shift
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617161249.28846-1-colin.king@canonical.com>
References: <20190617161249.28846-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 18:01:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon, 17 Jun 2019 17:12:49 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Left shifting the signed int value 1 by 31 bits has undefined behaviour
> and the shift amount oq_no can be as much as 63.  Fix this by using
> BIT_ULL(oq_no) instead.
> 
> Addresses-Coverity: ("Bad shift operation")
> Fixes: f21fb3ed364b ("Add support of Cavium Liquidio ethernet adapters")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> 
> V2: Use BIT_ULL(oq_no) instead of 1ULL << oq_no. Thanks to Dan Carpenter for
>     noting this is more appropriate.

Applied.
