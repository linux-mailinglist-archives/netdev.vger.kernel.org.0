Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0430B225567
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgGTB1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgGTB1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 21:27:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E810C0619D2;
        Sun, 19 Jul 2020 18:27:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BDD691285097F;
        Sun, 19 Jul 2020 18:27:28 -0700 (PDT)
Date:   Sun, 19 Jul 2020 18:27:27 -0700 (PDT)
Message-Id: <20200719.182727.141244810520299886.davem@davemloft.net>
To:     hch@lst.de
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, kuba@kernel.org,
        David.Laight@ACULAB.COM, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: do a single memdup_user in sctp_setsockopt v2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
References: <20200719072228.112645-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jul 2020 18:27:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 09:21:37 +0200

> here is a resend of my series to lift the copy_from_user out of the
> individual sctp sockopt handlers into the main sctp_setsockopt
> routine.
> 
> Changes since v1:
>  - fixes a few sizeof calls.
>  - use memzero_explicit in sctp_setsockopt_auth_key instead of special
>    casing it for a kzfree in the caller
>  - remove some minor cleanups from sctp_setsockopt_autoclose to keep
>    it closer to the existing version
>  - add another little only vaguely related cleanup patch

This is all very mechanical and contained to the sockopt code of SCTP,
so I reviewed this a few times and applied it to net-next.

Thanks Christoph!
