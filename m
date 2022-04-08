Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D023F4F8C9D
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 05:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiDHC6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 22:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbiDHC6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 22:58:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8940A1D8A97;
        Thu,  7 Apr 2022 19:56:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 289E7CE2962;
        Fri,  8 Apr 2022 02:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF0BC385A4;
        Fri,  8 Apr 2022 02:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649386563;
        bh=1jWpv2ExUkDWhUjL3VwJv5HO0++He4WymWQa2PrjI4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BQ1HRJxZmAVJtXb4eB8lUiRx4uh2RseU3Izok1+OX2pGGMTHG3HpnZPgyqSUFEdGA
         QYD2idTFgeVbHj28IH+vsGDu1OQTM8krKLv6ATcA06roVIoj7JVxlTQMoIMf2iV7+c
         Tiv59aCmNj04RIUeukcqVPJY+1ilC8ZLfR70c3+c9OGxlIzeZRBUklQekPCNtS2bzP
         Ioxo3hJ7+HTux7hjCslZpYVCwdyKlAwPA+buBjGIRRiVQMNYEFBWx5gdpWXcPJo6EF
         mTBTwKOh4u3bpkY7CmJXT/ft1Ztyi8GRqRGr+dIEbs8AhOGjeayvVNqQMBSLJzV7kf
         V2y+J0YLfPnZw==
Date:   Thu, 7 Apr 2022 19:56:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: felix: suppress -EPROBE_DEFER errors
Message-ID: <20220407195602.47c993d4@kernel.org>
In-Reply-To: <c9e8d4940e6c4a3540d67ca3f13ca484@walle.cc>
References: <20220407130625.190078-1-michael@walle.cc>
        <20220407135613.rlblrckb2h633bps@skbuf>
        <cd433399998c2f58884f08b4fc0fd66a@walle.cc>
        <20220407141254.3kpg75l4byytwfye@skbuf>
        <c9e8d4940e6c4a3540d67ca3f13ca484@walle.cc>
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

On Thu, 07 Apr 2022 16:58:43 +0200 Michael Walle wrote:
> >> I'll limit it to just the one dev_err() and add a Fixes,
> >> there might be scripts out there who greps dmesg for errors.  
> > 
> > Ok.  
> 
> Hum, it's not that easy. The issue goes back all the way
> to the initial commit if I didn't miss anything (56051948773e).
> That one was first included in 5.5, but dev_err_probe() wasn't
> added until 5.9.
> 
> Thus will it work if I add Fixes: 56051948773e (..)?

Yes, backporters will figure it out. Matters even less since none 
of [5.5, 5.9] kernels are LTS.

But if you want to slap a Fixes tag on it, it has to go to net rather
than net-next.
