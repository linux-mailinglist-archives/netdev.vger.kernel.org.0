Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A205A51B144
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358663AbiEDVpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358617AbiEDVp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:45:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142EC52B3D
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 14:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fXkZCp+J+lY4IwAsy0r70MQeGJ1hfoiYCNjOzNbtCWc=; b=NSKs0dMJszXMPIc8xZgSpTyOlr
        TOQsDrwr+SL5tEG99Il+EdqOlrOP6PeadLMsvwBzk2J1MuQABKPVfse+vYSGRkviHZ5SBuo15meq1
        IBr00yiRA4/h6fGqnnAReCFDo2LzLyXUczfZlp8V34sPhgKy56qzkJuT6DbFWc/TqVxo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmMkn-001GYO-VN; Wed, 04 May 2022 23:41:49 +0200
Date:   Wed, 4 May 2022 23:41:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     woojung.huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, ravi.hegde@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 1/2] net: phy: microchip: update LAN88xx phy
 ID and phy ID mask.
Message-ID: <YnLzHfeo6dyULtbs@lunn.ch>
References: <20220504152822.11890-1-yuiko.oshino@microchip.com>
 <20220504152822.11890-2-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504152822.11890-2-yuiko.oshino@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 08:28:21AM -0700, Yuiko Oshino wrote:
> update LAN88xx phy ID and phy ID mask because the existing code conflicts with the LAN8742 phy.
> 
> The current phy IDs on the available hardware.
>         LAN8742 0x0007C130, 0x0007C131
>         LAN88xx 0x0007C132
> 
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>

>  static struct phy_driver microchip_phy_driver[] = {
>  {
> -	.phy_id		= 0x0007c130,
> -	.phy_id_mask	= 0xfffffff0,
> +	.phy_id		= 0x0007c132,
> +	/* This mask (0xfffffff2) is to differentiate from
> +	 * LAN8742 (phy_id 0x0007c130 and 0x0007c131)
> +	 * and allows future phy_id revisions.
> +	 */
> +	.phy_id_mask	= 0xfffffff2,

It is odd, but you should be able to change your mind later if the
hardware engineers don't actually stick to this odd scheme.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
