Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5AF5EFA5D
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbiI2QZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbiI2QZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:25:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886B511D0DE;
        Thu, 29 Sep 2022 09:22:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C41B61AC4;
        Thu, 29 Sep 2022 16:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A4FC433D6;
        Thu, 29 Sep 2022 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664468532;
        bh=d2xbFWd6cZFHqRqtchaW5YtreTtOFcfhK6VaJhknpbI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n0wLICpr9rwLDoO4I22Q+j9GYGdUKtx6O4WAI2LoMiZB3FDSAWURYHUfaUCVoy0FM
         qYyRxJgC0jSvph0Coo/utPsy68jMOH4DGqPFWjRqQEKttA/d/0ZrktDUcVfwwNuHYL
         7S0HoBNZHiImbcIfMeTZSAaIn1zhtANzQbzqt32J/JeYD3OMUq74UVbliF+CfVlu/p
         J0/ACe8PO1rnEPHBK1ESN38tRjPVVor7iVryP5kv1sA7xGmVWQ0mD3oN4aWaqOEzHm
         9PdQWpxoqQyzL/n52vrIBKCwHTD8pcJQesLiDsZ8geoyB2WeoZD2mTUT3adNUZloCX
         4w2/AXVJNLemw==
Date:   Thu, 29 Sep 2022 09:22:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 net-next 9/9] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
Message-ID: <20220929092210.0423e96d@kernel.org>
In-Reply-To: <6811b44516cf8bf37678bab23bca80ba@kapio-technology.com>
References: <20220928174904.117131-1-netdev@kapio-technology.com>
        <20220929091143.468546f2@kernel.org>
        <6811b44516cf8bf37678bab23bca80ba@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 18:17:40 +0200 netdev@kapio-technology.com wrote:
> > If you were trying to repost just the broken patches - that's not gonna
> > work :(  
> 
> Sorry, I do not understand what 'broken' patches you are referring to?
> 
> I think that the locked port tests should be working?

Ignore it then. v6 does not build, see my other reply.
