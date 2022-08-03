Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5394C5886A9
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 06:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbiHCExk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 00:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiHCExj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 00:53:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E497C5724D;
        Tue,  2 Aug 2022 21:53:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D87D6133A;
        Wed,  3 Aug 2022 04:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FA0C433C1;
        Wed,  3 Aug 2022 04:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659502417;
        bh=pskyjT0HE8/JyP8tScx1ovkaBZ5OqB5zcQFOG+lcyzE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tqUDV5uBp9C8gX6KSiTTmREjtFjuM7igk/P2d08C5uUczqceBcYr5rnxVHIZJipdr
         E+ovgtQqeoAm4G7f/+6/uB7mHDqhfe+NOPrNFKKVL6mQ1XCDwueXu8qTTibpoi47GS
         AxczqfRachAlgLpuH14GES78s063YxkeGyNfDP5wycoYepLqqKMaXU6C58zr2c3VX7
         KYUBww2+8I9O70B14PZpK9pQbSiFQz/yEAcpmBxImSC9DjQfqI8Ggdolzey1Ei4jaA
         POoE12zvPsK9I6OQS9PZ+itDPDcXLlvgDbNKnaGJzBAxlvWTZdgacUZQgMXAwuxGCI
         cNjboEQsFDiuA==
Date:   Tue, 2 Aug 2022 21:53:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH net] net: dsa: microchip: make learning configurable and
 keep it off while standalone
Message-ID: <20220802215336.6bc61114@kernel.org>
In-Reply-To: <20220802002636.3963025-1-vladimir.oltean@nxp.com>
References: <20220802002636.3963025-1-vladimir.oltean@nxp.com>
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

On Tue,  2 Aug 2022 03:26:36 +0300 Vladimir Oltean wrote:
> This is compile-tested only, but the equivalent change was tested by
> Brian on a 5.10 kernel and it worked.
> 
> I'm targeting just the "net" tree here (today 5.19 release candidates),
> but this needs to be fixed separately for net-next and essentially every
> other stable branch, since we will be lacking the port_bridge_flags
> callbacks, and there has been a lot of general refactoring in the
> microchip driver.
> 
> Jakub, I wonder if I should let you do the merge resolution between
> "net" and "net-next", or should I just resend against "net-next" and
> keep this patch as one of the stable backports?

I missed this question, sorry. Let's do the latter.
