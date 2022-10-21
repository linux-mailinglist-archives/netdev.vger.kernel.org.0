Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C555C606C66
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 02:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiJUALS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 20:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJUALR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 20:11:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3CC22D59F;
        Thu, 20 Oct 2022 17:11:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F97E61D3B;
        Fri, 21 Oct 2022 00:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB68C433C1;
        Fri, 21 Oct 2022 00:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666311073;
        bh=EDmrggTVBt4ZmieCGYNTkKBhUVVBHvuFF8t6Ohb5odY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hXy7QnVya8WFHGkF23bCrlzbszdMIq30gtS5sC/AzLAN0UyIikoDL+dGHWiX3sOJx
         52Tra3Fs2j1AtumjbHs5IZaj1DXx+8kqp+MZQaFa5KMfEMRHjrqXtzFmcG3St3vajw
         vn19PU1YUp6Z8HqgEtJjF4vExJm+FQJxfb5H2BNy5KAjVRyZ1IPZjxgspl3wecF+5W
         Lz3nMgwm+OBkBF1XVr3XerHIv6ORrYZBTUuWXQFWkKBf8+yJ418REFRkxWPkPh00Zc
         c0ekgpx1lIBlABhf9vH5VdHTkphiAxThbg/MHqo8+4NIpzHVSY1BDl8Ax/GpkOYPZV
         gU9WNCggZUhaw==
Date:   Thu, 20 Oct 2022 17:11:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
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
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 01/12] net: bridge: add locked entry fdb
 flag to extend locked port feature
Message-ID: <20221020171111.0cc66047@kernel.org>
In-Reply-To: <1c71e62ee5d6c0a7fc54d3e666aca619@kapio-technology.com>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
        <20221018165619.134535-2-netdev@kapio-technology.com>
        <Y1FE6WFnsH8hcFY2@shredder>
        <1c71e62ee5d6c0a7fc54d3e666aca619@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Oct 2022 21:37:17 +0200 netdev@kapio-technology.com wrote:
> Okay, since Jakub says that this patch set must be resent, the question 
> remains to me if I shall make these changes and resend the patch set
> as v8?

If I understand the question right - since you'd be making changes 
the new posting should be a v9. If you got only acks and no change
requests for this posting you could repost as "v8 RESEND", or also
as v9, when in doubt err on the side of bumping the version...
