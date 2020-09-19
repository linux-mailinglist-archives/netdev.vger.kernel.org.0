Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E75227097E
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 02:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgISApr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 20:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgISApq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 20:45:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E08C0613CE;
        Fri, 18 Sep 2020 17:45:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9654E15B38A44;
        Fri, 18 Sep 2020 17:28:58 -0700 (PDT)
Date:   Fri, 18 Sep 2020 17:45:44 -0700 (PDT)
Message-Id: <20200918.174544.1980981472619221408.davem@davemloft.net>
To:     fazilyildiran@gmail.com
Cc:     david.lebrun@uclouvain.be, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul@pgazz.com, jeho@cs.utexas.edu
Subject: Re: [PATCH] net: ipv6: fix kconfig dependency warning for
 IPV6_SEG6_HMAC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917164642.158458-1-fazilyildiran@gmail.com>
References: <20200917164642.158458-1-fazilyildiran@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 17:28:58 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Date: Thu, 17 Sep 2020 19:46:43 +0300

> When IPV6_SEG6_HMAC is enabled and CRYPTO is disabled, it results in the
> following Kbuild warning:
> 
> WARNING: unmet direct dependencies detected for CRYPTO_HMAC
>   Depends on [n]: CRYPTO [=n]
>   Selected by [y]:
>   - IPV6_SEG6_HMAC [=y] && NET [=y] && INET [=y] && IPV6 [=y]
> 
> WARNING: unmet direct dependencies detected for CRYPTO_SHA1
>   Depends on [n]: CRYPTO [=n]
>   Selected by [y]:
>   - IPV6_SEG6_HMAC [=y] && NET [=y] && INET [=y] && IPV6 [=y]
> 
> WARNING: unmet direct dependencies detected for CRYPTO_SHA256
>   Depends on [n]: CRYPTO [=n]
>   Selected by [y]:
>   - IPV6_SEG6_HMAC [=y] && NET [=y] && INET [=y] && IPV6 [=y]
> 
> The reason is that IPV6_SEG6_HMAC selects CRYPTO_HMAC, CRYPTO_SHA1, and
> CRYPTO_SHA256 without depending on or selecting CRYPTO while those configs
> are subordinate to CRYPTO.
> 
> Honor the kconfig menu hierarchy to remove kconfig dependency warnings.
> 
> Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
> Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>

Applied and queued up for -stable, thank you.
