Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1EC66E49E5
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjDQN17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjDQN15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:27:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9B949C0;
        Mon, 17 Apr 2023 06:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7wl0yTX6nvYR98OUpRUjebJlimUbs4Lfs/0q69iij0s=; b=CP49BUhMy6a3qf/0NauCE2tLfD
        5HrtCSMDuFMs7thItb4x5DwjyiGXWWAYC2/FZcpmUSplGB+lDxmxcwdhH3Hq5DnKiM6prfzD2AczV
        MwqX7cbm3tdSCz8HP26Bzyw9kRMYzMY4oj/uW6aYRFhktRG+2NieLvHZl2j9hzOtzZGw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1poOtY-00AVGu-48; Mon, 17 Apr 2023 15:27:48 +0200
Date:   Mon, 17 Apr 2023 15:27:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ladislav Michl <oss-lists@triops.cz>
Cc:     Dan Carpenter <error27@gmail.com>, linux-staging@lists.linux.dev,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH 2/3] staging: octeon: avoid needless device allocation
Message-ID: <f662be5e-7f3f-465d-b3ff-73a10ab8f26a@lunn.ch>
References: <ZDgNexVTEfyGo77d@lenoch>
 <ZDgOLHw1IkmWVU79@lenoch>
 <543bfbb6-af60-4b5d-abf8-0274ab0b713f@lunn.ch>
 <ZDgxPet9RIDC9Oz1@lenoch>
 <e2f5462d-5573-483c-9428-5f2b052cf939@lunn.ch>
 <26dd05e9-befa-4190-ac3c-bf31d58a5f1e@kili.mountain>
 <ZD0TPvDa7zopm0dx@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD0TPvDa7zopm0dx@lenoch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I'm proposing to leave all that trickery behind and just follow what's
> written in device tree, so each I/O interface ends up as a driver
> with its own mac ops. While it is possible to implement that as
> private mac ops as some other drivers do, I think it is more
> convenient to use phylink_mac_ops.
> 
> In case I'm missing something or I'm wrong with analysis, please let
> me know.

It is a reasonable solution, and does help clean up some of the mess
keeping it in staging.

But as Maintainers, we also have to consider, are you just going to
add the cleanup you need in order that phylink supports SFPs, which is
what you seem most interesting in. And then stop the cleanup. Despite
the code being in staging, it is good enough for you.

So converting to phylink, with the existing feature set, is fine.

Maybe adding SFP support is a new feature, and we might consider not
accepting such patches until the driver has made it out of staging?

	  Andrew
