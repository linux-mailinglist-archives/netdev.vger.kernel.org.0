Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C16E5F39DF
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 01:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiJCXe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 19:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJCXez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 19:34:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822DE1B9ED;
        Mon,  3 Oct 2022 16:34:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E0C661202;
        Mon,  3 Oct 2022 23:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA23C433C1;
        Mon,  3 Oct 2022 23:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664840092;
        bh=DM9gkSKKb8UHctPavkKh9d4DtvTG7D6IhOkgdAnQjmQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K1W5m0WdFXAF7UPCmXehc+jkBtL/EZf36Ki50wZM4Q8086Dzp65pruvZFVd1tuxn8
         v3Ld4VGnHcT0NiTGDNuceo1CuUY7wzNCygCTwBDZVd6luh/pVFYnKvSpFqgDhyasrz
         AY81lexkAC7+irLyAA/CPpqcnCs7GG/i7AS0avOONfVxYvjoJNqqpcCxWku8A+QESc
         frYTP8YQaEV3YnWZm+Nrkr3+9iZdnnTiVjSzeciG84QV3G/cFdBty4DtNu5HvHCDMm
         9XDfeOph0wFAYUfYfX0mkdboavR1pYbp/Kl5QysylWEiGidgNTFFXrQ5MHXqugdJ2X
         Zz2PaGWRd/QiA==
Date:   Mon, 3 Oct 2022 16:34:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <Daniel.Machon@microchip.com>
Cc:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <maxime.chevallier@bootlin.com>,
        <thomas.petazzoni@bootlin.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <Lars.Povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <joe@perches.com>, <linux@armlinux.org.uk>,
        <Horatiu.Vultur@microchip.com>, <Julia.Lawall@inria.fr>,
        <vladimir.oltean@nxp.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Message-ID: <20221003163450.7e6cbf3a@kernel.org>
In-Reply-To: <YztdsF6b6SM9E5rw@DEN-LT-70577>
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
        <20220929185207.2183473-2-daniel.machon@microchip.com>
        <87leq1uiyc.fsf@nvidia.com>
        <20220930175452.1937dadd@kernel.org>
        <87pmf9xrrd.fsf@nvidia.com>
        <20221003092522.6aaa6d55@kernel.org>
        <YztdsF6b6SM9E5rw@DEN-LT-70577>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Oct 2022 21:59:49 +0000 Daniel.Machon@microchip.com wrote:
> If lldpad was idd able to emit the new pcp app entries, they would be

idd?

> emitted as invalid TLV's (assuming 255 or 24 selector value), because the
> selector would be either zero or seven, which is currently not used for
> any selector by the std. We then have time to patch lldpad to do whatever
> with the new attr. Wouldn't this be acceptable?

I'm not sure I can provide sensible advice given I don't really know
how the information flow looks in case of DCB.

First off - we're talking about netlink TLVs not LLDP / DCB wire message
TLVs?

What I was saying is that if lldpad dumps the information from the
kernel and gets confused by certain TLVs - we can add an opt-in
attribute to whatever Netlink request lldpad uses, and only add the new
attrs if that opt-in attribute is present. Normal GET or DUMP requests
can both take input attributes.

Old lldpad will not send this attribute to the kernel - the kernel will
not respond with confusing attrs. The new lldpad can be patched to send
the attribute and will get all the attrs (if it actually cares).
