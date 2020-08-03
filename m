Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9B523B033
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgHCWa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgHCWa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:30:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C521C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 15:30:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4138012773034;
        Mon,  3 Aug 2020 15:13:40 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:30:24 -0700 (PDT)
Message-Id: <20200803.153024.29144597725572653.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        tom@herbertland.com
Subject: Re: [PATCH net] net: gre: recompute gre csum for sctp over gre
 tunnels
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6722d2c4fe1b9b376a277b3f35cdf3eb3345874e.1596218124.git.lorenzo@kernel.org>
References: <6722d2c4fe1b9b376a277b3f35cdf3eb3345874e.1596218124.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:13:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Fri, 31 Jul 2020 20:12:05 +0200

> The GRE tunnel can be used to transport traffic that does not rely on a
> Internet checksum (e.g. SCTP). The issue can be triggered creating a GRE
> or GRETAP tunnel and transmitting SCTP traffic ontop of it where CRC
> offload has been disabled. In order to fix the issue we need to
> recompute the GRE csum in gre_gso_segment() not relying on the inner
> checksum.
> The issue is still present when we have the CRC offload enabled.
> In this case we need to disable the CRC offload if we require GRE
> checksum since otherwise skb_checksum() will report a wrong value.
> 
> Fixes: 4749c09c37030 ("gre: Call gso_make_checksum")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied with Fixes: tag corrected and queued up for -stable.

Thanks.
