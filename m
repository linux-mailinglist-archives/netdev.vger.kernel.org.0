Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC7330456
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfE3V5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:57:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60892 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfE3V5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:57:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 397CA14DB7E04;
        Thu, 30 May 2019 14:57:01 -0700 (PDT)
Date:   Thu, 30 May 2019 14:57:00 -0700 (PDT)
Message-Id: <20190530.145700.2173544714958397302.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        edumazet@google.com, alexei.starovoitov@gmail.com,
        david.beckett@netronome.com, dirk.vandermerwe@netronome.com
Subject: Re: [PATCH net] net: don't clear sock->sk early to avoid trouble
 in strparser
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529233323.26602-1-jakub.kicinski@netronome.com>
References: <20190529233323.26602-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 14:57:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 29 May 2019 16:33:23 -0700

> af_inet sets sock->sk to NULL which trips strparser over:
 ...
> To avoid this issue set sock->sk after sk_prot->close.
> My grepping and testing did not discover any code which
> would depend on the current behaviour.
> 
> Fixes: c46234ebb4d1 ("tls: RX path for ktls")
> Reported-by: David Beckett <david.beckett@netronome.com>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> ---
> We probably want to hold off on stable with this one :)

Ok, applied.  Will hold off on -stable :)

I only worry about sk visibility after whatever close does.
