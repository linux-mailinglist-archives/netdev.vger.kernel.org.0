Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9933427182A
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 23:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgITVQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 17:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgITVQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 17:16:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B023C061755;
        Sun, 20 Sep 2020 14:16:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E87313BCDB65;
        Sun, 20 Sep 2020 13:59:43 -0700 (PDT)
Date:   Sun, 20 Sep 2020 14:16:29 -0700 (PDT)
Message-Id: <20200920.141629.590298755126729557.davem@davemloft.net>
To:     hptasinski@google.com
Cc:     marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com,
        kuba@kernel.org, cminyard@mvista.com
Subject: Re: [PATCH v2] net: sctp: Fix IPv6 ancestor_size calc in
 sctp_copy_descendant
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200919001211.355148-1-hptasinski@google.com>
References: <20200918132957.GB82043@localhost.localdomain>
        <20200919001211.355148-1-hptasinski@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 20 Sep 2020 13:59:43 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Henry Ptasinski <hptasinski@google.com>
Date: Sat, 19 Sep 2020 00:12:11 +0000

> When calculating ancestor_size with IPv6 enabled, simply using
> sizeof(struct ipv6_pinfo) doesn't account for extra bytes needed for
> alignment in the struct sctp6_sock. On x86, there aren't any extra
> bytes, but on ARM the ipv6_pinfo structure is aligned on an 8-byte
> boundary so there were 4 pad bytes that were omitted from the
> ancestor_size calculation.  This would lead to corruption of the
> pd_lobby pointers, causing an oops when trying to free the sctp
> structure on socket close.
> 
> Fixes: 636d25d557d1 ("sctp: not copy sctp_sock pd_lobby in sctp_copy_descendant")
> Signed-off-by: Henry Ptasinski <hptasinski@google.com>

Applied and queued up for -stable, thank you.
