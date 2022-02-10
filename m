Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77364B0373
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiBJCg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:36:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiBJCg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:36:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92001237D8;
        Wed,  9 Feb 2022 18:36:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC503B8237D;
        Thu, 10 Feb 2022 02:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13ED9C340E7;
        Thu, 10 Feb 2022 02:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644460585;
        bh=bP1AetIUeykZM0C9T+LTSmrM0rMHwqKDK4UtSUG36mQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N9pUXKksn9FrliIkYoOBR+ievtONsYuwkC9IXa1SHRr9hv6rj9MQt0WGpfVAbP+oq
         qZKbpmwiiBz6opxil1U/Ofky8Ka2Lsg0LjIDkAAdUKPBK8FuEYbF8TLp7+8ElM/IB6
         Bz92dIL8Ar/kxuq6RK8s66QovL+urjEWF4bpeBse0LwEsS9Tp2Q31nuMJlMljyda2/
         IciHCk7aYCJ0M7PnmHmYUh61ruD3sbhJztgs5LzA9bnYiy0wYZTxRVHeB5bRtrQPip
         xLVRIr5Bq/bHEqvXQquBcXFANvv6wzOvANdoTDrV35tbbc8qn2hmISfbk5TumnOJmd
         ttzKjnLOPn5eA==
Date:   Wed, 9 Feb 2022 18:36:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mans Rullgard <mans@mansr.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Juergen Borleis <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: lan9303: fix reset on probe
Message-ID: <20220209183623.54369689@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220209145454.19749-1-mans@mansr.com>
References: <20220209145454.19749-1-mans@mansr.com>
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

On Wed,  9 Feb 2022 14:54:54 +0000 Mans Rullgard wrote:
> The reset input to the LAN9303 chip is active low, and devicetree
> gpio handles reflect this.  Therefore, the gpio should be requested
> with an initial state of high in order for the reset signal to be
> asserted.  Other uses of the gpio already use the correct polarity.
> 
> Signed-off-by: Mans Rullgard <mans@mansr.com>

Pending Andrew's review, this is the correct fixes tag, right?

Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
