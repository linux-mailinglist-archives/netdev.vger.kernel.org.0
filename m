Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEA25852FB
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237686AbiG2PmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237990AbiG2Pl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:41:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC605A2C4;
        Fri, 29 Jul 2022 08:41:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 277C7B8281F;
        Fri, 29 Jul 2022 15:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADCFC433C1;
        Fri, 29 Jul 2022 15:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659109310;
        bh=PASUnmn4rilPWOO3UiyS19JTCCpdjFihFifQbCJSh8U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mD63BlSZTJsjWUKenvIThXrJZuFcWyRxFiD7r5dZRwlPr6ia7odnVNUJFj6jbQUfi
         ytSm9Siu+4yk2UxNAHea5+z5ue+P76OksTNkMOKZn4FCxrTJlwIAstpRNXi6DV6/gQ
         HArN/KpCi80uPGYWMYQqcNp5CYLCihwISZnLC+GKOGHLvwh14ORNFTaPmhUDssc2ba
         Se6p8An1gilwu9Cl14PAzabBB9fT7LS/Jzowxs07pNhGsixckNBlQU3iVTTniXA7zz
         jGr2xMyu+klLSZcBaiyU+FlvtxPOcUDNlkDuWxHLnC7V+65iUyvPr8scyzz0obiuVa
         jETws7yPE9h7g==
Date:   Fri, 29 Jul 2022 08:41:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net v1 1/1] net: dsa: microchip: KSZ9893: do not write
 to not supported Output Clock Control Register
Message-ID: <20220729084149.5a061772@kernel.org>
In-Reply-To: <20220729094840.GB10850@pengutronix.de>
References: <20220728131852.41518-1-o.rempel@pengutronix.de>
        <20220728222316.1d538cb3@kernel.org>
        <20220729094840.GB10850@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jul 2022 11:48:40 +0200 Oleksij Rempel wrote:
> On Thu, Jul 28, 2022 at 10:23:16PM -0700, Jakub Kicinski wrote:
> > On Thu, 28 Jul 2022 15:18:52 +0200 Oleksij Rempel wrote:  
> > > KSZ9893 compatible chips do not have "Output Clock Control Register 0x0103".
> > > So, avoid writing to it.  
> > 
> > Respin will be needed regardless of the answer to Andrew - patch does
> > not apply.  
> 
> Hm, this driver was hardly refactored in net-next. I'll better send it
> against net-next otherwise things will break.

Probably fine either way, with the net-next patch (i.e. this patch) 
on the list we shouldn't have problems resolving the conflict correctly.

The real question is whether it's okay for 5.19 to not have this patch.
It'd be good to have the user-visible impact specified in the commit
message.
