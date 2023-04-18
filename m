Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0E26E559B
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjDRAIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjDRAIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:08:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8735040EF;
        Mon, 17 Apr 2023 17:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FEdUc157Sz3I3x+pFwkIqG3LmyaJdiYFvCux+cUd77A=; b=IpXULwBQadAZY+XGAms0Ci/8Oa
        Wl4aCWzghCYP6o4XAG6R5pizk2y828NnegHqj+XPwaQju0mwlPPa4dHOtXS+y3SUviDPiJ5shs0Du
        7Md6LnDxilJiSuHWsJSKQCs0BKpwksEWg54QUXsXo+PwXsdmb9yrZ4nOJ6qDtESiYSTI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1poYtL-00AY7v-Iv; Tue, 18 Apr 2023 02:08:15 +0200
Date:   Tue, 18 Apr 2023 02:08:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shmuel Hazan <shmuel.h@siklu.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: mvpp2: tai: add refcount for ptp worker
Message-ID: <2315ea01-650b-4eb0-afc9-f3f9880c0736@lunn.ch>
References: <20230417160151.1617256-1-shmuel.h@siklu.com>
 <20230417160151.1617256-2-shmuel.h@siklu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417160151.1617256-2-shmuel.h@siklu.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 07:01:49PM +0300, Shmuel Hazan wrote:
> In some configurations, a single TAI can be responsible for multiple
> mvpp2 interfaces. However, the mvpp2 driver will call mvpp22_tai_stop
> and mvpp22_tai_start per interface RX timestamp disable/enable.
> 
> As a result, disabling timestamping for one interface would stop the
> worker and corrupt the other interface's RX timestamps.
> 
> This commit solves the issue by introducing a simpler ref count for each
> TAI instance.

This is version 2, so you should add that to the subject line.  You
should also indicate what changed since the previous version.

Please read https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

You have added Fixes: tags, so you think this is a fix for stable? You
then should indicate this on the Subject line.
 
> Fixes: ce3497e2072e ("net: mvpp2: ptp: add support for receive timestamping")
> Signed-off-by: Shmuel Hazan <shmuel.h@siklu.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
