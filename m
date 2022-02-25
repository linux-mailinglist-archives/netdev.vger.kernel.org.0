Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C47B4C519F
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 23:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238397AbiBYWiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 17:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbiBYWiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 17:38:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6BF75225
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 14:37:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BBD5B82AC0
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 22:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A169C340E7;
        Fri, 25 Feb 2022 22:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645828650;
        bh=mooCU/XOg2DKjvVczJRtQMQ5x375iql2x/BkWM0XyD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MUvoNYslYZ0ldlnxex059m/1u89tD8PmuBEQiEhBm4DCcrpuHQLBQk2GOtT3LWyhz
         4e49fJYy0YCe2+t3dK1jQsfCmgBobBTMddgrWOVmf7k7asg/FUDm8wqEFZ/3kl31F7
         byJeR0v8nYifu5cibcjp+Jg/I/h0ATgW223eMZ4upQ4iZnDlA+UcVDViR/rQJVw/4k
         6QKN74t0e1R4BAnj42FVzqzkIlQKGWx/m6OfkatBSq8wh2Ljq8ogKTA3LazXagFsTf
         VnNBRYoAbYJun4MO+kGVy3GnJMhhRKOUlMRRr5iJZAXwxhCuUw4X6i4sFI0eXOT6L3
         +ILUql4h5eedQ==
Date:   Fri, 25 Feb 2022 14:37:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>, <roopa@nvidia.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <jiri@nvidia.com>, <razor@blackwall.org>,
        <dsahern@gmail.com>, <andrew@lunn.ch>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 06/14] net: dev: Add hardware stats support
Message-ID: <20220225143728.0e90e482@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <87wnhid7l8.fsf@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
        <20220224133335.599529-7-idosch@nvidia.com>
        <20220224222244.0dfadb8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8735k7fg53.fsf@nvidia.com>
        <20220225081212.4b1825f2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <874k4meuoj.fsf@nvidia.com>
        <20220225095645.547a79f0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <87wnhid7l8.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Feb 2022 21:01:53 +0100 Petr Machata wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > Yeah, if I'm counting right we're reusing like 38% of the fields, only.
> > We're better off with a new structure.  
> 
> OK.

Thanks, BTW I noticed that what Roopa has is very close (just missing
multicast):

https://lore.kernel.org/all/20220222025230.2119189-12-roopa@nvidia.com/

There are other structures (grep include/ for rx_bytes) already in tree
but none as close.

That's if you wanted to push for reuse (I presume you may prefer not
to), just an FYI..
