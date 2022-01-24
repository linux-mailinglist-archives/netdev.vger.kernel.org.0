Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F08F49882E
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbiAXSVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241708AbiAXSUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:20:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34142C06173B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:20:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC23661480
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 18:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78A7C340E5;
        Mon, 24 Jan 2022 18:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643048453;
        bh=lNP2k296ogAUuF4dXHQk/NRFqLsBh0s4BG9FEti6qcw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DoDR3fyIu+LI9Jck4eex+5p3gFE/G9PdI+PUJYJPKbCzcex/DxndR05ZD1UiO2AQV
         XbcSeSvruVh6m6A+XWnu1GoYv5tvn1X6F/cTOgip7jmtsiVOpsGxkAox/di0064Dqr
         YglqpI0E592FeBMIY/J6iKHFk/7Gvu8ethSbwl9JuKdoWIyqN51mjMOt5+NlxogAAs
         ad2+0p6/iRBgMvMuH/l4gS7UlB3azOnKzzXBaQy5MET4qB7AQshPbSN+kTkqRRYtLQ
         uVq4s/gHEipGwPO68dUViJW1K64ymwnFXXVKPyDjEpvbhk24uVHeJMJIYNEWsCOuFd
         7vnVR7xahSS+Q==
Date:   Mon, 24 Jan 2022 10:20:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb:
 multiple cpu ports, non cpu extint
Message-ID: <20220124102051.7c40e015@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124093556.50fe39a3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220121020627.spli3diixw7uxurr@skbuf>
        <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
        <20220121185009.pfkh5kbejhj5o5cs@skbuf>
        <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
        <20220121224949.xb3ra3qohlvoldol@skbuf>
        <CAJq09z6aYKhjdXm_hpaKm1ZOXNopP5oD5MvwEmgRwwfZiR+7vg@mail.gmail.com>
        <20220124153147.agpxxune53crfawy@skbuf>
        <20220124084649.0918ba5c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220124165535.tksp4aayeaww7mbf@skbuf>
        <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
        <20220124172158.tkbfstpwg2zp5kaq@skbuf>
        <20220124093556.50fe39a3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 09:35:56 -0800 Jakub Kicinski wrote:
> Sorry I used "geometry" loosely.
> 
> What I meant is simply that if the driver uses NETIF_F_IP*_CSUM 
> it should parse the packet before it hands it off to the HW.
> 
> There is infinity of protocols users can come up with, while the device
> parser is very much finite, so it's only practical to check compliance
> with the HW parser in the driver. The reverse approach of adding
> per-protocol caps is a dead end IMO. And we should not bloat the stack
> when NETIF_F_HW_CSUM exists and the memo that parsing packets on Tx is
> bad b/c of protocol ossification went out a decade ago.

> It's not about DSA. The driver should not check
> 
> if (dsa())
> 	blah;
> 
> it should check 
> 
> if (!(eth [-> vlan] -> ip -> tcp/udp))
> 	csum_help();

Admittedly on a quick look thru the drivers which already do this 
I only see L3, L4 and GRE/UDP encap checks. Nothing validates L2.
