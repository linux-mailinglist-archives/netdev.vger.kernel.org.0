Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF32221FEB8
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 22:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgGNUiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 16:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgGNUiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 16:38:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993F0C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 13:38:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C08615E2420E;
        Tue, 14 Jul 2020 13:38:50 -0700 (PDT)
Date:   Tue, 14 Jul 2020 13:38:49 -0700 (PDT)
Message-Id: <20200714.133849.786362008823993310.davem@davemloft.net>
To:     borisp@mellanox.com
Cc:     kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        tariqt@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH] tls: add zerocopy device sendpage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e538c2bc-b8b5-c5d9-05a3-a385d2c809e4@mellanox.com>
References: <9d13245f-4c0d-c377-fecf-c8f8d9eace2a@mellanox.com>
        <20200713155906.097a6fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e538c2bc-b8b5-c5d9-05a3-a385d2c809e4@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 13:38:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>
Date: Tue, 14 Jul 2020 10:31:25 +0300

> At the time, Dave objected when we presented this on the netdev conference,
> and we didn't want to delay the entire series just to argue this point. It's
> all a matter of timing and priorities. Now we have an ASIC that uses this API,
> and I'd like to show the best possible outcome, and not the best possible given
> an arbitrary limitation that avoids an error where the user does something
> erroneous.

It's not arbitrary, and what the user is doing is not "erroneous".

Imagine a userspace fileserver using sendpage, other users in the system can
write to the files while the fileserver sends it off to a client.

And that's perfectly legitimate and fine.  We get the IP checksums
correct, everything works.

And, therefore, if TLS is used, the signatures should be correct too.

And I'm also happy to hear that from the very start I was against an
implementation that would knowingly send incorrect signatures.

I'm not moving on this point, sorry.  Correctness over performance.

