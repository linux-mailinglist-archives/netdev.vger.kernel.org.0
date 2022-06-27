Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3F655C8E9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbiF0QPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 12:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238953AbiF0QPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 12:15:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2357B186FD;
        Mon, 27 Jun 2022 09:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD1FBB818B7;
        Mon, 27 Jun 2022 16:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0921BC3411D;
        Mon, 27 Jun 2022 16:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656346530;
        bh=77bhyQ7wgLJipdogb8BkaEAoXkAjBX1Mm1kwZ2+DCB4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m5bijR76p8V/Ps5SnlCCrDtz0RB57qcJ8+77FH/bistoHixjGz5nYNeUCZGCmRxvl
         ah6SVM7o/+y1ChoLT6fqkvL8JpO41a7w70PkSB0bDk9ULSGpu6kTj1w5q+6dijpw2e
         nM0p3vAnkAFs6G54GqRCmdGu5BhJ8vR+LncQO/5I8/5agBvuSevEey/VUXJet9fIZa
         jBH444LHxBWO44Gla5EfvvRgmF6uPce6l32HZaDfwm5x5dwi8v3TatS4Gn045QI8Pq
         hxgSu5Uzi+5r5ltxP3PlcOTSsMgwXXHtaiHwjdEMuoe2WJtpe9Es6mZyjHo7qCGY3D
         Fi/r3tETyGp1w==
Date:   Mon, 27 Jun 2022 09:15:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/3] net: dsa: ar9331: add support for pause
 stats
Message-ID: <20220627091521.3b80a4e8@kernel.org>
In-Reply-To: <20220626171008.GA7581@pengutronix.de>
References: <20220624125902.4068436-1-o.rempel@pengutronix.de>
        <20220624125902.4068436-2-o.rempel@pengutronix.de>
        <20220624220317.ckhx6z7cmzegvoqi@skbuf>
        <20220626171008.GA7581@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jun 2022 19:10:08 +0200 Oleksij Rempel wrote:
> > Is there an authoritative source who is able to tell whether rtnl_link_stats64 ::
> > rx_packets and tx_packets should count PAUSE frames or not?  
> 
> Yes, it will be interesting to know how to proceed with it.

I'm curious as well, AFAIK most drivers do not count pause to ifc stats.

> For example KSZ switch do count pause frame Bytes together will other
> frames. At same time, atheros switch do not count pause frame bytes
> at all.
> 
> To make things worse, i can manually send pause frame of any size, so
> it will not be accounted by HW. What ever decision we will made, i
> will need to calculate typical pause frame size and hope it will fit
> for 90% of cases.

:(
