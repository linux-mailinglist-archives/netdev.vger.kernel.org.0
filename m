Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 900B65EDC1
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfGCUma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:42:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34584 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfGCUma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:42:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42EFE1448D92B;
        Wed,  3 Jul 2019 13:42:29 -0700 (PDT)
Date:   Wed, 03 Jul 2019 13:42:28 -0700 (PDT)
Message-Id: <20190703.134228.1805959660993963992.davem@davemloft.net>
To:     ast@domdv.de
Cc:     netdev@vger.kernel.org, sd@queasysnail.net
Subject: Re: [PATCH net-next 0/3 v2] macsec: a few cleanups in the receive
 path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7ec44dd08280f0b32dcf18aa35f687fc227c0197.camel@domdv.de>
References: <7ec44dd08280f0b32dcf18aa35f687fc227c0197.camel@domdv.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jul 2019 13:42:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andreas Steinmetz <ast@domdv.de>
Date: Tue, 02 Jul 2019 22:49:54 +0200

> This patchset removes some unnecessary code in the receive path of the
> macsec driver, and re-indents the error handling after calling
> macsec_decrypt to make the post-processing clearer.
> 
> This is a combined effort of Sabrina Dubroca <sd@queasysnail.net> and me.
> 
> Change in 3/3:
> 
> The patch now only moves the IS_ERR(skb) case under the block where
> macsec_decrypt() is called, but not the call to macsec_post_decrypt().
> 

I really don't like these changes, especially patches #1 and #2.

Like Willem I don't think you can blindly remove the share check like
this (and you ignored his feedback about this from v1 it seems), and
the removal is *pskb assignment to NULL is undoing defensive
programming.

I'm not applying this series.

