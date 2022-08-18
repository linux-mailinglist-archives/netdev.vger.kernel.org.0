Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B340C598FF1
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345934AbiHRWDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345873AbiHRWC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:02:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89029D21C9;
        Thu, 18 Aug 2022 15:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XhUCvUk0FjYJlbhwmGOWTu4qKoisWXmd1WdcglrWl3A=; b=5rdpkCkcekw9D/Yf0EuLx7VjYl
        G9FPLdcorL4RUkWdqGdtX/eq2Ykdd+6MEzfmCuYjXhPxpwirEnvMLdJYPp9qIqPM3IJS3nR+tPRzo
        zvtdc7gKpIUe+/sOd+YbgEWF92qxx8nRNOIrWbHGy3RSWZOYDbC/WCSWWJ14h1IeZyz0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOnbE-00DqiX-S0; Fri, 19 Aug 2022 00:02:48 +0200
Date:   Fri, 19 Aug 2022 00:02:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcus Carlberg <marcus.carlberg@axis.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@axis.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: support RGMII cmode
Message-ID: <Yv63CGDPnfe6baoz@lunn.ch>
References: <20220816114534.10407-1-marcus.carlberg@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816114534.10407-1-marcus.carlberg@axis.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 01:45:34PM +0200, Marcus Carlberg wrote:
> Since the probe defaults all interfaces to the highest speed possible
> (10GBASE-X in mv88e6393x) before the phy mode configuration from the
> devicetree is considered it is currently impossible to use port 0 in
> RGMII mode.
> 
> This change will allow RGMII modes to be configurable for port 0
> enabling port 0 to be configured as RGMII as well as serial depending
> on configuration.

Hi Marcus

Can ports 9 and 10 do RGMII? I think not. So you should validate the
phy-mode in mv88e6393x_port_set_cmode().

	 Andrew
