Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28DF6553AB5
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 21:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354069AbiFUTkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 15:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348473AbiFUTkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 15:40:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C357F2DD6;
        Tue, 21 Jun 2022 12:40:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AB026177D;
        Tue, 21 Jun 2022 19:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E857C3411C;
        Tue, 21 Jun 2022 19:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655840399;
        bh=lQCSelBgy2HhBSoEiQ5gJm/Wcy4TE03fau90/EoLCvA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FXXefPothhatUuldvwUVoLHprYmMwkUurOsBmXlXdTh02OQN4y+5+g3b/9RfAR34P
         Dv62seaDiWd2AxL60b/r1c/cxbROrUvoC+U7ViaxiOOFirVN8LjinqDwKG5P/yPvOt
         Vb9BMFt/7sSDitshxK8UgWkGWQpk1pjXv3cQxYb4ILWcVBt3JkSOqPd2lNcOBIwE/T
         Y2hFLozxo/U3Hy5ysxKMsCb4MEWwY3ww3DX2iNGhJjD5jLbdVKvjX1kVFTJ6c3q5wc
         HF25JyYDznGWknbeynY9dOUplFy4xFuu5AP7NhzBQdukmqXi5aGdgrJopif4NcqrCA
         QLpBOZxoOxjUg==
Date:   Tue, 21 Jun 2022 12:39:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: qca8k: reduce mgmt ethernet
 timeout
Message-ID: <20220621123950.66110c97@kernel.org>
In-Reply-To: <20220621151633.11741-1-ansuelsmth@gmail.com>
References: <20220621151633.11741-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jun 2022 17:16:33 +0200 Christian Marangi wrote:
> The current mgmt ethernet timeout is set to 100ms. This value is too
> big and would slow down any mdio command in case the mgmt ethernet
> packet have some problems on the receiving part.
> Reduce it to just 5ms to handle case when some operation are done on the
> master port that would cause the mgmt ethernet to not work temporarily.
> 
> Fixes: 5950c7c0a68c ("net: dsa: qca8k: add support for mgmt read/write in Ethernet packet")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

If it's a fix it should go to net as well. But no need to repost,
we'll just apply it there since the fix is simple.
